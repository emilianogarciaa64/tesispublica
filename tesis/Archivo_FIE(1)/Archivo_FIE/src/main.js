import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import App from './App.vue'

// Bootstrap (opcional, como ya lo usabas)
import '@popperjs/core'
import 'bootstrap'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap-icons/font/bootstrap-icons.css'

// PrimeVue 4 + Aura
import PrimeVue from 'primevue/config'
import Aura from '@primeuix/themes/aura'   // ← OJO: @primeuix (no @primevue)
import 'primeicons/primeicons.css'

// Services/directivas de PrimeVue
import ToastService from 'primevue/toastservice'
import StyleClass from 'primevue/styleclass'
import Ripple from 'primevue/ripple'

// Componentes que quieras globales (puedes agregar/quitar)
import Toast from 'primevue/toast'
import Avatar from 'primevue/avatar'
import Button from 'primevue/button'
import Panel from 'primevue/panel'
import Card from 'primevue/card'
import DataView from 'primevue/dataview'
import Terminal from 'primevue/terminal'
import TerminalService from 'primevue/terminalservice'
import Tabs from 'primevue/tabs'
import TabList from 'primevue/tablist'
import Tab from 'primevue/tab'
import TabPanels from 'primevue/tabpanels'
import TabPanel from 'primevue/tabpanel'
import Calendar from 'primevue/calendar'

// (Si NO existe este archivo, borra esta línea)
//import '@/assets/primevue-drawer-overrides.css' // crea el archivo vacío o elimina esta import

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.use(PrimeVue, {
  ripple: true,
  theme: {
    preset: Aura,             // tema Aura
    options: {
      darkModeSelector: 'system', // respeta modo oscuro del SO
      cssLayer: false
    }
  },
  locale: {
    firstDayOfWeek: 1,
    dayNames: ["domingo","lunes","martes","miércoles","jueves","viernes","sábado"],
    dayNamesShort: ["dom","lun","mar","mié","jue","vie","sáb"],
    dayNamesMin: ["D","L","M","X","J","V","S"],
    monthNames: ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"],
    monthNamesShort: ["ene","feb","mar","abr","may","jun","jul","ago","sep","oct","nov","dic"],
    today: 'Hoy',
    clear: 'Limpiar'
  }
})

app.use(ToastService)
app.directive('styleclass', StyleClass)
app.directive('ripple', Ripple)

// Registros globales (si los necesitas globalmente)
app.component('Toast', Toast)
app.component('Avatar', Avatar)
app.component('Button', Button)
app.component('Panel', Panel)
app.component('Card', Card)
app.component('DataView', DataView)
app.component('Terminal', Terminal)
app.component('Tabs', Tabs)
app.component('TabList', TabList)
app.component('Tab', Tab)
app.component('TabPanels', TabPanels)
app.component('TabPanel', TabPanel)
app.component('Calendar', Calendar) 

app.mount('#app')
//const auth = useAuthStore()
//auth.initFromStorage() 