import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';


class Pet extends StatefulWidget {
    Pet(this.user, this.mascota);
    User user;
    Mascota mascota;
    @override
    _PetState createState() => _PetState();
}

class _PetState extends State<Pet>
{
    @override
    Widget build(BuildContext context) {
        var _date = widget.mascota.date.day.toString() + "." + widget.mascota.date.month.toString() + "." + widget.mascota.date.year.toString();
        var _difference = DateTime.now().difference(widget.mascota.date);
        var _age = (_difference.inDays/365).floor().toString();
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Mi mascota',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                    )
                ],
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
                                                "INFO",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        // nombre
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.assignment,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + widget.mascota.id.name,
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
                                                        Icons.date_range,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + _date + " (" + _age + " años)",
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                        ),
                                                    )
                                                ],
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 30),
                                            child: Row(
                                                children: <Widget>[
                                                    FloatingActionButton.extended(
                                                        icon: Icon(Icons.pets, color: Colors.white),
                                                        backgroundColor: Colors.green,
                                                        label: Text("Editar datos de mascota"),
                                                        onPressed: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) => _buildEditDialog(context)
                                                            );
                                                        }
                                                    )
                                                ],
                                            )
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

    Widget _buildEditDialog(BuildContext context) {
        TextEditingController _nameController = new TextEditingController();
        _nameController.text = widget.mascota.id.name;
        var _date = widget.mascota.date.day.toString() + "." + widget.mascota.date.month.toString() + "." + widget.mascota.date.year.toString();
        TextEditingController _dateController = new TextEditingController();
        _dateController.text = _date;
        return new AlertDialog(
            title: Text('Datos de la mascota'),
            content: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                            children: <Widget>[
                                new Expanded(child: Text(
                                    "Nombre:  ",
                                    style: TextStyle(
                                        color: Colors.green,
                                    ),
                                    textAlign: TextAlign.left,
                                ),),
                                SizedBox(width: 150, child: TextFormField(
                                    controller: _nameController,
                                    textAlign: TextAlign.center,
                                ),)
                            ],
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                            children: <Widget>[
                                new Expanded( child: Text(
                                    "Fecha de nacimiento:  ",
                                    style: TextStyle(
                                        color: Colors.green,
                                    ),
                                    textAlign: TextAlign.left,
                                ),),
                                SizedBox ( width: 150, child: TextFormField(
                                    controller: _dateController,
                                    textAlign: TextAlign.center,
                                ),)
                            ],
                        ),
                    ),
                ],
            ),
            actions: <Widget>[new FlatButton(
                onPressed: (){},
                textColor: Theme.of(context).primaryColor,
                child: const Text('Aceptar'),
            ),
            ],
        );
    }
}