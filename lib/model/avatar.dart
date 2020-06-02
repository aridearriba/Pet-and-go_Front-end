class Avatar {
    int _id;
    int _level;
    String _image;

    Avatar({int id, int level, String image}) {
        this._id = id;
        this._level = level;
        this._image = image;
    }

    int get id => _id;
    int get level => _level;
    String get image => _image;

    set level(int level) => _level = level;
    set image(String image) => _image = image;

    factory Avatar.fromJson(Map<String, dynamic> json) {
        return Avatar(
            id: json['id'],
            level: json['niveldesbloqueo'],
            image: json['avatar'],
        );
    }
}
