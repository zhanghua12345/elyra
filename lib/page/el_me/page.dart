import 'package:elyra/extend/el_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('ely_background_image.png'.icon),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.only(
          top: 40.w + ScreenUtil().statusBarHeight,
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 15.w),
              width: ScreenUtil().screenWidth - 32.w,
              decoration: BoxDecoration(
                color: Color(0xFFE424AE).withValues(alpha: .48),
                borderRadius: BorderRadius.circular(21.w),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // 头像
                      CircleAvatar(
                        radius: 30.w,
                        backgroundColor: Color(0xFF565656),
                      ),
                      // 内容区域
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.w),
                              Text(
                                'ID : 32432233341',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 登录按钮
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 17.w,
                          vertical: 5.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.w),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 40.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'ely_gold.png'.icon, // 替换为你的图标
                                  width: 28.w,
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Coins',
                                      style: TextStyle(
                                        color: Color(0xFFF7F497),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '99999',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 30.w),
                            Row(
                              children: [
                                Image.asset(
                                  'ely_gold.png'.icon, // 替换为你的图标
                                  width: 28.w,
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Coins',
                                      style: TextStyle(
                                        color: Color(0xFFF7F497),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '99999',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.w),
                            gradient: LinearGradient(
                              colors: [Color(0xFFE424AE), Color(0xFF6018E6)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Text(
                            'Top Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Top Up 按钮
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.w),
              child: Column(
                children: [
                  _buildMenuItem(
                    'assets/ely_my_language.png',
                    'Language',
                    'language',
                  ),
                  _buildMenuItem(
                    'assets/ely_my_feedback.png',
                    'Feedback',
                    'feedback',
                  ),
                  _buildMenuItem('assets/ely_my_about.png', 'About', 'about'),
                  _buildMenuItem(
                    'assets/ely_my_setting.png',
                    'Setting',
                    'setting',
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    dynamic icon,
    String title,
    String id, {
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.white.withOpacity(0.5), width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 1.w,
        ), // ✅ 去掉左右间距，设置上下间距
        // ✅ 支持自定义 icon 或图片
        leading: icon is String
            ? Image.asset(
                icon, // 例如传 'assets/icons/lang.png'
                width: 20.w,
              )
            : Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white70),
        onTap: () {
          // 点击事件
          Get.toNamed('/$id');
        },
      ),
    );
  }
}
