import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
    bool mostrar = false;
    User userBlock;
    List<User> _myBloqueados = new List();
    List<dynamic> _bloqueados = new List();
    String _image64;

    void initState(){
        getBloqueados().whenComplete(() =>
        {
            if(_bloqueados.isNotEmpty){
                print('tinc almenys un bloquejat'),
                for(String email in _bloqueados){
                    getData(email).whenComplete(() =>
                    {
                        getProfileImage(userBlock)
                    })
                },
                setState(() =>
                {
                    mostrar = true
                }),
            }
            else{
                setState(() =>
                {
                    mostrar = true
                }),
            }
        });

    }

    @override
    Widget build(BuildContext context) {
        return Scaffold (
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
            body: mostrar ? ListView.builder(
                itemCount: _myBloqueados.length,
                itemBuilder: (BuildContext context, index) {
                    return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                    CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: getImage(_myBloqueados[index].image),
                                    ),

                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                            // USER
                                            // username
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                        Text(
                                                            _myBloqueados[index].username,
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
                                                    top: 10.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                        Text(
                                                            _myBloqueados[index].name,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
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
                                                    top: 10.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                        Text(
                                                            _myBloqueados[index].email,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 12.0,
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
                                                        desbloquearFriend(_myBloqueados[index].email).whenComplete(() => {
                                                            if(_responseCode == 200){
                                                                setState((){
                                                                    _myBloqueados.removeAt(index);
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
                        )
                    );
                },
            ) : Padding(
                padding: const EdgeInsets.all(
                    30.0),
                child: Center(
                    child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.red, valueColor: AlwaysStoppedAnimation(Colors.red[200])
                        ),
                    )
                ),
            )
        );
    }

    Future<void> getBloqueados() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/amigos/"+email+'/Bloqueados'));
        setState(() {
            _bloqueados = jsonDecode(response.body);


        });
        _responseCode = response.statusCode;
        print(_responseCode);
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

    Future<void> getData(email) async{
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email));
        userBlock = User.fromJson(jsonDecode(response.body));

    }

    ImageProvider getImage(String image)  {
        _image64 = image;
        // no user image
        if (_image64 == "")
            return Image.network(widget.user.profileImageUrl).image;

        // else --> load image
        Uint8List _bytesImage;
        String _imgString = _image64.toString();
        _bytesImage = Base64Decoder().convert(_imgString);
        return Image.memory(_bytesImage).image;
    }

    Future<void> getProfileImage(User userF) async{
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + userF.email + "/image"),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },);
        userF.image = response.body;
        setState(() => {
            _myBloqueados.add(userF)
        });
    }

}