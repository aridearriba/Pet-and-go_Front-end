import 'package:flutter/cupertino.dart';

class User {
    String _username;
    String _password;
    String _email;
    String _name;
    String _profileImageUrl;

    User({String username, String password,String email, String name})
    {
        this._username = username;
        this._password = password;
        this._email = email;
        this._name = name;
        this._profileImageUrl = "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png";
    }

    String get username => _username;
    String get password => _password;
    String get email => _email;
    String get name => _name;
    String get profileImageUrl => _profileImageUrl;

    set username(String username) => _username = username;
    set email(String email) => _email = email;
    set name(String name) => _name = name;
    set profileImageUrl(String url) => _profileImageUrl = url;

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            username: json['username'],
            password: json['password'],
            email: json['email'],
            name: json['nombre'],
        );
    }
}