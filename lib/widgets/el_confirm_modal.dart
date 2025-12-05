import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElConfirmModal extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String description;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final ImageProvider? closeIcon;
  final double topOffset;
  final double moduleWidth;
  final double moduleHeight;
  final double titleTop;
  final double descSpacing;
  final double betweenModuleAndClose;
  final double imageWidth;
  final double imageHeight;
  final double imageTopAdjust;

  const ElConfirmModal({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
    this.closeIcon,
    this.topOffset = 65,
    this.moduleWidth = 328,
    this.moduleHeight = 304,
    this.titleTop = 185,
    this.descSpacing = 12,
    this.betweenModuleAndClose = 30,
    this.imageWidth = 233,
    this.imageHeight = 221,
    this.imageTopAdjust = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          Positioned(
            top: topOffset.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: moduleWidth.w,
                height: moduleHeight.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF404040),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    SizedBox(height: titleTop.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: descSpacing.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 122.43.w,
                          height: 36.h,
                          child: OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 1, color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(cancelText),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        SizedBox(
                          width: 122.43.w,
                          height: 36.h,
                          child: Ink(
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(0.00, 0.50),
                                end: Alignment(1.00, 0.50),
                                colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(34.r),
                              ),
                            ),
                            child: TextButton(
                              onPressed: onConfirm,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34.r),
                                ),
                              ),
                              child: Text(confirmText),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: topOffset.h - imageTopAdjust.h,
            left: 0,
            right: 0,
            child: Center(
              child: Image(
                image: image,
                width: imageWidth.w,
                height: imageHeight.h,
              ),
            ),
          ),
          Positioned(
            top: (topOffset + moduleHeight + betweenModuleAndClose).h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onCancel,
                child: closeIcon != null
                    ? Image(
                        image: closeIcon!,
                        width: 36.h,
                        height: 36.h,
                      )
                    : Icon(Icons.close, color: Colors.white, size: 36.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showElConfirmModal(
  BuildContext context, {
  required ImageProvider image,
  required String title,
  required String description,
  required String cancelText,
  required String confirmText,
  required VoidCallback onCancel,
  required VoidCallback onConfirm,
  ImageProvider? closeIcon,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return ElConfirmModal(
        image: image,
        title: title,
        description: description,
        cancelText: cancelText,
        confirmText: confirmText,
        onCancel: onCancel,
        onConfirm: onConfirm,
        closeIcon: closeIcon,
      );
    },
  );
}
