import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/pets/pet.dart';
import 'package:petandgo/screens/user/edit.dart';
import 'package:petandgo/screens/user/login.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/pets/newPet.dart';

import 'package:http/http.dart' as http;
import 'package:petandgo/screens/user/sign-up.dart';


// ignore: must_be_immutable
class Profile extends StatefulWidget {
    Profile(this.user);
    User user;

    @override
    _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
{
    var _image;
    String _image64;
    ImageProvider _imageProfile;

    nLogIn() {
        widget.user = null;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LogIn())
        );
    }

    nHome() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(widget.user))
        );
    }

    nNewPet() {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPet(widget.user))
        );
    }

    nPet(Mascota mascota) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pet(widget.user, mascota))
        );
    }

    nProfile() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(widget.user))
        );
    }
    nEdit(){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Edit(widget.user))
        );
    }


    @override
    Widget build(BuildContext context) {
        _image64 = widget.user.image;
        _imageProfile = getImage();

        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Perfil',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(
                            Icons.mode_edit,
                            color: Colors.white,
                        ),
                        onPressed: () => nEdit(),
                    ),
                ],
            ),
            body: ListView(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 30.0, right: 30.0),
                        child: Column(
                            children: <Widget>[
                                CircleAvatar(
                                    backgroundImage: _imageProfile,
                                    radius: 75,
                                    backgroundColor: Colors.transparent,
                                    child: Stack(
                                        children: <Widget>[
                                            Positioned(
                                                top: 105,
                                                left: 110,
                                                child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    child:
                                                        FloatingActionButton(
                                                            onPressed: _pickImage,
                                                            tooltip: 'Elige una imagen',
                                                            elevation: 10.0,
                                                            backgroundColor: Theme.of(context).primaryColor,
                                                            child: Icon(Icons.add_a_photo, color: Colors.black, size: 15),
                                                        )
                                                )
                                            ),
                                        ]
                                    ),
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                        // USER
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                                "USUARIO",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        // username
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.account_circle,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + widget.user
                                                            .username,
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
                                                top: 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.assignment_ind,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' +
                                                            widget.user.name,
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
                                                top: 5.0, bottom: 30),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.email,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' +
                                                            widget.user.email,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black54,
                                                        ),
                                                    )
                                                ],
                                            )
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),
                ]
            ),
        );
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

    void _pickImage() async {
        final imageSource = await showDialog<ImageSource>(
            context: context,
            builder: (context) =>
                AlertDialog(
                    title: Text("Selecciona una opción"),
                    actions: <Widget>[
                        MaterialButton(
                            child: Text("Camera"),
                            onPressed: () => Navigator.pop(context, ImageSource.camera),
                        ),
                        MaterialButton(
                            child: Text("Galería"),
                            onPressed: () => Navigator.pop(context, ImageSource.gallery),
                        )
                    ],
                )
        );

        if(imageSource != null) {
            final file = await ImagePicker.pickImage(source: imageSource);
            if (file != null)
            {
                _image = file;
                _image64 = Base64Encoder().convert(_image.readAsBytesSync());
                changeProfileImage().whenComplete(
                    () {
                        setState(() => _imageProfile = getImage());
                    }
                );
            }
        }
    }

    Future<void> changeProfileImage() async{
        var email = widget.user.email;

        http.Response response = await http.put(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/" + email + "/image"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: _image64
        );
        
        if (response.statusCode == 200) widget.user.image = _image64;
    }

}