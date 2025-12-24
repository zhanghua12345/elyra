import 'package:elyra/page/el_home/sub_page/popular/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/bean/short_video_bean.dart';

class PopularController extends GetxController {
  final state = PopularState();

  @override
  void onReady() {
    super.onReady();
    getHomeData();
  }

  @override
  void onClose() {
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
      }

      if (response.success && response.data is Map && response.data['list'] is List) {
        state.bannerList.clear();
        state.popularWeekList.clear();
        state.trendingList.clear();
        state.collectionsList.clear();

        final List list = response.data['list'];
        for (var item in list) {
          if (item is! Map) continue;
          String? moduleType = item['module_key'];
          dynamic moduleData = item['data'];
          if (moduleData == null) continue;

          switch (moduleType) {
            case 'home_banner':
              if (moduleData is List) {
                state.bannerList = moduleData
                    .map((i) => ShortVideoBean.fromJson(i))
                    .toList();
              }
              break;
            case 'week_ranking':
              if (moduleData is List) {
                state.popularWeekList = moduleData
                    .map((i) => ShortVideoBean.fromJson(i))
                    .toList();
              }
              break;
            case 'new_recommand':
              if (moduleData is Map && moduleData['list'] is List) {
                state.trendingList = (moduleData['list'] as List)
                    .map((i) => ShortVideoBean.fromJson(i))
                    .toList();
              }
              break;
            case 'highest_payment_hot_video':
              if (moduleData is List) {
                state.collectionsList = moduleData
                    .map((i) => ShortVideoBean.fromJson(i))
                    .toList();
              }
              break;
            default:
              break;
          }
        }

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
