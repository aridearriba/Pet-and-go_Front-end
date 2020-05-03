import 'dart:core';

class DogStop{
    String _admin;
    DateTime _date;
    DateTime _creationDate;
    String _locationOrigin;
    List<String> _assistants;
    String _locationEnd;

    DogStop({String admin, DateTime date, DateTime creationDate, String locationOrigin, String locationEnd})
    {
        this._admin = admin;
        this._date = date;
        this._creationDate = creationDate;
        this._locationOrigin = locationOrigin;
        this._locationEnd = locationEnd;
        this._assistants = null;
    }

    String get admin => _admin;
    DateTime get date => _date;
    String get locationOrigin => _locationOrigin;
    String get locationEnd => _locationEnd;
    List<String> get assistants => _assistants;

    factory DogStop.fromJson(Map<String, dynamic> json) {
        return DogStop(
            admin : json['admin'],
            date : json['fechaQuedada'],
            creationDate: json['createdAt'],
            locationOrigin: json['lugarInicio'],
            locationEnd: json['lugarFin'],
        );
    }
}
