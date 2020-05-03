import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petandgo/model/DogStop.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/screens/pets/myPets.dart';

import '../../Credentials.dart';
import '../home.dart';


class DogStopWidget extends StatefulWidget {

    DogStopWidget(this.user, this.id);

    User user;
    int id;

    @override
    _DogStopState createState() => _DogStopState();
}

class _DogStopState extends State<DogStopWidget>{

    nHome(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(widget.user))
        );
    }

    DogStop _dogStop;
    var _statusCode;

    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    Completer<GoogleMapController> _controller = Completer();

    static double lat;
    static double lng;

    /*Future<void> getLatLng(String name) async {

        final prediction = response.data['candidates'];

        lat = prediction[0]['geometry']['location']['lat'];
        lng = prediction[0]['geometry']['location']['lng'];

        String URL = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$name&key=$PLACES_API_KEY';
        final response = await http.get(URL);

        print(response.statusCode.toString());

        if (response.statusCode == 200) {
            var data = json.decode(response.body);
            var rest = data["result"];
            print(data);
            _result = Result.fromJson(rest);
        } else {
            throw Exception('An error occurred getting places nearby error: ');
        }



        print(lat);
    }*/

    Future<void> getDogStop(int id) async{
        http.Response response = await http.get(new Uri.http("petandgo.herokuapp.com", "/api/quedadas/1"));
        print('HEY HEREEEEEEEEEE');
        print(' --------> ' + response.body.toString());
        _dogStop = DogStop.fromJson(json.decode(response.body));
    }

    @override void initState() {
        getDogStop(widget.id);
        super.initState();
  }

    static final CameraPosition _camPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14.4746,
    );

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: _scaffoldKey,
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Perreparada',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => nHome(),
                    )
                ],
            ),
            body: ListView(
                children: <Widget>[
                    Text('' + _dogStop.locationOrigin),
                    Text('' + _dogStop.date.toString()),
                    Text('de ' + _dogStop.admin),
                ],
            ),
        );
    }

    Set<Marker> _createMarkers(){
        var tmp = Set<Marker>();
        tmp.add(Marker(
            markerId: MarkerId("DosgStopPoint"),
            position: LatLng(lat, lng),
        ));
        return tmp;
    }
}

