import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/user/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
    static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    @override
    _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {


    @override
    initState() {
        super.initState();
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
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

    /*@override
    Widget build(BuildContext context) {
        return new MaterialApp(
            home: new Scaffold(
                appBar: new AppBar(
                    title: new Text('Plugin example app'),
                ),
                body: new Center(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                            new SizedBox(
                                height: 30.0,
                            ),
                            new RaisedButton(
                                onPressed: _showNotificationWithDefaultSound,
                                child: new Text('Show Notification With Default Sound'),
                            ),
                            new SizedBox(
                                height: 30.0,
                            ),
                            new RaisedButton(
                                onPressed: _scheduleNotification,
                                child: new Text('Schedule notification -> in 10s'),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }*/

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

    // Method 2
    Future _showNotificationWithDefaultSound() async {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.Max, priority: Priority.High);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await MyApp.flutterLocalNotificationsPlugin.show(
            1,
            'Calendario',
            'Nombre del evento',
            platformChannelSpecifics,
            payload: 'Default_Sound',
        );
    }

    Future _scheduleNotification() async {
        var scheduledNotificationDateTime =
            new DateTime.now().add(new Duration(seconds: 5));
        var time = RepeatInterval.EveryMinute;
        print("DATA: " + DateTime.now().toString());
        print("DATA: " + scheduledNotificationDateTime.toString());
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.Max, priority: Priority.High);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await MyApp.flutterLocalNotificationsPlugin.schedule(
            0,
            'Scheduled',
            'Nombre del evento',
            scheduledNotificationDateTime,
            platformChannelSpecifics,
            payload: 'Default_Sound',
            androidAllowWhileIdle: true
        );
    }
}