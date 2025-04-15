<template>
  <div class="revenue-container">
    <RevenueHeader />
    <RevenueOptions 
      :selectedOption="selectedOption"
      @select="selectOption"
    />
    
    <CustomPercentageInput 
      v-if="selectedOption === 'custom'"
      v-model="customPercentage"
    />
    
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
import { RevenueHeader, RevenueOptions, CustomPercentageInput } from './components';

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

@media (max-width: 767px) {
  .revenue-container {
    width: 90%;
    padding: 50px 20px 40px;
  }
}
</style> 