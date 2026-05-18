/* import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubleCount = computed(() => count.value * 2)
  function increment() {
    count.value++
  }

  return { count, doubleCount, increment }
}) */

import { defineStore } from 'pinia'

const KEY = 'token'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem(KEY) || null,
  }),
  getters: {
    isAuthenticated: (s) => !!s.token,
  },
  actions: {
    guardarToken(token) {
      this.token = token
      if (token) localStorage.setItem(KEY, token)
      else localStorage.removeItem(KEY)
    },
    eliminarToken() {
      this.guardarToken(null)
    },
  },
})
