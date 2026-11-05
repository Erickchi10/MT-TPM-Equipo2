import 'package:flutter/material.dart';

import 'screens/notas_page.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Notas offline',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const NotasPage(),
  ),
);
