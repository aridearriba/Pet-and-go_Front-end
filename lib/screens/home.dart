import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/screens/user/profile.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
    Home(this.email);

    final String email;

    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    User user = new User();

    nLogIn() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nProfile(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(user))
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(),
            appBar: AppBar(
                title: Text(
                    'Pet & Go',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
                actions: <Widget>[
                    IconButton(icon : Icon(Icons.account_circle), color: Colors.white,
                        onPressed: () {
                            getData().whenComplete(
                                nProfile
                            );
                        }),
                ],
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        RichText(
                            text: TextSpan(
                                text : 'Welcome to',
                                style: TextStyle(
                                color: Colors.black,
                                fontSize: 28.0,
                                ),
                                children: <TextSpan>[
                                    TextSpan(
                                        text : '\nPet & Go',
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
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

    Future<void> getData() async{
        final response = await http.get(new Uri.http("192.168.1.100:8080", "/api/usuarios/"+widget.email));
        user = User.fromJson(jsonDecode(response.body));
    }
}