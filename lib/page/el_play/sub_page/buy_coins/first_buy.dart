// 第一次购买充值
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/widgets/week_coin_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FirstBuyPopup extends StatefulWidget {
  const FirstBuyPopup({super.key});

  /// 显示弹窗
  static void show() {
    Get.bottomSheet(
      const FirstBuyPopup(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 顶部标题区域
        Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 左侧圆点
              Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF0BBA),
                ),
              ),
              SizedBox(width: 6.w),
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                  ).createShader(bounds);
                },
                child: Text(
                  'WEEKLY REFILL',
                  style: TextStyle(
                    color: const Color(0xFFFF0BBA),
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    height: 0.75,
                  ),
                ),
              ),
              SizedBox(width: 6.w),

              /// 右侧圆点
              Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF0BBA),
                ),
              ),
            ],
          ),
        ),

        // 横向滚动列表
        GetBuilder<StorePageController>(
          tag: 'first_buy_dialog',
          builder: (controller) {
            if (controller.state.coinsWeekList.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return SizedBox(
              height: 84,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.state.coinsWeekList.length,
                itemBuilder: (context, index) {
                  final item = controller.state.coinsWeekList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < controller.state.coinsWeekList.length - 1
                          ? 12.w
                          : 0,
                    ),
                    child: WeekCoinItem(
                      item: item,
                      controller: controller,
                      width: 320,
                    ),
                  );
                },
              ),
            );
          },
        ),

        SizedBox(height: 12.h),

        // 底部带背景的模块
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('store_popup_bg.png'.icon),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 40.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 第一行：Balance 和关闭按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Balance: 50',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset(
                        'store_popup_close.png'.icon,
                        width: 24.w,
                        height: 24.w,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // 分割线
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: 0.10),
                ),

                SizedBox(height: 16.h),

                // Episode Locked 标题
                SizedBox(
                  width: 343.w,
                  child: Text(
                    'Episode Locked',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFFFB6EA),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      height: 1.50,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // Price to unlock this episode
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Price to unlock this episode: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Image.asset(
                      'store_gold.png'.icon,
                      width: 16.w,
                      height: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '500',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Unlock Now 按钮
                Container(
                  width: 286.w,
                  height: 48.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF999999),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Unlock Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.29,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
