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
          currentDateTime: DateTime.now(),
          showMonthControls: true,
          highlightCurrentDate: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState((){
            if (_calendarKey.currentState.selectionType ==
            SelectionType.START_DATE) {
            _calendarKey.currentState.selectionType = SelectionType.END_DATE;
          } else {
            _calendarKey.currentState.selectionType = SelectionType.START_DATE;
          }
          });
        },
        child: (){
          if (_calendarKey.currentState?.selectionType ==
            SelectionType.START_DATE)
            return Icon(Icons.ac_unit);
          else 
            return Icon(Icons.access_time);
        }(),
      ),
    );
  }
}
