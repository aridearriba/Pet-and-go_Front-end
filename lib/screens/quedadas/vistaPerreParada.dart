import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
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

    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    Completer<GoogleMapController> _controller = Completer();
    Set<Marker> _markers = {};

    bool _notJoined = true;
    bool _hasPets; //posible ampliación

    List<Mascota> _listPets;
    List<Mascota> _seledtedPets = [];

    void callback(int status){
        if (status == 0) {
            setState(() {
              _notJoined = false;
            });
        }
    }

    Future<List<Mascota>> _getUsersPets() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/mascotas"));
        Iterable list = json.decode(response.body);
        _listPets = list.map((model) => Mascota.fromJson(model)).toList();
        return _listPets;
    }

    Future<PerreParada> getPerreParada(int id) async{

        String URL = 'https://petandgo.herokuapp.com/api/quedadas/$id';
        final response = await http.get(URL);

        if (response.statusCode == 200) {
            var data = json.decode(response.body);
            print(data);

            _listPets = await _getUsersPets();

            PerreParada parada = PerreParada.fromJson(data);

            _markers.add(Marker(
                markerId: MarkerId('PERREPARADA'),
                position: LatLng(parada.latitud,parada.longitud),
            ));

            return parada;
        } else {
            throw Exception('An error occurred getting places nearby');
        }
        return null;
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<PerreParada>(
            future: getPerreParada(widget.id),// a previously-obtained Future<String> or null
            // ignore: missing_return
            builder: (BuildContext context, AsyncSnapshot<PerreParada> snapshot) {
                List<Widget> children;

                if (snapshot.hasData) {
                    children = <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 16),
                        ),
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                ),
                                Text(
                                    '${snapshot.data.admin}',
                                ),
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.place,
                                    color: Colors.grey,
                                ),
                                Text(
                                    '${snapshot.data.lugarInicio}',
                                    overflow: TextOverflow.ellipsis,
                                ),
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                ),
                                Text(
                                    '${snapshot.data.fechaQuedada.day}/${snapshot.data.fechaQuedada.month}/${snapshot.data.fechaQuedada.year}     ${snapshot.data.fechaQuedada.hour}:${snapshot.data.fechaQuedada.minute}',
                                ),
                            ],
                        ),
                        Padding(
                            padding: EdgeInsets.all(20.0),
                        ),
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
                        Padding(
                            padding: EdgeInsets.all(10.0),
                        ),
                        RaisedButton(
                            onPressed: (){
                                _notJoined ?
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                        return _PetsDialog(
                                            callback: this.callback,
                                            user: widget.user,
                                            paradaId: widget.id,
                                            pets: _listPets,
                                            selectedPets: _seledtedPets,
                                            onSelectedPetsListChanged: (pets) {
                                                _seledtedPets = pets;
                                                print(_seledtedPets);
                                            }
                                        );
                                    }
                                ) :
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                        return Dialog(
                                            child: Container(
                                                height: 250,
                                                width: 300,
                                                child: Column(
                                                    children: <Widget>[
                                                        Padding(
                                                            padding: EdgeInsets.all(20),
                                                        ),
                                                        Text(AppLocalizations.of(context).translate('dogstops_one_confirm-unroll'),
                                                            overflow: TextOverflow.fade,
                                                            textAlign: TextAlign.center,
                                                            style: new TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors.black,
                                                            ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.all(5),
                                                        ),
                                                        Text(AppLocalizations.of(context).translate('dogstops_one_info-unroll'),
                                                            overflow: TextOverflow.fade,
                                                            textAlign: TextAlign.center,
                                                            style: new TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors.black26,
                                                            ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.all(20),
                                                        ),
                                                        Center(
                                                            child: Container(
                                                                child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                        RaisedButton(
                                                                            color: Colors.grey[300],
                                                                            onPressed: () {
                                                                                deleteMyParticipations();
                                                                                Navigator.pop(context);
                                                                            },
                                                                            child: Text(
                                                                                AppLocalizations.of(context).translate('alert-dialog_accept'),
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        RaisedButton(
                                                                            color: Colors.grey[300],
                                                                            onPressed: () {
                                                                                Navigator.pop(context);
                                                                            },
                                                                            child: Text(
                                                                                AppLocalizations.of(context).translate('alert-dialog_cancel').toUpperCase(),
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                ),
                                                                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        );
                                    }
                                );
                            },
                            child: Text( _notJoined ?
                                AppLocalizations.of(context).translate('dogstops_one_enroll') : AppLocalizations.of(context).translate('dogstops_one_unroll')
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
                        children: <Widget>[
                            Column(
                                children: children,
                            ),
                        ],
                    ),
                );
            }
            );
    }

    Future<void> deleteMyParticipations() async {
    }

}

class _PetsDialog extends StatefulWidget{

    _PetsDialog({
        this.callback,
        this.user,
        this.paradaId,
        this.pets,
        this.selectedPets,
        this.onSelectedPetsListChanged,
    });

    Function callback;
    User user;
    int paradaId;
    final List<Mascota> pets;
    final List<Mascota> selectedPets;
    final ValueChanged<List<Mascota>> onSelectedPetsListChanged;

    @override
    _PetsDialogState createState() => _PetsDialogState();
}

class _PetsDialogState extends State<_PetsDialog> {
    List<Mascota> _tempSelectedPets = [];

    @override
    void initState() {
        _tempSelectedPets = widget.selectedPets;
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Dialog(
            child:  Container(
                height: 350,
                child: Column(
                    children: <Widget>[
                        FlatButton(
                            padding: EdgeInsets.only(left: 280),
                            onPressed: () {
                                _tempSelectedPets = [];
                                widget.onSelectedPetsListChanged(_tempSelectedPets);
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
                                            value: _tempSelectedPets.contains(pet),
                                            onChanged: (bool value) {
                                                if (value) {
                                                    if (!_tempSelectedPets.contains(pet)) {
                                                        setState(() {
                                                            _tempSelectedPets.add(pet);
                                                        });
                                                    }
                                                }
                                                else {
                                                    if (_tempSelectedPets.contains(pet)) {
                                                        setState(() {
                                                            _tempSelectedPets.removeWhere((Mascota p) => p == pet);
                                                        });
                                                    }
                                                }
                                                widget.onSelectedPetsListChanged(_tempSelectedPets);
                                            }),
                                    );
                                },
                            ),
                        ),
                        RaisedButton(
                            onPressed: (){
                                addMeAsParticipant();
                                Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context).translate('alert-dialog_accept')),
                        )
                    ],
                ),
            )
        );
    }

    Future<void> addMeAsParticipant() async {
        bool ok = false;

        for (var p in widget.selectedPets) {
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

            if (response.statusCode == 201) ok = true;
            else {
                print('ERROR'); //Que se lo muestre al usuario en un futuro
            }
            print('${p.id.name} ${response.statusCode}');
        }

        if (ok) widget.callback(0);
        else widget.callback(-1);
    }


}


