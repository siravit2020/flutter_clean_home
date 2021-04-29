import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_home/account/account.dart';

import 'package:flutter_clean_home/color_plate.dart';
import 'package:flutter_clean_home/plan/you_plan.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:intl/intl.dart';
import 'intro/intro.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
bool USE_FIRESTORE_EMULATOR = false;
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: purple));
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";

  await initializeDateFormatting();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
   static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(669.37, 1439.61),
      builder: () => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [
          BotToastNavigatorObserver(),
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
        home: Intro(),
      ),
    );
  }
}
