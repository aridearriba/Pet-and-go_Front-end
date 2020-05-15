import 'dart:convert';
import 'dart:typed_data';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/material.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/quedadas/vistaPerreParada.dart';
import '../../../Credentials.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class VisorImagenesWidget extends StatefulWidget {
  User user;
  PuntoInteres puntoInteres;
  List<ImageProvider> imagenes;

  VisorImagenesWidget(User User, PuntoInteres puntoInteres,List<ImageProvider> imagenes) {
    this.user = User;
    this.puntoInteres = puntoInteres;
    this.imagenes = imagenes;
  }

  @override
  VisorImagenesState createState() => VisorImagenesState();
}

class VisorImagenesState extends State<VisorImagenesWidget> {

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
          return Container(
            height: 225.0,
            child: Carousel(
              overlayShadow: false,
              borderRadius: true,
              boxFit: BoxFit.cover,
              autoplay: false,
              dotSize: 5.0,
              indicatorBgPadding: 9.0,
              images: [
                new ListView.builder(
                    itemCount: widget.imagenes.length,
                    itemBuilder: (BuildContext c, int i) {
                      return Image(
                        fit: BoxFit.cover,
                        image: widget.imagenes[i],
                      );
                    }
                ),

              ],
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: Duration(microseconds: 10500),
            ),
          );
      },
    );
  }

  ImageProvider getImage(ImageProvider<dynamic> imagen){
    return imagen;
  }

}

