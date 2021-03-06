import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:petandgo/model/event.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/calendar/calendar.dart';
import 'package:petandgo/screens/menu/menu.dart';

import '../../main.dart';

class NewEvent extends StatelessWidget {
    NewEvent(this.user);
    User user;


    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                FocusScopeNode actualFocus = FocusScope.of(context);

                if(!actualFocus.hasPrimaryFocus){
                    actualFocus.unfocus();
                }

            },
            child: Scaffold(
                drawer: Menu(user),
                appBar: AppBar(
                    title: Text(AppLocalizations.of(context).translate('calendar_new-event_title'), style: TextStyle(color: Colors.white)),
                    iconTheme: IconThemeData(
                        color: Colors.white,
                    ),
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Calendari(user))
                            ),
                        )
                    ],
                ),
                body: NewEventForm(user),
            ),
        );
    }
}

// Creamos un Widget que sea un Form
class NewEventForm extends StatefulWidget {
    NewEventForm(this.user);
    User user;
    @override
    MyCustomFormState createState() => MyCustomFormState();
}

// Esta clase contendrá los datos relacionados con el formulario.
class MyCustomFormState extends State<NewEventForm> {

    final _formKey = GlobalKey<FormState>();

    final _controladorTitle = TextEditingController();
    final _controladorDateIni = TextEditingController();
    final _controladorHourIni = TextEditingController();
    final _controladorDateEnd = TextEditingController();
    final _controladorHourEnd = TextEditingController();
    final _controladorDescription = TextEditingController();

    var _statusCode;
    DateTime _dateIni, _dateEnd;
    TimeOfDay _timeIni, _timeEnd;

    bool notificationsOn;

    // Navigate to Calendari
    nCalendar(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Calendari(widget.user))
        );
    }

    @override
    void initState() {
        notificationsOn = false;

        _dateIni = DateTime.now();
        _dateEnd = DateTime.now();
        _timeIni = TimeOfDay.fromDateTime(_dateIni);
        _timeEnd =  _timeIni.replacing(hour: _timeIni.hour + 1);

        _controladorDateIni.text = _dateIni.day.toString().padLeft(2, '0') + ". " + _dateIni.month.toString().padLeft(2, '0') + ". " + _dateIni.year.toString();
        _controladorDateEnd.text = _dateEnd.day.toString().padLeft(2, '0') + ". " + _dateEnd.month.toString().padLeft(2, '0') + ". " + _dateEnd.year.toString();
        _controladorHourIni.text = _timeIni.hour.toString().padLeft(2, '0') + ':' + _timeIni.minute.toString().padLeft(2, '0');
        _controladorHourEnd.text = _timeEnd.hour.toString().padLeft(2, '0') + ':' + _timeEnd.minute.toString().padLeft(2, '0');

        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    // nombre
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('calendar_new-event_event-title')
                            ),
                            controller: _controladorTitle,
                            keyboardType: TextInputType.text,
                            validator: (value){
                                if(value.isEmpty){
                                    return AppLocalizations.of(context).translate('calendar_new-event_empty-title');
                                }
                                return null;
                            },
                        ),
                    ),
                    Divider(indent: 15, endIndent: 15),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: InkWell(
                            onTap: () async {
                                _dateIni = await showDatePicker(
                                    context: context,
                                    initialDate: _dateIni == null ? DateTime.now() : _dateIni,
                                    firstDate: DateTime(DateTime.now().year - 20),
                                    lastDate: DateTime(DateTime.now().year + 1)
                                );
                                _controladorDateIni.text = _dateIni.day.toString().padLeft(2, '0') + ". " + _dateIni.month.toString().padLeft(2, '0') + ". " + _dateIni.year.toString();
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: AppLocalizations.of(context).translate('calendar_new-event_init-date')),
                                    controller: _controladorDateIni,
                                    validator: (value){
                                        if(value.isEmpty){
                                            return AppLocalizations.of(context).translate('calendar_new-event_empty-date');
                                        }
                                        return null;
                                    },
                                    onSaved: (String val) {},
                                ),
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: InkWell(
                            onTap: () async {
                                _timeIni = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                                );
                                _controladorHourIni.text = _timeIni.hour.toString().padLeft(2, '0') + ':' + _timeIni.minute.toString().padLeft(2, '0');
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: AppLocalizations.of(context).translate('calendar_new-event_init-time')),
                                    controller: _controladorHourIni,
                                    validator: (value){
                                        if(value.isEmpty){
                                            return AppLocalizations.of(context).translate('calendar_new-event_empty-time');
                                        }
                                        return null;
                                    },
                                    onSaved: (String val) {},
                                ),
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: InkWell(
                            onTap: () async {
                                _dateEnd = await showDatePicker(
                                    context: context,
                                    initialDate: _dateIni == null ? DateTime.now() : _dateIni,
                                    firstDate: DateTime(DateTime.now().year - 20),
                                    lastDate: DateTime(DateTime.now().year + 1)
                                );
                                _controladorDateEnd.text = _dateEnd.day.toString().padLeft(2, '0') + ". " + _dateEnd.month.toString().padLeft(2, '0') + ". " + _dateEnd.year.toString();
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: AppLocalizations.of(context).translate('calendar_new-event_end-date')),
                                    controller: _controladorDateEnd,
                                    validator: (value){
                                        if(value.isEmpty){
                                            return AppLocalizations.of(context).translate('calendar_new-event_empty-date');
                                        }
                                        if(_dateEnd.isBefore(_dateIni)){
                                            return AppLocalizations.of(context).translate('calendar_new-event_before-dates');
                                        }
                                        return null;
                                    },
                                    onSaved: (String val) {},
                                ),
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: InkWell(
                            onTap: () async {
                                _timeEnd = await showTimePicker(
                                    context: context,
                                    initialTime: _timeIni == null ? TimeOfDay(hour: 12, minute: 0) : _timeIni.replacing(hour: _timeIni.hour + 1)
                                );
                                _controladorHourEnd.text = _timeEnd.hour.toString().padLeft(2, '0') + ':' + _timeEnd.minute.toString().padLeft(2, '0');
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: AppLocalizations.of(context).translate('calendar_new-event_end-time')),
                                    controller: _controladorHourEnd,
                                    validator: (value){
                                        if(value.isEmpty){
                                            return AppLocalizations.of(context).translate('calendar_new-event_empty-time');
                                        }
                                        if((_dateIni.day ==  _dateEnd.day && _dateIni.month == _dateEnd.month && _dateIni.year == _dateEnd.year) &&
                                            ((_timeEnd.hour == _timeIni.hour && _timeEnd.minute <= _timeIni.minute) ||
                                                (_timeEnd.hour < _timeIni.hour))){
                                            return AppLocalizations.of(context).translate('calendar_new-event_before-times');
                                        }
                                        return null;
                                    },
                                    onSaved: (String val) {},
                                ),
                            ),
                        ),
                    ),
                    Divider(indent: 15, endIndent: 15),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            maxLines: 5,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('calendar_new-event_description'),
                                alignLabelWithHint: true,
                            ),
                            controller: _controladorDescription,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 35),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                Text(
                                    AppLocalizations.of(context).translate('calendar_new-event_reminder'),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54
                                    )
                                ),
                                Switch(
                                    value: notificationsOn,
                                    onChanged: (value) {
                                        setState(() {
                                            notificationsOn = value;
                                        });
                                    },
                                    activeColor: Colors.green,
                                ),
                            ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
                        child: RaisedButton(
                            onPressed: () {
                                if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                        addEvent().whenComplete(
                                            () {
                                                    if (_statusCode == 201) {
                                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate('calendar_new-event_success'))));
                                                        if (notificationsOn) _scheduleNotification();
                                                        nCalendar();
                                                    }
                                                    else {
                                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate('calendar_new-event_fail'))));
                                                    }
                                                }
                                        );
                                }
                            },
                            child: Text(AppLocalizations.of(context).translate('calendar_new-event_add')),
                        ),
                    ),
                ],
            ),
        );
    }

    Evento _event;
    Future<void> addEvent() async{
        var email = widget.user.email;
        var eventDateIni = new DateTime(_dateIni.year, _dateIni.month, _dateIni.day, _timeIni.hour, _timeIni.minute);
        var dateStringIni = eventDateIni.toIso8601String();
        var eventDateEnd = new DateTime(_dateEnd.year, _dateEnd.month, _dateEnd.day, _timeEnd.hour, _timeEnd.minute);
        var dateStringEnd = eventDateEnd.toIso8601String();

        http.Response response = await http.post(new Uri.http("petandgo.herokuapp.com", "/api/calendario/" + email + "/eventos"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString()
            },
            body: jsonEncode({
                'titulo': _controladorTitle.text,
                'usuario': widget.user.email,
                'fecha': dateStringIni,
                'fechaFin': dateStringEnd,
                'descripcion': _controladorDescription.text,
                'notificaciones': notificationsOn
            }));
        _statusCode = response.statusCode;
        _event = Evento.fromJson(jsonDecode(response.body));
    }

    Future _scheduleNotification() async {
        DateTime date = DateTime(_dateIni.year, _dateIni.month, _dateIni.day, _timeIni.hour, _timeIni.minute);
        DateTime scheduledNotificationDateTime = date.subtract(Duration(hours: 1));

        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.Max, priority: Priority.High);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

        String data = AppLocalizations.of(context).translate('notifications_today') + '  ' + _controladorHourIni.text;
        String text = '[' + widget.user.email + ']  ' + _controladorTitle.text;

        await MyApp.flutterLocalNotificationsPlugin.schedule(
            _event.id,
            data,
            text,
            scheduledNotificationDateTime,
            platformChannelSpecifics,
            payload: 'Default_Sound',
            androidAllowWhileIdle: true
        );
    }

}