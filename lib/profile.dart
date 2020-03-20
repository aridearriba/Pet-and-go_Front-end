import 'package:flutter/material.dart';
import 'package:petandgo/home.dart';
import 'package:petandgo/login.dart';

class Profile extends StatefulWidget {
    Profile({Key key,}) : super(key: key);

    @override
    _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

    String nick = 'UserName';
    String name = 'usuario';
    String surname = 'de ejemplo';
    String email = 'user@email.com';

    nLogIn() {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nHome() {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home())
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
                    IconButton(icon : Icon(Icons.settings), color: Colors.white, onPressed: () {},),
                ],
            ),

            body: Column(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                        child: Row(
                            children: <Widget>[
                                Icon(
                                    Icons.account_circle,
                                    color: Colors.green,
                                    size: 150.0,
                                ),
                                Column(
                                    children: <Widget>[
                                        Text(
                                            '$nick',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30.0,
                                            ),
                                            textAlign: TextAlign.left,
                                        ),

                                        Text(
                                            '$name $surname',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                                fontSize: 20.0,
                                            ),
                                            textAlign: TextAlign.left,
                                        ),

                                        Row(
                                            children: <Widget>[
                                                Icon(
                                                    Icons.email,
                                                    color: Colors.grey[600],
                                                ),
                                                Text(
                                                    '   $email',
                                                    style: TextStyle(
                                                        color: Colors.blueAccent,
                                                    ),
                                                )
                                            ],
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),

                    Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                            children: <Widget>[
                                Icon(
                                    Icons.email,
                                    color: Colors.grey[600],
                                ),
                                Text(
                                    '   $email',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                    ),
                                )
                            ],
                        ),
                    ),
                ]
            ),
                floatingActionButton: FloatingActionButton(
                    onPressed: nLogIn,
                    backgroundColor: Colors.green,
                    child: Text('LogOut'),
            ),
        );
    }
}