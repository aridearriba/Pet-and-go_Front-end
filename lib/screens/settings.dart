import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/pets/pet.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/pets/newPet.dart';

import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
    Settings(this.user);
    User user;

    @override
    _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
{
    List<Mascota> _mascotas = new List<Mascota>();
    nLogIn() {
        widget.user = null;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nHome() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(widget.user))
        );
    }

    nNewPet() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewPet(widget.user))
        );
    }

    nPet(Mascota mascota) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Pet(widget.user, mascota))
        );
    }

    nLogin() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Perfil',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
            body: ListView(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                        child: Column(
                            children: <Widget>[
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        // USER
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Text(
                                                "NOTIFICACIONES",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                                            child: Row(
                                                children: <Widget>[
                                                    /*Icon(
                                                        Icons.email,
                                                        color: Colors.black54,
                                                    ),*/
                                                    Text(
                                                        '   ',
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                        ),
                                                    )
                                                ],
                                            )
                                        ),
                                    ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        // PETS
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Text(
                                                "CUENTA",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: GestureDetector(
                                                child: Row(
                                                    children: <Widget>[
                                                        Icon(
                                                            Icons.delete,
                                                            color: Colors.redAccent,
                                                        ),
                                                        Text(
                                                            '   ' + "Eliminar cuenta",
                                                            style: TextStyle(
                                                                color: Colors.redAccent,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                onTap: () => _showAlertDialog()
                                            ),
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

    void _showAlertDialog() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Eliminar cuenta", textAlign: TextAlign.center),
                    content: Text("Estas apunto de eliminar tu cuenta. ¿Estás seguro?", textAlign: TextAlign.center),
                    actions: <Widget>[
                        FlatButton(
                            child: Text("CERRAR", style: TextStyle(color: Colors.black45),),
                            onPressed: () =>  Navigator.pop(context),
                        ),
                        FlatButton(
                            child: Text("ACEPTAR", style: TextStyle(color: Colors.redAccent),),
                            onPressed:  () => deleteAccount().whenComplete(
                                    () {
                                        Navigator.pop(context);
                                        nLogIn();
                                    }()),
                        ),
                    ],
                );
            }
        );
    }

    Future<void> deleteAccount() async{
        var email = widget.user.email;
        final http.Response response = await http.delete(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/" + email),
            headers: <String, String> {
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
        );
    }
}