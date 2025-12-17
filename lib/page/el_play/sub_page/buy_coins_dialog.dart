import 'package:elyra/bean/user_info.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/page.dart' as store_page;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 购买金币弹框
class BuyCoinsDialog extends StatefulWidget {
  final int episode; // 当前集数
  final UserInfo? userInfo; // 用户信息
  final VoidCallback? onPurchaseSuccess; // 购买成功回调

  const BuyCoinsDialog({
    super.key,
    required this.episode,
    this.userInfo,
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('ely_background_image.png'.icon),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                // 直接嵌入StorePage的内容
                child: store_page.StorePage(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Image.asset('ely_back.png'.icon, height: 20.h),
                ),
              ),
              Text(
                'Ep.${widget.episode}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Image.asset('ely_close.png'.icon, height: 20.h),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // 第二行：Price和Balance
          Row(
            children: [
              // Price
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
        ],
      ),
    );
  }
}
