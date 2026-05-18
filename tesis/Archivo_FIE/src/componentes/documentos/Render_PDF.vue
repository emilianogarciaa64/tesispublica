<!--<template>
    <div class="render-wrap">
      <header class="topbar">
        <button type="button" class="btn-azul" @click="goBack">← Regresar</button>
        
      </header>
  
      <iframe
        v-if="viewerSrc"
        :src="viewerSrc"
        id="pdfFrame"
        style="border:none"
        width="100%"
        height="100%"
      ></iframe>
  
      <div v-else class="loading">Cargando PDF…</div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import { useRoute, RouterLink } from 'vue-router'
  import axios from 'axios'
  import { useAuthStore } from '@/stores/counter'
  
  const route = useRoute()
  const auth = useAuthStore()
  
  const viewerSrc = ref('')
  const pdfUrl = ref('')
  const statusText = ref('Cargando…')
  import { useRouter } from 'vue-router'
const router = useRouter()
function goBack() {
  router.back() // equivale a history.go(-1)
}
  
  onMounted(async () => {
  const docId = route.query.docId
  const search = route.query.search || ''
  if (!docId) {
    statusText.value = 'Falta docId'
    alert('Necesitas pasar docId en la URL')
    return
  }

  try {
    // Ya NO llamas /api/getPDFUrl
    // Ya NO guardas pdfUrl público

    const viewerBase = '/pdfjs/web/viewer-secure.html'
    const qs = `?docId=${encodeURIComponent(docId)}&search=${encodeURIComponent(search)}`
    viewerSrc.value = viewerBase + qs

    statusText.value = 'Listo'
  } catch (e) {
    console.error(e)
    statusText.value = 'Error cargando PDF'
    alert('No se pudo cargar el PDF')
  }
})

  </script>
  
  <style scoped>
  .render-wrap { width:100%; height:100vh; background:#f5f7fb; }
  .topbar {
    display:flex; gap:8px; align-items:center;
    padding:10px; background:#003366; color:#fff; position:sticky; top:0; z-index:10;
  }
  .btn-azul {
    background:#00509e; color:#fff; border:none; padding:8px 12px;
    border-radius:6px; cursor:pointer; text-decoration:none; display:inline-flex; align-items:center;
  }
  .btn-azul:hover { background:#1a6ad1; color:#fff; }
  .muted { margin-left:auto; opacity:.9; font-size:.9rem; }
  .loading {
    height: calc(100vh - 56px);
    display:flex; align-items:center; justify-content:center;
    color:#003366; font-size:1.1rem;
  }
  </style>
  -->

  <template>
  <div class="render-wrap">
    <header class="topbar">
      <button type="button" class="btn-azul" @click="goBack">← Regresar</button>
      <!-- <span class="muted">{{ statusText }}</span> -->
    </header>

    <iframe
      v-if="viewerSrc"
      :src="viewerSrc"
      id="pdfFrame"
      style="border:none"
      width="100%"
      height="100%"
    ></iframe>

    <div v-else class="loading">Cargando PDF…</div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/counter'
import { guardarRendimiento } from '@/services/rendimientoService'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const viewerSrc = ref('')
const statusText = ref('Cargando…')
const docIdActual = ref(null)
const yaRegistrado = ref(false)

function goBack() {
  router.back()
}

async function onViewerMessage(event) {
  if (event.origin !== window.location.origin) return

  const data = event.data
  if (!data || typeof data !== 'object') return

  const headers = auth.token ? { Authorization: `Bearer ${auth.token}` } : {}

  if (data.type === 'PDF_VIEWER_READY' && data.pdfType === 'principal') {
    if (yaRegistrado.value) return
    yaRegistrado.value = true

    statusText.value = 'PDF cargado'

    try {
      await guardarRendimiento(
        {
          accion: 'MOSTRAR_PDF_ACTA',
          endpoint: '/api/pdf',
          duracion_ms: data.duracion_ms ?? null,
          exito: true,
          status_http: data.status_http ?? 200,
          doc_id: data.docId || docIdActual.value || null
        },
        headers
      )
    } catch (e) {
      console.error('No se pudo guardar rendimiento del PDF principal:', e)
    }
  }

  if (data.type === 'PDF_VIEWER_ERROR' && data.pdfType === 'principal') {
    statusText.value = 'Error al cargar PDF'

    try {
      await guardarRendimiento(
        {
          accion: 'MOSTRAR_PDF_PRINCIPAL',
          endpoint: '/api/pdf',
          duracion_ms: null,
          exito: false,
          status_http: data.status ?? null,
          doc_id: data.docId || docIdActual.value || null,
          detalle_error: data.detail || null
        },
        headers
      )
    } catch (e) {
      console.error('No se pudo guardar error del PDF principal:', e)
    }
  }
}

onMounted(() => {
  window.addEventListener('message', onViewerMessage)

  const docId = route.query.docId
  const search = route.query.search || ''

  if (!docId) {
    statusText.value = 'Falta docId'
    alert('Necesitas pasar docId en la URL')
    return
  }

  docIdActual.value = String(docId)
  yaRegistrado.value = false

  const viewerBase = '/pdfjs/web/viewer-secure.html'
  const qs = `?docId=${encodeURIComponent(docId)}&search=${encodeURIComponent(search)}`
  viewerSrc.value = viewerBase + qs

  statusText.value = 'Cargando PDF…'
})

onBeforeUnmount(() => {
  window.removeEventListener('message', onViewerMessage)
})
</script>

<style scoped>
.render-wrap { width:100%; height:100vh; background:#f5f7fb; }
.topbar {
  display:flex; gap:8px; align-items:center;
  padding:10px; background:#003366; color:#fff; position:sticky; top:0; z-index:10;
}
.btn-azul {
  background:#00509e; color:#fff; border:none; padding:8px 12px;
  border-radius:6px; cursor:pointer; text-decoration:none; display:inline-flex; align-items:center;
}
.btn-azul:hover { background:#1a6ad1; color:#fff; }
.muted { margin-left:auto; opacity:.9; font-size:.9rem; }
.loading {
  height: calc(100vh - 56px);
  display:flex; align-items:center; justify-content:center;
  color:#003366; font-size:1.1rem;
}
</style>