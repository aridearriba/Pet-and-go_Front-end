import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/event.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/calendar/calendarList.dart';
import 'package:petandgo/screens/calendar/newEvent.dart';
import 'package:petandgo/screens/calendar/viewEvent.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    String statusString = '';

    // Navigate to NewEvent
    nNewEvent(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewEvent(widget.user))
        );
    }

    // Navigate to Event
    nViewEvent(Evento event){
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
                actions: <Widget>[
                    IconButton(
                        padding: EdgeInsets.only(right: 15.0),
                        icon: Icon(Icons.sync, color: Colors.white),
                        onPressed: () =>
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildSyncDialog(context)
                            ),
                    ),
                    IconButton(
                        padding: EdgeInsets.only(right: 15.0),
                        icon: Icon(Icons.sync_disabled, color: Colors.white),
                        onPressed: () =>
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildDesSyncDialog(context)
                            ),
                    ),
                    PopupMenuButton(
                        //onSelected: /*(result) { setState(() { _selection = result; }); },*/,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            const PopupMenuItem(
                                value: "Hye",
                                child: Text('Working a lot harder'),
                            ),
                        ],
                    )
                ],
            ),
            body: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    _buildTableCalendar(),
                    Divider(),
                    Expanded(child: _buildEventList())
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
        List<Evento> listEvents = list.map((model) => Evento.fromJson(model)).toList();
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

    // Device calendar Variables
    bool deleted = false;
    bool calendarSelected = false;
    String calendarButtonText = 'Ver calendarios';
    String _currentCalendarID = '';
    DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
    StateSetter setStateDialog;

    Widget calendarButtonOrCalendar() {
        //Returns a calendar button that displays 'Select Calendar' or Returns a
        // Calendar Page if the button was pressed
        if (!calendarSelected) {
            return new FlatButton.icon(
                icon: Icon(
                    Icons.calendar_today,
                    color: Colors.amber[600],
                ),
                label: Text(calendarButtonText,
                    style: Theme.of(context).textTheme.body1),
                onPressed: () {
                    setStateDialog(() {
                        calendarSelected = true;
                    });
                });
        } else {
            return new Calendario(this._setCalendarCallback);
        }
    }

    void setDeviceCalendarCallback(DeviceCalendarPlugin deviceCalendar) {
        setState(() {
            _deviceCalendarPlugin = deviceCalendar;
        });
    }

    bool _setCalendarCallback(
        String calendarID, String calendarName, DeviceCalendarPlugin deviceCal) {
        setStateDialog(() {
            _currentCalendarID = calendarID;
            calendarButtonText = calendarName;
            _deviceCalendarPlugin = deviceCal;
            calendarSelected = false;
        });
    }


    Future _addEventsToCalendar(Map<DateTime, dynamic> mmaEvents) async {
        DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        mmaEvents.forEach( (date, events) async {
            for (var mmaEvent in events) {
                final eventTime = mmaEvent.id.date;
                final eventToCreate = new Event(_currentCalendarID);

                eventToCreate.title = mmaEvent.id.title;
                eventToCreate.start = eventTime;
                eventToCreate.description = mmaEvent.description;

                /*String mmaEventId = prefs.getString(mmaEvent.stringId);
                bool previouslyDeleted = prefs.getBool(mmaEvent.getPrefBoolKey());
                if (mmaEventId != null) {
                    if (previouslyDeleted != null && !previouslyDeleted){
                        //If the event already has an ID (was already added) and has not
                        //been previously deleted, set the ID on the event to update
                        eventToCreate.eventId = mmaEventId;
                    }
                }*/

                eventToCreate.end = eventTime.add(new Duration(hours: 1));
                final createEventResult =
                    await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);

                if (createEventResult.isSuccess &&
                    (createEventResult.data?.isNotEmpty ?? false)) {
                    prefs.setString(mmaEvent.stringId, createEventResult.data);
                    bool succes = true;
                }
            }
        });

        setState(() {
            statusString = 'Eventos añadidos a $calendarButtonText';
        });
    }

    Future _deleteEventsFromCalendar(Map<DateTime, dynamic> mmaEvents) async {

        SharedPreferences prefs = await SharedPreferences.getInstance();

        mmaEvents.forEach( (date, events) async {
            for (var mmaEvent in events) {
                final eventToCreate = new Event(_currentCalendarID);
                String mmaEventId = prefs.getString(mmaEvent.stringId);
                if (mmaEventId != null) {
                    eventToCreate.eventId = mmaEventId;
                    final createEventResult =
                        await _deviceCalendarPlugin.deleteEvent(
                        _currentCalendarID, eventToCreate.eventId);
                    /*if (createEventResult.isSuccess) {
                        prefs.setBool(mmaEvent.getPrefBoolKey(), true);
                    }*/
                }
            }
        });

        setState(() {
            statusString = 'Evento eliminado';
        });
    }

    Widget _buildSyncDialog(BuildContext context) {
        return AlertDialog(
            title:
                Text('Selecciona un calendario para sincronizar',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(
                            fontSize: 18
                        ),
                ),
            content:
                StatefulBuilder(  // You need this, notice the parameters below:
                    builder: (BuildContext context, StateSetter setState) {
                        setStateDialog = setState;
                        return ConstrainedBox(
                            constraints:
                                BoxConstraints(
                                    maxHeight: 130.0,
                                    maxWidth: 60.0,
                                    minHeight: 130.0
                                ),
                            child: calendarButtonOrCalendar(),
                        );
                    }
                ),
            actions: <Widget>[
                MaterialButton
                    (
                    child: Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                ),
                MaterialButton(
                    child: Text("Sincronizar"),
                    onPressed: () {
                        if (!calendarSelected) {
                            _addEventsToCalendar(_events);
                            Navigator.pop(context);
                        }
                    }
                ),
            ],
        );
    }
    Widget _buildDesSyncDialog(BuildContext context) {
        return AlertDialog(
            title:
            Text('Selecciona un calendario para desincronizar',
                textAlign: TextAlign.center,
                style:
                TextStyle(
                    fontSize: 18
                ),
            ),
            content:
            StatefulBuilder(  // You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
                    setStateDialog = setState;
                    return ConstrainedBox(
                        constraints:
                        BoxConstraints(
                            maxHeight: 130.0,
                            maxWidth: 60.0,
                            minHeight: 130.0
                        ),
                        child: calendarButtonOrCalendar(),
                    );
                }
            ),
            actions: <Widget>[
                MaterialButton
                    (
                    child: Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                ),
                MaterialButton(
                    child: Text("Desincronizar"),
                    onPressed: () {
                        if (!calendarSelected) {
                            _deleteEventsFromCalendar(_events);
                            Navigator.pop(context);
                        }
                    }
                ),
            ],
        );
    }
}
