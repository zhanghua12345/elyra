import 'package:elyra/page/el_home/sub_page/popular/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/bean/short_video_bean.dart';

class PopularController extends GetxController {
  final state = PopularState();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onReady() {
    super.onReady();
    getHomeData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // 获取前3条数据，不足则重复
  List<ShortVideoBean> getTop3Items(List<ShortVideoBean> list) {
    if (list.isEmpty) return [];
    if (list.length >= 3) return list.sublist(0, 3);
    
    List<ShortVideoBean> result = [];
    int index = 0;
    while (result.length < 3) {
      result.add(list[index % list.length]);
      index++;
    }
    return result;
  }

  getHomeData({RefreshController? refreshCtrl}) async {
    state.loadStatus = LoadStatusType.loading;
    update();
    try {
      ApiResponse response = await HttpClient().request(
        Apis.homeData,
        method: HttpMethod.get,
      );
      
      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      } else {
        refreshController.refreshCompleted();
      }
      
      if (response.success) {
        state.bannerList.clear();
        state.popularWeekList.clear();
        state.trendingList.clear();
        state.collectionsList.clear();
        
        response.data['list'].forEach((item) {
          String moduleType = item['module_key'];
          switch (moduleType) {
            case 'home_banner':
              state.bannerList = [
                ...item['data']
                    .map((item) => ShortVideoBean.fromJson(item))
                    .toList(),
              ];
              break;
            case 'week_ranking':
              state.popularWeekList = [
                ...item['data']
                    .map((item) => ShortVideoBean.fromJson(item))
                    .toList(),
              ];
              break;
            case 'new_recommand':
              state.trendingList = [
                ...item['data']['list']
                    .map((item) => ShortVideoBean.fromJson(item))
                    .toList(),
              ];
              break;
            case 'highest_payment_hot_video':
              state.collectionsList = [
                ...item['data']
                    .map((item) => ShortVideoBean.fromJson(item))
                    .toList(),
              ];
              break;
            default:
              break;
          }
        });
        
        if (state.bannerList.isEmpty &&
            state.popularWeekList.isEmpty &&
            state.trendingList.isEmpty &&
            state.collectionsList.isEmpty) {
          state.loadStatus = LoadStatusType.loadNoData;
        } else {
          state.loadStatus = LoadStatusType.loadSuccess;
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
    }
  }

  // 下拉刷新
  void onRefresh() {
    getHomeData();
  }
}
