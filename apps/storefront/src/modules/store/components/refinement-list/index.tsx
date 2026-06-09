"use client"

import { HttpTypes } from "@medusajs/types"
import { usePathname, useRouter, useSearchParams } from "next/navigation"
import { useCallback } from "react"
import SortProducts, { SortOptions } from "./sort-products"

type RefinementListProps = {
  sortBy: SortOptions
  categories?: HttpTypes.StoreProductCategory[]
  selectedCategory?: string
  "data-testid"?: string
}

const RefinementList = ({
  sortBy,
  categories,
  selectedCategory,
  "data-testid": dataTestId,
}: RefinementListProps) => {
  const router = useRouter()
  const pathname = usePathname()
  const searchParams = useSearchParams()

  const createQueryString = useCallback(
    (name: string, value: string) => {
      const params = new URLSearchParams(searchParams)
      params.set(name, value)
      return params.toString()
    },
    [searchParams]
  )

  const setQueryParams = (name: string, value: string) => {
    const query = createQueryString(name, value)
    router.push(`${pathname}?${query}`)
  }

  const clearCategory = () => {
    const params = new URLSearchParams(searchParams)
    params.delete("category")
    router.push(`${pathname}?${params.toString()}`)
  }

  return (
    <div className="flex small:flex-col gap-12 py-4 mb-8 small:px-0 pl-6 small:min-w-[250px] small:ml-[1.675rem]">
      <SortProducts
        sortBy={sortBy}
        setQueryParams={setQueryParams}
        data-testid={dataTestId}
      />

      {categories && categories.length > 0 && (
        <div className="flex flex-col gap-y-3">
          <span className="text-base-semi">Categories</span>
          <ul className="flex flex-col gap-y-2 text-base-regular">
            <li>
              <button
                onClick={clearCategory}
                className={`hover:text-ui-fg-base transition-colors ${
                  !selectedCategory
                    ? "text-ui-fg-base font-semibold"
                    : "text-ui-fg-subtle"
                }`}
              >
                All
              </button>
            </li>
            {categories.map((cat) => (
              <li key={cat.id}>
                <button
                  onClick={() => setQueryParams("category", cat.handle)}
                  className={`hover:text-ui-fg-base transition-colors ${
                    selectedCategory === cat.handle
                      ? "text-ui-fg-base font-semibold"
                      : "text-ui-fg-subtle"
                  }`}
                >
                  {cat.name}
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}

export default RefinementList