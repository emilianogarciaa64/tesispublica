<template>
    <div class="anexo-wrap">
      <header class="topbar">
        <button type="button" class="btn-azul" @click="goBack">← Regresar</button>
        
       <!-- <span class="muted ms-auto">{{ statusText }}</span>-->
      </header>
  
      <iframe
        v-if="viewerSrc"
        :src="viewerSrc"
        id="viewer"
        class="viewer"
      />
    </div>
  </template>
  
  <!--<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const viewerSrc = ref('')
const statusText = ref('Cargando…')

function goBack() {
  router.back()
}
function goHome() {
  router.push('/main')
}

onMounted(() => {
  const anexoUi = route.query.anexoUi
  if (!anexoUi) {
    statusText.value = 'Falta anexoUi'
    return
  }

  
  viewerSrc.value =
    `/pdfjs/web/viewer-secure.html?type=anexo&ui=${encodeURIComponent(anexoUi)}`

  statusText.value = 'Listo'
})
</script>-->
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
const anexoUiActual = ref(null)
const yaRegistrado = ref(false)

function goBack() {
  router.back()
}

function goHome() {
  router.push('/main')
}

async function onViewerMessage(event) {
  if (event.origin !== window.location.origin) return

  const data = event.data
  if (!data || typeof data !== 'object') return

  const headers = auth.token ? { Authorization: `Bearer ${auth.token}` } : {}

  if (data.type === 'PDF_VIEWER_READY') {
    if (yaRegistrado.value) return
    yaRegistrado.value = true

    statusText.value = 'PDF cargado'

    try {
      await guardarRendimiento(
        {
          accion: 'MOSTRAR_PDF_ANEXO',
          endpoint: '/api/anexoPdf',
          duracion_ms: data.duracion_ms ?? null,
          exito: true,
          status_http: data.status_http ?? 200,
          ui_anexo: data.ui || anexoUiActual.value || null
        },
        headers
      )
    } catch (e) {
      console.error('No se pudo guardar rendimiento del visor PDF:', e)
    }
  }

  if (data.type === 'PDF_VIEWER_ERROR') {
    statusText.value = 'Error al cargar PDF'

    try {
      await guardarRendimiento(
        {
          accion: 'MOSTRAR_PDF_ANEXO',
          endpoint: '/api/anexoPdf',
          duracion_ms: null,
          exito: false,
          status_http: data.status ?? null,
          ui_anexo: data.ui || anexoUiActual.value || null,
          detalle_error: data.detail || null
        },
        headers
      )
    } catch (e) {
      console.error('No se pudo guardar error de visor PDF:', e)
    }
  }
}

onMounted(() => {
  window.addEventListener('message', onViewerMessage)

  const anexoUi = route.query.anexoUi
  if (!anexoUi) {
    statusText.value = 'Falta anexoUi'
    return
  }

  anexoUiActual.value = String(anexoUi)
  yaRegistrado.value = false

  viewerSrc.value =
    `/pdfjs/web/viewer-secure.html?type=anexo&ui=${encodeURIComponent(anexoUi)}`

  statusText.value = 'Cargando…'
})

onBeforeUnmount(() => {
  window.removeEventListener('message', onViewerMessage)
})
</script>

  
  <style scoped>
  .anexo-wrap {
    height: 100vh;
    display: flex;
    flex-direction: column;
    background: #f5f7fb;
  }
  
  .topbar {
    display: flex;
    gap: 8px;
    align-items: center;
    padding: 10px;
    background: #003366;
    color: #fff;
    position: sticky;
    top: 0;
    z-index: 2;
  }
  
  .btn-azul {
    background: #00509e;
    color: #fff;
    border: none;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    text-decoration: none;
  }
  .btn-azul:hover { background:#1a6ad1; }
  
  .viewer {
    width: 100%;
    height: calc(100vh - 56px);
    border: 0;
  }
  
  .muted { opacity:.85; font-size:.9rem; }
  .ms-auto { margin-left: auto; }
  </style>
  