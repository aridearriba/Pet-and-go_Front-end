import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/user/profile.dart';

class Edit extends StatelessWidget{
    Edit(this.user);
    User user;

    @override
    Widget build(BuildContext context) {

        final appTitle = 'petandgo';

        return GestureDetector(
            onTap: () {
                FocusScopeNode actualFocus = FocusScope.of(context);

                if(!actualFocus.hasPrimaryFocus){
                    actualFocus.unfocus();
                }

            },
            child: MaterialApp(
                title: appTitle,
                theme: ThemeData(
                    primaryColor: Colors.green
                ),
                home: Scaffold(
                    //resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                        title: Text("Editar usuario"),
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
                    body: EditForm(user),
                ),
            ),
        );
  }

}

class EditForm extends StatefulWidget{
    EditForm(this.user);
    User user;

    @override
    MyCustomFormState createState() => MyCustomFormState();

}

class MyCustomFormState extends State<EditForm>{
    final _formKey = GlobalKey<FormState>();

    final _controladorName = TextEditingController();
    final _controladorUsername = TextEditingController();
    final _controladorOldPasswd = TextEditingController();
    final _controladorNewPasswd = TextEditingController();

    var _statusCode;

    DateTime _dateTime;

    @override
    Widget build(BuildContext context) {
        _controladorName.text = widget.user.name;
        _controladorUsername.text = widget.user.username;
        return Form(
            key: _formKey,
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0),
                        child: Text(
                            "PERFIL DE USUARIO",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                            children: <Widget>[
                                Expanded(child: Text('Username: ', style: TextStyle(color: Colors.green),)),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                                    child: SizedBox(width: 200.0,child: TextFormField(
                                        controller: _controladorUsername,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.center,
                                        validator: (value){
                                            return null;
                                            },
                                        ),
                                    ),
                                ),
                            ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                            children: <Widget>[
                                Expanded(child: Text('Nombre: ', style: TextStyle(color: Colors.green))),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    child: SizedBox(width: 200.0,child: TextFormField(
                                        controller: _controladorName,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.center,
                                        validator: (value){
                                            return null;
                                        },
                                    ),
                                    ),
                                ),
                            ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0, left: 30.0, right: 30.0, bottom: 5.0),
                        child: Text(
                            "MODIFICAR CONTRASEÑA",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0),
                        child: Text(
                            "Si no quieres actualizar tu contraseña, no rellenes los siguientes campos.",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                            children: <Widget>[
                                Expanded(child: Text('Contraseña actual: ', style: TextStyle(color: Colors.green))),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                                    child: SizedBox(width: 150.0,child: TextFormField(
                                        controller: _controladorOldPasswd,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.center,
                                        validator: (value){
                                            return null;
                                        },
                                    ),
                                    ),
                                ),
                            ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                            children: <Widget>[
                                Expanded(child: Text('Nueva contraseña: ', style: TextStyle(color: Colors.green))),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                                    child: SizedBox(width: 150.0,child: TextFormField(
                                        controller: _controladorNewPasswd,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.center,
                                        validator: (value){
                                            return null;
                                        },
                                    ),
                                    ),
                                ),
                            ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                            children: <Widget>[
                                Expanded(child: Text('Repetir contraseña: ', style: TextStyle(color: Colors.green))),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                                    child: SizedBox(width: 150.0, child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.center,
                                        validator: (value){
                                            return null;
                                        },
                                    ),
                                    ),
                                ),
                            ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
                        child: RaisedButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: Text('Actualizar'),
                        ),
                    ),
                ],
            ),
        );
    }
}