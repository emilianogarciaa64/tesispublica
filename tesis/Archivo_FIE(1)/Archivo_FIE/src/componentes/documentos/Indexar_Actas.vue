<template>
  <div class="indexar-wrap">
    <div class="indexar-card">
      <h2 class="titulo">Indexar Acta</h2>
      <p class="subtitulo">Completa los campos para registrar el Acta.</p>

      <form class="form-grid" @submit.prevent="indexDocument">
        <div class="campo">
          <label for="acta">Acta:</label>
          <InputText id="acta" v-model="acta" placeholder="Ej. 20/2014-2014" />
        </div>

        <div class="row">
          <label for="fecha">Fecha del acta:</label>
          <Calendar
            id="fecha"
            v-model="fechaObj"
            :showIcon="true"
            placeholder="Selecciona fecha"
            :showButtonBar="true"
            :touchUI="false"
            :inputClass="'p-inputtext'"
          />
        </div>

        <!-- NUEVO: Año o Ciclo -->
        <div class="campo">
          <label for="origen">¿Acta por…?</label>
          <select id="origen" v-model="origenExpediente" class="file-input">
            <option disabled value="">Selecciona…</option>
            <option value="ANIO">Año</option>
            <option value="CICLO">Ciclo</option>
          </select>
        </div>

        <!-- NUEVO: Select de ciclo (solo si eligió CICLO) -->
        <div class="campo" v-if="origenExpediente === 'CICLO'">
          <label for="ciclo">Ciclo:</label>
          <select id="ciclo" v-model="cicloId" class="file-input">
            <option disabled value="">Selecciona un ciclo…</option>
            <option v-for="c in ciclos" :key="c.id" :value="c.id">
              {{ c.ciclo }}
            </option>
          </select>

          <div class="nota-peq" v-if="cicloSeleccionadoTexto">
            Ciclo seleccionado: <strong>{{ cicloSeleccionadoTexto }}</strong>
          </div>
        </div>

        <div class="campo">
          <label for="tipo">Tipo:</label>
          <select id="tipo" v-model="tipo" class="file-input">
            <option disabled value="">Selecciona un tipo…</option>
            <option value="Ordinaria">Ordinaria</option>
            <option value="Extraordinaria">Extraordinaria</option>
          </select>
        </div>

        <div class="campo">
          <label for="permanente">Permanente:</label>
          <Checkbox inputId="permanente" :binary="true" v-model="permanenteChecked" />
          <span style="margin-left: 10px;">{{ permanente }}</span>
        </div>

        <div class="campo">
          <label for="instancia">Período / Instancia:</label>

          <select id="instancia" v-model="instanciaId" class="file-input" disabled>
            <option disabled value="">Selecciona un período…</option>
            <option v-for="opt in instancias" :key="opt.id_instancia" :value="opt.id_instancia">
              {{ opt.periodo }}
            </option>
          </select>

          <div class="nota-peq" v-if="instanciaSeleccionadaPeriodo">
            Seleccionado automáticamente: <strong>{{ instanciaSeleccionadaPeriodo }}</strong>
          </div>
        </div>

        <div class="campo">
          <label for="file">Archivo principal:</label>
          <input id="file" type="file" accept="application/pdf" class="file-input" @change="onFile" />
        </div>

        <div class="checkbox-row">
          <input id="chkAnexos" type="checkbox" v-model="agregarAnexos" />
          <label for="chkAnexos">Agregar anexos después de indexar</label>
        </div>

        <div class="acciones">
          <Button
            type="submit"
            label="Indexar"
            class="btn-azul"
            :disabled="busy"
          />
        </div>

        <!-- ✅ sin v-html -->
        <div class="mensajes">
          <p v-if="indexMsg" :class="indexMsgType">{{ indexMsg }}</p>
        </div>
      </form>
    </div>

    <!-- Modal de anexos -->
    <Dialog v-model:visible="showAnexo" modal header="Agregar Anexo" :style="{ width: '640px', background: 'white', color: 'black' }">
      <div class="form-grid mt-3">
        <div class="campo">
          <label>Fecha anexo:</label>
          <Calendar
            v-model="fechaAnexo"
            :showIcon="true"
            placeholder="Selecciona fecha"
            :showButtonBar="true"
            :touchUI="false"
            :inputClass="'p-inputtext'"
          />
        </div>

        <div class="campo">
          <label>Descripción:</label>
          <InputText v-model="descripcionAnexo" placeholder="Descripción del anexo" />
        </div>

        <div class="campo">
          <label for="fileAnexo">Archivo anexo:</label>
          <input id="fileAnexo" type="file" accept="application/pdf" class="file-input" @change="onFileAnexo" />
        </div>
      </div>

      <div class="acciones mt-3">
        <Button label="Registrar Anexo" class="btn-azul" :disabled="busyAnexo || !fileAnexo" @click="indexarAnexo" />
        <Button label="✔ Terminar" class="btn-azul" @click="showAnexo = false" />
      </div>

      <!-- ✅ sin v-html -->
      <div class="mensajes mt-2">
        <p v-if="anexoMsgText" :class="anexoMsgType">{{ anexoMsgText }}</p>
      </div>
    </Dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/counter'

import Button from 'primevue/button'
import Dialog from 'primevue/dialog'
import InputText from 'primevue/inputtext'
import Calendar from 'primevue/calendar'
import Checkbox from 'primevue/checkbox'

const auth = useAuthStore()
const router = useRouter()

// ===== formulario principal =====
const acta = ref('')
const fechaObj = ref(null)
const fecha = ref('')
const tipo = ref('')
const permanenteChecked = ref(false)
const permanente = ref('No')
const file = ref(null)
const agregarAnexos = ref(false)

// ✅ antes indexResult (HTML). Ahora: texto + tipo
const indexMsg = ref('')
const indexMsgType = ref('') // 'ok' | 'err'
const busy = ref(false)
const uiPrincipal = ref(null)

// ===== Año/Ciclo (NUEVO) =====
const origenExpediente = ref('') // 'ANIO' | 'CICLO'
const ciclos = ref([])
const cicloId = ref('')

// ===== instancia/expediente =====
const instancias = ref([])
const instanciaId = ref('')
const expedienteId = ref('')

// ===== modal anexo =====
const showAnexo = ref(false)
const fechaAnexo = ref(null)
const descripcionAnexo = ref('')
const fileAnexo = ref(null)

// ✅ antes anexoMsg (HTML). Ahora: texto + tipo
const anexoMsgText = ref('')
const anexoMsgType = ref('') // 'ok' | 'err'
const busyAnexo = ref(false)

// ===== util =====
const mesesES = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

const authHeaders = () => (auth.token ? { Authorization: `Bearer ${auth.token}` } : {})

const userId = computed(() => {
  if (!auth.token) return null
  try {
    const payload = JSON.parse(atob(auth.token.split('.')[1]))
    return payload?.id ?? null
  } catch {
    return null
  }
})

const yearCalculado = computed(() => {
  if (!fechaObj.value) return ''
  const d = fechaObj.value instanceof Date ? fechaObj.value : new Date(fechaObj.value)
  if (isNaN(d.getTime())) return ''
  return d.getFullYear()
})

const cicloSeleccionadoTexto = computed(() => {
  const sel = ciclos.value.find(c => String(c.id) === String(cicloId.value))
  return sel ? sel.ciclo : ''
})

const instanciaSeleccionadaPeriodo = computed(() => {
  const sel = instancias.value.find(opt => String(opt.id_instancia) === String(instanciaId.value))
  return sel ? sel.periodo : ''
})

onMounted(async () => {
  if (!auth.token) auth.initFromStorage?.()
  await Promise.all([cargarInstancias(), cargarCiclos()])
})

watch(permanenteChecked, (val) => {
  permanente.value = val ? 'Si' : 'No'
})

function setIndexMsg(type, text) {
  indexMsgType.value = type
  indexMsg.value = String(text || '')
}

function setAnexoMsg(type, text) {
  anexoMsgType.value = type
  anexoMsgText.value = String(text || '')
}

function formatFechaParaBackend(d) {
  if (!d || !(d instanceof Date)) return ''
  const day = d.getDate()
  const monthName = mesesES[d.getMonth()]
  const year = d.getFullYear()
  return `${day}-${monthName}-${year}`
}

function parseStartYearFromCiclo(cicloStr) {
  const m = String(cicloStr || '').match(/^(\d{4})\s*-\s*(\d{4})$/)
  if (!m) return null
  const start = parseInt(m[1], 10)
  return Number.isFinite(start) ? start : null
}

function selectInstanciaByYear(year) {
  if (!year || !Array.isArray(instancias.value) || instancias.value.length === 0) return

  const match = instancias.value.find(opt => {
    const periodo = String(opt.periodo || '')
    const m = periodo.match(/(\d{4})\s*-\s*(\d{4})/)
    if (!m) return false
    const start = parseInt(m[1], 10)
    const end = parseInt(m[2], 10)
    if (isNaN(start) || isNaN(end)) return false
    return year >= start && year <= end
  })

  instanciaId.value = match ? match.id_instancia : ''
}

async function cargarInstancias() {
  try {
    const { data } = await axios.get('/api/instancias', { headers: authHeaders() })
    instancias.value = data || []
  } catch (e) {
    console.error('Error cargando instancias', e)
    instancias.value = []
  }
}

async function cargarCiclos() {
  try {
    const { data } = await axios.get('/api/ciclos', { headers: authHeaders() })
    ciclos.value = data || []
  } catch (e) {
    console.error('Error cargando ciclos', e)
    ciclos.value = []
  }
}

async function encontrarexpedientePorAnio(year) {
  try {
    const { data } = await axios.get('/api/expedientes', {
      headers: authHeaders(),
      params: { year }
    })
    expedienteId.value = data?.id ? String(data.id) : ''
  } catch (e) {
    console.error('Error obteniendo expediente por año', e)
    expedienteId.value = ''
  }
}

async function encontrarexpedientePorCiclo(cicloIdVal) {
  try {
    const { data } = await axios.get('/api/expedientesporciclos', {
      headers: authHeaders(),
      params: { cicloId: cicloIdVal }
    })
    expedienteId.value = data?.id ? String(data.id) : ''
  } catch (e) {
    console.error('Error obteniendo expediente por ciclo', e)
    expedienteId.value = ''
  }
}

async function recalcularInstanciaYExpediente() {
  instanciaId.value = ''
  expedienteId.value = ''

  if (!origenExpediente.value) return

  if (origenExpediente.value === 'ANIO') {
    if (!fechaObj.value) return
    const d = fechaObj.value instanceof Date ? fechaObj.value : new Date(fechaObj.value)
    if (isNaN(d.getTime())) return
    const year = d.getFullYear()

    selectInstanciaByYear(year)
    await encontrarexpedientePorAnio(year)
    return
  }

  if (origenExpediente.value === 'CICLO') {
    if (!cicloId.value) return

    const cicloStr = cicloSeleccionadoTexto.value
    const startYear = parseStartYearFromCiclo(cicloStr)
    if (startYear) selectInstanciaByYear(startYear)
    else instanciaId.value = ''

    await encontrarexpedientePorCiclo(cicloId.value)
  }
}

watch(fechaObj, async () => {
  if (origenExpediente.value === 'ANIO') await recalcularInstanciaYExpediente()
})

watch(origenExpediente, async (nv) => {
  if (nv !== 'CICLO') cicloId.value = ''
  await recalcularInstanciaYExpediente()
})

watch(cicloId, async () => {
  if (origenExpediente.value === 'CICLO') await recalcularInstanciaYExpediente()
})

watch(instancias, async (nv) => {
  if (!nv || nv.length === 0) return
  await recalcularInstanciaYExpediente()
})

function onFile(e) {
  file.value = e.target.files?.[0] || null
}
function onFileAnexo(e) {
  fileAnexo.value = e.target.files?.[0] || null
}

async function indexDocument() {
  setIndexMsg('', '')

  if (!userId.value) {
    alert('Sesión no iniciada. Redirigiendo al login…')
    router.replace('/login')
    return
  }

  if (!origenExpediente.value) {
    setIndexMsg('err', 'Selecciona si el acta es por Año o por Ciclo.')
    return
  }

  if (origenExpediente.value === 'ANIO' && !fechaObj.value) {
    setIndexMsg('err', 'Selecciona la fecha del acta (para obtener el año).')
    return
  }

  if (origenExpediente.value === 'CICLO' && !cicloId.value) {
    setIndexMsg('err', 'Selecciona el ciclo.')
    return
  }

  if (!file.value) {
    setIndexMsg('err', 'Debe seleccionar un PDF.')
    return
  }

  if (!instanciaId.value) {
    setIndexMsg('err', 'No se pudo determinar la instancia.')
    return
  }

  if (!expedienteId.value) {
    setIndexMsg('err', 'No se pudo determinar el expediente.')
    return
  }

  if (fechaObj.value) {
    fecha.value = formatFechaParaBackend(fechaObj.value instanceof Date ? fechaObj.value : new Date(fechaObj.value))
  } else {
    fecha.value = ''
  }

  busy.value = true
  try {
    const fd = new FormData()
    fd.append('acta', acta.value)
    fd.append('fecha', fecha.value)
    fd.append('tipo', tipo.value)
    fd.append('permanente', permanente.value)
    fd.append('instancia_id', instanciaId.value)
    fd.append('idexpediente', expedienteId.value)
    fd.append('origen_expediente', origenExpediente.value)

    if (origenExpediente.value === 'CICLO') fd.append('ciclo_id', String(cicloId.value))
    fd.append('file', file.value)

    const { data } = await axios.post('/api/indexarActa', fd, { headers: authHeaders() })
    uiPrincipal.value = data?.ui || null

    setIndexMsg('ok', 'OK: indexado y registrado.')

    // limpiar
    acta.value = ''
    tipo.value = ''
    permanenteChecked.value = false
    file.value = null

    if (agregarAnexos.value && uiPrincipal.value) {
      fechaAnexo.value = null
      descripcionAnexo.value = ''
      fileAnexo.value = null
      setAnexoMsg('', '')
      showAnexo.value = true
    }
  } catch (e) {
    console.error(e)
    const msg = e?.response?.data?.message || e?.message || String(e)
    setIndexMsg('err', `Error: ${msg}`)
  } finally {
    busy.value = false
  }
}

async function indexarAnexo() {
  if (!userId.value) {
    setAnexoMsg('err', 'Sesión inválida. Inicia sesión nuevamente.')
    return
  }
  if (!uiPrincipal.value) {
    setAnexoMsg('err', 'No hay UI principal válido.')
    return
  }
  if (!fileAnexo.value) {
    setAnexoMsg('err', 'Selecciona un archivo anexo.')
    return
  }
  if (!fechaAnexo.value) {
    setAnexoMsg('err', 'Selecciona la fecha del anexo.')
    return
  }

  busyAnexo.value = true
  setAnexoMsg('', '')

  try {
    const fechaFormateada = formatFechaParaBackend(
      fechaAnexo.value instanceof Date ? fechaAnexo.value : new Date(fechaAnexo.value)
    )

    const fd = new FormData()
    fd.append('ui_principal', uiPrincipal.value)
    fd.append('fecha', fechaFormateada)
    fd.append('descripcion', descripcionAnexo.value)
    fd.append('file', fileAnexo.value)

    await axios.post('/api/registerAnexo', fd, { headers: authHeaders() })

    fechaAnexo.value = null
    descripcionAnexo.value = ''
    fileAnexo.value = null

    setAnexoMsg('ok', 'Anexo registrado correctamente.')
  } catch (e) {
    const msg = e?.response?.data?.message || e?.message || String(e)
    setAnexoMsg('err', `Error registrando anexo: ${msg}`)
  } finally {
    busyAnexo.value = false
  }
}
</script>

<style scoped>
.indexar-wrap {
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: 2rem;
  background: linear-gradient(135deg, #f0f6ff, #e4ecf7);
  min-height: 100vh;
}

.indexar-card {
  background: #fff;
  border-radius: 14px;
  padding: 2rem;
  max-width: 720px;
  width: 100%;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  animation: fadeIn 0.5s ease-in-out;
}

.titulo { margin: 0 0 0.5rem; color: #003366; }
.subtitulo { margin: 0 0 1.5rem; color: #555; }

.form-grid { display: grid; gap: 1rem; }
.form-grid :deep(.p-inputtext) {
  background-color: #ffffff !important;
  color: #000000 !important;
  border: 1px solid #ccc !important;
}

.campo label {
  font-weight: 600;
  color: #003366;
  margin-bottom: 0.25rem;
  display: block;
}

.file-input {
  border: 1px solid #ccd;
  padding: 6px;
  border-radius: 6px;
  width: 100%;
  background: #f8faff;
  color: #000;
}

.checkbox-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #003366;
  font-size: 0.95rem;
}

.acciones {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
  margin-top: 1rem;
}

.mensajes { margin-top: 1.5rem; }
.mensajes p { margin: 0.3rem 0; font-size: 0.95rem; }

/* ✅ ahora estas clases se aplican directo al <p> */
.mensajes .ok { color: #0a8d48; font-weight: bold; }
.mensajes .err { color: #b00020; font-weight: bold; }

.btn-azul {
  background-color: #007bff;
  border: none;
  color: white;
  font-weight: bold;
  border-radius: 6px;
}
.btn-azul:hover { background-color: #0056b3; }

:deep(.p-dialog .p-dialog-content) {
  background-color: #fff !important;
  color: #000 !important;
}
:deep(.p-dialog .p-dialog-header) {
  background-color: #f7f8fa !important;
  color: #000 !important;
  font-weight: bold;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(15px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
