import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/global/global.dart' as Global;
import 'package:petandgo/multilanguage/appLocalizations.dart';

class Blocks extends StatefulWidget{
    Blocks(this.user);
    User user;

    @override
    _BlocksState createState() => _BlocksState();

}

class _BlocksState extends State<Blocks>{

    var _responseCode;

    void initState(){
        super.initState();
        getBloqueados();

    }

    List<dynamic> _bloqueados = new List();
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                backgroundColor: Colors.red,
                title: Text(AppLocalizations.of(context).translate('blocks_title'),
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
            ),
            body: ListView.builder(
                itemCount: _bloqueados.length,
                itemBuilder: (BuildContext context, index) {
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
                                        child: Icon(Icons.person),
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
                                                            _bloqueados[index],
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
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: FloatingActionButton.extended(
                                                    heroTag: "btn5",
                                                    label: Text(AppLocalizations.of(context).translate('search_unblock-friend')),
                                                    icon: Icon(Icons.not_interested),
                                                    backgroundColor: Colors.blueGrey,
                                                    onPressed: () => {
                                                        desbloquearFriend(_bloqueados[index]).whenComplete(() => {
                                                            if(_responseCode == 200){
                                                                getBloqueados()
                                                            }
                                                        })
                                                    },
                                                ),
                                            )
                                        ],
                                    ),
                                ],
                            ),
                        )
                    );
                },
            ),
        );
    }

    Future<void> getBloqueados() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/amigos/"+email+'/Bloqueados'));
        setState(() {
            _bloqueados = jsonDecode(response.body);
        });
        _responseCode = response.statusCode;
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
        _responseCode = response.statusCode;
        print('El codigo de desbloqueado:'+_responseCode.toString());
    }

}