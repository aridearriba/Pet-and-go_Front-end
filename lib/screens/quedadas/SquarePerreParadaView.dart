import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:petandgo/model/DogStop.dart';
import 'package:petandgo/model/PerreParada.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/DogStops/DogStopView.dart';
import 'perreParadaTabView.dart';

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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DogStopWidget(widget.user, widget.miniQuedada.id)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => nPerreParadaView(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: getImage(),
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
      ),
    );
  }

  ImageProvider getImage() {
    // no image
    if (widget.miniQuedada.fotoLugar == "")
      return AssetImage("assets/images/parkDog.jpg");
    else {
      Uint8List decoded = base64Decode(widget.miniQuedada.fotoLugar);
      return Image.memory(decoded).image;
    }
  }
}
