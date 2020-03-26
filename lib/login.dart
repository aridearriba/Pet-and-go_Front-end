import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:petandgo/user.dart';
import 'package:petandgo/home.dart';
import 'package:petandgo/sign-up.dart';

import 'user.dart';
import 'home.dart';
import 'sign-up.dart';
import 'profile.dart';
import 'sign-in-google.dart';
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

    var _email;

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
                            onSaved: (value) => _email = value,
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
                                            _formKey.currentState.save();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => Home(_email))
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
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 90.0),
                        child: _signInButton(),
                    ),
                ],
            ),
        );
    }

    Widget _signInButton() {
        return OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
                signInWithGoogle().whenComplete(() {
                    signUpGoogle().whenComplete(() {
                        signInGoogle().whenComplete(
                                () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home(email))
                                );
                            }
                        );
                    });
                });
                /*signInWithGoogle().whenComplete(() {
                    print ("EMAIL: "+email);
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                                return Home(email);
                            },
                        ),
                    );
                });*/
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Image(image: AssetImage("assets/images/google-logo.png"), height: 20.0),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                ),
                            )
                        )
                    ],
                ),
            ),
        );
    }
    Future<User> getData() async{
        var user = controladorEmail.text;
        final response = await http.get(new Uri.http("192.168.1.100:8080", "/api/usuarios/"+user));
        var userP = User.fromJson(jsonDecode(response.body));
        return userP;
    }

    Future<void> passData() async{
        http.Response response = await post(new Uri.http("192.168.1.100:8080", "/api/usuarios/login"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'email': controladorEmail.text,
                'password': controladorPasswd.text}));
        _responseMessage = response.body;
    }

    Future<void> signInGoogle() async{
        http.Response response = await post(new Uri.http("192.168.1.100:8080", "/api/usuarios/login"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'email': email,
                'password': ""}));
        _responseMessage = response.body;
    }

    Future<void> signUpGoogle() async{
        http.Response response = await http.post(new Uri.http("192.168.1.100:8080", "/api/usuarios/"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'username': nick,
                'password': "",
                'email': email,
                'nombre': name}));
        _responseMessage = response.statusCode;
    }
}