<template>
  <div class="remix-container">
    <div class="remix-header">
      <div class="header-text">
        <p>好的，太好了。</p>
        <p>其他创作者可以重新混合这部作品吗？</p>
      </div>
      <div class="assistant-avatar">
        <img src="/images/girl-pointing-up_1.png" alt="AE Assistant" />
      </div>
    </div>

    <div class="remix-options">
      <div 
        class="remix-option" 
        :class="{ selected: selectedRemix === 'yes' }"
        @click="selectRemix('yes')"
      >
        <span>是的</span>
      </div>
      <div 
        class="remix-option" 
        :class="{ selected: selectedRemix === 'no' }"
        @click="selectRemix('no')"
      >
        <span>不</span>
      </div>
    </div>
    
    <!-- 使用NavigationButtons组件 -->
    <div class="navigation-section">
      <button class="back-btn" @click="goBack">
        <svg class="arrow-icon arrow-back" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M5 12h14M12 5l7 7-7 7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
        </svg>
        <span>返回</span>
      </button>
      
      <button class="uiverse" @click="goNext" :disabled="!isValidSelection">
        <div class="wrapper">
          <span>下一步</span>
          <div class="circle circle-1"></div>
          <div class="circle circle-2"></div>
          <div class="circle circle-3"></div>
          <div class="circle circle-4"></div>
          <div class="circle circle-5"></div>
          <div class="circle circle-6"></div>
          <div class="circle circle-7"></div>
          <div class="circle circle-8"></div>
          <div class="circle circle-9"></div>
          <div class="circle circle-10"></div>
          <div class="circle circle-11"></div>
          <div class="circle circle-12"></div>
        </div>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

const emit = defineEmits(['select-remix', 'navigate-back']);
const selectedRemix = ref('');

// 检查选择是否有效
const isValidSelection = computed(() => {
  return selectedRemix.value !== '';
});

const props = defineProps({
  sourceTab: {
    type: String,
    default: '' // 可以是 'preset', 'custom', 'assistant' 或空字符串
  },
  licenseType: {
    type: String,
    default: 'commercial'
  },
  expiration: {
    type: String,
    default: ''
  }
});

const selectRemix = (remixType: string) => {
  selectedRemix.value = remixType;
};

const goBack = () => {
  // 返回时发送源标签页信息，让父组件知道应该显示哪个标签页
  emit('navigate-back', props.sourceTab);
};

const goNext = () => {
  if (selectedRemix.value) {
    emit('select-remix', selectedRemix.value);
  }
};
</script>

<style scoped>
.remix-container {
  width: 100%;
  max-width: 800px;
  background: rgba(15, 15, 20, 0.85);
  border-radius: 16px;
  padding: 80px 30px 70px;
  position: relative;
  color: white;
  margin-top: 40px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
}

.remix-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 80px;
}

.header-text {
  flex: 1;
  padding-left: 100px;
  max-width: 600px;
  margin: 0 auto;
}

.header-text p {
  margin: 8px 0;
}

.header-text p:first-child {
  font-size: 28px;
  font-weight: 500;
  margin-bottom: 12px;
}

.header-text p:nth-child(2),
.header-text p:nth-child(3) {
  font-size: 20px;
  color: rgba(255, 255, 255, 0.9);
  margin: 5px 0;
}

.assistant-avatar {
  width: 120px;
  height: 120px;
  overflow: visible;
  background: transparent;
  margin-left: 30px;
  margin-right: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.assistant-avatar img {
  width: 140px;
  height: 140px;
  object-fit: contain;
  filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
  background-color: transparent;
  transform: translateX(-120px);
}

.remix-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 25px;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 60px;
}

.remix-option {
  background: rgba(25, 25, 30, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 14px;
  padding: 20px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.remix-option.selected {
  background: rgba(74, 144, 226, 0.2);
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.remix-option:hover {
  background: rgba(40, 40, 45, 0.7);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.remix-option.selected:hover {
  background: rgba(74, 144, 226, 0.25);
}

.remix-option span {
  font-size: 17px;
  font-weight: 500;
}

.navigation-section {
  display: flex;
  justify-content: space-between;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
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
  fill: none;
  stroke: currentColor;
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
  --x: -30%;
  --y: -30%;
  --animation: c1;
}

.uiverse .wrapper .circle.circle-2 {
  --x: -25%;
  --y: 150%;
  --animation: c2;
}

.uiverse .wrapper .circle.circle-3 {
  --x: 150%;
  --y: -30%;
  --animation: c3;
}

.uiverse .wrapper .circle.circle-4 {
  --x: 100%;
  --y: 100%;
  --animation: c4;
}

.uiverse .wrapper .circle.circle-5 {
  --x: 80%;
  --y: -80%;
  --animation: c5;
}

.uiverse .wrapper .circle.circle-6 {
  --x: -70%;
  --y: -70%;
  --animation: c6;
}

.uiverse .wrapper .circle.circle-7 {
  --x: 100%;
  --y: -40%;
  --animation: c7;
}

.uiverse .wrapper .circle.circle-8 {
  --x: -100%;
  --y: -40%;
  --animation: c8;
}

.uiverse .wrapper .circle.circle-9 {
  --x: 40%;
  --y: 100%;
  --animation: c9;
}

.uiverse .wrapper .circle.circle-10 {
  --x: -80%;
  --y: 100%;
  --animation: c10;
}

.uiverse .wrapper .circle.circle-11 {
  --x: 60%;
  --y: -20%;
  --animation: c11;
}

.uiverse .wrapper .circle.circle-12 {
  --x: -40%;
  --y: 30%;
  --animation: c12;
}

@keyframes c1 {
  0%, 100% {
    transform: translate(-30%, -30%) translateZ(0);
  }
  25% {
    transform: translate(30%, 30%) translateZ(0);
  }
  50% {
    transform: translate(140%, -40%) translateZ(0);
  }
  75% {
    transform: translate(30%, 80%) translateZ(0);
  }
}

@keyframes c2 {
  0%, 100% {
    transform: translate(-25%, 150%) translateZ(0);
  }
  25% {
    transform: translate(-40%, 20%) translateZ(0);
  }
  50% {
    transform: translate(-80%, 50%) translateZ(0);
  }
  75% {
    transform: translate(50%, 80%) translateZ(0);
  }
}

@keyframes c3 {
  0%, 100% {
    transform: translate(150%, -30%) translateZ(0);
  }
  25% {
    transform: translate(30%, 40%) translateZ(0);
  }
  50% {
    transform: translate(80%, 20%) translateZ(0);
  }
  75% {
    transform: translate(50%, -30%) translateZ(0);
  }
}

@keyframes c4 {
  0%, 100% {
    transform: translate(100%, 100%) translateZ(0);
  }
  25% {
    transform: translate(120%, 30%) translateZ(0);
  }
  50% {
    transform: translate(80%, -30%) translateZ(0);
  }
  75% {
    transform: translate(-40%, 150%) translateZ(0);
  }
}

@keyframes c5 {
  0%, 100% {
    transform: translate(80%, -80%) translateZ(0);
  }
  25% {
    transform: translate(90%, 40%) translateZ(0);
  }
  50% {
    transform: translate(-20%, 140%) translateZ(0);
  }
  75% {
    transform: translate(50%, 50%) translateZ(0);
  }
}

@keyframes c6 {
  0%, 100% {
    transform: translate(-70%, -70%) translateZ(0);
  }
  25% {
    transform: translate(-40%, -40%) translateZ(0);
  }
  50% {
    transform: translate(40%, -30%) translateZ(0);
  }
  75% {
    transform: translate(10%, 30%) translateZ(0);
  }
}

@keyframes c7 {
  0%, 100% {
    transform: translate(100%, -40%) translateZ(0);
  }
  25% {
    transform: translate(40%, 20%) translateZ(0);
  }
  50% {
    transform: translate(10%, 90%) translateZ(0);
  }
  75% {
    transform: translate(30%, 60%) translateZ(0);
  }
}

@keyframes c8 {
  0%, 100% {
    transform: translate(-100%, -40%) translateZ(0);
  }
  25% {
    transform: translate(-20%, 20%) translateZ(0);
  }
  50% {
    transform: translate(-80%, 80%) translateZ(0);
  }
  75% {
    transform: translate(70%, -20%) translateZ(0);
  }
}

@keyframes c9 {
  0%, 100% {
    transform: translate(40%, 100%) translateZ(0);
  }
  25% {
    transform: translate(12%, 20%) translateZ(0);
  }
  50% {
    transform: translate(0%, -10%) translateZ(0);
  }
  75% {
    transform: translate(100%, 10%) translateZ(0);
  }
}

@keyframes c10 {
  0%, 100% {
    transform: translate(-80%, 100%) translateZ(0);
  }
  25% {
    transform: translate(-40%, 60%) translateZ(0);
  }
  50% {
    transform: translate(0%, 0%) translateZ(0);
  }
  75% {
    transform: translate(-60%, -70%) translateZ(0);
  }
}

@keyframes c11 {
  0%, 100% {
    transform: translate(60%, -20%) translateZ(0);
  }
  25% {
    transform: translate(120%, 20%) translateZ(0);
  }
  50% {
    transform: translate(120%, 120%) translateZ(0);
  }
  75% {
    transform: translate(-20%, 100%) translateZ(0);
  }
}

@keyframes c12 {
  0%, 100% {
    transform: translate(-40%, 30%) translateZ(0);
  }
  25% {
    transform: translate(-20%, -40%) translateZ(0);
  }
  50% {
    transform: translate(0%, -100%) translateZ(0);
  }
  75% {
    transform: translate(40%, 30%) translateZ(0);
  }
}

@media (max-width: 767px) {
  .remix-container {
    width: 90%;
    padding: 50px 20px 40px;
  }
  
  .header-text {
    padding-left: 0;
  }
  
  .assistant-avatar {
    display: none;
  }
  
  .header-text p:first-child {
    font-size: 24px;
  }
  
  .header-text p:nth-child(2),
  .header-text p:nth-child(3) {
    font-size: 18px;
  }
  
  .remix-options {
    grid-template-columns: 1fr;
  }
  
  .navigation-section {
    flex-direction: column;
    gap: 16px;
  }
  
  .back-btn {
    width: 100%;
    justify-content: center;
  }
  
  .uiverse {
    width: 100%;
  }
  
  .uiverse .wrapper {
    width: 100%;
    text-align: center;
  }
}
</style> 