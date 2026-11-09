import '../models/habito.dart';

class HabitoService {
  final List<Habito> _datos = [
    const Habito(id: 1, nombre: 'Tomar agua'),
    const Habito(id: 2, nombre: 'Estudiar 30 minutos'),
    const Habito(id: 3, nombre: 'Caminar'),
  ];
  int _siguienteId = 4;

  Future<List<Habito>> listar() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.of(_datos);
  }

  Future<Habito> crear(String nombre) async {
    final nuevo = Habito(id: _siguienteId++, nombre: nombre);
    _datos.add(nuevo);
    return nuevo;
  }

  Future<void> actualizar(Habito habito) async {
    final i = _datos.indexWhere((x) => x.id == habito.id);
    if (i != -1) _datos[i] = habito;
  }

  Future<void> eliminar(int id) async {
    _datos.removeWhere((x) => x.id == id);
  }
}
