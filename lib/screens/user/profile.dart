import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/pets/newPet.dart';


// ignore: must_be_immutable
class Profile extends StatefulWidget {
    Profile(this.user);
    User user;
    @override
    _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
{
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

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
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
            body: ListView(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                        child: Column(
                            children: <Widget>[
                                Icon(
                                    Icons.account_circle,
                                    color: Colors.green,
                                    size: 150.0,
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
                                        Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.crop_square,
                                                        color: Colors.black54,
                                                        size: 100.0,
                                                    ),
                                                    Column(
                                                        children: <Widget>[
                                                            Text(
                                                                "Nombre mascota",
                                                                style: TextStyle(
                                                                    color: Colors.black54,
                                                                    fontSize: 16.0,
                                                                ),
                                                                textAlign: TextAlign.left,
                                                            ),
                                                            Text(
                                                                "Raza",
                                                                style: TextStyle(
                                                                    color: Colors.black45,
                                                                    fontStyle: FontStyle.italic,
                                                                    fontSize: 12.0,
                                                                ),
                                                                textAlign: TextAlign.left,
                                                            )
                                                        ]
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 50),
                                                        child: Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: Colors.black54,
                                                            size: 20.0,
                                                        ),
                                                    ),
                                                ]
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
}