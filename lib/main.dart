import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(AppointmentRemove());

class AppointmentRemove extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppointmentRemoveFromCalendar(),
    );
  }
}

class AppointmentRemoveFromCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScheduleExample();
}

List<String> views = <String>[
  'Day',
  'Week',
  'WorkWeek',
  'Month',
  'Timeline Day',
  'Timeline Week',
  'Timeline WorkWeek'
];

class ScheduleExample extends State<AppointmentRemoveFromCalendar> {
  CalendarView _calendarView;
  List<Meeting> meetings;
  MeetingDataSource events;
  Meeting _selectedAppointment;

  @override
  void initState() {
    _calendarView = CalendarView.month;
    _selectedAppointment = null;
    meetings = <Meeting>[];
    events = _getCalendarDataSource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.calendar_today),
          itemBuilder: (BuildContext context) => views.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList(),
          onSelected: (String value) {
            setState(() {
              if (value == 'Day') {
                _calendarView = CalendarView.day;
              } else if (value == 'Week') {
                _calendarView = CalendarView.week;
              } else if (value == 'WorkWeek') {
                _calendarView = CalendarView.workWeek;
              } else if (value == 'Month') {
                _calendarView = CalendarView.month;
              } else if (value == 'Timeline Day') {
                _calendarView = CalendarView.timelineDay;
              } else if (value == 'Timeline Week') {
                _calendarView = CalendarView.timelineWeek;
              } else if (value == 'Timeline WorkWeek') {
                _calendarView = CalendarView.timelineWorkWeek;
              }
            });
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 30,
            child: FlatButton(
              child: Text('Remove appointment'),
              onPressed: () {
                if (_selectedAppointment != null) {
                  events.appointments.removeAt(events.appointments
                      .indexOf(_selectedAppointment));
                  events.notifyListeners(
                      CalendarDataSourceAction.remove,
                      <Meeting>[]..add(_selectedAppointment));
                }
              },
            ),
          ),
          Container(
            height: 500,
            child: SfCalendar(
              view: _calendarView,
              initialSelectedDate: DateTime.now(),
              monthViewSettings: MonthViewSettings(showAgenda: true),
              dataSource: events,
              onTap: calendarTapped,
            ),
          ),
        ],
      ),
    ));
  }

  MeetingDataSource _getCalendarDataSource() {
    meetings.add(Meeting(
      from: DateTime.now(),
      to: DateTime.now().add(const Duration(hours: 1)),
      eventName: 'Meeting',
      background: Colors.pink,
      isAllDay: true,
    ));
    meetings.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 4, days: -1)),
      to: DateTime.now().add(const Duration(hours: 5, days: -1)),
      eventName: 'Release Meeting',
      background: Colors.lightBlueAccent,
    ));
    meetings.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 2, days: -2)),
      to: DateTime.now().add(const Duration(hours: 4, days: -2)),
      eventName: 'Performance check',
      background: Colors.amber,
    ));
    meetings.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 6, days: -3)),
      to: DateTime.now().add(const Duration(hours: 7, days: -3)),
      eventName: 'Support',
      background: Colors.green,
    ));
    meetings.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 6, days: 2)),
      to: DateTime.now().add(const Duration(hours: 7, days: 2)),
      eventName: 'Retrospective',
      background: Colors.purple,
    ));
    return MeetingDataSource(meetings);
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement==CalendarElement.agenda || calendarTapDetails.targetElement==CalendarElement.appointment) {
      final Meeting appointment = calendarTapDetails.appointments[0];
      _selectedAppointment = appointment;
    }

  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  List<Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  String getStartTimeZone(int index) {
    return source[index].startTimeZone;
  }

  @override
  String getEndTimeZone(int index) {
    return source[index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }
}

class Meeting {
  Meeting(
      {@required this.from,
      @required this.to,
      this.background = Colors.green,
      this.isAllDay = false,
      this.eventName = '',
      this.startTimeZone = '',
      this.endTimeZone = '',
      this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
