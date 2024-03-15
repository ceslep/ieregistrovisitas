import 'package:flutter/material.dart';
import 'package:ieregistrovisitas/models/modelo_registro.dart';
import 'package:html_unescape/html_unescape.dart';

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
        ),
        body: ListView.builder(
          itemCount: widget.listadoVisitas.length,
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
                              widget.listadoVisitas[index].nombres,
                            ),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text('Identificación:'),
                            Text(
                              widget.listadoVisitas[index].identificacion,
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
                              widget.listadoVisitas[index].fecha,
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
                              widget.listadoVisitas[index].hora,
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
                            Text(widget.listadoVisitas[index].horaSalida!,
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
