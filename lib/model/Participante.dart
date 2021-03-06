import 'dart:convert';

List<Participante> participanteFromJson(String str) => List<Participante>.from(json.decode(str).map((x) => Participante.fromJson(x)));

String participanteToJson(List<Participante> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Participante {
  Participante({
    this.nombre,
    this.username,
    this.email,
    this.image,
    this.estado,
    this.urlAvatar,
  });

  String nombre;
  String username;
  String email;
  String image;
  String estado;
  String urlAvatar;

  factory Participante.fromJson(Map<String, dynamic> json) => Participante(
    nombre: json["nombre"],
    username: json["username"],
    email: json["email"],
    image: json["image"] == null ? null : json["image"],
    estado: json["estado"] == null ? null : json["estado"],
    urlAvatar: json["urlAvatar"] == null ? null : json["urlAvatar"],
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "username": username,
    "email": email,
    "image": image == null ? null : image,
    "estado": estado == null ? null : estado,
    "urlAvatar": urlAvatar == null ? null : urlAvatar,
  };
}
