import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_utils.dart';

const versionStoreKey = "ely_version_dialog_time";

class versionUtils {
  static final versionUtils instance = versionUtils._();
  versionUtils._();

  int controlTime = 24 * 60 * 60; //24 * 60 * 60;

  void setVersionTime(int time) {
    SpUtils().setObject(versionStoreKey, time);
  }

  bool getVersionStatus() {
    bool status = false;
    int storeTime = SpUtils().getInt(versionStoreKey) ?? 0;
    int currentSecond = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (currentSecond - storeTime > controlTime) {
      // if (currentSecond - storeTime > 1) {
      status = true;
      setVersionTime(currentSecond);
    }
    return status;
  }

  int compareVersion(String v1, String v2) {
    final a = v1.split('.').map(int.parse).toList();
    final b = v2.split('.').map(int.parse).toList();
    final len = a.length > b.length ? a.length : b.length;
    for (int i = 0; i < len; i++) {
      final x = i < a.length ? a[i] : 0;
      final y = i < b.length ? b[i] : 0;
      if (x != y) return x.compareTo(y);
    }
    return 0;
  }

  Future<Map<String, dynamic>> checkAppVersion() async {
    Map<String, dynamic> version = {'status': false};
    final res = await HttpClient().request(
      Apis.versionControl,
      method: HttpMethod.get,
    );

    final data = res.data as Map?;
    String getVersionName = data?['version_name'] ?? '';
    final String versionDescOrigin = data?['description'] ?? '';
    String getVersionDesc = versionDescOrigin.replaceAll(r'\n', '\n');
    final bool force = data?['force'] ?? false;
    final currentVersionName = DeviceInfoUtils().appVersion ?? '1.0.0';
    if (getVersionName.isNotEmpty && currentVersionName.isNotEmpty) {
      final versionUpdate = compareVersion(getVersionName, currentVersionName);
      if (versionUpdate == 1) {
        version['status'] = true;
        version['name'] = getVersionName;
        version['description'] = getVersionDesc;
        version['force'] = force;
      }
    }
    return version;
  }
}
