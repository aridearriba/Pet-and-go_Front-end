
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/message.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/chat/chat_page.dart';
import 'package:petandgo/screens/menu/menu.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class Principal extends StatefulWidget{
    Principal(this.user);
    User user;
    @override
    _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal>{

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
            body: Column(
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
                                        'sender': widget.user.email,
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
}

class RecentChats extends StatelessWidget{

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
        return Column(
        );
        
        /*return Expanded(
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
                        itemCount: chats.length,
                        itemBuilder: (BuildContext context, int index) {
                            final Message chat = chats[index];
                            return GestureDetector(
                                onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute( builder: (_) => ChatPage(
                                            chat.sender,
                                            )
                                        )
                                    )
                                },
                                child: Container(
                                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                        color: chat.unread ? Color(0x1FA4FF02) : Colors.white,
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
                                                                chat.sender.name,
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 15.0,
                                                                    fontWeight: FontWeight.bold,
                                                                ),
                                                            ),
                                                            SizedBox(height: 5.0),
                                                            Container(
                                                                width: MediaQuery.of(context).size.width * 0.45,
                                                                child: Text(
                                                                    chat.text,
                                                                    style: TextStyle(
                                                                        color: Colors.blueGrey,
                                                                        fontSize: 15.0,
                                                                        fontWeight: FontWeight.w600,
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                ],
                                            ),
                                            Column(
                                                children: <Widget>[
                                                    Text(
                                                        chat.time,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15.0,
                                                            fontWeight: FontWeight.bold,
                                                        ),
                                                    ),
                                                    SizedBox(height: 5.0),
                                                    chat.unread
                                                        ? Container(
                                                        width: 40.0,
                                                        height: 20.0,
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(context).primaryColor,
                                                            borderRadius: BorderRadius.circular(30.0),
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                            'NEW',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                            ),
                                                        ),
                                                    )
                                                        : Text(''),
                                                ],
                                            ),
                                        ],
                                    ),
                                ),
                            );
                        },
                    ),
                ),
            ),
        );*/
    }
}