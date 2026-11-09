import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/habitos_provider.dart';
import 'screens/habitos_page.dart';
import 'services/habito_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitosProvider(HabitoService())..cargar(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hábitos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: const HabitosPage(),
      ),
    );
  }
}
