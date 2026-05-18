<template>
  <div class="lista-wrap p-3">
    <div class="header-bar">
      <h2>Actas <AyudaDialog v-bind="ayudas.listadoActasParaAnexo" /></h2>
      <div class="acciones">
        <!-- botones si los necesitas -->
      </div>
    </div>

    <!-- FILTROS -->
    <div class="filtros mb-3 d-flex gap-2 align-center">
      <label>
        Tipo:
        <select v-model="tipoFilter" @change="cargar" autocomplete="off">
          <option disabled hidden value="">-- Selecciona --</option>
          <option value="Ordinaria">Ordinaria</option>
          <option value="Extraordinaria">Extraordinaria</option>
        </select>
      </label>

      <label>
        Permanente:
        <select v-model="permanenteFilter" @change="cargar" autocomplete="off">
          <option disabled hidden value="">-- Selecciona --</option>
          <option value="Si">Permanente</option>
          <option value="No">No Permanente</option>
        </select>
      </label>

      <!-- NUEVO: Mes (obligatorio para habilitar Año) -->
      <label>
        Mes:
        <select v-model="mesFilter" @change="onMesChange" autocomplete="off">
          <option disabled hidden value="">-- Selecciona --</option>
          <option v-for="m in mesesES" :key="m" :value="m">{{ m }}</option>
        </select>
      </label>

      <!-- NUEVO: Año (obligatorio, viene de /api/anios y se deshabilita si no hay mes) -->
      <label>
        Año:
        <select
          v-model="anioFilter"
          :disabled="!mesFilter"
          @change="cargar"
          autocomplete="off"
        >
          <option disabled hidden value="">-- Selecciona --</option>
          <option v-for="y in aniosDisponibles" :key="y" :value="y">
            {{ y }}
          </option>
        </select>
      </label>

      <Button label="Limpiar" class="btn-sec" @click="limpiarFiltros" />
    </div>

    <!-- MENSAJE SI NO HAY FILTROS COMPLETOS -->
    <div v-if="!filtrosCompletos" class="mensaje">
      <p>⚠️ Selecciona <strong>Mes</strong> y <strong>Año</strong> para mostrar resultados.</p>
    </div>

    <!-- TABLA SOLO SI HAY FILTROS COMPLETOS -->
    <DataTable
      v-if="filtrosCompletos"
      :value="rows"
      dataKey="ui"
      showGridlines
      scrollable
      scrollHeight="700px"
      class="tabla-fixed"
      tableStyle="min-width: 800px"
      paginator
      :rows="10"
    >
      <Column field="acta" header="Acta" :style="{ minWidth: '12rem' }" />
      <Column field="fecha" header="Fecha" :style="{ minWidth: '12rem' }" />

      <Column header="Tipo" :style="{ minWidth: '12rem' }">
        <template #body="{ data }">
          <span>{{ formatTipo(data.tipo, data.permanente) }}</span>
        </template>
      </Column>

      <Column
        header="Acciones"
        :style="{ minWidth: '12rem', textAlign: 'center' }"
        bodyClass="text-center"
      >
        <template #body="{ data }">
          <Button
            label="Registrar anexo"
            size="small"
            class="btn-azul"
            @click="indexarAnexo(data)"
          />
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { guardarRendimiento } from '@/services/rendimientoService'
import api from '@/services/api'
import AyudaDialog from '@/componentes/ayuda/AyudaDialog.vue'
import { ayudas } from '@/data/ayudas'
import { useAuthStore } from '@/stores/counter'

// PrimeVue
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import Button from 'primevue/button'

const router = useRouter()
const auth = useAuthStore()

const rows = ref([])

// FILTROS
const tipoFilter = ref('')
const permanenteFilter = ref('')
const mesFilter = ref('')    // NUEVO obligatorio
const anioFilter = ref('')   // NUEVO obligatorio

// Meses (deben coincidir con lo que guardas: 12-Febrero-2014, etc.)
const mesesES = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

// Años desde /api/anios
const aniosDisponibles = ref([])

const authHeaders = () => (auth.token ? { Authorization: `Bearer ${auth.token}` } : {})

const filtrosCompletos = computed(() => !!mesFilter.value && !!anioFilter.value)

const userId = computed(() => {
  if (!auth.token) return null
  try {
    const payload = JSON.parse(atob(auth.token.split('.')[1]))
    return payload?.id ?? null
  } catch {
    return null
  }
})

// Cargar AÑOS reales disponibles
async function cargarAnios() {
  try {
    const { data } = await axios.get('/api/anios', { headers: authHeaders() })
    // tu API trae [{id, anio}] -> aquí solo usamos el texto del año
    aniosDisponibles.value = (data || []).map(a => String(a.anio))
  } catch (e) {
    console.error('Error cargando años')
    aniosDisponibles.value = []
  }
}

function onMesChange() {
  // al cambiar mes, se fuerza re-selección de año
  anioFilter.value = ''
  rows.value = []
}

// carga listado (requiere mes y año)
/*async function cargar() {
  if (!filtrosCompletos.value) {
    rows.value = []
    return
  }

  try {
    const params = {
      mes: mesFilter.value,
      anio: anioFilter.value,
    }
    if (tipoFilter.value) params.tipo = tipoFilter.value
    if (permanenteFilter.value) params.permanente = permanenteFilter.value

    const { data } = await axios.get('/api/documentosListado', {
      headers: authHeaders(),
      params,
    })
    rows.value = data || []
  } catch (e) {
    console.error('Error cargando listado', e)
    rows.value = []
  }
}*/

async function cargar() {
  if (!filtrosCompletos.value) {
    rows.value = []
    return
  }

  const params = {
    mes: mesFilter.value,
    anio: anioFilter.value,
  }

  if (tipoFilter.value) params.tipo = tipoFilter.value
  if (permanenteFilter.value) params.permanente = permanenteFilter.value

  let duracionMs = null
  let exito = false
  let statusHttp = null
  let clientDateIso = null
  let clientTimestampMs = null
  let totalResultadosListado = 0

  try {
    const response = await api.get('/api/documentosListado', {
      headers: authHeaders(),
      params,
    })

    const data = response.data
    rows.value = data || []

    totalResultadosListado = Array.isArray(data) ? data.length : 0
    duracionMs = response.durationMs ?? null
    clientDateIso = response.clientDateIso ?? null
    clientTimestampMs = response.clientTimestampMs ?? null
    statusHttp = response.status ?? null
    exito = true

    console.log('Tiempo /api/documentosListado:', duracionMs)
  } catch (e) {
    console.error('Error cargando listado', e)
    rows.value = []

    totalResultadosListado = 0
    duracionMs = e?.durationMs ?? null
    clientDateIso = e?.clientDateIso ?? null
    clientTimestampMs = e?.clientTimestampMs ?? null
    statusHttp = e?.response?.status ?? null
    exito = false
  } finally {
    try {
      await guardarRendimiento(
        {
          accion: 'LISTAR_ACTAS_PARA_REGISTRAR_ANEXO',
          endpoint: '/api/documentosListado',
          duracion_ms: duracionMs,
          exito: exito,
          status_http: statusHttp,
          instante_cliente_iso: clientDateIso,
          timestamp_cliente_ms: clientTimestampMs,
          usuario_id: userId.value,
          mes: mesFilter.value || null,
          anio: anioFilter.value ? Number(anioFilter.value) : null,
          tipo_filtro: tipoFilter.value || null,
          permanente_filtro: permanenteFilter.value || null,
          total_resultados: totalResultadosListado
        },
        authHeaders()
      )
    } catch (logError) {
      console.error('No se pudo guardar rendimiento del listado de documentos:', logError)
    }
  }
}

// Normaliza string: quita tildes, espacios y pasa a minúsculas
function normalizeStr(s) {
  return String(s || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .trim()
    .toLowerCase()
}

function formatTipo(tipo, permanente) {
  const t = tipo || ''
  const p = normalizeStr(permanente)
  if (p === 'si') return t ? `${t} (permanente)` : '(permanente)'
  return t
}

function limpiarFiltros() {
  tipoFilter.value = ''
  permanenteFilter.value = ''
  mesFilter.value = ''
  anioFilter.value = ''
  rows.value = []
}

function indexarAnexo(row) {
  router.push({
    path: '/main/registrar_anexos',
    query: { ui: row.ui, acta: row.acta || '' },
  })
}

onMounted(async () => {
  if (!auth.token) auth.loadFromStorage?.()
  await cargarAnios()
  // NO cargamos hasta que elijan mes y año
})
</script>

<style scoped>
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

.acciones {
  display: flex;
  gap: 0.5rem;
}

/* filtros */
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
.d-flex { display: flex; }
.mb-3 { margin-bottom: 1rem; }
.gap-2 { gap: 0.5rem; }

/* mensaje inicial */
.mensaje {
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

/* Botón secundario */
.btn-sec :deep(.p-button) {
  background-color: #f0f4f9 !important;
  border: 1px solid #ccd !important;
  color: #003366 !important;
  font-weight: 600;
  border-radius: 6px;
}
.btn-sec :deep(.p-button:hover) {
  background-color: #e2ebf7 !important;
}

/* Estilo de la tabla */
:deep(.tabla-fixed thead th) {
  background-color: #003366 !important;
  color: #fff !important;
  text-align: center;
}
:deep(.tabla-fixed tbody tr:nth-child(odd)) {
  background-color: #cce6ff !important;
}
:deep(.tabla-fixed tbody tr:nth-child(even)) {
  background-color: #e6f2ff !important;
}
:deep(.tabla-fixed td) {
  border: 1px solid #003366 !important;
  text-align: center;
  color: #000 !important;
}
:deep(.tabla-fixed .p-paginator) {
  background-color: #003366 !important;
  border: 1px solid #003366 !important;
}
:deep(.tabla-fixed .p-paginator .p-paginator-page),
:deep(.tabla-fixed .p-paginator .p-paginator-prev),
:deep(.tabla-fixed .p-paginator .p-paginator-next) {
  background-color: #00509e !important;
  border: 1px solid #00509e !important;
  color: #fff !important;
}
:deep(.tabla-fixed .p-paginator .p-paginator-page.p-highlight) {
  background-color: #001f3f !important;
  border-color: #001f3f !important;
}
</style>
