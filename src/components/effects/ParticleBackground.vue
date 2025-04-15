<template>
  <div class="particle-background" :style="containerStyle">
    <!-- 添加粒子漩涡背景 -->
    <ParticleWhirlpool class="background-particles" />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import ParticleWhirlpool from '../common/ParticleWhirlpool.vue';

// 定义可配置的props
interface Props {
  opacity?: number;
  scale?: number;
}

const props = withDefaults(defineProps<Props>(), {
  opacity: 0.9,
  scale: 1
});

// 根据props计算样式
const containerStyle = computed(() => {
  return {
    opacity: props.opacity,
    transform: `scale(${props.scale})`
  };
});
</script>

<style scoped>
.particle-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  overflow: hidden;
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.background-particles {
  width: 100%;
  height: 100%;
}
</style> 