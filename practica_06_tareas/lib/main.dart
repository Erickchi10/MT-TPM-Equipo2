import 'package:flutter/material.dart';

import 'screens/tareas_page.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Gestor de tareas offline',
    theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
    home: const TareasPage(),
  ),
);
