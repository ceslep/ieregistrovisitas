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
