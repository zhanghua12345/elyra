import 'package:elyra/page/el_home/sub_page/genres/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GenresController extends GetxController {
  final state = GenresState();

  @override
  void onReady() {
    super.onReady();
    getCategoryData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getCategoryData({RefreshController? refreshCtrl}) async {
    state.loadStatus = LoadStatusType.loading;
    update();
    try {
      ApiResponse response = await HttpClient().request(
        Apis.categoryListAppendShortPlay,
        method: HttpMethod.get,
        queryParameters: {'short_play_num': 3},
      );

      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      }
      
      if (response.success) {
        state.categoryList.clear();
        
        if (response.data['list'] != null && response.data['list'].length > 0) {
          state.categoryList = [
            ...response.data['list']
                .map((item) => CategoryItem.fromJson(item))
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
      }
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    }
  }

  void onRefresh() {
    getCategoryData();
  }
}
