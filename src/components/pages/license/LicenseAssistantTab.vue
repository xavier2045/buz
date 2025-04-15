<template>
  <div class="license-assistant">
    <div class="assistant-header">
      <div class="header-with-avatar">
        <div class="header-text">
          <p>嗨，我是您的 AE 助理。</p>
          <p>今天我能帮您什么忙呢？</p>
        </div>
        <div class="assistant-avatar">
          <img src="/images/female-showing-ok-gesture.png" alt="AE Assistant" />
        </div>
      </div>
    </div>
    
    <div class="license-options" v-if="!showingNonCommercial">
      <button class="license-option-card" @click="handleNonCommercialClick">
        <p>创建非商业许可证</p>
        <p class="description-zh">允许他人将您的作品仅用于非商业、个人用途</p>
      </button>
      
      <button class="license-option-card" @click="selectLicense('commercial')">
        <p>创建商业许可证</p>
        <p class="description-zh">根据您设定的条款用于商业用途</p>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const emit = defineEmits(['select-license', 'navigate-to-expiration', 'navigate-to-commercial-expiration', 'navigate-to-mint']);
const showingNonCommercial = ref(false);

const handleNonCommercialClick = () => {
  showingNonCommercial.value = true;
  emit('navigate-to-expiration', 'non-commercial');
};

const selectLicense = (licenseType: string) => {
  if (licenseType === 'commercial') {
    emit('navigate-to-commercial-expiration', licenseType);
  }
};
</script>

<style scoped>
.license-assistant {
  width: 100%;
  max-width: 800px;
  background: rgba(20, 20, 20, 0.7);
  border-radius: 16px;
  padding: 30px;
  position: relative;
  color: white;
}

.assistant-header {
  margin-bottom: 30px;
}

.header-with-avatar {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 30px;
}

.header-text {
  text-align: center;
}

.header-text p:first-child {
  font-size: 24px;
  margin-bottom: 5px;
  font-weight: 500;
}

.header-text p:last-child {
  font-size: 20px;
  margin-top: 5px;
  margin-bottom: 5px;
  font-weight: 500;
}

.license-options {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.license-option-card {
  background: rgba(30, 30, 35, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  position: relative;
  width: 100%;
  text-align: left;
  font-family: inherit;
  color: inherit;
}

.license-option-card:hover {
  background: rgba(40, 40, 45, 0.7);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
}

.license-option-card::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
}

.license-option-card p:first-child {
  font-size: 18px;
  margin-bottom: 5px;
  font-weight: 500;
  color: white;
  position: relative;
  z-index: 0;
}

.license-option-card p {
  margin: 5px 0;
  color: rgba(255, 255, 255, 0.7);
  position: relative;
  z-index: 0;
}

.option-description {
  font-size: 14px;
  margin-top: 10px;
  color: rgba(255, 255, 255, 0.5);
}

.description-zh {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.5);
}

.assistant-avatar {
  width: 140px;
  height: 140px;
  overflow: visible;
  background: transparent;
  margin-top: -10px;
}

.assistant-avatar img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
}

@media (max-width: 600px) {
  .header-with-avatar {
    flex-direction: column;
    align-items: center;
    gap: 15px;
  }
  
  .assistant-avatar {
    width: 100px;
    height: 100px;
    order: -1;
    margin-top: 0;
  }
}

@media (max-width: 480px) {
  .assistant-avatar {
    width: 80px;
    height: 80px;
  }
}
</style> 