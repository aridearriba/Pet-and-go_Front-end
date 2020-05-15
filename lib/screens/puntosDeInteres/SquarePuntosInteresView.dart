import 'dart:convert';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/material.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/puntosDeInteres/puntoInteres/puntoInteresView.dart';
import 'package:petandgo/screens/quedadas/vistaPerreParada.dart';
import '../../Credentials.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class SquarePuntoInteresWidget extends StatefulWidget {
    User user;
    PuntoInteres puntoInteres;
    LatLng position;

    SquarePuntoInteresWidget(User User, PuntoInteres puntoInteres,LatLng position) {
        this.user = User;
        this.puntoInteres = puntoInteres;
        this.position = position;
    }

    @override
    SquarePuntoInteresView createState() => SquarePuntoInteresView();
}

class SquarePuntoInteresView extends State<SquarePuntoInteresWidget> {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    nPuntoInteresView() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PuntoInteresView(widget.user, widget.puntoInteres,widget.position)));
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () => nPuntoInteresView(),
            child: buildImage(context)
        );
    }

    @override
    Widget buildImage(BuildContext context) {
        return FutureBuilder(
            future: getImage(),
            builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
                if (! snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(),
                    );
                } else {
                    return Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: snapshot.data,
                                fit: BoxFit.contain,
                            ),
                        ),
                        height: 200.0,
                        alignment: Alignment.topLeft, // where to position the child
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.lightGreen,
                            ),
                            child: Stack(
                                children: <Widget>[
                                    Icon(
                                        Icons.map,
                                        color: Colors.black,
                                        size: MediaQuery.of(context).size.height * 0.04,
                                    ),
                                    Center(
                                        child: Text(widget.puntoInteres.name, textAlign: TextAlign.center,)
                                    ),
                                ],
                            ),
                        ),
                    );
                }
            },
        );
    }

    Future<ImageProvider> getImage() async{
        try{
            if (widget.puntoInteres.photos.length > 0) {
                String ref = widget.puntoInteres.photos[0].photoReference;
                String urlImage = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + ref + "&key=" + PLACES_API_KEY;
                return Image.network(urlImage).image;
            }else {
                return AssetImage("assets/images/noImage.jpg");
            }
        }catch(e) {
            return AssetImage("assets/images/noImage.jpg");
        }

    }

/*
    Future<bool> changeProfileImage(String url,String path) async {
        var queryParameters = {
            "size": "600x300",
            "location": widget.miniQuedada.latitud.toString()  + "," + widget.miniQuedada.longitud.toString(),
            "fov" : "90",
            "heading" : "235",
            "pitch" : "10",
            "key" : PLACES_API_KEY,
        };

        Uri uri = new Uri.https(url, path,queryParameters);
        var res;
        try {
            final response = await http.get(uri);
            res = json.decode(response.body);
            if (res.containsKey("status"))
                return res["status"] == "OK";
        }catch(e) {
            return false;
        }

    }
*/
}

