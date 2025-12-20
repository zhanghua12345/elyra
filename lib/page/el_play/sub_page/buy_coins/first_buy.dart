// 第一次购买充值
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FirstBuyPopup extends StatefulWidget {
  const FirstBuyPopup({super.key});

  /// 显示弹窗
  static void show() {
    Get.dialog(
      const FirstBuyPopup(),
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 300),

      barrierDismissible: true,
    );
  }

  @override
  State<FirstBuyPopup> createState() => _FirstBuyPopupState();
}

class _FirstBuyPopupState extends State<FirstBuyPopup> {
  late final StorePageController storeController;

  @override
  void initState() {
    super.initState();

    // 初始化 Controller（只创建一次）
    storeController = Get.put(
      StorePageController()..isDialogInstance = true,
      tag: 'first_buy_dialog',
    );

    storeController.loadData();
  }

  @override
  void dispose() {
    // 弹窗销毁时清理 Controller
    Get.delete<StorePageController>(tag: 'first_buy_dialog');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 弹窗主体
            Container(
              width: 375.w,
              height: 543.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage('popup_recharge_vip_bg.png'.icon),
                  fit: BoxFit.fill,
                ),
              ),
              child: GetBuilder<StorePageController>(
                tag: 'first_buy_dialog',
                builder: (controller) {
                  if (controller.state.subList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: 247.h),
                    child: Column(
                      
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),

            /// 关闭按钮（InkWell 更规范）
            InkWell(
              onTap: () => Get.back(),
              child: Image.asset(
                'popup_recharge_vip_close.png'.icon,
                width: 28.w,
                height: 28.w,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}


// 🔥 使用方式，模拟按钮：点击显示充值金币包弹窗
// GestureDetector(
//   behavior: HitTestBehavior.translucent,
//   onTap: () {
//     // 模拟 PayItem 数据
//     
// FirstBuyPopup.show();
//   },
//   child: Padding(
//     padding: EdgeInsets.all(5.w),
//     child: Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 8.w,
//         vertical: 4.h,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.orange,
//         borderRadius: BorderRadius.circular(4.r),
//       ),
//       child: Text(
//         'Test',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   ),
// ),