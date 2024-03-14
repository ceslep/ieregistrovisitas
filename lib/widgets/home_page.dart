// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ieregistrovisitas/models/modelo_registro.dart';
import 'package:ieregistrovisitas/widgets/rol_selector.dart';
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
  bool nombreValido = false;
  bool asuntoValido = false;
  bool guardando = false;
  final TextEditingController _nombresTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _asuntoTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _telefonoTextEditingController =
      TextEditingController(text: '');
  String fecha = DateFormat('yyyy-mm-dd').format(DateTime.now());
  String hora = DateFormat('hh:mm:ss').format(DateTime.now());

  RegistroVisitas registro = RegistroVisitas(
    fecha: "",
    hora: "",
    nombres: "",
    asunto: "",
    telefono: "",
    tipoVisitante: "",
  );
  void onRolSelected(String value) {
    registro.tipoVisitante = value;
    setState(() {});
  }

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
    fToast = FToast();
    fToast.init(context);
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
            "Registro de Visita almacenado correctamente",
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

  _showToastFailed() {
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
            "Debe completar la información",
            style: TextStyle(fontSize: 12, color: Colors.yellow),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              _nombresTextEditingController.text = "";
              _asuntoTextEditingController.text = "";
              _telefonoTextEditingController.text = "";
            },
            icon: const Icon(Icons.note_add_outlined),
          ),
        ],
      ),
      body: Center(
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
                  nombreValido = value.length >= 15;
                  setState(() => registro.nombres = value);
                },
                controller: _nombresTextEditingController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    labelText: 'Nombre del visitante',
                    errorText: !nombreValido
                        ? "Debe ingresar los nombres, mínimo 15 caracteres"
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
                decoration: InputDecoration(
                    labelText: 'Asunto de la visita',
                    errorText: !asuntoValido
                        ? "Debe ingresar el asunto, mínimo 30 caracteres"
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
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (value) => setState(() => registro.telefono = value),
                controller: _telefonoTextEditingController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.number, // Tipo de teclado numérico
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter
                      .digitsOnly, // Permite solo números
                ],
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Tipo de visitante'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: RolSelector(onRolSelected: onRolSelected),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (nombreValido && asuntoValido) {
            _getDate();
            print(registro.toJson());
            await guardar();
            _showToast();
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
}
