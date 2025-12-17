import 'package:elyra/page/el_home/sub_page/ranking/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/bean/short_video_bean.dart';

class RankingController extends GetxController {
  final state = RankingState();

  @override
  void onReady() {
    super.onReady();
    getRankingData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getRankingData({RefreshController? refreshCtrl}) async {
    state.loadStatus = LoadStatusType.loading;
    update();
    try {
      ApiResponse response = await HttpClient().request(
        Apis.rankingData,
        method: HttpMethod.post,
        queryParameters: {'type': 'most_trending'},
      );

      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      }
      
      if (response.success) {
        state.rankingList.clear();
        
        if (response.data['list'] != null && response.data['list'].length > 0) {
          List<ShortVideoBean> tempList = [
            ...response.data['list']
                .map((item) => ShortVideoBean.fromJson(item))
                .toList(),
          ];
          
          if (tempList.length >= 2) {
            state.rankingList = [...tempList];
            final temp = state.rankingList[0];
            state.rankingList[0] = state.rankingList[1];
            state.rankingList[1] = temp;
          } else {
            state.rankingList = tempList;
          }
          
          state.loadStatus = LoadStatusType.loadSuccess;
        } else {
          state.loadStatus = LoadStatusType.loadNoData;
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

  void onRefresh() {
    getRankingData();
  }
}
