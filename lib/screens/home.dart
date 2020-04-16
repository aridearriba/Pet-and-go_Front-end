import 'package:flutter/material.dart';
import 'package:petandgo/model/DogStop.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/screens/user/profile.dart';
import 'package:petandgo/model/user.dart';

class Home extends StatefulWidget {
    Home(this.user);
    User user;
    List<int> nearbyDogStops = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];

    //PEDIR A BACK EL LISTADO DE PERREPARADAS CERCANAS AL USUARIO

    @override
    _HomeState createState() => _HomeState();
}

class DogStopWidget extends StatelessWidget{
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
                        Container(
                          height: 500,
                          child: ListView.separated(
                              padding: const EdgeInsets.all(20),
                               itemCount: widget.nearbyDogStops.length,
                               itemBuilder: (BuildContext context, int index){
                                  return Container(
                                      height: 200,
                                      color: Colors.amber,
                                     child: Text('index ${widget.nearbyDogStops[index]}'),
                                  );
                                  },
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                          ),
                        )
                    ],
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: (){},
                    backgroundColor: Colors.green,
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
    }
}