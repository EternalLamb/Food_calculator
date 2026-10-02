# Food Calculator — Gestor de Alimentación Estudiantil

**Asignatura:** Programación de Dispositivos Móviles   
**Estudiante** Benjamin Llauca  

---

## 1. Definición del Producto y Paradigma Mobile First

### Contexto y Problema

Los estudiantes de educacion superior, tienden a independizarse cuando estos se mudan de su pais o region de origen a arrendar a una casa en una ciudad ajena a la suya, apareciendo como desafios como el orden, organización y porsupuesto, el manejo de presupuesto para sobrellevar la vida de manera equilibrada y segura con un sueldo o beca fijos durante un mes.

El tema de decidir que comprar, donde comprarlo cada 30 dias se hace complejo al no saber los precios de los productos con un presuspuesto acortado que debe abordar tanto el tema de la presentacion personal y mantener una alimentacion equilibrada. Este ultimo es el problema que buscamos resolver con el producto desarrollado.

### Solución Propuesta
**Food Calculator** es una maqueta funcional interactiva en Flutter que optimiza el proceso de compra de alimentos. La aplicación permite ingresar un presupuesto mensual en pesos chilenos (CLP) y ofrece dos flujos de trabajo:
1. **Canasta Inteligente Automática:** Distribución porcentual según prioridades nutricionales (Abarrotes, Proteínas, Lácteos, Frutas/Verduras, Panadería y Limpieza).
2. **Digitalización e Inserción In-Situ:** Captura de nuevos insumos mediante la cámara nativa del dispositivo para incorporarlos al catálogo disponible en tiempo real.

### Justificación de la Arquitectura Mobile First
La propuesta responde estrictamente al entorno móvil por los siguientes factores de ingeniería y contexto de uso:
* **Uso In-Situ y Captura por Hardware:** Incorporación de la cámara nativa del teléfono (`image_picker`) para tomar fotografías o simular la lectura de productos directamente en los pasillos del supermercado. Un software de escritorio no acompaña al usuario en el punto de compra.
* **Operación a Una Sola Mano (Ergonomía Táctil):** Interfaz adaptada con micro-interacciones (+ / -) y modal flotante para operar con soltura mientras se desplaza el carro de compras.
* **Rendimiento Offline y Almacenamiento Local:** Carga mixta de recursos localizados (`assets/images/`) y archivos locales (`Image.file`), asegurando que la calculadora mantenga su reactividad dentro de supermercados con mala cobertura de red.

---

## 2. Especificación de Requerimientos

### Historias de Usuario (Formatos Ágiles)
* **Usuario 1:** *Como estudiante universitario*, quiero ingresar mi presupuesto inicial en CLP, *para* calcular y visualizar mi capacidad de compra mensual.
* **Usuario 2:** *Como estudiante*, quiero generar una canasta balanceada de forma automática, *para* reducir el tiempo de decisión y asegurar alimentos básicos.
* **HU04:** *Como usuario en el punto de compra*, quiero capturar la foto y datos de un nuevo producto usando la cámara del teléfono, *para* agregarlo instantáneamente al catálogo disponible.

### Matriz de Requerimientos

| Código | Tipo | Descripción |
| :--- | :--- | :--- |
| **RF01** | Funcional | Permitir el ingreso de un presupuesto numérico en CLP desde la vista inicial. |
| **RF02** | Funcional | Implementar el algoritmo de Canasta Inteligente con asignación de presupuesto por porcentajes categóricos. |
| **RF03** | Funcional | Integrar el uso nativo de la cámara del dispositivo (`image_picker`) para fotografiar e insertar nuevos productos al catálogo. |
| **RF04** | Funcional | Desplegar el listado dinámico de productos permitiendo modificar cantidades con cálculo de saldo en tiempo real. |
| **RF05** | Funcional | Implementar la navegación Master-Detail enviando la instancia del modelo de producto a la vista de detalle. |
| **RNF01** | No Funcional | Arquitectura modular con separación lógica entre modelos (`ProductModel`) y vistas (`views/`). |
| **RNF02** | No Funcional | Tematización global en Material 3 a través de `ThemeData` centralizado sin hardcoding de estilos. |
| **RNF03** | No Funcional | Garantizar la inmutabilidad de los datos maestros mediante la implementación del método `copyWith`. |
| **RNF04** | No Funcional | Renderizado dinámico de imágenes soportando assets del proyecto y archivos capturados localmente (`File`). |

---

## 3. Arquitectura y Jerarquía de Navegación

### Estructura de Directorios
```text
lib/
├── models/
│   └── product.dart         # Modelo de dominio ProductModel, método copyWith y catálogo base
├── views/
│   ├── home.dart            # Vista inicial: Ingreso de sueldo y disparador del algoritmo
│   ├── list.dart            # Vista Master: Banner reactivo, carrito y modal de cámara para nuevos productos
│   └── detail.dart          # Vista Detail: Desglose de información y rendimiento del insumo
└── main.dart                # Configuración global del ThemeData y punto de entrada de la app

Repositorio: https://github.com/EternalLamb/-3479A321_2024479019