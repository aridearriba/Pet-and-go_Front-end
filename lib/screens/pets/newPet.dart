import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/screens/user/profile.dart';
import '../home.dart';

class NewPet extends StatelessWidget {
    NewPet(this.user);
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
                        title: Text("Añadir mascota"),
                    ),
                    body: NewPetForm(user),
                ),
            ),
        );
    }
}

// Creamos un Widget que sea un Form
class NewPetForm extends StatefulWidget {
    NewPetForm(this.user);
    User user;
    @override
    MyCustomFormState createState() => MyCustomFormState();
}

// Esta clase contendrá los datos relacionados con el formulario.
class MyCustomFormState extends State<NewPetForm> {

    final _formKey = GlobalKey<FormState>(); // así identificaremos el formulario

    final _controladorEmail = TextEditingController(); //así podremos capturar el email
    final _controladorPasswd = TextEditingController(); //así podremos capturar la contraseña
    final _controladorNombre = TextEditingController();
    final _controladorApellido1 = TextEditingController();
    final _controladorUsername = TextEditingController();

    var _statusCode;

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Nombre:"
                            ),
                            controller: _controladorEmail,
                            keyboardType: TextInputType.text,
                            validator: (value){
                                if(value.isEmpty){
                                    return 'Por favor, escribe el nombre de tu mascota.';
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Fecha nacimiento:",
                            ),
                            controller: _controladorUsername,
                            keyboardType: TextInputType.datetime,
                            validator: (value){
                                if(value.isEmpty){
                                    return 'Por favor, escribe una fecha.';
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Raza:",
                            ),
                            controller: _controladorNombre,
                            validator: (value){
                                if(value.isEmpty){
                                    return 'Por favor, escribe tu nombre.';
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
                        child: RaisedButton(
                            onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                add().whenComplete(
                                        () {
                                        // comprueba que los campos sean correctos
                                        if (_formKey.currentState.validate()) {
                                            _formKey.currentState.save();
                                            // Si el formulario es válido, queremos mostrar un Snackbar
                                            if(_statusCode == 201) {
                                                Scaffold.of(context).showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Mascota añadida con éxito!')));
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Profile(widget.user))
                                                );
                                            }
                                            else Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text('No se ha podido añadir la mascota')));
                                        }
                                    });
                            },
                            child: Text('Añadir'),
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> add() async{
        var email = widget.user.email;
        http.Response response = await http.post(new Uri.http("192.168.1.100:8080", "/api/usuarios/" + email + "/mascotas"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'id': _controladorUsername.text,
                'password': _controladorPasswd.text,
                'email': _controladorEmail.text,
                'date': _controladorNombre.text + " " + _controladorApellido1.text}));
        _statusCode = response.statusCode;
    }
}