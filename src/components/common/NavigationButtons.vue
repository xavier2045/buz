<template>
  <div class="navigation">
    <button class="back-btn" @click="onBack" :disabled="backDisabled">
      <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="arrow" class="arrow-icon arrow-back">
        <path d="M17.7,11.2C17.7,11.2,17.7,11.2,17.7,11.2l-5-5c-0.4-0.4-1-0.4-1.4,0c-0.4,0.4-0.4,1,0,1.4l3.3,3.3H7c-0.6,0-1,0.4-1,1
          s0.4,1,1,1h7.6l-3.3,3.3c-0.4,0.4-0.4,1,0,1.4c0.4,0.4,1,0.4,1.4,0c0,0,0,0,0,0l5-5C18.1,12.3,18.1,11.6,17.7,11.2z"></path>
      </svg>
    </button>
    
    <!-- Uiverse animated button for next -->
    <button class="uiverse" @click="onNext" :disabled="nextDisabled">
      <div class="wrapper">
        <span v-if="!isFinalStep">
          <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="arrow" class="arrow-icon">
            <path d="M17.7,11.2C17.7,11.2,17.7,11.2,17.7,11.2l-5-5c-0.4-0.4-1-0.4-1.4,0c-0.4,0.4-0.4,1,0,1.4l3.3,3.3H7c-0.6,0-1,0.4-1,1
              s0.4,1,1,1h7.6l-3.3,3.3c-0.4,0.4-0.4,1,0,1.4c0.4,0.4,1,0.4,1.4,0c0,0,0,0,0,0l5-5C18.1,12.3,18.1,11.6,17.7,11.2z"></path>
          </svg>
        </span>
        <span v-else>
          发布
        </span>
        
        <!-- Animated circles -->
        <div class="circle circle-1" style="animation: circle-1 7s linear infinite;"></div>
        <div class="circle circle-2" style="animation: circle-2 7s linear infinite;"></div>
        <div class="circle circle-3" style="animation: circle-3 7s linear infinite;"></div>
        <div class="circle circle-4" style="animation: circle-4 7s linear infinite;"></div>
        <div class="circle circle-5" style="animation: circle-5 7s linear infinite;"></div>
        <div class="circle circle-6" style="animation: circle-6 7s linear infinite;"></div>
        <div class="circle circle-7" style="animation: circle-7 7s linear infinite;"></div>
        <div class="circle circle-8" style="animation: circle-8 7s linear infinite;"></div>
        <div class="circle circle-9" style="animation: circle-9 7s linear infinite;"></div>
        <div class="circle circle-10" style="animation: circle-10 7s linear infinite;"></div>
        <div class="circle circle-11" style="animation: circle-11 7s linear infinite;"></div>
        <div class="circle circle-12" style="animation: circle-12 7s linear infinite;"></div>
      </div>
    </button>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';

defineProps({
  backText: {
    type: String,
    default: '返回'
  },
  nextText: {
    type: String,
    default: '下一步'
  },
  backDisabled: {
    type: Boolean,
    default: false
  },
  nextDisabled: {
    type: Boolean,
    default: false
  },
  isFinalStep: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['back', 'next']);

const onBack = () => {
  emit('back');
};

const onNext = () => {
  emit('next');
};

// Add script to handle hover animation speed
onMounted(() => {
  const uiverseButton = document.querySelector('.uiverse');
  const circles = document.querySelectorAll('.uiverse .circle');

  if (uiverseButton) {
    uiverseButton.addEventListener('mouseenter', () => {
      circles.forEach(circle => {
        // @ts-ignore
        circle.style.animationDuration = '1.4s';
      });
    });

    uiverseButton.addEventListener('mouseleave', () => {
      circles.forEach(circle => {
        // @ts-ignore
        circle.style.animationDuration = '7s';
      });
    });
    
    // 立即触发一次动画效果，确保动画始终可见
    setTimeout(() => {
      circles.forEach(circle => {
        // @ts-ignore
        const currentDuration = circle.style.animationDuration;
        // @ts-ignore
        circle.style.animationDuration = '1.4s';
        
        setTimeout(() => {
          // @ts-ignore
          circle.style.animationDuration = currentDuration || '7s';
        }, 800);
      });
    }, 500);
  }
});
</script>

<style scoped>
.navigation {
  display: flex;
  justify-content: space-between;
  width: 100%;
  max-width: 600px;
  margin: 40px auto 0;
  padding: 0 20px;
}

.back-btn {
  display: flex;
  align-items: center;
  padding: 10px 24px;
  border-radius: 24px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  margin: 0;
}

.back-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.2);
}

.back-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.arrow-icon {
  width: 32px;
  height: 32px;
  fill: currentColor;
}

.arrow-back {
  transform: rotate(180deg);
}

/* Uiverse button style */
.uiverse {
  --duration: 7s;
  --easing: linear;
  --c-color-1: #ffd58c;
  --c-color-2: #69a5ff;
  --c-color-3: #c29fff;
  --c-color-4: rgba(140, 232, 255, 0.8);
  --c-shadow: rgba(99, 85, 255, 0.7);
  --c-shadow-inset-top: rgba(132, 156, 255, 0.9);
  --c-shadow-inset-bottom: rgba(62, 145, 255, 0.7);
  --c-radial-inner: #2f3fbb;
  --c-radial-outer: #5264fa;
  --c-color: #ffffff;
  -webkit-tap-highlight-color: transparent;
  -webkit-appearance: none;
  outline: none;
  position: relative;
  cursor: pointer;
  border: none;
  display: table;
  border-radius: 24px;
  padding: 0;
  margin: 0;
  text-align: center;
  font-weight: 600;
  font-size: 16px;
  letter-spacing: 0.05em;
  line-height: 1.5;
  color: var(--c-color);
  background: radial-gradient(
    circle,
    var(--c-radial-inner),
    var(--c-radial-outer) 80%
  );
  box-shadow: 0 0 14px var(--c-shadow);
}

.uiverse:before {
  content: "";
  pointer-events: none;
  position: absolute;
  z-index: 3;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  border-radius: 28px;
  box-shadow:
    inset 0 3px 12px var(--c-shadow-inset-top),
    inset 0 -3px 4px var(--c-shadow-inset-bottom);
}

.uiverse .wrapper {
  -webkit-mask-image: -webkit-radial-gradient(white, black);
  overflow: hidden;
  border-radius: 26px;
  min-width: 132px;
  padding: 12px 24px;
}

.uiverse .wrapper span {
  display: inline-block;
  position: relative;
  z-index: 1;
}

.uiverse:hover {
  --duration: 1400ms;
}

.uiverse:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  --c-radial-inner: #6c6c6c;
  --c-radial-outer: #9c9c9c;
  --c-shadow: rgba(99, 99, 99, 0.59);
}

.uiverse:disabled .wrapper span {
  opacity: 0.8;
}

.uiverse:disabled .wrapper .circle {
  opacity: 0.5;
}

.uiverse .wrapper .circle {
  position: absolute;
  left: 0;
  top: 0;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  filter: blur(var(--blur, 8px));
  background: var(--background, transparent);
  transform: translate(var(--x, 0), var(--y, 0)) translateZ(0);
  animation-name: var(--animation) !important;
  animation-duration: var(--duration) !important;
  animation-timing-function: var(--easing) !important;
  animation-iteration-count: infinite !important;
}

.uiverse .wrapper .circle.circle-1,
.uiverse .wrapper .circle.circle-9,
.uiverse .wrapper .circle.circle-10 {
  --background: var(--c-color-4);
}

.uiverse .wrapper .circle.circle-3,
.uiverse .wrapper .circle.circle-4 {
  --background: var(--c-color-2);
  --blur: 14px;
}

.uiverse .wrapper .circle.circle-5,
.uiverse .wrapper .circle.circle-6 {
  --background: var(--c-color-3);
  --blur: 16px;
}

.uiverse .wrapper .circle.circle-2,
.uiverse .wrapper .circle.circle-7,
.uiverse .wrapper .circle.circle-8,
.uiverse .wrapper .circle.circle-11,
.uiverse .wrapper .circle.circle-12 {
  --background: var(--c-color-1);
  --blur: 12px;
}

.uiverse .wrapper .circle.circle-1 {
  --x: 0;
  --y: -40px;
  --animation: circle-1;
}

.uiverse .wrapper .circle.circle-2 {
  --x: 92px;
  --y: 8px;
  --animation: circle-2;
}

.uiverse .wrapper .circle.circle-3 {
  --x: -12px;
  --y: -12px;
  --animation: circle-3;
}

.uiverse .wrapper .circle.circle-4 {
  --x: 80px;
  --y: -12px;
  --animation: circle-4;
}

.uiverse .wrapper .circle.circle-5 {
  --x: 12px;
  --y: -4px;
  --animation: circle-5;
}

.uiverse .wrapper .circle.circle-6 {
  --x: 56px;
  --y: 16px;
  --animation: circle-6;
}

.uiverse .wrapper .circle.circle-7 {
  --x: 8px;
  --y: 28px;
  --animation: circle-7;
}

.uiverse .wrapper .circle.circle-8 {
  --x: 28px;
  --y: -4px;
  --animation: circle-8;
}

.uiverse .wrapper .circle.circle-9 {
  --x: 20px;
  --y: -12px;
  --animation: circle-9;
}

.uiverse .wrapper .circle.circle-10 {
  --x: 64px;
  --y: 16px;
  --animation: circle-10;
}

.uiverse .wrapper .circle.circle-11 {
  --x: 4px;
  --y: 4px;
  --animation: circle-11;
}

.uiverse .wrapper .circle.circle-12 {
  --blur: 14px;
  --x: 52px;
  --y: 4px;
  --animation: circle-12;
}

@keyframes circle-1 {
  33% {
    transform: translate(0px, 16px) translateZ(0);
  }

  66% {
    transform: translate(12px, 64px) translateZ(0);
  }
}

@keyframes circle-2 {
  33% {
    transform: translate(80px, -10px) translateZ(0);
  }

  66% {
    transform: translate(72px, -48px) translateZ(0);
  }
}

@keyframes circle-3 {
  33% {
    transform: translate(20px, 12px) translateZ(0);
  }

  66% {
    transform: translate(12px, 4px) translateZ(0);
  }
}

@keyframes circle-4 {
  33% {
    transform: translate(76px, -12px) translateZ(0);
  }

  66% {
    transform: translate(112px, -8px) translateZ(0);
  }
}

@keyframes circle-5 {
  33% {
    transform: translate(84px, 28px) translateZ(0);
  }

  66% {
    transform: translate(40px, -32px) translateZ(0);
  }
}

@keyframes circle-6 {
  33% {
    transform: translate(28px, -16px) translateZ(0);
  }

  66% {
    transform: translate(76px, -56px) translateZ(0);
  }
}

@keyframes circle-7 {
  33% {
    transform: translate(8px, 28px) translateZ(0);
  }

  66% {
    transform: translate(20px, -60px) translateZ(0);
  }
}

@keyframes circle-8 {
  33% {
    transform: translate(32px, -4px) translateZ(0);
  }

  66% {
    transform: translate(56px, -20px) translateZ(0);
  }
}

@keyframes circle-9 {
  33% {
    transform: translate(20px, -12px) translateZ(0);
  }

  66% {
    transform: translate(80px, -8px) translateZ(0);
  }
}

@keyframes circle-10 {
  33% {
    transform: translate(68px, 20px) translateZ(0);
  }

  66% {
    transform: translate(100px, 28px) translateZ(0);
  }
}

@keyframes circle-11 {
  33% {
    transform: translate(4px, 4px) translateZ(0);
  }

  66% {
    transform: translate(68px, 20px) translateZ(0);
  }
}

@keyframes circle-12 {
  33% {
    transform: translate(56px, 0px) translateZ(0);
  }

  66% {
    transform: translate(60px, -32px) translateZ(0);
  }
}
</style> 