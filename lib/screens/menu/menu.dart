import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/pets/myPets.dart';

import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/screens/user/profile.dart';

import '../home.dart';

class Menu extends StatefulWidget {
    Menu(this.user);
    User user;
    // Navigate to LogIn
    @override
    _MenuContent createState() => _MenuContent();
}

class _MenuContent extends State<Menu> {
    // Navigate to LogIn
    nLogIn() {
        widget.user = null;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }
    // Navigate to Profile
    nProfile(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(widget.user))
        );
    }
    // Navigate to Home
    nHome(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(widget.user))
        );
    }
    // Navigate to MyPets
    nMyPets(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPets(widget.user))
        );
    }

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
                        iconTheme: IconThemeData(
                            color: Colors.white,
                        ),
                    ),
                    UserAccountsDrawerHeader(
                        accountName: Text(
                            widget.user.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                            ),
                        ),
                        accountEmail: Text(
                            widget.user.email,
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
                        currentAccountPicture: IconButton(
                            icon : Icon(Icons.account_circle, size: 70),
                            color: Colors.white,
                            onPressed: nProfile,
                        ),
                    ),
                    ListTile(
                        leading: Icon(Icons.home),
                        title: Text('Inicio'),
                        onTap: () => nHome(),
                    ),
                    ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Perfil'),
                        onTap: () => nProfile(),
                    ),
                    ListTile(
                        leading: Icon(Icons.pets),
                        title: Text('Mis mascotas'),
                        onTap: () => nMyPets(),
                    ),
                    ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Configuración'),
                        onTap: () => {Navigator.of(context).pop()},
                    ),
                    ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout'),
                        onTap: () => nLogIn(),
                    ),
                ],
            ),
        );
    }
}