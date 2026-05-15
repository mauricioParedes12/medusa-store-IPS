# 📚 Documentación Técnica - MedusaIPS

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
* **Sprint 0 (Actual):** Configuración de entorno y planificación.
* **Sprint 1-2:** Mejora del Módulo de Productos y CI/CD.
* **Sprint 3-4:** Módulo de Pedidos, Tests y Métricas finales.

## 4. Guía de Ejecución Local
```bash
# Clonar y levantar
git clone [https://github.com/mauricioParedes12/medusa-store-IPS.git](https://github.com/mauricioParedes12/medusa-store-IPS.git)
docker-compose up -d