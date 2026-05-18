import api from '@/services/api'

export async function guardarRendimiento(payload, authHeaders = {}) {
  return await api.post('/api/rendimiento', payload, {
    headers: authHeaders,
    skipPerformanceLog: true
  })
}