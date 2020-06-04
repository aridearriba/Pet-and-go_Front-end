import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/multilanguage/appLanguage.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/user/sign-up.dart';

import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

/// This Widget is the main application widget.
class LogIn extends StatelessWidget {
    static const String _title = 'Pet and Go';

    @override
    Widget build(BuildContext context) {
        _googleSignIn.disconnect();
        Size size = MediaQuery.of(context).size;
        return GestureDetector(
            onTap: () {
                FocusScopeNode actualFocus = FocusScope.of(context);

                if(!actualFocus.hasPrimaryFocus){
                    actualFocus.unfocus();
                }
            },

            child: Scaffold(
                    body: Stack(
                        children: <Widget>[
                        Center(
                            child: new Image.asset(
                                'assets/images/background-login.jpg',
                                height: size.height,
                                fit: BoxFit.fitHeight,
                            ),
                        ),
                        Center(
                            child: MyStatefulWidget(),
                        )
                    ]
                    ),),
        );
    }
}

class MyStatefulWidget extends StatefulWidget {
    MyStatefulWidget({Key key}) : super(key: key);

    @override
    _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
    final _formKey = GlobalKey<FormState>();
    var _responseCode, _token;
    final controladorEmail = new TextEditingController();
    final controladorPasswd = new TextEditingController();

    User user = new User();
    String language;

    void nHome(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(user))
        );
    }

    @override
    Widget build(BuildContext context) {
        var appLanguage = Provider.of<AppLanguage>(context);
        return Form(
            key: _formKey,
            child: ListView(
                children: <Widget>[
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: EdgeInsets.only(top: 10, right: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    Text(language == null ? appLanguage.appLocal.languageCode.toUpperCase() : language, style: TextStyle(color: Colors.white)),
                                    PopupMenuButton<String>(
                                        initialValue: appLanguage.appLocal.languageCode,
                                        icon: Icon(Icons.language, color: Colors.white),
                                        itemBuilder: (context) => [
                                            PopupMenuItem(
                                                value: "es",
                                                child:  Text("ES"),
                                            ),
                                            PopupMenuItem(
                                                value: "ca",
                                                child:  Text("CA"),
                                            ),
                                            PopupMenuItem(
                                                value: "en",
                                                child:  Text("EN"),
                                            ),
                                        ],
                                        onSelected: (value) {
                                            setState(() {
                                              language = value.toUpperCase();
                                            });
                                            appLanguage.changeLanguage(Locale(value));
                                        },
                                    )
                                ]
                            )
                        ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Image.asset('assets/images/pet-and-go-logo.png', height: 150),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                        child: TextFormField(
                            style: TextStyle(
                                color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('user_email'),
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: controladorEmail,
                            validator: (value) {
                                if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('user_login_empty-email');
                                }
                                else if (_responseCode == 400) {
                                    return AppLocalizations.of(context).translate('user_login_wrong-user-password');
                                }

                                return null;
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                            style: TextStyle(
                                color: Colors.white
                            ),
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).translate('user_password'),
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                ),
                            ),
                            controller: controladorPasswd,
                            validator: (value) {
                                if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('user_login_empty-password');
                                }
                                else if (_responseCode == 400) {
                                    return AppLocalizations.of(context).translate('user_login_wrong-user-password');
                                }
                                return null;
                            },
                            obscureText: true,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:30.0, bottom: 20.0, left: 90.0, right: 90.0),
                        child: RaisedButton(
                            onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid
                                login(controladorEmail.text, controladorPasswd.text).whenComplete(
                                    () {
                                        if (_formKey.currentState.validate()) {
                                            if(_responseCode != 200) {
                                                Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text(AppLocalizations.of(context).translate('user_login_not-complete'))));
                                            }
                                            else {
                                                getData().whenComplete(
                                                    () => getProfileImage().whenComplete(
                                                        () {    Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => Home(user))
                                                            );
                                                        }
                                                    )
                                                );
                                            }
                                        }
                                    }
                                );
                            },
                            child: Text(AppLocalizations.of(context).translate('user_login_login')),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90.0),
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context).translate('user_login_or'),
                                style: TextStyle(color: Colors.white),
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 90.0),
                        child: RaisedButton(
                            onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage())
                                );
                            },
                            child: Text(AppLocalizations.of(context).translate('user_login_sign-up')),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 90.0),
                        child: _signInButton(),
                    ),
                ],
            ),
        );
    }

    Widget _signInButton() {
        return OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
                _googleAccountSignIn().whenComplete(
                        () {
                        getProfileImage().whenComplete( () =>
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home(user))
                        ));
                    }
                );
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Image(
                            image: AssetImage("assets/images/google-logo.png"),
                            height: 20.0),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                AppLocalizations.of(context).translate('user_login_sign-in-google'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                ),
                            )
                        )
                    ],
                ),
            ),
        );
    }

    Future<void> getProfileImage() async{
        var email = user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/" + email + "/image"));
        user.image = response.body;
    }

    Future<void> getData() async{
        var email = controladorEmail.text;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/usuarios/"+email));
        user = User.fromJson(jsonDecode(response.body));
        user.token = _token;
        print("USER: " + user.toString());
        print("TOKEN: " + user.token.toString());
    }

    Future<void> _googleAccountSignIn() async{
        try{
            await _googleSignIn.signIn();
            user.email = _googleSignIn.currentUser.email;
            user.username = _googleSignIn.currentUser.displayName.toLowerCase().replaceAll(" ", "");
            user.name = _googleSignIn.currentUser.displayName;
            if (_googleSignIn.currentUser.photoUrl.runtimeType != Null) user.profileImageUrl = _googleSignIn.currentUser.photoUrl;
            signUp().whenComplete(
                () => login(user.email, "").whenComplete(
                    (){
                        user.token = _token.toString();
                        print("TOKEN USER GOGOLE: " + _token.toString());
                    }
                )
            );
        }catch(error){
            print("ERROR GOOGLE: " + error);
        }
    }

    Future<void> login(String email, String password) async{
         Uri uri= new Uri.http(Global.apiURL, "/api/usuarios/login");
        http.Response response = await post(uri,
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'email': email,
                'password': password}));
        _responseCode = response.statusCode;
        _token = response.headers['authorization'].toString();
         print("TOKEN LOGIN GOGOLE: " + _token.toString());
    }

    Future<void> signUp() async{
        http.Response response = await http.post(new Uri.http(Global.apiURL, "/api/usuarios/"),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'username': user.username,
                'password': "",
                'email': user.email,
                'nombre': user.name}));
        _responseCode = response.statusCode;
    }
}