import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import '../home.dart';

class SignUpPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final appTitle = 'petandgo';

        return GestureDetector(
            onTap: () {
                FocusScopeNode actualFocus = FocusScope.of(context);

                if(!actualFocus.hasPrimaryFocus){
                    actualFocus.unfocus();
                }
            },
            child:  Scaffold(
                //resizeToAvoidBottomInset: false,
                appBar: AppBar(
                    iconTheme: IconThemeData(color: Colors.white),
                    title: Text(AppLocalizations.of(context).translate('user_sign-up_title'), style: TextStyle(color: Colors.white)),
                ),
                body: MyCustomForm(),
            ),
        );
    }
}

// Creamos un Widget que sea un Form
class MyCustomForm extends StatefulWidget {
    @override
    MyCustomFormState createState() {
        return MyCustomFormState();
    }
}

// Esta clase contendrá los datos relacionados con el formulario.
class MyCustomFormState extends State<MyCustomForm> {

    final _formKey = GlobalKey<FormState>(); // así identificaremos el formulario

    final _controladorEmail = TextEditingController(); //así podremos capturar el email
    final _controladorPasswd = TextEditingController(); //así podremos capturar la contraseña
    final _controladorNombre = TextEditingController();
    final _controladorApellido1 = TextEditingController();
    final _controladorUsername = TextEditingController();

    var _responseMessage,_responseCode;
    var _token;
    var _email;

    var _image;
    String _image64 = "";
    Image _imageProfile;
    User user = new User();

    @override
    Widget build(BuildContext context) {
        _imageProfile = getImage();
        return Form(
            key: _formKey,
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Padding(padding: EdgeInsets.all(10)),
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
                                labelText: AppLocalizations.of(context).translate('user_email')
                            ),
                            controller: _controladorEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                                RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                if(value.isEmpty){
                                    return AppLocalizations.of(context).translate('user_login_empty-email');
                                }
                                if(!regex.hasMatch(value)){
                                    return AppLocalizations.of(context).translate('user_sign-up_invalid-email');
                                }
                                if (_responseMessage == "email") {
                                    return AppLocalizations.of(context).translate('user_sign-up_existing-email');
                                }
                                return null;
                            },
                            onSaved: (value) => _email = value,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('user_username'),
                            ),
                            controller: _controladorUsername,
                            validator: (value){
                                if(value.isEmpty){
                                    return AppLocalizations.of(context).translate('user_sign-up_empty-username');
                                }
                                if (_responseMessage == "username"){
                                    return AppLocalizations.of(context).translate('user_sign-up_existing-username');
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('user_name'),
                            ),
                            controller: _controladorNombre,
                            validator: (value){
                                if(value.isEmpty){
                                    return AppLocalizations.of(context).translate('user_sign-up_empty-name');
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('user_surname'),
                            ),
                            controller: _controladorApellido1,
                            validator: (value){
                                if(value.isEmpty){
                                    return AppLocalizations.of(context).translate('user_sign-up_empty-surname');
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('user_password'),
                            ),
                            controller: _controladorPasswd,
                            validator: (value){
                                if(value.isEmpty){
                                    return AppLocalizations.of(context).translate('user_login_empty-password');
                                }
                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                            obscureText: true,
                            maxLength: 20,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('user_repeat-password')
                            ),
                            validator: (value) {
                                if(value!=_controladorPasswd.text){
                                    return AppLocalizations.of(context).translate('user_sign-up_not-match_passwords');
                                }
                                return null;
                            },
                        ),
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
                        child: RaisedButton(
                            onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                signUp().whenComplete(
                                () {
                                    // comprueba que los campos sean correctos
                                    if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        // Si el formulario es válido, queremos mostrar un Snackbar
                                        if(_responseCode == 201) {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(AppLocalizations.of(context).translate('user_sign-up_success'))));
                                                // navigate to home
                                                login(_controladorEmail.text, _controladorPasswd.text).whenComplete(
                                                    () => getData().whenComplete(
                                                        () {
                                                            if (_image64 != "") changeProfileImage().whenComplete(
                                                                () => Navigator.pushReplacement(context, MaterialPageRoute(
                                                                    builder: (context) => Home(user))
                                                            ));
                                                            else
                                                                Navigator.pushReplacement(context, MaterialPageRoute(
                                                                builder: (context) => Home(user))
                                                                );
                                                        }
                                                ));
                                            }
                                        }
                                        else Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(AppLocalizations.of(context).translate('user_sign-up_fail'))));
                                });
                            },
                            child: Text(AppLocalizations.of(context).translate('user_login_sign-up')),
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> signUp() async{
        http.Response response = await http.post(new Uri.http(Global.apiURL, "/api/usuarios/"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'username': _controladorUsername.text,
                'password': _controladorPasswd.text,
                'email': _controladorEmail.text,
                'nombre': _controladorNombre.text + " " + _controladorApellido1.text}));
        _responseCode = response.statusCode;
        _responseMessage = response.body;
    }

    Image getImage()  {
        // no image
        if (_image64 == "")
            return Image.asset(AppLocalizations.of(context).translate('user_sign-up_upload-image-url'), fit: BoxFit.cover, width: 150, height: 150);

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
        var email = _controladorEmail.text;

        http.Response response = await http.put(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/image"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: user.token.toString(),
            },
            body: _image64
        );

        if (response.statusCode == 200) user.image = _image64;
    }

    Future<void> getData() async{
        var email = _controladorEmail.text;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/"+email));
        user = User.fromJson(jsonDecode(response.body));
        user.token = _token;
    }

    Future<void> login(String email, String password) async{
        http.Response response = await post(new Uri.http(Global.apiURL, "/api/usuarios/login"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'email': email,
                'password': password}));
        _responseCode = response.statusCode;
        _token = response.headers['authorization'].toString();
    }

}