import 'package:elyra/page/el_collect/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/toast.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/bean/short_video_bean.dart';

class CollectController extends GetxController {
  final state = CollectState();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getVampireData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  getVampireData({RefreshController? refreshCtrl, bool loadMore = false}) async {
    // 如果正在加载，或者加载更多时没有更多数据，则直接返回
    if (state.isLoading || (loadMore && !state.hasMore)) return;
    
    // 更新状态
    if (!loadMore) {
      state.loadStatus = LoadStatusType.loading;
    }
    state.isLoading = true;
    update();

    try {
      // 构造请求参数
      Map<String, dynamic> params = {
        'current_page': loadMore ? state.currentPage + 1 : 1,
        'page_size': state.pageSize,
      };

      ApiResponse response = await HttpClient().request(
        Apis.myCollections,  // 使用收藏列表接口
        method: HttpMethod.get,
        queryParameters: params,
      );
      
      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      } else {
        refreshController.refreshCompleted();
      }
      
      if (response.success) {
        // 解析分页信息
        var pagination = response.data['pagination'];
        state.currentPage = pagination['current_page'] ?? 1;
        state.totalPages = pagination['page_total'] ?? 0;
        state.hasMore = state.currentPage < state.totalPages;
        
        if (loadMore) {
          // 加载更多数据
          if (response.data['list'] != null && response.data['list'].length > 0) {
            try {
              List<ShortVideoBean> newItems = response.data['list']
                  .map<ShortVideoBean>((item) => ShortVideoBean.fromJson(item))
                  .toList();
              state.collectList.addAll(newItems);
            } catch (e) {
              print('Error mapping new items: $e');
              // 如果解析失败，我们仍然更新状态以停止加载
              state.loadStatus = LoadStatusType.loadFailed;
            }
          }
        } else {
          // 刷新数据
          state.collectList.clear();
          
          if (response.data['list'] != null && response.data['list'].length > 0) {
            try {
              List<ShortVideoBean> newItems = response.data['list']
                  .map<ShortVideoBean>((item) => ShortVideoBean.fromJson(item))
                  .toList();
              state.collectList = newItems;
              
              state.loadStatus = LoadStatusType.loadSuccess;
            } catch (e) {
              print('Error mapping items: $e');
              state.loadStatus = LoadStatusType.loadFailed;
            }
          } else {
            state.loadStatus = LoadStatusType.loadNoData;
          }
        }
        update();
      } else {
        state.loadStatus = LoadStatusType.loadFailed;
        update();
      }
    } catch (e) {
      if (refreshCtrl != null) {
        refreshCtrl.refreshFailed();
      } else {
        refreshController.refreshFailed();
      }
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    } finally {
      state.isLoading = false;
      if (refreshCtrl == null) {
        refreshController.loadComplete(); // 停止加载更多动画
      }
    }
  }

  void onRefresh() {

    getVampireData();
  }
  
  void onLoadMore() {
    if (state.hasMore) {
      getVampireData(loadMore: true);
    } else {
      refreshController.loadNoData(); // 没有更多数据
    }
  }

  /// 取消收藏
  Future<bool> cancelCollect(shortPlayId) async {
    try {
      ApiResponse response = await HttpClient().request(
        Apis.cancelCollect,
        method: HttpMethod.post,
        data: {
          'short_play_id': shortPlayId,
        },
      );

      if (response.success) {
        Message.show(response.data); 
        return true;
      } else {
       Message.show(response.data); 
        return false;
      }
    } catch (e) {
      Message.show('取消收藏异常: $e'); 
      return false;
    }
  }
}