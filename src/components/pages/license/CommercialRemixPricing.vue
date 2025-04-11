<template>
  <div class="commercial-license-pricing">
    <div class="header">
      <h1 class="pricing-title">定价和版税</h1>
      <div class="pricing-subtitle">
        <p class="subtitle-zh">输入每个许可证的价格和收入分成。许可证只能使用一次。购买者需要为每次额外使用购买新许可证。</p>
      </div>
    </div>

    <div class="license-section">
      <div class="license-type-header">
        <h2>商业 Remix 许可证</h2>
      </div>

      <div class="pricing-grid">
        <div class="price-input-section">
          <h3 class="input-label">许可证价格</h3>
          <div class="input-container">
            <input 
              type="text" 
              class="license-input" 
              placeholder="输入许可证价格" 
              v-model="licensePrice"
            />
            <div class="input-suffix">¥</div>
          </div>
        </div>

        <div class="revenue-input-section">
          <h3 class="input-label">收入分成</h3>
          <div class="input-container">
            <input 
              type="text" 
              class="license-input" 
              placeholder="输入收入分成" 
              v-model="revenueShare"
            />
            <div class="input-suffix">%</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部导航按钮 -->
    <NavigationButtons 
      @back="goBack" 
      @next="goNext"
      :next-disabled="!isPricingValid"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import NavigationButtons from '../../common/NavigationButtons.vue';

const emit = defineEmits(['navigate-back', 'navigate-next', 'remix-pricing-update']);

// 许可证价格和收入分成
const licensePrice = ref('');
const revenueShare = ref('');

// 验证价格和收入分成是否有效
const isPricingValid = computed(() => {
  return !!licensePrice.value.trim();
});

// 导航方法
const goBack = () => {
  emit('navigate-back');
};

const goNext = () => {
  if (isPricingValid.value) {
    // 价格和收入分成数据
    const pricingData = {
      licensePrice: licensePrice.value,
      revenueShare: revenueShare.value || '0'
    };
    
    // 更新价格信息并导航到下一页
    emit('remix-pricing-update', pricingData);
    emit('navigate-next');
  }
};
</script>

<style scoped>
.commercial-license-pricing {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  color: white;
}

.header {
  text-align: center;
  margin-bottom: 40px;
  width: 100%;
}

.pricing-title {
  font-size: 2.5rem;
  margin-bottom: 16px;
  color: white;
  font-weight: 600;
}

.pricing-subtitle {
  max-width: 800px;
  margin: 0 auto;
}

.subtitle-zh {
  font-size: 1.05rem;
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
  line-height: 1.5;
}

.license-section {
  width: 100%;
  background: rgba(30, 30, 30, 0.4);
  border-radius: 16px;
  padding: 30px;
  margin-bottom: 40px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.license-type-header {
  margin-bottom: 30px;
}

.license-type-header h2 {
  font-size: 1.6rem;
  font-weight: 600;
  color: white;
  margin: 0;
}

.pricing-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}

.input-label {
  font-size: 1rem;
  font-weight: 500;
  margin-bottom: 12px;
  color: white;
}

.input-container {
  position: relative;
  display: flex;
  align-items: center;
}

.license-input {
  width: 100%;
  padding: 15px;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  background-color: rgba(30, 30, 30, 0.6);
  color: white;
  font-size: 1rem;
  outline: none;
  transition: all 0.2s ease;
}

.license-input:focus {
  border-color: rgba(200, 200, 200, 0.5);
  box-shadow: 0 0 0 2px rgba(200, 200, 200, 0.2);
}

.input-suffix {
  position: absolute;
  right: 15px;
  color: rgba(200, 200, 200, 0.7);
  font-weight: 500;
  pointer-events: none;
}

@media (max-width: 768px) {
  .pricing-grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }
  
  .pricing-title {
    font-size: 2rem;
  }
  
  .pricing-subtitle {
    font-size: 1rem;
  }
  
  .license-section {
    padding: 20px;
  }
}
</style> 