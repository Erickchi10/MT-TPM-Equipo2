import 'package:flutter/material.dart';

import 'screens/lista_tareas.dart';

void main() => runApp(const AppTareas());

class AppTareas extends StatelessWidget {
  const AppTareas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tareas offline',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueGrey),
      home: const ListaTareas(),
    );
  }
}
