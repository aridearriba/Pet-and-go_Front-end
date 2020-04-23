import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/screens/pets/myPets.dart';


class Pet extends StatefulWidget {
    Pet(this.user, this.mascota);
    User user;
    Mascota mascota;
    @override
    _PetState createState() => _PetState();
}

class _PetState extends State<Pet>{

    nMyPets() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPets(widget.user))
        );
    }

    nPet(Mascota mascota) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pet(widget.user, mascota))
        );
    }
    var _statusCode;
    Mascota _result = new Mascota();
    var _date;
    DateTime _dateTime;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    @override
    Widget build(BuildContext context) {
        _date = widget.mascota.date.day.toString() + "." + widget.mascota.date.month.toString() + "." + widget.mascota.date.year.toString();
        var _difference = DateTime.now().difference(widget.mascota.date);
        var _age = (_difference.inDays/365).floor().toString();
        return Scaffold(
            key: _scaffoldKey,
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
                        onPressed: () => nMyPets(),
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
                                        // PET
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
        var _dateT = widget.mascota.date.day.toString() + "." + widget.mascota.date.month.toString() + "." + widget.mascota.date.year.toString();
        TextEditingController _dateController = new TextEditingController();
        _dateController.text = _dateT;
        return new SimpleDialog(
            title: Text('Datos de la mascota',
            textAlign: TextAlign.center,),
            children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Text(
                                "Fecha de nacimiento:  ",
                                style: TextStyle(
                                    color: Colors.green,
                                ),
                                textAlign: TextAlign.center,
                            ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                    child: InkWell(
                                onTap: () async {
                                    _dateTime = await showDatePicker(
                                        context: context,
                                        initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                        firstDate: DateTime(DateTime.now().year - 20),
                                        lastDate: DateTime(DateTime.now().year + 1)
                                    );
                                    _dateController.text = _dateTime.day.toString() + ". " + _dateTime.month.toString() + ". " + _dateTime.year.toString();
                                },
                                child: IgnorePointer(
                                    child: new TextFormField(
                                        controller: _dateController,
                                        textAlign: TextAlign.center,
                                        validator: (value){
                                            if(value.isEmpty){
                                                return 'Por favor, pon una fecha.';
                                            }
                                            return null;
                                        },
                                        onSaved: (String val) {},
                                    ),
                                ),
                    ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                    child: SimpleDialogOption(
                        child: RaisedButton(
                            disabledColor: Colors.green,
                            child: Text("Actualizar"),
                            disabledTextColor: Colors.white,
                        ),
                        onPressed: ()  {
                            if(_dateController.text == _date){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Error: No se ha actualizado la fecha'),
                                ));
                            }
                            else{
                                update().whenComplete(() {
                                    if(_statusCode == 200){
                                        getMascota().whenComplete(() {
                                            print(_result.date);
                                            Navigator.pop(context);
                                            nPet(_result);
                                        });
                                    }
                                });
                            }
                        },
                    )
                ),
            ],
        );
    }

    Future<void> update() async{
        var email = widget.user.email;
        String mascot = widget.mascota.id.name;
        var date = _dateTime.toString().substring(0,10);
        http.Response response = await http.put(new Uri.http("192.168.1.60:8080", "/api/usuarios/" + email + "/mascotas/"+ mascot),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString()
            },
            body: jsonEncode({
                    "id": {
                    "nombre":mascot,
                    "amo":"cvila@hotmail.com"
                    },
                    "fechaNacimiento":date}));
        _statusCode = response.statusCode;
        print(_statusCode);
    }

    Future<void> getMascota() async{
        var email = widget.user.email;
        String mascot = widget.mascota.id.name;
        http.Response response = await http.get(new Uri.http("192.168.1.60:8080", "/api/usuarios/" + email + "/mascotas/"+ mascot));
        _result = Mascota.fromJson(jsonDecode(response.body));
        print("La data en result: " +_result.date.toString());
    }
}