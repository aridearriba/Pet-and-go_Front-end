import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../Credentials.dart';
import 'vistaPerreParada.dart';
import 'adressField.dart';


class NuevaPerreParada extends StatelessWidget {
    NuevaPerreParada(this.user);
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
                    body: NuevaPerreParadaForm(user),
                ),
            ),
        );
    }
}

// Creamos un Widget que sea un Form
class NuevaPerreParadaForm extends StatefulWidget {
    NuevaPerreParadaForm(this.user);
    User user;
    @override
    NuevaPerreParadaState createState() => NuevaPerreParadaState();
}

// Esta clase contendrá los datos relacionados con el formulario.
class NuevaPerreParadaState extends State<NuevaPerreParadaForm> {

    final _formKey = GlobalKey<FormState>();

    final _controladorLocation = TextEditingController();
    final _controladorDate = TextEditingController();
    final _controladorHour = TextEditingController();

    var _statusCode;
    var _id;
    var uuid;

    DateTime _dateTime;
    TimeOfDay _hour;

    List<String> _placesList;
    List<Prediction> _predictions;
    Result _result;
    static double lat = 41.390205;
    static double lng = 2.154007;
    static String code = '';

    Completer<GoogleMapController> _controller = Completer();

    static final CameraPosition _camPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 10,
    );

    Future<void> getLocations(String input) async {
        if (input.isEmpty){
            return null;
        }
        input = input.replaceAll(" ", "+");
        String URL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$PLACES_API_KEY&sessiontoken=$uuid';
        final response = await http.get(URL);

        print(response.statusCode.toString());

        if (response.statusCode == 200) {
            var data = json.decode(response.body);
            var rest = data["predictions"] as List;
            print(rest);
            _predictions = rest.map<Prediction>((json) => Prediction.fromJson(json)).toList();
        } else {
            throw Exception('An error occurred getting places : PREDICTIONS');
        }
    }

    Future<void> getPlaceInfo(String name) async {
        String URL = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$name&key=$PLACES_API_KEY&sessiontoken=$uuid';
        final response = await http.get(URL);

        print(response.statusCode.toString());

        if (response.statusCode == 200) {
            var data = json.decode(response.body);
            var rest = data["result"];
            print(data);
            _result = Result.fromJson(rest);
        } else {
            throw Exception('An error occurred getting places : RESULT');
        }
    }

    @override
    void initState() {
        uuid = Uuid();
        super.initState();
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
                            child: NuevaPerreParada(uuid)
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
                                initialCameraPosition: _camPosition,
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
                                                            builder: (context) => VistaPerreParada(widget.user, _id))
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
        var date = _dateTime.toString() + ' ' + _hour.hour.toString() + ':' + _hour.minute.toString() + ':00';
        var today = DateTime.now().toString().substring(0, 10);
        var loc = _controladorLocation.text.toString();

        lat = _result.geo.loc.lat;
        lng = _result.geo.loc.lng;
        loc = _result.name;

        print('lat: $lat lng: $lng code: $loc');

        //getPlaceInfo(loc);
        //loc = code;

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
                'lugarInicio': loc, //PLUS_CODE
                'latitud':  lat,
                'longitud': lng,
                'idImageGoogle': '',
            }));
        _statusCode = response.statusCode;
        _id = int.parse(response.body);

        print('$_id');
        print(_statusCode);
    }
}


//GOOGLE MAPS RESPONSE CLASSES

class Result {
    Geometry _geo;
    String _name;

    Result({Geometry geo, String name})
    {
        this._geo = geo;
        this._name = name;
    }

    Geometry get geo => _geo;
    String get name => _name;

    factory Result.fromJson(Map<String, dynamic> json){
        return Result(
            geo: Geometry.fromJson(json['geometry']),
            name: json['formatted_address'],
        );
    }
}

class Geometry {

    Location _loc;

    Geometry({Location loc})
    {
        this._loc = loc;
    }

    Location get loc => _loc;

    factory Geometry.fromJson(Map<String, dynamic> json){
        return Geometry(
            loc: Location.fromJson(json ['location'])
        );
    }
}

class Location {

    double _lat, _lng;

    Location({double lat, double lng})
    {
        this._lat = lat;
        this._lng = lng;
    }

    double get lat => _lat;
    double get lng => _lng;


    factory Location.fromJson(Map<String, dynamic> json){
        return Location(
            lat: json['lat'],
            lng: json['lng']
        );
    }
}

class Photo {
    double _height, _width;
    String _ref;

    Photo({double h, double w, String ref})
    {
        this._height = h;
        this._width = w;
        this._ref = ref;
    }

    double get height => _height;
    double get width => _width;
    String get ref => _ref;


    factory Photo.fromJson(Map<String, dynamic> json){
        return Photo(
            h: json['height'],
            w: json['width'],
            ref: json['photo_reference']
        );
    }
}