import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/global/global.dart' as Global;
import 'package:petandgo/multilanguage/appLocalizations.dart';

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
    bool mostrar = false;

    String _image64;
    ImageProvider _imageProfile;

    List<User> _myFriends = new List();


    void initState(){
        getFriends().whenComplete(() => {
            for(String email in _friends){
                getData(email).whenComplete(() => {
                    getProfileImage(userFriend),
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
        if(!mostrar){
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
                body: Center(
                    child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.green, valueColor: AlwaysStoppedAnimation(Colors.lightGreen)
                        ),
                    )
                ),
            );
        }
        else {
            return Scaffold(
                appBar: AppBar(
                    iconTheme: IconThemeData(
                        color: Colors.white,
                    ),
                    title: Text(AppLocalizations.of(context).translate('friends_title'),
                        style: TextStyle(
                            color: Colors.white,
                        ),
                    ),
                ),
                body: ListView.builder(
                    itemCount: _myFriends.length,
                    itemBuilder: (BuildContext context, index) {
                        return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                        CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: getImage(_myFriends[index].image),
                                        ),

                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                                // USER
                                                // username
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 10.0),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                            Text(
                                                                _myFriends[index].username,
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
                                                        top: 10.0),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                            Text(
                                                                _myFriends[index].name,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
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
                                                        top: 10.0),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                            Text(
                                                                _myFriends[index].email,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize: 12.0,
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
                                                        top: 15.0),
                                                    child: FloatingActionButton.extended(
                                                        heroTag: "btn4",
                                                        label: Text(AppLocalizations.of(context).translate('search_delete-friend')),
                                                        icon: Icon(Icons.delete),
                                                        backgroundColor: Colors.red,
                                                        onPressed: () => {
                                                            removeAmic(_friends[index].email).whenComplete(() => {
                                                                if(_responseCode == 200){
                                                                    getFriends()
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
                                                        label: Text(AppLocalizations.of(context).translate('search_block-friend')),
                                                        icon: Icon(Icons.block),
                                                        backgroundColor: Colors.black,
                                                        onPressed: () => {
                                                            blockFriend(_friends[index]).whenComplete(() => {
                                                                if(_responseCode == 200){
                                                                    getFriends()
                                                                }
                                                            })
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

    Future<void> blockFriend(String emailFriend) async{
        var email = widget.user.email;
        final response = await http.post(
            new Uri.http(Global.apiURL, "/api/amigos/" + email+'/Bloquear'),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: emailFriend
        );
        _responseCode = response.statusCode;
        print(_responseCode);
    }
}