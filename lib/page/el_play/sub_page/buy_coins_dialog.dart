import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/bean/user_info.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/page.dart' as store_page;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 购买金币弹框
class BuyCoinsDialog extends StatefulWidget {
  final UserInfo? userInfo; // 用户信息
  final EpisodeList? currentEpisode; // 用户信息
  final VoidCallback? onPurchaseSuccess; // 购买成功回调

  const BuyCoinsDialog({
    super.key,
    this.userInfo,
    this.currentEpisode,
    this.onPurchaseSuccess,
  });

  @override
  State<BuyCoinsDialog> createState() => _BuyCoinsDialogState();
}

class _BuyCoinsDialogState extends State<BuyCoinsDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Set background color to transparent

      body: Container(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.60)),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                // 直接嵌入StorePage的内容
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'ely_lock_max.png'.icon,
                      width: 24.w,
                      height: 24.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Unlock Episode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 头部
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          // 第一行：返回按钮、Ep.x、关闭按钮
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              
              
            ],
          ),
          SizedBox(height: 16.h),
          // 第二行：Price和Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Price: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Image.asset(
                        'ely_gold.png'.icon,
                        width: 16.w,
                        height: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${widget.userInfo?.coinLeftTotal ?? 0}',
                        style: TextStyle(
                          color: Color(0xFFFFD67C),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24.w),
                  // Balance
                  Row(
                    children: [
                      Text(
                        'Balance: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Image.asset(
                        'ely_gold.png'.icon,
                        width: 16.w,
                        height: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${widget.userInfo?.sendCoinLeftTotal ?? 0}',
                        style: TextStyle(
                          color: Color(0xFFFFD67C),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Price
              GestureDetector(
                onTap: () => Get.back(),
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Image.asset('ely_close.png'.icon, height: 20.h),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
