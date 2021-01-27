import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Termin {
  String date;
  String time;
}

class DateTimeWidget extends StatefulWidget {
  // final OrderModel order;
  final Termin termin;
  final int createdAt;
  DateTimeWidget({this.createdAt, this.termin});

  static String makeDate(String day, int createdAt) {
    String date;

    DateTime bestellDate = DateTime.fromMillisecondsSinceEpoch(createdAt);

    DateTime termin1;
    int diffDay = DateTime.daysPerWeek - bestellDate.weekday;
    int freiday = diffDay - 2;
    int saturday = diffDay - 1;

    if (diffDay >= 4) {
      // bis Mittwoch
      termin1 = (day == 'Fr') // diese Woche
          ? DateTime.fromMillisecondsSinceEpoch(createdAt)
              .add(Duration(days: freiday)) /*Freitag dieser Woche*/
          : DateTime.fromMillisecondsSinceEpoch(createdAt)
              .add(Duration(days: saturday)); /*Samstag dieser Woche*/
    } else {
      // nächste Woche
      termin1 = (day == 'Fr') // nächste Woche
          ? DateTime.fromMillisecondsSinceEpoch(createdAt)
              .add(Duration(days: (7 + freiday))) /*Freitag nächste Woche*/
          : DateTime.fromMillisecondsSinceEpoch(createdAt)
              .add(Duration(days: (7 + saturday))); /*Samstag nächste Woche*/
    }

    final df = new DateFormat('dd.MM');
    date = df.format(termin1);
    return date;
  }

  @override
  _DateTimeWidgetState createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  var selectedDate = '';
  var selectedDay = ''; //'Sa';
  var selectedTime = ''; //'12-14';

  String customDate;
  String customDay;

  @override
  void initState() {
    // selectedDate = DateTimeWidget.makeDate(selectedDay, widget.createdAt);
    super.initState();
  }

  Color switchTimeColor(time) {
    if (time == selectedTime) {
      return AppColors.lightblue.withOpacity(0.8);
    } else {
      return Colors.grey.withOpacity(0.2);
    }
  }

  Color switchTimeContentColor(time) {
    if (time == selectedTime) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  selectTime(time) {
    setState(() {
      selectedTime = time;
      widget.termin.time = time;
    });
  }

  Widget getTime(time) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: switchTimeColor(time)),
      height: 50.0,
      width: 75.0,
      child: InkWell(
        onTap: () {
          selectTime(time);
        },
        child: Center(
          child: Text(
            time,
            style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: switchTimeContentColor(time)),
          ),
        ),
      ),
    );
  }

  Color switchColor(date) {
    if (date == selectedDate) {
      return AppColors.lightblue.withOpacity(0.8);
    } else {
      return Colors.grey.withOpacity(0.2);
    }
  }

  Color switchContentColor(date) {
    if (date == selectedDate) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  selectDay(date, day) {
    setState(() {
      selectedDate = date;
      widget.termin.date = '$day, den $date';
    });
  }

  Widget getDate(String date, String day) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), color: switchColor(date)),
      width: 60.0,
      height: 60.0,
      child: InkWell(
        onTap: () {
          selectDay(date, day);
        },
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 7.0),
              Text(
                date,
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: switchContentColor(date)),
              ),
              Text(
                day,
                style: TextStyle(
                    fontFamily: 'FiraSans',
                    fontSize: 17.0,
                    color: switchContentColor(day)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 130.0,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurRadius: 3.0,
                color: AppColors.lightblue.withOpacity(0.2),
                spreadRadius: 4.0)
          ], color: Colors.white),
        ),
        Positioned(
          top: 10.0,
          left: 15.0,
          right: 15.0,
          child: Container(
            height: 60.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                getDate(DateTimeWidget.makeDate('Fr', widget.createdAt), 'Fr'),
                SizedBox(width: 15.0),
                getDate(DateTimeWidget.makeDate('Sa', widget.createdAt), 'Sa'),
                if (customDate != null && customDay != null)
                  SizedBox(width: 15.0),
                if (customDate != null && customDay != null)
                  getDate(customDate, customDay),
                SizedBox(width: 15.0),
                FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.add),
                    backgroundColor: AppColors.straw,
                    onPressed: () async {
                      final DateTime picked =
                          await /*DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime(2021, 1, 15),
                          maxTime: DateTime(2041, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                      }, currentTime: DateTime.now(), locale: LocaleType.de);*/

                          showDatePicker(
                              context: context,
                              //locale: const Locale("de","DE"),
                              initialDate: DateTime.fromMillisecondsSinceEpoch(
                                  widget.createdAt),
                              initialDatePickerMode: DatePickerMode.day,
                              firstDate: DateTime.now(),//(2021),
                              lastDate: DateTime(
                                  2050)); //this line making the code not working too

                      if (picked != null)
                        setState(() {
                          final df = new DateFormat('dd.MM');
                          customDate = df.format(picked);

                          final dfDay = new DateFormat('E');
                          customDay = dfDay.format(picked);

                          if (customDay == 'Wed') customDay = 'Mi';
                          else if (customDay == 'Tue') customDay = 'Di';
                          else if (customDay == 'Mon') customDay = 'Mo';
                          else if (customDay == 'Thu') customDay = 'Do';
                          else if (customDay == 'Fri') customDay = 'Fr';
                          else if (customDay == 'Sat') customDay = 'Sa';
                          else if (customDay == 'Sun') customDay = 'So';

                          selectDay(customDate, customDay);
                        });
                    }),
              ],
            ),
          ),
        ),
        Positioned(
          top: 80.0,
          left: 15.0,
          right: 15.0,
          child: Container(
            height: 40.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                getTime('10-12'),
                SizedBox(width: 10.0),
                getTime('12-14'),
                SizedBox(width: 10.0),
                getTime('14-16'),
                SizedBox(width: 10.0),
                getTime('16-18'),
                SizedBox(width: 10.0)
              ],
            ),
          ),
        ),
      ],
      //  ),
    );
  }
}
