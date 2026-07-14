# Documentación Técnica del Proceso DevOps
**Proyecto:** Medusa Store IPS — Scrum + DevOps aplicado al Medusa DTC Starter
**Curso:** Ingeniería y Procesos de Software — UNSA 2026
**Grupo 03:** Flores Núñez, Rodrigo Francisco · Jimenez Paredes, Fabricio Gabriel · Paredes Miranda, Mauricio Antonio · Leon Ramos, Mijael Paul
**Repositorio:** https://github.com/mauricioParedes12/medusa-store-IPS

---

## Tabla de Contenidos

1. [Introducción](#1-introducción)
2. [Descripción general del sistema](#2-descripción-general-del-sistema)
3. [Arquitectura técnica](#3-arquitectura-técnica)
4. [Entorno de desarrollo con Docker](#4-entorno-de-desarrollo-con-docker)
5. [Pipeline CI/CD con GitHub Actions](#5-pipeline-cicd-con-github-actions)
6. [Gestión ágil del proyecto (Scrum)](#6-gestión-ágil-del-proyecto-scrum)
7. [Estrategia de ramas (GitFlow) y Pull Requests](#7-estrategia-de-ramas-gitflow-y-pull-requests)
8. [Mejoras funcionales por sprint](#8-mejoras-funcionales-por-sprint)
9. [Calidad de código](#9-calidad-de-código)
10. [Gestión de riesgos](#10-gestión-de-riesgos)
11. [Retrospectivas](#11-retrospectivas)
12. [Recursos y herramientas](#12-recursos-y-herramientas)
13. [Conclusiones](#13-conclusiones)
14. [Referencias](#14-referencias)

---

## 1. Introducción

Este documento consolida, en un único artefacto técnico, todo el proceso DevOps implementado a lo largo de los cuatro sprints del proyecto **Scrum + DevOps aplicado al Medusa DTC Starter**, ejecutado entre el 5 de mayo y el 12 de julio de 2026. Reúne la información generada en los tres hitos del curso: la planificación y selección del producto (Hito 01), la puesta en marcha de la infraestructura técnica (Hito 02), y el cierre funcional y documental del proyecto (Hito 03).

El objetivo de este documento es servir como referencia técnica única y completa del pipeline de integración continua, el entorno de desarrollo reproducible, la gestión del backlog y las ceremonias ágiles aplicadas, de modo que cualquier persona ajena al equipo pueda comprender, auditar o retomar el proyecto.

## 2. Descripción general del sistema

El proyecto se construyó sobre el **Medusa DTC Starter**, la implementación de referencia oficial del ecosistema MedusaJS (repositorio `medusajs/dtc-starter`), publicada bajo licencia MIT por el propio equipo de Medusa. Se trata de una plataforma de comercio electrónico *headless* de tipo Direct-to-Consumer, organizada como monorepo con **pnpm workspaces** y **Turborepo**, y compuesta por tres aplicaciones:

| Aplicación | Tecnología | Puerto | Función |
|---|---|---|---|
| Backend | Node.js + TypeScript + Medusa v2 | 9000 | API REST y lógica de negocio |
| Storefront | Next.js 14 + React | 8000 | Tienda pública para clientes |
| Admin Dashboard | React (incluido en Medusa) | 9000/app | Panel de administración interno |

El repositorio supera las 15,000 líneas de código propio, cumpliendo el umbral mínimo establecido para el proyecto del curso. Los cinco módulos de dominio del sistema son: **Productos**, **Pedidos**, **Clientes**, **Pagos** y **Envíos**.

## 3. Arquitectura técnica

El sistema se organiza en tres capas, comunicadas mediante HTTP/REST:

```
Capa de presentación
  Storefront (Next.js) — puerto 8000        Admin Dashboard (React) — puerto 9000/app
                    |                                      |
                    |---------------- HTTP / REST API ------------------|

Capa de negocio
  Backend Medusa (Node.js) — puerto 9000
  [ Productos | Pedidos | Clientes | Pagos | Envíos ]

Capa de datos
  PostgreSQL 15 (puerto 5432, datos principales)
  Redis 7 (puerto 6379, caché y colas de trabajo)
```

Esta documentación fue originalmente registrada en `docs/arquitectura.md`, incluyendo un diagrama en formato Mermaid para su renderizado directo en GitHub, y describe para cada módulo sus responsabilidades, endpoints principales de la API y relación con los demás módulos.

## 4. Entorno de desarrollo con Docker

El entorno local se levanta con **Docker Compose**, orquestando el backend, PostgreSQL y Redis con un solo comando (`docker-compose up -d`).

### 4.1. Configuración inicial

El repositorio original de Medusa DTC Starter no incluye un archivo `.env` configurado. El proceso de configuración fue:

1. Copiar `apps/backend/.env.template` a `apps/backend/.env`.
2. Configurar las variables de conexión a PostgreSQL y Redis.
3. Ejecutar las migraciones con `pnpm medusa db:migrate`.

### 4.2. Problemas resueltos

| Problema | Causa | Solución |
|---|---|---|
| `docker-compose up` fallaba | El backend intentaba conectarse a Postgres antes de que el contenedor terminara de inicializar | Se agregó `depends_on` con `condition: service_healthy` en `docker-compose.yml` |
| El servidor no levantaba | Faltaba el campo `http` en `medusa-config.ts`, requerido explícitamente por Medusa v2 | Se agregó la propiedad con los valores por defecto según la documentación oficial |

Al finalizar la configuración, los tres servicios respondían correctamente: backend en `localhost:9000`, storefront en `localhost:8000` y panel de administración en `localhost:9000/app`. Los pasos quedaron documentados en el `README.md` del repositorio.

## 5. Pipeline CI/CD con GitHub Actions

### 5.1. Estructura del pipeline

El pipeline principal está definido en `.github/workflows/ci.yml` y se ejecuta automáticamente en cada push a `main` y `develop`, y en cada Pull Request dirigido a `main`. Está compuesto por cuatro jobs:

| Job | Depende de | Qué hace |
|---|---|---|
| `lint` | — | Instala dependencias y ejecuta el análisis de código estático sobre todo el monorepo usando Turborepo |
| `build` | `lint` | Compila el proyecto completo en modo producción, verificando que storefront y backend construyan sin errores |
| `test` | `lint` | Levanta contenedores de PostgreSQL 15 y Redis 7 en el runner, instala dependencias y ejecuta la suite de tests |
| `deploy-pages` | `lint`, `build` | Solo en push a `main`; actualiza el estado del CI en `index.html` y despliega a la rama `gh-pages` |

Los jobs `build` y `test` corren en paralelo una vez que `lint` pasa, reduciendo el tiempo total de ejecución. `deploy-pages` nunca se activa en Pull Requests, para evitar publicar ramas incompletas.

### 5.2. Decisiones técnicas y errores resueltos

Durante la puesta en marcha del pipeline (Sprint 1) se presentaron y resolvieron los siguientes problemas:

- **Lockfile desincronizado:** el lockfile heredado del repositorio original no coincidía con el `package.json` del fork. Se adoptó el flag `--no-frozen-lockfile` en todos los jobs, dado que el lockfile se regenera correctamente en cada ejecución del runner.
- **Variables de entorno faltantes:** el job de `lint` fallaba porque el storefront de Next.js requiere ciertas variables en tiempo de compilación. Se agregaron `NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY`, `NEXT_PUBLIC_BASE_URL` y `NEXT_PUBLIC_DEFAULT_REGION` con valores *placeholder* en el workflow, suficientes para que linter y build pasen sin backend real.
- **`medusa-config.ts` sin el campo `http`:** el job de `build` fallaba al inicializar la configuración del backend. Se agregó la propiedad con los valores por defecto exigidos por Medusa v2.
- **`generateStaticParams` sin manejo de excepciones:** esta función consulta la API de Medusa para generar rutas estáticas; en CI no hay backend levantado, por lo que lanzaba una excepción no manejada. Se envolvió la llamada en un bloque `try/catch` que retorna un arreglo vacío en caso de error.

### 5.3. Automatización del Burndown Chart (Sprint 3)

Se incorporó un workflow independiente (`burndown.yml`) que se ejecuta de forma programada (*scheduled*) mediante GitHub Actions, generando automáticamente el burndown chart del proyecto sin intervención manual. El resultado se publica junto con el dashboard del proyecto en GitHub Pages.

### 5.4. Pruebas de integración (Sprint 3)

Se escribieron pruebas de integración utilizando `medusaIntegrationTestRunner` de `@medusajs/test-utils`, validando flujos reales del backend (por ejemplo, la creación de API keys publicables y canales de venta mediante los workflows internos de Medusa: `createApiKeysWorkflow`, `createSalesChannelsWorkflow`, `linkSalesChannelsToApiKeyWorkflow`). Estas pruebas se conectaron como un nuevo job (`test`) dentro del pipeline de CI, validándose en cada push y Pull Request.

## 6. Gestión ágil del proyecto (Scrum)

### 6.1. Roles del equipo

| Integrante | Rol Scrum (Sprint) | Enfoque técnico |
|---|---|---|
| Flores Núñez, Rodrigo Francisco | Scrum Master, Sprint 0 y 4 | DevOps, Docker, CI/CD |
| Leon Ramos, Mijael Paul | Scrum Master, Sprint 1 | Frontend, storefront |
| Paredes Miranda, Mauricio Antonio | Scrum Master, Sprint 2 | Documentación técnica |
| Jimenez Paredes, Fabricio Gabriel | Scrum Master, Sprint 3 | Backend, módulos |

Todos los integrantes forman parte del *Development Team*, con responsabilidad compartida en desarrollo, pruebas y documentación.

### 6.2. Product Backlog en GitHub Issues

El Product Backlog completo se registró en GitHub Issues (issue #8, Sprint 1), con un total de **14 issues** distribuidos entre los cuatro sprints:

- **Sprint 1:** 3 issues — infraestructura y documentación base.
- **Sprint 2:** 5 issues — mejoras al módulo de Productos y cierre del sprint.
- **Sprint 3:** 4 issues — módulo de Pedidos y automatizaciones.
- **Sprint 4:** 2 issues — documentación final y artículo IEEE.

Los labels de tipo utilizados fueron: `user-story` (historias de usuario funcionales), `devops` (infraestructura y automatización), `documentacion` (entregables escritos) y `bug` (correcciones). Cada issue lleva además el label de su sprint (`sprint-1` a `sprint-4`).

### 6.3. Sprint Board en GitHub Projects

El tablero Kanban "Medusa Project" está configurado con las columnas **Backlog, Ready, In Progress, In Review y Done**. Cada issue avanza: Backlog (creado) → Ready (seleccionado por el sprint) → In Progress (tomado por un integrante) → In Review (PR abierto) → Done (PR mergeado e issue cerrado).

### 6.4. Ceremonias Scrum

| Ceremonia | Cómo se documentó |
|---|---|
| Sprint Planning | Issue `[SPRINT-N] Planning` con los compromisos del equipo |
| Daily Standup | Comentarios en el issue de Planning |
| Sprint Review | Issues cerrados + capturas publicadas en GitHub Pages |
| Retrospectiva | `docs/retrospectiva-sprint1.md` y `docs/retrospectiva-sprints.md` |

## 7. Estrategia de ramas (GitFlow) y Pull Requests

El equipo adoptó **GitFlow**: cada issue se trabaja en una rama `feature/nombre-tarea` creada desde `main`. Al finalizar, se abre un Pull Request hacia `main`, que debe ser revisado y aprobado por al menos otro integrante antes de mergear. El pipeline de GitHub Actions valida automáticamente cada PR ejecutando `lint`, `build` y `test` sobre la rama en revisión, evitando que código con errores llegue a `main`.

## 8. Mejoras funcionales por sprint

### Sprint 2 — Módulo de Productos
- **Filtrado por categoría:** conectado al endpoint `/store/product-categories` de la API de Medusa; el estado del filtro se maneja con `useSearchParams` de Next.js para reflejar la categoría activa en la URL.
- **Disponibilidad de stock:** lectura de `inventory_quantity` por variante, con tres estados visuales — "En stock" (verde, >5 unidades), "Pocas unidades" (amarillo, 1–5) y "Sin stock" (rojo, deshabilita el botón de compra).

### Sprint 3 — Módulo de Pedidos
- **Estado del pedido en la cuenta del cliente:** se implementó `getFulfillmentStatusInfo`, que traduce el estado interno de Medusa (`not_fulfilled`, `partially_fulfilled`, `fulfilled`, `shipped`, `delivered`, `canceled`, etc.) a una etiqueta y color de badge visibles en la sección "Orders" de la cuenta del cliente.
- **Corrección de advertencias de ESLint:** se resolvieron las advertencias `no-unused-vars` y de dependencias faltantes en `useEffect` heredadas del código base original, mejorando la consistencia de calidad del repositorio.

## 9. Calidad de código

Se utilizó **ESLint**, ejecutado sobre todo el monorepo mediante Turborepo (`turbo lint`), como parte del job `lint` del pipeline. Durante el Sprint 3 se corrigieron sistemáticamente las advertencias heredadas del starter original (variables declaradas y no usadas, dependencias faltantes en hooks de React), dejando el linter en estado limpio (`0 cached, 1 total — 1 successful`).

## 10. Gestión de riesgos

| Riesgo | Probabilidad | Impacto | Mitigación aplicada | Estado |
|---|---|---|---|---|
| Dificultad para configurar el entorno Docker | Alta | Alto | Guía oficial de Medusa; `depends_on: condition: service_healthy` | Resuelto |
| Conflictos de merge en el repositorio compartido | Media | Medio | GitFlow + PR con revisión obligatoria | Controlado |
| Complejidad del codebase TypeScript de Medusa | Alta | Medio | Alcance limitado por módulo; revisión de documentación oficial antes de modificar | Controlado |
| Miembro del equipo no disponible temporalmente | Media | Medio | Tareas documentadas y asignadas individualmente en GitHub Issues | Controlado |
| Pipeline CI/CD fallando en GitHub Actions | Media | Alto | Resolución de lockfile, variables de entorno, campo `http` y `generateStaticParams` | Resuelto |
| Retrasos en la escritura del artículo IEEE | Media | Alto | Redacción distribuida entre los cuatro integrantes en el Sprint 4 | Gestionado |

## 11. Retrospectivas

**Sprint 1 — Qué salió bien:** repositorio y estrategia colaborativa correctamente configurados; pipeline funcionando desde el inicio; división de tareas clara.
**Qué mejorar:** estimaciones de tiempo optimistas, especialmente para la configuración de Docker (lockfile e variables de entorno).
**Qué se hizo diferente:** verificar el entorno local antes de iniciar cada tarea nueva.

**Sprint 2 — Qué salió bien:** filtrado por categoría y visualización de stock implementados correctamente; documentación técnica al día; mayor velocidad de resolución de incidencias gracias a la experiencia del Sprint 1.
**Qué mejorar:** parte de la documentación se concentró al final del sprint.
**Qué se hizo diferente:** documentar cada funcionalidad inmediatamente después de implementarla; reuniones breves de seguimiento.

## 12. Recursos y herramientas

- **Medusa.js** — plataforma principal de comercio electrónico.
- **Next.js** — storefront.
- **PostgreSQL** — sistema gestor de base de datos.
- **Redis** — caché y colas de trabajo.
- **Docker / Docker Compose** — contenedores del entorno local.
- **Git / GitHub** — control de versiones.
- **GitHub Actions** — CI/CD.
- **GitHub Projects** — tablero Kanban/Scrum.
- **GitHub Issues** — Product Backlog y decisiones técnicas.
- **GitHub Pages** — dashboard, documentación y burndown chart.
- **ESLint** — análisis estático de código.
- **Tailwind CSS** — diseño de interfaz.
- **Visual Studio Code** — entorno de desarrollo.
- **Node.js / pnpm** — gestión de dependencias y ejecución.

**Repositorio:** https://github.com/mauricioParedes12/medusa-store-IPS
**Sitio publicado (GitHub Pages):** https://mauricioparedes12.github.io/medusa-store-IPS/

## 13. Conclusiones

- El proceso Scrum + DevOps permitió establecer, en solo cuatro sprints, un flujo de trabajo completo desde la infraestructura técnica hasta la entrega de funcionalidades visibles al usuario final.
- La adopción temprana de un pipeline CI/CD con jobs independientes (`lint`, `build`, `test`, `deploy-pages`) permitió detectar errores antes de que llegaran a la rama principal, reduciendo el riesgo de regresiones.
- La automatización progresiva (burndown chart programado, pruebas de integración conectadas al pipeline) consolidó las prácticas DevOps más allá de la configuración inicial, extendiéndolas hacia la calidad continua del proyecto.
- La gestión disciplinada del Product Backlog en GitHub Issues, junto con el tablero Kanban en GitHub Projects, permitió mantener trazabilidad completa de las 14 tareas del proyecto a lo largo de los cuatro sprints.
- Las retrospectivas realizadas al cierre de cada sprint permitieron ajustar la forma de trabajo del equipo (por ejemplo, verificar el entorno local antes de codear), mejorando la eficiencia en los sprints subsiguientes.
- La resolución iterativa de errores de configuración (Docker, lockfile, variables de entorno, ESLint) dejó como resultado un repositorio reproducible y con estándar de calidad consistente, apto para ser retomado por terceros.

## 14. Referencias

Docker Inc. (2026). *Docker documentation*. https://docs.docker.com/
ESLint. (2026). *ESLint documentation*. https://eslint.org/docs/latest/
Git. (2026). *Git documentation*. https://git-scm.com/doc
GitHub. (2026). *GitHub Actions documentation*. https://docs.github.com/actions
GitHub. (2026). *GitHub Docs*. https://docs.github.com/
GitHub. (2026). *GitHub Projects documentation*. https://docs.github.com/issues/planning-and-tracking-with-projects
Medusa. (2026). *Medusa documentation*. https://docs.medusajs.com/
Microsoft. (2026). *Visual Studio Code documentation*. https://code.visualstudio.com/docs
Next.js. (2026). *Next.js documentation*. https://nextjs.org/docs
Node.js Foundation. (2026). *Node.js documentation*. https://nodejs.org/docs/latest/api/
pnpm. (2026). *pnpm documentation*. https://pnpm.io/motivation
PostgreSQL Global Development Group. (2026). *PostgreSQL documentation*. https://www.postgresql.org/docs/
Redis Ltd. (2026). *Redis documentation*. https://redis.io/docs/latest/
Tailwind Labs. (2026). *Tailwind CSS documentation*. https://tailwindcss.com/docs
