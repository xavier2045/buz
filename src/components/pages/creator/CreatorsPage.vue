<template>
  <div class="creators-container">
    <h1 class="page-title">添加共同创作者</h1>
    <p class="page-subtitle">将共同创建者添加到此资产（可选）</p>

    <!-- 添加共同创作者 -->
    <div class="add-creators-section">
      <div class="search-row">
        <input 
          type="text" 
          class="search-input" 
          placeholder="输入名称搜索"
          v-model="newCreatorName"
        >
        <input 
          type="text" 
          class="search-input" 
          placeholder="输入用户ID搜索"
          v-model="newCreatorWallet"
        >
        <button 
          class="add-btn" 
          @click="addCoCreator"
          :disabled="!newCreatorName || !newCreatorWallet"
        >
          添加 <span class="plus-icon">+</span>
        </button>
      </div>
    </div>

    <!-- 创作者列表 -->
    <div class="creators-list-section">
      <h2 class="section-title">创作者</h2>
      
      <!-- 当前用户（管理员） -->
      <div class="creator-item current-user">
        <div class="creator-avatar">
          <div class="avatar-image">😀</div>
        </div>
        <div class="creator-info">
          <div class="creator-name">你</div>
          <div class="creator-role">管理</div>
        </div>
      </div>
      
      <!-- 共同创作者列表 -->
      <div v-for="(creator, index) in coCreators" :key="index" class="creator-item">
        <div class="creator-avatar">
          <div class="avatar-image">👤</div>
        </div>
        <div class="creator-info">
          <div class="creator-name">{{ creator.name }}</div>
          <div class="creator-wallet">{{ shortenWallet(creator.wallet) }}</div>
        </div>
        <button class="remove-creator-btn" @click="removeCoCreator(index)">×</button>
      </div>
    </div>

    <!-- 底部导航按钮 -->
    <div class="navigation-buttons">
      <button class="back-btn" @click="$emit('navigate-back')">
        <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="arrow" class="arrow-icon arrow-back">
          <path d="M17.7,11.2C17.7,11.2,17.7,11.2,17.7,11.2l-5-5c-0.4-0.4-1-0.4-1.4,0c-0.4,0.4-0.4,1,0,1.4l3.3,3.3H7c-0.6,0-1,0.4-1,1
            s0.4,1,1,1h7.6l-3.3,3.3c-0.4,0.4-0.4,1,0,1.4c0.4,0.4,1,0.4,1.4,0c0,0,0,0,0,0l5-5C18.1,12.3,18.1,11.6,17.7,11.2z"></path>
        </svg>
      </button>
      <button class="uiverse" @click="$emit('navigate-next', coCreators)">
        <div class="wrapper">
          <span>
            <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="arrow" class="arrow-icon">
              <path d="M17.7,11.2C17.7,11.2,17.7,11.2,17.7,11.2l-5-5c-0.4-0.4-1-0.4-1.4,0c-0.4,0.4-0.4,1,0,1.4l3.3,3.3H7c-0.6,0-1,0.4-1,1
                s0.4,1,1,1h7.6l-3.3,3.3c-0.4,0.4-0.4,1,0,1.4c0.4,0.4,1,0.4,1.4,0c0,0,0,0,0,0l5-5C18.1,12.3,18.1,11.6,17.7,11.2z"></path>
            </svg>
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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';

const emit = defineEmits(['navigate-back', 'navigate-next']);

// 接收props
const props = defineProps({
  creators: {
    type: Array as () => Array<{name: string, wallet: string}>,
    default: () => []
  }
});

// 新创作者信息
const newCreatorName = ref('');
const newCreatorWallet = ref('');

// 共同创作者列表
const coCreators = ref<Array<{name: string, wallet: string}>>(
  props.creators ? [...props.creators] : []
);

// 添加测试数据
onMounted(() => {
  // 如果列表为空，添加测试数据
  if (coCreators.value.length === 0) {
    coCreators.value = [
      { name: '张三', wallet: '0x1234567890abcdef' },
      { name: '李四', wallet: '0xabcdef1234567890' },
      { name: '王五', wallet: '0x9876543210abcdef' },
      { name: '赵六', wallet: '0xfedcba0987654321' }
    ];
  }
  console.log('CreatorsPage初始化的共同创作者:', coCreators.value);
  
  // 为uiverse按钮添加动画效果
  const uiverseButton = document.querySelector('.creators-container .uiverse');
  const circles = document.querySelectorAll('.creators-container .uiverse .circle');

  if (uiverseButton) {
    // 添加鼠标悬停事件，加速动画
    uiverseButton.addEventListener('mouseenter', () => {
      circles.forEach(circle => {
        (circle as HTMLElement).style.animationDuration = '1.4s';
      });
    });

    // 添加鼠标离开事件，恢复动画速度
    uiverseButton.addEventListener('mouseleave', () => {
      circles.forEach(circle => {
        (circle as HTMLElement).style.animationDuration = '7s';
      });
    });
    
    // 立即触发一次动画效果，确保动画始终可见
    setTimeout(() => {
      circles.forEach(circle => {
        // 保存当前动画持续时间
        const currentDuration = (circle as HTMLElement).style.animationDuration;
        // 设置快速动画
        (circle as HTMLElement).style.animationDuration = '1.4s';
        
        // 800ms后恢复正常速度
        setTimeout(() => {
          (circle as HTMLElement).style.animationDuration = currentDuration || '7s';
        }, 800);
      });
    }, 500);
  }
});

// 添加共同创作者
const addCoCreator = () => {
  if (!newCreatorName.value || !newCreatorWallet.value) return;
  
  coCreators.value.push({
    name: newCreatorName.value,
    wallet: newCreatorWallet.value
  });
  
  // 清空输入
  newCreatorName.value = '';
  newCreatorWallet.value = '';
};

// 移除共同创作者
const removeCoCreator = (index: number) => {
  coCreators.value.splice(index, 1);
};

// 缩短钱包地址显示
const shortenWallet = (wallet: string) => {
  if (wallet.length <= 10) return wallet;
  return wallet.substring(0, 6) + '...' + wallet.substring(wallet.length - 4);
};
</script>

<style scoped>
.creators-container {
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
  padding: 30px;
  color: #fff;
}

.page-title {
  font-size: 32px;
  margin-bottom: 8px;
  font-weight: normal;
}

.page-subtitle {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 30px;
}

.add-creators-section {
  margin-bottom: 30px;
}

.search-row {
  display: flex;
  gap: 10px;
  align-items: center;
}

.search-input {
  flex: 1;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  padding: 12px 15px;
  color: white;
  font-size: 16px;
  transition: all 0.3s;
}

.search-input:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.4);
  background: rgba(255, 255, 255, 0.15);
}

.add-btn {
  background: rgba(52, 152, 219, 0.7);
  color: white;
  border: none;
  border-radius: 8px;
  padding: 0 20px;
  height: 46px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 5px;
}

.add-btn:hover:not(:disabled) {
  background: rgba(52, 152, 219, 0.9);
}

.add-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.plus-icon {
  font-size: 18px;
}

.section-title {
  font-size: 18px;
  font-weight: normal;
  margin-bottom: 15px;
}

.creators-list-section {
  margin-bottom: 30px;
}

.creator-item {
  display: flex;
  align-items: center;
  background: rgba(30, 30, 35, 0.6);
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 10px;
  position: relative;
}

.creator-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 15px;
  overflow: hidden;
  background: rgba(52, 152, 219, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
}

.creator-avatar .avatar-image {
  font-size: 22px;
}

.current-user .creator-avatar {
  background: #ffeb3b;
  color: #333;
}

.creator-info {
  flex: 1;
}

.creator-name {
  font-size: 16px;
  color: white;
  margin-bottom: 5px;
}

.creator-role, .creator-wallet {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
}

.remove-creator-btn {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: rgba(231, 76, 60, 0.3);
  border: none;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.2s;
  position: absolute;
  right: 15px;
}

.remove-creator-btn:hover {
  background: rgba(231, 76, 60, 0.8);
}

.current-user {
  border-left: 3px solid rgba(46, 204, 113, 0.8);
}

/* 导航按钮 */
.navigation-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 40px;
}

.back-btn, .uiverse {
  padding: 12px 20px;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  transition: all 0.3s;
}

.back-btn {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
}

.back-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

/* Uiverse button style */
.uiverse {
  --duration: 7s;
  --easing: linear;
  --c-color-1: #ffd58c;
  --c-color-2: #69a5ff;
  --c-color-3: #c29fff;
  --c-color-4: rgba(140, 232, 255, 0.7);
  --c-shadow: rgba(99, 85, 255, 0.59);
  --c-shadow-inset-top: rgba(132, 156, 255, 0.9);
  --c-shadow-inset-bottom: rgba(62, 145, 255, 0.614);
  --c-radial-inner: #2637a4;
  --c-radial-outer: #5f64ea;
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

.arrow-icon {
  width: 32px;
  height: 32px;
  fill: currentColor;
}

.arrow-back {
  transform: rotate(180deg);
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