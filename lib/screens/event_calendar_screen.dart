import 'package:flutter/material.dart';
import 'package:mobilenew/screens/add_event_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobilenew/models/event.dart'; // Your event model
import 'package:mobilenew/resources/firestore_methods.dart'; // Your Firestore methods class

class EventCalendarScreen extends StatefulWidget {
  @override
  _EventCalendarScreenState createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
    fetchEvents();
  }

  fetchEvents() async {
    // Assume you have a method in your FirestoreMethods to fetch events
    List<Event> events = await FireStoreMethods().getEvents();
    Map<DateTime, List<Event>> tempEvents = {};
    for (var event in events) {
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (tempEvents[date] == null) tempEvents[date] = [];
      tempEvents[date]!.add(event);
    }
    setState(() {
      selectedEvents = tempEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Calendar"),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: focusedDay,
        calendarFormat: format,
        onFormatChanged: (CalendarFormat _format) {
          setState(() {
            format = _format;
          });
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (DateTime selectDay, DateTime focusDay) {
          setState(() {
            selectedDay = selectDay;
            focusedDay = focusDay;
          });
          // Functionality to show events for the selected day
        },
        selectedDayPredicate: (DateTime date) {
          return isSameDay(selectedDay, date);
        },
        eventLoader: (day) {
          return selectedEvents[day] ?? [];
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventPage()),
          ).then((_) {
            // Optional: Refresh the event list if you're not using a StreamBuilder
          });
        },
      ),
    );
  }
}
