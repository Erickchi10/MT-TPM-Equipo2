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
