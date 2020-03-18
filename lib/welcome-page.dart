import 'package:flutter/material.dart';
import 'login.dart';

/// This Widget is the main application widget.
class WelcomePage extends StatelessWidget {
    static const String _title = 'Pet and Go';

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: _title,
            home: Scaffold(
                appBar: AppBar(title: const Text(_title)),
                body: Center(
                    child: RaisedButton(
                        onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LogIn())
                            );
                        },
                        child: Text('Go to "Log in"'),
                    ),
                ),
            ),
        );
    }
}