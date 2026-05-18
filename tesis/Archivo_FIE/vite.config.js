/* import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
}) */
  import { fileURLToPath, URL } from 'node:url'
  import { defineConfig } from 'vite'
  import vue from '@vitejs/plugin-vue'
  import vueDevTools from 'vite-plugin-vue-devtools'
  
  export default defineConfig({
    plugins: [
      vue(),
      vueDevTools(),
    ],
    resolve: {
      alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) }
    },
    server: {
      proxy: {
        // proxea todo lo de /api y /pdfs al backend node (3000)
        '/api': { target: 'http://localhost:3000', changeOrigin: true },
        '/pdfs': { target: 'http://localhost:3000', changeOrigin: true },
        '/pdfjs': { target: 'http://localhost:3000', changeOrigin: true },
      }
    }
  })
  