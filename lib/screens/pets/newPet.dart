import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
                        title: Text("Añadir mascota")
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

    final _formKey = GlobalKey<FormState>();

    final _controladorName = TextEditingController();
    final _controladorBirthday = TextEditingController();
    final _controladorRaza = TextEditingController();

    var _statusCode;

    DateTime _dateTime;

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
                            controller: _controladorName,
                            keyboardType: TextInputType.text,
                            validator: (value){
                                if(value.isEmpty){
                                    return 'Por favor, escribe el nombre de tu mascota.';
                                }
                                else if (_statusCode == 500){
                                    return 'Ya tienes otra mascota con este nombre.';
                                }

                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: InkWell(
                            onTap: () async {
                                    _dateTime = await showDatePicker(
                                        context: context,
                                        initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                        firstDate: DateTime(DateTime.now().year - 20),
                                        lastDate: DateTime(DateTime.now().year + 1)
                                    );
                                    _controladorBirthday.text = _dateTime.day.toString() + ". " + _dateTime.month.toString() + ". " + _dateTime.year.toString();
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: 'Fecha de nacimiento:'),
                                    controller: _controladorBirthday,
                                    validator: (value){
                                        if(value.isEmpty){
                                            return 'Por favor, pon una fecha.';
                                        }
                                        return null;
                                    },
                                    onSaved: (String val) {},
                                ),
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Raza:",
                            ),
                            controller: _controladorRaza,
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
        var date = _dateTime.toString().substring(0, 10);
        print("DATE: " + _dateTime.toString().substring(0, 10));
        http.Response response = await http.post(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/" + email + "/mascotas"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
                'id': {
                    'nombre': _controladorName.text,
                    'amo': widget.user.email
                },
                'fechaNacimiento': date}));
        _statusCode = response.statusCode;
    }
}