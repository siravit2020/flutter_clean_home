import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clean_home/bookings/booking.dart';
import 'package:flutter_clean_home/plan/you_plan.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../color_plate.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Account extends StatefulWidget {
  String routeName = "Account";
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  double radius = 95.w;
  String text = '';
  bool textComplete = false;
  final defaults = <String, dynamic>{'welcome': 'default welcome'};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final remoteConfig = await RemoteConfig.instance;
      await remoteConfig.setDefaults(<String, dynamic>{
        'text': 'this is the default welcome message',
        'text2': 'this is the default welcome message',
        'textComplete': false,
        'textComplete2': false
      });
      await remoteConfig
          .setConfigSettings(RemoteConfigSettings(debugMode: true));
      await remoteConfig.fetch(
        expiration: const Duration(hours: 4),
      );
      await remoteConfig.activateFetched();
      setState(() {
        text = remoteConfig.getString('text');
        textComplete = remoteConfig.getBool('textComplete');
        print(remoteConfig.getBool('textComplete2'));
        print(remoteConfig.getString('text2'));
      });
    });
    //remote();
    _controller = AnimationController(
      duration: const Duration(seconds: 150),
      vsync: this,
    )..repeat(reverse: false);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: purple,
        body: SingleChildScrollView(
          //physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 240.h,
                      width: 240.h,
                      child: Center(
                        child: Stack(
                          children: [
                            Center(
                              child: CircularPercentIndicator(
                                radius: 145.h,
                                lineWidth: 3.0,
                                percent: 0.6,
                                center: SvgPicture.asset(
                                  'assets/icons/avatar.svg',
                                  width: 110.h,
                                ),
                                progressColor: Color(0xffFFBF67),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            RotationTransition(
                              turns: Tween(begin: 0.0, end: 1.0)
                                  .animate(_controller),
                              child: Center(
                                child: Stack(
                                  children: [
                                    dot(cos(pi) * radius, sin(pi) * radius,
                                        Color(0xffFFBF67)),
                                    dot(
                                        cos(7 * pi / 4) * radius,
                                        sin(7 * pi / 4) * radius,
                                        Color(0xffFF6C46)),
                                    dot(
                                        cos(pi / 3) * radius,
                                        sin(pi / 3) * radius,
                                        Color(0xff10D592)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  (textComplete)
                      ? Row(
                          children: [
                            SizedBox(width: 60.w),
                            Column(
                              children: [
                                Text(
                                  "Hi Kate, \nWelcome Back",
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 34.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 29.h,
                                ),
                                Text(
                                  "70% Completed",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 27.sp,
                                      color: yellow,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: h - 240.h - ScreenUtil().statusBarHeight,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffFAFAFA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 1.sw * 0.075,
                          right: 1.sw * 0.075,
                          top: 69.h,
                          bottom: 30.h),
                      child: Text(
                        "Account",
                        style: GoogleFonts.ubuntu(
                            fontSize: 29.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    item('Notifications', 'notifications.svg'),
                    Divider(
                      height: 0,
                      thickness: 1.h,
                      color: Color(0xff707070).withOpacity(0.1),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              settings:
                                  RouteSettings(name: Booking().routeName),
                              builder: (BuildContext context) {
                                return Booking();
                              }));
                        },
                        child: item('My bookings', 'calendar.svg')),
                    Divider(
                      height: 0,
                      thickness: 1.h,
                      color: Color(0xff707070).withOpacity(0.1),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              settings:
                                  RouteSettings(name: YourPlan().routeName),
                              builder: (BuildContext context) {
                                return YourPlan();
                              }));
                        },
                        child: item('My Plan', 'tick.svg')),
                    Divider(
                      height: 0,
                      thickness: 1.h,
                      color: Color(0xff707070).withOpacity(0.1),
                    ),
                    item('Addresses', 'address.svg'),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 1.sw * 0.075,
                        right: 1.sw * 0.075,
                        top: 48.h,
                        bottom: 48.h,
                      ),
                      child: Text(
                        "Share",
                        style: GoogleFonts.ubuntu(
                            fontSize: 29.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    item('Facebook', 'facebook.svg'),
                    Divider(
                      height: 0,
                      thickness: 1.h,
                      color: Color(0xff707070).withOpacity(0.1),
                    ),
                    item('Twitter', 'twitter.svg'),
                    Divider(
                      height: 0,
                      thickness: 1.h,
                      color: Color(0xff707070).withOpacity(0.1),
                    ),
                    item('Gmail', 'gmail.svg'),
                    Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40))),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container item(String title, String icon) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 1.sw * 0.075, vertical: 36.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/$icon',
                  width: 33.h,
                  height: 33.h,
                ),
              ),
            ),
            Expanded(
              flex: 11,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: Text(
                    title,
                    style: GoogleFonts.ubuntu(
                        fontSize: 29.sp, color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Transform dot(double x, double y, Color color) {
    return Transform.translate(
      offset: Offset(x, y),
      child: Center(
        child: Container(
          height: 12.w,
          width: 12.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
