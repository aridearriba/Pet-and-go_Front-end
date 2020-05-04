import 'package:flutter/material.dart';
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
    List<int> nearbyDogStops = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];

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

    nLogIn() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nProfile(){
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
            MaterialPageRoute(builder: (context) => DogStopWidget(widget.user, 25))
        );
    }

    @override
    Widget build(BuildContext context) {
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
                    children: <Widget>[
                        Container(
                            height: 200,
                        ),

                        Text(
                            'PERREPARADAS CERCANAS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                            ),
                        ),
                        ListaPerreParadasWidget(widget.user,"cercanas"),
                    ],
                ),
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white,),
                    onPressed: nNewDogStop,
                    backgroundColor: Colors.green,
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
    }
}