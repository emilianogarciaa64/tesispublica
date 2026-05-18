<template>
  
    <Button
      icon="pi pi-question-circle"
      class="p-button-rounded p-button-text btn-ayuda"
      @click="visible = true"
      :aria-label="tooltip"
      v-tooltip.top="tooltip"
    />

    <Dialog
      v-model:visible="visible"
      :header="titulo"
      modal
      :style="{ width: '30rem', maxWidth: '95vw' }"
      :pt="{
        root: { class: 'dialog-ayuda-root' },
        header: { class: 'dialog-ayuda-header' },
        title: { class: 'dialog-ayuda-title' },
        content: { class: 'dialog-ayuda-content' },
        pcCloseButton: { class: 'dialog-ayuda-close' }
      }"
    >
      <div class="ayuda-contenido">
        <p v-if="texto">{{ texto }}</p>

        <div v-if="items && items.length" class="mb-3">
          <ul>
            <li v-for="(item, index) in items" :key="index">
              {{ item }}
            </li>
          </ul>
        </div>

        <a
          v-if="linkUrl"
          :href="linkUrl"
          target="_blank"
          rel="noopener noreferrer"
        >
          {{ linkLabel || 'Ver más información' }}
        </a>
      </div>
    </Dialog>
  
</template>

<script setup>
import { ref } from 'vue'
import Button from 'primevue/button'
import Dialog from 'primevue/dialog'

const visible = ref(false)

defineProps({
  titulo: {
    type: String,
    default: 'Ayuda'
  },
  texto: {
    type: String,
    default: ''
  },
  items: {
    type: Array,
    default: () => []
  },
  linkUrl: {
    type: String,
    default: ''
  },
  linkLabel: {
    type: String,
    default: ''
  },
  tooltip: {
    type: String,
    default: 'Ayuda'
  }
})
</script>

<style>
.btn-ayuda {
  background-color: #00196f!important;
  color: #ffffff !important;
  border: 1px solid #000000 !important;
  width: 42px;
  height: 42px;
}

.dialog-ayuda-root {
  background: #ffffff !important;
  color: #000000 !important;
}

.dialog-ayuda-header {
  background: #ffffff !important;
  color: #000000 !important;
  border-bottom: 1px solid #ddd !important;
}

.dialog-ayuda-title {
  color: #000000 !important;
}

.dialog-ayuda-content {
  background: #ffffff !important;
  color: #000000 !important;
}

.dialog-ayuda-content p,
.dialog-ayuda-content li,
.dialog-ayuda-content ul,
.dialog-ayuda-content div {
  color: #000000 !important;
}

.dialog-ayuda-content a {
  color: #0d6efd !important;
}

.dialog-ayuda-close {
  color: #000000 !important;
}
</style>