import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/Participante.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/global/global.dart' as Global;
import 'package:http/http.dart' as http;
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';

import 'SquarePerreParadaView.dart';

class PerreParadaParticipantesView extends StatefulWidget {
    int idPerreParada;
    User user;

    PerreParadaParticipantesView(User user, int idPerreParada) {
        this.user = user;
        this.idPerreParada = idPerreParada;
    }

    @override
    PerreParadaParticipantesState createState() => PerreParadaParticipantesState();

}

class PerreParadaParticipantesState extends State<PerreParadaParticipantesView>{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(AppLocalizations.of(context).translate('meetings_my-meetings_title'), style: TextStyle(color: Colors.white,),),
                iconTheme: IconThemeData(color: Colors.white,),
            ),
            body: FutureBuilder(
                future: getParticipantes(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Participante>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(),
                        );
                    } else {
                        if (snapshot.data != null) {
                          return Container(
                              height: 500,
                              child: ListView.separated(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int i) {
                                      return Text(snapshot.data[i].id.nombre);
                                  },
                                  separatorBuilder: (BuildContext context, int index) =>
                                  const Divider(),
                              ),
                          );

                        } else {
                            return Container(

                                child: Center(
                                    child: Text(
                                        "Sin participantes",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                )
                            );
                        }
                    }
                },
            ),
        );
    }

    /*
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(this.user),
            appBar: AppBar(
                title: Text(AppLocalizations.of(context).translate('meetings_my-meetings_title'), style: TextStyle(color: Colors.white,),),
                iconTheme: IconThemeData(color: Colors.white,),
            ),
            body: FutureBuilder(
              future: getParticipantes(idPerreParada),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Participante>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(),
                      );
                  } else {
                      if (snapshot.data != null) {
                          /*
                          return Container(
                              height: 500,
                              child: ListView.separated(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int i) {
                                      return Text("a");
                                  },
                                  separatorBuilder: (BuildContext context, int index) =>
                                  const Divider(),
                              ),
                          );*/
                          return Container(

                              child: Center(
                                  child: Text(
                                      "Con participantes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                      ),
                                  ),
                              )
                          );
                      } else {
                          return Container(

                              child: Center(
                                  child: Text(
                                      "Sin participantes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                      ),
                                  ),
                              )
                          );
                      }
                  }
              },
          ),
        );
    }
*/

    Future<List<Participante>> getParticipantes() async {
        List<Participante> list;
        http.Response response = await http.get(
            new Uri.http(Global.apiURL, "/api/quedadas/" + widget.idPerreParada.toString() + "/participantes"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
        );

        list =  participanteFromJson(response.body);
        return list;
    }

}
