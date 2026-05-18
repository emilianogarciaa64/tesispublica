import axios from 'axios'

const api = axios.create()

api.interceptors.request.use((config) => {
  config.metadata = {
    startTime: performance.now(),
    clientDateIso: new Date().toISOString(),
    clientTimestampMs: Date.now()
  }
  return config
})

api.interceptors.response.use(
  (response) => {
    const endTime = performance.now()
    response.durationMs = endTime - (response.config.metadata?.startTime || endTime)
    response.clientDateIso = response.config.metadata?.clientDateIso || null
    response.clientTimestampMs = response.config.metadata?.clientTimestampMs || null
    return response
  },
  (error) => {
    const endTime = performance.now()
    if (error.config?.metadata?.startTime) {
      error.durationMs = endTime - error.config.metadata.startTime
      error.clientDateIso = error.config.metadata.clientDateIso || null
      error.clientTimestampMs = error.config.metadata.clientTimestampMs || null
    }
    return Promise.reject(error)
  }
)

export default api