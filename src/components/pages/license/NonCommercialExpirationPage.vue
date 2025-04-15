<template>
  <div class="expiration-container">
    <div class="expiration-header">
      <div class="header-text">
        <p>非常好！</p>
        <p>你希望这次许可什么时候到期？</p>
      </div>
      <div class="assistant-avatar">
        <img src="/images/girl-doing-namaste.png" alt="AE Assistant" />
      </div>
    </div>

    <div class="expiration-options">
      <div 
        class="expiration-option" 
        :class="{ selected: selectedExpiration === 'never' }"
        @click="selectExpiration('never')"
      >
        <span>从不</span>
      </div>
      <div 
        class="expiration-option" 
        :class="{ selected: selectedExpiration === '6months' }"
        @click="selectExpiration('6months')"
      >
        <span>6 个月</span>
      </div>
      <div 
        class="expiration-option" 
        :class="{ selected: selectedExpiration === '1year' }"
        @click="selectExpiration('1year')"
      >
        <span>1 年</span>
      </div>
      <div 
        class="expiration-option" 
        :class="{ selected: selectedExpiration === 'custom' }"
        @click="selectExpiration('custom')"
      >
        <span>选择日期</span>
      </div>
    </div>
    
    <!-- 日期选择器 -->
    <div class="date-picker-container" v-if="selectedExpiration === 'custom'">
      <input 
        type="date" 
        class="date-input" 
        v-model="customDate"
        :min="minDate"
      />
    </div>
    
    <!-- 使用NavigationButtons组件 -->
    <NavigationButtons 
      @back="goBack" 
      @next="goNext"
      :next-disabled="!isValidSelection"
      :isFinalStep="false"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import NavigationButtons from '../../../components/common/NavigationButtons.vue';

const emit = defineEmits(['select-expiration', 'navigate-back']);
const selectedExpiration = ref('');
const customDate = ref('');

// 最小日期为明天
const minDate = computed(() => {
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  return formatDate(tomorrow);
});

// 检查选择是否有效
const isValidSelection = computed(() => {
  if (selectedExpiration.value === 'custom') {
    return customDate.value !== '';
  }
  return selectedExpiration.value !== '';
});

// 格式化日期为YYYY-MM-DD
const formatDate = (date: Date): string => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const props = defineProps({
  sourceTab: {
    type: String,
    default: '' // 可以是 'preset', 'custom', 'assistant' 或空字符串
  }
});

const selectExpiration = (expirationType: string) => {
  selectedExpiration.value = expirationType;
};

const goBack = () => {
  // 返回时发送源标签页信息，让父组件知道应该显示哪个标签页
  emit('navigate-back', props.sourceTab);
};

const goNext = () => {
  if (selectedExpiration.value) {
    if (selectedExpiration.value === 'custom') {
      emit('select-expiration', customDate.value);
    } else {
      emit('select-expiration', selectedExpiration.value);
    }
  }
};
</script>

<style scoped>
.expiration-container {
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

.expiration-header {
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
  margin-left: 0px;
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
  transform: translateX(-220px);
}

.expiration-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 25px;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 60px;
}

.expiration-option {
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

.expiration-option.selected {
  background: rgba(74, 144, 226, 0.2);
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.expiration-option:hover {
  background: rgba(40, 40, 45, 0.7);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.expiration-option.selected:hover {
  background: rgba(74, 144, 226, 0.25);
}

.expiration-option span {
  font-size: 17px;
  font-weight: 500;
}

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

@media (max-width: 600px) {
  .expiration-options {
    grid-template-columns: 1fr;
  }
  
  .expiration-header {
    flex-direction: column;
    align-items: center;
  }
  
  .header-text {
    text-align: center;
  }
  
  .assistant-avatar {
    margin: 15px 0 0 0;
  }
  
  .navigation {
    flex-direction: column;
    gap: 15px;
    align-items: center;
  }
  
  .back-btn, .uiverse {
    width: 100%;
  }
  
  .back-btn {
    padding: 14px 24px;
    justify-content: center;
  }
}

/* 日期选择器样式 */
.date-picker-container {
  width: 100%;
  max-width: 600px;
  margin: 10px auto 30px;
  display: flex;
  justify-content: center;
}

.date-input {
  width: 100%;
  max-width: 280px;
  height: 52px;
  background: rgba(25, 25, 30, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 14px;
  padding: 10px 20px;
  font-size: 17px;
  color: white;
  outline: none;
  transition: all 0.3s ease;
  color-scheme: dark;
  cursor: pointer;
}

.date-input:hover {
  background: rgba(40, 40, 45, 0.7);
  border-color: rgba(255, 255, 255, 0.25);
}

.date-input:focus {
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

/* 修改日期选择器内部箭头和日历图标颜色 */
:deep(.date-input::-webkit-calendar-picker-indicator) {
  filter: invert(1) opacity(0.7);
  cursor: pointer;
}

@media (max-width: 600px) {
  .date-input {
    max-width: 100%;
  }
}
</style> 