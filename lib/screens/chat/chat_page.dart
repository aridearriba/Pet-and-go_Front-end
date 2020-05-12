import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/model/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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

    @override
    Widget build(BuildContext context) {
        print('hola');
        socket.on('connect', (_) {
            print('connect');
            socket.emit('message', 'test');
        });
        socket.on('connect_error', (error) {
            print("connect error");
            print(error);
        });

        socket.on('message', (data) => print(data));

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
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.more_horiz),
                            iconSize: 30.0,
                            color: Colors.white,
                            onPressed: () {},
                        ),
                    ],
                ),
            ),
            body:Column(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Form(
                                    child: TextFormField(
                                        controller: _controller,
                                        decoration: InputDecoration(labelText: 'Send a message'),
                                    ),
                                ),
                                Text('plis que funcioni x200990'),
                            ],
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FloatingActionButton(
                            onPressed: (){
                                if(_controller.text.isNotEmpty){
                                    socket.emit('message',
                                        jsonEncode(<String, String>{
                                            'data': _controller.text,
                                            'sender': widget.userMe.email,
                                            'receiver': 'a@prueba.com'}));
                                }
                            },
                            child: Icon(Icons.send),
                        ),
                    )
                ],
            )
        );
    }

    /*_buildMessage(Message message, bool isMe) {
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
                            color: Colors.blueGrey,
                            fontSize: 16.0,
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
        return Row(
            children: <Widget>[
                msg,
                IconButton(
                    icon: message.isLiked
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    iconSize: 30.0,
                    color: message.isLiked
                        ? Theme.of(context).primaryColor
                        : Colors.blueGrey,
                    onPressed: () {},
                )
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
                            onChanged: (value) {},
                            decoration: InputDecoration.collapsed(
                                hintText: 'Send a message...',
                            ),
                        ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 25.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {},
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: AppBar(
                    title: Row(
                        children: <Widget>[
                            SizedBox(width: 55.0,),
                            CircleAvatar(
                                radius: 20.0,
                                child: Icon(Icons.person),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                                widget.userChat.name,
                                style: TextStyle(
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                ),
                            )
                        ],
                    ),
                    centerTitle: true,
                    elevation: 0.0,
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.more_horiz),
                            iconSize: 30.0,
                            color: Colors.white,
                            onPressed: () {},
                        ),
                    ],
                ),
            ),
            body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                    children: <Widget>[
                        Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                    ),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                    ),
                                    child: ListView.builder(
                                        reverse: true,
                                        padding: EdgeInsets.only(top: 15.0),
                                        itemCount: messages.length,
                                        itemBuilder: (BuildContext context, int index) {
                                            final Message message = messages[index];
                                            final bool isMe = message.sender.name == currentUser.name;
                                            return _buildMessage(message, isMe);
                                        },
                                    ),
                                ),
                            ),
                        ),
                        _buildMessageComposer(),
                    ],
                ),
            ),
        );
    }*/
}