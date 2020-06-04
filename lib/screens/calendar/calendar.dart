import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/event.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/calendar/calendarList.dart';
import 'package:petandgo/screens/calendar/newEvent.dart';
import 'package:petandgo/screens/calendar/viewEvent.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;


class Calendari extends StatefulWidget {
    Calendari(this.user);
    final User user;

    @override
    _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendari> with TickerProviderStateMixin {
    // Variables
    Map<DateTime, List> _events;
    List _selectedEvents;
    AnimationController _animationController;
    CalendarController _calendarController;
    String statusString = '';
    var _scaffoldKey = new GlobalKey<ScaffoldState>();

    // Navigate to NewEvent
    nNewEvent(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewEvent(widget.user))
        );
    }

    // Navigate to Event
    nViewEvent(Evento event){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ViewEvent(widget.user, event, _deviceCalendarPlugin, _currentCalendarID))
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


    // main build
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: _scaffoldKey,
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    AppLocalizations.of(context).translate('calendar_calendar_title'),
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                actions: <Widget> [
                    PopupMenuButton<int>(
                        itemBuilder: (scaffoldContext) => [
                            PopupMenuItem(
                                value: 1,
                                child:  Row(
                                    children: <Widget>[
                                        Icon(
                                            Icons.sync,
                                            color: Colors.black54,
                                        ),
                                        Text("   " + AppLocalizations.of(context).translate('calendar_calendar_sync')),
                                    ],
                                ),
                            ),
                            PopupMenuItem(
                                value: 2,
                                child:  Row(
                                    children: <Widget>[
                                        Icon(
                                            Icons.sync_disabled,
                                            color: Colors.black54,
                                        ),
                                        Text("   " + AppLocalizations.of(context).translate('calendar_calendar_sync-disabled')),
                                    ],
                                ),
                            ),
                        ],
                        onSelected: (value) {
                            if (value == 1) showDialog(context: context, builder: (BuildContext context) => _buildSyncDialog(context));
                            else if (value == 2) showDialog(context: context, builder: (BuildContext context) => _buildDesSyncDialog(context));
                        },
                        icon: Icon(Icons.more_vert),
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


    // TableCalendar configuration
    Widget _buildTableCalendar() {
        return TableCalendar(
            locale: AppLocalizations.of(context).translate('calendar_calendar_locale'),
            availableCalendarFormats: {
                CalendarFormat.month: AppLocalizations.of(context).translate('calendar_calendar_month'),
                CalendarFormat.week: AppLocalizations.of(context).translate('calendar_calendar_week')
            },
            calendarController: _calendarController,
            events: _events,
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

    // Show events
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
                    title: Text(
                                event.dateIni.day.toString() + ' ' + _monthName(event.dateIni.month) + ' ' +
                                event.dateIni.hour.toString().padLeft(2, '0') + ':' + event.dateIni.minute.toString().padLeft(2, '0') + '  -  ' +
                                event.dateEnd.day.toString() + ' ' + _monthName(event.dateEnd.month) + ' ' +
                                event.dateEnd.hour.toString().padLeft(2, '0') + ':' + event.dateEnd.minute.toString().padLeft(2, '0') + '   ' ,
                                style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black45
                                ),
                            ),
                    subtitle: Text(
                                event.title,
                                style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                            ),
                    onTap: () => nViewEvent(event),
                ),
            ))
                .toList(),
        );
    }

    String _monthName(int month)
    {
        if (month == 1) return AppLocalizations.of(context).translate('calendar_calendar_january');
        if (month == 2) return AppLocalizations.of(context).translate('calendar_calendar_february');
        if (month == 3) return AppLocalizations.of(context).translate('calendar_calendar_march');
        if (month == 4) return AppLocalizations.of(context).translate('calendar_calendar_april');
        if (month == 5) return AppLocalizations.of(context).translate('calendar_calendar_may');
        if (month == 6) return AppLocalizations.of(context).translate('calendar_calendar_june');
        if (month == 7) return AppLocalizations.of(context).translate('calendar_calendar_july');
        if (month == 8) return AppLocalizations.of(context).translate('calendar_calendar_august');
        if (month == 9) return AppLocalizations.of(context).translate('calendar_calendar_september');
        if (month == 10) return AppLocalizations.of(context).translate('calendar_calendar_october');
        if (month == 11) return AppLocalizations.of(context).translate('calendar_calendar_november');
        return AppLocalizations.of(context).translate('calendar_calendar_december');
    }

    // GET Events from User
    Future<void> getEvents() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http("petandgo.herokuapp.com", "/api/calendario/" + email + "/eventos"));
        Iterable list = json.decode(response.body);
        List<Evento> listEvents = list.map((model) => Evento.fromJson(model)).toList();
        _events = {};

        listEvents.forEach((e) {
            DateTime dataIni = new DateTime(e.dateIni.year, e.dateIni.month, e.dateIni.day);
            DateTime dataEnd = new DateTime(e.dateEnd.year, e.dateEnd.month, e.dateEnd.day);
            DateTime data = dataIni;

            while(data.compareTo(dataEnd) <= 0) {
                if (_events[data] != null){
                    _events[data].add(e);
                }
                else {
                    List<dynamic> list = new List();
                    list.add(e);
                    _events[data] = list;
                }

                data = data.add(new Duration(days: 1));
            }
        });

        _events.forEach((date, evs) => evs.sort(((a,b) => a.dateIni.compareTo(b.dateIni))));
    }


    // Device calendar Variables
    bool deleted = false;
    bool calendarSelected = false;
    String calendarButtonText;
    String _currentCalendarID = '';
    DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
    StateSetter setStateDialog;

    Widget calendarButtonOrCalendar() {
        // Returns a calendar button or returns the device's calendar if the button was pressed
        if (!calendarSelected) {
            return new FlatButton.icon(
                icon: Icon(
                    Icons.calendar_today,
                    color: Colors.amber[600],
                ),
                label: Text(calendarButtonText == null ? AppLocalizations.of(context).translate('calendar_calendar_see-calendars') : calendarButtonText,
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


    Future _addEventsToCalendar(Map<DateTime, dynamic> allEvents) async {
        DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        allEvents.forEach( (date, events) async {
            for (var event in events) {
                final eventTime = event.dateIni;
                final eventToCreate = new Event(_currentCalendarID);

                eventToCreate.title = event.title;
                eventToCreate.start = eventTime;
                eventToCreate.description = event.description;

                eventToCreate.end = event.dateEnd;
                final createEventResult = await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);

                if (createEventResult.isSuccess &&
                    (createEventResult.data?.isNotEmpty ?? false)) {
                    prefs.setString(event.id.toString(), createEventResult.data);
                }
            }
        });
    }

    Future _deleteEventsFromCalendar(Map<DateTime, dynamic> allEvents) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        allEvents.forEach( (date, events) async {
            for (var event in events) {
                final eventToCreate = new Event(_currentCalendarID);
                String eventId = prefs.getString(event.id.toString());
                if (eventId != null) {
                    eventToCreate.eventId = eventId;
                    await _deviceCalendarPlugin.deleteEvent(_currentCalendarID, eventToCreate.eventId);
                }
            }
        });
    }

    Widget _buildSyncDialog(BuildContext context) {
        return AlertDialog(
            title:
                Text(AppLocalizations.of(context).translate('calendar_calendar_select-sync'),
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
                    child: Text(AppLocalizations.of(context).translate('alert-dialog_cancel')),
                    onPressed: () => Navigator.pop(context),
                ),
                MaterialButton(
                    child: Text(AppLocalizations.of(context).translate('calendar_calendar_sync')),
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
            Text(AppLocalizations.of(context).translate('calendar_calendar_select-disable-sync'),
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
                    child: Text(AppLocalizations.of(context).translate('alert-dialog_cancel')),
                    onPressed: () => Navigator.pop(context),
                ),
                MaterialButton(
                    child: Text(AppLocalizations.of(context).translate('calendar_calendar_sync-disabled')),
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
