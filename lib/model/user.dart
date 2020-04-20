import 'package:flutter/cupertino.dart';

class User {
    String _username;
    String _password;
    String _email;
    String _name;
    String _profileImageUrl;
    String _token;

    User({String username, String password,String email, String name, String token})
    {
        this._username = username;
        this._password = password;
        this._email = email;
        this._name = name;
        this._token = token;
        this._profileImageUrl = "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png";
    }

    String get username => _username;
    String get password => _password;
    String get email => _email;
    String get name => _name;
    String get profileImageUrl => _profileImageUrl;
    String get token => _token;

    set username(String username) => _username = username;
    set email(String email) => _email = email;
    set name(String name) => _name = name;
    set profileImageUrl(String url) => _profileImageUrl = url;
    set token(String token) => _token = token;

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            username: json['username'],
            password: json['password'],
            email: json['email'],
            name: json['nombre'],
        );
    }
}