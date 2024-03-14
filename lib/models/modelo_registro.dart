// To parse this JSON data, do
//
//     final registroVisitas = registroVisitasFromJson(jsonString);

import 'dart:convert';

RegistroVisitas registroVisitasFromJson(String str) =>
    RegistroVisitas.fromJson(json.decode(str));

String registroVisitasToJson(RegistroVisitas data) =>
    json.encode(data.toJson());

class RegistroVisitas {
  String fecha;
  String hora;
  String nombres;
  String asunto;
  String telefono;
  String tipoVisitante;

  RegistroVisitas({
    required this.fecha,
    required this.hora,
    required this.nombres,
    required this.asunto,
    required this.telefono,
    required this.tipoVisitante,
  });

  factory RegistroVisitas.fromJson(Map<String, dynamic> json) =>
      RegistroVisitas(
        fecha: json["fecha"],
        hora: json["hora"],
        nombres: json["nombres"],
        asunto: json["asunto"],
        telefono: json["telefono"],
        tipoVisitante: json["tipo_visitante"],
      );

  Map<String, dynamic> toJson() => {
        "fecha": fecha,
        "hora": hora,
        "nombres": nombres,
        "asunto": asunto,
        "telefono": telefono,
        "tipo_visitante": tipoVisitante,
      };
}
