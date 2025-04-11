<template>
  <div class="remix-container">
    <div class="remix-header">
      <div class="header-text">
        <p>非常好！</p>
        <p>其他创作者可以重新混合这部作品吗？</p>
      </div>
      <div class="assistant-avatar">
        <img src="/images/girl-pointing-up.png" alt="AE Assistant" />
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
    
    <!-- 添加导航按钮 -->
    <NavigationButtons 
      @back="emit('navigate-back')" 
      @next="handleNext"
      :next-disabled="!selectedRemix"
      :isFinalStep="false"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import NavigationButtons from '../../../components/common/NavigationButtons.vue';

const emit = defineEmits(['select-remix', 'navigate-back']);
const selectedRemix = ref('');

const props = defineProps({
  sourceTab: {
    type: String,
    default: '' // 可以是 'preset', 'custom', 'assistant' 或空字符串
  }
});

const selectRemix = (remixType: string) => {
  selectedRemix.value = remixType;
};

const handleNext = () => {
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
  transform: translateX(-150px);
}

.remix-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 25px;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
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

@media (max-width: 600px) {
  .remix-options {
    grid-template-columns: 1fr;
  }
  
  .remix-header {
    flex-direction: column;
    align-items: center;
  }
  
  .header-text {
    text-align: center;
  }
  
  .assistant-avatar {
    margin: 15px 0 0 0;
  }
}
</style> 