import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class User {
    String _username;
    String _password;
    String _email;
    String _name;
    String _profileImageUrl;
    String _token;
    String _image;
    Position pos;
    int _points;
    int _level;
    String _avatar;
    List<dynamic> _friends;


    User({String username, String password,String email, String name, String token, int points, int level, String avatar, List<dynamic> friends})
    {
        this._username = username;
        this._password = password;
        this._email = email;
        this._name = name;
        this._token = token;
        this._image = image = "";
        this._profileImageUrl = "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png";
        this._points = points;
        this._level = level;
        this._avatar = avatar;
        this._friends = friends;

    }

    String get username => _username;
    String get password => _password;
    String get email => _email;
    String get name => _name;
    String get profileImageUrl => _profileImageUrl;
    String get image => _image;
    String get token => _token;
    int get points => _points;
    int get level => _level;
    String get avatar => _avatar;
    List<dynamic> get friends => _friends;

    set username(String username) => _username = username;
    set email(String email) => _email = email;
    set name(String name) => _name = name;
    set profileImageUrl(String url) => _profileImageUrl = url;
    set token(String token) => _token = token;
    set image(String image) => _image = image;
    set points(int points) => _points = points;
    set level(int level) => _level = level;
    set avatar(String avatar) => _avatar = avatar;

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            username: json['username'],
            password: json['password'],
            email: json['email'],
            name: json['nombre'],
            points: json['puntos'],
            level: json['nivel'],
            avatar: json['avatar'],
            friends: json['myFriends']
        );
    }
}