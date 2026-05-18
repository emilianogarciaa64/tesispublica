<template>
  <div class="panel-wrap" :style="bgStyle">
    <br></br>
    <br></br>
    <br></br>
    <br></br>
    <!-- Controles -->
    <div class="controls d-flex justify-content-center gap-2">
      <Button label="← Anterior" class="btn-blue" :disabled="!hasLeft()" @click="movePrev" />
      <Button label="Siguiente →" class="btn-blue" :disabled="!hasRight()" @click="moveNext" />
    </div>
    <br></br>
    <br></br>
    <!-- Cards -->
    <main class="card-list" id="cardList" aria-live="polite">
      <Card
        v-for="(card, index) in state"
        :key="index"
        class="animated-card"
        :class="card.position"
        :style="cardStyle(card)"
        role="button"
        :tabindex="card.position === 'center' ? 0 : -1"
        :aria-label="`${card.title} (${card.position})`"
        @click="onCardClick(card)"
        @keyup.enter="onCardClick(card)"
        ref="cardRefs"
      >
        <template #header>
          <img :src="card.image" alt="" class="card-image" />
        </template>

        <template #title>
          <div class="card-title">{{ card.title }}</div>
        </template>

        <template #subtitle>
          <small class="text-light-50">{{ card.subtitle }}</small>
        </template>

        <template #content>
          <p class="mb-0 text-muted">{{ card.description }}</p>
        </template>

        <template #footer>
          <div class="d-flex gap-2">
            <Button
              :label="card.to === '/login' ? 'Salir' : 'Abrir'"
              icon="pi pi-arrow-right"
              class="btn-blue"
              @click="onCardClick(card)"
            />
          </div>
        </template>
      </Card>
     <!--  <router-view /> -->
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/counter'

// PrimeVue
import Button from 'primevue/button'
import Card from 'primevue/card'

// Imágenes desde @/assets/img
import imgIndexar from '@/assets/img/indexar.png'
import imgBuscar from '@/assets/img/buscar.png'
import imgAnexos from '@/assets/img/indexar_anexo.png'
import imgInicio from '@/assets/img/reply.svg'
import bgImage from '@/assets/img/fondo.png'

const router = useRouter()
const auth = useAuthStore()

const bgStyle = {
  background: `#eceef3 url(${bgImage}) center/cover no-repeat fixed`,
  minHeight: '100vh',
  padding: '1.25rem'
}

const state = ref([
  { image: imgIndexar, title: 'Indexar Documentos', subtitle: 'Paso 1/2', description: 'Sube e indexa documentos.', to: '/indexar_actas', position: 'center' },
  { image: imgBuscar,  title: 'Buscar Documentos',   subtitle: 'Solr',     description: 'Consulta y abre resultados.', to: '/buscar_actas',  position: 'right' },
  { image: imgAnexos,  title: 'Indexar Anexo',       subtitle: 'Vinculado',description: 'Agrega anexos a un principal.', to: '/listaActas', position: 'right' },
  { image: imgInicio,  title: 'Volver al Inicio',    subtitle: 'Login',    description: 'Cerrar sesión y salir.', to: '/login', position: 'right' },
])

const cardRefs = ref([])

function centerCard () { return state.value.find(c => c.position === 'center') }
function leftCards  () { return state.value.filter(c => c.position === 'left') }
function rightCards () { return state.value.filter(c => c.position === 'right') }
function hasLeft    () { return leftCards().length > 0 }
function hasRight   () { return rightCards().length > 0 }

function focusCenterCard() {
  nextTick(() => {
    const idx = state.value.findIndex(c => c.position === 'center')
    const el = cardRefs.value?.[idx]
    if (el && el.$el) el.$el.focus()
    else if (el instanceof HTMLElement) el.focus()
  })
}

function moveNext() {
  const c = centerCard()
  if (c) c.position = 'left'
  const next = state.value.find(x => x.position === 'right')
  if (next) next.position = 'center'
  focusCenterCard()
}

function movePrev() {
  const c = centerCard()
  if (c) c.position = 'right'
  const l = leftCards()
  if (l.length) l[l.length - 1].position = 'center'
  focusCenterCard()
}

function cardStyle(card) {
  if (card.position === 'left') {
    const idx = leftCards().indexOf(card)
    return {
      transform: `translateX(${-120 + (idx * 20)}%) scale(${1 - idx * 0.1})`,
      zIndex: String(10 - idx),
      opacity: String(0.8 - idx * 0.2),
      filter: 'brightness(.9)',
      cursor: 'default',
    }
  }
  if (card.position === 'right') {
    const idx = rightCards().indexOf(card)
    return {
      transform: `translateX(${120 - (idx * 20)}%) scale(${1 - idx * 0.1})`,
      zIndex: String(10 - idx),
      opacity: String(0.8 - idx * 0.2),
      filter: 'brightness(.9)',
      cursor: 'default',
    }
  }
  return { transform: 'translateX(0) scale(1)', zIndex: '20', opacity: '1', boxShadow: '0 10px 25px rgba(0,0,0,.35)' }
}

function onCardClick(card) {
  if (card.position !== 'center') return
  if (card.to === '/login') {
    // Cerrar sesión desde la card: limpiar token en Pinia + localStorage
    auth.eliminarToken()
    router.replace('/login')
    return
  }
  router.push(card.to)
}

// Navegación con teclado: ← → y Enter
function onKeyDown(e) {
  if (e.key === 'ArrowLeft') {
    e.preventDefault()
    if (hasLeft()) movePrev()
  } else if (e.key === 'ArrowRight') {
    e.preventDefault()
    if (hasRight()) moveNext()
  } else if (e.key === 'Enter') {
    const c = centerCard()
    if (c) onCardClick(c)
  }
}

onMounted(() => {
  // Recuperar token si recargas / navegas directo
  if (!auth.token) auth.loadFromStorage()
  window.addEventListener('keydown', onKeyDown)
  focusCenterCard()
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeyDown)
})
</script>

<style scoped>
/* Botón azul fuerte con texto blanco */
.btn-blue.p-button {
  background-color: #00509e;
  border-color: #00509e;
  color: #fff;
}
.btn-blue.p-button:hover {
  filter: brightness(0.95);
}
.btn-blue.p-button:disabled {
  opacity: .5;
  cursor: not-allowed;
}

/* Controles */
.controls {
  margin-bottom: 1rem;
}

/* Zona de tarjetas */
.card-list{
  position:relative;
  height: 500px;
  max-width: 900px;
  margin: 0 auto 40px;
  display:flex;
  justify-content:center;
  align-items:center;
}

/* Card animada */
.animated-card{
  position:absolute;
  width: 800px;
  min-height: 500px;
  max-height: 600px;
  border-radius: 14px;
  overflow: hidden;
  background: #5484ec;
  border: 1px solid rgba(198,196,216,.12);
  transition: transform .5s cubic-bezier(0.4,0,0.2,1),
              opacity .5s cubic-bezier(0.4,0,0.2,1),
              filter .5s cubic-bezier(0.4,0,0.2,1),
              box-shadow .3s ease;
  transform-origin: center;
  cursor: pointer;
  will-change: transform, opacity, filter;
  outline: none;
}
.animated-card:focus {
  box-shadow: 0 0 0 3px rgba(0,80,158,.35);
}
.card-image{
  width:100%;
  height: 320px;
  object-fit: contain;
  background:#0f1525;
}
.card-title{ font-weight: 700; }

/* Responsive */
@media (max-width: 920px){
  .animated-card{ width: 92vw; min-height: 460px; }
  .card-image{ height: 280px; }
}
</style>
