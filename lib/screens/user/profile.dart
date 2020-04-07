import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/model/user.dart';


// ignore: must_be_immutable
class Profile extends StatefulWidget {
    Profile(this.user);
    User user;
    @override
    _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
{
    nLogIn() {
        widget.user = null;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nHome() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(widget.user))
        );
    }

    @override
    Widget build(BuildContext context) {
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
            body: Column(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                            children: <Widget>[
                                Icon(
                                    Icons.account_circle,
                                    color: Colors.green,
                                    size: 150.0,
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                        // username
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Text(
                                                widget.user.username,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 26.0,
                                                ),
                                                textAlign: TextAlign.center,
                                            )
                                        ),

                                        Padding (
                                            padding:const EdgeInsets.symmetric(vertical: 5.0),
                                            child:
                                                Text(
                                                    widget.user.name,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontStyle: FontStyle.italic,
                                                        fontSize: 20.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                )
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.email,
                                                        color: Colors.grey[600],
                                                    ),
                                                    Text(
                                                        '   '+widget.user.email,
                                                        style: TextStyle(
                                                            color: Colors.blueAccent,
                                                        ),
                                                    )
                                                ],
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 90.0),
                                            child:
                                                RaisedButton(
                                                    onPressed: nLogIn,
                                                    child:
                                                        Text('Log out',
                                                            style: TextStyle(color: Colors.black)),
                                                    color: Colors.red,
                                                ),
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),
                ]
            ),
        );
    }
}