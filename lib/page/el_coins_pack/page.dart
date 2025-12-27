import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_coins_pack/controller.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:elyra/widgets/week_coin_item.dart';
import 'package:elyra/bean/reward_overview_bean.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ElCoinsPackPage extends StatefulWidget {
  const ElCoinsPackPage({super.key});

  @override
  State<ElCoinsPackPage> createState() => _ElCoinsPackPageState();
}

class _ElCoinsPackPageState extends State<ElCoinsPackPage> {
  late final ElCoinsPackController controller;
  late final StorePageController storeController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ElCoinsPackController());

    // 初始化 Controller（只创建一次）
    storeController = Get.put(
      StorePageController()..isDialogInstance = true,
      tag: 'coins_pack',
    );

    storeController.loadData();
  }

  @override
  void dispose() {
    // 销毁时清理 Controller
    Get.delete<ElCoinsPackController>();
    Get.delete<StorePageController>(tag: 'coins_pack');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ElCoinsPackController>(
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('el_coin_pack_bg.png'.icon),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar('My Refills'),
                SizedBox(height: 6.h),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: controller.onRefresh,
                    header: const ClassicHeader(
                      height: 40,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(String title) {
    return Container(
      padding: EdgeInsets.only(left: 11.w, right: 11.w, top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.all(5.w), // 扩大点击热区
              child: Image.asset('ely_back.png'.icon, height: 20.h),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 30.w),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (controller.state.loadStatus == LoadStatusType.loading) {
      return Center(
        child: Image.asset('loading.gif'.icon, width: 80.w, height: 80.w),
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadFailed) {
      return ElNoDataWidget(
        imagePath: 'ely_error.png',
        title: 'No connection',
        description: 'Please check your network',
        buttonText: 'Try again',
        onButtonPressed: controller.onRefresh,
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadNoData) {
      return ElNoDataWidget(
        imagePath: 'ely_nodata.png',
        imageWidth: 180,
        imageHeight: 223,
        title: null,
        description: 'There is no data for the moment.',
        buttonText: null,
      );
    }

    return _buildContentArea();
  }

  Widget _buildContentArea() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          _buildSectionTitle('REWARDS OVERVIEW', 'left'),
          SizedBox(height: 24.h),
          _buildRewardsDisplay(),
          SizedBox(height: 24.h),
          _buildRefillCount(),
          SizedBox(height: 12.h),
          _buildClaimButtonOrPlaceholder(),
          SizedBox(height: 16.h),
          Center(
            child: CustomPaint(
              size: Size(319.w, 1.h),
              painter: DashedLinePainter(
                color: Colors.white.withValues(alpha: 0.25),
                axis: Axis.horizontal,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          _buildSectionTitle('Active Refills', 'center'),
          if (controller.state.receiveList.isNotEmpty) ...[
            SizedBox(height: 24.h),
            _buildReceiveList(),
          ],
          SizedBox(height: 20.h),
          _buildRefillList(),
          SizedBox(height: 32.h),
          _buildRulesSection(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String align) {
    return Row(
      mainAxisAlignment: align == 'center'
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: const BoxDecoration(
            color: Color(0xFFFFB7EB),
            shape: BoxShape.circle,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFFFFB7EB),
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          width: 6.w,
          height: 6.w,
          decoration: const BoxDecoration(
            color: Color(0xFFFFB7EB),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          _buildStatTile(
            'Weekly Total',
            controller.state.weeklyTotal.toString(),
          ),
          SizedBox(width: 18.w),
          CustomPaint(
            size: Size(1.w, 32.h),
            painter: DashedLinePainter(
              color: Colors.white.withOpacity(0.25),
              axis: Axis.vertical,
            ),
          ),
          SizedBox(width: 18.w),
          _buildStatTile(
            'Claimable Coins',
            controller.state.claimableCoins.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Image.asset('ely_gold.png'.icon, width: 18.w, height: 18.w),
            SizedBox(width: 4.w),
            Text(
              value,
              style: TextStyle(
                color: Color(0xFFFF0BBA),
                fontSize: 18.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRefillCount() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 12.w),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Active Refills: ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: '${controller.state.activeRefills}',
              style: TextStyle(
                color: Color(0xFFFFB7EB),
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimButtonOrPlaceholder() {
    final coinInfo = controller.state.coinInfo;
    if (coinInfo?.isExistSub == 1 && (coinInfo?.receiveCoins ?? 0) > 0) {
      return GestureDetector(
        onTap: () => controller.receiveDay('all'),
        child: Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE424AE), Color(0xFF6018E6)],
            ),
            borderRadius: BorderRadius.circular(24.w),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Claim All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Image.asset(
                  'ely_gold.png'.icon,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
              Text(
                '${coinInfo?.receiveCoins ?? 0}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF6D6D6D),
        borderRadius: BorderRadius.circular(24.w),
      ),
      alignment: Alignment.center,
      child: Text(
        'Get a Refill to Claim',
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 14.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildReceiveList() {
    return Column(
      children: controller.state.receiveList.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildReceiveItem(item),
        );
      }).toList(),
    );
  }

  Widget _buildReceiveItem(RewardReceiveItem item) {
    return Container(
      width: 343.w,
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF6018E6), Color(0xFFFF0BBA)],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFFDCE0), Color(0xFFFFD8F4)],
          ),
        ),
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 14.h,
          bottom: 14.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                /// 2000 渐变文字
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                    ).createShader(bounds);
                  },
                  child: Text(
                    '${item.title}',
                    style: TextStyle(
                      color: const Color(0xFFFF0BBA),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.57,
                    ),
                  ),
                ),
                Text(
                  '（Day ${item.dayText}）',
                  style: TextStyle(
                    color: Color(0xFFDF23B8),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.57,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            CustomPaint(
              size: Size(319.w, 1.h),
              painter: DashedLinePainter(
                color: const Color(0x3F0F0F0F),
                axis: Axis.horizontal,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Reward',
                          style: TextStyle(
                            color: const Color(0xFFDF23B8),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Image.asset(
                              'ely_gold.png'.icon,
                              width: 14.w,
                              height: 14.w,
                            ),
                            SizedBox(width: 4.w),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color(0xFFFF0BBA),
                                    Color(0xFF6018E6),
                                  ],
                                ).createShader(bounds);
                              },
                              child: Text(
                                '${item.weekMaxTotal ?? 0}',
                                style: TextStyle(
                                  color: const Color(0xFFFF0BBA),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 1.57,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    CustomPaint(
                      size: Size(1.w, 32.h),
                      painter: DashedLinePainter(
                        color: Colors.white.withValues(alpha: 0.25),
                        axis: Axis.vertical,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Remaining',
                          style: TextStyle(
                            color: const Color(0xFFDF23B8),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Image.asset(
                              'ely_gold.png'.icon,
                              width: 14.w,
                              height: 14.w,
                            ),
                            SizedBox(width: 4.w),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color(0xFFFF0BBA),
                                    Color(0xFF6018E6),
                                  ],
                                ).createShader(bounds);
                              },
                              child: Text(
                                '${item.weekRemainingTotal ?? 0}',
                                style: TextStyle(
                                  color: const Color(0xFFFF0BBA),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 1.57,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => controller.receiveDay(item.id!),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 48.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-1, .5),
                          end: Alignment(0, .5),
                          colors: [
                            const Color(0xFFFF0BBA),
                            const Color(0xFF6018E6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Claim',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.29,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'ely_gold.png'.icon,
                                width: 14.w,
                                height: 14.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${item.receiveCoins}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.90),
                                  fontSize: 12.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefillList() {
    // 纵向列表
    return GetBuilder<StorePageController>(
      tag: 'coins_pack',
      builder: (storeCtrl) {
        if (storeCtrl.state.coinsWeekList.isEmpty) {
          return const SizedBox(
            height: 84,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: storeCtrl.state.coinsWeekList.length,
          itemBuilder: (context, index) {
            final item = storeCtrl.state.coinsWeekList[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: WeekCoinItem(
                item: item,
                controller: storeCtrl,
                width: 343,
                isOldPrice: true,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription Rules',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '1. Up to 2 subscriptions can be active at once.\n'
          '2. Coins are delivered instantly upon purchase.\n'
          '3. Daily bonus coins available from the next day.\n'
          '4. All coins will be revoked when the subscription expires, including both initial and daily coins.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final Axis axis;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    required this.color,
    required this.axis,
    this.dashWidth = 4,
    this.dashSpace = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = (axis == Axis.horizontal ? size.height : size.width)
      ..style = PaintingStyle.stroke;

    if (axis == Axis.horizontal) {
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
