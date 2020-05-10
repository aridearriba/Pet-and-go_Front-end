import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/PerreParada.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/global/global.dart' as Global;
import 'package:http/http.dart' as http;

import 'SquarePerreParadaView.dart';

class ListaPerreParadasWidget extends StatelessWidget{

    User user;
    String tipo;
    String point;

    List<PerreParada> _list;

    ListaPerreParadasWidget(User user,String tipo, String point){
        this.user = user;
        this.tipo = tipo;
        this.point = point;
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: getPerreParadas(tipo),
            builder: (BuildContext context, AsyncSnapshot<List<PerreParada>> snapshot) {
                if (! snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(),
                    );
                } else {
                    return Container(
                        height: 500,
                        child: ListView.separated(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int i){
                                return SquarePerreParadaWidget( user, snapshot.data[i]);
                            },
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                        ),
                    );
                }
            },
        );
    }

    Future<List<PerreParada>> getPerreParadas(String tipo) async{
        List<PerreParada> list;

        switch(tipo){
            case 'cercanas':
                {
                    http.Response response = await http.get(new Uri.http(Global.apiURL, "/api/quedadas/distancia/1000/$point"),
                        headers: <String, String>{
                            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                            HttpHeaders.authorizationHeader: user.token.toString(),
                        },
                    );

                    print(response.statusCode);
                    print(json.decode(response.body));

                    if (response.statusCode == 200) {
                        return reqResponsePerreParadaFromJson(response.body);
                    } else {
                        throw Exception('error en la creacion de la lista : CERCANAS');
                    }
                    break;
                }

            case 'admin':
                {
                    var queryParameters = {tipo: user.email };
                    http.Response response = await http.get(new Uri.http(Global.apiURL, "/api/quedadas", queryParameters),
                        headers: <String, String>{
                            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                            HttpHeaders.authorizationHeader: user.token.toString(),
                        },);

                    print(response.statusCode);
                    print(json.decode(response.body));

                    if (response.statusCode == 200) {
                        return reqResponsePerreParadaFromJson(response.body);
                    } else {
                        throw Exception('error en la creacion de la lista : ADMIN');
                    }
                    break;
                }
            case 'participante':
                {
                    var queryParameters = {tipo: user.email };
                    http.Response response = await http.get(new Uri.http(Global.apiURL, "/api/quedadas", queryParameters),
                        headers: <String, String>{
                            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                            HttpHeaders.authorizationHeader: user.token.toString(),
                        },);

                    print(response.statusCode);
                    print(json.decode(response.body));

                    if (response.statusCode == 200) {
                        return reqResponsePerreParadaFromJson(response.body);
                    } else {
                        throw Exception('error en la creacion de la lista : PARTICIPANTES');
                    }
                    break;
                }
            case 'all' :
                {
                    http.Response response = await http.get(new Uri.http(Global.apiURL, "/api/quedadas/"),
                        headers: <String, String>{
                            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                            HttpHeaders.authorizationHeader: user.token.toString(),
                        },);

                    print(response.statusCode);
                    print(json.decode(response.body));

                    return reqResponsePerreParadaFromJson(response.body);
                }
        }
    }

}