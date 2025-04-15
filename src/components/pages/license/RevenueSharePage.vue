<template>
  <div class="revenue-container">
    <div class="revenue-header">
      <div class="header-text">
        <p>哈！接下来</p>
        <p>会有收入分成吗？</p>
      </div>
      <div class="assistant-avatar">
        <img src="/images/girl-pointing-up_1.png" alt="AE Assistant" />
      </div>
    </div>

    <div class="revenue-options">
      <div 
        class="revenue-option" 
        :class="{ selected: selectedOption === '1' }"
        @click="selectOption('1')"
      >
        <span>1%</span>
      </div>
      <div 
        class="revenue-option" 
        :class="{ selected: selectedOption === '5' }"
        @click="selectOption('5')"
      >
        <span>5%</span>
      </div>
      <div 
        class="revenue-option" 
        :class="{ selected: selectedOption === 'custom' }"
        @click="selectOption('custom')"
      >
        <span>自定义</span>
      </div>
      <div 
        class="revenue-option" 
        :class="{ selected: selectedOption === 'none' }"
        @click="selectOption('none')"
      >
        <span>没有</span>
      </div>
    </div>
    
    <!-- 自定义百分比输入 -->
    <div class="custom-percentage" v-if="selectedOption === 'custom'">
      <input 
        type="number" 
        class="percentage-input" 
        v-model="customPercentage"
        min="1"
        max="100"
        placeholder="输入百分比"
      />
      <span class="percentage-sign">%</span>
    </div>
    
    <!-- 导航按钮 -->
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
import NavigationButtons from '../../common/NavigationButtons.vue';

const emit = defineEmits(['select-revenue-share', 'navigate-back']);
const selectedOption = ref('');
const customPercentage = ref('');

// 检查选择是否有效
const isValidSelection = computed(() => {
  if (selectedOption.value === 'custom') {
    return customPercentage.value !== '' && Number(customPercentage.value) > 0;
  }
  return selectedOption.value !== '';
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
  },
  allowRemix: {
    type: Boolean,
    default: false
  }
});

const selectOption = (option: string) => {
  selectedOption.value = option;
};

const goBack = () => {
  // 返回时发送源标签页信息，让父组件知道应该显示哪个标签页
  emit('navigate-back', props.sourceTab);
};

const goNext = () => {
  if (isValidSelection.value) {
    let revenueShare = selectedOption.value;
    if (selectedOption.value === 'custom' && customPercentage.value) {
      revenueShare = customPercentage.value;
    }
    emit('select-revenue-share', revenueShare);
  }
};
</script>

<style scoped>
.revenue-container {
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

.revenue-header {
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

.revenue-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 25px;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 30px;
}

.revenue-option {
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

.revenue-option.selected {
  background: rgba(74, 144, 226, 0.2);
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.revenue-option:hover {
  background: rgba(40, 40, 45, 0.7);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.revenue-option.selected:hover {
  background: rgba(74, 144, 226, 0.25);
}

.revenue-option span {
  font-size: 17px;
  font-weight: 500;
}

.custom-percentage {
  width: 100%;
  max-width: 300px;
  margin: 0 auto 40px;
  position: relative;
}

.percentage-input {
  width: 100%;
  height: 64px;
  padding: 10px 20px;
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background: rgba(25, 25, 30, 0.6);
  color: white;
  font-size: 17px;
  outline: none;
  transition: all 0.3s ease;
  padding-right: 40px;
}

.percentage-input:focus {
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.percentage-sign {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
}

@media (max-width: 767px) {
  .revenue-container {
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
  
  .revenue-options {
    grid-template-columns: 1fr;
  }
}
</style> 