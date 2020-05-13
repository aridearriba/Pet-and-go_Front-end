
class Evento {
    int _id;
    String _title;
    String _user;
    DateTime _dateIni;
    DateTime _dateEnd;
    String _description;
    bool _notifications;
    bool _previouslyDeleted;

    Evento({int id, String title, String user, DateTime dateIni, DateTime dateEnd, String description, bool notifications}) {
        this._id = id;
        this._title = title;
        this._user = user;
        this._dateIni = dateIni;
        this._dateEnd = dateEnd;
        this._description = description;
        this._notifications = notifications;
        this._previouslyDeleted = false;
    }

    int get id => _id;
    String get title => _title;
    String get user => _user;
    DateTime get dateIni => _dateIni;
    DateTime get dateEnd => _dateEnd;
    String get description => _description;
    bool get notifications => _notifications;
    bool get previouslyDeleted => _previouslyDeleted;


    set id(int id) => _id = id;
    set title(String title) => _title = title;
    set user(String value) =>_user = value;
    set dateIni(DateTime value) =>_dateIni = value;
    set dateEnd(DateTime value) => _dateEnd = value;
    set description(String description) => _description = description;
    set notifications(bool notifications) => _notifications = notifications;
    set previouslyDeleted(bool deleted) => _previouslyDeleted = deleted;

    factory Evento.fromJson(Map<String, dynamic> json) {
        return Evento(
            id: json['id'],
            title: json['titulo'],
            user: json['usuario'],
            dateIni: DateTime.parse(json['fecha']),
            dateEnd: DateTime.parse(json['fechaFin']),
            description: json['descripcion'],
            notifications: json['notificaciones'],
        );
    }
}