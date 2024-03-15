import 'package:flutter/material.dart';

class RolSelector extends StatefulWidget {
  final Function(String) onRolSelected;

  const RolSelector({super.key, required this.onRolSelected});

  @override
  State<RolSelector> createState() => _RolSelectorState();
}

class _RolSelectorState extends State<RolSelector> {
  String selectedRol = '';
  List<String> roles = [
    '',
    'Padre de Familia',
    'Acudiente',
    'Vendedor',
    'Funcionario SED de Caldas',
    'Funcionario Gobernación de Caldas',
    'Funcionario Judicial',
    'Funcionario del gobierno',
    'Funcionario Alcaldía',
    'Docente',
    'Policía',
    'Otro',
    'Estudiante'
  ];

  @override
  void initState() {
    super.initState();
    roles.sort(
      (a, b) => a.compareTo(b),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      alignment: Alignment.centerLeft,
      dropdownColor: const Color.fromARGB(255, 247, 202, 255),
      value: selectedRol,
      items: roles.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedRol = value!;
          widget.onRolSelected(value);
        });
      },
    );
  }
}
