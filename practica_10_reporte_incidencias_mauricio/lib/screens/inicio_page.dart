import 'package:flutter/material.dart';

class InicioPage extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const InicioPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reporte de Incidencias',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_city, color: Colors.white, size: 42),
                    SizedBox(height: 16),
                    Text(
                      'Bienvenido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Registra y consulta incidencias '
                      'de manera sencilla desde tu dispositivo.',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Accesos rápidos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _AccesoCard(
                icon: Icons.add_a_photo_outlined,
                titulo: 'Crear reporte',
                descripcion: 'Registrar una nueva incidencia',
                onTap: () => onNavigate(1),
              ),
              _AccesoCard(
                icon: Icons.assignment_outlined,
                titulo: 'Mis reportes',
                descripcion: 'Consultar reportes registrados',
                onTap: () => onNavigate(2),
              ),
              _AccesoCard(
                icon: Icons.cloud_sync_outlined,
                titulo: 'Servicios y API',
                descripcion: 'Consultar información de servicios',
                onTap: () => onNavigate(3),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Los reportes podrán consultarse '
                        'incluso sin conexión a Internet.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccesoCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descripcion;
  final VoidCallback onTap;

  const _AccesoCard({
    required this.icon,
    required this.titulo,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(descripcion),
        trailing: const Icon(Icons.arrow_forward_ios, size: 17),
        onTap: onTap,
      ),
    );
  }
}
