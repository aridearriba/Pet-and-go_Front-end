import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petandgo/screens/quedadas/listadoPerreParadasView.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/quedadas/nuevaPerreParada.dart';
import 'package:petandgo/screens/quedadas/vistaPerreParada.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/screens/user/profile.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
    Home(this.user);
    User user;

    //PEDIR A BACK EL LISTADO DE PERREPARADAS CERCANAS AL USUARIO

    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    String _queryParameters = '0/0';
    String _consejo = '';

    nLogIn() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nProfile() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(widget.user))
        );
    }

    nNewDogStop() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NuevaPerreParada(widget.user))
        );
    }

    @override
    void initState() {
        _getConsejos();
    }

    Future<String> _getCurrentLocation() async {
        final position = await Geolocator().getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print('$position');

        widget.user.pos = position;
        _queryParameters = position.latitude.toString() + '/' + position.longitude.toString();

        return position.toString();
    }

    // GET Consejos
    Future<String> _getConsejos() async {
        final response = await http.get(new Uri.http("petandgo.herokuapp.com", "/api/consejos/one"));

        Map<String, dynamic> responseJson = json.decode(response.body);

        setState(() {
            _consejo = responseJson['consejo'];
        });

        return _consejo;
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<String>(
            future: _getCurrentLocation(),
            // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                print(_consejo);
                Center advice = Center(
                    child: Container(
                        width: 300,
                        //height: 200,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen[200],
                            borderRadius: BorderRadius.circular(12),
                        ),
                        child:  ListTile(
                            title: Text(
                                "CONSEJO",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22,
                                    //decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    //color: Colors.black45
                                ),
                            ),
                            subtitle: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: _consejo == '' ?
                                    Text ('cargando consejo...',
                                        textAlign: TextAlign.center,
                                    ) :
                                    Text(
                                    _consejo,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black87
                                    ),
                                ),
                            )
                        )
                    )
                );
                RichText title = RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'PERREPARADAS CERCANAS',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            decoration: TextDecoration.underline,
                        ),
                    )
                );
                List<Widget> children;
                if (snapshot.hasData) {
                    children = <Widget>[
                        Padding(padding: EdgeInsets.all(10)),
                        advice,
                        Padding(padding: EdgeInsets.all(10)),
                        title,
                        ListaPerreParadasWidget(widget.user, 'cercanas', _queryParameters),
                    ];
                }
                else if (snapshot.hasError) {
                    children = <Widget>[
                        Padding(padding: EdgeInsets.all(10)),
                        advice,
                        Padding(padding: EdgeInsets.all(10)),
                        title,
                        Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.data.error}'),
                        )
                    ];
                }
                else {
                    children = <Widget>[
                        Padding(padding: EdgeInsets.all(10)),
                        advice,
                        Padding(padding: EdgeInsets.all(10)),
                        title,
                        Center(
                            child: Column(
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.all(20),
                                    ),
                                    SizedBox(
                                        width: 30.0,
                                        height: 30.0,

                                        child: CircularProgressIndicator(backgroundColor: Colors.green, valueColor: AlwaysStoppedAnimation(Colors.lightGreen)),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.all(100),
                                        child: Text('searching position...'),
                                    )
                                ],
                            ),
                        )
                    ];
                }
                return Scaffold(
                    drawer: Menu(widget.user),
                    appBar: AppBar(
                        title: Text(
                            'Pet & Go',
                            style: TextStyle(
                                color: Colors.white,
                            ),

                        ),
                        iconTheme: IconThemeData(
                            color: Colors.white,
                        ),
                    ),

                    body: ListView(
                        children: children,
                    ),
                    floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.add, color: Colors.white,),
                        onPressed: nNewDogStop,
                        backgroundColor: Colors.green,
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation
                        .centerFloat,
                );
            }
        );
    }


}