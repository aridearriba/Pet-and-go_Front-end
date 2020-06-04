import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/global/global.dart' as Global;

class Friends extends StatefulWidget{
    Friends(this.user);
    User user;

    @override
    _FriendsState createState() => _FriendsState();

}

class _FriendsState extends State<Friends>{

    List<dynamic> _friends = new List();
    var _controller;
    User userFriend;
    User userMe;
    var _responseCode;

    void initState(){
        print(_friends);
        super.initState();
        getData();
    }

  @override
  Widget build(BuildContext context) {
        if(_friends.isEmpty){
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
        else {
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
                body: ListView.builder(
                    itemCount: _friends.length,
                    itemBuilder: (BuildContext context, index) {
                        return Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[
                                        CircleAvatar(
                                            radius: 50.0,
                                            child: Icon(Icons.person),
                                        ),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                                // USER
                                                // username
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        top: 5.0),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                            Text(
                                                                _friends[index],
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
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 15.0),
                                                    child: FloatingActionButton.extended(
                                                        heroTag: "btn4",
                                                        label: Text('Borrar amigo'),
                                                        icon: Icon(Icons.delete),
                                                        backgroundColor: Colors.red,
                                                        onPressed: () => {
                                                            removeAmic(_friends[index]).whenComplete(() => {
                                                                if(_responseCode == 200){
                                                                    getData()
                                                                }
                                                            })
                                                        },
                                                    ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 15.0),
                                                    child: FloatingActionButton.extended(
                                                        heroTag: "btn5",
                                                        label: Text('Bloquear'),
                                                        icon: Icon(Icons.block),
                                                        backgroundColor: Colors.black,
                                                        onPressed: () => {

                                                        },
                                                    ),
                                                )
                                            ],
                                        ),
                                    ],
                                ),
                            )
                        );
                    },
                )
            );
        }
  }

    Future<void> getData() async {
        var email = widget.user.email;
        final response = await http.get(
            new Uri.http(Global.apiURL, "/api/usuarios/" + email));
        userMe = User.fromJson(jsonDecode(response.body));
        setState(() {
            _friends = userMe.friends;
        });
        print(_friends);
        _responseCode = response.statusCode;
    }

    Future<void> removeAmic(String emailFriend) async{
        var email = widget.user.email;
        final response = await http.post(
            new Uri.http(Global.apiURL, "/api/amigos/" + email+'/Removeamic'),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: emailFriend
        );
        _responseCode = response.statusCode;
        print(_responseCode);
    }



}