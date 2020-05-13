import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/model/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

// ignore: must_be_immutable
class ChatPage extends StatefulWidget{
    ChatPage(this.userMe, this.userChat);
    User userMe;
    String userChat;


    @override
    _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{

    TextEditingController _controller = TextEditingController();
    IO.Socket socket = IO.io('https://petandgochat.herokuapp.com/', <String, dynamic>{
        'transports': ['websocket']
    });

    Map<String, dynamic> msg = new Map();

    ScrollController _listController = new ScrollController();

    List<Message> _missatges = List();

    @override
    void initState(){
        socket.on('connect', (_) {
            print('connect');
            socket.emit('join', widget.userMe.email);
        });
        socket.on('connect_error', (error) {
            print("connect error");
            print(error);
        });

        socket.on('message', (data) {
            msg = jsonDecode(data);
            setState(() {
                if (msg['sender'] != widget.userMe.email){
                    Message m = new Message(
                        sender: msg['sender'],
                        text: msg['text'],
                        time: msg['time'],
                        isLiked: false,
                        unread: false
                    );
                    if(!_missatges.contains(m)) {
                        print('entro aquí');
                        _missatges.add(m);
                    }
                }
            });
        });

        String fToken;
        _firebaseMessaging.getToken().then((token){
            print(token.toString());
            fToken = token.toString();
            String email = widget.userMe.email;
            String URL = 'https://petandgochat.herokuapp.com/api/usuarios/$email/firebase';
            http.put(URL, headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.userMe.token.toString(),
                'Content-Type': 'application/json; charset=utf-8'
            }, body: jsonEncode(<String, String>{
                'token': fToken}));
        });

        _firebaseMessaging.configure(
            onMessage: (Map<String, dynamic> message) async {
                print('on message $message');
            },
            onResume: (Map<String, dynamic> message) async {
                print('on resume $message');
            },
            onLaunch: (Map<String, dynamic> message) async {
                print('on launch $message');
            },
        );
    }

    _buildMessage(Message message, bool isMe) {
        final Container msg = Container(
            margin: isMe
                ? EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 80.0,
            )
                : EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
            ),
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
                color: isMe ? Color(0x6FA4FF02) : Color(0xFFFFEFEE),
                borderRadius: isMe
                    ? BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                )
                    : BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text(
                        message.time,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                        ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                        message.text,
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                        ),
                    ),
                ],
            ),
        );
        if (isMe) {
            return msg;
        }

        Timer(
            Duration(milliseconds: 100),
                () => _listController
                .jumpTo(_listController.position.maxScrollExtent)
        );
        return Row(
            children: <Widget>[
                msg,
            ],
        );
    }

    _buildMessageComposer() {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 70.0,
            color: Colors.white,
            child: Row(
                children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.photo),
                        iconSize: 25.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {},
                    ),
                    Expanded(
                        child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                            },
                            controller: _controller,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Send a message...',
                            ),
                            onTap: () {
                                Timer(
                                    Duration(milliseconds: 100),
                                        () => _listController
                                        .jumpTo(_listController.position.maxScrollExtent));
                            },
                        ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 25.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                            if(_controller.text.isNotEmpty){
                                socket.emit('message',
                                    jsonEncode(<String, String>{
                                        'text': _controller.text,
                                        'sender': widget.userMe.email,
                                        'receiver': widget.userChat,
                                        'time': DateTime.now().hour.toString()+ ':'+ DateTime.now().minute.toString(),
                                    })
                                );
                                setState(() {
                                    _missatges.add(
                                        Message(
                                            sender: widget.userMe.email,
                                            text: _controller.text,
                                            time: DateTime.now().hour.toString()+ ':'+ DateTime.now().minute.toString(),
                                            isLiked: false,
                                            unread: false
                                        )
                                    );
                                });
                                _controller.clear();
                            }
                            Timer(
                                Duration(milliseconds: 100),
                                    () => _listController
                                    .jumpTo(_listController.position.maxScrollExtent)
                            );

                        },
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {


        print('hola');


        return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: AppBar(
                    title: Row(
                        children: <Widget>[
                            SizedBox(width: 40.0,),
                            CircleAvatar(
                                radius: 20.0,
                                child: Icon(Icons.person),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                                widget.userChat,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                ),
                            )
                        ],
                    ),
                    centerTitle: true,
                    elevation: 0.0,
                ),
            ),
            body: Column(
                children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                                    padding: EdgeInsets.all(20.0),
                                    itemCount: _missatges.length,
                                    controller: _listController,
                                    itemBuilder: (BuildContext context, int index) {
                                        final Message message = _missatges[index];
                                        final bool isMe = message.sender == widget.userMe.email;
                                        return _buildMessage(message, isMe);
                                    },
                        ),
                    ),
                    _buildMessageComposer()
                ],
            ),
        );
    }
}