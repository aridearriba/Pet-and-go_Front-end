
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
    String _image64;
    ImageProvider _imageProfile;
    List<dynamic> _friends = new List();
    var _responseCode;
    List<User> _myFriends = new List();
    bool mostrar = false;

    void initState(){
        getFriends().whenComplete(() => {
            for(var i = 0; i< _friends.length; i++){
                getData(_friends[i]).whenComplete(() =>
                {
                    getProfileImage(userFriend),
                    print('email despues de getData: '+userFriend.email),
                })
            },
            print(_myFriends),
            setState(() => {
                mostrar = true
            }),
        });
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
            title: Text(_myFriends[index].name, style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
            subtitle: Text(_myFriends[index].email),
            leading: CircleAvatar(
                radius: 25.0,
                backgroundImage: _imageProfile = getImage(_myFriends[index].image),
            ),
            onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute( builder: (_) => ChatPage(
                        widget.user, _myFriends[index]
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
        _responseCode = response.statusCode;
    }

    Future<void> getData(email) async{
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email));
        userFriend = User.fromJson(jsonDecode(response.body));

    }

    ImageProvider getImage(String image)  {
        _image64 = image;
        // no user image
        if (_image64 == "")
            return Image.network(widget.user.profileImageUrl).image;

        // else --> load image
        Uint8List _bytesImage;
        String _imgString = _image64.toString();
        _bytesImage = Base64Decoder().convert(_imgString);
        return Image.memory(_bytesImage).image;
    }

    Future<void> getProfileImage(User userF) async{
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + userF.email + "/image"),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },);
            userF.image = response.body;
            setState(() => {
                _myFriends.add(userF)
            });
    }
}