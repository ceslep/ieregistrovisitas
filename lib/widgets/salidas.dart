// ignore_for_file: avoid_print

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:ieregistrovisitas/models/modelo_registro.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ieregistrovisitas/widgets/api.dart';
import 'package:intl/intl.dart';

const String urlbase = 'https://app.iedeoccidente.com';
String decodeHtmlEntities(String text) {
  final unescape = HtmlUnescape();
  return unescape.convert(text);
}

class Salidas extends StatefulWidget {
  final List<RegistroVisitas> listadoVisitas;
  const Salidas({super.key, required this.listadoVisitas});

  @override
  State<Salidas> createState() => _SalidasState();
}

class _SalidasState extends State<Salidas> {
  late FToast fToast;
  bool guardando = false;
  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(
            "Salida Registrada",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Registrar Salidas',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white),
      ),
      body: widget.listadoVisitas.isNotEmpty
          ? ListView.builder(
              itemCount: widget.listadoVisitas.length,
              itemBuilder: (context, index) {
                print(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    decodeHtmlEntities(
                                      widget.listadoVisitas[index].nombres,
                                    ),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    const Text('Identirficación:'),
                                    Text(
                                      widget
                                          .listadoVisitas[index].identificacion,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                        ElevatedButton(
                            style: const ButtonStyle(
                                shape: MaterialStatePropertyAll(CircleBorder(
                                    side: BorderSide(style: BorderStyle.none))),
                                elevation: MaterialStatePropertyAll(10),
                                animationDuration: Duration(milliseconds: 250)),
                            onPressed: () async {
                              widget.listadoVisitas[index].horaSalida =
                                  DateFormat('hh:mm:ss').format(DateTime.now());
                              setState(() {});
                              setState(() => guardando = !guardando);
                              await guardarSalida(
                                  widget.listadoVisitas[index].id);
                              _showToast();
                              setState(() => guardando = !guardando);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            child: widget.listadoVisitas[index].horaSalida ==
                                    '00:00:00'
                                ? const Icon(
                                    Icons.save,
                                    size: 25,
                                  )
                                : const SpinKitCircle(
                                    color: Colors.green,
                                    size: 14,
                                  ))
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
              'No hay registros',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            )),
    );
  }
}
