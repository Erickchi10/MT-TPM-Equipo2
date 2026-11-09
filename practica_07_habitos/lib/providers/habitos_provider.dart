import 'package:flutter/foundation.dart';

import '../models/habito.dart';
import '../services/habito_service.dart';

class HabitosProvider extends ChangeNotifier {
  HabitosProvider(this._servicio);

  final HabitoService _servicio;

  List<Habito> _habitos = [];
  bool _cargando = false;

  List<Habito> get habitos => List.unmodifiable(_habitos);
  bool get cargando => _cargando;
  int get total => _habitos.length;
  int get completados => _habitos.where((h) => h.completado).length;

  Future<void> cargar() async {
    _cargando = true;
    notifyListeners();
    _habitos = await _servicio.listar();
    _cargando = false;
    notifyListeners();
  }

  Future<void> agregar(String nombre) async {
    final texto = nombre.trim();
    if (texto.isEmpty) return;
    final nuevo = await _servicio.crear(texto);
    _habitos = [..._habitos, nuevo];
    notifyListeners();
  }

  Future<void> alternar(Habito habito) async {
    final actualizado = habito.copiarCon(completado: !habito.completado);
    await _servicio.actualizar(actualizado);
    _habitos = [for (final h in _habitos) h.id == habito.id ? actualizado : h];
    notifyListeners();
  }

  Future<void> eliminar(int id) async {
    await _servicio.eliminar(id);
    _habitos = _habitos.where((h) => h.id != id).toList();
    notifyListeners();
  }
}
