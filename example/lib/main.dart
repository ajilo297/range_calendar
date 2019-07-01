import 'package:flutter/material.dart';
import 'package:range_calendar/range_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.redAccent,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RangeCalendarState> _calendarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Range Calendar'),
      ),
      body: Center(
        child: RangeCalendar(
          key: _calendarKey,
          currentDateTime: DateTime(2019, 6, 30),
          selectionStartDate: DateTime(2019, 6, 18),
          selectionEndDate: DateTime(2019, 6, 22),
          showMonthControls: true,
          highlightCurrentDate: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (_calendarKey.currentState.selectionType ==
            SelectionType.START_DATE) {
          _calendarKey.currentState.selectionType = SelectionType.END_DATE;
        } else {
          _calendarKey.currentState.selectionType = SelectionType.START_DATE;
        }
      }),
    );
  }
}
