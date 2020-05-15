import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/screens/puntosDeInteres/listadoPuntosInteresView.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';

import '../../Credentials.dart';
import 'mapaPuntosInteres.dart';
import 'package:http/http.dart' as http;

enum Accion { buscar, cancelar }

class PuntosInteresTabView extends StatefulWidget {
  User user;
  String tipo = "veterinario";
  LatLng origen;
  bool respuesta;
  Map<String, bool> opcionesPuntosInteres;

  PuntosInteresTabView(User user) {
    this.user = user;
    opcionesPuntosInteres = new Map<String, bool>();
    opcionesPuntosInteres["Veterinario"] = true;
    opcionesPuntosInteres["Alimentacion"] = true;
    opcionesPuntosInteres["Peluqueria"] = true;
  }

  @override
  PuntosInteresTabState createState() => PuntosInteresTabState();
}

class PuntosInteresTabState extends State<PuntosInteresTabView> {
  PuntosInteres puntosInteres;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(widget.user),
      appBar: AppBar(
        title: Text(
          'Puntos de interes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(children: <Widget>[buildTab(context)]),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () async {
          final action = await yesAbortDialog(
              'Seleccionar puntos de interes', widget.opcionesPuntosInteres);
          if (action == Accion.buscar) {
            //puntosInteres = await getPuntosInteres(widget.tipo,false);
            setState(() {
              puntosInteres = puntosInteres;
            });
          }
        },
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget buildTab(BuildContext context) {
    return FutureBuilder(
        future: getPuntosInteres(widget.tipo),
        builder: (BuildContext context, AsyncSnapshot<PuntosInteres> snapshot) {
          if (!snapshot.hasData) {
            return Center();
          } else {
            return Expanded(
              child: Column(
                children: <Widget>[
                  DefaultTabController(
                    length: 2,
                    child: Expanded(
                      child: Column(
                        children: <Widget>[
                          TabBar(
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.green,
                            tabs: [
                              Tab(
                                text: "Ver listado",
                              ),
                              Tab(
                                text: "Ver mapa",
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                ListaPuntosInteresWidget(
                                    widget.user, puntosInteres, widget.origen),
                                MapaPuntosInteresWidget(
                                    widget.user, puntosInteres, widget.origen),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  Future<Accion> yesAbortDialog(
      String title, Map<String, bool> opciones) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter stateUpdater) {
            return ListView.builder(
                itemCount: opciones.length,
                itemBuilder: (BuildContext context, int i) => ListTile(
                      title: Text(opciones.keys.toList()[i]),
                      leading: Checkbox(
                          value: opciones[opciones.keys.toList()[i]],
                          onChanged: (bool value) {
                            stateUpdater(() {
                              opciones[opciones.keys.toList()[i]] = value;
                            });
                          }),
                    ));
          }),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(Accion.buscar),
              color: Colors.green,
              child: const Text(
                'Buscar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(Accion.cancelar),
              child: const Text('Cancelar'),
              color: Colors.red,
            ),
          ],
        );
      },
    );
    return (action != null) ? action : Accion.cancelar;
  }

  Future<PuntosInteres> getPuntosInteres(String tipo) async{
    String url = "maps.googleapis.com";
    String path = "/maps/api/place/textsearch/json";
    String location = await getCurrentLocation();
    List<PuntosInteres> lpuntosInteres = new List<PuntosInteres>();
    List<String> valuesMap = widget.opcionesPuntosInteres.keys.toList();
    PuntosInteres result;

    for (int i = 0; i < valuesMap.length; i++) {
      if (widget.opcionesPuntosInteres[valuesMap[i]]) {
          lpuntosInteres.add(await getPuntosInteresApi(url,path,location,valuesMap[i]));
      }
    }
    result = juntarPuntosInteres(lpuntosInteres);
    puntosInteres = eliminarPuntosRepetidos(result);

    return puntosInteres;
  }
  PuntosInteres juntarPuntosInteres(List<PuntosInteres> lPuntos){
    PuntosInteres pI;
    lPuntos.forEach((element) {
      if (pI == null) pI = element;
      else if (pI.results != null) pI.results.addAll(element.results);
      else pI.results = element.results;
    });

    return pI;

  }

  PuntosInteres eliminarPuntosRepetidos(PuntosInteres puntosInteres) {

    if(puntosInteres != null && puntosInteres.results != null){
      for(int i = 0; i < puntosInteres.results.length; i++ ){
        for(int j = puntosInteres.results.length - 1; j > i; j--){
          if(puntosInteres.results[i].id == puntosInteres.results[j].id)
            puntosInteres.results.removeAt(j);
        }
      }
    }

    return puntosInteres;
  }

  Future<PuntosInteres> getPuntosInteresApi(String url,String path,String location,String tipo) async {
    String find_Type = "pet_store";
    if(tipo == "Veterinario") find_Type = "veterinary_care";
    var queryParameters = {
      "radius": "100",
      "input": tipo,
      "location": location,
      "key": PLACES_API_KEY,
      "type": find_Type
    };

    Uri uri = new Uri.https(url, path, queryParameters);
    var res;

    try {
      final response = await http.get(uri);
      res = json.decode(response.body);
      if (res.containsKey("status"))
        return puntosInteresFromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<String> getCurrentLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    widget.origen = new LatLng(position.latitude,position.longitude);
    return position.toString();
  }

}
