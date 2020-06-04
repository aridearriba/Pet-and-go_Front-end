import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petandgo/model/mascota.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/screens/pets/myPets.dart';


class Pet extends StatefulWidget {
    Pet(this.user, this.mascota);
    User user;
    Mascota mascota;
    @override
    _PetState createState() => _PetState();
}

class _PetState extends State<Pet>{
    var _image;
    String _image64;
    ImageProvider _imageProfile;

    nMyPets() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPets(widget.user))
        );
    }

    nPet(Mascota mascota) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pet(widget.user, mascota))
        );
    }

    var _statusCode;
    Mascota _result = new Mascota();
    var _date;
    DateTime _dateTime;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    @override
    Widget build(BuildContext context) {
        _date = widget.mascota.date.day.toString() + "." + widget.mascota.date.month.toString() + "." + widget.mascota.date.year.toString();
        var _difference = DateTime.now().difference(widget.mascota.date);
        var _age = (_difference.inDays/365).floor().toString();
        _image64 = widget.mascota.image;
        _imageProfile = getImage();

        return Scaffold(
            key: _scaffoldKey,
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    AppLocalizations.of(context).translate('pets_pet_title'),
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => nMyPets(),
                    )
                ],
            ),
            body: ListView(
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
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
                                                        heroTag: "pickImage",
                                                        onPressed: _pickImage,
                                                        tooltip: AppLocalizations.of(context).translate('user_sign-up_choose-image'),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        // PET
                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: Text(
                                                AppLocalizations.of(context).translate('pets_pet_info').toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.left,
                                            )
                                        ),
                                        // nombre
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.assignment,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + widget.mascota.id.name,
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 16.0,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                    )
                                                ]
                                            ),
                                        ),
                                        Padding (
                                            padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(
                                                        Icons.date_range,
                                                        color: Colors.black54,
                                                    ),
                                                    Text(
                                                        '   ' + _date + " (" + _age + " " + AppLocalizations.of(context).translate('pets_pet_years') + ")",
                                                        style: TextStyle(color: Colors.black54,),
                                                    )
                                                ],
                                            )
                                        ),
                                        Center(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0, bottom: 30),
                                                child: FloatingActionButton.extended(
                                                    heroTag: "editPet",
                                                    icon: Icon(Icons.pets, color: Colors.white),
                                                    backgroundColor: Colors.green,
                                                    label: Text(AppLocalizations.of(context).translate('pets_pet_edit')),
                                                    onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) => _buildEditDialog(context)
                                                        );
                                                    }
                                                )
                                            ),
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

    Widget _buildEditDialog(BuildContext context) {
        TextEditingController _nameController = new TextEditingController();
        _nameController.text = widget.mascota.id.name;
        var _dateT = widget.mascota.date.day.toString() + "." + widget.mascota.date.month.toString() + "." + widget.mascota.date.year.toString();
        TextEditingController _dateController = new TextEditingController();
        _dateController.text = _dateT;
        return new SimpleDialog(
            title: Text(AppLocalizations.of(context).translate('pets_pet_pet-info'),
            textAlign: TextAlign.center,),
            children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Text(
                                AppLocalizations.of(context).translate('pets_pet_birthday'),
                                style: TextStyle(color: Colors.green,),
                                textAlign: TextAlign.center,
                            ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                    child: InkWell(
                                onTap: () async {
                                    _dateTime = await showDatePicker(
                                        context: context,
                                        initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                        firstDate: DateTime(DateTime.now().year - 20),
                                        lastDate: DateTime(DateTime.now().year + 1)
                                    );
                                    _dateController.text = _dateTime.day.toString() + ". " + _dateTime.month.toString() + ". " + _dateTime.year.toString();
                                },
                                child: IgnorePointer(
                                    child: new TextFormField(
                                        controller: _dateController,
                                        textAlign: TextAlign.center,
                                        validator: (value){
                                            if(value.isEmpty){
                                                return AppLocalizations.of(context).translate('calendar_new-event_empty-date');
                                            }
                                            return null;
                                        },
                                        onSaved: (String val) {},
                                    ),
                                ),
                    ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                    child: SimpleDialogOption(
                        child: RaisedButton(
                            disabledColor: Colors.green,
                            child: Text(AppLocalizations.of(context).translate('user_edit_update')),
                            disabledTextColor: Colors.white,
                        ),
                        onPressed: ()  {
                            if(_dateController.text == _date){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context).translate('pets_pet_update-fail')),
                                    duration: Duration(seconds: 2),
                                ));
                            }
                            else{
                                update().whenComplete(() {
                                    if(_statusCode == 200){
                                        getMascota().whenComplete(() {
                                            Navigator.pop(context);
                                            nPet(_result);
                                        });
                                    }
                                });
                            }
                        },
                    )
                ),
            ],
        );
    }

    Future<void> update() async{
        var email = widget.user.email;
        String mascot = widget.mascota.id.name;
        var date = _dateTime.toString().substring(0,10);
        http.Response response = await http.put(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/mascotas/"+ mascot),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString()
            },
            body: jsonEncode({
                    "id": {
                        "nombre": mascot,
                        "amo": widget.user.email
                    },
                    "fechaNacimiento": date}));
        _statusCode = response.statusCode;
    }


    Future<void> getMascota() async{
        var email = widget.user.email;
        String mascot = widget.mascota.id.name;
        http.Response response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/mascotas/"+ mascot));
        _result = Mascota.fromJson(jsonDecode(response.body));
    }
    ImageProvider getImage()  {
        // no pet image
        if (_image64 == "")
            return Image.network("https://www.abbeyvetgroupbarnsley.co.uk/wp-content/uploads/2014/09/dog-avatar.png").image;

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
                    title: Text(AppLocalizations.of(context).translate('alert-dialog_select-option')),
                    actions: <Widget>[
                        MaterialButton(
                            child: Text(AppLocalizations.of(context).translate('alert-dialog_camera')),
                            onPressed: () => Navigator.pop(context, ImageSource.camera),
                        ),
                        MaterialButton(
                            child: Text(AppLocalizations.of(context).translate('alert-dialog_gallery')),
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
        var mascota = widget.mascota.id.name;

        http.Response response = await http.put(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/" + email + "/mascotas/" + mascota + "/image"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: _image64
        );

        if (response.statusCode == 200) widget.mascota.image = _image64;
    }
}