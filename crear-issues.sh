#!/bin/bash
# Script para crear labels, milestones e issues en GitHub
# Proyecto: Medusa Store IPS - Grupo 03
# Ejecutar desde la raiz del repositorio con: bash crear-issues.sh

echo "Creando labels..."

gh label create "user-story" --color "0075ca" --description "Historia de usuario" 2>/dev/null || echo "label user-story ya existe"
gh label create "devops" --color "e4e669" --description "Tarea de infraestructura CI/CD" 2>/dev/null || echo "label devops ya existe"
gh label create "documentacion" --color "cfd3d7" --description "Tarea de documentacion tecnica" 2>/dev/null || echo "label documentacion ya existe"
gh label create "bug" --color "d73a4a" --description "Reporte de error" 2>/dev/null || echo "label bug ya existe"
gh label create "sprint-1" --color "bfe5bf" --description "Sprint 1" 2>/dev/null || echo "label sprint-1 ya existe"
gh label create "sprint-2" --color "fbca04" --description "Sprint 2" 2>/dev/null || echo "label sprint-2 ya existe"
gh label create "sprint-3" --color "f9d0c4" --description "Sprint 3" 2>/dev/null || echo "label sprint-3 ya existe"
gh label create "sprint-4" --color "e99695" --description "Sprint 4" 2>/dev/null || echo "label sprint-4 ya existe"

echo "Labels creados."

echo "Creando milestones..."

gh api repos/:owner/:repo/milestones -f title="Sprint 1" -f due_on="2026-05-26T23:59:59Z" -f description="CI/CD, Docker, documentacion base" 2>/dev/null || echo "milestone Sprint 1 ya existe"
gh api repos/:owner/:repo/milestones -f title="Sprint 2" -f due_on="2026-06-09T23:59:59Z" -f description="Mejoras modulo Productos y staging" 2>/dev/null || echo "milestone Sprint 2 ya existe"
gh api repos/:owner/:repo/milestones -f title="Sprint 3" -f due_on="2026-06-27T23:59:59Z" -f description="Modulo Pedidos, burndown chart y tests" 2>/dev/null || echo "milestone Sprint 3 ya existe"
gh api repos/:owner/:repo/milestones -f title="Sprint 4" -f due_on="2026-07-12T23:59:59Z" -f description="Documentacion final y articulo IEEE" 2>/dev/null || echo "milestone Sprint 4 ya existe"

echo "Milestones creados."

echo "Creando issues Sprint 1..."

gh issue create \
  --title "[SPRINT-1] Levantar entorno Docker local con Medusa DTC Starter" \
  --body "Como desarrollador del equipo, necesito poder levantar todo el entorno de desarrollo con un solo comando para poder trabajar localmente sin tener que configurar cada servicio de forma manual.

Criterios de aceptacion:
- El comando docker-compose up levanta todos los servicios sin errores
- El backend de Medusa responde en http://localhost:9000
- El storefront responde en http://localhost:8000
- El panel de administracion es accesible en http://localhost:9000/app
- El archivo apps/backend/.env esta documentado sin exponer valores secretos
- Se puede crear un usuario administrador para hacer pruebas

Tareas:
- Copiar apps/backend/.env.template a apps/backend/.env y configurar las variables
- Ejecutar las migraciones de base de datos con pnpm medusa db:migrate
- Crear usuario admin de prueba
- Documentar los pasos de configuracion en el README.md" \
  --label "devops,sprint-1" \
  --assignee "RodrigoFFN" \
  --milestone "Sprint 1"

gh issue create \
  --title "[SPRINT-1] Documentar arquitectura tecnica de los modulos del sistema" \
  --body "Como equipo, necesitamos tener documentada la arquitectura del sistema para que el equipo docente pueda entender como esta estructurado el proyecto y para que nosotros mismos tengamos una referencia clara durante el desarrollo.

Criterios de aceptacion:
- Existe el archivo docs/arquitectura.md en el repositorio
- El documento describe los 5 modulos del sistema: Productos, Pedidos, Clientes, Pagos y Envios
- Cada modulo incluye descripcion, responsabilidades y endpoints principales de la API
- Se incluye un diagrama de arquitectura que muestre como se relacionan los servicios
- El documento esta enlazado desde el README.md

Tareas:
- Crear la carpeta docs/ en la raiz del repositorio
- Redactar docs/arquitectura.md con la estructura de modulos y el diagrama de capas
- Agregar el enlace al documento en el README.md" \
  --label "documentacion,sprint-1" \
  --assignee "paredes1234" \
  --milestone "Sprint 1"

gh issue create \
  --title "[SPRINT-1] Registrar el Product Backlog completo en GitHub Issues" \
  --body "Como Scrum Master del Sprint 1, necesito tener todas las historias de usuario del proyecto registradas en GitHub Issues para poder planificar los sprints y hacer seguimiento del trabajo del equipo desde el tablero Kanban.

Criterios de aceptacion:
- Existen al menos 15 issues creados en el repositorio
- Cada issue tiene titulo descriptivo, descripcion de la tarea, criterios de aceptacion y label de sprint correspondiente
- El tablero Kanban en GitHub Projects refleja el estado actual de cada issue
- Todos los issues estan asignados a algun integrante del equipo
- Los milestones de Sprint 1, 2, 3 y 4 estan creados en GitHub

Tareas:
- Crear los labels necesarios: user-story, devops, documentacion, bug, sprint-1 al sprint-4
- Crear los milestones por sprint con sus fechas de entrega
- Registrar todos los issues del Product Backlog
- Vincular cada issue a su milestone y columna en el tablero de GitHub Projects" \
  --label "documentacion,sprint-1" \
  --assignee "mauricioParedes12" \
  --milestone "Sprint 1"

echo "Issues Sprint 1 creados."

echo "Creando issues Sprint 2..."

gh issue create \
  --title "[SPRINT-2] Agregar filtrado de productos por categoria en el storefront" \
  --body "Como cliente de la tienda, quiero poder filtrar los productos por categoria para encontrar mas rapido lo que estoy buscando sin tener que revisar todo el catalogo.

Criterios de aceptacion:
- El storefront muestra una lista de categorias disponibles que el usuario puede seleccionar
- Al seleccionar una categoria, la lista de productos se actualiza sin recargar la pagina
- Si no hay productos en la categoria seleccionada, se muestra un mensaje indicandolo
- El filtro funciona correctamente tanto en dispositivos moviles como en desktop
- Los cambios estan documentados en docs/modulo-productos.md

Tareas:
- Identificar el componente de listado de productos en apps/storefront/
- Conectar el filtro con el endpoint /store/product-categories de la API de Medusa
- Manejar el estado del filtro seleccionado con useState o useSearchParams de Next.js
- Actualizar la interfaz para mostrar las categorias disponibles" \
  --label "user-story,sprint-2" \
  --assignee "mauricioParedes12" \
  --milestone "Sprint 2"

gh issue create \
  --title "[SPRINT-2] Mostrar disponibilidad de stock en la pagina de producto" \
  --body "Como cliente, quiero ver cuantas unidades quedan disponibles de cada variante de producto antes de agregarlo al carrito, para saber si el producto que quiero esta disponible antes de intentar comprarlo.

Criterios de aceptacion:
- La pagina de detalle de producto muestra el stock disponible para cada variante
- Si el stock de una variante es 0, el boton de agregar al carrito se deshabilita
- Si el stock es menor a 5 unidades, se muestra una advertencia de pocas unidades
- El dato de stock viene directamente del modulo de inventario de Medusa, no es un valor fijo en el codigo
- Los cambios estan documentados en docs/modulo-productos.md

Tareas:
- Identificar el componente de detalle de producto en apps/storefront/
- Leer el campo inventory_quantity de cada variante desde la API de Medusa
- Implementar la logica de mostrar stock, deshabilitar boton y mostrar advertencia
- Aplicar estilos con Tailwind CSS para el indicador de stock" \
  --label "user-story,sprint-2" \
  --assignee "MijaL18" \
  --milestone "Sprint 2"

gh issue create \
  --title "[SPRINT-2] Documentar las mejoras realizadas al modulo de Productos" \
  --body "Como equipo, necesitamos documentar los cambios que hicimos al modulo de Productos durante el Sprint 2 para que el equipo docente pueda revisar exactamente que se modifico y por que.

Criterios de aceptacion:
- Existe el archivo docs/modulo-productos.md en el repositorio
- El documento describe las dos mejoras implementadas: filtrado por categoria y visualizacion de stock
- Se incluyen capturas de pantalla de las funcionalidades en el storefront
- Se explica brevemente el flujo de datos entre el storefront y la API de Medusa
- El documento esta enlazado desde el README.md

Tareas:
- Crear docs/modulo-productos.md con la descripcion de los cambios
- Agregar fragmentos de codigo relevantes de las modificaciones
- Tomar capturas del storefront mostrando las nuevas funcionalidades
- Actualizar el README.md con el enlace al documento" \
  --label "documentacion,sprint-2" \
  --assignee "paredes1234" \
  --milestone "Sprint 2"

gh issue create \
  --title "[SPRINT-2] Actualizar GitHub Pages con el avance del Sprint 2" \
  --body "Como equipo, necesitamos actualizar el sitio de GitHub Pages para que refleje el estado actual del proyecto al finalizar el Sprint 2, incluyendo los entregables completados y el estado del pipeline.

Criterios de aceptacion:
- El index.html muestra el Sprint 2 como completado o en curso segun corresponda
- Se muestra el badge del pipeline CI/CD con el estado actual
- Se incluyen enlaces a la documentacion tecnica del modulo de Productos
- El deploy se realiza automaticamente cuando se hace push a main

Tareas:
- Actualizar la seccion de sprints del index.html con el estado del Sprint 2
- Agregar el badge de GitHub Actions al index.html
- Agregar enlaces a docs/modulo-productos.md y docs/arquitectura.md" \
  --label "devops,sprint-2" \
  --assignee "RodrigoFFN" \
  --milestone "Sprint 2"

gh issue create \
  --title "[SPRINT-2] Retrospectiva del Sprint 1 - documentar lo aprendido" \
  --body "Como equipo Scrum, necesitamos hacer la retrospectiva del Sprint 1 y documentar las conclusiones para mejorar nuestra forma de trabajar en los sprints siguientes.

Criterios de aceptacion:
- Existe el archivo docs/retrospectiva-sprint1.md en el repositorio
- El documento responde tres preguntas: que salio bien, que hay que mejorar y que vamos a hacer diferente
- Cada integrante del equipo aporto al menos un punto en cada seccion
- El documento esta fechado y tiene el nombre del Scrum Master del Sprint 1

Tareas:
- Coordinar la reunion de retrospectiva con todo el equipo (puede ser por videollamada)
- Redactar docs/retrospectiva-sprint1.md con el formato acordado
- Subir el documento al repositorio y cerrar los issues completados del Sprint 1" \
  --label "documentacion,sprint-2" \
  --assignee "mauricioParedes12" \
  --milestone "Sprint 2"

echo "Issues Sprint 2 creados."

echo "Creando issues Sprint 3..."

gh issue create \
  --title "[SPRINT-3] Mostrar el estado de los pedidos en la cuenta del cliente" \
  --body "Como cliente registrado, quiero poder ver el estado actual de mis pedidos desde mi cuenta en el storefront para saber en que etapa esta mi compra sin tener que contactar al soporte.

Criterios de aceptacion:
- La seccion de pedidos en la cuenta del cliente muestra el estado de cada orden
- Se muestran al menos cuatro estados: pendiente, en proceso, enviado y entregado
- Cada estado tiene un color o icono diferente para distinguirlos facilmente
- Los datos vienen de la API de Medusa, no son estaticos
- Los cambios estan documentados en docs/modulo-pedidos.md

Tareas:
- Identificar el componente de historial de pedidos en apps/storefront/
- Conectar con el endpoint /store/orders de la API de Medusa
- Implementar el componente visual de estados con Tailwind CSS
- Redactar docs/modulo-pedidos.md con la descripcion del cambio" \
  --label "user-story,sprint-3" \
  --assignee "paredes1234" \
  --milestone "Sprint 3"

gh issue create \
  --title "[SPRINT-3] Generar el Burndown Chart automaticamente con GitHub Actions" \
  --body "Como Scrum Master, quiero que el Burndown Chart del sprint se genere de forma automatica con GitHub Actions para poder ver el progreso del equipo sin tener que crearlo manualmente cada dia.

Criterios de aceptacion:
- Existe el archivo .github/workflows/burndown.yml en el repositorio
- El workflow se ejecuta automaticamente cada dia y tambien en cada push a main
- El grafico muestra el trabajo total, el trabajo completado y la linea ideal del sprint
- El burndown generado se publica automaticamente en GitHub Pages

Tareas:
- Crear .github/workflows/burndown.yml con trigger de tipo schedule
- Usar la API de GitHub para obtener el conteo de issues abiertos y cerrados por sprint
- Generar el grafico usando Python con matplotlib o Node.js
- Publicar la imagen resultante en la rama gh-pages" \
  --label "devops,sprint-3" \
  --assignee "MijaL18" \
  --milestone "Sprint 3"

gh issue create \
  --title "[SPRINT-3] Escribir pruebas de integracion y conectarlas al pipeline" \
  --body "Como equipo de desarrollo, necesitamos tener pruebas de integracion en el proyecto para que el pipeline pueda verificar automaticamente que los modulos que modificamos siguen funcionando correctamente antes de hacer merge a main.

Criterios de aceptacion:
- Existen al menos tres pruebas de integracion escritas en el proyecto
- Las pruebas cubren al menos: creacion de un producto, consulta de un pedido y autenticacion de cliente
- El job de test del pipeline ejecuta las pruebas usando Postgres y Redis reales
- Si alguna prueba falla, el pipeline bloquea el merge a main

Tareas:
- Instalar jest o vitest en el workspace del backend
- Escribir las tres pruebas de integracion basicas
- Verificar que el job test del ci.yml las detecta y ejecuta correctamente" \
  --label "devops,sprint-3" \
  --assignee "RodrigoFFN" \
  --milestone "Sprint 3"

gh issue create \
  --title "[SPRINT-3] Corregir advertencias de ESLint heredadas del codigo base de Medusa" \
  --body "Durante la configuracion del pipeline CI/CD se identificaron errores de ESLint en el codigo base del storefront de Medusa que impedian que el job de lint pasara. Estos errores son del codigo original del repositorio y no fueron introducidos por el equipo.

Descripcion del problema:
El storefront tiene variables sin usar y comentarios @ts-ignore en archivos del codigo base de Medusa que el linter marca como errores. Como son del upstream y no afectan el funcionamiento del sistema, se decidio degradarlos a advertencias con justificacion tecnica documentada.

Criterios de aceptacion:
- El job de lint del pipeline pasa sin errores
- El archivo apps/storefront/.eslintrc.json esta configurado con las reglas ajustadas
- La decision tecnica esta documentada en este issue como referencia

Solucion aplicada:
Se creo apps/storefront/.eslintrc.json degradando a warning las reglas no-unused-vars, no-explicit-any, ban-ts-comment y react-hooks/exhaustive-deps unicamente para el codigo heredado del upstream. El patron argsIgnorePattern asegura que el codigo nuevo del equipo si sea validado estrictamente." \
  --label "bug,sprint-3" \
  --assignee "paredes1234" \
  --milestone "Sprint 3"

echo "Issues Sprint 3 creados."

echo "Creando issues Sprint 4..."

gh issue create \
  --title "[SPRINT-4] Redactar la documentacion tecnica completa del proceso DevOps" \
  --body "Como equipo, necesitamos documentar todo el proceso DevOps que implementamos a lo largo del proyecto para que el equipo docente pueda evaluar como integramos CI/CD con la metodologia Scrum.

Criterios de aceptacion:
- Existe docs/devops-proceso.md con la descripcion completa del pipeline
- El documento incluye el diagrama del pipeline, las etapas, las herramientas usadas y los resultados obtenidos
- Se incluyen capturas de los pipelines exitosos en la pestana Actions de GitHub
- El documento esta enlazado desde el README.md y desde el index.html de GitHub Pages

Tareas:
- Crear docs/devops-proceso.md
- Documentar cada job del pipeline: lint, build, test y deploy-pages
- Agregar capturas del historial de ejecuciones en GitHub Actions
- Incluir una seccion de metricas con el tiempo promedio de ejecucion del pipeline" \
  --label "documentacion,sprint-4" \
  --assignee "mauricioParedes12" \
  --milestone "Sprint 4"

gh issue create \
  --title "[SPRINT-4] Redactar el articulo tecnico del proyecto en formato IEEE" \
  --body "Como equipo, necesitamos entregar un articulo tecnico en formato IEEE que documente todo el proceso del proyecto como entregable final del curso de Ingenieria y Procesos de Software.

Criterios de aceptacion:
- El articulo sigue la plantilla IEEE de doble columna
- Incluye las secciones: Abstract, Introduccion, Marco Teorico, Metodologia, Resultados y Conclusiones
- Se citan al menos ocho referencias academicas o tecnicas relevantes
- El articulo tiene entre seis y ocho paginas
- El PDF esta disponible en el repositorio en docs/articulo-ieee.pdf y enlazado desde GitHub Pages

Tareas:
- Usar la plantilla IEEE disponible en Overleaf o Word
- Asignar una seccion a cada integrante del equipo
- Revisar y unificar el articulo completo antes de exportarlo
- Subir el PDF al repositorio" \
  --label "documentacion,sprint-4" \
  --assignee "MijaL18" \
  --milestone "Sprint 4"

echo "Issues Sprint 4 creados."
echo ""
echo "Listo. Se crearon todos los issues, labels y milestones del proyecto."
echo "Recuerda cerrar los issues ya resueltos: pipeline CI/CD, deploy Pages y correccion ESLint."
