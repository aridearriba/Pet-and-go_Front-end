import 'package:flutter/material.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/calendar/newEvent.dart';
import 'package:petandgo/screens/calendar/viewEvent.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

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
    nViewEvent(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ViewEvent(widget.user))
        );
    }

    @override
    void initState() {
        initializeDateFormatting();
        super.initState();
        final _selectedDay = DateTime.now();

        _events = {
            DateTime(2020, 5, 17, 12, 22) : ['Event ARI'],
            _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
            _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
            _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
            _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
            _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
            _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
            _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
            _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
            _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
            _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
            _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
            _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
            _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
            _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
            _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
        };

        _selectedEvents = _events[_selectedDay] ?? [];
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
                    title: Text(event.toString()),
                    onTap: () => nViewEvent() //print('$event tapped!'),
                ),
            ))
                .toList(),
        );
    }
}
