import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/global/global.dart' as Global;

class Search extends StatefulWidget{
    Search(this.user);
    User user;
    @override
    _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>{

    TextEditingController _controller = new TextEditingController();
    final _formKey = GlobalKey<FormState>();

    User userSearch = new User();
    User userMe;
    bool mostrar = false;
    var _responseCode;
    bool isFriend = false;
    bool isBlocked = false;
    bool progress = false;

    List<dynamic> _bloqueados = new List();

    String _image64;
    ImageProvider _imageProfile;

    @override
    Widget build(BuildContext context) {

        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Buscar',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
            body: Column(
                children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(35.0),
                        child: Row(
                            children: <Widget>[
                                Form(
                                    key: _formKey,
                                    child: SizedBox(width: 250.0,
                                            child: TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Introduzca un email'
                                                ),
                                                controller: _controller,
                                                validator: (value) {
                                                    RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                                    if(value.isEmpty){
                                                        return 'Por favor, escriba un email';
                                                    }
                                                    if(!regex.hasMatch(value)){
                                                        return 'Este email no es válido.';
                                                    }
                                                    if (_responseCode !=200) {
                                                        return 'No existe un usuario con este email.';
                                                    }
                                                    return null;
                                                },
                                            )
                                    ),
                                ),
                                SizedBox(width: 15.0,),
                                FloatingActionButton(
                                    child: Icon(Icons.search),
                                    onPressed: () => {
                                        getData().whenComplete(() =>
                                        {
                                            if(_formKey.currentState.validate()){
                                                setState((){
                                                    progress = true;
                                                    mostrar = false;
                                                }),
                                                isAmic().whenComplete(() => {
                                                    print('icono de progress:'+progress.toString()),
                                                    isBlock().whenComplete(() => {
                                                        getProfileImage().whenComplete(() => {
                                                            _image64 = userSearch.image,
                                                            _imageProfile = getImage(),
                                                            setState(() {
                                                                mostrar = true;
                                                            })
                                                        })
                                                    })
                                                })

                                            }
                                        })
                                    },
                                    backgroundColor: Colors.green,
                                )
                            ],
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                            height: !progress ? 0.0 : mostrar ? 310.0 : 100.0,
                            child: !progress ? SizedBox(width: 10) : mostrar ? _buildCard(context) : SizedBox(height: 100.0,
                                                            width: 100.0,
                                                            child: CircularProgressIndicator(
                                                            backgroundColor: Colors.green, valueColor: AlwaysStoppedAnimation(Colors.lightGreen)
                                                            ),)
                        ),
                    )
                ],
            )
        );
    }

    Widget _buildCard(BuildContext context){
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
                                                            top: 10.0),
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
                                                            top: 10.0),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                                Text(
                                                                    userSearch.name,
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
                                                            top: 10.0),
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
                                                    Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 15.0),
                                                        child: isBlocked ? null : isFriend ?
                                                        FloatingActionButton.extended(
                                                            heroTag: "btn3",
                                                            label: Text('Borrar amigo'),
                                                            icon: Icon(Icons.remove),
                                                            backgroundColor: Colors.red,
                                                            onPressed: () => {
                                                                setState((){
                                                                    isFriend = false;
                                                                })
                                                            },
                                                        ) :
                                                        FloatingActionButton.extended(
                                                            heroTag: "btn4",
                                                            label: Text('Añadir amigo'),
                                                            icon: Icon(Icons.add),
                                                            backgroundColor: Colors.blue,
                                                            onPressed: () => {
                                                                addAmic().whenComplete(() => {
                                                                    if(_responseCode == 201){
                                                                        setState((){
                                                                            isFriend = true;
                                                                        })
                                                                    }

                                                                })

                                                            },
                                                        ),
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 15.0),
                                                        child: isBlocked ?
                                                        FloatingActionButton.extended(
                                                            heroTag: "btn7",
                                                            label: Text('Desbloquear'),
                                                            icon: Icon(Icons.not_interested),
                                                            backgroundColor: Colors.blueGrey,
                                                            onPressed: () => {
                                                                desbloquearFriend(userSearch.email).whenComplete(() => {
                                                                    if(_responseCode == 200){
                                                                        isAmic().whenComplete(() => {
                                                                            setState((){
                                                                                isBlocked = false;
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
                                                                    if(_responseCode == 200){
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

    Future<void> getData() async{
        var email = _controller.text;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/"+email));
        userSearch = User.fromJson(jsonDecode(response.body));
        _responseCode = response.statusCode;
    }

    Future<void> getProfileImage() async{
        var email = userSearch.email;
        print(email);
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/image"),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },);
        userSearch.image = response.body;
    }

    Future<void> isAmic() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/"+email));
        userMe = User.fromJson(jsonDecode(response.body));
        setState(() {
            isFriend = (userMe.friends.contains(_controller.text));
        });

    }

    Future<void> isBlock() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/amigos/"+email+'/Bloqueados'));
        _bloqueados = jsonDecode(response.body);
        setState(() {
            isBlocked = (_bloqueados.contains(userSearch.email));
            print('is blocked?'+isBlocked.toString());
        });

    }

    Future<void> addAmic() async{
        var email = widget.user.email;
        print(_controller.text);
        final response = await http.post(new Uri.http(Global.apiURL, "/api/amigos/"+email+'/Addamic'),
            headers: <String, String>{
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: userSearch.email
        );
        _responseCode = response.statusCode;
        print(_responseCode);
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
        _responseCode = response.statusCode;
        print(_responseCode);
    }

    ImageProvider getImage()  {
        // no user image
        if (_image64 == "")
            return Image.network(widget.user.profileImageUrl).image;

        // else --> load image
        Uint8List _bytesImage;
        String _imgString = _image64.toString();
        _bytesImage = Base64Decoder().convert(_imgString);
        return Image.memory(_bytesImage).image;
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
}