# Práctica 7: Arquitectura Flutter, componentes, paquetes y optimización

**Alumno:** Tommy Gael Can Mut
Instituto Tecnológico Superior de Calkiní · Ingeniería en Sistemas Computacionales
Materia: Tópicos de Programación Móvil · Semestre 7°

## Objetivo
Estructurar una aplicación Flutter escalable, integrar paquetes externos y aplicar prácticas básicas de rendimiento.

## Requisitos
- Flutter SDK (probado con Flutter 3.41.4) y Dart
- Git y cuenta de GitHub
- Chrome o Windows como destino de ejecución

## Instalación
```bash
git clone <URL_DEL_REPOSITORIO>
cd MT-TPM-Equipo2/practica_07_arquitectura_gael
git checkout practica-07-arquitectura-gael
flutter pub get
```

## Ejecución
```bash
flutter run -d chrome
```

## Pruebas y análisis
```bash
dart format .
flutter analyze
flutter test
```

## Estructura del proyecto
```
lib/
  main.dart        # Registra los providers (MultiProvider)
  models/          # Tarea
  services/        # TareasService (acceso a datos)
  providers/       # ContadorProvider, TareasProvider (estado)
  screens/         # HomeScreen, ContadorScreen
  widgets/         # EncabezadoSeccion, BotonAccion, TarjetaTarea, DialogoNuevaTarea
test/              # Prueba de widget
docs/              # Informe de la práctica
```

## Paquetes externos
| Paquete | Justificación |
|---|---|
| provider | Administración de estado simple; separa el estado de la interfaz. |
| intl | Formato de fechas de las tareas sin código manual propenso a errores. |

## Participantes
- Tommy Gael Can Mut