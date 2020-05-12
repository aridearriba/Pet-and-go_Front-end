import 'dart:convert';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/material.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/puntosDeInteres/mapaPuntosInteres.dart';
import 'package:petandgo/screens/puntosDeInteres/puntoInteres/visorImagenesWidget.dart';
import 'package:petandgo/screens/quedadas/vistaPerreParada.dart';
import '../../../Credentials.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class MapaPuntoInteresView extends StatefulWidget {
  User user;
  LatLng position;
  PuntosInteres puntosInteres;

  MapaPuntoInteresView(User User, PuntosInteres puntosInteres,LatLng position) {
    this.user = User;
    this.puntosInteres = puntosInteres;
    this.position = position;
  }

  @override
  MapaPuntoInteresState createState() => MapaPuntoInteresState();
}

class MapaPuntoInteresState extends State<MapaPuntoInteresView> {

  nMaps() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MapaPuntosInteresWidget(widget.user,widget.puntosInteres,widget.position)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(widget.user),
      appBar: AppBar(
        title: Text('Puntos de interes',style: TextStyle(color: Colors.white,),),
        iconTheme: IconThemeData(color: Colors.white,),
      ),
      body: MapaPuntosInteresWidget(widget.user,widget.puntosInteres,widget.position),
      );
  }

}

