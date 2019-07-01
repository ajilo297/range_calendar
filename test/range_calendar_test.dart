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

  test('Is Date in range', () {
    DateTime d1 = DateTime(2019, 5, 16);
    DateTime d2 = DateTime(2019, 5, 11);
    DateTime d3 = DateTime(2019, 5, 26);

    expect(RangeCalendarState.isDateInRange(d1, d2, d3), true);

    DateTime d4 = DateTime(2019, 5, 16);
    DateTime d5 = DateTime(2019, 5, 16);
    DateTime d6 = DateTime(2019, 5, 26);

    expect(RangeCalendarState.isDateInRange(d4, d5, d6), true);

    DateTime d7 = DateTime(2019, 5, 26);
    DateTime d8 = DateTime(2019, 5, 11);
    DateTime d9 = DateTime(2019, 5, 26);

    expect(RangeCalendarState.isDateInRange(d7, d8, d9), true);

    DateTime d10 = DateTime(2019, 5, 10);
    DateTime d11 = DateTime(2019, 5, 11);
    DateTime d12 = DateTime(2019, 5, 26);

    expect(RangeCalendarState.isDateInRange(d10, d11, d12), false);

    DateTime d13 = DateTime(2019, 5, 27);
    DateTime d14 = DateTime(2019, 5, 11);
    DateTime d15 = DateTime(2019, 5, 26);

    expect(RangeCalendarState.isDateInRange(d13, d14, d15), false);

    DateTime d16 = DateTime(2019, 6, 27);
    DateTime d17 = DateTime(2019, 5, 11);
    DateTime d18 = DateTime(2019, 5, 26);

    expect(RangeCalendarState.isDateInRange(d16, d17, d18), false);
  });
}
