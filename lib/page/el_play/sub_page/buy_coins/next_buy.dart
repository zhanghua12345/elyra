// 第一次购买充值
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/page/el_store/sub_page/store_coin_item.dart';
import 'package:elyra/widgets/week_coin_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NextBuyPopup extends StatefulWidget {
  const NextBuyPopup({super.key});

  /// 显示弹窗
  static void show() {
    Get.bottomSheet(
      const NextBuyPopup(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  @override
  State<NextBuyPopup> createState() => _NextBuyPopupState();
}

class _NextBuyPopupState extends State<NextBuyPopup> {
  late final StorePageController storeController;

  @override
  void initState() {
    super.initState();

    // 初始化 Controller（只创建一次）
    storeController = Get.put(
      StorePageController()..isDialogInstance = true,
      tag: 'next_buy_dialog',
    );

    storeController.loadData();
  }

  @override
  void dispose() {
    // 弹窗销毁时清理 Controller
    Get.delete<StorePageController>(tag: 'next_buy_dialog');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 顶部标题区域
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    begin: Alignment(-1, .5),
                    end: Alignment(0, .5),
                    colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                  ).createShader(bounds);
                },
                child: Text(
                  'WEEKLY REFILL',
                  style: TextStyle(
                    color: const Color(0xFFFF0BBA),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    height: 1.29,
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
          tag: 'next_buy_dialog',
          builder: (controller) {
            if (controller.state.coinsWeekList.isEmpty) {
              return const SizedBox(
                height: 84,
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Balance:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0.86,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Image.asset(
                            'store_gold.png'.icon,
                            width: 12.w,
                            height: 12.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '500',
                            style: TextStyle(
                              color: const Color(0xFFFFB6EA),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0.86,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Image.asset(
                        'store_popup_close.png'.icon,
                        width: 24.w,
                        height: 24.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // 分割线
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: 0.10),
                ),

                SizedBox(height: 12.h),
                SizedBox(
                  width: 343.w,
                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF0BBA),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Episode Locked',
                        style: TextStyle(
                          color: const Color(0xFFFFB6EA),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          height: 1.29,
                        ),
                      ),
                      SizedBox(width: 6.w),
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

                SizedBox(height: 6.h),
                GetBuilder<StorePageController>(
                  tag: 'next_buy_dialog',
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Big Coins
                        if (controller.state.coinsBigList.isNotEmpty)
                          _StoreBigCoins(controller: controller),
                        // Small Coins
                        if (controller.state.coinsSmallList.isNotEmpty)
                          _StoreSmallCoins(controller: controller),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 大金币组件
class _StoreBigCoins extends StatelessWidget {
  final StorePageController controller;

  const _StoreBigCoins({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Wrap(
          spacing: 15.w,
          runSpacing: 15.h,
          alignment: WrapAlignment.start,
          children: controller.state.coinsBigList.map((item) {
            return StoreCoinItem(
              controller: controller,
              item: item,
              isBig: true,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 小金币组件
class _StoreSmallCoins extends StatelessWidget {
  final StorePageController controller;

  const _StoreSmallCoins({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 15.h,
          alignment: WrapAlignment.start,
          children: controller.state.coinsSmallList.map((item) {
            return StoreCoinItem(
              controller: controller,
              item: item,
              isBig: false,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 周包金币组件
class _StoreWeekCoins extends StatelessWidget {
  final StorePageController controller;

  const _StoreWeekCoins({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Wrap(
          runSpacing: 8.h,
          alignment: WrapAlignment.start,
          children: controller.state.coinsWeekList.map((item) {
            return WeekCoinItem(
              item: item,
              controller: controller,
              width: double.infinity,
            );
          }).toList(),
        ),
      ],
    );
  }
}
