import 'package:flutter/material.dart';

class RolSelector extends StatefulWidget {
  final String initialValue;
  final void Function(String) onChanged;

  const RolSelector(
      {super.key, required this.onChanged, required this.initialValue});

  @override
  State<RolSelector> createState() => _RolSelectorState();
}

class _RolSelectorState extends State<RolSelector> {
  late String dropDownValue;
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
    dropDownValue = widget.initialValue;
    roles.sort(
      (a, b) => a.compareTo(b),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      alignment: Alignment.centerLeft,
      dropdownColor: const Color.fromARGB(255, 247, 202, 255),
      value: dropDownValue,
      items: roles.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() => dropDownValue = newValue!);
        widget.onChanged.call(newValue!);
      },
    );
  }
}
