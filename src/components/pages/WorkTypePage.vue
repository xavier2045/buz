<template>
  <div class="work-type-container">
    <!-- 标题部分 -->
    <div class="header">
      <h1 class="title-with-subtitle">选择作品类型（注册类型）</h1>
      <p class="subtitle-zh">请选择您要发布的作品类型</p>
    </div>

    <!-- 作品类型选项 -->
    <div class="work-type-options">
      <!-- 新IP选项 -->
      <div 
        class="work-type-card" 
        :class="{ selected: selectedWorkType === 'newIP' }"
        @click="selectWorkType('newIP')"
      >
        <div class="work-type-content">
          <div class="work-type-icon new-icon">
            <span class="icon-symbol">✦</span>
          </div>
          <h2>新IP <span class="type-label">新作品</span></h2>
          <p class="work-description">注册原创图片、视频或文字作品</p>
        </div>
      </div>

      <!-- 混音选项 -->
      <div 
        class="work-type-card"
        :class="{ selected: selectedWorkType === 'remix' }"
        @click="selectWorkType('remix')"
      >
        <div class="work-type-content">
          <div class="work-type-icon remix-icon">
            <span class="icon-symbol">↺</span>
          </div>
          <h2>混音 <span class="type-label">衍生作品</span></h2>
          <p class="work-description">注册与现有作品相关的衍生作品</p>
        </div>
      </div>
    </div>

    <!-- 提示信息区域 -->
    <div class="info-panel">
      <div class="info-icon">
        <span class="coin-emoji">🪙</span>
      </div>
      <div class="info-text">
        <h3>获取AETRIX币</h3>
        <p>您需要一定数量的AETRIX币用于支付gas和交易费用</p>
      </div>
      <div class="info-arrow">
        <span>→</span>
      </div>
    </div>

    <!-- 底部导航按钮 -->
    <NavigationButtons 
      :next-disabled="!selectedWorkType" 
      @back="goBack" 
      @next="goNext" 
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import NavigationButtons from '../common/NavigationButtons.vue';

const emit = defineEmits(['navigate-back', 'navigate-next']);
const selectedWorkType = ref('');

const selectWorkType = (type: string) => {
  selectedWorkType.value = type;
};

const goBack = () => {
  emit('navigate-back');
};

const goNext = () => {
  if (selectedWorkType.value) {
    emit('navigate-next', selectedWorkType.value);
  }
};
</script>

<style scoped>
.work-type-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
}

.header {
  text-align: center;
  margin-bottom: 40px;
}

.title-with-subtitle {
  font-size: 32px;
  margin-bottom: 8px;
  color: #ffffff;
}

.subtitle-zh {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
}

.work-type-options {
  display: flex;
  justify-content: center;
  gap: 30px;
  margin-bottom: 40px;
  width: 100%;
}

.work-type-card {
  flex: 1;
  max-width: 400px;
  min-width: 280px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 24px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.work-type-card:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-5px);
}

.work-type-card.selected {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
}

.work-type-content {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.work-type-icon {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
  font-size: 24px;
}

.new-icon {
  background: linear-gradient(135deg, #00c6ff, #0072ff);
}

.remix-icon {
  background: linear-gradient(135deg, #ff9966, #ff5e62);
}

.icon-symbol {
  color: white;
}

.work-type-card h2 {
  font-size: 24px;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  color: white;
}

.type-label {
  font-size: 12px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 4px 8px;
  margin-left: 8px;
  color: rgba(255, 255, 255, 0.9);
}

.work-description {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.5;
}

.info-panel {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  padding: 16px;
  margin-bottom: 40px;
  width: 100%;
  max-width: 600px;
}

.info-icon {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #ffcc33, #ffaa00);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
}

.coin-emoji {
  font-size: 20px;
}

.info-text {
  flex: 1;
}

.info-text h3 {
  font-size: 18px;
  margin-bottom: 4px;
  color: white;
}

.info-text p {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.info-arrow {
  margin-left: 16px;
  font-size: 24px;
  color: rgba(255, 255, 255, 0.5);
}
</style> 