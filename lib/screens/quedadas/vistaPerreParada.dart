import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:petandgo/Credentials.dart';
import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petandgo/model/PerreParada.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/screens/quedadas/editPerreParada.dart';
import 'package:petandgo/screens/quedadas/perreParadaParticipantesView.dart';
import 'package:petandgo/screens/quedadas/perreParadaTabView.dart';
import 'package:random_string/random_string.dart';
import '../home.dart';


class VistaPerreParada extends StatefulWidget {

    VistaPerreParada(this.user, this.id);

    User user;
    int id;

    @override
    _VistaPerreParadaState createState() => _VistaPerreParadaState();
}

class _VistaPerreParadaState extends State<VistaPerreParada>{

    nHome(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(widget.user))
        );
    }

    nPerreParadaParticipantesView() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PerreParadaParticipantesView(widget.user,widget.id) ) );
    }

    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    Completer<GoogleMapController> _controller = Completer();
    Set<Marker> _markers = {};

    PerreParada _parada;

    bool _joined = true;
    bool _owner;

    List<Mascota> _listPets;
    List<Mascota> _seledtedPets = [];
    List<Mascota> _wasSelected = [];

    List<Mascota> _participants;

    PerreParada parada;

    nMisQuedadas(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuedadasTabView(widget.user))
        );
    }

    nEditPerreParada(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EditPerreParada(widget.user, parada))
        );
    }

    void callback(int status){
        if (status == 0) { //añadidos
            setState(() async {
                _joined = true;
                _participants =  await _getParticipants();
                _wasSelected = _seledtedPets;
            });
        } else if (status == 1) { //eliminados todas tus mascotas
            setState(() {
                _joined = false;
                _participants = _getParticipants() as List<Mascota>;
                _wasSelected = _seledtedPets;
            });
        }
    }

    Future<List<Mascota>> _getUsersPets() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/mascotas"));
        Iterable list = json.decode(response.body);
        return list.map((model) => Mascota.fromJson(model)).toList();
    }

    Future<List<Mascota>> _getParticipants() async{
        final response = await http.get(new Uri.http(Global.apiURL, "/api/quedadas/${widget.id}/participantes"));

        print(response.statusCode);
        if (response.statusCode == 200 || response.statusCode == 201){
            Iterable list = json.decode(response.body);

            for(var l in list){
                print(l);
            }

            return list.map((model) => Mascota.fromJson(model)).toList();
        }
        else print('ERROR en participantes');

    }

    Future<PerreParada> getPerreParada(int id) async {
        if (_parada == null) {
            String URL = 'https://petandgo.herokuapp.com/api/quedadas/$id';
            final response = await http.get(URL);

            if (response.statusCode == 200) {
                var data = json.decode(response.body);
                print(data);

                _listPets = await _getUsersPets();
                _participants = await _getParticipants();

                for (Mascota m in _listPets) {
                    if (m.isIn(_participants)) {
                        _seledtedPets.add(m);
                        _wasSelected.add(m);
                    }
                }

                for (var m in _seledtedPets) {
                    print(m.id.name);
                }

                if (response.statusCode == 200) {
                    var data = json.decode(utf8.decode(response.bodyBytes));
                    print(data);

                    if (_seledtedPets != []) {
                        setState(() {
                            _joined = true;
                        });
                    }


                    PerreParada parada = PerreParada.fromJson(data);


                    parada = PerreParada.fromJson(data);

                    if (parada.admin == widget.user.email)
                        setState(() {
                            _owner = true;
                        });
                    else
                        setState(() {
                            _owner = false;
                        });


                    _markers.add(Marker(
                        markerId: MarkerId('PERREPARADA'),
                        position: LatLng(parada.latitud, parada.longitud),
                    ));

                    _parada = parada;
                    return parada;
                } else {
                    throw Exception('An error occurred getting the DogStop');
                }
            }
            else
                return _parada;
        }
        else return _parada;
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<PerreParada>(
            future: getPerreParada(widget.id),
            builder: (BuildContext context, AsyncSnapshot<PerreParada> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                    children = <Widget>[
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                ),
                                Text(
                                    '  ${snapshot.data.admin}',
                                ),
                            ],
                        ),
                        Divider(color: Colors.transparent),
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.place,
                                    color: Colors.grey,
                                 ),
                                Text("  "),
                                Expanded(child:
                                    Text(
                                        '${snapshot.data.lugarInicio}',
                                        overflow: TextOverflow.visible,
                                    ),
                                )
                             ],
                        ),
                        Divider(color: Colors.transparent),
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                ),
                                Text(
                                    '  ${snapshot.data.fechaQuedada.day.toString().padLeft(2, '0')}/${snapshot.data.fechaQuedada.month.toString().padLeft(2, '0')}/${snapshot.data.fechaQuedada.year}     ${snapshot.data.fechaQuedada.hour.toString().padLeft(2, '0')}:${snapshot.data.fechaQuedada.minute.toString().padLeft(2, '0')} h',
                                ),
                            ],
                        ),
                        Divider(color: Colors.transparent),
                        Center(
                            child: Container(
                                height: 250,
                                width: 350,
                                child: GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(snapshot.data.latitud,snapshot.data.longitud),
                                        zoom: 15,
                                    ),
                                    onMapCreated: (GoogleMapController controller) {
                                        _controller.complete(controller);
                                    },
                                    markers: _markers,
                                ),
                            ),
                        ),
                        Divider(color: Colors.transparent, height: 20,),
                        Center(
                            child: RaisedButton(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                            return _PetsDialog(
                                                owner: _owner,
                                                callback: this.callback,
                                                user: widget.user,
                                                paradaId: widget.id,
                                                pets: _listPets,
                                                selectedPets: _seledtedPets,
                                                wasSelected: _wasSelected,
                                                onSelectedPetsListChanged: (pets) {
                                                    _seledtedPets = pets;
                                                    print(_seledtedPets);
                                                }
                                            );
                                        }
                                    );
                                },
                                child: Text( ! _joined ?
                                AppLocalizations.of(context).translate('dogstops_one_enroll') : AppLocalizations.of(context).translate('dogstops_one_unroll')
                                ),
                            ),
                        ),
                        snapshot.data.admin == widget.user.email ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                            child: FloatingActionButton.extended(
                                heroTag: "editDogStop",
                                icon: Icon(Icons.edit, color: Colors.white),
                                backgroundColor: Colors.green,
                                label: Text(AppLocalizations.of(context).translate('dogstops_edit_title')),
                                onPressed: () {
                                    nEditPerreParada();
                                }
                            )
                        ) : Divider(color: Colors.transparent),
                        Text("  " + AppLocalizations.of(context).translate('meetings_my-meetings_title_participants').toUpperCase()),
                        Container(
                            height: 200,
                            width: 500,
                            child: FutureBuilder<List<Mascota>>(
                                future: _getParticipants(),
                                builder: (context, snapshot) {
                                    if (snapshot.hasData){
                                        return ListView.builder(
                                            itemCount: (_participants == []) ? 0 : _participants.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index){
                                                return Card(
                                                    key: new Key(randomString(10)),
                                                    child: ListTile(
                                                        onTap: nPerreParadaParticipantesView,
                                                        leading: Icon(Icons.pets),
                                                        title: Text(_participants[index].id.name),
                                                        subtitle: Text('${_participants[index].id.amo}'),

                                                    ),
                                                );
                                            }
                                        );
                                    }
                                    else {
                                        return Center(
                                            child: CircularProgressIndicator(),
                                        );
                                    }
                                },
                            ),
                        ),
                    ];
                }
                else if (snapshot.hasError) {
                    children = <Widget>[
                        Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                        )

                    ];
                }
                else {
                    children = <Widget>[
                        SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(AppLocalizations.of(context).translate('dogstops_one_awaiting-results')),
                        )
                    ];
                }
                return Scaffold(
                    key: _scaffoldKey, drawer: Menu(widget.user),
                    appBar: AppBar(
                        title: Text(
                            AppLocalizations.of(context).translate('dogstops_one_title'),
                            style: TextStyle(
                                color: Colors.white,
                            ),
                        ),
                        iconTheme: IconThemeData(
                            color: Colors.white,
                        ),
                        actions: <Widget>[
                            IconButton(
                                icon: Icon(Icons.home, color: Colors.white),
                                onPressed: () => nHome(),
                            ),
                        ],
                    ),
                    body: ListView(
                        children: children,
                    )
                );
            }
        );
    }
}

class _PetsDialog extends StatefulWidget{

    _PetsDialog({
        this.owner,
        this.callback,
        this.user,
        this.paradaId,
        this.pets,
        this.selectedPets,
        this.onSelectedPetsListChanged,
        this.wasSelected,

    });

    Function callback;
    User user;
    int paradaId;
    bool owner;
    final List<Mascota> pets;
    final List<Mascota> selectedPets;
    final ValueChanged<List<Mascota>> onSelectedPetsListChanged;
    final List<Mascota> wasSelected;

    @override
    _PetsDialogState createState() => _PetsDialogState();
}

class _PetsDialogState extends State<_PetsDialog> {

    @override
    Widget build(BuildContext context) {
        return Dialog(
            child:  Container(
                height: 350,
                width: 300,
                child: Column(
                    children: <Widget>[
                        FlatButton(
                            padding: EdgeInsets.only(left: 270),
                            onPressed: () {
                                widget.onSelectedPetsListChanged(widget.wasSelected);
                                Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                                Text(AppLocalizations.of(context).translate('dogstops_one_pet-select'),
                                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                                    textAlign: TextAlign.center,
                                ),
                            ],
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: widget.pets.length,
                                itemBuilder: (BuildContext context, int index) {
                                    final pet = widget.pets[index];
                                    return Container(
                                        height: 50,
                                        child: CheckboxListTile(
                                            title: Text(pet.id.name),
                                            value: pet.isIn(widget.selectedPets),
                                            onChanged: (bool value) {
                                                if (value) {
                                                    if (!pet.isIn(widget.selectedPets)) {
                                                        setState(() {
                                                            widget.selectedPets.add(pet);
                                                        });
                                                    }
                                                }
                                                else {
                                                    if (pet.isIn(widget.selectedPets)) {
                                                        setState(() {
                                                            widget.selectedPets.removeWhere((Mascota p) => p == pet);
                                                        });
                                                    }
                                                }
                                                widget.onSelectedPetsListChanged(widget.selectedPets);
                                            }),
                                    );
                                },
                            ),
                        ),
                        RaisedButton(
                            onPressed: (){
                                addMyParticipants();
                                Navigator.pop(context);
                            },
                            color: Colors.transparent,
                            elevation: 0,
                            child: Text(AppLocalizations.of(context).translate('alert-dialog_accept')),
                        )
                    ],
                ),
            )
        );
    }

    Future<void> addMyParticipants() async {
        bool ok = false;

        for (var p in widget.pets) {
            if (p.isIn(widget.wasSelected)){
                if (! p.isIn(widget.selectedPets)){
                    //si estaba seleccionado y ahora no lo esta se borra de la quedada
                    http.Response response = await http.delete(new Uri.http(Global.apiURL, "/api/quedadas/${widget.paradaId}/participantes/${p.id.amo}/mascotas/${p.id.name}"),
                        headers: <String, String>{
                            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                            HttpHeaders.authorizationHeader: widget.user.token.toString(),
                        },
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) ok = true;
                    else {
                        print('ERROR');
                    }
                    print('${p.id.name} ${response.statusCode}');
                }
            }
            else{
                if (p.isIn(widget.selectedPets)){
                    //si no estaba seleccionado y ahora si lo esta se añade a la quedada
                    http.Response response = await http.post(new Uri.http(Global.apiURL, "/api/quedadas/${widget.paradaId}/participantes"),
                        headers: <String, String>{
                            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                            HttpHeaders.authorizationHeader: widget.user.token.toString(),
                        },
                        body: jsonEncode(
                            {
                                'nombre': p.id.name,
                                'amo': p.id.amo,
                            }
                        )
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) ok = true;
                    else {
                        print('ERROR'); //Que se lo muestre al usuario en un futuro
                    }
                    print('${p.id.name} ${response.statusCode}');
                }
            }
        }

        if (ok) {
            if (widget.selectedPets == []) {
                widget.callback(1);
            }
            else {
                widget.callback(0);
            }

        }
    }
}


