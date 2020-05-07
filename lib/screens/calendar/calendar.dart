import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petandgo/model/event.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/calendar/newEvent.dart';
import 'package:petandgo/screens/calendar/viewEvent.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

// Example holidays
final Map<DateTime, List> _holidays = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2020, 4, 22): ['Easter Monday'],
};

class Calendari extends StatefulWidget {
    Calendari(this.user);
    final User user;

    @override
    _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendari> with TickerProviderStateMixin {
    Map<DateTime, List> _events;
    List _selectedEvents;
    AnimationController _animationController;
    CalendarController _calendarController;

    // Navigate to NewEvent
    nNewEvent(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewEvent(widget.user))
        );
    }

    // Navigate to Event
    nViewEvent(Event event){
        EventId eventID = event.id;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ViewEvent(widget.user, event))
        );
    }

    @override
    void initState() {
        initializeDateFormatting();
        super.initState();
        final _selectedDay = DateTime.now();

        _events = {};
        _selectedEvents = _events[_selectedDay] ?? [];
        getEvents().whenComplete(() {
            setState(() {
                _selectedEvents = _events[_selectedDay] ?? [];
            });
        });
        _calendarController = CalendarController();

        _animationController = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 400),
        );

        _animationController.forward();
    }

    @override
    void dispose() {
        _animationController.dispose();
        _calendarController.dispose();
        super.dispose();
    }

    void _onDaySelected(DateTime day, List events) {
        print('CALLBACK: _onDaySelected');
        setState(() {
            _selectedEvents = events;
        });
    }

    void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
        print('CALLBACK: _onVisibleDaysChanged');
    }

    void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
        print('CALLBACK: _onCalendarCreated');
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Calendario',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
            body: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    _buildTableCalendar(),
                    Divider(),
                    Expanded(child: _buildEventList()),
                ],
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () => nNewEvent(),
            ),
        );
    }

    Map<CalendarFormat, String> formats = {
        CalendarFormat.month: 'Mes',
        CalendarFormat.week: 'Semana',
    };

    // Simple TableCalendar configuration (using Styles)
    Widget _buildTableCalendar() {
        return TableCalendar(
            locale: 'es_ES',
            availableCalendarFormats: formats,
            calendarController: _calendarController,
            events: _events,
            holidays: _holidays,
            initialCalendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
                selectedColor: Color.fromRGBO(63, 202, 12, 1),
                todayColor: Color.fromRGBO(63, 202, 12, 0.4),
                markersColor: Colors.black54,
                outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
                centerHeaderTitle: true,formatButtonDecoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false
            ),
            onDaySelected: _onDaySelected,
            onVisibleDaysChanged: _onVisibleDaysChanged,
            onCalendarCreated: _onCalendarCreated,
        );
    }

    Widget _buildEventList() {
        return ListView(
            children: _selectedEvents
                .map((event) => Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.8),
                    borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                    title: Text(event.id.title),
                    onTap: () => nViewEvent(event),
                ),
            ))
                .toList(),
        );
    }

    Future<void> getEvents() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/" + email + "/eventos"));
        Iterable list = json.decode(response.body);
        List<Event> listEvents = list.map((model) => Event.fromJson(model)).toList();
        _events = {};

        listEvents.forEach((e) {
            var data = new DateTime(e.id.date.year, e.id.date.month, e.id.date.day);

            if (_events[data] != null){
                _events[data].add(e);
            }
            else{
                List<dynamic> list = new List();
                list.add(e);
                _events[data] = list;
            }
        });
    }
}
