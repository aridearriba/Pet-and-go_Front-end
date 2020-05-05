import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/screens/calendar/calendar.dart';
import 'package:petandgo/screens/calendar/viewEvent.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/pets/myPets.dart';
import 'package:petandgo/screens/user/profile.dart';
import '../home.dart';

class NewEvent extends StatelessWidget {
    NewEvent(this.user);
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
                    drawer: Menu(user),
                    appBar: AppBar(
                        title: Text("Añadir evento"),
                        iconTheme: IconThemeData(
                            color: Colors.white,
                        ),
                        actions: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                            )
                        ],
                    ),
                    body: NewEventForm(user),
                ),
            ),
        );
    }
}

// Creamos un Widget que sea un Form
class NewEventForm extends StatefulWidget {
    NewEventForm(this.user);
    User user;
    @override
    MyCustomFormState createState() => MyCustomFormState();
}

// Esta clase contendrá los datos relacionados con el formulario.
class MyCustomFormState extends State<NewEventForm> {

    final _formKey = GlobalKey<FormState>();

    final _controladorTitle = TextEditingController();
    final _controladorDate = TextEditingController();
    final _controladorHour = TextEditingController();
    final _controladorDescription = TextEditingController();

    var _statusCode;
    DateTime _dateTime;
    TimeOfDay _hour;

    // Navigate to Calendari
    nCalendar(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Calendari(widget.user))
        );
    }

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
                                labelText: "Título"
                            ),
                            controller: _controladorTitle,
                            keyboardType: TextInputType.text,
                            validator: (value){
                                if(value.isEmpty){
                                    return 'Por favor, escribe el título del evento.';
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
                                _controladorDate.text = _dateTime.day.toString() + ". " + _dateTime.month.toString() + ". " + _dateTime.year.toString();
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: 'Fecha'),
                                    controller: _controladorDate,
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
                        child: InkWell(
                            onTap: () async {
                                _hour = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: 12, minute: 0),
                                );
                                _controladorHour.text = _hour.hour.toString().padLeft(2, '0') + ':' + _hour.minute.toString().padLeft(2, '0');
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: 'Hora'),
                                    controller: _controladorHour,
                                    validator: (value){
                                        if(value.isEmpty){
                                            return 'Por favor, pon una hora.';
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
                            maxLines: 5,
                            decoration: InputDecoration(
                                labelText: "Descripción",
                                alignLabelWithHint: true,
                            ),
                            controller: _controladorDescription,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
                        child: RaisedButton(
                            onPressed: () => nCalendar(),
                            child: Text('Añadir'),
                        ),
                    ),
                ],
            ),
        );
    }
}