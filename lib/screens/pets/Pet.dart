import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/pets/newPet.dart';

import 'package:http/http.dart' as http;
import 'package:petandgo/screens/user/sign-up.dart';


// ignore: must_be_immutable
class Pet extends StatefulWidget {
    @override
    _PetState createState() => _PetState();
}

class _PetState extends State<Pet>
{

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            //drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Pet & Go',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
        );
    }
}