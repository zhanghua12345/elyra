import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/utils/el_color.dart';

enum BadStatusType { noNetwork, loadFailed, nothingYet, notFound }

enum LoadStatusType { loading, loadSuccess, loadFailed, loadNoData }

class BadStatusWidget extends StatelessWidget {
  final BadStatusType type;
  final String? message;
  final VoidCallback? onPressed;

  const BadStatusWidget({super.key, required this.type, this.message, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(_getIcon(type).icon, width: 290.w, height: 268.h),
              Text(
                _getMessage(type, message),
                style: TextStyle(fontSize: 15.sp, color: ColorEnum.mainColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),

          Text(
            _getSubMessage(type, message),
            style: TextStyle(fontSize: 12.sp, color: ColorEnum.bg_777777),
          ),
          if (onPressed != null)
            GestureDetector(
              onTap: onPressed,
              child: Container(
                height: 48.h,
                width: 200.w,
                margin: EdgeInsets.only(top: 30.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorEnum.mainColor, width: 1.w),
                  borderRadius: BorderRadius.circular(50.w),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(fontSize: 14.sp, color: ColorEnum.mainColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getIcon(BadStatusType type) {
    switch (type) {
      case BadStatusType.noNetwork:
        return 'ic_no_network.png';
      case BadStatusType.loadFailed:
        return 'ic_load_failed.png';
      case BadStatusType.nothingYet:
        return 'ic_nothing.png';
      case BadStatusType.notFound:
        return 'ic_not_found.png';
    }
  }

  String _getMessage(BadStatusType type, String? message) {
    switch (type) {
      case BadStatusType.noNetwork:
        return 'No Network';
      case BadStatusType.loadFailed:
        return 'Load Failed';
      case BadStatusType.nothingYet:
        return 'Nothing here yet';
      case BadStatusType.notFound:
        return 'Not found';
    }
  }

  String _getSubMessage(BadStatusType type, String? message) {
    switch (type) {
      case BadStatusType.noNetwork:
        return 'Unable to connect. Try again later.';
      case BadStatusType.loadFailed:
        return 'We’re having trouble. Hang tight.';
      case BadStatusType.nothingYet:
        return 'Start exploring and add something!';
      case BadStatusType.notFound:
        return 'Sorry, we couldn\'t find anything.';
    }
  }
}
