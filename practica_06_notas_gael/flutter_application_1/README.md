# Práctica 06: Persistencia de datos con SQLite

## Descripción del proyecto

Aplicación móvil desarrollada con Flutter y Dart que permite administrar tareas mediante una base de datos local SQLite. La aplicación permite registrar, consultar, editar, completar y eliminar tareas, conservando la información incluso después de cerrar y volver a iniciar la aplicación.

## Objetivo

Implementar persistencia de datos utilizando SQLite en Flutter, mediante operaciones CRUD y migraciones de bases de datos.

## Tecnologías utilizadas

- Flutter
- Dart
- SQLite
- Paquete `sqflite`
- Paquete `path`
- Visual Studio Code

## Funcionalidades

- Registro de tareas con título y descripción.
- Consulta de tareas almacenadas.
- Edición de tareas existentes.
- Cambio del estado de una tarea (pendiente o completada).
- Eliminación de tareas.
- Almacenamiento local mediante SQLite.
- Persistencia de información después de reiniciar la aplicación.
- Migración de la base de datos para agregar el campo `pendiente_sincronizar`.

## Estructura del proyecto

```text
flutter_application_1/
├── lib/
│   └── main.dart
├── test/
│   └── widget_test.dart
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

## Instalación y ejecución

1. Clonar o descargar el repositorio.
2. Abrir la carpeta del proyecto en Visual Studio Code.
3. Instalar las dependencias:

```bash
flutter pub get
```

4. Ejecutar la aplicación:

```bash
flutter run
```

## Verificación del proyecto

Se realizaron las siguientes comprobaciones:

- `dart format lib/main.dart`
- `flutter analyze`
- `flutter test`

También se verificó el funcionamiento de la aplicación al reiniciarla, editar tareas, cambiar su estado y eliminarlas.

## Base de datos y migración

La aplicación utiliza SQLite para almacenar las tareas localmente.

Se incrementó la versión de la base de datos a la versión 2 y se implementó una migración mediante `onUpgrade` para agregar el campo `pendiente_sincronizar`, conservando los registros existentes.

## Evidencias

Las capturas de pantalla del funcionamiento de la aplicación se encuentran en la carpeta de evidencias del proyecto.

## Autor

Gael