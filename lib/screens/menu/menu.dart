import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/calendar/calendar.dart';
import 'package:petandgo/screens/pets/myPets.dart';
import 'package:petandgo/screens/puntosDeInteres/puntosInteresTabView.dart';
import 'package:petandgo/screens/quedadas/perreParadaTabView.dart';
import 'package:petandgo/screens/settings.dart';
import 'package:petandgo/screens/chat/principal.dart';

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

    // Navigate to MyPets
    nMisQuedadas(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuedadasTabView(widget.user))
        );
    }

    // Navigate to MyPets
    nPuntosInteres(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PuntosInteresTabView(widget.user))
        );
    }
    // Navigate to Settings
    nSettings(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Settings(widget.user))
        );
    }
    // Navigate to Calendar
    nCalendar(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Calendari(widget.user))
        );
    }

    nChat(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Principal(widget.user))
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
                        currentAccountPicture:  CircleAvatar(
                            backgroundImage: getImage(),
                            radius: 75,
                            backgroundColor: Colors.transparent,
                        ),
                    ),
                    ListTile(
                        leading: Icon(Icons.home),
                        title: Text(AppLocalizations.of(context).translate('home_title')),
                        onTap: () => nHome(),
                    ),
                    ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text(AppLocalizations.of(context).translate('user_profile_title')),
                        onTap: () => nProfile(),
                    ),
                    ListTile(
                        leading: Icon(Icons.pets),
                        title: Text(AppLocalizations.of(context).translate('pets_my-pets_title')),
                        onTap: () => nMyPets(),
                    ),
                    ListTile(
                        leading: Icon(Icons.sentiment_satisfied),
                        title: Text(AppLocalizations.of(context).translate('meetings_my-meetings_title')),
                        onTap: () => nMisQuedadas(),
                    ),
                    ListTile(
                        leading: Icon(Icons.account_balance),
                        title: Text(AppLocalizations.of(context).translate('points-of-interest_title')),
                        onTap: () => nPuntosInteres(),
                    ),
                    ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(AppLocalizations.of(context).translate('calendar_calendar_title')),
                        onTap: () => nCalendar(),
                    ),
                    ListTile(
                        leading: Icon(Icons.chat),
                        title: Text(AppLocalizations.of(context).translate('chat_title')),
                        onTap: () => nChat(),
                    ),
                    ListTile(
                        leading: Icon(Icons.settings),
                        title: Text(AppLocalizations.of(context).translate('settings_title')),
                        onTap: () => nSettings(),
                    ),
                    ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text(AppLocalizations.of(context).translate('logout')),
                        onTap: () => nLogIn(),
                    ),
                ],
            ),
        );
    }

    ImageProvider getImage()  {
        // no user image
        if (widget.user.image == "")
            return Image.network(widget.user.profileImageUrl).image;

        // else --> load image
        Uint8List _bytesImage;
        String _imgString = widget.user.image.toString();
        _bytesImage = Base64Decoder().convert(_imgString);
        return Image.memory(_bytesImage).image;
    }


}