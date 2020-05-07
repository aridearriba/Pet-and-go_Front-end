import 'dart:convert';

class Event {
    EventId _id;
    String _description;


    Event({EventId id, String description}) {
        this._id = id;
        this._description = description;
    }

    EventId get id => _id;
    String get description => _description;

    set id(EventId id) => _id = id;
    set description(String description) => _description = description;

    factory Event.fromJson(Map<String, dynamic> json) {
        return Event(
            id: EventId.fromJson(json['id']),
            description: json['descripcion'],
        );
    }
}

class EventId {
    String _title;
    String _user;
    DateTime _date;

    EventId({String title, String user, DateTime date})
    {
        this._title = title;
        this._user = user;
        this._date = date;
    }

    String get title => _title;
    String get user => _user;
    DateTime get date => _date;

    set title(String title) => _title = title;
    set user(String user) => _user = user;
    set date(DateTime date) => _date = date;


    factory EventId.fromJson(Map<String, dynamic> json){
        return EventId(
            title: json['titulo'],
            user: json['user'],
            date: DateTime.parse(json['fecha']),
        );
    }
}