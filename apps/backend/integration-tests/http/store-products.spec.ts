import { medusaIntegrationTestRunner } from "@medusajs/test-utils"
import { ApiKeyDTO } from "@medusajs/framework/types"
import {
  createApiKeysWorkflow,
  createSalesChannelsWorkflow,
  linkSalesChannelsToApiKeyWorkflow,
} from "@medusajs/medusa/core-flows"

medusaIntegrationTestRunner({
  testSuite: ({ api, getContainer }) => {
    describe("Store: Productos", () => {
      let publishableKey: ApiKeyDTO

      beforeEach(async () => {
        const container = getContainer()

        publishableKey = (
          await createApiKeysWorkflow(container).run({
            input: {
              api_keys: [
                {
                  type: "publishable",
                  title: "Test Key - Productos",
                  created_by: "",
                },
              ],
            },
          })
        ).result[0]

        const salesChannel = (
          await createSalesChannelsWorkflow(container).run({
            input: {
              salesChannelsData: [
                {
                  name: "Test Sales Channel - Productos",
                },
              ],
            },
          })
        ).result[0]

        await linkSalesChannelsToApiKeyWorkflow(container).run({
          input: {
            id: publishableKey.id,
            add: [salesChannel.id],
          },
        })
      })

      describe("GET /store/products", () => {
        it("retorna 200 y una lista de productos", async () => {
          const response = await api.get("/store/products", {
            headers: {
              "x-publishable-api-key": publishableKey.token,
            },
          })

          expect(response.status).toEqual(200)
          expect(response.data).toHaveProperty("products")
          expect(Array.isArray(response.data.products)).toBe(true)
        })
      })

      describe("GET /store/product-categories", () => {
        it("retorna 200 y una lista de categorías", async () => {
          const response = await api.get("/store/product-categories", {
            headers: {
              "x-publishable-api-key": publishableKey.token,
            },
          })

          expect(response.status).toEqual(200)
          expect(response.data).toHaveProperty("product_categories")
          expect(Array.isArray(response.data.product_categories)).toBe(true)
        })
      })
    })
  },
})

jest.setTimeout(180 * 1000)
