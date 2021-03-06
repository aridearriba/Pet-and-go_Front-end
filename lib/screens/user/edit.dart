import 'dart:convert';
import 'dart:io';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/model/user.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/user/profile.dart';

class Edit extends StatelessWidget{
    Edit(this.user);
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
                    title: Text(AppLocalizations.of(context).translate('user_edit_title'), style: TextStyle(color: Colors.white)),
                    iconTheme: IconThemeData(color: Colors.white,),
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                        )
                    ],
                ),
                body: EditForm(user),
            ),
        );
  }

}

class EditForm extends StatefulWidget{
    EditForm(this.user);
    User user;

    @override
    MyCustomFormState createState() => MyCustomFormState();

}

class MyCustomFormState extends State<EditForm>{
    final _formKey = GlobalKey<FormState>();

    final _controladorName = TextEditingController();
    final _controladorUsername = TextEditingController();
    final _controladorOldPasswd = TextEditingController();
    final _controladorNewPasswd = TextEditingController();
    var _responseCode, _token;

    DateTime _dateTime;

    User userRefresh = new User();

    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    nProfile(User user){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(user))
        );
    }

    @override
    Widget build(BuildContext context) {
        _controladorName.text = widget.user.name;
        _controladorUsername.text = widget.user.username;
        return Scaffold(
            key: _scaffoldKey,
            body: Form(
                key: _formKey,
                child: ListView(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                                children: <Widget>[
                                    Expanded(child: Text(AppLocalizations.of(context).translate('user_username'), style: TextStyle(color: Colors.green),)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5.0),
                                        child: SizedBox(width: 200.0,child: TextFormField(
                                            controller: _controladorUsername,
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.center,
                                            validator: (value){
                                                return null;
                                                },
                                            ),
                                        ),
                                    ),
                                ],
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                                children: <Widget>[
                                    Expanded(child: Text(AppLocalizations.of(context).translate('user_name'), style: TextStyle(color: Colors.green))),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                                        child: SizedBox(width: 200.0,child: TextFormField(
                                            controller: _controladorName,
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.center,
                                            validator: (value){
                                                return null;
                                            },
                                        ),
                                        ),
                                    ),
                                ],
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
                            child: RaisedButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                onPressed: () {
                                    if(_controladorName.text.isEmpty || _controladorUsername.text.isEmpty){
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text(AppLocalizations.of(context).translate('user_edit_empty-fields')),
                                            duration: Duration(seconds: 2),
                                        ));
                                    }
                                    else{
                                        updateProfile().whenComplete((){
                                            print(_responseCode);
                                           if(_responseCode == 200){
                                               getData().whenComplete((){
                                                   nProfile(userRefresh);
                                               });
                                           }
                                        });
                                    }
                                },
                                child: Text(AppLocalizations.of(context).translate('user_edit_update')),
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, left: 30.0, right: 30.0, bottom: 5.0),
                            child: FloatingActionButton.extended(
                                icon: Icon(Icons.lock_outline, color: Colors.white,
                                ),
                                backgroundColor: Colors.lightGreen,
                                onPressed: (){
                                    login(widget.user.email, "").whenComplete( () {
                                        if(_responseCode == 200){
                                            showDialog(context: context,
                                                builder: (BuildContext context) => _buildGoogleDialog(context)
                                            );
                                        }
                                        else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => _buildEditDialog(context)
                                            );
                                        }
                                    });

                                }, label: Text(AppLocalizations.of(context).translate('user_edit_change-password')))
                        ),
                    ],
                ),
            )
        );
    }

    Widget _buildEditDialog(BuildContext context) {
        TextEditingController _passwdController = new TextEditingController();
        _controladorOldPasswd.clear();
        _controladorNewPasswd.clear();
        return new SimpleDialog(
            title: Text(
                AppLocalizations.of(context).translate('user_edit_change-password'),
                textAlign: TextAlign.center,
            ),
            children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                        children: <Widget>[
                            Expanded(child: Text(AppLocalizations.of(context).translate('user_edit_current-password'), style: TextStyle(color: Colors.green))),
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                                child: SizedBox(width: 120.0,child: TextFormField(
                                    controller: _controladorOldPasswd,
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.center,
                                    obscureText: true,
                                ),
                                ),
                            ),
                        ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                        children: <Widget>[
                            Expanded(child: Text(AppLocalizations.of(context).translate('user_edit_new-password'), style: TextStyle(color: Colors.green))),
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                                child: SizedBox(width: 120.0,child: TextFormField(
                                    controller: _controladorNewPasswd,
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.center,
                                    obscureText: true,
                                ),
                                ),
                            ),
                        ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                        children: <Widget>[
                            Expanded(child: Text(AppLocalizations.of(context).translate('user_repeat-password'), style: TextStyle(color: Colors.green))),
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                                child: SizedBox(width: 120.0, child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.center,
                                    controller: _passwdController,
                                    obscureText: true,
                                ),
                                ),
                            ),
                        ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                    child: SimpleDialogOption(
                        child: RaisedButton(
                            disabledColor: Colors.lightGreen,
                            child: Text(AppLocalizations.of(context).translate('user_edit_update')),
                            disabledTextColor: Colors.white,
                        ),
                        onPressed: ()  {
                            if(_controladorNewPasswd.text.isEmpty || _controladorOldPasswd.text.isEmpty || _passwdController.text.isEmpty){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context).translate('user_edit_empty-fields')),
                                    duration: Duration(seconds: 2),
                                ));
                            }
                            else if(_controladorNewPasswd.text != _passwdController.text){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context).translate('user_sign-up_not-match-passwords')),
                                    duration: Duration(seconds: 2),
                                ));
                            }
                            else {
                                updatePasswd().whenComplete(() {
                                    if (_responseCode == 200) {
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(AppLocalizations.of(context).translate('user_edit_password-update-success')),
                                                duration: Duration(seconds: 2),
                                            ));
                                        Navigator.pop(context);
                                    }
                                    else if(_responseCode == 400){
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    AppLocalizations.of(context).translate('user_edit_wrong-current-password')),
                                                duration: Duration(seconds: 2),
                                            ));
                                    }
                                });
                            }
                        },
                    )
                ),
            ],
        );
    }

    Widget _buildGoogleDialog(BuildContext context) {
        return new AlertDialog(
            title: Text(AppLocalizations.of(context).translate('user_edit_alert'), textAlign: TextAlign.center,),
            content: Text(AppLocalizations.of(context).translate('user_edit_google-user'),
                style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
        );
    }

    Future<void> login(String email, String password) async{
        http.Response response = await http.post(new Uri.http(Global.apiURL, "/api/usuarios/login"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'email': email,
                'password': password}));
        _responseCode = response.statusCode;
        _token = response.headers['authorization'].toString();
    }

    Future<void> updateProfile() async{
        var email = widget.user.email;
        var name = _controladorName.text;
        var username = _controladorUsername.text;
        http.Response response = await http.put(new Uri.http(Global.apiURL, "/api/usuarios/" + email),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString()
            },
            body: jsonEncode({
                "nombre": name,
                "username": username
            })
        );
        _responseCode = response.statusCode;
    }

    Future<void> updatePasswd() async{
        var email = widget.user.email;
        var old = _controladorOldPasswd.text;
        var nueva = _controladorNewPasswd.text;
        http.Response response = await http.put(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/forgot"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString()
            },
            body: jsonEncode({
                "newPassword": nueva,
                "oldPassword": old
            })
        );
        _responseCode = response.statusCode;
    }

    Future<void> getData() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/"+email));
        userRefresh = User.fromJson(jsonDecode(response.body));
        userRefresh.token = widget.user.token;
        userRefresh.image = widget.user.image;
    }
}