import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';

class Blocks extends StatefulWidget{
    Blocks(this.user);
    User user;

    @override
    _BlocksState createState() => _BlocksState();

}

class _BlocksState extends State<Blocks>{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                backgroundColor: Colors.red,
                title: Text('Personas bloquadas',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
            ),
        );
    }

}