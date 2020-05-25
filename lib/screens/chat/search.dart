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

    TextEditingController _controller = new TextEditingController();
    final _formKey = GlobalKey<FormState>();


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
            body: Column(
                children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(35.0),
                        child: Row(
                            children: <Widget>[
                                Form(
                                    key: _formKey,
                                    child: SizedBox(width: 250.0,
                                            child: TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Introduzca un email'
                                                ),
                                                controller: _controller,
                                            )
                                    ),
                                ),
                                SizedBox(width: 15.0,),
                                FloatingActionButton(
                                    child: Icon(Icons.search),
                                    onPressed: () => {
                                        _controller.text = 'ha funcionat el boto',
                                    },
                                    backgroundColor: Colors.green,
                                )
                            ],
                        ),
                    )
                ],
            )
        );
    }
}