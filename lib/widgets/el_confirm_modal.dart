import 'package:elyra/extend/el_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElConfirmModal extends StatelessWidget {
  final ImageProvider image;

  /// Title
  final String title;

  /// Description slot (可传可不传)
  final Widget? child;

  /// Buttons text
  final String? cancelText;
  final String? confirmText;

  /// Callbacks
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  /// 是否显示右下角关闭按钮
  final bool isCloseIcon;

  /// layout configs
  final double imageOffset;
  final double imageWidth;
  final double moduleWidth;
  final double moduleHeight;
  final double titleOffset;

  const ElConfirmModal({
    super.key,
    required this.image,
    required this.title,
    this.child,
    this.cancelText,
    this.confirmText,
    this.onCancel,
    this.onConfirm,
    this.isCloseIcon = true,
    this.imageOffset = 65,
    this.imageWidth = 233,
    this.moduleWidth = 304,
    this.moduleHeight = 328,
    this.titleOffset = 185,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          /// 中心布局
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: imageOffset.h),

                /// 主模块 + 悬浮图片
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    /// 模块背景
                    Container(
                      width: moduleWidth.w,
                      height: moduleHeight.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF404040),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: titleOffset.h),

                          /// TITLE
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              height: 1,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.01,
                            ),
                          ),

                          /// slot 内容区
                          if (child != null) ...[
                            SizedBox(height: 12.h),
                            child!,
                          ],

                          SizedBox(height: 20.h),

                          /// 按钮区（1 个或 2 个）
                          _buildButtons(),
                        ],
                      ),
                    ),

                    /// 悬浮图片
                    Positioned(
                      top: -imageOffset.h,
                      left: (moduleWidth.w - imageWidth.w) / 2,
                      child: Image(image: image, width: imageWidth.w),
                    ),
                  ],
                ),

                /// 底部关闭按钮
                if (isCloseIcon)
                  Padding(
                    padding: EdgeInsets.only(top: 20.w),
                    child: GestureDetector(
                      onTap: onCancel ?? () => Navigator.pop(context),
                      child: Image(
                        image: AssetImage('ely_close.png'.icon),
                        width: 36.h,
                        height: 36.h,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 处理按钮逻辑
  Widget _buildButtons() {
    final hasCancel = cancelText != null && cancelText!.isNotEmpty;
    final hasConfirm = confirmText != null && confirmText!.isNotEmpty;

    if (!hasCancel && !hasConfirm) return const SizedBox.shrink();

    /// 只有一个按钮
    if (hasCancel ^ hasConfirm) {
      final text = hasCancel ? cancelText! : confirmText!;
      final callback = hasCancel ? onCancel : onConfirm;

      return SizedBox(
        width: 256.w,
        height: 36.h,

        child: Container(
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFF0BBA), const Color(0xFF6018E6)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(34),
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(34.r),
            onTap: callback,
            child: Center(
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      );
    }

    /// 两个按钮
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 122.w,
          height: 36.h,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            child: Text(cancelText!),
          ),
        ),
        SizedBox(width: 16.w),
        SizedBox(
          width: 122.w,
          height: 36.h,
          child: Container(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFF0BBA), const Color(0xFF6018E6)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(34),
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(34.r),
              onTap: onConfirm,
              child: Center(
                child: Text(
                  confirmText!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//
// 弹窗方法
//
Future<void> showElConfirmModal(
  BuildContext context, {
  required ImageProvider image,
  required String title,
  Widget? child,
  String? cancelText,
  String? confirmText,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
  bool isCloseIcon = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (context) {
      return ElConfirmModal(
        image: image,
        title: title,
        child: child,
        cancelText: cancelText,
        confirmText: confirmText,
        onCancel: onCancel,
        onConfirm: onConfirm,
        isCloseIcon: isCloseIcon,
      );
    },
  );
}
