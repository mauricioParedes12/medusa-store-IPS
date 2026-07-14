import { medusaIntegrationTestRunner } from "@medusajs/test-utils"

medusaIntegrationTestRunner({
  testSuite: ({ api }) => {
    describe("Health check", () => {
      it("responde correctamente en GET /health", async () => {
        const response = await api.get(`/health`)

        expect(response.status).toEqual(200)
      })
    })
  },
})

jest.setTimeout(180 * 1000)