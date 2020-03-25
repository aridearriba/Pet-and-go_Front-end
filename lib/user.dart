class User {
    final String username;
    final String password;
    final String email;
    final String nombre;

    User({this.username, this.password, this.email, this.nombre});

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            username: json['username'],
            password: json['password'],
            email: json['email'],
            nombre: json['nombre'],
        );
    }
}