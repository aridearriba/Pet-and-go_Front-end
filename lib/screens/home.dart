import 'package:flutter/material.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/screens/user/profile.dart';
import 'package:petandgo/model/user.dart';

class Home extends StatefulWidget {
    Home(this.user);
    User user;

    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    nLogIn() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nProfile(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(widget.user))
        );
    }

    @override
    Widget build(BuildContext context) {
        print("USER TOKEN: "+ widget.user.token.toString());
        print(widget.user.image);
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Pet & Go',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
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
}