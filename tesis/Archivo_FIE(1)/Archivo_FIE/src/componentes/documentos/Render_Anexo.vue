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
  
  <script setup>
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
  