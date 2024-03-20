// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ieregistrovisitas/models/modelo_registro.dart';

const String urlbase = 'https://app.iedeoccidente.com';

Future<List<RegistroVisitas>?> getListado(bool? tipo) async {
  late final http.Response response;
  try {
    final url = Uri.parse('$urlbase/getRegistroVisitas.php');
    if (tipo!) {
      response = await http.post(url, body: json.encode({'todos': 'si'}));
    } else {
      response = await http.get(url);
    }
    if (response.statusCode == 200) {
      List<dynamic> result = json.decode(response.body);
      List<RegistroVisitas> registros =
          result.map((l) => RegistroVisitas.fromJson(l)).toList();

      return registros;
    } else {
      throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al obtener el listado: $e');

    return null;
  }
}

Future<void> guardarSalida(String? idVisita) async {
  final url = Uri.parse('$urlbase/guardarRegistroSalida.php');
  final bodyData = json.encode({'id': idVisita});
  try {
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      var respuesta = json.decode(response.body);
      if (respuesta["msg"] == "exito") {
      } else {
        throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } else {
      throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (error) {
    print('Error al guardar la salida: $error');
  }
}
