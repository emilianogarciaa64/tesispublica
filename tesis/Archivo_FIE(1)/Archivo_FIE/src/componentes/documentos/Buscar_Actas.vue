<template>
  <div class="buscar-actas p-3">
    <div class="mb-3 d-flex gap-2 align-items-center">
     <!-- Después -->
      <select v-model="instanciaId" class="form-select">
        <option disabled value="">-- Selecciona un periodo --</option>
        <option v-for="inst in instancias" :key="inst.id_instancia" :value="inst.id_instancia">
          {{ inst.periodo }}
        </option>
      </select>

      <InputText
        v-model="query"
        placeholder="Escribe tu consulta (ej. fecha:27-Mayo-2014 o texto libre)"
        class="w-100"
        @keyup.enter="doSearch(1)"
      />
      <Button label="Buscar" class="btn-azul" @click="doSearch(1)" />
    </div>

    <!-- <div class="muted mb-2" v-if="lastUrl">Endpoint backend: {{ lastUrl }}</div>
    <div class="err mb-2" v-if="fetchError">{{ fetchError }}</div> -->
<div v-if="rows.length > 0 && totalResults > 0">
    <DataTable
      :value="rows"
      :loading="loading"
      :lazy="true"
      dataKey="id"
      showGridlines
      :paginator="true"
      :rows="pageSize"
      :totalRecords="totalResults"
      :first="(currentPage - 1) * pageSize"
      @page="onPage"
      scrollable
      scrollHeight="800px"
      class="tabla-fixed"
      tableStyle="min-width: 1100px"
      :expandedRows="expanded"
      @rowExpand="loadAnexos"
      @rowCollapse="onRowCollapse"
    >
      <template #empty> No se encontraron resultados. </template>
      <template #loading> Cargando resultados... </template>

      <!-- Columna para expandir (anexos) -->
      <!-- <Column expander style="width:3rem" /> -->

      <!--<Column field="id" header="ID" :style="{ minWidth: '11rem'}" />-->
      <Column field="acta" header="ACTA" :style="{ minWidth: '10rem' }" />
      <Column field="fecha" header="FECHA" :style="{ minWidth: '10rem' }" />
      <Column field="tipo" header="TIPO" :style="{ minWidth: '5rem' }">
        <template #body="{ data }">
          {{ data.tipo }}<span v-if="data.permanente === 'si' || data.permanente === 'Si'"> (permanente)</span>
        </template>
      </Column>

      <!-- <Column field="tipo" header="TIPO" :style="{ minWidth: '5rem' }" /> -->
      <!-- <Column field="permanente" header="PERMANENTE" :style="{ minWidth: '2rem' }" /> -->

      <Column header="HIGHLIGHTED" :style="{ minWidth: '24rem' }">
        <template #body="{ data }">
          <div class="highlighted" v-html="highlightHtml(data)"></div>
        </template>
      </Column>

      <Column header="PDF" :style="{ minWidth: '8rem', textAlign:'center' }" bodyClass="text-center">
        <template #body="{ data }">
          <Button label="Abrir PDF" class="btn-azul" size="small" @click="openPDF(data)" />
        </template>
      </Column>
      <Column header="DETALLES" :style="{ minWidth: '8rem', textAlign:'center' }" bodyClass="text-center">
        <template #body="{ data }">
          <Button
            :label="isExpanded(data) ? 'Ocultar anexos' : 'Ver anexos'"
            class="btn-azul"
            size="small"
            @click="toggleExpand(data)"
          />
        </template>
      </Column>

      <!-- Fila expandida: Anexos -->
      <template #expansion="slotProps">
        <div class="p-3 bg-light">
          <div v-if="anexosLoading[slotProps.data.id]" class="muted">Cargando anexos…</div>
          <div v-else>
            <div v-if="(anexos[slotProps.data.id] || []).length === 0" class="note" >
              No hay anexos para este documento.
            </div>
            <DataTable
              v-else
              :value="anexos[slotProps.data.id]"
              size="small"
              showGridlines
              scrollable
              scrollHeight="240px"
              tableStyle="min-width: 900px"
              :style= "{ color: 'blue' }"
            >
             <!--  <Column field="ui" header="ui" :style="{ minWidth: '14rem' }" />
              <Column field="ui_principal" header="ui_principal" :style="{ minWidth: '14rem' }" />
              <Column field="nombre_documento" header="nombre_documento" :style="{ minWidth: '16rem' }" /> -->
              <Column field="descripcion" header="descripcion" :style="{ minWidth: '16rem' }" />
              <Column field="fecha_del_documento" header="fecha_del_documento" :style="{ minWidth: '14rem' }" />
              <Column header="Abrir" :style="{ minWidth: '8rem' }" bodyClass="text-center">
                <template #body="{ data }">
                  <Button label="Abrir" size="small" class="btn-azul" @click="openAnexo(data)" />
                </template>
              </Column>
            </DataTable>
          </div>
        </div>
      </template>
    </DataTable>
</div>
    <!-- <div class="mt-3 muted" v-if="totalResults">
      Mostrando {{ rows.length }} de {{ totalResults }} resultados
    </div> -->
 <div v-else class="empty-state">
  <div class="empty-card">
    <div class="empty-title">⚠️ No hay resultados</div>
    <div class="empty-sub">Ajusta tu búsqueda o selecciona otro periodo.</div>
  </div>
  </div>   
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useAuthStore } from '@/stores/counter'
import Dropdown from 'primevue/dropdown'
// PrimeVue
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import Button from 'primevue/button'
import InputText from 'primevue/inputtext'
import { useRouter } from 'vue-router'   
defineOptions({ name: 'BuscarActas' })


const router = useRouter()  

// Estado básico
const auth = useAuthStore()

const query = ref('')
const rows = ref([])
const totalResults = ref(0)
const loading = ref(false)
const fetchError = ref('')
const lastUrl = ref('')

// paginación
const pageSize = 10
const currentPage = ref(1)

const instancias = ref([])         // [{ id_instancia, periodo }]
const instanciaId = ref(null)  
// highlight y anexos
const highlighting = ref({}) // mapa id -> { contenido: [ ...fragments ] }
const echoTerm = ref('')
const anexos = ref({})       // mapa idPrincipal -> [ anexos ]
const anexosLoading = ref({})// mapa idPrincipal -> boolean
const expanded = ref({})     // filas expandidas (PrimeVue: objeto con ids como claves)


// helpers
function limpiarSearchTerm(searchTerm) {
  return String(searchTerm || '')
    .replace(/\b(AND|OR|NOT)\b/gi, '')
    .replace(/[()]/g, '')
    .replace(/\s+/g, ' ')
    .trim()
}

function highlightHtml(doc) {
  const frags = highlighting.value?.[doc.id]?.contenido
  if (frags && frags.length) return frags.join(' ')
  // fallback: muestra contenido si viniera (normalmente no lo incluimos por peso)
  return ''
}
onMounted(async () => {
  const headers = auth.token ? { Authorization: `Bearer ${auth.token}` } : {}
  const { data } = await axios.get('/api/instancias', { headers })
  instancias.value = data || []
  // Si quieres auto-seleccionar el primero:
  if (instancias.value.length && instanciaId.value == null) {
    instanciaId.value = instancias.value[0].id_instancia
  }
})


async function doSearch(page = 1) {
  if (!instanciaId.value) {
    return alert('Selecciona un periodo antes de buscar.')
  }
  fetchError.value = ''
  loading.value = true
  currentPage.value = page

  const start = (page - 1) * pageSize
  const params = {
    query: query.value.trim(),
    start,
    rows: pageSize,
    instanciaId: instanciaId.value   //  se manda el id al backend
  }
  const headers = auth.token ? { Authorization: `Bearer ${auth.token}` } : {}

  try {
    const { data } = await axios.get('/api/solrSearch', { params, headers })
    totalResults.value = data?.response?.numFound ?? 0
    rows.value = data?.response?.docs || []
    highlighting.value = data?.highlighting || {}
    echoTerm.value = data?.echo?.term || ''
  } catch (e) {
    fetchError.value = e?.response?.data?.message || e.message || 'Error consultando Solr'
    rows.value = []
    totalResults.value = 0
    highlighting.value = {}
  } finally {
    loading.value = false
  }
}
/* async function doSearch(page = 1) {
  fetchError.value = ''
  loading.value = true
  currentPage.value = page

  const start = (page - 1) * pageSize
  const params = { query: query.value.trim(), start, rows: pageSize }
  const headers = auth.token ? { Authorization: `Bearer ${auth.token}` } : {}

  const qs = new URLSearchParams(params).toString()
  lastUrl.value = `/api/solrSearch?${qs}`

  try {
    const { data } = await axios.get('/api/solrSearch', { params, headers })
    totalResults.value = data?.response?.numFound ?? 0
    rows.value = data?.response?.docs || []
    highlighting.value = data?.highlighting || {}
    echoTerm.value = data?.echo?.term || ''
  } catch (e) {
    fetchError.value = e?.response?.data?.message || e.message || 'Error consultando Solr'
    rows.value = []
    totalResults.value = 0
    highlighting.value = {}
  } finally {
    loading.value = false
  }
} */

function onPage(event) {
  // PrimeVue envía: { first, rows, page }
  // usamos event.page (0-based) -> sumamos 1
  const nextPage = Number(event.page) + 1
  doSearch(nextPage)
}

async function openPDF(doc) {
  try {
    const clean = limpiarSearchTerm(echoTerm.value)  // 👈 aplicas la limpieza
    router.push({
      path: '/main/renderPDF',
      query: { docId: doc.id, search: clean }
    })
  } catch (e) {
    alert('No se pudo abrir el PDF', e)
  }
}

async function loadAnexos({ data }) {
  // se dispara al expandir una fila
  const uiPrincipal = data.id
  anexosLoading.value[uiPrincipal] = true
  try {
    const headers = auth.token ? { Authorization: `Bearer ${auth.token}` } : {}
    const { data: resp } = await axios.get('/api/anexosByPrincipal', {
      params: { ui_principal: uiPrincipal },
      headers
    })
    anexos.value[uiPrincipal] = resp?.anexos || []
  } catch (e) {
    anexos.value[uiPrincipal] = []
  } finally {
    anexosLoading.value[uiPrincipal] = false
  }
}

function onRowCollapse() {
  // no necesitamos lógica especial aquí, pero queda por claridad
}

function openAnexo(anexo) {
  router.push({
    path: '/main/renderAnexo',
    query: { anexoUi: anexo.ui }
  })}
/* function openAnexo(anexo) {
  // Si tienes pantalla dedicada usa router.push; aquí abrimos directo con el backend
  // p.ej. GET /api/getAnexoUrl?ui=<anexo.ui>
  axios.get('/api/getAnexoUrl', {
    params: { ui: anexo.ui },
    headers: auth.token ? { Authorization: `Bearer ${auth.token}` } : {}
  }).then(({ data }) => {
    const url = data?.pdfUrl
    if (url) window.open(url, '_blank')
  }).catch(() => {
    alert('No se pudo abrir el anexo')
  })
} */
function isExpanded(row) {
  // PrimeVue usa un objeto cuyas claves son las keys (dataKey="id")
  return !!expanded.value[row.id]
}

async function toggleExpand(row) {
  if (isExpanded(row)) {
    // colapsa
    const copy = { ...expanded.value }
    delete copy[row.id]
    expanded.value = copy
  } else {
    // expande
    expanded.value = { ...expanded.value, [row.id]: true }
    // carga anexos si aún no están
    if (!anexos.value[row.id]) {
      await loadAnexos({ data: row })
    }
  }
}

// carga inicial vacía (opcional puedes disparar una búsqueda por defecto)
</script>

<style scoped>
.buscar-actas {
  font-family: Arial, sans-serif;
}

/* Botón azul fuerte con texto blanco */
/* .btn-azul :deep(.p-button) {
  background-color: #00509e !important;
  border-color: #00509e !important;
  color: #fff !important;
}
.btn-azul :deep(.p-button:hover) {
  background-color: #003d79 !important;
  border-color: #003d79 !important;
  color: #fff !important;
} */
.btn-azul {
  background-color: #007bff;  /* azul */
  border: none;
  color: white;
  font-weight: bold;
  border-radius: 6px;
}

.btn-azul:hover {
  background-color: #0056b3; /* azul más oscuro al pasar el mouse */
}
.buscar-actas .p-inputtext {
  background-color: #f0f8ff; /* color de fondo */
  border: 1px solid #007bff; /* color del borde */
  color: #333; /* color del texto */
}
.buscar-actas .p-inputtext:focus {
  border-color: #0056b3;
  box-shadow: 0 0 4px rgba(0, 91, 187, 0.6);
}

/* Tabla con tamaño fijo y scroll si la altura de filas crece */
/* Cabecera azul con letras blancas */
:deep(.tabla-fixed thead th) {
  background-color: #003366 !important;
  color: #fff !important;
  text-align: center;
}

/* Filas alternadas azules claros */
:deep(.tabla-fixed tbody tr:nth-child(odd)) {
  background-color: #cce6ff !important;
}
:deep(.tabla-fixed tbody tr:nth-child(even)) {
  background-color: #e6f2ff !important;
}

/* Bordes y texto */
:deep(.tabla-fixed td) {
  border: 1px solid #003366 !important;
  color: #000 !important;
  text-align: center;
}

/* Footer/paginador azul */
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


/* Para que el contenido resaltado conserve estilos */
.highlighted :deep(.highlight) {
  background-color: yellow;
  font-weight: bold;
}

/* helpers visuales */
.muted { color:#666; }
.err { color:#b00020; white-space: pre-wrap; }
.note { color:#3825e0; }
.instancias-wrap {
  display: flex;
  gap: .5rem;
  flex-wrap: wrap;
}

.instancia-pill {
  background: #e8f1ff;
  color: #0a3a74;
  border: 1px solid #bcd3ff;
  border-radius: 999px;
  padding: .35rem .75rem;
  font-weight: 600;
  cursor: pointer;
}
.instancia-pill:hover { background: #d7e9ff; }
.instancia-pill.active {
  background: #00509e;
  color: #fff;
  border-color: #00509e;
  box-shadow: 0 0 0 2px rgba(0,80,158,.15) inset;
}

/* Estado vacío */
.empty-state { display:flex; justify-content:center; margin-top: 1rem; }
.empty-card {
  background: #f7fbff;
  border: 1px dashed #bcd3ff;
  border-radius: 12px;
  padding: 1rem 1.25rem;
  text-align: center;
  max-width: 720px;
  width: 100%;
}
.empty-title { font-weight: 700; color:#003366; }
.empty-sub { color:#557; margin-top: .25rem; }
.form-select {
  padding: 6px 10px;
  border: 1px solid #007bff;
  border-radius: 6px;
  font-size: 0.95rem;
  color: #333;
  background-color: #f0f8ff;
}
.form-select:focus {
  outline: none;
  border-color: #0056b3;
  box-shadow: 0 0 4px rgba(0, 91, 187, 0.6);
}
.form-select { min-width: 360px; width: 360px; flex: 0 0 auto; height: 42px; }
.w-100 { flex: 1 1 auto !important; min-width: 420px; }
</style>
