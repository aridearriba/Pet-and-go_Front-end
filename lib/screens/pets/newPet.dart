import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petandgo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/pets/myPets.dart';

class NewPet extends StatelessWidget {
    NewPet(this.user);
    User user;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                FocusScopeNode actualFocus = FocusScope.of(context);

                if(!actualFocus.hasPrimaryFocus){
                    actualFocus.unfocus();
                }

            },
            child: Scaffold(
                drawer: Menu(user),
                appBar: AppBar(
                    title: Text(AppLocalizations.of(context).translate('pets_my-pets_add-pet'), style: TextStyle(color: Colors.white)),
                    iconTheme: IconThemeData(color: Colors.white,),
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                        )
                    ],
                ),
                body: NewPetForm(user),
            ),
        );
    }
}

// Creamos un Widget que sea un Form
class NewPetForm extends StatefulWidget {
    NewPetForm(this.user);
    User user;
    @override
    MyCustomFormState createState() => MyCustomFormState();
}

// Esta clase contendrá los datos relacionados con el formulario.
class MyCustomFormState extends State<NewPetForm> {

    final _formKey = GlobalKey<FormState>();

    final _controladorName = TextEditingController();
    final _controladorBirthday = TextEditingController();
    final _controladorRaza = TextEditingController();

    var _statusCode;
    DateTime _dateTime;

    var _image;
    String _image64 = "";
    Image _imageProfile;

    // Navigate to MyPets
    nMyPets(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPets(widget.user))
        );
    }

    @override
    Widget build(BuildContext context) {
        _imageProfile = getImage();
        return Form(
            key: _formKey,
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    CircleAvatar(
                        minRadius: 10,
                        maxRadius: 80,
                        backgroundColor: Colors.transparent,
                        child: Stack(
                            children: <Widget>[
                                ClipOval(
                                    child: _imageProfile,
                                ),
                                Positioned(
                                    top: 105,
                                    left: 105,
                                    child: Container(
                                        width: 40,
                                        height: 40,
                                        child:
                                        FloatingActionButton(
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
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('user_name')
                            ),
                            controller: _controladorName,
                            keyboardType: TextInputType.text,
                            validator: (value){
                                if(value.isEmpty){
                                    return AppLocalizations.of(context).translate('pets_add-pet_empty-name');
                                }
                                else if (_statusCode == 500){
                                    return AppLocalizations.of(context).translate('pets_add-pet_existing');
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: InkWell(
                            onTap: () async {
                                    _dateTime = await showDatePicker(
                                        context: context,
                                        initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                        firstDate: DateTime(DateTime.now().year - 20),
                                        lastDate: DateTime(DateTime.now().year + 1)
                                    );
                                    _controladorBirthday.text = _dateTime.day.toString() + ". " + _dateTime.month.toString() + ". " + _dateTime.year.toString();
                            },
                            child: IgnorePointer(
                                child: new TextFormField(
                                    decoration: new InputDecoration(labelText: AppLocalizations.of(context).translate('pets_pet_birthday')),
                                    controller: _controladorBirthday,
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
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
                        child: RaisedButton(
                            onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                add().whenComplete(
                                        () {
                                        // comprueba que los campos sean correctos
                                        if (_formKey.currentState.validate()) {
                                            _formKey.currentState.save();
                                            // Si el formulario es válido, queremos mostrar un Snackbar
                                            if(_statusCode == 201) {
                                                Scaffold.of(context).showSnackBar(
                                                    SnackBar(
                                                        content: Text(AppLocalizations.of(context).translate('pets_add-pet_success'))));
                                                // navigate to myPets
                                                if (_image64 != "") changeProfileImage().whenComplete(
                                                        () => Navigator.pushReplacement(context, MaterialPageRoute(
                                                        builder: (context) => MyPets(widget.user))
                                                    ));
                                                else
                                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                                        builder: (context) => MyPets(widget.user))
                                                    );
                                            }
                                        }
                                        else Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(AppLocalizations.of(context).translate('pets_add-pet_fail'))));
                                    });
                            },
                            child: Text(AppLocalizations.of(context).translate('calendar_new-event_add')),
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> add() async{
        var email = widget.user.email;
        var date = _dateTime.toString().substring(0, 10);
        print("DATE: " + _dateTime.toString().substring(0, 10));
        http.Response response = await http.post(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/mascotas"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString()
            },
            body: jsonEncode({
                'id': {
                    'nombre': _controladorName.text,
                    'amo': widget.user.email
                },
                'fechaNacimiento': date}));
        _statusCode = response.statusCode;
        print(_statusCode);
    }

    Image getImage()  {
        // no pet image
        if (_image64 == "")
            return Image.asset('assets/images/examinar.jpg', fit: BoxFit.cover, width: 150, height: 150);

        // else --> load image
        Uint8List _bytesImage;
        String _imgString = _image64.toString();
        _bytesImage = Base64Decoder().convert(_imgString);
        return Image.memory(_bytesImage, fit: BoxFit.cover, width: 150, height: 150);
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
                setState(() => _imageProfile = getImage());
            }
        }
    }

    Future<void> changeProfileImage() async{
        var email = widget.user.email;
        var mascota = _controladorName.text;

        http.Response response = await http.put(new Uri.http("petandgo.herokuapp.com", "/api/usuarios/" + email + "/mascotas/" + mascota + "/image"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: _image64
        );
    }
}