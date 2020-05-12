
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
                            widget.user, 'a@prueba.com'
                            )
                        )
                    )
                },
                child: Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        color: Color(0x1FA4FF02),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                        ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                'a@prueba.com',
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
            )
        );
  }
}