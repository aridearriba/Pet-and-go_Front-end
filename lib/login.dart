import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'sign-up.dart';


/// This Widget is the main application widget.
class LogIn extends StatelessWidget {
    static const String _title = 'Pet and Go';

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: _title,
            theme: ThemeData(
                primaryColor: Colors.green
            ),
            home: Scaffold(
                appBar: AppBar(title: const Text(_title)),
                body: MyStatefulWidget(),
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
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Username',
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
                            decoration: const InputDecoration(
                                labelText: 'Contraseña',
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
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
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
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
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