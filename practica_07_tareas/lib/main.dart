import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/tareas_provider.dart';
import 'screens/tareas_page.dart';
import 'services/preferencias_service.dart';
import 'services/tarea_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          TareasProvider(TareaServiceSqlite(), PreferenciasService())
            ..iniciar(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tareas',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: const TareasPage(),
      ),
    );
  }
}
