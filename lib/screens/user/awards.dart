import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/pets/pet.dart';
import 'package:petandgo/screens/user/edit.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/pets/newPet.dart';

import 'package:http/http.dart' as http;
import 'package:petandgo/screens/user/profile.dart';
import 'package:petandgo/screens/user/sign-up.dart';

import 'awards.dart';


class Awards extends StatefulWidget {
    Awards(this.user);
    User user;

    @override
    _AwardsState createState() => _AwardsState();
}

class _AwardsState extends State<Awards>
{
    nProfile() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(widget.user))
        );
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Premios',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                        ),
                        onPressed: () => nProfile(),
                    ),
                ],
            ),
            body: ListView(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 30.0, right: 30.0),
                        child: Column(
                            children: <Widget>[
                                CircleAvatar(
                                    backgroundImage: Image.network('https://images.assetsdelivery.com/compings_v2/lar01joka/lar01joka1804/lar01joka180400005.jpg').image,
                                    radius: 110,
                                    backgroundColor: Colors.transparent,
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                        // USER
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Text(
                                                "AVATAR",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0),
                                            child: Table(
                                                children: [
                                                    TableRow(children: [
                                                        _avatarBlocked(),
                                                        _avatarBlocked(),
                                                        _avatarBlocked(),
                                                    ]),
                                                    TableRow(children:[
                                                        _avatarBlocked(),
                                                        _avatarBlocked(),
                                                        _avatarBlocked(),
                                                    ]),
                                                ])
                                        ),
                                    ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                        // PUNTUACION
                                        Padding(
                                            padding: const EdgeInsets.only(top: 10, bottom: 5.0),
                                            child: Text(
                                                "COMPLEMENTOS",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        // nivel
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0),
                                            child: Table(
                                                children: [
                                                    TableRow(children: [
                                                        _complementBlocked(),
                                                        _complementBlocked(),
                                                        _complementBlocked(),
                                                    ]),
                                                    TableRow(children:[
                                                        _complementBlocked(),
                                                        _complementBlocked(),
                                                        _complementBlocked(),
                                                    ]),
                                            ])
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),
                ]
            ),
        );
    }

    Widget _avatarBlocked(){
        return CircleAvatar(
            minRadius: 10,
            maxRadius: 40,
            backgroundColor: Colors.transparent,
            child: Stack(
                children: <Widget>[
                    ClipOval(
                        child: Image.network('https://images.assetsdelivery.com/compings_v2/lar01joka/lar01joka1804/lar01joka180400005.jpg'),
                    ),
                    Positioned(
                        top: 0,
                        left: 60,
                        child: Container(
                            width: 20,
                            height: 20,
                            child:
                            ClipOval(
                                child: Icon(Icons.lock, color: Colors.black, size: 15),
                            )
                        )
                    ),
                ]
            ),
        );
    }

    Widget _complementBlocked(){
        return CircleAvatar(
            minRadius: 10,
            maxRadius: 40,
            backgroundColor: Colors.transparent,
            child: Stack(
                children: <Widget>[
                    ClipOval(
                        child: Image.network('https://i.dlpng.com/static/png/6711347_preview.png'),
                    ),
                    Positioned(
                        top: 0,
                        left: 60,
                        child: Container(
                            width: 20,
                            height: 20,
                            child:
                            ClipOval(
                                child: Icon(Icons.lock, color: Colors.black, size: 15),
                            ),
                        )
                    ),
                ]
            ),
        );
    }
}