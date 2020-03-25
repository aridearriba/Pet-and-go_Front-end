import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'user.dart';
import 'home.dart';
import 'sign-up.dart';
import 'package:http/http.dart' as http;


/// This Widget is the main application widget.
class LogIn extends StatelessWidget {
    static const String _title = 'Pet and Go';

    @override
    Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return GestureDetector(
            onTap: () {
                FocusScopeNode actualFocus = FocusScope.of(context);

                if(!actualFocus.hasPrimaryFocus){
                    actualFocus.unfocus();
                }
            },

            child: MaterialApp(
                title: _title,
                theme: ThemeData(
                    primaryColor: Color.fromRGBO(63, 202, 12, 1),
                ),
                home: Scaffold(
                    body: Stack(
                        children: <Widget>[
                        Center(
                            child: new Image.asset(
                                'assets/images/background-login.jpg',
                                height: size.height,
                                fit: BoxFit.fitHeight,
                            ),
                        ),
                        Center(
                            child: MyStatefulWidget(),
                        )
                    ]
                    ),),
            ),
        );
    }
}

class MyStatefulWidget extends StatefulWidget {
    MyStatefulWidget({Key key}) : super(key: key);

    @override
    _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
    final _formKey = GlobalKey<FormState>();
    var _responseMessage;
    final controladorEmail = new TextEditingController();
    final controladorPasswd = new TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 70.0),
                        child: Image.asset('assets/images/pet-and-go-logo.png', height: 150),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                        child: TextFormField(
                            style: TextStyle(
                                color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: controladorEmail,
                            validator: (value) {
                                if (value.isEmpty) {
                                    return 'Por favor, escribe un email.';
                                }
                                else if (_responseMessage == "El email no existe") {
                                    return 'Este email no está registrado';
                                }

                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                            style: TextStyle(
                                color: Colors.white
                            ),
                            decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                ),
                            ),
                            controller: controladorPasswd,
                            validator: (value) {
                                if (value.isEmpty) {
                                    return 'Por favor, escribe tu constraseña';
                                }
                                else if (_responseMessage == "Password incorrecto") {
                                    return 'Contraseña incorrecta';
                                }
                                return null;
                            },
                            obscureText: true,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:30.0, bottom: 20.0, left: 90.0, right: 90.0),
                        child: RaisedButton(
                            onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid
                                passData().whenComplete(
                                    () {
                                        if (_formKey.currentState.validate()) {
                                            //passData();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => Home())
                                            );
                                        }
                                    }
                                );
                            },
                            child: Text('Log in'),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90.0),
                        child: Center(
                            child: Text(
                                'or',
                                style: TextStyle(color: Colors.white),
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 90.0),
                        child: RaisedButton(
                            onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage())
                                );
                            },
                            child: Text('Sign up'),
                        ),
                    ),
                ],
            ),
        );
    }
    Future<User> getData() async{
        var user = controladorEmail.text;
        final response = await http.get(new Uri.http("192.168.1.100:8080", "/api/usuarios/"+user));
        var userP = User.fromJson(jsonDecode(response.body));
        return userP;
    }

    Future<http.Response> passData() async{
        http.Response response = await post(new Uri.http("192.168.1.100:8080", "/api/usuarios/login"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'email': controladorEmail.text,
                'password': controladorPasswd.text}));
        _responseMessage = response.body;
        print(response.body);
    }
}