import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/screens/puntosDeInteres/listadoPuntosInteresView.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';

import '../../Credentials.dart';
import 'mapaPuntosInteres.dart';
import 'package:http/http.dart' as http;

class PuntosInteresTabView extends StatefulWidget {

    PuntosInteresTabView(this.user);

    User user;
    String tipo = "veterinario";
    LatLng origen;

    @override
    PuntosInteresTabState createState() => PuntosInteresTabState();
}

class PuntosInteresTabState extends State<PuntosInteresTabView>{

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text('Puntos de interes',style: TextStyle(color: Colors.white,),),
                iconTheme: IconThemeData(color: Colors.white,),
            ),
            body: Column(
                children: <Widget>[
                    buildTab(context)
                ]
            ),
        );
    }


    @override
    Widget buildTab(BuildContext context) {
        return FutureBuilder(
            future: getPuntosInteres(widget.tipo),
            builder: (BuildContext context, AsyncSnapshot<PuntosInteres> snapshot) {
                if (! snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(),
                    );
                } else {
                    return Expanded(
                        child: Column(
                            children: <Widget>[
                                DefaultTabController(
                                    length: 2,
                                    child: Expanded(

                                        child: Column(
                                            children: <Widget>[
                                                TabBar(
                                                    unselectedLabelColor: Colors.grey,
                                                    indicatorColor: Colors.green,
                                                    tabs: [
                                                        Tab(text: "Ver listado",),
                                                        Tab(text: "Ver mapa",),
                                                    ],
                                                ),
                                                Expanded(
                                                    child: TabBarView(
                                                        physics: NeverScrollableScrollPhysics(),
                                                        children: [
                                                            ListaPuntosInteresWidget(widget.user,snapshot.data,widget.origen),
                                                            MapaPuntosInteresWidget(widget.user,snapshot.data,widget.origen),
                                                        ],
                                                    ),
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    );
                }
            }
        );
    }

    Future<PuntosInteres> getPuntosInteres(String tipo) async{
        String url = "maps.googleapis.com";
        String path = "/maps/api/place/textsearch/json";
        String location = await getCurrentLocation();
        return await getPuntosInteresApi(url,path,location);
        //return new PuntosInteres();
    }

    Future<PuntosInteres> getPuntosInteresApi(String url,String path,String location) async {
        var queryParameters = {
            "radius": "100",
            "input": widget.tipo,
            "location": location,
            "key": PLACES_API_KEY,
        };

        Uri uri = new Uri.https(url, path, queryParameters);
        var res;

        try {
            final response = await http.get(uri);
            res = json.decode(response.body);
            if (res.containsKey("status"))
                return puntosInteresFromJson(response.body);
        } catch (e) {
            return null;
        }
    }

    Future<String> getCurrentLocation() async {
        final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        widget.origen = new LatLng(position.latitude,position.longitude);
        return position.toString();
    }
}