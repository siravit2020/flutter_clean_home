import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_home/color_plate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'dart:math';

enum Frequency { weekly, bi_weekly, monthly }

class YourPlan extends StatefulWidget {
  String routeName = "Plan";
  @override
  _YourPlanState createState() => _YourPlanState();
}

class _YourPlanState extends State<YourPlan> {
  bool selectCleaning = true;
  String ttr;
  Frequency selectFrequency = Frequency.monthly;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  Future<void> _initial() async {
    await analytics.logEvent(
      name: 'initial_cleaning',
    );
    print('logEvent succeeded');
  }

  Future<void> _upkeep() async {
    await analytics.logEvent(
      name: 'upkeep_cleaning',
    );
    print('logEvent succeeded');
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height - kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: purple,
        title: Text(
          "Your Plan",
          style: GoogleFonts.ubuntu(
              fontSize: 29.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: purple,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: h - ScreenUtil().statusBarHeight,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 64.h,
                ),
                Text(
                  "Selected Cleaning",
                  style: GoogleFonts.ubuntu(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold),
                ),
                // Text(
                //   ttr,
                //   style: GoogleFonts.ubuntu(
                //       color: Colors.black.withOpacity(0.7),
                //       fontSize: 25.sp,
                //       fontWeight: FontWeight.bold),
                // ),
                SizedBox(
                  height: 53.h,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _initial();
                        setState(() {
                          selectCleaning = true;
                        });
                      },
                      child: itemCleaning('Initial-cleaning.png',
                          'Initial Cleaning', selectCleaning),
                    ),
                    SizedBox(
                      width: 23.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        _upkeep();
                        setState(() {
                          selectCleaning = false;
                        });
                      },
                      child: itemCleaning('Upkeep-cleaning.png',
                          'Upkeep cleaning', !selectCleaning),
                    ),
                  ],
                ),
                SizedBox(
                  height: 38.6.h,
                ),
                Text(
                  "Selected Frequency",
                  style: GoogleFonts.ubuntu(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 44.2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    itemFrequency("Weekly", Frequency.weekly),
                    itemFrequency("Bi-weekly", Frequency.bi_weekly),
                    itemFrequency("Monthly", Frequency.monthly),
                  ],
                ),
                SizedBox(
                  height: 53.9.h,
                ),
                Text(
                  "Selected Extras",
                  style: GoogleFonts.ubuntu(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 46.6.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    itemExtras('Inside Fridge', 'fridge.svg', true),
                    itemExtras('Organizing', 'organizing.svg', false),
                    itemExtras('Small Blinds', 'blinds.svg', false),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    itemExtras('Patio', 'patio.svg', true),
                    itemExtras('Organizing', 'organizing.svg', false),
                    itemExtras('Inside Fridge', 'blinds.svg', true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column itemCleaning(String image, String title, bool status) {
    return Column(
      children: [
        Container(
          height: 223.56.h,
          width: 272.96.w,
          decoration: BoxDecoration(
            color: Color(0xffDFDEFF),
            borderRadius: BorderRadius.all(
              Radius.circular(51.w),
            ),
          ),
          child: Image(
            image: AssetImage(
              'assets/images/$image',
            ),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: 31.4.h,
        ),
        Text(
          title,
          style: GoogleFonts.montserrat(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        SizedBox(
          height: 18.9.h,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 38.4.w,
          width: 38.4.w,
          decoration: (status)
              ? BoxDecoration(color: pink, shape: BoxShape.circle)
              : BoxDecoration(
                  color: Color(0xffDBDBDB).withOpacity(0.51),
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1, color: Color(0xffA8A8A8).withOpacity(0.51))),
          child: (status)
              ? Icon(
                  Icons.done_rounded,
                  color: Colors.white,
                  size: 27.8.w,
                )
              : null,
        )
      ],
    );
  }

  Column itemExtras(String title, String icon, bool notificationStatus) {
    int count;
    if (notificationStatus) count = Random().nextInt(10) + 4;
    return Column(
      children: [
        SizedBox(
          height: 130.h,
          width: 125.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 121.15.w,
                  width: 121.15.w,
                  decoration:
                      BoxDecoration(color: purple, shape: BoxShape.circle),
                  child: Align(
                      child: SvgPicture.asset(
                    'assets/icons/$icon',
                    height: 62.5.h,
                  )),
                ),
              ),
              notificationStatus
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 41.55.h,
                        width: 41.55.h,
                        decoration:
                            BoxDecoration(color: pink, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            '$count',
                            style: GoogleFonts.montserrat(fontSize: 20.sp),
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
        SizedBox(
          height: 16.3.h,
        ),
        Text(
          title,
          style: GoogleFonts.montserrat(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        )
      ],
    );
  }

  GestureDetector itemFrequency(String title, Frequency frequency) {
    bool select = frequency == selectFrequency;
    return GestureDetector(
      onTap: () {
        selectFrequency = frequency;
        setState(() {});
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: 76.87.h,
        width: 157.32.w,
        decoration: BoxDecoration(
          color: select ? pink : null,
          border: select
              ? null
              : Border.all(
                  width: 2,
                  color: Color(0xffD9D9D9),
                ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.montserrat(
                color: select ? Colors.white : Color(0xff9B9B9B),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
