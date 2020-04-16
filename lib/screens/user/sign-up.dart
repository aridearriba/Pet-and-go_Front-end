import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../home.dart';

class SignUpPage extends StatelessWidget {
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
                        title: Text("Pet and Go"),
                    ),
                    body: MyCustomForm(),
                ),
            ),
        );
    }
}

// Creamos un Widget que sea un Form
class MyCustomForm extends StatefulWidget {
    @override
    MyCustomFormState createState() {
        return MyCustomFormState();
    }
}

// Esta clase contendrá los datos relacionados con el formulario.
class MyCustomFormState extends State<MyCustomForm> {

    final _formKey = GlobalKey<FormState>(); // así identificaremos el formulario

    final _controladorEmail = TextEditingController(); //así podremos capturar el email
    final _controladorPasswd = TextEditingController(); //así podremos capturar la contraseña
    final _controladorNombre = TextEditingController();
    final _controladorApellido1 = TextEditingController();
    final _controladorUsername = TextEditingController();

    var _responseMessage;
    var _email;

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
                                labelText: "Email:"
                            ),
                            controller: _controladorEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                                RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                if(value.isEmpty){
                                    return 'Por favor, escribe un email válido.';
                                }
                                if(!regex.hasMatch(value)){
                                    return 'Este email no es válido.';
                                }
                                if (_responseMessage == "Email en uso") {
                                    return 'Ya existe un usuario con este email';
                                }
                                return null;
                            },
                            onSaved: (value) => _email = value,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Username:",
                            ),
                            controller: _controladorUsername,
                            validator: (value){
                                if(value.isEmpty){
                                    return 'Por favor, escribe un username.';
                                }
                                if (_responseMessage == "Username en uso"){
                                    return 'Ya existe un usuario con este username';
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Nombre:",
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
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Apellidos:",
                            ),
                            controller: _controladorApellido1,
                            validator: (value){
                                if(value.isEmpty){
                                    return 'Por favor, escribe tus apellidos.';
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: "Contraseña:",
                            ),
                            controller: _controladorPasswd,
                            validator: (value){
                                if(value.isEmpty){
                                    return 'Por favor, escribe una contraseña.';
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            obscureText: true,
                            maxLength: 20,
                            decoration: InputDecoration(
                                labelText: "Repetir contraseña:"
                            ),
                            validator: (value) {
                                if(value!=_controladorPasswd.text){
                                    return 'Las contraseñas no coinciden.';
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
                                signUp().whenComplete(
                                () {
                                    // comprueba que los campos sean correctos
                                    if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        // Si el formulario es válido, queremos mostrar un Snackbar
                                        if(_responseMessage == "Usuario creado con exito") {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Usuario registrado con éxito!')));
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Home(_email))
                                            );
                                        }
                                        else Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text('No se ha podido registrar el usuario')));
                                    }
                                });
                            },
                            child: Text('Sign Up'),
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> signUp() async{
        http.Response response = await http.post(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'username': _controladorUsername.text,
                'password': _controladorPasswd.text,
                'email': _controladorEmail.text,
                'nombre': _controladorNombre.text + " " + _controladorApellido1.text}));
        _responseMessage = response.body;
    }
}