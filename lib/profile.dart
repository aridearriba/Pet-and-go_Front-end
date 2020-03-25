import 'package:flutter/material.dart';
import 'package:petandgo/home.dart';
import 'package:petandgo/login.dart';
import 'package:petandgo/sign-in-google.dart';


class Profile extends StatefulWidget {
    Profile({Key key,}) : super(key: key);

    @override
    _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

    //String nick = 'UserName';
    //String name = 'usuario';
    //String surname = 'de ejemplo';
    //String email = 'user@email.com';

    nLogIn() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login())
        );
    }

    nHome() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home())
        );
    }

    @override
    Widget build(BuildContext context) {
        if (profileImage == null) profileImage = "https://cdn.iconscout.com/icon/free/png-256/avatar-380-456332.png";

        return Scaffold(
            body: Column(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.home, color: Colors.green,),
                                onPressed: nHome,
                            ),
                            IconButton(
                                icon: Icon(Icons.settings, color: Colors.green,),
                                onPressed: () {},
                            ),
                        ],
                    ),


                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                            children: <Widget>[
                                CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        profileImage,
                                    ),
                                    radius: 60,
                                    backgroundColor: Colors.transparent,
                                ),
                                /*Icon(
                                    Icons.account_circle,
                                    color: Colors.green,
                                    size: 150.0,
                                ),*/
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
                                            '$name',
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
                                                    email,
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
                ]
            ),

            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    signOutGoogle().whenComplete(() {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) {
                                    return Login();
                                },
                            ),
                        );
                    });
                },
                backgroundColor: Colors.green,
                child: Text('LogOut'),
            ),
        );
    }
}