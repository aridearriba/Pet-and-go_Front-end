import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';

import 'package:http/http.dart' as http;

class Edit extends StatefulWidget{
    Edit(this.user);
    User user;

    @override
    _EditState createState() => _EditState();
}

class _EditState extends State<Edit>{

    @override
    Widget build(BuildContext context){
        final _formKey = GlobalKey<FormState>();
        TextEditingController _passwdController = new TextEditingController();
        TextEditingController _usernameController = new TextEditingController();
        _usernameController.text = widget.user.username;
        TextEditingController _nombreController = new TextEditingController();
        _nombreController.text = widget.user.name;
        TextEditingController _emailController = new TextEditingController();
        _emailController.text = widget.user.email;
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'Modificar perfil',
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
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 30.0, right: 30.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Text(
                                            "PERFIL DE USUARIO",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                            ),
                                        )
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Row(
                                            children: <Widget>[
                                                new Expanded(child: Text(
                                                    "Username:  ",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 18.0
                                                    ),
                                                    textAlign: TextAlign.left,
                                                ),),
                                                SizedBox(width: 220, child: TextFormField(
                                                    controller: _usernameController,
                                                    textAlign: TextAlign.center,
                                                ),)
                                            ],
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Row(
                                            children: <Widget>[
                                                new Expanded( child: Text(
                                                    "Nombre: ",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 18.0
                                                    ),
                                                    textAlign: TextAlign.left,
                                                ),),
                                                SizedBox ( width: 220, child: TextFormField(
                                                    controller: _nombreController,
                                                    textAlign: TextAlign.center,
                                                ),)
                                            ],
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30.0),
                                        child: Text(
                                            "CONTRASEÑA",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                            ),
                                        )
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric( vertical: 10.0),
                                        child: Row(
                                            children: <Widget>[
                                                new Expanded(child: Text(
                                                    "Nueva contraseña:  ",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 16.0
                                                    ),
                                                    textAlign: TextAlign.left,
                                                ),),
                                                SizedBox(width: 150, child: TextFormField(
                                                    controller: _passwdController,
                                                    textAlign: TextAlign.center,
                                                    obscureText: true,
                                                    validator: (value){
                                                        if(value.isEmpty){
                                                            return 'Escribe una contraseña';
                                                        }
                                                        return null;
                                                    },
                                                ),)
                                            ],
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Row(
                                            children: <Widget>[
                                                new Expanded(child: Text(
                                                    "Repetir contraseña: ",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 16.0
                                                    ),
                                                    textAlign: TextAlign.left,
                                                ),),
                                                SizedBox(width: 150, child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    obscureText: true,
                                                    validator: (value){
                                                        if(value != _passwdController.text){
                                                            return 'No coinciden';
                                                        }
                                                        return null;
                                                    },
                                                ),)
                                            ],
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 50.0),
                                        child: MaterialButton(
                                            minWidth: 200.0,
                                            height: 40.0,
                                            onPressed: () {},
                                            color: Colors.green,
                                            child: Text('Actualizar', style: TextStyle(color: Colors.white)),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    )
                ],
            ),
        );
    }

}