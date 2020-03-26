import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/home.dart';
import 'package:petandgo/login.dart';
import 'package:petandgo/sign-in-google.dart';
import 'package:petandgo/user.dart';


// ignore: must_be_immutable
class Profile extends StatefulWidget {
    Profile(this.user);
    User user;
    @override
    _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

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
            MaterialPageRoute(builder: (context) => Home(widget.user.email))
        );
    }

    @override
    Widget build(BuildContext context) {
        if (profileImage == null) profileImage = "https://cdn.iconscout.com/icon/free/png-256/avatar-380-456332.png";

        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'Pet & Go',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.home, color: Colors.white,),
                        onPressed: nHome,
                    ),
                    IconButton(
                        icon: Icon(Icons.settings, color: Colors.white,),
                        onPressed: () {},
                    ),
                ]
            ),
            body: Column(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
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