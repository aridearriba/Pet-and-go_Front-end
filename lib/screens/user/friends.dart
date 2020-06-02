import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/menu/menu.dart';

class Friends extends StatefulWidget{
    Friends(this.user);
    User user;

    @override
    _FriendsState createState() => _FriendsState();

}

class _FriendsState extends State<Friends>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
                color: Colors.white,
            ),
            title: Text('Mis amigos',
                        style: TextStyle(
                            color: Colors.white,
                        ),
                    ),
        ),
    );
  }

}