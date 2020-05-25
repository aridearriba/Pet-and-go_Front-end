import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/global/global.dart' as Global;

class Search extends StatefulWidget{
    Search(this.user);
    User user;
    @override
    _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>{

    TextEditingController _controller = new TextEditingController();
    final _formKey = GlobalKey<FormState>();

    User userSearch = new User();
    bool mostrar = false;


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
                                        getData().whenComplete(() => {
                                            setState((){
                                                mostrar = true;
                                            })
                                        })
                                    },
                                    backgroundColor: Colors.green,
                                )
                            ],
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(35.0),
                        child: mostrar ? _buildCard(context) : null
                    )
                ],
            )
        );
    }

    Widget _buildCard(BuildContext context){
        return new Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        CircleAvatar(
                            radius: 50.0,
                            child: Icon(Icons.person),
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                // USER
                                // username
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                            Text(
                                                userSearch.username,
                                                style: TextStyle(
                                                    color: Colors
                                                        .black54,
                                                    fontWeight: FontWeight
                                                        .bold,
                                                    fontSize: 16.0,
                                                ),
                                                textAlign: TextAlign
                                                    .center,
                                            ),
                                        ]
                                    ),
                                ),
                                // email
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                            Text(
                                                userSearch.name,
                                                style: TextStyle(
                                                    color: Colors
                                                        .black54,
                                                    fontSize: 16.0,
                                                ),
                                                textAlign: TextAlign
                                                    .center,
                                            )
                                        ]
                                    ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                            Text(
                                                userSearch.email,
                                                style: TextStyle(
                                                    color: Colors
                                                        .black54,
                                                ),
                                            )
                                        ],
                                    )
                                ),
                            ],
                        ),
                    ],
                ),
            )
        );
    }

    Future<void> getData() async{
        var email = _controller.text;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/"+email));
        userSearch = User.fromJson(jsonDecode(response.body));
    }
}