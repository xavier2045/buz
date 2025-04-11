<template>
  <div class="ai-training-container">
    <div class="ai-training-header">
      <div class="header-text">
        <p>最后一个问题！</p>
        <p>此资产是否可以用于 AI 训练计划?</p>
      </div>
      <div class="assistant-avatar">
        <img src="/images/woman-showing-ok-gesture-using-right-hand.png" alt="AE Assistant" />
      </div>
    </div>

    <div class="ai-training-options">
      <div 
        class="ai-training-option" 
        :class="{ selected: selectedAITraining === 'yes' }"
        @click="selectAITraining('yes')"
      >
        <span>是的</span>
      </div>
      <div 
        class="ai-training-option" 
        :class="{ selected: selectedAITraining === 'no' }"
        @click="selectAITraining('no')"
      >
        <span>不</span>
      </div>
    </div>
    
    <!-- 添加导航按钮 -->
    <NavigationButtons 
      @back="emit('navigate-back')" 
      @next="handleNext"
      :next-disabled="!selectedAITraining"
      :isFinalStep="true"
    />
    
    <!-- 支付弹框 -->
    <PaymentQRModal 
      v-if="showPaymentModal" 
      :show="showPaymentModal"
      :payment-amount="5"
      @close="closePaymentModal"
      @payment-complete="handlePaymentComplete"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import NavigationButtons from '../../../components/common/NavigationButtons.vue';
import PaymentQRModal from '../../../components/modals/PaymentQRModal.vue';

const emit = defineEmits(['select-ai-training', 'navigate-back']);
const selectedAITraining = ref('');
const showPaymentModal = ref(false);

const props = defineProps({
  sourceTab: {
    type: String,
    default: '' // 可以是 'preset', 'custom', 'assistant' 或空字符串
  }
});

const selectAITraining = (aiTrainingType: string) => {
  selectedAITraining.value = aiTrainingType;
};

const handleNext = () => {
  if (selectedAITraining.value) {
    // 显示支付模态框，而不是直接提交
    showPaymentModal.value = true;
  }
};

const closePaymentModal = () => {
  showPaymentModal.value = false;
};

const handlePaymentComplete = () => {
  // 支付完成后才触发提交
  closePaymentModal();
  emit('select-ai-training', selectedAITraining.value);
};
</script>

<style scoped>
.ai-training-container {
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

.ai-training-header {
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

.ai-training-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 25px;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
}

.ai-training-option {
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

.ai-training-option.selected {
  background: rgba(74, 144, 226, 0.2);
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.ai-training-option:hover {
  background: rgba(40, 40, 45, 0.7);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.ai-training-option.selected:hover {
  background: rgba(74, 144, 226, 0.25);
}

.ai-training-option span {
  font-size: 17px;
  font-weight: 500;
}

@media (max-width: 600px) {
  .ai-training-options {
    grid-template-columns: 1fr;
  }
  
  .ai-training-header {
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