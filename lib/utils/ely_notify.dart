import 'package:elyra/utils/el_utils.dart';

const notifySettingManageStoreKey = "SanpPlay_Notify";

class ElyNotifyUtils {
  static final ElyNotifyUtils instance = ElyNotifyUtils._();
  ElyNotifyUtils._();

  String keyOfPermission = "permission_dialog_time";

  int controlTime = 24 * 60 * 60; //24 * 60 * 60;

  /// 获取是否可弹出 - 通知权限弹窗
  bool getPermissionStatus() {
    bool status = false;
    int storeTime =
        SpUtils().getInt("${notifySettingManageStoreKey}_$keyOfPermission") ??
        0;
    int currentSecond = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (currentSecond - storeTime > controlTime) {
      status = true;
      setPermissionTime(currentSecond);
    }
    return status;
  }

  void setPermissionTime(int time) {
    SpUtils().setObject(
      "${notifySettingManageStoreKey}_$keyOfPermission",
      time,
    );
  }
}
