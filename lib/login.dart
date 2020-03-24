import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'sign-up.dart';
import 'package:http/http.dart' as http;


/// This Widget is the main application widget.
class LogIn extends StatelessWidget {
    static const String _title = 'Pet and Go';

    @override
    Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return MaterialApp(
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
    var _username = 'user';
    var _password = 'hola';

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
                                labelText: 'Usuario',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                                if (value.isEmpty) {
                                    return 'Por favor, escribe un username';
                                }
                                else if (value != _username) {
                                    return 'Este username no existe';
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
                            validator: (value) {
                                if (value.isEmpty) {
                                    return 'Por favor, escribe tu constraseña';
                                }
                                else if (value != _password) {
                                    return 'Contraseña incorrecta';
                                }
                                return null;
                            },
                            onSaved: (value) => _password = value,
                            obscureText: true,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:30.0, bottom: 20.0, left: 90.0, right: 90.0),
                        child: RaisedButton(
                            onPressed: () {

                                Future getData() async{
                                    http.Response response = await http.get(new Uri.http("192.168.1.43:8080", "/api/usuarios"));
                                    var data = jsonDecode(response.body);
                                    print(data.toString());
                                }

                                getData();
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid
                                if (_formKey.currentState.validate()) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => Home())
                                    );
                                }
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
}