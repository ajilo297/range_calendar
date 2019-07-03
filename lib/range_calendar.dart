library range_calendar;

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

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
  final Decoration outOfMonthDateDecoration;
  final Decoration startDateDecoration;
  final Decoration endDateDecoration;

  final Curve animationCurve;
  final Duration animationDuration;

  final Color selectedDateColor;

  final bool highlightCurrentDate;
  final bool showMonthControls;

  final EdgeInsets margin;
  final EdgeInsets padding;

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
    this.outOfMonthDateDecoration,
    this.startDateDecoration,
    this.endDateDecoration,
    this.animationCurve,
    this.animationDuration,
    this.selectedDateColor,
    this.highlightCurrentDate = true,
    this.showMonthControls = true,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.all(4),
    Key key,
  }) : super(key: key);

  @override
  RangeCalendarState createState() => RangeCalendarState();
}

class RangeCalendarState extends State<RangeCalendar> {
  DateTime _viewDate;

  DateTime startDate;
  DateTime endDate;

  SelectionType selectionType = SelectionType.START_DATE;
  double _width;

  final _CalendarStateBuilder _calendarStateBuilder = _CalendarStateBuilder();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _width = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();

    _viewDate = widget.currentDateTime ?? DateTime.now();
    startDate = widget.selectionStartDate ?? DateTime.now();
    endDate = widget.selectionEndDate ?? DateTime.now();

    if (startDate != null || endDate != null)
      assert(startDate.isBefore(endDate) || isSameDay(startDate, endDate));
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
            if (widget.showMonthControls) _monthControl,
            _monthView,
          ],
        ),
      ),
    );
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

  Widget get _monthControl {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: Icon(Icons.navigate_before),
              onPressed: previousMonth,
            ),
          ),
          Expanded(
            child: Text(
              '${_monthList.elementAt(_viewDate.month - 1)} ${_viewDate.year}',
              style: widget.monthControlTextStyle ??
                  Theme.of(context).textTheme.title.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: nextMonth,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _monthView {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _weekdayTitleRowWidget,
        _monthDateView,
      ],
    );
  }

  Widget get _weekdayTitleRowWidget {
    return Row(
      children: _weekdayList.map((weekDay) {
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

  Widget get _monthDateView {
    List<int> dayList = [];
    for (int i = 0; i < 42; i++) {
      dayList.add(i + 1);
    }
    return Table(
      defaultColumnWidth: FixedColumnWidth(_width / 7),
      border: TableBorder.all(color: Colors.transparent),
      children: _weekDateView(dayList),
    );
  }

  List<TableRow> _weekDateView(List<int> dayList) {
    List<TableRow> rowList = [];
    List<TableCell> cellList = [];
    cellList = dayList.map((dayIndex) {
      return TableCell(
        child: Material(
          child: InkWell(
            onTap: () {
              _onDateSelected(dayIndex);
              _calendarStateBuilder.rebuild();
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: StateBuilder(
                tag: "$_CALENDAR_WIDGET_TAG",
                blocs: [
                  _calendarStateBuilder,
                ],
                builder: (context, tag) =>
                    _animatedBuilder(context, tag, dayIndex),
              ),
            ),
          ),
        ),
      );
    }).toList();

    rowList = List.generate(6, (index) {
      int i = index * 7;
      return TableRow(children: cellList.sublist(i, i + 7));
    });
    return rowList;
  }

  Widget _animatedBuilder(BuildContext context, String tag, int dayIndex) {
    return Animator(
      tween: ColorTween(
          end: widget.selectedDateColor ??
              Theme.of(context).primaryColor.withAlpha(20)),
      curve: widget.animationCurve ?? Curves.easeOut,
      cycles: 1,
      duration: widget.animationDuration ?? Duration(milliseconds: 800),
      builder: (animation) => Container(
            margin: widget.margin,
            decoration: () {
              if (isSameDay(startDate, _getDateFromDayIndex(dayIndex)) &&
                  isSameDay(endDate, _getDateFromDayIndex(dayIndex)))
                return widget.startDateDecoration ?? _defaultStartEndDecoration;
              if (_getDateFromDayIndex(dayIndex) == startDate) {
                return widget.startDateDecoration ?? _defaultStartDecoration;
              }
              if (_getDateFromDayIndex(dayIndex) == endDate) {
                return widget.endDateDecoration ?? _defaultEndDecoration;
              }

              if (_isInSelectedRange(dayIndex)) {
                return BoxDecoration(color: animation.value);
              }
            }(),
            child: Container(
              padding: widget.padding,
              decoration: () {
                bool isInCurrentMonth = !_isDayIndexOutOfMonth(dayIndex);
                if (!isInCurrentMonth) {
                  return widget.outOfMonthDateDecoration;
                }
                if (widget.highlightCurrentDate &&
                    isSameDay(
                      widget.currentDateTime ?? DateTime.now(),
                      DateTime(
                        _viewDate.year,
                        _viewDate.month,
                        dayIndex - _dayOffset,
                      ),
                    )) {
                  return widget.currentDateDecoration ??
                      ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: Theme.of(context).accentColor,
                            width: 1,
                          ),
                        ),
                      );
                }
              }(),
              child: _getDayTextWidget(dayIndex),
            ),
          ),
    );
  }

  ShapeDecoration get _defaultStartEndDecoration => ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        color: Theme.of(context).primaryColor.withAlpha(40),
      );

  ShapeDecoration get _defaultStartDecoration => ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
        ),
        color: Theme.of(context).primaryColor.withAlpha(40),
      );

  ShapeDecoration get _defaultEndDecoration => ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
        ),
        color: Theme.of(context).primaryColor.withAlpha(40),
      );

  void _onDateSelected(int dayIndex) {
    DateTime selectionDate = _getDateFromDayIndex(dayIndex);
    if (selectionType == SelectionType.START_DATE &&
        selectionDate.isAfter(endDate)) return;

    if (selectionType == SelectionType.END_DATE &&
        selectionDate.isBefore(startDate)) return;
    setState(() {
      if (selectionType == SelectionType.START_DATE)
        startDate = selectionDate;
      else if (selectionType == SelectionType.END_DATE) endDate = selectionDate;
    });
  }

  DateTime _getDateFromDayIndex(int dayIndex) {
    int dateValue;
    DateTime selectionDate = DateTime(
      _viewDate.year,
      _viewDate.month,
      _viewDate.day,
    );
    if (dayIndex <= _dayOffset) {
      int numberOfDaysInPreviousMonth = getNumberOfDaysInMonth(
          _viewDate.month > 1 ? _viewDate.month - 1 : 12, _viewDate.year);
      dateValue = numberOfDaysInPreviousMonth - (_dayOffset - dayIndex);
      selectionDate =
          DateTime(selectionDate.year, selectionDate.month - 1, dateValue);
    } else if (dayIndex - _dayOffset >
        getNumberOfDaysInMonth(_viewDate.month, _viewDate.year)) {
      dateValue = dayIndex -
          (getNumberOfDaysInMonth(_viewDate.month, _viewDate.year) +
              _dayOffset);
      selectionDate =
          DateTime(selectionDate.year, selectionDate.month + 1, dateValue);
    } else {
      dateValue = dayIndex - _dayOffset;
      selectionDate =
          DateTime(selectionDate.year, selectionDate.month, dateValue);
    }
    return selectionDate;
  }

  Widget _getDayTextWidget(int dayIndex) {
    bool isInCurrentMonth = !_isDayIndexOutOfMonth(dayIndex);
    DateTime dateTime = _getDateFromDayIndex(dayIndex);

    return Center(
      child: Text(
        dateTime.day.toString(),
        style: isInCurrentMonth
            ? widget.inMonthDateTextStyle ??
                Theme.of(context).textTheme.body1.copyWith(color: Colors.black)
            : widget.outMonthDateTextStyle ??
                Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Color(0xffeeeeee)),
      ),
    );
  }

  bool _isInSelectedRange(int dayIndex) {
    DateTime testDate = _getDateFromDayIndex(dayIndex);

    if (startDate == null) return false;
    if (endDate == null) return false;

    return isDateInRange(testDate, startDate, endDate);
  }

  bool _isDayIndexOutOfMonth(int dayIndex) {
    if (dayIndex <= _dayOffset ||
        dayIndex - _dayOffset >
            getNumberOfDaysInMonth(_viewDate.month, _viewDate.year)) {
      return true;
    } else if (dayIndex - _dayOffset >
        getNumberOfDaysInMonth(_viewDate.month, _viewDate.year)) {
      return true;
    }
    return false;
  }

  int get _dayOffset {
    int offset = DateTime(_viewDate.year, _viewDate.month, 1).weekday;
    offset = offset == 7 ? 0 : offset;
    return offset;
  }

  static List<String> get _monthList => [
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

  static List<String> get _weekdayList => [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednessday',
        'Thursday',
        'Friday',
        'Saturday',
      ];

  @visibleForTesting
  static int getNumberOfDaysInMonth(int month, int year) {
    int numDays = 28;
    switch (month) {
      case 1:
        numDays = 31;
        break;
      case 2:
        if (isLeapYear(year)) {
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

  @visibleForTesting
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
  }

  @visibleForTesting
  static bool isSameDay(DateTime d1, DateTime d2) {
    return (d1.year == d2.year && d1.month == d2.month && d1.day == d2.day);
  }

  @visibleForTesting
  static bool isDateInRange(DateTime testDate, DateTime d1, DateTime d2) {
    if ((testDate.isAfter(d1) || isSameDay(testDate, d1)) &&
        (testDate.isBefore(d2) || isSameDay(testDate, d2))) {
      return true;
    }
    return false;
  }
}

enum SelectionType { START_DATE, END_DATE }

class _CalendarStateBuilder extends StatesRebuilder {
  void rebuild() {
    rebuildStates(["$_CALENDAR_WIDGET_TAG"]);
  }
}

const String _CALENDAR_WIDGET_TAG = 'CAL_WIDGET';
