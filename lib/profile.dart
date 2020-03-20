import 'package:flutter/material.dart';
import 'package:petandgo/home.dart';
import 'package:petandgo/login.dart';

class Profile extends StatefulWidget {
    Profile({Key key,}) : super(key: key);

    @override
    _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

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
                title: Text('Pet & Go'),
                actions: <Widget>[
                    IconButton(icon : Icon(Icons.dehaze), color: Colors.white, onPressed: () {},),
                ],
            ),
            body: Center(
                child: Text(
                    'PRERFIL'
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: nLogIn,
                backgroundColor: Colors.green,
                child: Text('LogOut'),
            ),
        );
    }
}