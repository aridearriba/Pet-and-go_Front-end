import 'dart:convert';
import 'dart:io';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/pets/pet.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/pets/newPet.dart';

import 'package:http/http.dart' as http;


// ignore: must_be_immutable
class MyPets extends StatefulWidget {
    MyPets(this.user);
    User user;

    @override
    _PetsState createState() => _PetsState();
}

class _PetsState extends State<MyPets>
{
    List<Mascota> _mascotas;

    nNewPet() {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPet(widget.user))
        );
    }

    nPet(Mascota mascota) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pet(widget.user, mascota))
        );
    }

    nMyPets() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPets(widget.user))
        );
    }

    Mascota _mascota = new Mascota();

    @override
    Widget build(BuildContext context) {
    return FutureBuilder<List<Mascota>>(
        future: getMascotas(),
        builder: (BuildContext context, AsyncSnapshot<List<Mascota>> snapshot) {
                return Scaffold(
                    drawer: Menu(widget.user),
                    appBar: AppBar(
                        title: Text(
                            AppLocalizations.of(context).translate('pets_my-pets_title'),
                            style: TextStyle(color: Colors.white),
                        ),
                        iconTheme: IconThemeData(color: Colors.white),
                    ),
                    body: ListView(
                        children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 20.0),
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(top: 5.0),
                                            child: GestureDetector(
                                                child: Row(
                                                    children: <Widget>[
                                                        Icon(
                                                            Icons.add_circle,
                                                            color: Colors.black54,
                                                        ),
                                                        Text(
                                                            '   ' + AppLocalizations.of(context).translate('pets_my-pets_add-pet'),
                                                            style: TextStyle(color: Colors.black54,),
                                                        ),
                                                    ],
                                                ),
                                                onTap: () => nNewPet()
                                            ),
                                        ),
                                        !snapshot.hasData ?
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30.0),
                                                child: CircularProgressIndicator(backgroundColor: Colors.green, valueColor: AlwaysStoppedAnimation(Colors.lightGreen))
                                            )
                                        : ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _mascotas.length,
                                            itemBuilder: (BuildContext context,
                                                index) {
                                                return ListTile(
                                                    title: Text(
                                                        _mascotas[index].id
                                                            .name),
                                                    onTap:
                                                        () {
                                                        _mascota = _mascotas[index];
                                                        getPetProfileImage().whenComplete(() => nPet(_mascota));
                                                    },
                                                    //trailing: Icon(Icons.keyboard_arrow_right),
                                                    trailing: IconButton(
                                                        icon: Icon(
                                                            Icons.delete),
                                                        color: Colors.black54,
                                                        onPressed: () =>
                                                            _showAlertDialog(
                                                                _mascotas[index].id.name),
                                                    ),
                                                );
                                            },
                                        )
                                    ],
                                ),
                            ),
                        ]
                    ),
                );
        });
    }

    void _showAlertDialog(String petName) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(AppLocalizations.of(context).translate('pets_delete-pet_title'), textAlign: TextAlign.center),
                    content: Text(AppLocalizations.of(context).translate('pets_delete-pet_confirm'), textAlign: TextAlign.center),
                    actions: <Widget>[
                        FlatButton(
                            child: Text(AppLocalizations.of(context).translate('alert-dialog_close'), style: TextStyle(color: Colors.black45),),
                            onPressed: () =>  Navigator.pop(context),
                        ),
                        FlatButton(
                            child: Text(AppLocalizations.of(context).translate('alert-dialog_accept'), style: TextStyle(color: Colors.redAccent),),
                            onPressed:  () => deleteMascota(petName).whenComplete(
                                    () {
                                        Navigator.pop(context);
                                        getMascotas();
                                })
                        ),
                    ],
                );
            }
        );
    }

    Future<List<Mascota>> getMascotas() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/mascotas"));
        Iterable list = json.decode(response.body);
        _mascotas = list.map((model) => Mascota.fromJson(model)).toList();
        return _mascotas;
    }

    Future<void> getPetProfileImage() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/" + email + "/mascotas/" + _mascota.id.name + "/image"),
            headers: <String, String> {
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
        );
        _mascota.image = response.body;
    }

    Future<void> deleteMascota(String petName) async{
        var email = widget.user.email;
        final http.Response response = await http.delete(new Uri.http(Global.apiURL, "/api/usuarios/" +
            email + "/mascotas/" + petName),
            headers: <String, String> {
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
        );
    }
}
