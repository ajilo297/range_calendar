library range_calendar;

import 'package:flutter/material.dart';

class RangeCalendar extends StatefulWidget {
  final DateTime currentDateTime;
  final DateTime selectionStartDate;
  final DateTime selectionEndDate;

  final TextStyle weekdayTextStyle;
  final TextStyle inMonthDateTextStyle;
  final TextStyle outMonthDateTextStyle;
  final TextStyle monthControlTextStyle;

  final Decoration dateDecoration;
  final Decoration currentDateDecoration;
  final Decoration selectedDateDecoration;
  final Decoration outOfMonthDateDecoration;

  final bool highlightCurrentDate;
  final bool showMonthControls;

  RangeCalendar({
    this.currentDateTime,
    this.selectionStartDate,
    this.selectionEndDate,
    this.weekdayTextStyle,
    this.inMonthDateTextStyle,
    this.outMonthDateTextStyle,
    this.monthControlTextStyle,
    this.dateDecoration,
    this.currentDateDecoration,
    this.selectedDateDecoration,
    this.outOfMonthDateDecoration,
    this.highlightCurrentDate = true,
    this.showMonthControls = true,
  });

  @override
  RangeCalendarState createState() => RangeCalendarState();
}

class RangeCalendarState extends State<RangeCalendar> {
  DateTime _viewDate;

  DateTime startDate;
  DateTime endDate;

  SelectionType selectionType = SelectionType.START_DATE;

  @override
  void initState() {
    super.initState();

    _viewDate = widget.currentDateTime ?? DateTime.now();
    startDate = widget.selectionStartDate ?? DateTime.now();
    endDate = widget.selectionEndDate ?? DateTime.now();

    assert(startDate.isBefore(endDate) || _isSameDay(startDate, endDate));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (widget.showMonthControls) monthControl,
            monthView,
          ],
        ),
      ),
    );
  }

  Widget get monthControl {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: previousMonth,
          ),
          Text(
            '${monthList.elementAt(_viewDate.month - 1)} ${_viewDate.year}',
            style: widget.monthControlTextStyle ??
                Theme.of(context).textTheme.title,
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: nextMonth,
          ),
        ],
      ),
    );
  }

  Widget get monthView {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_weekdayTitleRowWidget, monthDateView],
        ),
      ),
    );
  }

  Widget get _weekdayTitleRowWidget {
    return Row(
      children: weekdayList.map((weekDay) {
        return _getWeekdayTitleWidget(weekDay);
      }).toList(),
    );
  }

  Widget _getWeekdayTitleWidget(String weekday) {
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            weekday.substring(0, 3),
            style:
                widget.weekdayTextStyle ?? Theme.of(context).textTheme.subtitle,
          ),
        ),
      ),
    );
  }

  Widget get monthDateView {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 7,
      children: () {
        List<int> dayList = [];
        for (int i = 0; i < 42; i++) {
          dayList.add(i + 1);
        }
        return dayList.map(
          (dayIndex) {
            return Container(
              decoration: () {
                bool isInCurrentMonth = !_isDayIndexOutOfMonth(dayIndex);
                if (!isInCurrentMonth) {
                  return widget.outOfMonthDateDecoration;
                }
                if (_isSameDay(
                  widget.currentDateTime ?? DateTime.now(),
                  DateTime(
                    _viewDate.year,
                    _viewDate.month,
                    dayIndex - dayOffset,
                  ),
                )) {
                  return widget.currentDateDecoration ??
                      ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: Theme.of(context).accentColor,
                            width: 2,
                          ),
                        ),
                      );
                }
              }(),
              child: getDayTextWidget(dayIndex),
            );
          },
        ).toList();
      }(),
    );
  }

  Widget getDayTextWidget(int dayIndex) {
    bool isInCurrentMonth = false;
    int dateValue;
    if (dayIndex <= dayOffset) {
      int numberOfDaysInPreviousMonth = getNumberOfDaysInMonth(
          _viewDate.month > 1 ? _viewDate.month - 1 : 12, _viewDate.year);
      dateValue = numberOfDaysInPreviousMonth - (dayOffset - dayIndex);
    } else if (dayIndex - dayOffset >
        getNumberOfDaysInMonth(_viewDate.month, _viewDate.year)) {
      dateValue = dayIndex -
          (getNumberOfDaysInMonth(
                _viewDate.month,
                _viewDate.year,
              ) +
              dayOffset);
    } else {
      dateValue = dayIndex - dayOffset;
      isInCurrentMonth = true;
    }

    return Center(
      child: Text(
        dateValue.toString(),
        style: isInCurrentMonth
            ? widget.inMonthDateTextStyle ??
                Theme.of(context).textTheme.body1.copyWith(color: Colors.black)
            : widget.outMonthDateTextStyle ??
                Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Color(0xffefefef)),
      ),
    );
  }

  bool _isInSelectedDate() {}

  bool _isDayIndexOutOfMonth(int dayIndex) {
    if (dayIndex <= dayOffset) {
      int numberOfDaysInPreviousMonth = getNumberOfDaysInMonth(
          _viewDate.month > 1 ? _viewDate.month - 1 : 12, _viewDate.year);
      return true;
    } else if (dayIndex - dayOffset >
        getNumberOfDaysInMonth(_viewDate.month, _viewDate.year)) {
      return true;
    }
    return false;
  }

  int get dayOffset {
    int offset = DateTime(_viewDate.year, _viewDate.month, 1).weekday;
    offset = offset == 7 ? 0 : offset;
    return offset;
  }

  void nextMonth() {
    setState(() {
      return _viewDate = DateTime(_viewDate.year, _viewDate.month + 1, 1);
    });
  }

  void previousMonth() {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month - 1, 1);
    });
  }

  static int getNumberOfDaysInMonth(int month, int year) {
    int numDays = 28;
    switch (month) {
      case 1:
        numDays = 31;
        break;
      case 2:
        if (_isLeapYear(year)) {
          numDays = 29;
        } else {
          numDays = 28;
        }
        break;
      case 3:
        numDays = 31;
        break;
      case 4:
        numDays = 30;
        break;
      case 5:
        numDays = 31;
        break;
      case 6:
        numDays = 30;
        break;
      case 7:
        numDays = 31;
        break;
      case 8:
        numDays = 31;
        break;
      case 9:
        numDays = 30;
        break;
      case 10:
        numDays = 31;
        break;
      case 11:
        numDays = 30;
        break;
      case 12:
        numDays = 31;
        break;
      default:
        numDays = 28;
    }
    return numDays;
  }

  static List<String> get monthList => [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

  static List<String> get weekdayList => [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednessday',
        'Thursday',
        'Friday',
        'Saturday',
      ];

  static bool _isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
  }

  static bool _isSameDay(DateTime d1, DateTime d2) {
    return (d1.year == d2.year && d1.month == d2.month && d1.day == d2.day);
  }
}

enum SelectionType { START_DATE, END_DATE }
