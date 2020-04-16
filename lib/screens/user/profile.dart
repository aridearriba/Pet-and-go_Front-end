import 'dart:convert';

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
import 'package:petandgo/screens/user/sign-up.dart';


// ignore: must_be_immutable
class Profile extends StatefulWidget {
    Profile(this.user);
    User user;

    @override
    _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
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


    @override
    Widget build(BuildContext context) {
        getMascotas();
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
                                CircleAvatar(
                                    backgroundImage: new NetworkImage(widget.user.profileImageUrl),
                                    radius: 75,
                                    backgroundColor: Colors.transparent,
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        // USER
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Text(
                                                "USUARIO",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        // username
                                        Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.account_circle,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + widget.user.username,
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16.0,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                    ),
                                                ]
                                            ),
                                        ),
                                        // email
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.assignment_ind,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + widget.user.name,
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 16.0,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                    )
                                                ]
                                            ),
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.email,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + widget.user.email,
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
                                                "MASCOTAS",
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
                                                            Icons.add_circle,
                                                            color: Colors.black54,
                                                        ),
                                                        Text(
                                                            '   ' + "Añadir mascota",
                                                            style: TextStyle(
                                                                color: Colors.black54,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                onTap: () => nNewPet()
                                            ),
                                        ),
                                        // Pet
                                        ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _mascotas.length,
                                            itemBuilder: (context, index) {
                                                return ListTile(
                                                    title: Text(_mascotas[index].id.name),
                                                    onTap: () => nPet(_mascotas[index]),
                                                );
                                            },
                                        )
                                    ],
                                ),
                            ],
                        ),
                    ),
                ]
            ),
        );
    }

    Future<void> getMascotas() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/" + email + "/mascotas"));
        setState(() {
            Iterable list = json.decode(response.body);
            _mascotas = list.map((model) => Mascota.fromJson(model)).toList();
        });
    }
}