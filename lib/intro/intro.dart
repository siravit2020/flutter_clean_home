import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_home/account/account.dart';
import 'package:flutter_clean_home/color_plate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String token;
  void initState() {
    super.initState();
    //_error();
    _fcm.getToken().then((value) {
      token = value;
      print(value);
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        BotToast.showSimpleNotification(
          hideCloseButton: true,
          title: message['notification']['title'],
          subTitle: message['notification']['body'],
          duration: Duration(seconds: 3),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  void _testFirebaseError() async {
    await FirebaseCrashlytics.instance.setCustomKey("bool_key", true);
    await FirebaseCrashlytics.instance.log("อิหยังวะ");
    await FirebaseCrashlytics.instance.setUserIdentifier(token);
    //FirebaseCrashlytics.instance.crash();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: purple,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Logo(),
                _TitleWidget(),
                SizedBox(height: 56.h),
                _DescriptionWidget(),
                SizedBox(height: 128.2.h),
                _ImageWidget(),
              ],
            ),
            _ButtonWidget()
          ],
        ),
      ),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          navigation(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
            ),
          ),
          height: 120.h,
          width: 308.57.w,
          child: Center(
            child: Text(
              "Get Started",
              style: GoogleFonts.montserrat(
                color: purple,
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<Account>(
        settings: RouteSettings(name: Account().routeName),
        builder: (BuildContext context) {
          return Account();
        },
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/group.svg',
      height: 581.18.h,
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Book Cleaners at the Comfort \n of you home.",
      style: GoogleFonts.montserrat(
        fontSize: 30.sp,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Clean Home \n Clean Life",
      style: GoogleFonts.montserrat(
        fontSize: 61.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30.h,
        ),
        SvgPicture.asset(
          'assets/icons/logo.svg',
          height: 27.83.h,
        ),
        SizedBox(
          width: 14.58.w,
        ),
        Text(
          "Nimbl.",
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 34.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 83.5.h,
        ),
      ],
    );
  }
}
