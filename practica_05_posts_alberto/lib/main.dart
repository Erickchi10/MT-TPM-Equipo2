import 'package:flutter/material.dart';
import 'screens/lista_publicaciones.dart';
import 'services/api_publicaciones.dart';

void main() => runApp(const AppPublicaciones());

class AppPublicaciones extends StatelessWidget {
  const AppPublicaciones({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Publicaciones',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: ListaPublicaciones(api: ApiPublicaciones()),
    );
  }
}
