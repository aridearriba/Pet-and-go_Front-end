import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:petandgo/global/global.dart' as Global;
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

    Future<String> getDogStop(int id) async{

        String URL = 'https://petandgo.herokuapp.com/api/quedadas/$id';
        final response = await http.get(URL);

        if (response.statusCode == 200) {
            var data = json.decode(response.body);
            print(data);
            setState(() {
                _dogStop = DogStop.fromJson(data);
            });
            return data.toString();
        } else {
            throw Exception('An error occurred getting places nearby');
        }

        return null;

    }

    static final CameraPosition _camPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14.4746,
    );

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<String>(
            future: getDogStop(widget.id),// a previously-obtained Future<String> or null
            // ignore: missing_return
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                List<Widget> children;

                if (snapshot.hasData) {
                    children = <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 16),
                        ),
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                ),
                                Text(
                                    '${_dogStop.admin}',
                                ),
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.place,
                                    color: Colors.grey,
                                ),
                                Text(
                                    '${_dogStop.locationOrigin}',
                                ),
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                ),
                                Text(
                                    '${_dogStop.date.day}/${_dogStop.date.month}/${_dogStop.date.year} a las ${_dogStop.date.hour}:${_dogStop.date.minute}',
                                ),
                            ],
                        ),
                    ];
                }
                else if (snapshot.hasError) {
                    children = <Widget>[
                        Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                        )
                    ];
                }
                else {
                    children = <Widget>[
                        SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting result...'),
                        )
                    ];
                }
                return Scaffold(
                    key: _scaffoldKey, drawer: Menu(widget.user),
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
                                icon: Icon(Icons.home, color: Colors.white),
                                onPressed: () => nHome(),
                            ),
                        ],
                    ),
                    body: ListView(
                        children: <Widget>[
                            Column(
                                children: children,
                            ),
                        ],
                    ),
                );
            }
            );
    }
}
