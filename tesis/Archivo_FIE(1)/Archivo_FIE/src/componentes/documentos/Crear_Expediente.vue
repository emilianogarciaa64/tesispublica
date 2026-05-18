<template>
  <div class="lista-wrap p-3">
    <!--<div class="header-bar">
      <h2>Expedientes</h2>
      <div class="acciones"></div>
    </div>-->

    <!-- Selector modo -->
    <div class="modo-bar">
      <Button
        label="Por Años"
        class="btn-modo"
        :outlined="modo !== 'ANIO'"
        @click="setModo('ANIO')"
      />
      <Button
        label="Por Ciclos"
        class="btn-modo"
        :outlined="modo !== 'CICLO'"
        @click="setModo('CICLO')"
      />
    </div>

    <!-- FORMULARIO -->
    <form class="filtros" @submit.prevent="crearExpediente">
      <div class="filtro">
        <label class="filtro-label" for="seccion">Sección:</label>
        <select id="seccion" v-model="seccionId" class="file-input">
          <option disabled value="">Selecciona una sección…</option>
          <option v-for="opt1 in secciones" :key="opt1.id" :value="opt1.id">
            {{ opt1.seccion }}
          </option>
        </select>
      </div>

      <div class="filtro">
        <label class="filtro-label" for="serie">Serie:</label>
        <select id="serie" v-model="serieId" class="file-input" :disabled="!seccionId">
          <option disabled value="">Selecciona una serie…</option>
          <option v-for="opt2 in series" :key="opt2.id" :value="opt2.id">
            {{ opt2.serie }}
          </option>
        </select>
      </div>

      <div class="filtro">
        <label class="filtro-label" for="subserie">Subserie:</label>
        <select id="subserie" v-model="subserieId" class="file-input" :disabled="!serieId">
          <option disabled value="">Selecciona una subserie…</option>
          <option v-for="opt3 in subseries" :key="opt3.id" :value="opt3.id">
            {{ opt3.subserie }}
          </option>
        </select>
      </div>

      <div class="filtro">
        <label class="filtro-label" for="areap">Área productora:</label>
        <select id="areap" v-model="areapId" class="file-input">
          <option disabled value="">Selecciona un área…</option>
          <option v-for="opt5 in areaps" :key="opt5.id" :value="opt5.id">
            {{ opt5.area }}
          </option>
        </select>
      </div>

      <!-- ===== AÑO o CICLO ===== -->
      <div class="filtro" v-if="modo === 'ANIO'">
        <label class="filtro-label" for="anio">Año:</label>
        <select id="anio" v-model="anioId" class="file-input">
          <option disabled value="">Selecciona un año…</option>
          <option v-for="opt6 in anios" :key="opt6.id" :value="opt6.id">
            {{ opt6.anio }}
          </option>
        </select>
      </div>

      <div class="filtro" v-else>
        <label class="filtro-label" for="ciclo">Ciclo:</label>
        <select id="ciclo" v-model="cicloId" class="file-input">
          <option disabled value="">Selecciona un ciclo…</option>
          <option v-for="c in ciclos" :key="c.id" :value="c.id">
            {{ c.ciclo }}
          </option>
        </select>
      </div>

      <div class="filtro">
        <label class="filtro-label" for="instancia">Instancia:</label>
        <select
          id="instancia"
          v-model="instanciaId"
          class="file-input"
          :disabled="modo === 'ANIO' ? !anioId : !cicloId"
        >
          <option disabled value="">Selecciona una instancia…</option>
          <option v-for="opt in instancias" :key="opt.id_instancia" :value="opt.id_instancia">
            {{ opt.periodo }}
          </option>
        </select>
      </div>

      <div class="filtro">
        <Button
          type="submit"
          label="Crear"
          class="btn-azul"
          :disabled="loading || !formCompleto"
        />
      </div>
    </form>

    <div v-if="msg" class="mensaje">
      <p>{{ msg }}</p>
    </div>

    <!--<div style="font-size:12px;color:#666;margin-top:8px;">
      modo: {{ modo }} |
      anioId: {{ anioId }} |
      cicloId: {{ cicloId }} |
      instanciaId: {{ instanciaId }}
    </div>-->
  </div>
</template>

<script setup>
import { ref, onMounted, watch, computed } from 'vue'
import axios from 'axios'
import { useAuthStore } from '@/stores/counter'
import Button from 'primevue/button'

const auth = useAuthStore()

const loading = ref(false)
const msg = ref('')

// modo: ANIO | CICLO
const modo = ref('ANIO')

// Listas
const instancias = ref([])
const secciones = ref([])
const series = ref([])
const subseries = ref([])
const areaps = ref([])
const anios = ref([])
const ciclos = ref([])

// IDs seleccionados
const seccionId = ref('')
const serieId = ref('')
const subserieId = ref('')
const areapId = ref('')
const anioId = ref('')
const cicloId = ref('')
const instanciaId = ref('')

const authHeaders = () => (auth.token ? { Authorization: `Bearer ${auth.token}` } : {})

// ======= helpers =======
function resetDependientes() {
  // cascada
  serieId.value = ''
  subserieId.value = ''
  series.value = []
  subseries.value = []

  // modo
  anioId.value = ''
  cicloId.value = ''
  instanciaId.value = ''
}

function setModo(nuevo) {
  if (modo.value === nuevo) return
  modo.value = nuevo
  // limpiar selección de año/ciclo/instancia
  anioId.value = ''
  cicloId.value = ''
  instanciaId.value = ''
}

const formCompleto = computed(() => {
  const base = seccionId.value && serieId.value && subserieId.value && areapId.value && instanciaId.value
  if (!base) return false
  return (modo.value === 'ANIO') ? !!anioId.value : !!cicloId.value
})

// ======= carga inicial =======
async function cargarCatalogosIniciales() {
  try {
    const headers = authHeaders()

    const [rInst, rAreap, rSecc] = await Promise.all([
      axios.get('/api/instancias', { headers }),
      axios.get('/api/areasprod', { headers }),
      axios.get('/api/secciones', { headers }),
    ])

    instancias.value = rInst.data || []
    areaps.value = rAreap.data || []
    secciones.value = rSecc.data || []

    // por default ANIO
    await cargarAniosOCiclos()
  } catch (e) {
    console.error('Error cargando catálogos', e)
    msg.value = 'Error cargando catálogos'
  }
}

async function cargarAniosOCiclos() {
  try {
    const headers = authHeaders()
    if (modo.value === 'ANIO') {
      const { data } = await axios.get('/api/anios', { headers })
      anios.value = data || []
      ciclos.value = []
    } else {
      const { data } = await axios.get('/api/ciclos', { headers })
      ciclos.value = data || []
      anios.value = []
    }
  } catch (e) {
    console.error('Error cargando anios/ciclos', e)
    msg.value = 'Error cargando años/ciclos'
  }
}

// cuando cambia el modo, carga el catálogo correspondiente
watch(modo, async () => {
  await cargarAniosOCiclos()
})

// ======= cascadas =======
watch(seccionId, async (newSeccionId) => {
  // reset cascada
  serieId.value = ''
  subserieId.value = ''
  series.value = []
  subseries.value = []

  if (!newSeccionId) return

  try {
    const { data } = await axios.get('/api/series', {
      headers: authHeaders(),
      params: { seccionId: newSeccionId },
    })
    series.value = data || []
  } catch (e) {
    console.error('Error cargando series', e)
    series.value = []
  }
})

watch(serieId, async (newSerieId) => {
  subserieId.value = ''
  subseries.value = []

  if (!newSerieId) return

  try {
    const { data } = await axios.get('/api/subseries', {
      headers: authHeaders(),
      params: { serieId: newSerieId },
    })
    subseries.value = data || []
  } catch (e) {
    console.error('Error cargando subseries', e)
    subseries.value = []
  }
})

// ======= instancia por año =======
function selectInstanciaByYear(year) {
  if (!year || !Array.isArray(instancias.value) || instancias.value.length === 0) return

  const match = instancias.value.find((opt) => {
    const periodo = String(opt.periodo || '')
    const m = periodo.match(/(\d{4})\s*[-/]\s*(\d{4})/)
    if (!m) return false
    const start = parseInt(m[1], 10)
    const end = parseInt(m[2], 10)
    if (isNaN(start) || isNaN(end)) return false
    return year >= start && year <= end
  })

  instanciaId.value = match ? match.id_instancia : ''
}

// Año -> auto instancia
watch(anioId, (newAnioId) => {
  if (modo.value !== 'ANIO') return
  instanciaId.value = ''
  if (!newAnioId) return

  const obj = (anios.value || []).find((a) => String(a.id) === String(newAnioId))
  if (!obj) return

  const year = parseInt(obj.anio, 10)
  if (isNaN(year)) return

  selectInstanciaByYear(year)
})

// Ciclo -> auto instancia por primer año del ciclo
function getPrimerAnioDelCiclo(txt) {
  // espera "2014-2015" o "2014 - 2015"
  const m = String(txt || '').match(/(\d{4})\s*[-/]\s*(\d{4})/)
  if (!m) return null
  const first = parseInt(m[1], 10)
  return isNaN(first) ? null : first
}

watch(cicloId, (newCicloId) => {
  if (modo.value !== 'CICLO') return
  instanciaId.value = ''
  if (!newCicloId) return

  const obj = (ciclos.value || []).find(c => String(c.id) === String(newCicloId))
  if (!obj) return

  const firstYear = getPrimerAnioDelCiclo(obj.ciclo)
  if (!firstYear) return

  selectInstanciaByYear(firstYear)
})

// ======= submit =======
async function crearExpediente() {
  msg.value = ''
  if (!formCompleto.value) {
    msg.value = 'Selecciona todos los campos antes de crear.'
    return
  }

  loading.value = true
  try {
    const basePayload = {
      seccionId: Number(seccionId.value),
      serieId: Number(serieId.value),
      subserieId: Number(subserieId.value),
      areaProdId: Number(areapId.value),
      instanciaId: Number(instanciaId.value),
    }

    let url = ''
    let payload = {}

    if (modo.value === 'ANIO') {
      url = '/api/crearexpedienteporanios'
      payload = { ...basePayload, anioId: Number(anioId.value) }
    } else {
      url = '/api/crearexpedienteporciclos'
      payload = { ...basePayload, cicloId: Number(cicloId.value) }
    }

    const { data } = await axios.post(url, payload, {
      headers: { ...authHeaders(), 'Content-Type': 'application/json' },
    })

    msg.value = data?.message || 'Expediente creado'
    limpiarFormulario()
  } catch (e) {
    console.error('Error creando expediente', e)
    msg.value = e?.response?.data?.message || 'Error creando expediente'
  } finally {
    loading.value = false
  }
}

function limpiarFormulario() {
  seccionId.value = ''
  serieId.value = ''
  subserieId.value = ''
  areapId.value = ''
  anioId.value = ''
  cicloId.value = ''
  instanciaId.value = ''
  series.value = []
  subseries.value = []
}

onMounted(async () => {
  if (!auth.token) auth.loadFromStorage?.()
  await cargarCatalogosIniciales()
})
</script>

<style scoped>
.filtros {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  align-items: flex-end;
}

.filtro {
  width: fit-content;
  flex: 0 0 auto;
}

.file-input {
  width: auto !important;
  min-width: 220px;
  max-width: 260px;
  display: inline-block !important;
}

.lista-wrap {
  font-family: Arial, sans-serif;
  min-height: 100vh;
  background: linear-gradient(135deg, #f8fbff, #eaf1f9);
}

.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

/* modo buttons */
.modo-bar{
  display:flex;
  gap:.5rem;
  margin-bottom: .75rem;
}
.btn-modo :deep(.p-button){
  border-radius: 8px;
  font-weight: 600;
}

/* selects */
.filtros label {
  display: flex;
  flex-direction: column;
  font-size: 0.9rem;
}
.filtros select {
  margin-top: 4px;
  padding: 6px 8px;
  border-radius: 6px;
  border: 1px solid #ccd;
  background: #fff;
  color: black;
}

/* mensaje */
.mensaje {
  margin-top: 1rem;
  background: #fff4e6;
  border: 1px solid #ffa94d;
  color: #d9480f;
  padding: 1rem;
  border-radius: 6px;
  text-align: center;
  font-weight: 600;
}

/* Botón azul fuerte */
.btn-azul :deep(.p-button) {
  background-color: #00509e !important;
  border: none !important;
  color: #fff !important;
  font-weight: 600;
  border-radius: 6px;
}
.btn-azul :deep(.p-button:hover) {
  background-color: #003f7f !important;
}
</style>
