import 'package:flutter/material.dart';
import 'package:petandgo/sign-in-email.dart';
import 'package:petandgo/root.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
    static const String _title = 'Pet and Go';

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: _title,
            theme: ThemeData(
                primaryColor: Color.fromRGBO(63, 202, 12, 1),
            ),
            home: new RootPage(auth: new Auth())
        );
    }
}