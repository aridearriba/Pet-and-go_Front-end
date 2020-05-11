import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/model/PerreParada.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/model/user.dart';
import 'SquarePuntosInteresView.dart';
import '../../Credentials.dart';
import 'package:geolocator/geolocator.dart';

class ListaPuntosInteresWidget extends StatelessWidget{

  User user;
  String tipo;
  PuntosInteres puntosInteres;

  ListaPuntosInteresWidget(User user,PuntosInteres puntosInteres){
    this.user = user;
    this.tipo = "veterinario";
    this.puntosInteres = puntosInteres;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (BuildContext context) {
          return Container(
            height: 500,
            child: ListView.separated(
              itemCount: puntosInteres.results.length,
              itemBuilder: (BuildContext context, int i){
                return SquarePuntoInteresWidget( user, puntosInteres.results[i]);
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          );
      }
    );
  }

}