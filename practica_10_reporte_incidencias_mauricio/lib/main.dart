import 'package:flutter/material.dart';

import 'screens/inicio_page.dart';
import 'screens/nuevo_reporte_page.dart';
import 'screens/reportes_page.dart';
import 'screens/servicios_page.dart';
import 'services/notificacion_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificacionService.inicializar();

  runApp(const ReporteIncidenciasApp());
}

class ReporteIncidenciasApp extends StatelessWidget {
  const ReporteIncidenciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reporte de Incidencias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B87)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FA),
          centerTitle: false,
        ),
      ),
      home: const NavegacionPrincipal(),
    );
  }
}

class NavegacionPrincipal extends StatefulWidget {
  const NavegacionPrincipal({super.key});

  @override
  State<NavegacionPrincipal> createState() => _NavegacionPrincipalState();
}

class _NavegacionPrincipalState extends State<NavegacionPrincipal> {
  int indiceSeleccionado = 0;

  void cambiarPantalla(int indice) {
    setState(() {
      indiceSeleccionado = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      InicioPage(onNavigate: cambiarPantalla),
      const NuevoReportePage(),
      ReportesPage(key: ValueKey(indiceSeleccionado == 2)),
      const ServiciosPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: indiceSeleccionado, children: pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indiceSeleccionado,
        onDestinationSelected: cambiarPantalla,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Nuevo',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Reportes',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: 'Servicios',
          ),
        ],
      ),
    );
  }
}
