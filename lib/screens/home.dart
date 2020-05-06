import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petandgo/screens/quedadas/listadoPerreParadasView.dart';
import 'package:petandgo/screens/DogStops/newDogStop.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/screens/user/profile.dart';
import 'package:petandgo/model/user.dart';

import 'DogStops/DogStopView.dart';

class Home extends StatefulWidget {
    Home(this.user);
    User user;

    //PEDIR A BACK EL LISTADO DE PERREPARADAS CERCANAS AL USUARIO

    @override
    _HomeState createState() => _HomeState();
}

class DogStopWidgetShort extends StatelessWidget{
    @override
    Widget build(BuildContext context) {
        Widget dogStop = Container(
            padding: const EdgeInsets.all(8.0),
            width: 700,
            height: 100,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                        Color(0xFF068FFA),
                        Color(0xFF89ED91)
                    ]
                )
            ),
            child: SafeArea(
                child: Column(
                    children: <Widget>[
                        Text('Hola')
                    ],
                ),
            ),
        );

      return dogStop;
  }

}

class _HomeState extends State<Home> {

    String _queryParameters = '/distancia/1000/';

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
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewDogStop(widget.user))
        );
    }

    nDogStopView() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DogStopWidget(widget.user, 25))
        );
    }

    Future<String> _getCurrentLocation() async {
        final position = await Geolocator().getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print('$position');

        _queryParameters +=
            position.latitude.toString() + '/' + position.longitude.toString();
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<String>(
            future: _getCurrentLocation(),
            // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                    children = <Widget>[
                        Container(height: 200,),
                        Text(
                            'PERREPARADAS CERCANAS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                            ),
                        ),
                        ListaPerreParadasWidget(widget.user, _queryParameters),
                    ];
                }
                else if (snapshot.hasError) {
                    children = <Widget>[
                        Container(height: 200,),
                        Text(
                            'PERREPARADAS CERCANAS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                            ),
                        ),
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
                        Container(height: 200,),
                        Text(
                            'PERREPARADAS CERCANAS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                            ),
                        ),
                        Center(
                            child: Column(
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.all(20),
                                    ),
                                    SizedBox(
                                        width: 30.0,
                                        height: 30.0,

                                        child: CircularProgressIndicator(),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.all(100),
                                        child: Text('Awaiting result...'),
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