import 'package:elyra/extend/el_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElNoDataWidget extends StatelessWidget {
  final String? imagePath;
  final double imageWidth;
  final double imageHeight;
  final String? title;
  final String? description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const ElNoDataWidget({
    super.key,
    this.imagePath = 'ely_error.png',
    this.imageWidth = 173,
    this.imageHeight = 167,
    this.title = 'No connection',
    this.description = 'Please check your network',
    this.buttonText = 'Try again',
    this.onButtonPressed,
  });

  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;
  bool get hasTitle => title != null && title!.isNotEmpty;
  bool get hasDesc => description != null && description!.isNotEmpty;
  bool get hasButton => buttonText != null && buttonText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图片
          if (hasImage) ...[
            SizedBox(height: 30.h),
            Image.asset(
              imagePath!.icon,
              width: imageWidth.w,
              height: imageHeight.h,
              errorBuilder: (context, error, stackTrace) =>
                  SizedBox(width: imageWidth.w, height: imageHeight.h),
            ),
            SizedBox(height: 10.h),
          ],

          // 标题
          if (hasTitle)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

          // 描述
          if (hasDesc) ...[
            if (hasTitle) SizedBox(height: 2.h),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: !hasTitle ? Colors.white : Color(0xFFE5E5E5),
                fontSize: 14.sp,
              ),
            ),
          ],

          // 按钮
          if (hasButton) ...[
            SizedBox(height: 20.h),
            OutlinedButton(
              onPressed: onButtonPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 1, color: Colors.white),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                minimumSize: Size(0, 34.h),
              ),
              child: Text(
                buttonText!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
