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


// ignore: must_be_immutable
class MyPets extends StatefulWidget {
    MyPets(this.user);
    User user;

    @override
    _PetsState createState() => _PetsState();
}

class _PetsState extends State<MyPets>
{
    List<Mascota> _mascotas = new List<Mascota>();

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
                    'Mis mascotas',
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
                        child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
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
                                    ListView.builder
                                        (
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
                        ),
                ]
            ),
        );
    }

    Future<void> getMascotas() async {
        var email = widget.user.email;
        final response = await http.get(new Uri.http(
            "192.168.1.100:8080", "/api/usuarios/" + email + "/mascotas"));
        setState(() {
            Iterable list = json.decode(response.body);
            _mascotas = list.map((model) => Mascota.fromJson(model)).toList();
        });
    }
}