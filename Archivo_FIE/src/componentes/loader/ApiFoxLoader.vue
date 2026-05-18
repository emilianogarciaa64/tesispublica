<template>
  <transition name="fade">
    <div v-if="visible" class="fox-loader-overlay">
      <div class="fox-loader-box">
        <div class="fox-track">
          <img
            :src="imageSrc"
            alt="Cargando"
            class="fox-image"
            :style="foxStyle"
          />
        </div>

        <div class="fox-progress">
          <div class="fox-progress-bar" :style="progressStyle"></div>
        </div>

        <div v-if="label" class="fox-label">
          {{ label }}
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  progress: {
    type: Number,
    default: 0
  },
  imageSrc: {
    type: String,
    required: true
  },
  label: {
    type: String,
    default: 'Cargando...'
  },
  maxTravel: {
    type: Number,
    default: 320
  }
})

const safeProgress = computed(() => {
  const value = Number(props.progress) || 0
  return Math.min(100, Math.max(0, value))
})

const foxStyle = computed(() => ({
  transform: `translateX(${(safeProgress.value / 100) * props.maxTravel}px)`,
  transition: 'transform 220ms linear'
}))

const progressStyle = computed(() => ({
  width: `${safeProgress.value}%`,
  transition: 'width 220ms linear'
}))
</script>

<style scoped>
.fox-loader-overlay {
  position: fixed;
  inset: 0;
  z-index: 3000;
  background: rgba(0, 0, 0, 0.18);
  display: flex;
  align-items: center;
  justify-content: center;
}

.fox-loader-box {
  width: 560px;
  max-width: calc(100vw - 32px);
  padding: 24px 20px 18px;
  border-radius: 18px;
  background: rgba(17, 24, 39, 0.55);
  box-shadow: 0 18px 50px rgba(0, 0, 0, 0.22);
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
  text-align: center;
}

.fox-track {
  position: relative;
  width: 100%;
  height: 120px;
  overflow: hidden;
  margin-bottom: 12px;
}

.fox-image {
  position: absolute;
  left: 0;
  bottom: 8px;
  width: 320px;
  max-width: none;
  user-select: none;
  pointer-events: none;
  filter: drop-shadow(0 10px 12px rgba(59, 130, 246, 0.25));
  transition: transform 220ms linear;
}

.fox-progress {
  width: 100%;
  height: 8px;
  background: rgba(255, 255, 255, 0.12);
  border-radius: 999px;
  overflow: hidden;
}

.fox-progress-bar {
  height: 100%;
  width: 0;
  border-radius: 999px;
  background: linear-gradient(90deg, #2563eb, #60a5fa);
  box-shadow: 0 0 12px rgba(96, 165, 250, 0.55);
}

.fox-label {
  margin-top: 10px;
  color: #cbdcf4;
  font-size: 0.95rem;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>