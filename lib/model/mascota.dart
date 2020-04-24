import 'dart:convert';

class Mascota {
    Id _id;
    DateTime _date;
    String _image;


    Mascota({Id id, DateTime date, String image}) {
        this._id = id;
        this._date = date;
        this._image = image = "";
    }

    Id get id => _id;
    DateTime get date => _date;
    String get image => _image;

    set image(String image) => _image = image;

    factory Mascota.fromJson(Map<String, dynamic> json) {
        return Mascota(
            id: Id.fromJson(json['id']),
            date: DateTime.parse(json['fechaNacimiento']),
        );
    }
}

class Id {
    String _name;
    String _amo;

    Id({String name, String amo})
    {
        this._name = name;
        this._amo = amo;
    }

    String get name => _name;
    String get amo => _amo;


    factory Id.fromJson(Map<String, dynamic> json){
        return Id(
            name: json['nombre'],
            amo: json['amo']
        );
    }
}