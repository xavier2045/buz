<template>
  <div class="combined-license-pricing">
    <div class="header">
      <h1 class="pricing-title">定价和版税</h1>
      <div class="pricing-subtitle">
        <p class="subtitle-zh">输入每个许可证的价格和收入分成。许可证只能使用一次。购买者需要为每次额外使用购买新许可证。</p>
      </div>
    </div>

    <!-- 商业使用许可证部分 -->
    <div class="license-section" v-if="selectedLicenses.includes('commercial')">
      <div class="license-type-header">
        <h2>商业使用许可证</h2>
      </div>

      <div class="pricing-grid">
        <div class="price-input-section">
          <h3 class="input-label">许可证价格</h3>
          <div class="input-container">
            <input 
              type="text" 
              class="license-input" 
              placeholder="输入许可证价格" 
              v-model="commercialPrice"
            />
            <div class="input-suffix">IP</div>
          </div>
        </div>

        <div class="revenue-input-section disabled-section">
          <h3 class="input-label disabled-label">收入分成</h3>
          <div class="input-container">
            <input 
              type="text" 
              class="license-input disabled-input" 
              placeholder="不可用" 
              disabled
            />
            <div class="input-suffix">%</div>
          </div>
          <div class="disabled-note">商业使用许可证不支持收入分成</div>
        </div>
      </div>
    </div>

    <!-- 商业混音许可证部分 -->
    <div class="license-section" v-if="selectedLicenses.includes('commercial-remix')">
      <div class="license-type-header">
        <h2>商业Remix许可证</h2>
      </div>

      <div class="pricing-grid">
        <div class="price-input-section">
          <h3 class="input-label">许可证价格</h3>
          <div class="input-container">
            <input 
              type="text" 
              class="license-input" 
              placeholder="输入许可证价格" 
              v-model="remixPrice"
            />
            <div class="input-suffix">IP</div>
          </div>
        </div>

        <div class="revenue-input-section">
          <h3 class="input-label">收入分成</h3>
          <div class="input-container">
            <input 
              type="text" 
              class="license-input" 
              placeholder="输入收入分成" 
              v-model="remixRevenue"
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
import { ref, computed, onMounted } from 'vue';
import NavigationButtons from '../../common/NavigationButtons.vue';

const props = defineProps({
  selectedLicenses: {
    type: Array as () => string[],
    default: () => []
  },
  commercialLicenseData: {
    type: Object,
    default: () => ({ licensePrice: '', revenueShare: '0' })
  },
  commercialRemixLicenseData: {
    type: Object,
    default: () => ({ licensePrice: '', revenueShare: '' })
  }
});

// 添加组件挂载时的日志
onMounted(() => {
  console.log('CombinedPricingPage组件已挂载');
  console.log('选中的许可证列表:', props.selectedLicenses);
  console.log('商业许可证数据:', props.commercialLicenseData);
  console.log('商业混音许可证数据:', props.commercialRemixLicenseData);
});

const emit = defineEmits([
  'navigate-back', 
  'navigate-next', 
  'pricing-update', 
  'remix-pricing-update'
]);

// 许可证价格和收入分成
const commercialPrice = ref(props.commercialLicenseData.licensePrice || '');
const remixPrice = ref(props.commercialRemixLicenseData.licensePrice || '');
const remixRevenue = ref(props.commercialRemixLicenseData.revenueShare || '');

// 验证价格和收入分成是否有效
const isPricingValid = computed(() => {
  const commercialValid = !props.selectedLicenses.includes('commercial') || 
                         (props.selectedLicenses.includes('commercial') && !!commercialPrice.value.trim());
  
  const remixValid = !props.selectedLicenses.includes('commercial-remix') || 
                     (props.selectedLicenses.includes('commercial-remix') && !!remixPrice.value.trim());
  
  return commercialValid && remixValid;
});

// 导航方法
const goBack = () => {
  console.log('从组合定价页面返回上一页');
  emit('navigate-back');
};

const goNext = () => {
  if (isPricingValid.value) {
    console.log('提交组合定价数据并前往下一页');
    
    // 更新商业使用许可证价格
    if (props.selectedLicenses.includes('commercial')) {
      const commercialData = {
        licensePrice: commercialPrice.value,
        revenueShare: '0'
      };
      console.log('更新商业使用许可证数据:', commercialData);
      emit('pricing-update', commercialData);
    }
    
    // 更新商业混音许可证价格
    if (props.selectedLicenses.includes('commercial-remix')) {
      const remixData = {
        licensePrice: remixPrice.value,
        revenueShare: remixRevenue.value || '0'
      };
      console.log('更新商业混音许可证数据:', remixData);
      emit('remix-pricing-update', remixData);
    }
    
    // 导航到下一页
    console.log('组合定价页面发送navigate-next事件');
    emit('navigate-next');
  }
};
</script>

<style scoped>
.combined-license-pricing {
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
  margin-bottom: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.license-type-header {
  margin-bottom: 20px;
}

.license-type-header h2 {
  font-size: 1.5rem;
  font-weight: 500;
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
  padding: 12px 15px;
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

.disabled-section {
  opacity: 0.7;
}

.disabled-label {
  color: rgba(255, 255, 255, 0.5);
}

.disabled-input {
  background-color: rgba(30, 30, 30, 0.3);
  border-color: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.4);
  cursor: not-allowed;
}

.disabled-note {
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.5);
  margin-top: 6px;
  font-style: italic;
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