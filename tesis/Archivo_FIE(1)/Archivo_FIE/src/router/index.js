import { createRouter, createWebHistory } from 'vue-router'
import Login from '@/componentes/sesion/Login.vue'
import ViewMenu from '@/componentes/main/Menu.vue'
import Buscar_Actas from '@/componentes/documentos/Buscar_Actas.vue'
import Indexar_Actas from '@/componentes/documentos/Indexar_Actas.vue'
import Lista_Actas from '@/componentes/documentos/Lista_Actas.vue'
import Registrar_Anexos from '@/componentes/documentos/Registrar_Anexos.vue'
import Render_PDF from '@/componentes/documentos/Render_PDF.vue'
import Render_Anexo from '@/componentes/documentos/Render_Anexo.vue'
import Crear_Expediente from '@/componentes/documentos/Crear_Expediente.vue'
import Reporte_Expediente from '@/componentes/documentos/Reporte_Expediente.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', redirect: '/login' },

    { path: '/login', name: 'Login', component: Login },

    // Panel de tarjetas (sin hijos)
    { 
      path: '/main', 
      name: 'main', 
      component: ViewMenu, 
      children : [
        { path: '/main/indexar_actas', component: Indexar_Actas },
        { path: '/main/buscar_actas', name: 'BuscarActas',component: Buscar_Actas },
        { path: '/main/lista_actas', component: Lista_Actas},
        { path: '/main/registrar_anexos', component: Registrar_Anexos},
        { path: '/main/renderPDF', component: Render_PDF},
        { path: '/main/renderAnexo', component: Render_Anexo},
        { path: '/main/crearExpediente', component: Crear_Expediente},
        { path: '/main/reporteExpediente', component: Reporte_Expediente}
      ]
    
    
    },
    // 404 opcional
    { path: '/:pathMatch(.*)*', redirect: '/login' },
  ],
})

export default router
