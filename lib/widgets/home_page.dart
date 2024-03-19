// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ieregistrovisitas/models/modelo_registro.dart';
import 'package:ieregistrovisitas/widgets/get_listado.dart';
import 'package:ieregistrovisitas/widgets/listado.dart';
import 'package:ieregistrovisitas/widgets/rol_selector.dart';
import 'package:ieregistrovisitas/widgets/salidas.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

const String urlbase = 'https://app.iedeoccidente.com';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FToast fToast;
  late FToast fToast2;
  bool nombreValido = false;
  bool asuntoValido = false;
  bool identificacionValida = false;
  bool guardando = false;
  bool listando = false;
  bool alistando = false;
  bool tipoVisitante = false;
  String selectedRol = "";
  final int caracteresIdentificacion = 5;
  final int caracteresNombres = 20;
  final int caracteresAsunto = 30;
  final TextEditingController _nombresTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _asuntoTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _identificacionTextEditingController =
      TextEditingController(text: '');
  String fecha = DateFormat('yyyy-mm-dd').format(DateTime.now());
  String hora = DateFormat('hh:mm:ss').format(DateTime.now());
  List<RegistroVisitas> listadoVisitas = [];

  RegistroVisitas registro = RegistroVisitas(
    fecha: "",
    hora: "",
    nombres: "",
    asunto: "",
    identificacion: "",
    tipoVisitante: "",
  );

  void _getDate() {
    fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());
    hora = DateFormat('hh:mm:ss').format(DateTime.now());
    registro.fecha = fecha;
    registro.hora = hora;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _getDate();
    });
  }

  Future<void> guardar() async {
    guardando = true;
    setState(() {});
    final url = Uri.parse('$urlbase/guardarRegistroVisita.php');
    print({"url": url});
    final bodyData = json.encode(registro.toJson());

    print({"bodyData": bodyData});

    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == "exito") {}
      guardando = false;
      setState(() {});
    }
    guardando = false;
    setState(() {});
  }

  _showToast() {
    fToast = FToast();
    fToast.init(context);
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
            "Registrado",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  _showToastFailed() {
    fToast2 = FToast();
    fToast2.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.dangerous,
            color: Colors.yellowAccent,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            "Complete la información",
            style: TextStyle(fontSize: 12, color: Colors.yellow),
          ),
        ],
      ),
    );

    fToast2.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.purple,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              formReset();
            },
            icon: const Icon(
              Icons.note_add_outlined,
              color: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                refrescarListado(context);
              },
              icon: !alistando
                  ? const Icon(Icons.list)
                  : const SpinKitFadingGrid(
                      color: Colors.lightBlueAccent,
                      size: 18,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                setState(() => listando = !listando);
                getListado(false).then((value) async {
                  listadoVisitas = value!;
                  setState(() => listando = !listando);
                  for (var element in listadoVisitas) {
                    print(element.identificacion);
                  }
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Salidas(listadoVisitas: listadoVisitas),
                    ),
                  );
                  print(result);
                });
              },
              icon: !listando
                  ? const Icon(
                      Icons.outbond,
                      color: Colors.blue,
                    )
                  : const SpinKitCircle(color: Colors.black, size: 15),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              CachedNetworkImage(
                imageUrl: "https://app.iedeoccidente.com/escudoNuevo2.png",
              ),
              const SizedBox(height: 1),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Fecha: $fecha'),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Hora: $hora'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                    onChanged: (value) {
                      identificacionValida = value.length >= 5;
                      setState(() => registro.identificacion = value);
                    },
                    controller: _identificacionTextEditingController,
                    keyboardType:
                        TextInputType.number, // Tipo de teclado numérico
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // Permite solo números
                    ],
                    decoration: InputDecoration(
                      labelText: 'Identificación',
                      errorText: !identificacionValida
                          ? "la Identificación mínimo,  $caracteresIdentificacion caracteres"
                          : "",
                      errorBorder: OutlineInputBorder(
                        borderSide: !identificacionValida
                            ? const BorderSide(color: Colors.red)
                            : const BorderSide(color: Colors.black),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: (value) {
                    nombreValido = value.length >= 15;
                    setState(() => registro.nombres = value);
                  },
                  controller: _nombresTextEditingController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      labelText: 'Nombre del visitante',
                      errorText: !nombreValido
                          ? "Debe ingresar los nombres, Faltan ${caracteresNombres - _nombresTextEditingController.text.length} caracteres"
                          : "",
                      errorBorder: OutlineInputBorder(
                        borderSide: !nombreValido
                            ? const BorderSide(color: Colors.red)
                            : const BorderSide(color: Colors.black),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: (value) {
                    asuntoValido = value.length >= 30;
                    setState(() => registro.asunto = value);
                  },
                  maxLines: 2,
                  controller: _asuntoTextEditingController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      labelText: 'Asunto de la visita',
                      labelStyle: TextStyle(
                          color: !asuntoValido ? Colors.red : Colors.black),
                      errorText: !asuntoValido
                          ? "Debe ingresar el asunto, ${caracteresAsunto - _asuntoTextEditingController.text.length} caracteres"
                          : "",
                      errorBorder: OutlineInputBorder(
                        borderSide: !asuntoValido
                            ? const BorderSide(color: Colors.red)
                            : const BorderSide(color: Colors.black),
                      )),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Tipo de visitante'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RolSelector(
                      initialValue: selectedRol,
                      onChanged: (newValue) {
                        print({"nv": newValue});
                        tipoVisitante = true;
                        registro.tipoVisitante = newValue;

                        setState(() => selectedRol = newValue);

                        print({"sr": selectedRol});
                      }),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(side: BorderSide(style: BorderStyle.none)),
        backgroundColor: const Color.fromARGB(255, 180, 123, 191),
        onPressed: () async {
          if (nombreValido && asuntoValido && tipoVisitante) {
            _getDate();
            print(registro.toJson());
            await guardar();
            _showToast();
            formReset();
          } else {
            _showToastFailed();
          }
        },
        tooltip: 'Guardar Registro de visitas',
        child: !guardando
            ? const Icon(Icons.save)
            : const SpinKitCircle(
                color: Colors.black,
                size: 20,
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void formReset() {
    _nombresTextEditingController.text = "";
    _asuntoTextEditingController.text = "";
    _identificacionTextEditingController.text = "";
    tipoVisitante = false;
    identificacionValida = false;
    nombreValido = false;
    asuntoValido = false;
    registro = RegistroVisitas(
      fecha: "",
      hora: "",
      nombres: "",
      asunto: "",
      identificacion: "",
      tipoVisitante: "",
    );
    print({"frs": selectedRol});
    setState(() => selectedRol = '');
  }

  void refrescarListado(BuildContext context) {
    setState(() => alistando = !alistando);
    getListado(true).then((value) async {
      listadoVisitas = value!;
      setState(() => alistando = !alistando);
      for (var element in listadoVisitas) {
        print(element.identificacion);
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Listado(listadoVisitas: listadoVisitas),
        ),
      );
    });
  }
}
