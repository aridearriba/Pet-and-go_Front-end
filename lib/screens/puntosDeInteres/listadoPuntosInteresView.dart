import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/model/user.dart';
import 'SquarePuntosInteresView.dart';

class ListaPuntosInteresWidget extends StatelessWidget{

    User user;
    String tipo;
    PuntosInteres puntosInteres;
    LatLng position;

    ListaPuntosInteresWidget(User user,PuntosInteres puntosInteres,LatLng position){
        this.user = user;
        this.tipo = "veterinario";
        this.puntosInteres = puntosInteres;
        this.position = position;
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
                            return SquarePuntoInteresWidget( user, puntosInteres.results[i],position);
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
                );
            }
        );
    }

}