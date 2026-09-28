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
