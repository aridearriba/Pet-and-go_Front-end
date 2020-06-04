import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petandgo/model/PerreParada.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/quedadas/vistaPerreParada.dart';
import '../../Credentials.dart';
import 'package:http/http.dart' as http;

class SquarePerreParadaWidget extends StatefulWidget {
    User user;
    PerreParada miniQuedada;

    SquarePerreParadaWidget(User User, PerreParada quedada) {
        this.user = User;
        this.miniQuedada = quedada;
    }

    @override
    SquarePerreParadaView createState() => SquarePerreParadaView();
}

class SquarePerreParadaView extends State<SquarePerreParadaWidget> {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    nPerreParadaView() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VistaPerreParada(widget.user, widget.miniQuedada.id)));
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () => nPerreParadaView(),
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
                                fit: BoxFit.cover,
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
                                        child: Text(widget.miniQuedada.lugarInicio, textAlign: TextAlign.center,)
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
        String urlExistImage = "maps.googleapis.com";
        String pathExistImage = "/maps/api/streetview/metadata";
        String urlGetImage = "https://maps.googleapis.com/maps/api/streetview?size=600x300&location=" + widget.miniQuedada.latitud.toString()  + "," + widget.miniQuedada.longitud.toString() +  "&heading=151.78&pitch=-0.76&key=" + PLACES_API_KEY;

        if ( await changeProfileImage(urlExistImage, pathExistImage))
            return Image.network(urlGetImage).image;
        else {
            return AssetImage("assets/images/parkDog.jpg");
        }
    }

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

}

