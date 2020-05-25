import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/menu/menu.dart';

class Search extends StatefulWidget{
    Search(this.user);
    User user;
    @override
    _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>{


    @override
    Widget build(BuildContext context) {

        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Buscar',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
                centerTitle: true,
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
            body: GestureDetector(
                onTap: () => {
                },
            ),
        );
    }
}