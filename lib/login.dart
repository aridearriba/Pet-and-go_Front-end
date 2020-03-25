import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'sign-up.dart';
import 'profile.dart';
import 'sign-in-google.dart';


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
                    ),
                ),
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
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                                return Profile();
                            },
                        ),
                    );
                });
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
                        Image(image: AssetImage("assets/images/google_logo.png"), height: 20.0),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                ),
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}