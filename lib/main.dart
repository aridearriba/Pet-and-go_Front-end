import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
    static const String _title = 'Pet and Go';

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: _title,
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
    var _password = 'hola';

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                                RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                if (value.isEmpty) {
                                    return 'Por favor, escribe un email';
                                }
                                else if (!regex.hasMatch(value)) {
                                    return 'Escribe un email válido';
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
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: RaisedButton(
                            onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey.currentState.validate()) {
                                    // Process data.
                                }
                            },
                            child: Text('Log in'),
                        ),
                    ),
                ],
            ),
        );
    }
}