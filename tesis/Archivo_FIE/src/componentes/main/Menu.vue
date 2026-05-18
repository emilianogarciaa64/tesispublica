<template>
    <div class="card">
      
      <!-- Contenedor centrado -->
      <div class="contenedor-centrado">
        <Encabezado />
      </div>
      <!-- Menubar ocupa todo el ancho -->
      <Menubar :model="itemsFiltrados" class="custom-menubar">
        <template #item="{ item, props, hasSubmenu, root }">
          <router-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom class="segundo">
            <a v-ripple :href="href" v-bind="props.action" @click="navigate">
              <span :class="item.icon" />
              <span>{{ item.label }}</span>
            </a>
          </router-link>
          <a v-else v-ripple :href="item.url" :target="item.target" v-bind="props.action" class="primero">
            <span :class="item.icon" />
            <span>{{ item.label }}</span>
            <span v-if="hasSubmenu" class="pi pi-fw pi-angle-down" />
          </a>
        </template>
        <template #end>
          <Toast />
          <Button severity="secondary" rounded text @click="toggle" class="userboton">{{ usuario }}</Button>
          <Menu ref="menu" id="config_menu" :model="items2" popup  /> 
        </template>
      </Menubar>
  
      <!-- <router-view /> -->
       <RouterView v-slot="{ Component, route }">
            <KeepAlive include="BuscarActas">
            <component v-if="Component" :is="Component" :key="route.name" />
            </KeepAlive>
        </RouterView>
    </div>
  </template>

<script setup>
import { ref } from "vue";
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/counter'
import Menubar from "primevue/menubar"
import InputText from 'primevue/inputtext';
import Badge from 'primevue/badge';
import Menu from 'primevue/menu';
import Avatar from 'primevue/avatar';
import { useToast } from "primevue/usetoast";
import Encabezado from './Encabezado.vue'
import axios from 'axios';

const router = useRouter();
const auth = useAuthStore()

const usuario = ref('');
const rol = ref('');
const menu = ref(null);
const toast = useToast();
const itemsFiltrados = ref([]);

const items = ref([
  {
      icon: 'pi pi-home',
      /*route: '/main'*/
  },
  {
      label: 'Actas de consejo',
      icon: 'pi pi-search',
      badge: 3,
      items: [
          {
              label: 'Registrar Actas',
              icon: 'pi pi-bolt',
              shortcut: '⌘+S',
              route: '/main/indexar_actas'
          },
          {
              separator: true
          },
          {
              label: 'Buscar Actas',
              icon: 'pi pi-bolt',
              shortcut: '⌘+S',
              name: 'BuscarActas',
              route: '/main/buscar_actas'
              
          },
          {
              separator: true
          },
          {
              label: 'Registrar Anexo',
              icon: 'pi pi-bolt',
              shortcut: '⌘+S',
              route: '/main/lista_actas'
              
          }
      ]
  },
  {
      label: 'Expedientes',
      icon: 'pi pi-search',
      name: 'Expedientes',
      badge: 3,
      items: [
          {
              label: 'Crear Expediente',
              icon: 'pi pi-bolt',
              shortcut: '⌘+S',
              route: '/main/crearExpediente'
          }/*,
          {
              separator: true
          },
          {
              label: 'Reporte Expediente',
              icon: 'pi pi-bolt',
              shortcut: '⌘+S',
              route: '/main/reporteExpediente'
              
          }*/
      ]
  }
]);

const items2 = ref([
    /*{
        label: 'Perfil',
        icon: 'pi pi-user-edit'
    },*/
    {
        label: 'Cerrar Sesión',
        icon: 'pi pi-sign-out',
        command: () => {
            logout()
        }
    },
    {
        separator: true
    }
]);
axios.interceptors.response.use(
  response => response,
  async error => {
    if (error.response && error.response.status === 403) {
      await auth.eliminarToken();
      router.replace('/login');
    }
    return Promise.reject(error);
  }
);


const toggle = (event) => {
    menu.value.toggle(event);
};

const save = () => {
    toast.add({ severity: 'success', summary: 'Success', detail: 'Data Saved', life: 3000 });
}; 
function logout() {
    auth.eliminarToken()
    router.replace('/login')
}
// Función para cargar usuario y rol
const cargarUsuario = async () => {
  try {
    const headers = auth.token ? { Authorization: `Bearer ${auth.token}` } : {};

    // Obtener nombre de usuario
    const userResp = await axios.post('/api/usuario_name', {}, { headers });
    usuario.value = userResp.data.id_usuario; // si quieres mostrar el nombre real, cambia el backend para enviar nombre_usuario

    // Obtener rol
    const rolResp = await axios.post('/api/usuario_rol', {}, { headers });
    rol.value = rolResp.data.rol;

    const ocultarRoots = ['Expedientes'];        // menús principales a ocultar
    const ocultarSubs  = ['BuscarActas'];        // submenús a ocultar

    if (rol.value === 'admin') {
      itemsFiltrados.value = items.value;
    } else {
      itemsFiltrados.value = items.value
        // 1) QUITAR ROOTS COMPLETOS
        .filter(item => !ocultarRoots.includes(item.name))
        // 2) FILTRAR SUBITEMS
        .map(item => {
          if (!item.items) return item;
          return {
            ...item,
            items: item.items.filter(sub =>
              !ocultarSubs.includes(sub.name)
            )
          };
        });
    }


  } catch (err) {
    console.error('Error cargando usuario/rol:', err);
  }
};

// Ejecutar al montar
cargarUsuario();

</script>
<style lang="css" scoped>

.contenedor-centrado {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    height: 70px !important;
    width: fit-content;
    padding-top: 5px;
    margin-left: 200px !important; /* Sobreescribe la regla global */
    margin: 0px 200px !important;
}

.custom-menubar {
    width: 97vw !important; /* Reduce el ancho total para dejar 15px de espacio en cada lado */
    height: 60px; /* Altura del menú */
    background-color: #00196f; /* Color de fondo */
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px !important;
    margin: 0 15px !important; /* Centra el Menubar con la separación */
    position: relative;
    top: 0;
    left: 0;
    z-index: 1000;
    color: white !important;
    border-radius: 5px; /* Opcional: esquinas redondeadas */
}


/* === ESTILO PARA LOS PRIMEROS ENLACES (a) === */
/* Letras blancas y fondo transparente */
.primero {
    color: white !important;
    text-decoration: none !important; /* Sin subrayado */
    background-color: #00196f!important; /* Sin fondo */
    padding: 0 !important; /* Sin padding */
    border: none !important; /* Sin bordes */
}

.primero:hover{
    color: white !important;
    background-color: rgb(73, 72, 150) !important;
}
/* === ESTILO PARA LOS SEGUNDOS ENLACES (a) === */
/* Letras negras y fondo blanco */
.segundo{
    color: rgb(15, 15, 15) !important;
    background-color: rgb(236, 237, 241) !important;
    padding: 5px 10px;
    border-radius: 5px; /* Bordes redondeados opcionales */
}
</style>
