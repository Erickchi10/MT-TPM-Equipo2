import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../widgets/materia_card.dart';
import 'detalle_materia_page.dart';

class InicioMateriasPage extends StatelessWidget {
  const InicioMateriasPage({super.key});

      static const materias = [
         Materia('Tópicos de Programación Móvil', 7, 5, 'Desarrollo de apps móviles con Flutter y Dart.'),
         Materia('Programación Web', 5, 5, 'Desarrollo de sitios y aplicaciones web con HTML, CSS y JavaScript.'),
         Materia('Sistemas Programables', 6, 5, 'Implementación de sensores y actuadores con microcontroladores.'),
         Materia('Base de Datos', 4, 5, 'Diseño y administración de bases de datos relacionales.'),
         Materia('Estructura de Datos', 3, 5, 'Organización y manejo eficiente de datos en memoria.'),
         Materia('Ingeniería de Software', 6, 5, 'Metodologías y procesos para el desarrollo de software.'),
      ];

      @override
      Widget build(BuildContext context) => Scaffold(
         appBar: AppBar(title: const Text('Catálogo de Materias')),
         body: ListView(
            padding: const EdgeInsets.all(12),
            children: materias.map((m) => MateriaCard(
              materia: m,
              onTap: () => Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => DetalleMateriaPage(materia: m)),
              ),
            )).toList(),
         ),
      );
}

