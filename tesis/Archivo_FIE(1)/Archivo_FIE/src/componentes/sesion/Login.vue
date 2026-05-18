<template>
  <div
    class="container d-flex justify-content-center align-items-center vh-100"
    
  >
    <div class="card shadow-lg p-4" style="width: 22rem; background: rgba(255,255,255,0.88); border-radius: 1rem;">
      <div class="text-center mb-3">
        <img :src="logo" class="rounded-circle" width="160" height="160" />
        <h3 class="text-primary mt-2">ARCHIVO</h3>
      </div>

      <form @submit.prevent="login">
        <div class="mb-3">
          <label for="nombre_usuario" class="form-label">Nombre de usuario:</label>
          <input
            v-model.trim="nombre_usuario"
            type="text"
            class="form-control"
            id="nombre_usuario"
            name="nombre_usuario"
            required
            autocomplete="username"
          />
        </div>
        <div class="mb-3">
          <label for="password" class="form-label">Contraseña:</label>
          <input
            v-model="password"
            type="password"
            class="form-control"
            id="password"
            name="password"
            required
            autocomplete="current-password"
          />
        </div>
        <button type="submit" class="btn btn-primary w-100" :disabled="loading">
          <span v-if="!loading">Iniciar sesión</span>
          <span v-else class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        </button>
      </form>

      <p v-if="error" class="text-danger mt-3 text-center">{{ error }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/counter'
import api from '@/env/ApiREST'

// imágenes (ajústalas a tu carpeta)
import logo from '@/assets/img/logo_archivo_fie.png'
import bgImg from '@/assets/img/fondo_login.png'

const router = useRouter()
const auth = useAuthStore()

const nombre_usuario = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')

async function login () {
  error.value = ''
  loading.value = true
  try {
    const { data } = await axios.post(`/api/login`, {
      nombre_usuario: nombre_usuario.value,
      password: password.value
    })

    if (data?.token) {
      auth.guardarToken(data.token)        // Pinia + localStorage
      await router.push('/main')           // a Pagina_Principal.vue
    } else {
      error.value = data?.message || 'Login fallido'
    }
  } catch (e) {
    error.value = e?.response?.data?.message || 'Error en la solicitud'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.container {
  width: 100vw;
  height: 100vh;
  background-color: #ffffff;   /* fondo blanco */
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 1rem;               /* opcional para que no toque los bordes en móviles */
}

.card {
  background: rgba(255, 255, 255, 0.95); /* ligeramente transparente si quieres */
  border-radius: 1rem;
  padding: 2rem;
  width: 22rem;
  max-width: 90%;
  box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.25);
}

.card img {
  width: 160px;
  height: 160px;
  border-radius: 50%;
  object-fit: cover;
}

.btn-primary {
  width: 100%;
}

.spinner-border {
  display: inline-block;
  vertical-align: middle;
}


</style>