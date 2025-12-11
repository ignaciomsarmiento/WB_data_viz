# ⚡ INICIO RÁPIDO - Regulatory Frameworks Explorer

## 🚀 Instalación en 3 Pasos

### 1️⃣ Instalar Paquetes

Abre RStudio o R Console y ejecuta:

```r
install.packages("shiny")
install.packages("shiny.router")
```

### 2️⃣ Organizar Archivos

Crea la siguiente estructura de carpetas:

```
mi-proyecto/
├── app.R
├── ui.R
├── server.R
└── www/
    └── styles.css
```

Coloca cada archivo descargado en su ubicación correspondiente.

### 3️⃣ Ejecutar la Aplicación

En RStudio:
- Abre `app.R`
- Click en **"Run App"** (arriba a la derecha)

O en R Console:
```r
setwd("/ruta/a/mi-proyecto")
shiny::runApp()
```

---

## ✅ Verificación

Si todo funciona correctamente, deberías ver:

1. ✅ Header con logo del World Bank Group
2. ✅ Menú con EXPLORER, GUIDE, ABOUT
3. ✅ Banner azul abstracto
4. ✅ Título "Regulatory Frameworks Explorer"
5. ✅ 3 tarjetas de tópicos:
   - Non-Salary Labor Costs (activa, clickeable)
   - Minimum wages (disabled, "FORTHCOMING")
   - Business taxes (disabled, "FORTHCOMING")

---

## 🎯 Flujo de Navegación

### Probar el flujo completo:

1. **Click en "Non-Salary Labor Costs"**
   - Deberías ir a la página de países

2. **Click en un país (ej: "Colombia")**
   - Deberías ver "Select a Topic for Colombia"
   - Verás las 3 tarjetas de tópicos para ese país

3. **Click en "Non-Salary Labor Costs" del país**
   - Deberías ver la página de contenido (placeholder)

4. **Probar navegación del menú superior**
   - EXPLORER → Landing page
   - GUIDE → Página de preguntas
   - ABOUT → Página del proyecto

---

## 🐛 Solución de Problemas

### ❌ Los estilos no cargan

**Síntoma**: La página se ve sin colores, todo blanco y negro

**Solución**:
1. Verifica que `www/styles.css` existe
2. Reinicia la app con `Ctrl+Shift+F5` en el navegador
3. En R Console, ejecuta: `shiny::runApp(launch.browser = TRUE)`

### ❌ Error: "package shiny.router not found"

**Síntoma**: Error al ejecutar la app

**Solución**:
```r
install.packages("shiny.router")
```

### ❌ Los clicks no funcionan

**Síntoma**: Haces click en las tarjetas y no pasa nada

**Solución**:
1. Abre la consola del navegador (F12)
2. Busca errores en rojo
3. Verifica que JavaScript esté habilitado
4. Reinicia la aplicación

### ❌ Error: "could not find function router_ui"

**Síntoma**: Error al iniciar la app

**Solución**:
```r
library(shiny.router)
shiny::runApp()
```

---

## 📝 Comandos Útiles

### Ejecutar en un puerto específico:
```r
shiny::runApp(port = 8080)
```

### Ejecutar y abrir navegador automáticamente:
```r
shiny::runApp(launch.browser = TRUE)
```

### Ver mensajes de debug en R Console:
```r
# Los mensajes DEBUG aparecerán automáticamente
# cuando hagas click en elementos de la app
```

### Ver mensajes de debug en navegador:
```javascript
// Abre consola del navegador (F12)
// Ve a la pestaña "Console"
// Verás mensajes como:
// "Card clicked: card-labor"
// "Country clicked: colombia"
```

---

## 🎨 Personalización Rápida

### Cambiar colores:

En `www/styles.css`, busca `:root` y cambia:
```css
:root {
  --solid-blue: #002244;    /* Tu color aquí */
  --bright-blue: #00C1FF;   /* Tu color aquí */
  /* ... */
}
```

### Agregar/quitar países:

En `app.R`, busca la lista `countries` y edita:
```r
countries <- list(
  argentina = "Argentina",
  chile = "Chile",
  # Agrega más países aquí
  tu_pais = "Tu País"
)
```

### Cambiar descripciones:

En `app.R`, busca la lista `topics` y edita:
```r
topics <- list(
  labor = list(
    title = "Tu Título",
    description = "Tu descripción aquí",
    active = TRUE,
    badge = NULL
  )
)
```

---

## 📖 Próximos Pasos

1. ✅ **Ejecutar la aplicación** y verificar que funciona
2. 📚 **Leer el README.md** para detalles completos
3. 🎨 **Ver VISUAL_GUIDE.md** para entender el diseño
4. 🔧 **Agregar tus datos reales** en módulos personalizados
5. 🎯 **Personalizar contenido** de las páginas GUIDE y ABOUT

---

## 🆘 ¿Necesitas Ayuda?

Si algo no funciona:

1. **Verifica la estructura de carpetas** - Todos los archivos en su lugar
2. **Revisa la consola de R** - Busca errores en rojo
3. **Revisa la consola del navegador (F12)** - Busca errores de JavaScript
4. **Verifica los paquetes instalados**:
   ```r
   library(shiny)
   library(shiny.router)
   ```

---

**¡Listo! Tu aplicación debería estar funcionando ahora.** 🎉

Para más información, consulta:
- 📖 `README.md` - Documentación completa
- 🎨 `VISUAL_GUIDE.md` - Guía visual de diseño
