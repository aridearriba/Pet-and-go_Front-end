import 'package:flutter/material.dart';
import 'package:petandgo/login.dart';

class Home extends StatefulWidget {
    Home({Key key,}) : super(key: key);

    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    nLogIn() {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Pet & Go'),
                actions: <Widget>[
                    IconButton(icon : Icon(Icons.dehaze), color: Colors.white, onPressed: () {},),
                ],
            ),
            body: Center(

                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        RichText(
                            text: TextSpan(
                                text : 'Welcome ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28.0,
                                ),
                                children: <TextSpan>[
                                    TextSpan(
                                        text: 'UserName',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 30.0,
                                        ),
                                    ),
                                    TextSpan(
                                        text : '\n to Pet & Go',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 28.0,
                                        ),
                                    ),
                                ]
                            ),
                            textAlign: TextAlign.center,
                        ),
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: nLogIn,
                child: Text('LogOut'),
            ),
        );
    }
}