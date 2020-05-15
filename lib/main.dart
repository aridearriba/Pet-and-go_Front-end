import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/user/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
    static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    static bool calendarNotifications;

    @override
    _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

    @override
    initState() {
        super.initState();

        MyApp.calendarNotifications = true;

        // notifications
        var initializationSettingsAndroid =
        new AndroidInitializationSettings('mipmap/ic_launcher');
        var initializationSettingsIOS = new IOSInitializationSettings();
        var initializationSettings = new InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS);
        MyApp.flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
        MyApp.flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Pet and Go',
            theme: ThemeData(
                primaryColor: Color.fromRGBO(63, 202, 12, 1),
            ),
            home: LogIn(),
        );
    }

    Future onSelectNotification(String payload) async {
        showDialog(
            context: context,
            builder: (_) {
                return new AlertDialog(
                    title: Text("PayLoad"),
                    content: Text("Payload : $payload"),
                );
            },
        );
    }
}