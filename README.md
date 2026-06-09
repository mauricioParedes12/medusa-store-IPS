#  Documentación Técnica - MedusaIPS

## 1. Descripción del Producto
**Medusa DTC Starter** es una implementación de referencia para comercio electrónico Direct-to-Consumer. Se seleccionó este producto por su arquitectura modular y su capacidad de despliegue mediante contenedores.

* **Líneas de Código (Ecosistema):** +250,000 (Core) / +15,000 (Starter).
* **Stack:** Node.js v20, PostgreSQL v15, Redis, Next.js.

## 2. Arquitectura de Infraestructura (DevOps)
El proyecto utiliza **Docker Compose** para orquestar los servicios necesarios, garantizando que el entorno de desarrollo sea idéntico al de producción/staging.

### Servicios Orquestados:
1.  **medusa-server:** Motor principal (API).
2.  **medusa-db:** Base de datos relacional (PostgreSQL).
3.  **medusa-redis:** Manejo de eventos y caché.

## 3. Plan de Proyecto e Hitos
De acuerdo al **Cronograma del Hito 01**:
* **Sprint 0:** Configuración de entorno y planificación.
* **Sprint 1-2 (Actual):** Mejora del Módulo de Productos y CI/CD.
* **Sprint 3-4:** Módulo de Pedidos, Tests y Métricas finales.

## 4. Guía de Ejecución Local
```bash
# Clonar y levantar
git clone [https://github.com/mauricioParedes12/medusa-store-IPS.git](https://github.com/mauricioParedes12/medusa-store-IPS.git)
docker-compose up -d
```

## 5. Documentación

La documentación técnica del proyecto se encuentra disponible en la carpeta `docs`.

### Documentos disponibles

#### Arquitectura del Sistema
Descripción de la arquitectura general del proyecto, componentes principales y relaciones entre los servicios.

 [Ver documentación](docs/arquitectura.md)

#### Módulo de Productos
Descripción de las mejoras implementadas durante el Sprint 2:

- Filtrado de productos por categoría.
- Visualización de disponibilidad de stock.
- Flujo de datos entre el storefront y la API de Medusa.

 [Ver documentación](docs/modulo-productos.md)

#### Retrospectiva de Sprints
Registro de las lecciones aprendidas y oportunidades de mejora identificadas durante el desarrollo del proyecto.

- Sprint 1.
- Sprint 2.
- Acciones de mejora continua.

 [Ver documentación](docs/retrospectiva-sprints.md)

![CI/CD Pipeline](https://github.com/mauricioParedes12/medusa-store-IPS/actions/workflows/ci.yml/badge.svg)
