import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';

class ChatPage extends StatefulWidget{
    ChatPage();
    User userMe, userChat;

    @override
    _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'Pablo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                    ),

                ),
                centerTitle: true,
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
        );
  }
}