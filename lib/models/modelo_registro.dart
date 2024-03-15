// To parse this JSON data, do
//
//     final registroVisitas = registroVisitasFromJson(jsonString);

import 'dart:convert';

RegistroVisitas registroVisitasFromJson(String str) =>
    RegistroVisitas.fromJson(json.decode(str));

String registroVisitasToJson(RegistroVisitas data) =>
    json.encode(data.toJson());

class RegistroVisitas {
  String? id;
  String fecha;
  String hora;
  String? horaSalida;
  String nombres;
  String asunto;
  String identificacion;
  String tipoVisitante;

  RegistroVisitas({
    this.id,
    required this.fecha,
    required this.hora,
    this.horaSalida,
    required this.nombres,
    required this.asunto,
    required this.identificacion,
    required this.tipoVisitante,
  });

  factory RegistroVisitas.fromJson(Map<String, dynamic> json) =>
      RegistroVisitas(
        id: json["id"],
        fecha: json["fecha"],
        hora: json["hora"],
        horaSalida: json["horaSalida"],
        nombres: json["nombres"],
        asunto: json["asunto"],
        identificacion: json["identificacion"],
        tipoVisitante: json["tipo_visitante"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "hora": hora,
        "horaSalida": horaSalida,
        "nombres": nombres,
        "asunto": asunto,
        "identificacion": identificacion,
        "tipo_visitante": tipoVisitante,
      };
}
