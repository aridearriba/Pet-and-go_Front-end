import 'dart:convert';
import 'dart:io';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:petandgo/model/event.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/multilanguage/appLanguage.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/pets/pet.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/pets/newPet.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

class Settings extends StatefulWidget {
    Settings(this.user);
    User user;

    @override
    _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
{
    List<Mascota> _mascotas = new List<Mascota>();
    String language;

    nLogIn() {
        widget.user = null;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nHome() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(widget.user))
        );
    }

    nNewPet() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewPet(widget.user))
        );
    }

    nPet(Mascota mascota) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Pet(widget.user, mascota))
        );
    }

    nLogin() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    List<Evento> listEvents;

    @override
    void initState()  {
        getEvents().whenComplete(
            ()  {
                if (MyApp.calendarNotifications) _enableCalendarNotifications();
            }
        );
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        var appLanguage = Provider.of<AppLanguage>(context);

        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    AppLocalizations.of(context).translate('settings_title'),
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
            body: ListView(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                        child: Column(
                            children: <Widget>[
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        // USER
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Text(
                                                AppLocalizations.of(context).translate('settings_language'),
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 10.0, bottom: 40),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                        Icon(
                                                            Icons.language,
                                                            color: Colors.black54,
                                                        ),
                                                        Container(
                                                            width: 260,
                                                            height: 40,
                                                            child: DropdownButtonHideUnderline(
                                                                child: ButtonTheme(
                                                                    alignedDropdown: true,
                                                                    child: DropdownButton<String>(
                                                                        hint: _selectedLanguage(appLanguage.appLocal.languageCode),
                                                                        isExpanded: true,
                                                                        value: language,
                                                                        icon: Icon(Icons.arrow_drop_down),
                                                                        iconSize: 24,
                                                                        elevation: 16,
                                                                        style: TextStyle(color: Colors.black54),
                                                                        onChanged: (String newValue) {
                                                                            setState(() {
                                                                                language = newValue;
                                                                            });
                                                                            appLanguage.changeLanguage(Locale(language));
                                                                            if (MyApp.calendarNotifications) {
                                                                                _disableCalendarNotifications();
                                                                                _enableCalendarNotifications();
                                                                            }
                                                                        },
                                                                        items: <String>['es', 'ca', 'en'].map<DropdownMenuItem<String>>((String value) {
                                                                            return DropdownMenuItem<String>(
                                                                                value: value,
                                                                                child: _selectedLanguage(value),
                                                                            );
                                                                        }).toList(),
                                                                    ),
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                            ),
                                        ),
                                    ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        // USER
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Text(
                                                AppLocalizations.of(context).translate('settings_notifications'),
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                    Text(
                                                        AppLocalizations.of(context).translate('settings_calendar-notifications'),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black54
                                                        )
                                                    ),
                                                    Switch(
                                                        value: MyApp.calendarNotifications,
                                                        onChanged: (value) {
                                                            setState(() {
                                                                MyApp.calendarNotifications = value;
                                                            });
                                                            if (MyApp.calendarNotifications)  _enableCalendarNotifications();
                                                            else                              _disableCalendarNotifications();
                                                        },
                                                        activeColor: Colors.green,
                                                    ),
                                                ],
                                            )
                                        ),
                                    ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        // PETS
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                                            child: Text(
                                                AppLocalizations.of(context).translate('settings_account'),
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: GestureDetector(
                                                child: Row(
                                                    children: <Widget>[
                                                        Icon(
                                                            Icons.delete,
                                                            color: Colors.redAccent,
                                                        ),
                                                        Text(
                                                            '   ' + AppLocalizations.of(context).translate('settings_delete-account'),
                                                            style: TextStyle(
                                                                color: Colors.redAccent,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                onTap: () => _showAlertDialog()
                                            ),
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),
                ]
            ),
        );
    }

    Text _selectedLanguage(String languageCode) {
        if (languageCode == 'en') return Text(AppLocalizations.of(context).translate('settings_language-en'));
        else if (languageCode == 'es') return Text(AppLocalizations.of(context).translate('settings_language-es'));
        else if (languageCode == 'ca') return Text(AppLocalizations.of(context).translate('settings_language-ca'));
        return Text('. . .');
    }

    void _showAlertDialog() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(AppLocalizations.of(context).translate('settings_delete-account'), textAlign: TextAlign.center),
                    content: Text(AppLocalizations.of(context).translate('settings_delete-account-confirmation'), textAlign: TextAlign.center),
                    actions: <Widget>[
                        FlatButton(
                            child: Text(AppLocalizations.of(context).translate('alert-dialog_close'), style: TextStyle(color: Colors.black45),),
                            onPressed: () =>  Navigator.pop(context),
                        ),
                        FlatButton(
                            child: Text(AppLocalizations.of(context).translate('alert-dialog_accept'), style: TextStyle(color: Colors.redAccent),),
                            onPressed:  () => deleteAccount().whenComplete(
                                    () {
                                        Navigator.pop(context);
                                        nLogIn();
                                    }()),
                        ),
                    ],
                );
            }
        );
    }

    Future<void> deleteAccount() async{
        var email = widget.user.email;
        final http.Response response = await http.delete(new Uri.http(Global.apiURL, "/api/usuarios/" + email),
            headers: <String, String> {
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
        );
    }

    Future<List<Evento>> getEvents() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http("petandgo.herokuapp.com", "/api/calendario/" + email + "/eventos"));
        Iterable list = json.decode(response.body);
        listEvents = list.map((model) => Evento.fromJson(model)).toList();
    }

    Future _scheduleNotification(int id, String title, String body, DateTime scheduledDateTime) async{
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.Max, priority: Priority.High);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

        await MyApp.flutterLocalNotificationsPlugin.schedule(
            id,
            title,
            body,
            scheduledDateTime,
            platformChannelSpecifics,
            payload: 'Default_Sound',
            androidAllowWhileIdle: true
        );
    }

    Future _enableCalendarNotifications() async {
        listEvents.forEach((e) async {
            DateTime date = DateTime(e.dateIni.year, e.dateIni.month, e.dateIni.day, e.dateIni.hour, e.dateIni.minute);
            DateTime scheduledDateTime = date.subtract(Duration(hours: 1));

            String title = AppLocalizations.of(context).translate('notifications_today') + '  ' + e.dateIni.hour.toString().padLeft(2, '0') + ': ' + e.dateIni.minute.toString().padLeft(2, '0');
            String body = '[' + e.user + ']  ' + e.title;

            if (e.notifications) {
                if (date.isAfter(DateTime.now()))
                    _scheduleNotification(e.id, title, body, scheduledDateTime);
            }
        });
    }

    Future _disableCalendarNotifications() async {
        listEvents.forEach((e) async {
            if (e.notifications) await MyApp.flutterLocalNotificationsPlugin.cancel(e.id);
        });
    }
}