import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'multilanguage/appLanguage.dart';
import 'multilanguage/appLocalizations.dart';
import 'screens/user/login.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    AppLanguage appLanguage = AppLanguage();
    await appLanguage.fetchLocale();

    runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatefulWidget {
    final AppLanguage appLanguage;
    MyApp({this.appLanguage});

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
        return ChangeNotifierProvider<AppLanguage>(
            create: (_) => widget.appLanguage,
            child: Consumer<AppLanguage>(builder: (context, model, child) {
                return MaterialApp(
                    title: 'Pet and Go',
                    theme: ThemeData(
                        primaryColor: Color.fromRGBO(63, 202, 12, 1),
                    ),
                    locale: model.appLocal,
                    supportedLocales: [
                        Locale('es', 'ES'),
                        Locale('ca', 'CA'),
                        Locale('en', 'US'),
                    ],
                    localizationsDelegates: [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                    ],
                    home: LogIn(),
                );
            }),
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