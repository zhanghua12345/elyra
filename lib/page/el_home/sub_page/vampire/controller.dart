import 'package:elyra/page/el_home/sub_page/new/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/bean/short_video_bean.dart';

class NewController extends GetxController {
  final state = NewState();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onReady() {
    super.onReady();
    getNewData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  getNewData({RefreshController? refreshCtrl}) async {
    state.loadStatus = LoadStatusType.loading;
    update();
    HttpClient().addHeader('lang-key', 'en');
    try {
      ApiResponse response = await HttpClient().request(
        Apis.rankingData,
        method: HttpMethod.post,
        queryParameters: {'type': 'new_releases'},
      );
      
      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      } else {
        refreshController.refreshCompleted();
      }
      
      if (response.success) {
        state.newList.clear();
        
        if (response.data['list'] != null && response.data['list'].length > 0) {
          state.newList = [
            ...response.data['list']
                .map((item) => ShortVideoBean.fromJson(item))
                .toList(),
          ];
          
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
      } else {
        refreshController.refreshFailed();
      }
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    }
  }

  void onRefresh() {
    getNewData();
  }
}
