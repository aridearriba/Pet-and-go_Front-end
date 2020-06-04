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
    var _responseCode;
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
                              child: ListView.separated(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int i) {
                                      return Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Container(
                                              height: 310.0,
                                              child: _buildCard(context,null,snapshot.data[i],false,false)
                                          )
                                      );
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

    Widget _buildCard(BuildContext context,ImageProvider _imageProfile,Participante userSearch,bool isFriend,bool isBlocked){
        return ListView(
            children: <Widget>[
                Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage: _imageProfile,
                                ),

                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                        // USER
                                        // username
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                    Text(
                                                        userSearch.username,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black54,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 16.0,
                                                        ),
                                                        textAlign: TextAlign
                                                            .center,
                                                    ),
                                                ]
                                            ),
                                        ),
                                        // email
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                    Text(
                                                        userSearch.nombre,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black54,
                                                            fontSize: 16.0,
                                                        ),
                                                        textAlign: TextAlign
                                                            .center,
                                                    )
                                                ]
                                            ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                    Text(
                                                        userSearch.email,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black54,
                                                        ),
                                                    )
                                                ],
                                            )
                                        ),
                                        if(widget.user.email != userSearch.email)
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: userSearch.estado == "ACEPTADA" ?
                                            FloatingActionButton.extended(
                                                heroTag: "btn3",
                                                label: Text('Borrar amigo'),
                                                icon: Icon(Icons.remove),
                                                backgroundColor: Colors.red,
                                                onPressed: () => {
                                                    setState((){
                                                        userSearch.estado = null;
                                                    })
                                                },
                                            ) :
                                            FloatingActionButton.extended(
                                                heroTag: "btn4",
                                                label: Text('Añadir amigo'),
                                                icon: Icon(Icons.add),
                                                backgroundColor: Colors.blue,
                                                onPressed: () => {
                                                    addAmic(userSearch).whenComplete(() => {
                                                        if(widget._responseCode == 201){
                                                            setState((){
                                                                userSearch.estado = "ACEPTADA";
                                                            })
                                                        }

                                                    })

                                                },
                                            ),
                                        ) ,
                                       if(widget.user.email != userSearch.email)
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: userSearch.estado == "BLOQUEADO" ?
                                            FloatingActionButton.extended(
                                                heroTag: "btn7",
                                                label: Text('Desbloquear'),
                                                icon: Icon(Icons.not_interested),
                                                backgroundColor: Colors.blueGrey,
                                                onPressed: () => {
                                                    desbloquearFriend(userSearch.email).whenComplete(() => {
                                                        if(widget._responseCode == 200){
                                                            isAmic().whenComplete(() => {
                                                                setState((){
                                                                    userSearch.estado = "BLOQUEADO";
                                                                })
                                                            })

                                                        }
                                                    })
                                                },
                                            ) :
                                            FloatingActionButton.extended(
                                                heroTag: "btn6",
                                                label: Text('Bloquear'),
                                                icon: Icon(Icons.block),
                                                backgroundColor: Colors.black,
                                                onPressed: () => {
                                                    blockFriend(userSearch.email).whenComplete(() => {
                                                        if(widget._responseCode == 200){
                                                            setState((){
                                                                isBlocked = true;
                                                            })
                                                        }
                                                    })
                                                },
                                            ),
                                        )
                                    ],
                                ),
                            ],
                        ),
                    ),
                ),
            ]
        );
    }

    Future<List<Participante>> getParticipantes() async {
        List<Participante> list;
        http.Response response = await http.get(
            new Uri.http(Global.apiURL, "/api/quedadas/" + widget.idPerreParada.toString() + "/participantes/relacion"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
        );

        list =  participanteFromJson(response.body);
        return list;
    }

    Future<void> addAmic(Participante user) async{
        var email = widget.user.email;
        final response = await http.post(new Uri.http(Global.apiURL, "/api/amigos/"+email+'/Addamic'),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: user.email
        );
        widget._responseCode = response.statusCode;
    }

    Future<void> desbloquearFriend(String emailFriend) async{
        var email = widget.user.email;
        final response = await http.post(
            new Uri.http(Global.apiURL, "/api/amigos/" + email+'/Removebloqueado'),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: emailFriend
        );
        widget._responseCode = response.statusCode;

    }

    Future<bool> isAmic() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/"+email));
        widget.user = User.fromJson(jsonDecode(response.body));
        setState(() {
            //widget.isFriend = (widget.user.friends.contains(_controller.text));
            return false;
        });

    }

    Future<void> blockFriend(String emailFriend) async{
        var email = widget.user.email;
        final response = await http.post(
            new Uri.http(Global.apiURL, "/api/amigos/" + email+'/Bloquear'),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: emailFriend
        );
        widget._responseCode = response.statusCode;
    }
}
