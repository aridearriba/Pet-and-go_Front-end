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

  ListaPerreParadasWidget(User user,String tipo ){
    this.user = user;
    this.tipo = tipo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPerreParadas(tipo),
      builder: (BuildContext context, AsyncSnapshot<List<PerreParada>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
    var queryParameters = {tipo: user.email };
    final response = await http.get(new Uri.http(Global.apiURL, "/api/quedadas", queryParameters));
    return reqResponsePerreParadaFromJson(response.body);
  }

}