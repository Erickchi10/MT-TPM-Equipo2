# MT-TPM-Equipo2

Proyecto integrador de la materia Tópicos de Programación Móvil (ITESCAM) — prácticas de Flutter/Dart, manual MP-TPM-2026.

## Participantes

- Erick Chi

## Práctica 2 — Fundamentos de Dart, Widgets y Estado

### Objetivo
Aplicar variables, funciones, conversión de tipos y manejo de estado para construir aplicaciones móviles sencillas con Flutter.

### Requisitos
- Flutter SDK y Dart SDK
- Visual Studio Code con extensión Flutter
- Google Chrome (para ejecutar en modo web)

### Instalación
1. Clonar este repositorio.
2. Entrar a la carpeta del proyecto que se quiera ejecutar (`practica_02_propina` o `practica_02_combustible`).
3. Ejecutar `flutter pub get` para instalar las dependencias.

### Ejecución
Dentro de la carpeta del proyecto, ejecutar:

    flutter run -d chrome

### Proyectos incluidos

- **practica_02_propina**: ejemplo guiado del manual, calculadora de propina (consumo, porcentaje con Slider, cálculo de propina y total).
- **practica_02_combustible**: ejercicio evaluable, calculadora de rendimiento de combustible (km/L), con validación de entradas, botón de limpiar y clasificación en tres niveles (Bajo, Medio, Alto).

## Práctica 3 — Formularios, Validación, Listas y Diseño Responsivo

### Objetivo
Construir un formulario validado, manejar eventos y mostrar registros en una lista adaptable a distintos tamaños de pantalla.

### Proyectos incluidos
- **practica_03_registro**: ejemplo guiado del manual, formulario de registro de estudiantes (nombre, correo, semestre) con validación, `ListView` de estudiantes registrados con opción de eliminar, y diseño responsivo (ancho máximo de 600px en pantallas grandes).
- **practica_03_productos**: ejercicio evaluable, formulario de registro de productos (nombre, categoría, precio, existencia) con validación de datos, `ListView` de productos, eliminación y cálculo del valor total del inventario.

## Práctica 4 — Navegación, Rutas y Componentes Reutilizables

### Objetivo
Organizar una aplicación en múltiples archivos (models, screens, widgets), crear componentes reutilizables y navegar entre pantallas pasando datos.

### Requisitos
- Flutter y Visual Studio Code
- Git y GitHub

### Instalación
1. Clonar el repositorio
2. Entrar a la carpeta del proyecto deseado (`practica_04_catalogo` o `practica_04_materias`)
3. Ejecutar `flutter pub get`

### Ejecución

flutter run -d chrome

### Proyectos incluidos
- **practica_04_catalogo**: ejemplo guiado. Catálogo de productos con navegación de lista a detalle, usando el modelo `Producto` y el widget reutilizable `ProductoCard`.
- **practica_04_materias**: ejercicio evaluable. Catálogo de 6 materias con navegación a pantalla de detalle (nombre, semestre, créditos y descripción), usando el modelo `Materia` y el widget reutilizable `MateriaCard`.

### Participantes
Erick Chi


## Práctica 5 — Consumo de API REST y Procesamiento JSON

### Objetivo
Consumir un servicio REST mediante HTTP, convertir JSON a objetos Dart y representar estados de carga, éxito y error.

### Requisitos
- Flutter y Visual Studio Code
- Git y GitHub
- Conexión a Internet
- Paquete `http`

### Instalación
1. Clonar el repositorio
2. Entrar a la carpeta del proyecto deseado (`practica_05_api` o `practica_05_posts`)
3. Ejecutar `flutter pub get`

### Ejecución

flutter run -d chrome

También se puede ejecutar en el emulador de Android con `flutter run -d emulator-5554`.

### API utilizada
- Servicio: JSONPlaceholder (https://jsonplaceholder.typicode.com)
- Método: GET
- Endpoints: `/users` (ejemplo guiado) y `/posts` (ejercicio evaluable)
- Respuesta: JSON, con validación del código de estado 200

### Proyectos incluidos
- **practica_05_api**: ejemplo guiado. Lista de usuarios obtenida de la API con `http`, modelo `Usuario` con `fromJson`, `FutureBuilder` para los estados de carga, error, éxito y lista vacía, y `RefreshIndicator` para actualizar.
- **practica_05_posts**: ejercicio evaluable. Lista de las 100 publicaciones del endpoint `/posts` (título y cuerpo), con indicador de carga, manejo de error con botón Reintentar, actualización con `RefreshIndicator` y pantalla de detalle al tocar una publicación. Organizado en `models`, `services` y `screens`.

### Pruebas realizadas
- `flutter analyze`: sin problemas en ambos proyectos
- `flutter test`: 2 pruebas en `practica_05_api` y 6 en `practica_05_posts`, todas aprobadas
- Pruebas manuales en Chrome y en el emulador de Android (lista, detalle, error HTTP 404 y actualización)
- Capturas en `docs/evidencias/practica-05/`

### Participantes
Erick Chi

## Práctica 6 - Persistencia local y funcionamiento offline

### Objetivo
Persistir preferencias simples y registros estructurados en almacenamiento local, implementando operaciones CRUD y una estrategia básica offline.

### Requisitos
- Flutter 3.47.2 y Dart 3.13.2
- Paquetes: `sqflite`, `shared_preferences` y `path`
- Emulador Android (`sqflite` no funciona en Chrome)
- Modo de desarrollador de Windows activado (necesario para compilar plugins)

### Instalación
1. Clonar el repositorio y cambiar a la rama `practica-06-persistencia`.
2. Entrar a `practica_06_notas` o `practica_06_tareas`.
3. Ejecutar `flutter pub get`.

### Ejecución
Con el emulador encendido: `flutter run -d emulator-5554`

### Proyectos incluidos
- `practica_06_notas` (ejemplo guiado): notas con SQLite (crear, listar, editar y eliminar con confirmación), nombre de usuario con SharedPreferences y bandera `pendiente_sincronizar`.
- `practica_06_tareas` (ejercicio evaluable): gestor offline de tareas con SQLite (crear, consultar, editar, eliminar y marcar completada), filtro Todas/Pendientes/Completadas guardado con SharedPreferences y validaciones (vacío, mínimo 3 y máximo 60 caracteres, sin repetidas).

### Pruebas
- `flutter analyze`: sin problemas en ambos proyectos.
- `flutter test`: 3 pruebas en `practica_06_notas` y 5 en `practica_06_tareas`, todas aprobadas.
- Manuales en emulador Android: CRUD, datos conservados al reiniciar, preferencia conservada y funcionamiento en modo avión.

### Evidencias
Capturas en `docs/evidencias/practica-06/`.

### Participantes
- Erick de los Ángeles Chi Calan


## Práctica 7 - Arquitectura Flutter, componentes, paquetes y optimización

### Objetivo
Estructurar una aplicación Flutter escalable separando interfaz, estado, servicios y modelos, integrar paquetes externos y aplicar prácticas básicas de rendimiento.

### Requisitos
- Flutter 3.47.2 (stable) y Dart 3.13.2
- Visual Studio Code
- Emulador Android (Medium_Phone) y Chrome
- Paquetes: `provider`, `sqflite`, `shared_preferences`, `path`, `intl`

### Instalación
```bash
cd practica_07_habitos
flutter pub get
cd ../practica_07_tareas
flutter pub get
```

### Ejecución
```bash
cd practica_07_habitos
flutter run -d chrome

cd practica_07_tareas
flutter run -d emulator-5554
```
`practica_07_tareas` usa `sqflite`, por lo que se ejecuta en el emulador Android y no en Chrome.

### Proyectos incluidos
- **practica_07_habitos** (ejemplo guiado): lista de hábitos con `Provider`. Carpetas `models`, `services`, `providers`, `screens` y `widgets`. Probado en Chrome y en el emulador.
- **practica_07_tareas** (ejercicio evaluable): refactorización de la práctica 6. Interfaz `TareaService` con implementación SQLite, `PreferenciasService` para el filtro, `TareasProvider` para el estado y 4 widgets reutilizables. Se agregó `intl` para dar formato a la fecha de creación.

### Estructura
```text
lib/
  models/      Datos (Tarea)
  services/    SQLite y SharedPreferences
  providers/   Estado con ChangeNotifier
  screens/     Pantallas
  widgets/     Componentes reutilizables
```

### Pruebas
- `flutter analyze`: sin problemas en los dos proyectos.
- `flutter test`: 5 pruebas en `practica_07_habitos` y 6 en `practica_07_tareas`, usando un servicio falso en memoria.
- Pruebas manuales en Chrome (hábitos) y en el emulador Android (hábitos y tareas): agregar, editar, completar, eliminar, validaciones y filtros.

### Comparación Flutter y solución nativa hipotética
| Aspecto | Flutter | Nativo (hipotético) |
|---|---|---|
| Tiempo de desarrollo | Un solo código para varias plataformas | Un desarrollo por plataforma |
| Portabilidad | Android, iOS, web y escritorio | Una plataforma por proyecto |
| Desempeño percibido | Fluido en las pruebas realizadas | Mayor control en casos exigentes |

### Evidencias
Capturas en `docs/evidencias/practica-07/`.

### Participantes
- Erick de los Ángeles Chi Calan

## Práctica 8: GPS, geolocalización y mapas

**Rama:** `practica-08-geolocalizacion`

### Objetivo
Solicitar permisos de ubicación, obtener las coordenadas del dispositivo, calcular distancias y abrir un mapa externo.

### Proyectos
- `practica_08_ubicacion`: ejemplo guiado. Pide el permiso en tiempo de ejecución, muestra latitud, longitud y precisión, calcula la distancia a un punto de referencia (Calkiní, Campeche) y abre el mapa.
- `practica_08_puntos`: ejercicio evaluable. App de puntos de interés: guarda ubicaciones con nombre (se conservan al cerrar la app con `shared_preferences`), muestra latitud y longitud de cada una, calcula la distancia desde la posición actual con `Geolocator.distanceBetween` y abre cada punto en un mapa externo.

### Requisitos
- Flutter 3.47.2 (stable) y Dart 3.13.2
- Emulador Android o dispositivo físico con ubicación activa
- Paquetes: `geolocator` 14.1.2, `url_launcher` 6.3.3 y `shared_preferences` 2.5.6 (solo en `practica_08_puntos`)
- Permisos `ACCESS_FINE_LOCATION` y `ACCESS_COARSE_LOCATION` en `AndroidManifest.xml`, y consultas `https` y `geo` para abrir el mapa

### Instalación y ejecución
```bash
cd practica_08_puntos
flutter pub get
flutter run -d <id-del-dispositivo>
```
Lo mismo aplica para `practica_08_ubicacion`. En el emulador, la ubicación se cambia desde *Extended controls > Location*.

### Pruebas
```bash
flutter analyze
flutter test
```
Resultado: `flutter analyze` sin problemas en los dos proyectos y `flutter test` con 7 pruebas aprobadas en `practica_08_puntos`. Las pruebas manuales (permisos, GPS apagado, guardado de 3 puntos, distancias, mapa y persistencia) están en `docs/evidencias/practica-08/`.

### Participantes
- Erick de los Ángeles Chi Calan

## Práctica 9: Cámara, multimedia y sensores de movimiento

**Objetivo:** integrar captura de imágenes y lectura de sensores para crear interacción con el hardware del dispositivo.

### Contenido

- `practica_09_sensores`: ejemplo guiado. Toma una foto con `image_picker` y muestra en vivo el acelerómetro y el giroscopio (X, Y, Z) con `sensors_plus`.
- `practica_09_bitacora`: ejercicio evaluable. Bitácora de inspección: cada entrada es una tarjeta de evidencia con foto, fecha, hora y los valores del acelerómetro y del giroscopio. Maneja cancelación de la cámara y permisos denegados, y guarda las inspecciones aunque se cierre la app.

### Requisitos

- Flutter 3.47.2 (canal stable) y Dart 3.13.2.
- Dispositivo Android físico (recomendado) o emulador con cámara y sensores virtuales.
- Paquetes: `image_picker` 1.2.4 y `sensors_plus` 7.1.1 (en la bitácora también `path_provider` y `shared_preferences`).
- Permiso `CAMERA` declarado en `android/app/src/main/AndroidManifest.xml`. El acelerómetro y el giroscopio no necesitan permiso.

### Instalación y ejecución

```bash
cd practica_09_bitacora
flutter pub get
flutter run -d <id-del-dispositivo>
```

Para el ejemplo guiado se hace lo mismo dentro de `practica_09_sensores`. Los ids de los dispositivos se ven con `flutter devices`.

### Pruebas

```bash
flutter analyze
flutter test
```

- `practica_09_sensores`: `flutter analyze` sin problemas (sin pruebas propias).
- `practica_09_bitacora`: `flutter analyze` sin problemas y 11 pruebas automáticas que pasan (formato de fecha y hora, lecturas de sensores, guardado y carga de inspecciones, datos dañados y captura cancelada).
- Casos manuales: permiso de cámara, foto tomada, cancelación, permiso denegado, lectura de acelerómetro, lectura de giroscopio, y que las inspecciones se conserven al cerrar y volver a abrir la app. Las capturas están en `docs/evidencias/practica-09/`.

### Dispositivos de prueba y limitaciones

- Cámara, permisos y acelerómetro: Huawei Y6p (MED-LX9) físico.
- Ese celular no tiene giroscopio, por lo que la app muestra "No disponible" sin cerrarse. El giroscopio se probó en el emulador Android (`Medium_Phone`) con *Extended controls > Virtual sensors*.
- El reloj del emulador va en UTC, por lo que la hora de sus tarjetas difiere de la local.

### Participantes

- Erick de los Ángeles Chi Calan

