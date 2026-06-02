# Arquitectura Técnica del Sistema
**Proyecto:** Medusa Store IPS  
**Curso:** Ingeniería y Procesos de Software — UNSA 2026  
**Grupo 03:** Flores · Jimenez · Paredes · Leon  

---

## Tabla de Contenidos

1. [Descripción general del sistema](#1-descripción-general-del-sistema)
2. [Stack tecnológico](#2-stack-tecnológico)
3. [Diagrama de arquitectura](#3-diagrama-de-arquitectura)
4. [Módulo de Productos](#4-módulo-de-productos)
5. [Módulo de Pedidos](#5-módulo-de-pedidos)
6. [Módulo de Clientes](#6-módulo-de-clientes)
7. [Módulo de Pagos](#7-módulo-de-pagos)
8. [Módulo de Envíos](#8-módulo-de-envíos)
9. [Infraestructura y entorno de desarrollo](#9-infraestructura-y-entorno-de-desarrollo)
10. [Referencias](#10-referencias)

---

## 1. Descripción general del sistema

El proyecto está basado en el repositorio Medusa DTC Starter, una plataforma de comercio electrónico de tipo Direct-to-Consumer desarrollada y mantenida por el equipo oficial de MedusaJS. La arquitectura del sistema es de tipo headless, lo que significa que el backend y el frontend son aplicaciones completamente independientes que se comunican entre sí a través de una API REST.

El código fuente está organizado como un monorepo utilizando pnpm workspaces y Turborepo, lo que permite gestionar las tres aplicaciones del sistema desde un único repositorio sin que una dependa directamente del código de la otra.

Las tres aplicaciones que conforman el sistema son las siguientes:

| Aplicación | Tecnología | Puerto | Función |
|---|---|---|---|
| Backend | Node.js + TypeScript + Medusa v2 | 9000 | API REST y lógica de negocio |
| Storefront | Next.js 14 + React | 8000 | Tienda pública para clientes |
| Admin Dashboard | React (incluido en Medusa) | 9000/app | Panel de administración interno |

---

## 2. Stack tecnológico

| Capa | Tecnología |
|---|---|
| Runtime | Node.js v20 |
| Lenguaje | TypeScript 5.x |
| Framework backend | MedusaJS v2 |
| Framework frontend | Next.js 14 con App Router |
| Librería de UI | React 19 |
| Base de datos | PostgreSQL 15 |
| Caché y colas | Redis 7 |
| Gestor de paquetes | pnpm v10 con workspaces |
| Orquestador de build | Turborepo v2 |
| Contenedores | Docker y Docker Compose |
| CI/CD | GitHub Actions |
| Hosting del sitio estático | GitHub Pages |
| Licencia | MIT |

---

## 3. Diagrama de arquitectura

El sistema está organizado en tres capas: presentación, negocio y datos. Las capas de presentación y negocio se comunican mediante HTTP, y la capa de negocio accede a los datos directamente.

```
Capa de presentación
-------------------------------------------------------------
  Storefront (Next.js)          Admin Dashboard (React)
  Puerto 8000                   Puerto 9000/app
       |                               |
       |-------- HTTP / REST API -------|
                      |
Capa de negocio
-------------------------------------------------------------
              Backend Medusa (Node.js)
                    Puerto 9000
        ------------------------------------------
        | Productos | Pedidos | Clientes | Pagos |
        ------------------------------------------
                      |
Capa de datos
-------------------------------------------------------------
   PostgreSQL 15              Redis 7
   Puerto 5432                Puerto 6379
   (datos principales)        (caché y colas de trabajo)
```

---

## 4. Módulo de Productos

Este módulo es el núcleo del catálogo de la tienda. Se encarga de gestionar toda la información relacionada con los artículos disponibles para la venta, incluyendo sus variantes, precios e inventario disponible.

**Responsabilidades principales:**

- Gestionar el catálogo de productos con sus metadatos: nombre, descripción e imágenes.
- Administrar las variantes de cada producto, como combinaciones de talla y color.
- Controlar el inventario disponible por variante.
- Definir precios por región y lista de precios.
- Organizar los productos en categorías y colecciones.

**Estructura de datos:**

```
Producto
├── id, title, description, handle
├── thumbnail, images[]
├── status: draft | published
├── categories[]
├── variants[]
│   ├── id, title, sku
│   ├── prices[]
│   └── inventory_quantity
└── collection
```

**Endpoints principales (API de tienda):**

| Método | Ruta | Descripción |
|---|---|---|
| GET | /store/products | Listar productos publicados |
| GET | /store/products/:id | Detalle de un producto |
| GET | /store/product-categories | Listar categorías disponibles |
| GET | /store/collections | Listar colecciones |

**Mejoras planificadas para el Sprint 2:**

- Filtrado de productos por categoría en el storefront.
- Visualización del stock disponible por variante en la página de detalle del producto.

---

## 5. Módulo de Pedidos

Este módulo gestiona el ciclo de vida completo de una orden de compra, desde que el cliente finaliza el checkout hasta la entrega del producto y las posibles devoluciones.

**Responsabilidades principales:**

- Crear y procesar órdenes de compra a partir del carrito del cliente.
- Gestionar los cambios de estado del pedido a lo largo del proceso.
- Coordinar el fulfillment, es decir, la preparación y el despacho del pedido.
- Procesar devoluciones y reembolsos cuando corresponde.

**Ciclo de vida de un pedido:**

```
Carrito -> Checkout -> PENDIENTE
                           |
                      EN PROCESO  (pago confirmado)
                           |
                        ENVIADO    (fulfillment creado)
                           |
                       ENTREGADO
                           |
                 DEVUELTO / COMPLETADO
```

**Endpoints principales (API de tienda):**

| Método | Ruta | Descripción |
|---|---|---|
| GET | /store/orders | Historial de pedidos del cliente |
| GET | /store/orders/:id | Detalle de un pedido |
| POST | /store/carts/:id/complete | Completar el checkout y crear la orden |

**Mejoras planificadas para el Sprint 3:**

- Visualización del estado de los pedidos en la sección de cuenta del cliente en el storefront.

---

## 6. Módulo de Clientes

Este módulo gestiona el registro, la autenticación y el perfil de los usuarios de la tienda.

**Responsabilidades principales:**

- Registro e inicio de sesión de clientes.
- Gestión del perfil y los datos personales del cliente.
- Administración de las direcciones de envío guardadas.
- Acceso al historial de compras del cliente.

**Estructura de datos:**

```
Cliente
├── id, email, first_name, last_name
├── phone, has_account
├── addresses[]
│   ├── address_1, city, country_code
│   └── is_default_shipping, is_default_billing
└── groups[]
```

**Endpoints principales (API de tienda):**

| Método | Ruta | Descripción |
|---|---|---|
| POST | /store/customers | Registrar un nuevo cliente |
| POST | /auth/customer/emailpass | Iniciar sesión |
| GET | /store/customers/me | Perfil del cliente autenticado |
| POST | /store/customers/me/addresses | Agregar una dirección |

---

## 7. Módulo de Pagos

Este módulo actúa como intermediario entre la plataforma y los proveedores de pago externos. En el entorno de desarrollo del proyecto se utiliza el proveedor simulado que incluye Medusa por defecto, sin integración con pasarelas reales.

**Responsabilidades principales:**

- Iniciar y confirmar sesiones de pago vinculadas al carrito.
- Gestionar autorizaciones y capturas de fondos.
- Manejar los reembolsos asociados a devoluciones.
- Soportar múltiples proveedores de pago según la región.

**Proveedores configurados en el proyecto:**

| Proveedor | Entorno | Estado en el proyecto |
|---|---|---|
| pp_system_default | Desarrollo / simulado | Activo para pruebas |
| Stripe | Producción | Fuera del alcance del proyecto |
| PayPal | Producción | Fuera del alcance del proyecto |

**Endpoints principales (API de tienda):**

| Método | Ruta | Descripción |
|---|---|---|
| POST | /store/payment-collections | Crear una colección de pago |
| POST | /store/payment-collections/:id/sessions | Iniciar una sesión de pago |
| POST | /store/carts/:id/complete | Confirmar el pago y crear la orden |

La integración con pasarelas de pago reales está fuera del alcance definido en el plan del proyecto. Solo se trabaja con el proveedor simulado para el entorno de desarrollo y pruebas.

---

## 8. Módulo de Envíos

Este módulo gestiona los métodos de entrega disponibles, el cálculo de tarifas y la coordinación con los proveedores logísticos.

**Responsabilidades principales:**

- Definir los métodos de envío disponibles por región.
- Calcular las tarifas de envío durante el proceso de checkout.
- Gestionar las zonas geográficas de envío configuradas.

**Endpoints principales (API de tienda):**

| Método | Ruta | Descripción |
|---|---|---|
| GET | /store/shipping-options | Opciones de envío disponibles |
| POST | /store/carts/:id/shipping-methods | Seleccionar un método de envío |

La modificación de este módulo está fuera del alcance del proyecto en los sprints actuales, según lo definido en el plan del Hito 01.

---

## 9. Infraestructura y entorno de desarrollo

**Levantar el entorno local:**

El entorno completo se levanta con un solo comando desde la raíz del repositorio:

```bash
docker-compose up
```

Los servicios que se inician son los siguientes:

| Servicio | Imagen | Puerto | Descripción |
|---|---|---|---|
| postgres | postgres:15-alpine | 5432 | Base de datos principal |
| redis | redis:7-alpine | 6379 | Caché y colas |
| medusa | build local | 9000, 5173 | Backend y panel admin |
| storefront | build local | 8000 | Storefront Next.js |

**Pipeline CI/CD:**

El archivo `.github/workflows/ci.yml` define el pipeline de integración continua que se ejecuta automáticamente en cada push a las ramas `main` y `develop`:

```
Push a main o develop
        |
   [Lint] pnpm lint via Turborepo
        |
   [Build] pnpm build    [Test] con Postgres + Redis reales
        |
   [Deploy Pages] solo en push a main
```

**Estructura del repositorio:**

```
medusa-store-IPS/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── burndown.yml         (Sprint 3)
├── apps/
│   ├── backend/                 (Medusa backend)
│   │   ├── src/
│   │   ├── medusa-config.ts
│   │   └── .env
│   └── storefront/              (Next.js storefront)
│       ├── src/
│       └── .env.local
├── docs/
│   ├── arquitectura.md
│   ├── modulo-productos.md      (Sprint 2)
│   ├── modulo-pedidos.md        (Sprint 3)
│   ├── retrospectiva-sprint1.md (Sprint 2)
│   ├── devops-proceso.md        (Sprint 4)
│   └── articulo-ieee.pdf        (Sprint 4)
├── docker-compose.yml
├── turbo.json
├── package.json
└── index.html
```

---

## 10. Referencias

- MedusaJS. (2025). Documentación oficial MedusaJS v2. https://docs.medusajs.com
- MedusaJS. (2025). Repositorio medusajs/dtc-starter. https://github.com/medusajs/dtc-starter
- GitHub. (2025). GitHub Actions Documentation. https://docs.github.com/en/actions
- Turborepo. (2025). CI con GitHub Actions. https://turbo.build/repo/docs/ci/github-actions
- Schwaber, K. & Sutherland, J. (2020). The Scrum Guide. https://scrumguides.org

---

*Documento generado para el Hito 02 — Grupo 03 — UNSA 2026*
