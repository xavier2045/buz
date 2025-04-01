<template>
  <div class="blur-container" :style="containerStyle">
    <slot></slot>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  blurAmount?: number
  bgOpacity?: number
  borderColor?: string
  borderOpacity?: number
  borderRadius?: number
}

const props = withDefaults(defineProps<Props>(), {
  blurAmount: 40,
  bgOpacity: 0.16,
  borderColor: '255, 255, 255',
  borderOpacity: 0,
  borderRadius: 0
})

const containerStyle = computed(() => {
  const blurValue = `${props.blurAmount}px`
  
  return {
    backdropFilter: `blur(${blurValue})`,
    WebkitBackdropFilter: `blur(${blurValue})`,
    background: `rgba(229, 229, 229, ${props.bgOpacity})`,
    borderRadius: `${props.borderRadius}px`
  }
})
</script>

<style scoped>
.blur-container {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  overflow: hidden;
}
</style> 