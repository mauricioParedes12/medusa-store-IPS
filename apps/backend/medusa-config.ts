// apps/backend/medusa-config.ts
import { loadEnv, defineConfig } from "@medusajs/framework/utils"

loadEnv(process.env.NODE_ENV || "development", process.cwd())

module.exports = defineConfig({
  projectConfig: {
    databaseDriverOptions: {
      ssl: false,
      sslmode: "disable",
    },
  },
  admin: {
    vite: (config) => ({
      server: {
        host: "0.0.0.0",
        allowedHosts: ["localhost", ".localhost", "127.0.0.1"],
        hmr: {
          port: 5173,
          clientPort: 5173,
        },
      },
    }),
  },
})