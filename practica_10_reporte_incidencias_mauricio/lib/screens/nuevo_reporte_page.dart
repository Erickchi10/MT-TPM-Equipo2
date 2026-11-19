import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../models/reporte.dart';
import '../services/camara_service.dart';
import '../services/ubicacion_service.dart';
import '../services/reporte_storage_service.dart';
import '../services/notificacion_service.dart';
import '../widgets/campo_formulario.dart';

class NuevoReportePage extends StatefulWidget {
  const NuevoReportePage({super.key});

  @override
  State<NuevoReportePage> createState() => _NuevoReportePageState();
}

class _NuevoReportePageState extends State<NuevoReportePage> {
  final _formKey = GlobalKey<FormState>();

  final CamaraService _camaraService = CamaraService();
  final UbicacionService _ubicacionService = UbicacionService();
  final ReporteStorageService _storageService = ReporteStorageService();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  final List<String> _categorias = [
    'Infraestructura',
    'Alumbrado público',
    'Limpieza',
    'Seguridad',
    'Transporte',
    'Servicios públicos',
    'Otros',
  ];

  String? _categoriaSeleccionada;
  XFile? _imagenSeleccionada;
  Position? _ubicacionActual;

  bool _procesandoImagen = false;
  bool _obteniendoUbicacion = false;
  bool _guardandoReporte = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen(bool usarCamara) async {
    if (_procesandoImagen) return;

    setState(() {
      _procesandoImagen = true;
    });

    try {
      final imagen = usarCamara
          ? await _camaraService.tomarFotografia()
          : await _camaraService.seleccionarGaleria();

      if (!mounted) return;

      if (imagen != null) {
        setState(() {
          _imagenSeleccionada = imagen;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo seleccionar la imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _procesandoImagen = false;
        });
      }
    }
  }

  void _eliminarImagen() {
    setState(() {
      _imagenSeleccionada = null;
    });
  }

  Future<void> _obtenerUbicacion() async {
    setState(() {
      _obteniendoUbicacion = true;
    });

    try {
      final posicion = await _ubicacionService.obtenerUbicacionActual();

      if (!mounted) return;

      setState(() {
        _ubicacionActual = posicion;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ubicación obtenida correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _obteniendoUbicacion = false;
        });
      }
    }
  }

  Future<void> _registrarReporte() async {
    if (!_formKey.currentState!.validate()) return;

    if (_guardandoReporte) return;

    setState(() {
      _guardandoReporte = true;
    });

    try {
      final nuevoReporte = Reporte(
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        categoria: _categoriaSeleccionada!,
        imagenPath: _imagenSeleccionada?.path,
        latitud: _ubicacionActual?.latitude,
        longitud: _ubicacionActual?.longitude,
        fecha: DateTime.now(),
      );

      // Guardar primero el reporte en el almacenamiento local.
      await _storageService.guardarReporte(nuevoReporte);

      // Mostrar la notificación sin afectar el guardado.
      bool notificacionMostrada = true;

      try {
        await NotificacionService.mostrarReporteGuardado(
          tituloReporte: nuevoReporte.titulo,
        );
      } catch (e) {
        notificacionMostrada = false;
        debugPrint('No se pudo mostrar la notificación: $e');
      }

      if (!mounted) return;

      _tituloController.clear();
      _descripcionController.clear();

      setState(() {
        _categoriaSeleccionada = null;
        _imagenSeleccionada = null;
        _ubicacionActual = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            notificacionMostrada
                ? 'Reporte guardado correctamente. Se envió una notificación.'
                : 'Reporte guardado correctamente, pero no se pudo mostrar la notificación.',
          ),
          backgroundColor: notificacionMostrada ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar el reporte: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardandoReporte = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuevo reporte',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registrar incidencia',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Completa los siguientes datos para '
                  'describir la incidencia.',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 25),

                // Campo reutilizable para el título.
                CampoFormulario(
                  etiqueta: 'Título de la incidencia',
                  textoAyuda: 'Ej. Luminaria dañada',
                  controller: _tituloController,
                  icono: Icons.title,
                  longitudMaxima: 60,
                  validador: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el título de la incidencia';
                    }

                    if (value.trim().length < 5) {
                      return 'El título debe tener al menos 5 caracteres';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Campo reutilizable para la descripción.
                CampoFormulario(
                  etiqueta: 'Descripción',
                  textoAyuda: 'Describe detalladamente la incidencia...',
                  controller: _descripcionController,
                  icono: Icons.description_outlined,
                  maxLineas: 5,
                  longitudMaxima: 500,
                  validador: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa una descripción';
                    }

                    if (value.trim().length < 10) {
                      return 'La descripción debe tener al menos 10 caracteres';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                const Text(
                  'Categoría',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _categoriaSeleccionada,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: 'Selecciona una categoría',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _categorias.map((categoria) {
                    return DropdownMenuItem<String>(
                      value: categoria,
                      child: Text(categoria),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoriaSeleccionada = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una categoría';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Fotografía de la incidencia',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      if (_imagenSeleccionada != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagenSeleccionada!.path),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: _eliminarImagen,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Eliminar fotografía'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 55,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Agrega una fotografía como evidencia',
                          style: TextStyle(color: Colors.grey.shade700),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (_procesandoImagen)
                        const CircularProgressIndicator()
                      else
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _seleccionarImagen(true),
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Cámara'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _seleccionarImagen(false),
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Galería'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Ubicación de la incidencia',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue,
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Coordenadas GPS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (_ubicacionActual != null)
                            const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_ubicacionActual != null) ...[
                        Text('Latitud: ${_ubicacionActual!.latitude}'),
                        const SizedBox(height: 6),
                        Text('Longitud: ${_ubicacionActual!.longitude}'),
                        const SizedBox(height: 6),
                        Text(
                          'Precisión: ${_ubicacionActual!.accuracy.toStringAsFixed(1)} metros',
                        ),
                      ] else
                        Text(
                          'Todavía no se ha obtenido la ubicación.',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _obteniendoUbicacion
                              ? null
                              : _obtenerUbicacion,
                          icon: _obteniendoUbicacion
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.my_location),
                          label: Text(
                            _obteniendoUbicacion
                                ? 'Obteniendo ubicación...'
                                : 'Obtener ubicación actual',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: _guardandoReporte ? null : _registrarReporte,
                    icon: _guardandoReporte
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _guardandoReporte
                          ? 'Guardando reporte...'
                          : 'Registrar reporte',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Los campos marcados como obligatorios '
                          'deben completarse correctamente.',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
