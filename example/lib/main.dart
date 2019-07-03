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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RangeCalendarState> _calendarKey = GlobalKey();
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 1,
        duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Range Calendar'),
      ),
      body: Center(
        child: RangeCalendar(
          key: _calendarKey,
          currentDateTime: DateTime.now(),
          showMonthControls: true,
          highlightCurrentDate: true,
          outMonthDateTextStyle: TextStyle(color: Colors.grey),
          margin: EdgeInsets.symmetric(vertical: 2),
          selectedDateColor: Colors.red.withAlpha(60),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_calendarKey.currentState.toggleCurrentDateSelection() ==
              SelectionType.START_DATE) {
            controller.forward(from: 0);
          } else {
            controller.reverse(from: 1);
          }
        },
        child: AnimatedIcon(
          icon: AnimatedIcons.search_ellipsis,
          progress: controller.view,
        ),
      ),
    );
  }
}
