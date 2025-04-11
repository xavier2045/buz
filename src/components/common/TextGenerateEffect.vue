<template>
  <div 
    ref="textContainer" 
    class="text-generate-effect"
    :class="{
      'text-generate-effect-animated': animated,
      'with-underline': withUnderline
    }"
  >
    <span 
      v-for="(char, index) in characters" 
      :key="index"
      class="text-generate-character"
      :style="{ 
        animationDelay: `${Math.max(index * 0.035, 0)}s`,
        opacity: animated ? 1 : 0
      }"
    >{{ char }}</span>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue';

const props = defineProps({
  text: {
    type: String,
    required: true
  },
  autoStart: {
    type: Boolean,
    default: true
  },
  withGlow: {
    type: Boolean,
    default: true
  },
  withUnderline: {
    type: Boolean,
    default: true
  }
});

const textContainer = ref<HTMLElement | null>(null);
const animated = ref(false);

const characters = computed(() => {
  return props.text.split('');
});

const startAnimation = () => {
  animated.value = true;
};

const resetAnimation = () => {
  animated.value = false;
  setTimeout(() => {
    startAnimation();
  }, 100);
};

watch(() => props.text, resetAnimation);

onMounted(() => {
  if (props.autoStart) {
    // Small delay for better visual effect when page loads
    setTimeout(startAnimation, 300);
  }
});

defineExpose({
  startAnimation,
  resetAnimation
});
</script>

<style scoped>
.text-generate-effect {
  display: inline-block;
  position: relative;
}

.text-generate-effect.with-underline::after {
  content: "";
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 0;
  height: 2px;
  background: linear-gradient(90deg, 
    rgba(140, 232, 255, 0), 
    rgba(140, 232, 255, 0.8) 50%, 
    rgba(140, 232, 255, 0));
  animation: lineReveal 1.5s forwards;
  animation-delay: 0.6s;
  box-shadow: 0 0 10px rgba(140, 232, 255, 0.6);
  opacity: 0;
}

.text-generate-effect-animated.with-underline::after {
  opacity: 1;
}

.text-generate-character {
  display: inline-block;
  opacity: 0;
  animation-name: characterReveal;
  animation-duration: 0.5s;
  animation-fill-mode: forwards;
  animation-timing-function: cubic-bezier(0.11, 0.8, 0.33, 1);
}

@keyframes characterReveal {
  0% {
    opacity: 0;
    transform: translateY(30px) scale(0.9);
    filter: blur(8px);
    color: rgba(255, 255, 255, 0.5);
    text-shadow: none;
  }
  60% {
    filter: blur(0);
    opacity: 0.8;
  }
  100% {
    opacity: 1;
    transform: translateY(0) scale(1);
    filter: blur(0);
    color: white;
    text-shadow: 0 0 20px rgba(140, 232, 255, 0.6);
  }
}

@keyframes lineReveal {
  0% {
    width: 0;
  }
  100% {
    width: 100%;
  }
}
</style> 