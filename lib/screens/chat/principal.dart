
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/message.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/chat/chat_page.dart';
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

        String userChat;
        if(widget.user.email == 'cvila@gmail.com'){
            userChat = 'a@prueba.com';
        }
        else userChat = 'cvila@gmail.com';

        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Chats',
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
                    Navigator.push(
                        context,
                        MaterialPageRoute( builder: (_) => ChatPage(
                            widget.user, userChat
                            )
                        )
                    )
                },
                child: ListView(
                        children: <Widget>[
                            Row(
                                children: <Widget>[
                                    CircleAvatar(
                                        radius: 35.0,
                                        child: Icon(Icons.person),
                                    ),
                                    SizedBox(width: 10.0),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                            Text(
                                                userChat,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            );
  }
}