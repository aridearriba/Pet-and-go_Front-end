import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/menu/menu.dart';

class Principal extends StatefulWidget{
    Principal(this.user);
    User user;
    @override
    _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal>{
    @override
    Widget build(BuildContext context) {

        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Chats',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
        );
  }
}