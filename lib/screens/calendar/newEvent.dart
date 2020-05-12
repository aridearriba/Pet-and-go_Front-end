import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/screens/calendar/calendar.dart';
import 'package:petandgo/screens/menu/menu.dart';

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
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => Calendari(user))
                                ),
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
    final _controladorDateIni = TextEditingController();
    final _controladorHourIni = TextEditingController();
    final _controladorDateEnd = TextEditingController();
    final _controladorHourEnd = TextEditingController();
    final _controladorDescription = TextEditingController();

    var _statusCode;
    DateTime _dateIni, _dateEnd;
    TimeOfDay _timeIni, _timeEnd;

    // Navigate to Calendari
    nCalendar(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Calendari(widget.user))
        );
    }

    @override
    Widget build(BuildContext context) {
        _dateIni = DateTime.now();
        _dateEnd = _dateIni.add(Duration(hours: 1));
        _timeIni = TimeOfDay.fromDateTime(_dateIni);
        _timeEnd = TimeOfDay.fromDateTime(_dateEnd);

        _controladorDateIni.text = _dateIni.day.toString().padLeft(2, '0') + ". " + _dateIni.month.toString().padLeft(2, '0') + ". " + _dateIni.year.toString();
        _controladorDateEnd.text = _dateEnd.day.toString().padLeft(2, '0') + ". " + _dateEnd.month.toString().padLeft(2, '0') + ". " + _dateEnd.year.toString();
        _controladorHourIni.text = _timeIni.hour.toString().padLeft(2, '0') + ':' + _timeIni.minute.toString().padLeft(2, '0');
        _controladorHourEnd.text = _timeEnd.hour.toString().padLeft(2, '0') + ':' + _timeEnd.minute.toString().padLeft(2, '0');

        return Form(
            key: _formKey,
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    // nombre
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
                    Divider(indent: 15, endIndent: 15),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: InkWell(
                            onTap: () async {
                                _dateIni = await showDatePicker(
                                    context: context,
                                    initialDate: _dateIni == null ? DateTime.now() : _dateIni,
                                    firstDate: DateTime(DateTime.now().year - 20),
                                    lastDate: DateTime(DateTime.now().year + 1)
                                );
                                _controladorDateIni.text = _dateIni.day.toString().padLeft(2, '0') + ". " + _dateIni.month.toString().padLeft(2, '0') + ". " + _dateIni.year.toString();
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: 'Fecha inicio'),
                                    controller: _controladorDateIni,
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
                                _timeIni = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                                );
                                _controladorHourIni.text = _timeIni.hour.toString().padLeft(2, '0') + ':' + _timeIni.minute.toString().padLeft(2, '0');
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: 'Hora inicio'),
                                    controller: _controladorHourIni,
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
                        child: InkWell(
                            onTap: () async {
                                _dateEnd = await showDatePicker(
                                    context: context,
                                    initialDate: _dateIni == null ? DateTime.now() : _dateIni,
                                    firstDate: DateTime(DateTime.now().year - 20),
                                    lastDate: DateTime(DateTime.now().year + 1)
                                );
                                _controladorDateEnd.text = _dateEnd.day.toString().padLeft(2, '0') + ". " + _dateEnd.month.toString().padLeft(2, '0') + ". " + _dateEnd.year.toString();
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: 'Fecha fin'),
                                    controller: _controladorDateEnd,
                                    validator: (value){
                                        if(value.isEmpty){
                                            return 'Por favor, pon una fecha.';
                                        }
                                        if(_dateEnd.isBefore(_dateIni)){
                                            return 'La fecha fin debe ser posterior a la de inicio.';
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
                                _timeEnd = await showTimePicker(
                                    context: context,
                                    initialTime: _timeIni == null ? TimeOfDay(hour: 12, minute: 0) : _timeIni.replacing(hour: _timeIni.hour + 1)
                                );
                                _controladorHourEnd.text = _timeEnd.hour.toString().padLeft(2, '0') + ':' + _timeEnd.minute.toString().padLeft(2, '0');
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: 'Hora fin'),
                                    controller: _controladorHourEnd,
                                    validator: (value){
                                        if(value.isEmpty){
                                            return 'Por favor, pon una hora.';
                                        }
                                        if(_dateIni.compareTo(_dateEnd) == 0 &&
                                            ((_timeEnd.hour == _timeIni.hour && _timeEnd.minute <= _timeIni.minute) ||
                                                (_timeEnd.hour < _timeIni.hour))){
                                            return 'La hora fin debe ser posterior a la de inicio.';
                                        }
                                        return null;
                                    },
                                    onSaved: (String val) {},
                                ),
                            ),
                        ),
                    ),
                    Divider(indent: 15, endIndent: 15),
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
                            onPressed: () {
                                if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                        addEvent().whenComplete(
                                            () {
                                                    if (_statusCode == 201) {
                                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Evento añadido con éxito!')));
                                                        nCalendar();
                                                    }
                                                    else if (_statusCode == 404) {
                                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Ya tienes otro evento en ese rango de fecha/hora')));
                                                    }
                                                    else {
                                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('No se ha podido añadir el evento.')));
                                                    }
                                                }
                                        );
                                }
                            },
                            child: Text('Añadir'),
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> addEvent() async{
        var email = widget.user.email;
        var eventDateIni = new DateTime(_dateIni.year, _dateIni.month, _dateIni.day, _timeIni.hour, _timeIni.minute);
        var dateStringIni = eventDateIni.toIso8601String();
        var eventDateEnd = new DateTime(_dateEnd.year, _dateEnd.month, _dateEnd.day, _timeEnd.hour, _timeEnd.minute);
        var dateStringEnd = eventDateEnd.toIso8601String();

        http.Response response = await http.post(new Uri.http("petandgo.herokuapp.com", "/api/calendario/" + email + "/eventos"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString()
            },
            body: jsonEncode({
                'titulo': _controladorTitle.text,
                'usuario': widget.user.email,
                'fecha': dateStringIni,
                'fechaFin': dateStringEnd,
                'descripcion': _controladorDescription.text}));
        _statusCode = response.statusCode;

        print("STATUS CODE: $_statusCode");
    }
}