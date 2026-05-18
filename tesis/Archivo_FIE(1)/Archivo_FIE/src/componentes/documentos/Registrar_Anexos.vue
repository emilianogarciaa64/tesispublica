<template>
  <div class="anexo-wrap">
    <div class="anexo-centered">
      <header class="anexo-header">
        <h2>Registrar Anexo</h2>
      </header>

      <form class="anexo-form" @submit.prevent="indexar" enctype="multipart/form-data">
        <!-- Inputs ocultos: siguen enviándose (por compatibilidad si alguna vez usas envío nativo) -->
        <input type="hidden" name="ui_principal" :value="ui" />
        <input type="hidden" name="acta" :value="acta" />

        <!-- Fecha con calendario -->
        <div class="row">
          <label for="fecha">Fecha del anexo:</label>
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

        <!-- Descripción -->
        <div class="row">
          <label for="descripcion">Descripción:</label>
          <InputText id="descripcion" v-model="descripcion" placeholder="Breve descripción" required />
        </div>

        <!-- Archivo -->
        <div class="row file-row">
          <label for="file">Archivo anexo (PDF):</label>
          <input
            ref="fileInput"
            id="file"
            type="file"
            accept="application/pdf"
            @change="onFileChange"
            required
          />

        </div>

        <!-- Acciones (botones azules con texto blanco) -->
        <div class="acciones-form">
          <Button
            type="submit"
            :disabled="busy || !archivo || !fechaObj || !descripcion"
            label="Registrar"
            class="btn-azul"
          />

          <Button type="button" label="Regresar al listado" class="btn-azul" @click="goList" />
        </div>
      </form>

      <div class="result ok" v-if="okMsg">{{ okMsg }}</div>
      <div class="result err" v-if="errMsg">{{ errMsg }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import { useAuthStore } from '@/stores/counter'

// PrimeVue components
import Button from 'primevue/button'
import InputText from 'primevue/inputtext'
import Calendar from 'primevue/calendar'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

// campos
const ui = ref('')
const acta = ref('')
const fecha = ref('') // string formateada que enviaremos
const fechaObj = ref(null) // objeto Date que usa el calendario
const descripcion = ref('')
const fileInput = ref(null)

const okMsg = ref('')
const errMsg = ref('')
const busy = ref(false)
const archivo = ref(null) // aquí guardaremos el archivo

function onFileChange(e) {
  archivo.value = e.target.files[0] || null
}

// nombres de meses en español (primera letra mayúscula)
const mesesES = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

onMounted(() => {
  // precarga desde query params
  ui.value = route.query.ui ? String(route.query.ui) : ''
  acta.value = route.query.acta ? String(route.query.acta) : ''

  // Si hay una fecha en query (por ejemplo 17-Junio-2014),
  // intentamos parsearla a Date para que el calendario muestre algo.
  if (route.query.fecha) {
    const qf = String(route.query.fecha)
    // Intentar parsear formatos comunes dd-MM-yyyy o dd-Mes-yyyy
    const parts = qf.split('-')
    if (parts.length === 3) {
      const d = parseInt(parts[0], 10)
      const m = parts[1]
      const y = parseInt(parts[2], 10)
      // si m es número:
      if (!isNaN(m)) {
        const date = new Date(y, parseInt(m, 10) - 1, d)
        if (!isNaN(date)) fechaObj.value = date
      } else {
        // m es nombre de mes (ej: Junio) -> buscar índice
        const idx = mesesES.findIndex(mm => mm.toLowerCase() === m.toLowerCase())
        if (idx >= 0) {
          const date = new Date(y, idx, d)
          if (!isNaN(date)) fechaObj.value = date
        }
      }
    }
  }

  // si no hay token, intenta cargar de storage
  if (!auth.token && typeof auth.loadFromStorage === 'function') {
    auth.loadFromStorage()
  }
})

function formatFechaParaBackend(d) {
  if (!d || !(d instanceof Date)) return ''
  const day = d.getDate()
  const monthName = mesesES[d.getMonth()]
  const year = d.getFullYear()
  return `${day}-${monthName}-${year}`
}

async function indexar() {
  okMsg.value = ''
  errMsg.value = ''

  // validar archivo
  const file = archivo.value
  if (!file) {
    errMsg.value = 'Debes seleccionar un archivo PDF.'
    return
  }

  // validar fecha seleccionada
  if (!fechaObj.value) {
    errMsg.value = 'Debes seleccionar una fecha para el anexo.'
    return
  }

  // formatear la fecha para enviar
  fecha.value = formatFechaParaBackend(fechaObj.value)

  busy.value = true
  try {
    const fd = new FormData()
    fd.append('ui_principal', ui.value)
    fd.append('acta', acta.value)
    fd.append('fecha', fecha.value) // cadena formateada, ej "17-Junio-2014"
    fd.append('descripcion', descripcion.value)
    fd.append('file', file)

    // Authorization si existe token
    const headers = {}
    const token = auth.token || localStorage.getItem('token') || ''
    if (token) headers.Authorization = `Bearer ${token}`

    const { data } = await axios.post('/api/registerAnexo', fd, { headers })

    const uiAnexo = data?.ui_anexo || 'N/D'

    // limpiar inputs (pero conservar ui/acta)
    fechaObj.value = null
    fecha.value = ''
    descripcion.value = ''
    if (fileInput.value) fileInput.value.value = ''

    /* okMsg.value = `Anexo registrado correctamente (UI: ${uiAnexo}). Puedes cargar otro anexo.` */
    okMsg.value = `Anexo registrado correctamente. Puedes cargar otro anexo.`
  } catch (e) {
    errMsg.value = `Error registrando anexo: ${e?.response?.data?.message || e?.message || String(e)}`
  } finally {
    busy.value = false
  }
}

function goList() {
  router.push('/main/lista_actas')
}
function goMain() {
  router.push('/main')
}
function logout() {
  if (typeof auth.eliminarToken === 'function') {
    auth.eliminarToken()
  } else if (typeof auth.logout === 'function') {
    auth.logout()
  } else {
    localStorage.removeItem('token')
  }
  router.replace('/login')
}
</script>

<style scoped>
/* contenedor base y centrado */
.anexo-wrap {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8fbff, #eaf1f9);
  display: flex;
  justify-content: center;    /* centrado horizontal */
  align-items: flex-start;    /* no lo baja al centro vertical */
  padding-top: 60px;          /* espacio desde arriba */
  font-family: Arial, sans-serif;
}

/* contenedor centrado con un ancho max y padding */
.anexo-centered {
  width: 100%;
  max-width: 760px;
  margin: 0 auto;
}

/* header */
.anexo-header {
  text-align: center;
  margin-bottom: 16px;
}
.anexo-header h2 {
  margin: 0;
  font-weight: 700;
  color: #0a2b4f;
}

/* formulario */
.anexo-form {
  background: #ffffff;
  border: 1px solid rgba(0,0,0,.06);
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 6px 20px rgba(0,0,0,.08);
}

/* grid filas etiqueta / control */
.row {
  display: grid;
  grid-template-columns: 180px 1fr;
  gap: 10px;
  align-items: center;
  margin-bottom: 12px;
}
.row label {
  font-weight: 700;
  color: #0a2b4f;
}
.anexo-form :deep(.p-inputtext) {
  background-color: #ffffff !important;
  color: #000000 !important;
  border: 1px solid #ccc !important;
}
/* estilo input file */
.file-row input[type="file"] {
  padding: 6px 8px;
  border: 1px dashed #99b7e0;
  border-radius: 8px;
  background: #f7fbff;
}

/* acciones (botones) */
.acciones-form {
  display: flex;
  gap: 10px;
  margin-top: 12px;
  justify-content: flex-end;
}

/* Botones azules con texto blanco: aplicamos a clases .btn-azul */
/* Usamos :deep para apuntar al .p-button interno de PrimeVue cuando scoped */
/* Botones azules con texto blanco */
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

/* Mensajes */
.result { margin-top: 12px; font-weight: 700; }
.ok { color: #1b7e1b; }
.err { color: #b00020; white-space: pre-wrap; }
</style>
