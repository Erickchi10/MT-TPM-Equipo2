## Práctica 7 - Arquitectura Flutter, componentes, paquetes y optimización

### Objetivo
Estructurar una aplicación Flutter escalable separando interfaz, estado, servicios y modelos, integrar paquetes externos y aplicar prácticas básicas de rendimiento.

### Requisitos
- Flutter 3.47.2 (stable) y Dart 3.13.2
- Visual Studio Code
- Emulador Android (Medium_Phone) y Chrome
- Paquetes: provider, sqflite, shared_preferences, path, intl

### Instalación
cd practica_07_habitos
flutter pub get
cd ../practica_07_tareas
flutter pub get

### Ejecución
cd practica_07_habitos
flutter run -d chrome

cd practica_07_tareas
flutter run -d emulator-5554
practica_07_tareas usa sqflite, por lo que se ejecuta en el emulador Android y no en Chrome.

### Proyectos incluidos
- *practica_07_habitos* (ejemplo guiado): lista de hábitos con Provider. Carpetas models, services, providers, screens y widgets. Probado en Chrome y en el emulador.
- *practica_07_tareas* (ejercicio evaluable): refactorización de la práctica 6. Interfaz TareaService con implementación SQLite, PreferenciasService para el filtro, TareasProvider para el estado y 4 widgets reutilizables. Se agregó intl para dar formato a la fecha de creación.

### Estructura
text
lib/
  models/      Datos (Tarea)
  services/    SQLite y SharedPreferences
  providers/   Estado con ChangeNotifier
  screens/     Pantallas
  widgets/     Componentes reutilizables

### Pruebas
- flutter analyze: sin problemas en los dos proyectos.
- flutter test: 5 pruebas en practica_07_habitos y 6 en practica_07_tareas, usando un servicio falso en memoria.
- Pruebas manuales en Chrome (hábitos) y en el emulador Android (hábitos y tareas): agregar, editar, completar, eliminar, validaciones y filtros.

### Comparación Flutter y solución nativa hipotética
| Aspecto | Flutter | Nativo (hipotético) |
|---|---|---|
| Tiempo de desarrollo | Un solo código para varias plataformas | Un desarrollo por plataforma |
| Portabilidad | Android, iOS, web y escritorio | Una plataforma por proyecto |
| Desempeño percibido | Fluido en las pruebas realizadas | Mayor control en casos exigentes |

### Evidencias
Capturas en docs/evidencias/practica-07/.

### Participantes
- Mauricio Gabriel Cih Koh