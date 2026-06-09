# Módulo de Productos — Sprint 2

Documentación de las mejoras implementadas al módulo de productos durante el Sprint 2.

---

## Mejora 1: Filtrado por categoría

### Descripción
Se agregó un panel lateral en la página `/store` que permite al usuario filtrar productos por categoría. Las categorías se obtienen dinámicamente desde la API de Medusa y se reflejan en la URL mediante query params, lo que permite compartir links filtrados y mantener el estado al navegar.

### Archivos modificados
- `apps/storefront/src/app/[countryCode]/(main)/store/page.tsx`
- `apps/storefront/src/modules/store/templates/index.tsx`
- `apps/storefront/src/modules/store/components/refinement-list/index.tsx`

### Flujo de datos
```
Usuario selecciona categoría
  → URL actualizada con ?category=handle
  → store/page.tsx lee el param y llama listCategories()
  → StoreTemplate busca el id de la categoría activa
  → PaginatedProducts recibe categoryId y filtra
  → GET /store/products?category_id[]=pcat_xxx
  → Medusa retorna solo productos de esa categoría
  → Título de la página cambia al nombre de la categoría
```

### Fragmento clave — `store/page.tsx`
```tsx
const categories = await listCategories()

return (
  <StoreTemplate
    sortBy={sortBy}
    page={page}
    countryCode={params.countryCode}
    categories={categories}
    selectedCategory={category}
  />
)
```

### Fragmento clave — `refinement-list/index.tsx`
```tsx
{categories.map((cat) => (
  <li key={cat.id}>
    <button
      onClick={() => setQueryParams("category", cat.handle)}
      className={selectedCategory === cat.handle
        ? "text-ui-fg-base font-semibold"
        : "text-ui-fg-subtle"}
    >
      {cat.name}
    </button>
  </li>
))}
```

### Categorías disponibles en el sistema

| ID | Handle | Nombre |
|----|--------|--------|
| pcat_01KRP28VC7ZVY9CN2S3YR55QK4 | shirts | Shirts |
| pcat_01KRP28VC9S5A6KKDZCBQ7DTM6 | sweatshirts | Sweatshirts |
| pcat_01KRP28VCAANFJ2EQ3SMSMSMCE | pants | Pants |
| pcat_01KRP28VCBH1WA2NFZAJPFF446 | merch | Merch |

---

## Mejora 2: Disponibilidad de stock en página de producto

### Descripción
Se muestra un indicador visual en la página de detalle del producto informando al usuario si la variante seleccionada tiene stock disponible. El indicador aparece únicamente cuando el usuario ha seleccionado una variante, y el botón "Add to cart" se deshabilita automáticamente si no hay stock.

### Archivos modificados
- `apps/storefront/src/modules/products/components/product-actions/index.tsx`

### Flujo de datos
```
Usuario selecciona una variante (talla, color, etc.)
  → selectedVariant se recalcula (useMemo)
  → inStock evalúa tres condiciones en orden:
      1. manage_inventory = false → siempre en stock
      2. allow_backorder = true   → siempre en stock
      3. inventory_quantity > 0   → en stock
  → Indicador visual actualiza color y texto
  → Botón Add to cart se habilita o deshabilita
```

### Lógica de stock — `product-actions/index.tsx`
```tsx
const inStock = useMemo(() => {
  // Si no se gestiona inventario, siempre disponible
  if (selectedVariant && !selectedVariant.manage_inventory) return true

  // Si permite backorder, siempre disponible
  if (selectedVariant?.allow_backorder) return true

  // Si hay unidades disponibles
  if (
    selectedVariant?.manage_inventory &&
    (selectedVariant?.inventory_quantity || 0) > 0
  ) return true

  return false
}, [selectedVariant])
```

### Indicador visual agregado
```tsx
{selectedVariant && (
  <div className="flex items-center gap-x-2 text-sm">
    <span
      className={`w-2 h-2 rounded-full ${
        inStock ? "bg-green-500" : "bg-red-400"
      }`}
    />
    <span className={inStock ? "text-green-700" : "text-red-500"}>
      {inStock ? "In stock" : "Out of stock"}
    </span>
  </div>
)}
```

---

## API de Medusa utilizada

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/store/product-categories` | GET | Lista todas las categorías con sus productos y subcategorías |
| `/store/products?category_id[]=id` | GET | Filtra productos por categoría |
| `/store/products/:handle` | GET | Detalle de producto incluyendo `inventory_quantity` por variante |

### Ejemplo de request con filtro de categoría
```
GET /store/products?category_id[0]=pcat_01KRP28VC7ZVY9CN2S3YR55QK4
    &region_id=reg_01KRP28V175V9S2VPN17E9E12C
    &fields=+variants.inventory_quantity,+variants.calculated_price
    &order=created_at
```

---

## Referencias

- [Medusa Docs — Product Categories](https://docs.medusajs.com/resources/storefront-development/products/categories)
- [Repositorio del proyecto](https://github.com/mauricioParedes12/medusa-store-IPS)
