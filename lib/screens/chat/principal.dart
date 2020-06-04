
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/chat/chat_page.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/global/global.dart' as Global;

class Principal extends StatefulWidget{
    Principal(this.user);
    User user;
    @override
    _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal>{

    User userMe, userFriend;
    List<dynamic> _friends = new List();
    var _responseCode;
    List<User> _myFriends = new List();
    bool mostrar = false;

    void initState(){
        getFriends().whenComplete(() => {
            for(String email in _friends){
                getData(email).whenComplete(() => {
                    _myFriends.add(userFriend),
                })
            },
            setState(() => {
                mostrar = true
            }),
        });
        print(_myFriends.length);
    }

    @override
    Widget build(BuildContext context) {

        String userChat;

        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Chats',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
            body: GestureDetector(
                child: !mostrar ?
                Padding(
                    padding: const EdgeInsets.all(
                        30.0),
                    child: Center(
                        child: SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.green, valueColor: AlwaysStoppedAnimation(Colors.lightGreen)
                            ),
                        )
                    ),
                )
                    :ListView.separated(
                    padding: EdgeInsets.only(top: 10.0),
                    separatorBuilder: (context, index) =>
                        Divider(
                            color: Colors.grey,
                            indent: 25.0,
                            endIndent: 25.0,
                        ),
                    itemCount: _myFriends.length,
                    itemBuilder: _buildListTile,
                ),
            ),
        );
    }

    ListTile _buildListTile(BuildContext context, int index){
        return ListTile(
            title: Text(_myFriends[index].email, style: TextStyle(
            ),),
            leading: CircleAvatar(
                radius: 35.0,
                child: Icon(Icons.person),
            ),
            onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute( builder: (_) => ChatPage(
                        widget.user, _myFriends[index].email
                    )
                    )
                )
            },
        );
    }


    Future<void> getFriends() async {
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

    Future<void> getData(String email) async{
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email));
        setState(() {
            userFriend = User.fromJson(jsonDecode(response.body));
        });

        print(response.statusCode.toString());

    }
}