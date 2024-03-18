// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ieregistrovisitas/models/modelo_registro.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:ieregistrovisitas/widgets/get_listado.dart';

String decodeHtmlEntities(String text) {
  final unescape = HtmlUnescape();
  return unescape.convert(text);
}

class Listado extends StatefulWidget {
  final List<RegistroVisitas> listadoVisitas;
  const Listado({super.key, required this.listadoVisitas});

  @override
  State<Listado> createState() => _ListadoState();
}

class _ListadoState extends State<Listado> {
  late List<RegistroVisitas> _listadoVisitas;
  bool _refrescando = false;

  @override
  void initState() {
    super.initState();
    _listadoVisitas = widget.listadoVisitas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lista de registros',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                'Ultimos 50',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            !_refrescando
                ? IconButton(
                    onPressed: () async {
                      _listadoVisitas = [];
                      setState(() => _refrescando = !_refrescando);
                      try {
                        _listadoVisitas =
                            await getListado(true) as List<RegistroVisitas>;
                      } catch (e) {
                        print(e);
                      }

                      setState(() => _refrescando = !_refrescando);
                    },
                    icon: const Icon(Icons.refresh),
                    color: Colors.white,
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SpinKitCircle(
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
          ],
        ),
        body: ListView.builder(
          itemCount: _listadoVisitas.length,
          itemBuilder: (context, index) => Card(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            decodeHtmlEntities(
                              _listadoVisitas[index].nombres,
                            ),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            decodeHtmlEntities(
                              _listadoVisitas[index].tipoVisitante,
                            ),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          decodeHtmlEntities(
                            _listadoVisitas[index].asunto,
                          ),
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text('Identificación:'),
                            Text(
                              _listadoVisitas[index].identificacion,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text('Fecha de Entrada:'),
                            Text(
                              _listadoVisitas[index].fecha,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text('Hora de Entrada:'),
                            Text(
                              _listadoVisitas[index].hora,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text('Hora de Salida:'),
                            Text(_listadoVisitas[index].horaSalida!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      widget.listadoVisitas[index].horaSalida ==
                                              "00:00:00"
                                          ? Colors.redAccent
                                          : Colors.green,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                ),
              ],
            ),
          ),
        ));
  }
}
