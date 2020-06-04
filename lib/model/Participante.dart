// To parse this JSON data, do
//
//     final participante = participanteFromJson(jsonString);

import 'dart:convert';

List<Participante> participanteFromJson(String str) => List<Participante>.from(json.decode(str).map((x) => Participante.fromJson(x)));

String participanteToJson(List<Participante> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Participante {
  Participante({
    this.id,
  });

  Id id;

  factory Participante.fromJson(Map<String, dynamic> json) => Participante(
    id: Id.fromJson(json["id"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id.toJson(),
  };
}

class Id {
  Id({
    this.nombre,
    this.amo,
  });

  String nombre;
  String amo;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    nombre: json["nombre"],
    amo: json["amo"],
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "amo": amo,
  };
}
