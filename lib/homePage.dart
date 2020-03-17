import 'package:flutter/material.dart';

class Home extends StatefulWidget {
    Home({Key key,}) : super(key: key);

@override
    HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

    nLogIn() {}

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Pet & Go'),
                actions: <Widget>[
                    IconButton(icon : Icon(Icons.dehaze), color: Colors.white, onPressed: () {},),
                ],
            ),
            body: Center(

                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Text(
                            'Welcome (name) \n to Pet & Go',
                            style: TextStyle(fontSize: 25,),
                            textAlign: TextAlign.center,
                            //añadir en un futuro el nombre
                        ),
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: nLogIn,
                child: Text('LogOut'),
            ),
        );
    }
}
