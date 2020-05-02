import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:petandgo/global/global.dart' as Global;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:petandgo/model/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/screens/user/profile.dart';
import '../../Credentials.dart';
import '../home.dart';
import 'package:rxdart/rxdart.dart';


class NewDogStop extends StatelessWidget {
    NewDogStop(this.user);
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
                        title: Text("Crea una nueva Perreparada")
                    ),
                    body: NewDogStopForm(user),
                ),
            ),
        );
    }
}

// Creamos un Widget que sea un Form
class NewDogStopForm extends StatefulWidget {
    NewDogStopForm(this.user);
    User user;
    @override
    MyCustomFormState createState() => MyCustomFormState();
}

// Esta clase contendrá los datos relacionados con el formulario.
class MyCustomFormState extends State<NewDogStopForm> {

    final _formKey = GlobalKey<FormState>();

    final _controladorLocation = TextEditingController();
    final _controladorDate = TextEditingController();
    final _controladorHour = TextEditingController();

    var _statusCode;
    var _id;

    DateTime _dateTime;
    TimeOfDay _hour;
    Places _location;

    List<Places> _placesList;

    AutoCompleteTextField<Places> textField;

    Places selected;

    static double lat = 41.390205;
    static double lng = 2.154007;

    Completer<GoogleMapController> _controller = Completer();

    static final CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 10,
    );

    void getLocations(String input) async {
        if (input.isEmpty){
            return null;
        }

        String baseURL = 'https://mpas.googleapis.com/maps/api/place/autocomplete/json';
        String type = 'address';
        String language = 'es';

        //ADD SESION TOKEN??

        String request = '$baseURL?input=$input&key=$PLACES_API_KEY&type=$type&language=$language';
        final response = await Dio().get(request);

        final predictions = response.data['predictions'];

        List<Places> _displayResults = [];

        for (var i=0; i < predictions.length; i++){
            Places p = new Places();
            p.name = predictions[i]['description'];
            p.id = predictions[i]['id'];
            _displayResults.add(p);
        }

       _placesList = _displayResults;
    }

    Future<void> getLatLng(Places p) async {
        String baseURL = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
        String language = 'es';
        String name = p.name;

        String request = '$baseURL?query=$name&key=$PLACES_API_KEY&language=$language';
        final response = await Dio().get(request);

        final prediction = response.data['candidates'];

        lat = prediction[0]['geometry']['location']['lat'];
        print(lat);
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            body: Form(
                key: _formKey,
                child: ListView(
                    children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Dirección:"
                                ),
                                controller: _controladorLocation,
                                keyboardType: TextInputType.text,
                                validator: (value){
                                    if(value.isEmpty){
                                        return 'Por favor, escribe una direccion.';
                                    }
                                    else if (_statusCode == 500){
                                        return 'Ya hay otra quedada en esa hora por esa zona, apunntate!.';
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
                                        decoration: new InputDecoration(labelText: 'Fecha:'),
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
                                    _controladorHour.text = _hour.hour.toString() + ':' + _hour.minute.toString();
                                },
                                child: IgnorePointer(
                                    child: new TextFormField(
                                        decoration: new InputDecoration(labelText: 'Hora:'),
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
                        Container(
                            width: 50,
                            height: 300,
                            child: GoogleMap(
                                mapType: MapType.hybrid,
                                initialCameraPosition: _kGooglePlex,
                                onMapCreated: (GoogleMapController controller) {
                                    _controller.complete(controller);
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
                                                                'Perreparada añadida con éxito!')));
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => Home(widget.user))
                                                    );
                                                }
                                                else Scaffold.of(context).showSnackBar(SnackBar(
                                                    content: Text('No se ha podido la Perreparada')));
                                            }
                                        });
                                },
                                child: Text('Añadir'),
                            ),
                        ),
                    ],
                ),
            ),

        );
    }

    Future<void> add() async{
        var email = widget.user.email;
        var date = _dateTime.toString().substring(0, 10) + ' ' + _hour.hour.toString() + ':' + _hour.minute.toString() + ':00';
        var today = DateTime.now().toString().substring(0, 10);
        var loc = _controladorLocation.text.toString();
        print("DATE: $date");
        http.Response response = await http.post(new Uri.http(Global.apiURL, "/api/quedadas"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: jsonEncode({
                'admin': email,
                'createdAt': today,
                'fechaQuedada': date,
                'lugarInicio': loc,
                'lugarFin': loc,
                }));
        _statusCode = response.statusCode;
        _id = response.body;

        print('$_id');
        print(_statusCode);
    }
}

class Places {
    String name;
    String id;
}
