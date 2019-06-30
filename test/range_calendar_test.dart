import 'package:flutter_test/flutter_test.dart';

import 'package:range_calendar/range_calendar.dart';

void main() {
  test('Number of days in month test', () {
    expect(RangeCalendarState.getNumberOfDaysInMonth(1, 2020), 31);
    expect(RangeCalendarState.getNumberOfDaysInMonth(2, 2020), 29);
    expect(RangeCalendarState.getNumberOfDaysInMonth(2, 2021), 28);
    expect(RangeCalendarState.getNumberOfDaysInMonth(3, 2020), 31);
    expect(RangeCalendarState.getNumberOfDaysInMonth(4, 2020), 30);
    expect(RangeCalendarState.getNumberOfDaysInMonth(5, 2020), 31);
    expect(RangeCalendarState.getNumberOfDaysInMonth(6, 2020), 30);
    expect(RangeCalendarState.getNumberOfDaysInMonth(7, 2020), 31);
    expect(RangeCalendarState.getNumberOfDaysInMonth(8, 2020), 31);
    expect(RangeCalendarState.getNumberOfDaysInMonth(9, 2020), 30);
    expect(RangeCalendarState.getNumberOfDaysInMonth(10, 2020), 31);
    expect(RangeCalendarState.getNumberOfDaysInMonth(11, 2020), 30);
    expect(RangeCalendarState.getNumberOfDaysInMonth(12, 2020), 31);
  });
}
