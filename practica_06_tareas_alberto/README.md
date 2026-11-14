# Práctica 6 — Persistencia Local y Funcionamiento Offline

**Alumno:** Alberto Sánchez Ucan
**Materia:** Tópicos de Programación Móvil — ITESCAM
**Rama:** `practica-06-alberto`

## Objetivo
Implementar almacenamiento local con SharedPreferences y SQLite para conservar preferencias y registros cuando no exista conexión a Internet.

## Requisitos
- Flutter SDK 3.x y Dart 3.x
- Paquetes `shared_preferences`, `sqflite` y `path`
- Emulador Android o celular Android (sqflite no funciona en Chrome)

## Instalación y ejecución
```bash
cd practica_06_tareas_alberto
flutter pub get
flutter run
```

## Proyectos incluidos
- **practica_06_notas_alberto** — Ejemplo guiado: CRUD de notas con SQLite, nombre del usuario con SharedPreferences, edición, eliminación con confirmación y marca de pendiente de sincronizar.
- **practica_06_tareas_alberto** — Ejercicio evaluable: gestor offline de tareas con prioridad, completadas, formulario con validación, eliminación deslizando y preferencias de orden y de mostrar/ocultar completadas.

## Estructura del ejercicio evaluable
```
lib/
├── models/tarea.dart            # Modelo, toMap/fromMap y validación
├── models/orden.dart            # Filtro y orden según preferencias
├── data/tareas_db.dart          # SQLite: insertar, listar, actualizar, eliminar
├── data/preferencias.dart       # SharedPreferences: orden y completadas
├── widgets/tarea_item.dart      # Tarjeta reutilizable
├── screens/form_tarea.dart      # Formulario de crear/editar
├── screens/lista_tareas.dart    # Lista principal
└── main.dart
```

## Tabla SQLite `tareas`
| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER PK | Identificador autoincremental |
| titulo | TEXT | Título obligatorio (3 a 60 caracteres) |
| descripcion | TEXT | Descripción opcional |
| prioridad | INTEGER | 0 alta, 1 media, 2 baja |
| completada | INTEGER | 0 pendiente, 1 completada |
| creada | INTEGER | Fecha de creación (milisegundos) |
| pendiente_sincronizar | INTEGER | 1 si el cambio aún no se envía al servidor |

## Pruebas realizadas
- `flutter analyze`: No issues found! (ambos proyectos)
- `flutter test`: 2 pruebas (notas) y 8 pruebas (tareas).
- Manuales en emulador Android (Pixel_Ligero, API 34): crear, validar, editar, completar, eliminar con confirmación, cambiar orden, ocultar completadas y persistencia al cerrar y abrir la app.

## Evidencias
`docs/evidencias/practica-06-alberto/`

