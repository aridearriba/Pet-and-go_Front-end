import 'dart:convert';

import 'dart:typed_data';

List<PerreParada> reqResponsePerreParadaFromJson(Uint8List str) => List<PerreParada>.from(json.decode(utf8.decode(str)).map((x) => PerreParada.fromJson(x)));

String reqResponsePerreParadaToJson(List<PerreParada> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PerreParada {
    int id;
    String admin;
    DateTime createdAt;
    DateTime fechaQuedada;
    String lugarInicio;
    double latitud;
    double longitud;
    String idImageGoogle;

    String fotoLugar = "";

    PerreParada({
        this.id,
        this.admin,
        this.createdAt,
        this.fechaQuedada,
        this.lugarInicio,
        this.latitud,
        this.longitud,
        this.idImageGoogle,
    });

    factory PerreParada.fromJson(Map<String, dynamic> json) => PerreParada(
        id: json["id"],
        admin: json["admin"],
        createdAt: DateTime.parse(json["createdAt"]),
        fechaQuedada: DateTime.parse(json["fechaQuedada"]),
        lugarInicio: json["lugarInicio"],
        latitud: json["latitud"],
        longitud: json['longitud'],
        idImageGoogle: json['idImageGoogle']
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "admin": admin,
        "createdAt": createdAt.toIso8601String(),
        "fechaQuedada": fechaQuedada.toIso8601String(),
        "lugarInicio": lugarInicio,
        "latitud": latitud,
        "longitud": longitud,
        "idImageGoogle": idImageGoogle,
    };
}
