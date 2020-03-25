import 'package:flutter/material.dart';
import 'package:petandgo/login.dart';
import 'package:petandgo/profile.dart';
import 'package:petandgo/sign-in-email.dart';

class Home extends StatefulWidget {
    Home({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

    final BaseAuth auth;
    final VoidCallback logoutCallback;
    final String userId;

    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    nLogIn() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login())
        );
    }

    nProfile(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile())
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'Pet & Go',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
                actions: <Widget>[
                    IconButton(icon : Icon(Icons.account_circle), color: Colors.white, onPressed: nProfile,),
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
        );
    }
}