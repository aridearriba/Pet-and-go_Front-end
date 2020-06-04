import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/puntosDeInteres/mapaPuntosInteres.dart';


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
                title: Text(AppLocalizations.of(context).translate('points-of-interest_one_title'), style: TextStyle(color: Colors.white)),
                iconTheme: IconThemeData(color: Colors.white,),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                    )
                ],
            ),
            body: MapaPuntosInteresWidget(widget.user,widget.puntosInteres,widget.position),
        );
    }

}

