import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final appTitle = 'Pet_and_Go_register';
        
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

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Email:"
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                        child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: "Contraseña:",
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                        child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: "Repetir contraseña:"
                            ),
                        ),
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: RaisedButton(
                            onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                // comprueba que los campos sean correctos
                                if (_formKey.currentState.validate()) {
                                    // Si el formulario es válido, queremos mostrar un Snackbar
                                    Scaffold.of(context)
                                        .showSnackBar(SnackBar(content: Text('Usuario registrado con éxito!')));
                                }
                            },
                            child: Text('Sign Up'),
                        ),
                    ),
                ],
            ),
        );
    }
}