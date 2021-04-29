//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_clean_home/color_plate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
// Example holidays

class Booking extends StatefulWidget {
  String routeName = "Booking";
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> with TickerProviderStateMixin {
  final Map<DateTime, List> _holidays = {
    DateTime(2021, 1, 1): ['New Year\'s Day'],
    DateTime(2021, 1, 6): ['Epiphany'],
    DateTime(2021, 2, 14): ['Valentine\'s Day'],
    DateTime(2021, 4, 21): ['Easter Sunday'],
    DateTime(2021, 4, 22): ['Easter Monday'],
  };
  bool en = true;
  Map<DateTime, List<ItemEvent>> _events;
  List<ItemEvent> _selectedEvents;
  Animation _arrowAnimation;
  AnimationController _arrowAnimationController;
  CalendarController _calendarController;
  Future<DateTime> date = Future.value(DateTime.now());

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    ItemEvent i1 = ItemEvent(
        'non.png', 'Nonny1', 'Initial Cleaning', '8 AM', '9AM', 3, 50, false);
    ItemEvent i2 = ItemEvent(
        'non.png', 'Nonny2', 'Upkeep Cleaning', '10 AM', '11AM', 4, 60, false);
    ItemEvent i3 = ItemEvent(
        'non.png', 'Nonny3', 'Initial Cleaning', '12 AM', '1PM', 2, 40, true);
    ItemEvent i4 = ItemEvent(
        'non.png', 'Nonny4', 'Upkeep Cleaning', '3 PM', '4PM', 1, 45, false);
    ItemEvent i5 = ItemEvent(
        'non.png', 'Nonny5', 'Initial Cleaning', '6 PM', '7PM', 5, 55, true);
    _events = {
      _selectedDay.subtract(Duration(days: 2)): [i1, i2],
      _selectedDay: [i1, i2, i3, i4, i5],
      _selectedDay.add(Duration(days: 1)): [i2, i3, i4, i5],
      _selectedDay.add(Duration(days: 3)): [i1, i2, i3],
      _selectedDay.add(Duration(days: 7)): [i4, i5],
      _selectedDay.add(Duration(days: 11)): [i1],
      _selectedDay.add(Duration(days: 26)): [i2, i3, i4],
    };

    _selectedEvents = _events[_selectedDay] ?? [];

    _calendarController = CalendarController();

    _arrowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _arrowAnimation =
        Tween(begin: 0.0, end: pi).animate(_arrowAnimationController);
    _arrowAnimationController.forward();
    date.then((value) {
      _calendarController.setSelectedDay(DateTime.now());
      setState(() {});
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    List<ItemEvent> event = events.cast<ItemEvent>();
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = event;
      if (events.isNotEmpty) {
        _calendarController.setCalendarFormat(CalendarFormat.week);
      } else {
        _calendarController.setCalendarFormat(CalendarFormat.month);
      }
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    if (format == CalendarFormat.month) {
      _arrowAnimationController.forward();
    } else {
      _arrowAnimationController.reverse();
    }
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: purple,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: purple,
          centerTitle: true,
          title: Text(
            'Cleaner Calendar',
            style: GoogleFonts.ubuntu(
                fontSize: 29.sp, fontWeight: FontWeight.bold),
          ),
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 40.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      en = !en;
                    });
                  },
                  child: Text(
                    en ? 'TH' : 'EN',
                    style: GoogleFonts.ubuntu(fontSize: 29.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 30.h),
            _buildTableCalendar(),
            //_buildTableCalendarWithBuilders(),
            const SizedBox(height: 8.0),
            //_buildButtons(),

            Expanded(child: _buildEventList()),
          ],
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: en ? 'en_US' : null,
      initialSelectedDay: DateTime.now(),
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: yellow,
        todayColor: yellow.withOpacity(0.5),
        weekendStyle: GoogleFonts.ubuntu(fontSize: 26.sp),
        weekdayStyle: GoogleFonts.ubuntu(fontSize: 26.sp),
        markersColor: Colors.white,
        markersPositionBottom: 8,
        markersMaxAmount: 1,
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextBuilder: (date, locate) => DateFormat.E(locate).format(date)[0],
        // dowTextBuilder: (date, locate) =>
        //     DateFormat.E().formatInBuddhistCalendarThai(date),
        weekendStyle: GoogleFonts.ubuntu(fontSize: 25.sp),
        weekdayStyle: GoogleFonts.ubuntu(fontSize: 25.sp),
      ),
      headerStyle: HeaderStyle(
        titleTextBuilder: (date, locate) => en
            ? DateFormat.yMMM(locate).format(date)
            : DateFormat.yMMM().formatInBuddhistCalendarThai(date),
        formatButtonVisible: false,
        centerHeaderTitle: true,
        leftChevronMargin: EdgeInsets.only(left: 157.3.w),
        rightChevronMargin: EdgeInsets.only(right: 157.3.w),
        leftChevronIcon: Icon(
          Icons.navigate_before_rounded,
          color: Colors.white,
        ),
        rightChevronIcon: Icon(
          Icons.navigate_next_rounded,
          color: Colors.white,
        ),
        titleTextStyle: GoogleFonts.ubuntu(color: Colors.white),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    String date;
    String d;
    String m;
    String y;
    if (_calendarController.selectedDay != null) if (en) {
      d = DateFormat.d("en").format(_calendarController.selectedDay);
      m = DateFormat.MMM("en").format(_calendarController.selectedDay);
      y = DateFormat.y("en").format(_calendarController.selectedDay);
    } else {
      d = DateFormat.d("th").format(_calendarController.selectedDay);
      m = DateFormat.MMM("th").format(_calendarController.selectedDay);
      y = DateFormat.y("th")
          .formatInBuddhistCalendarThai(_calendarController.selectedDay);
    }
    date = '$d $m $y';
    return Center(
      child: Container(
        child: Stack(
          children: [
            ClipPath(
              clipper: Custom(),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(top: 105.7.h),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        child: child,
                        opacity: animation,
                      );
                    },
                    child: (_selectedEvents.length != 0)
                        ? ListView(
                            physics: BouncingScrollPhysics(),
                            children: _selectedEvents.map((event) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 1.sw * 0.08,
                                    right: 1.sw * 0.08,
                                    bottom: 22.6.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 18,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 9.h),
                                        child: Text(
                                          event.startTime,
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19.sp,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 100,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffDFDEFF),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 21.1.h),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 31.4.h),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        event.name,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          color: purple,
                                                          fontSize: 19.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 25.1.h,
                                                      ),
                                                      Text(
                                                        event.cleanning,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                          color: Colors.black45,
                                                          fontSize: 17.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.9.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/icons/clock.svg',
                                                            width: 17.42.w,
                                                          ),
                                                          SizedBox(
                                                            width: 12.2.w,
                                                          ),
                                                          Text(
                                                            "${event.startTime.replaceAll(RegExp(r"\s+"), "")} - ${event.endTime}",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                                    color:
                                                                        purple,
                                                                    fontSize:
                                                                        13.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 21.18.w,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Client Rating",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 17.sp,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 17.5.w,
                                                          ),
                                                          for (int i = 0;
                                                              i < event.rating;
                                                              i++)
                                                            Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/icons/star.svg',
                                                                  width: 19.w,
                                                                ),
                                                                SizedBox(
                                                                  width: 15.7.w,
                                                                ),
                                                              ],
                                                            )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 23.7.h,
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  height: 0,
                                                  color: Color(0xffC48B30)
                                                      .withOpacity(0.18),
                                                ),
                                                SizedBox(
                                                  height: 22.8.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 31.4.h,
                                                      right: 35.2.h),
                                                  child: SizedBox(
                                                    height: 22.8.h,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                                'assets/icons/telephone.svg'),
                                                            SizedBox(
                                                              width: 20.w,
                                                            ),
                                                            SvgPicture.asset(
                                                                'assets/icons/email.svg'),
                                                          ],
                                                        ),
                                                        (event.paid)
                                                            ? SizedBox()
                                                            : Text(
                                                                "\$50",
                                                                style: GoogleFonts.ubuntu(
                                                                    color:
                                                                        purple,
                                                                    fontSize:
                                                                        19.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 22.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 14.h,
                                            right: 24.4.w,
                                            child: Container(
                                              width: 90.62.h,
                                              height: 90.62.h,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.white),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        'assets/images/non.PNG'),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 4,
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                          (event.paid)
                                              ? Positioned(
                                                  bottom: -22.7.h,
                                                  right: 0,
                                                  child: Image(
                                                    image: AssetImage(
                                                        'assets/images/paid.png'),
                                                    height: 151.5.h,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/group.svg',
                                  height: 200.h,
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                Text(
                                  'Not have event',
                                  style:
                                      GoogleFonts.ubuntu(color: Colors.black54),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_calendarController.calendarFormat ==
                        CalendarFormat.month)
                      _calendarController
                          .setCalendarFormat(CalendarFormat.week);
                    else
                      _calendarController
                          .setCalendarFormat(CalendarFormat.month);
                  });
                },
                child: AnimatedBuilder(
                    animation: _arrowAnimationController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: _arrowAnimation.value,
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      );
                    }),
              ),
            ),
            Positioned(
                left: 48.5.w,
                top: 43.h,
                child: Text(
                  _calendarController.selectedDay != null ? '$date' : '',
                  style: GoogleFonts.ubuntu(color: Colors.black54),
                ))
          ],
        ),
      ),
    );
  }
}

class Custom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double radius = 30;
    path.moveTo(0, size.height);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo((size.width / 2) - 140.w, 0);

    path.quadraticBezierTo(
        (size.width / 2) - 72.w, 0, (size.width / 2) - 42.w, 38.h);
    path.quadraticBezierTo(
        (size.width / 2) - 25.w, 58.h, (size.width / 2) - 5.w, 58.h);
    path.lineTo((size.width / 2), 58.h);
    path.lineTo((size.width / 2) + 5, 58.h);

    path.quadraticBezierTo(
        (size.width / 2) + 25.w, 58.h, (size.width / 2) + 42.w, 38.h);
    path.quadraticBezierTo(
        (size.width / 2) + 72.w, 0, (size.width / 2) + 140.w, 0);

    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ItemEvent {
  String image;
  String name;
  String cleanning;
  String startTime;
  String endTime;
  int rating;
  int price;
  bool paid;
  ItemEvent(this.image, this.name, this.cleanning, this.startTime, this.endTime,
      this.rating, this.price, this.paid);
}
