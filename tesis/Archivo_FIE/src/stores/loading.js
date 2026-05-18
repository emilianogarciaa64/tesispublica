import { defineStore } from 'pinia'

export const useLoadingStore = defineStore('loading', {
  state: () => ({
    visible: false,
    progress: 0,
    timer: null,
    label: 'Cargando...',
    requestsCount: 0
  }),

  actions: {
    start(label = 'Cargando...') {
      this.requestsCount++
      this.label = label
      this.visible = true

      if (this.progress <= 0) {
        this.progress = 4
      }

      if (!this.timer) {
        this.timer = setInterval(() => {
          if (this.progress < 85) {
            this.progress += Math.random() * 6
          }
        }, 220)
      }
    },

    finish() {
      this.requestsCount = Math.max(0, this.requestsCount - 1)

      if (this.requestsCount === 0) {
        this.progress = 100

        setTimeout(() => {
          this.reset()
        }, 300)
      }
    },

    fail() {
      this.requestsCount = Math.max(0, this.requestsCount - 1)

      if (this.requestsCount === 0) {
        this.reset()
      }
    },

    reset() {
      this.visible = false
      this.progress = 0
      this.label = 'Cargando...'
      this.requestsCount = 0

      if (this.timer) {
        clearInterval(this.timer)
        this.timer = null
      }
    }
  }
})