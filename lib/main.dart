import 'package:flutter/material.dart';
import 'sign-up.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final appTitle = 'petandgo';

        return MaterialApp(
            title: appTitle,
            home: SignUpPage()
        );
    }

}
