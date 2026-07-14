# Retrospectiva de Sprints

## Sprint 1

### ¿Qué salió bien?
- Se configuró correctamente el repositorio y la estrategia de trabajo colaborativo mediante Git y GitHub.
- El pipeline de integración continua (CI/CD) quedó funcionando desde las primeras etapas del proyecto.
- La división de tareas entre los integrantes fue clara, permitiendo avanzar de manera paralela en diferentes actividades.
- Se logró levantar y ejecutar el proyecto de Medusa localmente, comprendiendo su estructura general y flujo de trabajo.

### ¿Qué hay que mejorar?
- Las estimaciones de tiempo realizadas al inicio del sprint fueron demasiado optimistas.
- La resolución de problemas relacionados con Docker tomó más tiempo del esperado debido a inconsistencias en el lockfile y variables de entorno faltantes.
- Algunas tareas requirieron investigación adicional sobre la arquitectura de Medusa, lo que afectó la planificación inicial.

### ¿Qué haremos diferente?
- Verificar el entorno local antes de comenzar una nueva tarea.
- Mantener actualizadas las dependencias y archivos de configuración del proyecto.
- Realizar validaciones tempranas para detectar problemas de configuración antes de iniciar el desarrollo.

---

## Sprint 2

### ¿Qué salió bien?
- Se implementó correctamente el filtrado de productos por categoría en el storefront.
- Se añadió la visualización de disponibilidad de stock en la página de detalle del producto.
- La documentación técnica del módulo de Productos fue completada y actualizada.
- La experiencia adquirida durante el Sprint 1 permitió resolver incidencias con mayor rapidez y reducir tiempos de configuración.

### ¿Qué hay que mejorar?
- Algunas tareas de documentación fueron realizadas al final del sprint, concentrando trabajo en los últimos días.
- Se requiere generar evidencias visuales y documentación técnica de manera continua durante el desarrollo.
- Es necesario seguir mejorando la estimación de esfuerzo para funcionalidades que implican modificaciones tanto en frontend como en backend.

### ¿Qué haremos diferente?
- Documentar cada funcionalidad inmediatamente después de su implementación.
- Mantener reuniones breves de seguimiento para identificar bloqueos de forma temprana.
- Continuar validando el entorno local antes de comenzar nuevas tareas.
- Realizar pruebas funcionales al finalizar cada mejora para detectar errores antes de la integración final.

---

## Sprint 3

### ¿Qué salió bien?
- Se implementó correctamente la visualización del estado de los pedidos en la cuenta del cliente, incluyendo el mapeo de los distintos estados de fulfillment a indicadores visuales.
- El burndown chart quedó automatizado mediante un workflow programado de GitHub Actions, sin requerir generación manual.
- Se escribieron pruebas de integración conectadas como un nuevo job del pipeline, validando flujos reales del backend.
- Se corrigió la totalidad de las advertencias de ESLint heredadas del código base original de Medusa, dejando el linter en estado limpio.
- La experiencia acumulada en los sprints anteriores permitió resolver la configuración de nuevas automatizaciones (burndown, tests) con menor fricción que en sprints previos.

### ¿Qué hay que mejorar?
- La escritura de pruebas de integración tomó más tiempo del estimado, ya que requirió familiarizarse con los workflows internos de Medusa (creación de API keys y sales channels) antes de poder validarlos.
- La corrección de advertencias de ESLint, al abarcar múltiples módulos del storefront, se concentró en pocos días en lugar de distribuirse a lo largo del sprint.
- Faltó coordinar con más anticipación la dependencia entre el job de pruebas y el resto del pipeline, lo que generó reintentos adicionales en las primeras ejecuciones.

### ¿Qué haremos diferente?
- Reservar tiempo específico dentro del sprint para investigar la API interna de Medusa antes de comprometer estimaciones de pruebas de integración.
- Distribuir las tareas de limpieza de código (lint) en paralelo con el desarrollo funcional, en lugar de dejarlas para el cierre del sprint.
- Ejecutar el pipeline completo de forma local (o en una rama de prueba) antes de integrar nuevos jobs, para reducir el número de iteraciones necesarias en GitHub Actions.

---

## Sprint 4

### ¿Qué salió bien?
- Se consolidó toda la documentación técnica del proceso DevOps (arquitectura, pipeline, entorno Docker, gestión del backlog y ceremonias Scrum) en un único documento de referencia.
- La redacción del artículo técnico en formato IEEE permitió sintetizar los cuatro sprints del proyecto en una narrativa coherente, facilitando la revisión final del trabajo.
- El reparto de secciones del artículo entre los cuatro integrantes permitió avanzar en paralelo sin sobrecargar a una sola persona.
- Al no haber desarrollo funcional en este sprint, el equipo pudo dedicar tiempo completo a la calidad y consistencia de la documentación.

### ¿Qué hay que mejorar?
- La redacción del artículo IEEE se inició más tarde de lo planificado, pese a que el riesgo ya había sido identificado desde el Hito 01.
- Faltó una revisión cruzada más temprana entre integrantes de las secciones ya redactadas, lo que generó ajustes de última hora en el formato y el lenguaje.
- La consolidación de evidencias (capturas, diagramas) de los cuatro sprints tomó más tiempo del esperado por estar dispersas entre distintos documentos.

### ¿Qué haremos diferente?
- En futuros proyectos, iniciar la redacción de la documentación final desde el sprint anterior al cierre, en paralelo al último desarrollo funcional, y no únicamente en el sprint de cierre.
- Centralizar desde el inicio del proyecto un repositorio único de evidencias (capturas, diagramas, enlaces) para evitar tareas de recopilación tardías.
- Establecer una revisión cruzada obligatoria de cada sección del artículo antes de darla por finalizada.

---

## Conclusiones

Los cuatro sprints del proyecto permitieron al equipo recorrer el ciclo completo de un proceso de desarrollo ágil respaldado por prácticas DevOps: desde la selección y comprensión de un producto externo, pasando por la configuración de su infraestructura técnica y la incorporación de mejoras funcionales, hasta el cierre documental y la redacción del artículo académico. Durante los dos primeros sprints el equipo se familiarizó con la arquitectura de Medusa, el uso de Next.js en el storefront y las herramientas de integración continua; en los dos últimos, esa base permitió extender el sistema hacia el módulo de Pedidos y madurar el pipeline con automatización adicional (burndown chart, pruebas de integración) sin comprometer su estabilidad. Las lecciones aprendidas en cada retrospectiva —desde validar el entorno local antes de codear hasta iniciar la documentación final con mayor anticipación— fortalecieron progresivamente la eficiencia del equipo y su capacidad de anticipar riesgos, constituyendo una experiencia formativa completa sobre la aplicación conjunta de Scrum y DevOps en un contexto de software real.
