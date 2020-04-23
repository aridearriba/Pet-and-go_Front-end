import 'dart:core';

class DogStop{
    String _organizer;
    DateTime _date;
    String _locationName;
    List<String> _assistants;
    String _location;

    //BORRAR CUANDO EL BACK ESTE HECHO
    DogStop(String organizer, DateTime date, String location){
        this._organizer = organizer;
        this._date = date;
        this._location = location;
    }

    /*DogStop({String organizer, DateTime date, String location})
    {
        this._organizer = organizer;
        this._date = date;
        this._location = location;
        this._assistants = null;
    }*/

    String get organizer => _organizer;
    DateTime get date => _date;
    String get location => _location;
    String get locationName => _locationName;
    List<String> get assistants => _assistants;

    /*factory DogStop.fromJson(Map<String, dynamic> json) {
        return DogStop(
            organizer: json['organizer'],
        );
    }*/
}