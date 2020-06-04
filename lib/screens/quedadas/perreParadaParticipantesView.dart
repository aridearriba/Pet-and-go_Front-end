import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/Participante.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/global/global.dart' as Global;
import 'package:http/http.dart' as http;
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/quedadas/vistaPerreParada.dart';


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

    nPerreParadaView() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VistaPerreParada(widget.user, widget.idPerreParada)));
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
            FocusScopeNode actualFocus = FocusScope.of(context);

            if(!actualFocus.hasPrimaryFocus){
                actualFocus.unfocus();
            }
        },
        child: Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(AppLocalizations.of(context).translate('meetings_my-meetings_title_participants'), style: TextStyle(color: Colors.white,),),
                iconTheme: IconThemeData(color: Colors.white,),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => nPerreParadaView()
                    )
                ],
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
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int i) {
                                      return Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Container(
                                              height: 400.0,
                                              child: _buildCard(snapshot.data[i])
                                          )
                                      );
                                  }
                              ),
                          );

                        } else {
                            return Container(

                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context).translate('meetings_my-meetings_title_no-participants'),
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
        ));
    }

    Widget _buildCard(Participante userSearch){
        return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage: getImage(userSearch.image, userSearch.urlAvatar),
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
                                                heroTag: "btn30",
                                                label: Text(AppLocalizations.of(context).translate('search_delete-friend')),
                                                icon: Icon(Icons.remove),
                                                backgroundColor: Colors.red,
                                                onPressed: () => {
                                                    removeAmic(userSearch.email).whenComplete(() => {
                                                    setState((){
                                                        userSearch.estado = null;
                                                        })
                                                    })
                                                },
                                            ) :
                                            FloatingActionButton.extended(
                                                heroTag: "btn40",
                                                label: Text(AppLocalizations.of(context).translate('search_add-friend')),
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
                                                heroTag: "btn70",
                                                label: Text(AppLocalizations.of(context).translate('search_unblock-friend')),
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
                                                heroTag: "btn60",
                                                label: Text(AppLocalizations.of(context).translate('search_block-friend')),
                                                icon: Icon(Icons.block),
                                                backgroundColor: Colors.black,
                                                onPressed: () => {
                                                    blockFriend(userSearch.email).whenComplete(() => {
                                                        if(widget._responseCode == 200){
                                                            setState((){
                                                                userSearch.estado = "BLOQUEADA";
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
        if (list != null){
            for(int i = 0; i< list.length; i++){
                if(list[i].image != null && list[i].image != ""){
                    list[i].image = await getProfileImage(list[i].email);
                }
            }
            return list;
        }
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

    Future<void> removeAmic(String emailFriend) async{
        var email = widget.user.email;
        final response = await http.post(
            new Uri.http(Global.apiURL, "/api/amigos/" + email+'/Removeamic'),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: emailFriend
        );
        widget._responseCode = response.statusCode;
    }

    ImageProvider getImage(String _image64,String urlImage)  {
        // no user image
        if ( (_image64 == null  || _image64 == "")   && ( urlImage == null || urlImage  == "" ) )
            return null;
        else if  (_image64 == null  || _image64 == "")
            return Image.network(urlImage).image;


        // else --> load image
        Uint8List _bytesImage;
        String _imgString = _image64.toString();
        _bytesImage = Base64Decoder().convert(_imgString);
        return Image.memory(_bytesImage).image;
    }

    Future<String> getProfileImage(String emailAmigo) async{
        var email = emailAmigo;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/image"),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },);
        String result = response.body;
        return result;
    }

}
