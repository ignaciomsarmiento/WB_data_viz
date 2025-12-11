# Regulatory Frameworks Explorer
## World Bank Group - Latin America

Una aplicación Shiny interactiva para explorar marcos regulatorios en países de América Latina, incluyendo costos laborales no salariales, salarios mínimos, impuestos empresariales y asistencia social.

---

## 📋 Estructura del Proyecto

```
regulatory-frameworks-explorer/
│
├── app.R                 # Archivo principal de la aplicación
├── ui.R                  # Interfaz de usuario
├── server.R              # Lógica del servidor
│
├── www/                  # Archivos estáticos
│   └── styles.css        # Estilos CSS personalizados
│
├── modules/              # Módulos de la aplicación (futuro)
│   ├── labor/
│   ├── minwage/
│   └── btax/
│
└── data/                 # Datos de la aplicación (futuro)
    └── [archivos de datos]
```

---

## 🎨 Diseño y Colores

La aplicación utiliza la paleta de colores oficial del World Bank Group:

- **Light Gray**: `#F1F3F5` - Fondo de secciones
- **Border Gray**: `#B9BAB5` - Bordes de elementos
- **Solid Blue**: `#002244` - Color principal, textos
- **Solid Blue 60%**: `rgba(0, 34, 68, 0.6)` - Versión transparente
- **Bright Blue**: `#00C1FF` - Acentos, elementos activos
- **White**: `#FFFFFF` - Fondo principal

**Tipografía**: National Park (con fallback a Source Sans Pro)

---

## 🚀 Instalación

### Requisitos Previos

- R (versión 4.0 o superior)
- RStudio (recomendado)

### Paquetes Necesarios

Instala los siguientes paquetes de R:

```r
# Paquetes principales
install.packages("shiny")
install.packages("shiny.router")

# Paquetes adicionales (si se necesitan en el futuro)
install.packages("dplyr")
install.packages("ggplot2")
install.packages("plotly")
install.packages("DT")
```

### Instalación del Proyecto

1. **Clona o descarga** el repositorio

2. **Estructura de carpetas**: Asegúrate de tener la siguiente estructura:
   ```
   tu-proyecto/
   ├── app.R
   ├── ui.R
   ├── server.R
   └── www/
       └── styles.css
   ```

3. **Verifica los archivos**: Asegúrate de que todos los archivos estén en su lugar

---

## ▶️ Ejecución

### Método 1: Desde RStudio

1. Abre el archivo `app.R` en RStudio
2. Haz clic en el botón **"Run App"** en la esquina superior derecha
3. La aplicación se abrirá en tu navegador predeterminado

### Método 2: Desde la consola de R

```r
# Navega al directorio del proyecto
setwd("/ruta/a/tu/proyecto")

# Ejecuta la aplicación
shiny::runApp()
```

### Método 3: Especificar puerto

```r
# Ejecutar en un puerto específico
shiny::runApp(port = 8080)

# Ejecutar y abrir en el navegador automáticamente
shiny::runApp(launch.browser = TRUE)
```

---

## 📱 Navegación de la Aplicación

### Estructura de Páginas

La aplicación tiene 3 páginas principales accesibles desde el menú superior:

#### 1. **EXPLORER** (Página Principal)
- Landing page con 3 tarjetas de tópicos regulatorios
- Solo "Non-Salary Labor Costs" está activa
- "Minimum wages" y "Business taxes" están marcados como "FORTHCOMING"

#### 2. **GUIDE** (Guía)
- "How to read the data"
- 6 preguntas con información sobre cómo interpretar los datos
- (Contenido pendiente de agregar)

#### 3. **ABOUT** (Acerca del Proyecto)
- "The project"
- Información de contacto
- Información del equipo
- (Contenido pendiente de personalizar)

### Flujo de Navegación

#### Explorar por Tópico:

```
Landing Page (EXPLORER)
  ↓ Click en "Non-Salary Labor Costs"
Página de Países
  ↓ Seleccionar un país (ej: Colombia)
Página de Tópicos del País
  ↓ Seleccionar tópico
Página de Contenido (visualización de datos)
```

#### Navegación del Menú:

```
EXPLORER → GUIDE → ABOUT
   ↑         ↓        ↓
   ←---------←--------←
```

---

## 🛠️ Personalización

### Modificar Países

En `app.R` (o `ui.R`), edita la lista de países:

```r
countries <- list(
  argentina = "Argentina",
  # ... agregar o quitar países
)
```

### Modificar Tópicos

En `app.R` (o `ui.R`), edita la lista de tópicos:

```r
topics <- list(
  labor = list(
    title = "Non-Salary Labor Costs",
    description = "Tu descripción aquí",
    active = TRUE,      # Cambiar a FALSE para deshabilitar
    badge = NULL        # Agregar "FORTHCOMING" para mostrar badge
  ),
  # ... más tópicos
)
```

### Modificar Colores

En `www/styles.css`, cambia las variables CSS en `:root`:

```css
:root {
  --light-gray: #F1F3F5;
  --border-gray: #B9BAB5;
  --solid-blue: #002244;
  --bright-blue: #00C1FF;
  /* ... más variables */
}
```

### Agregar Contenido a las Páginas

#### Para GUIDE:
En `ui.R`, busca `page_guide` y edita:
```r
tags$div(
  class = "question-item",
  tags$p(class = "question-text", "TU PREGUNTA AQUÍ")
)
```

#### Para ABOUT:
En `ui.R`, busca `page_about` y edita las secciones de contacto y equipo.

---

## 🔧 Desarrollo Futuro

### Próximos Pasos

1. **Crear Módulos de Contenido**
   - Módulo para "Non-Salary Labor Costs"
   - Visualizaciones de datos con ggplot2/plotly
   - Tablas interactivas con DT

2. **Agregar Datos Reales**
   - Conectar con bases de datos
   - Archivos CSV/Excel con datos de países
   - API endpoints para datos en tiempo real

3. **Habilitar Tópicos Adicionales**
   - Activar "Minimum wages"
   - Activar "Business taxes"
   - Crear sus respectivos módulos

4. **Mejorar Funcionalidad**
   - Exportación de datos
   - Comparación entre países
   - Filtros avanzados

### Agregar Nuevo Módulo

1. Crea la carpeta del módulo:
   ```
   modules/
   └── nuevo_modulo/
       ├── ui_nuevo_modulo.R
       └── server_nuevo_modulo.R
   ```

2. En `ui.R`, agrega el tópico a la lista:
   ```r
   nuevo_modulo = list(
     title = "Título del Módulo",
     description = "Descripción",
     active = TRUE,
     badge = NULL
   )
   ```

3. En `server.R`, agrega la lógica de renderizado en `output$module_content`

---

## 🐛 Debugging

### Mensajes de Depuración

La aplicación incluye mensajes de debug extensivos. Para verlos:

1. **Consola de R**: Verás mensajes como:
   ```
   DEBUG: Topic card clicked = labor
   DEBUG: Country selected = colombia
   DEBUG: Rendering country_topics_content
   ```

2. **Consola del Navegador** (F12):
   ```javascript
   Card clicked: card-labor
   Country clicked: colombia
   Topic clicked: labor for country: colombia
   ```

### Problemas Comunes

#### La aplicación no carga los estilos
- **Solución**: Verifica que `www/styles.css` existe
- Reinicia la aplicación con `Ctrl+Shift+F5` (hard refresh)

#### Los clics no funcionan
- **Solución**: Abre la consola del navegador (F12) y busca errores de JavaScript
- Verifica que `shiny.router` esté instalado correctamente

#### Página en blanco
- **Solución**: Revisa la consola de R para errores
- Verifica que todos los archivos (`ui.R`, `server.R`, `app.R`) estén en el directorio correcto

---

## 📞 Soporte

Para problemas o preguntas:
- **Email**: contact@worldbank.org
- **Issues**: [Crear issue en GitHub]

---

## 📄 Licencia

© 2025 World Bank Group. Todos los derechos reservados.

---

## ✨ Características Principales

- ✅ Diseño moderno y responsive
- ✅ Navegación intuitiva con rutas
- ✅ 18 países de América Latina
- ✅ 3 tópicos regulatorios (1 activo, 2 próximamente)
- ✅ Paleta de colores oficial del World Bank
- ✅ Efectos hover y transiciones suaves
- ✅ Debugging extensivo
- ✅ Preparado para módulos adicionales

---

## 🎯 Roadmap

- [ ] Implementar módulo de "Non-Salary Labor Costs"
- [ ] Agregar visualizaciones de datos reales
- [ ] Habilitar "Minimum wages" y "Business taxes"
- [ ] Agregar exportación de datos (CSV, PDF)
- [ ] Implementar comparación entre países
- [ ] Agregar filtros de fecha
- [ ] Versión móvil optimizada
- [ ] Modo oscuro

---

**¡Listo para explorar los marcos regulatorios de América Latina!** 🌎
