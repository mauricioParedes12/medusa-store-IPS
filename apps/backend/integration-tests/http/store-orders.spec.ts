import { medusaIntegrationTestRunner } from "@medusajs/test-utils"
import { ApiKeyDTO } from "@medusajs/framework/types"
import { createApiKeysWorkflow } from "@medusajs/medusa/core-flows"

medusaIntegrationTestRunner({
  testSuite: ({ api, getContainer }) => {
    describe("Store: Pedidos", () => {
      let publishableKey: ApiKeyDTO

      beforeAll(async () => {
        publishableKey = (
          await createApiKeysWorkflow(getContainer()).run({
            input: {
              api_keys: [
                {
                  type: "publishable",
                  title: "Test Key - Pedidos",
                  created_by: "",
                },
              ],
            },
          })
        ).result[0]
      })

      describe("GET /store/orders", () => {
        it("rechaza la solicitud sin un cliente autenticado (401)", async () => {
          await expect(
            api.get("/store/orders", {
              headers: {
                "x-publishable-api-key": publishableKey.token,
              },
            })
          ).rejects.toMatchObject({
            response: {
              status: 401,
            },
          })
        })
      })
    })
  },
})

jest.setTimeout(180 * 1000)