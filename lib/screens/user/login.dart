import 'dart:convert';
import 'dart:io';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/user/sign-up.dart';

import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

/// This Widget is the main application widget.
class LogIn extends StatelessWidget {
    static const String _title = 'Pet and Go';

    @override
    Widget build(BuildContext context) {
        _googleSignIn.disconnect();
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
    var _responseCode, _token;
    final controladorEmail = new TextEditingController();
    final controladorPasswd = new TextEditingController();

    User user = new User();

    void nHome(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(user))
        );
    }

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
                                else if (_responseCode == 400) {
                                    return 'Usuario o contraseña incorrectos';
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
                                else if (_responseCode == 400) {
                                    return 'Usuario o contraseña incorrectos';
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
                                login(controladorEmail.text, controladorPasswd.text).whenComplete(
                                    () {
                                        if (_formKey.currentState.validate()) {
                                            if(_responseCode != 200) {
                                                Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text('No se ha podido completar el login')));
                                            }
                                            else {
                                                getData().whenComplete(
                                                    () => getProfileImage().whenComplete(
                                                        () {    Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => Home(user))
                                                            );
                                                        }
                                                    )
                                                );
                                            }
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
                _googleAccountSignIn().whenComplete(
                        () {
                        getProfileImage().whenComplete( () =>
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home(user))
                        ));
                    }
                );
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Image(
                            image: AssetImage("assets/images/google-logo.png"),
                            height: 20.0),
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

    Future<void> getProfileImage() async{
        var email = user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/image"));
        user.image = response.body;
    }

    Future<void> getData() async{
        var email = controladorEmail.text;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/"+email));
        user = User.fromJson(jsonDecode(response.body));
        user.token = _token;
    }

    Future<void> _googleAccountSignIn() async{
        try{
            await _googleSignIn.signIn();
            user.email = _googleSignIn.currentUser.email;
            user.username = _googleSignIn.currentUser.displayName.toLowerCase().replaceAll(" ", "");
            user.name = _googleSignIn.currentUser.displayName;
            if (_googleSignIn.currentUser.photoUrl.runtimeType != Null) user.profileImageUrl = _googleSignIn.currentUser.photoUrl;
            signUp().whenComplete(
                () => login(user.email, "").whenComplete(
                    (){
                        user.token = _token.toString();
                    }
                )
            );
        }catch(error){
            print(error);
        }
    }

    Future<void> login(String email, String password) async{
         Uri uri= new Uri.http(Global.apiURL, "/api/usuarios/login");
        http.Response response = await post(uri,
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'email': email,
                'password': password}));
        _responseCode = response.statusCode;
        _token = response.headers['authorization'].toString();
    }

    Future<void> signUp() async{
        http.Response response = await http.post(new Uri.http(Global.apiURL, "/api/usuarios/"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'username': user.username,
                'password': "",
                'email': user.email,
                'nombre': user.name}));
        _responseCode = response.statusCode;
    }
}