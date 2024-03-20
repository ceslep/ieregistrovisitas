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
  String dropDownValue = "";
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
    dropDownValue = widget.initialValue;
    super.initState();
    //   dropDownValue = widget.initialValue;
    roles.sort(
      (a, b) => a.compareTo(b),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: DropdownButton<String>(
          autofocus: true,
          alignment: Alignment.centerLeft,
          dropdownColor: const Color.fromARGB(255, 247, 202, 255),
          value: widget.initialValue,
          items: roles.map((String value) {
            return DropdownMenuItem<String>(
              alignment: Alignment.centerLeft,
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() => dropDownValue = newValue!);
            widget.onChanged.call(newValue!);
          },
        ),
      ),
    );
  }
}
