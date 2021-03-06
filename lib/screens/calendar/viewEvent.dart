import 'dart:io';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/event.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/calendar/calendar.dart';
import 'package:petandgo/screens/calendar/editEvent.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ViewEvent extends StatefulWidget {
    ViewEvent(this.user, this.event, this._deviceCalendarPlugin, this._currentCalendarID);
    User user;
    Evento event;
    String _currentCalendarID;
    DeviceCalendarPlugin _deviceCalendarPlugin;


    @override
    _viewEventState createState() => _viewEventState();
}

class _viewEventState extends State<ViewEvent>{

    // Navigate to Calendari
    nCalendar(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Calendari(widget.user))
        );
    }
    // Navigate to EditEvent
    nEditEvent(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EditEvent(widget.user, widget.event, widget._deviceCalendarPlugin, widget._currentCalendarID))
        );
    }

    var _statusCode;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    AppLocalizations.of(context).translate('calendar_view-event_title'),
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => nCalendar(),
                    )
                ],
            ),
            body: ListView(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 5, left: 30.0, right: 30.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        // Event
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                                            child: /*Expanded(
                                                child:*/ Text(
                                                    widget.event.title,
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20.0,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                ),
                                            //)
                                        ),
                                        // Fecha init
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.date_range,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + AppLocalizations.of(context).translate('calendar_new-event_init-date'),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 16.0,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                    )
                                                ]
                                            ),
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: Text(
                                                        '         ' + widget.event.dateIni.day.toString().padLeft(2, '0') + '.  ' +
                                                            widget.event.dateIni.month.toString().padLeft(2, '0') + '.  ' +
                                                            widget.event.dateIni.year.toString() + '     ' +
                                                            widget.event.dateIni.hour.toString().padLeft(2, '0') + '. ' +
                                                            widget.event.dateIni.minute.toString().padLeft(2, '0') + ' h',
                                                        style: TextStyle(
                                                            color: Colors.black87,
                                                            fontSize: 16.0,
                                                        ),
                                                        textAlign: TextAlign.center,
                                            ),
                                        ),
                                        // Fecha end
                                        Padding (
                                            padding: const EdgeInsets.only(top: 20.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.date_range,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + AppLocalizations.of(context).translate('calendar_new-event_end-date'),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 16.0,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                    )
                                                ]
                                            ),
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: Text(
                                                '         ' + widget.event.dateEnd.day.toString().padLeft(2, '0') + '.  ' +
                                                    widget.event.dateEnd.month.toString().padLeft(2, '0') + '.  ' +
                                                    widget.event.dateEnd.year.toString() + '     ' +
                                                    widget.event.dateEnd.hour.toString().padLeft(2, '0') + '. ' +
                                                    widget.event.dateEnd.hour.toString().padLeft(2, '0') + ' h',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.0,
                                                ),
                                                textAlign: TextAlign.center,
                                            ),
                                        ),
                                        // description
                                        Padding (
                                            padding: const EdgeInsets.only(top: 30.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.description,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + AppLocalizations.of(context).translate('calendar_new-event_description'),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 16
                                                        ),
                                                    )
                                                ],
                                            )
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 10.0, left: 35, right: 10),
                                            child: Text(
                                                        widget.event.description,
                                                        style: TextStyle(
                                                            color: Colors.black87,
                                                            fontSize: 16
                                                        ),
                                                    )
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 30.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.notifications,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + AppLocalizations.of(context).translate('calendar_view-event_notifications'),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 16
                                                        ),
                                                    )
                                                ],
                                            )
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 10.0, left: 30, bottom: 30),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        widget.event.notifications ? Icons.check : Icons.close,
                                                        color: widget.event.notifications ? Colors.green : Colors.redAccent,
                                                    ),
                                                    Text(
                                                        widget.event.notifications ? '   ' + AppLocalizations.of(context).translate('calendar_new-event_reminder') : '   ' + AppLocalizations.of(context).translate('calendar_view-event_no-reminders'),
                                                        style: TextStyle(
                                                            color: Colors.black87,
                                                            fontSize: 16
                                                        ),
                                                    )
                                                ],
                                            )
                                        ),
                                    ],
                                ),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                    Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: FloatingActionButton.extended(
                                            heroTag: "editEvent",
                                            icon: Icon(Icons.edit, color: Colors.white),
                                            backgroundColor: Colors.green,
                                            label: Text(AppLocalizations.of(context).translate('calendar_view-event_edit')),
                                            onPressed: () {
                                                nEditEvent();
                                            }
                                        )
                                    ),
                                 Padding(
                                        padding: EdgeInsets.only(top:20),
                                        child: FloatingActionButton.extended(
                                            heroTag: "deleteEvent",
                                            icon: Icon(Icons.delete, color: Colors.white),
                                            backgroundColor: Colors.redAccent,
                                            label: Text(AppLocalizations.of(context).translate('calendar_view-event_delete')),
                                            onPressed: () {
                                                deleteEvent().whenComplete(nCalendar);
                                            }
                                        )
                                    ),
                                 ])
                            ],
                        ),
                    ),
                ]
            ),
        );
    }

    Future<void> deleteEvent() async{
        var email = widget.user.email;
        var id = widget.event.id.toString();
        final http.Response response = await http.delete(new Uri.http("petandgo.herokuapp.com", "/api/calendario/" + email + "/eventos/" + id),
            headers: <String, String> {
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
        );
        _deleteOneEventFromCalendar(widget.event);
    }

    Future _deleteOneEventFromCalendar(Evento event) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        final eventToCreate = new Event(widget._currentCalendarID);
        String eventId = prefs.getString(event.id.toString());
        if (eventId != null) {
            eventToCreate.eventId = eventId;
            await widget._deviceCalendarPlugin.deleteEvent(widget._currentCalendarID, eventToCreate.eventId);
        }
    }
}