import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ieregistrovisitas/widgets/rol_selector.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nombresTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _asuntoTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _telefonoTextEditingController =
      TextEditingController(text: '');
  String fecha = DateFormat('yyyy-mm-dd').format(DateTime.now());
  String hora = DateFormat('hh:mm:ss').format(DateTime.now());

  String onRolSelected(String value) {
    return value;
  }

  void _getDate() {
    fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());
    hora = DateFormat('hh:mm:ss').format(DateTime.now());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _getDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.note_add_outlined),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            CachedNetworkImage(
              imageUrl: "https://app.iedeoccidente.com/escudoNuevo2.png",
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Fecha: $fecha'),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Hora: $hora'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nombresTextEditingController,
                textCapitalization: TextCapitalization.characters,
                decoration:
                    const InputDecoration(labelText: 'Nombre del visitante'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 3,
                controller: _asuntoTextEditingController,
                decoration:
                    const InputDecoration(labelText: 'Asunto de la visita'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
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
                padding: EdgeInsets.all(8.0),
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
        onPressed: () {},
        tooltip: 'Guardar Registro de visitas',
        child: const Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
