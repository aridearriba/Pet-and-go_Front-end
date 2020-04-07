import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                    AppBar(
                        title: Text(
                            'Pet & Go',
                            style: TextStyle(
                                color: Colors.white,
                            ),
                        ),
                    ),
                    UserAccountsDrawerHeader(
                        accountName: Text(
                            "Nombre Apellido",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                            ),
                        ),
                        accountEmail: Text(
                            "prueba@gmail.com",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                            ),
                        ),
                        decoration:  BoxDecoration(
                            color: Colors.green,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/background-login.jpg')
                            )
                        ),
                        currentAccountPicture: CircleAvatar(
                            backgroundColor:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? Colors.blue
                                : Colors.white,
                            child: Text(
                                "A",
                                style: TextStyle(fontSize: 40.0),
                            ),
                        ),
                    ),
                    ListTile(
                        leading: Icon(Icons.home),
                        title: Text('Inicio'),
                        onTap: () => {},
                    ),
                    ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Perfil'),
                        onTap: () => {Navigator.of(context).pop()},
                    ),
                    ListTile(
                        leading: Icon(Icons.pets),
                        title: Text('Mis mascotas'),
                        onTap: () => {Navigator.of(context).pop()},
                    ),
                    ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Configuración'),
                        onTap: () => {Navigator.of(context).pop()},
                    ),
                    ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout'),
                        onTap: () => {Navigator.of(context).pop()},
                    ),
                ],
            ),
        );
    }
}