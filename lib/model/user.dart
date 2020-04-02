class User {
    String _username;
    String _password;
    String _email;
    String _name;

    User({String username, String password,String email, String name})
    {
        this._username = username;
        this._password = password;
        this._email = email;
        this._name = name;
    }

    String get username => _username;
    String get password => _password;
    String get email => _email;
    String get name => _name;

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            username: json['username'],
            password: json['password'],
            email: json['email'],
            name: json['nombre'],
        );
    }
}