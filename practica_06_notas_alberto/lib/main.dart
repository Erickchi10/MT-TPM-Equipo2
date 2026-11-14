import 'package:flutter/material.dart';

import 'screens/notas_page.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Notas offline',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
    home: const NotasPage(),
  ),
);
