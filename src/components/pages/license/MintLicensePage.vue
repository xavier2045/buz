<template>
  <div class="mint-license-page">
    <!-- 许可证价格输入 - 步骤1 -->
    <div v-if="step === 1" class="full-container">
      <!-- 铸造价格模态框 -->
      <MintLicensePriceModal 
        v-if="showMintPriceModal"
        @close="closeMintPriceModal"
        @confirm="confirmMintPrice"
      />
    </div>
    
    <!-- 许可证到期设置 - 步骤2 -->
    <div v-else-if="step === 2" class="full-container">
      <LicenseExpirationPage
        :license-type="props.licenseType"
        :source-tab="'mint'"
        @select-expiration="handleExpirationSelect"
        @navigate-back="handleExpirationBack"
      />
    </div>
    
    <!-- 许可证确认 - 步骤3 -->
    <div v-else-if="step === 3" class="confirmation-container">
      <div class="header">
        <h1 class="page-title">铸造许可证</h1>
        <p class="page-subtitle">您即将铸造此许可证并将其添加到区块链上</p>
      </div>

      <div class="license-preview">
        <div class="license-card">
          <div class="license-header">
            <div class="license-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="30" height="30" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 14h-1a7 7 0 0 0-7 7v0"></path>
                <path d="M21 7v7l-7-7z"></path>
                <path d="M3 7h1a7 7 0 0 1 7-7v0"></path>
                <path d="M3 14v-7l7 7z"></path>
                <path d="M10 21h4"></path>
                <path d="M10 3h4"></path>
              </svg>
            </div>
            <div class="license-title">{{ getLicenseName(licenseType) }}</div>
          </div>
          
          <div class="license-body">
            <p class="license-description">{{ getLicenseDescription(licenseType) }}</p>
            
            <div class="license-terms">
              <div class="term-item" v-for="(term, index) in getLicenseTerms(licenseType)" :key="index">
                <div class="term-icon">{{ term.icon }}</div>
                <div class="term-text">{{ term.text }}</div>
              </div>
            </div>
            
            <div class="license-price" v-if="showPrice">
              <div class="price-label">许可价格:</div>
              <div class="price-value">
                <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="bag-coin" width="14" height="14" class="price-icon">
                  <path d="m12.5 7h-7c-.827 0-1.5-.673-1.5-1.5s.673-1.5 1.5-1.5h7c.827 0 1.5.673 1.5 1.5s-.673 1.5-1.5 1.5zm-7-2c-.276 0-.5.225-.5.5s.224.5.5.5h7c.276 0 .5-.225.5-.5s-.224-.5-.5-.5z"></path>
                  <path d="M11.5 5c-.147 0-.292-.064-.391-.188-.172-.216-.137-.53.078-.703l2.774-2.219c.257-.205.188-.478.16-.557-.027-.077-.143-.333-.472-.333h-9.298c-.329 0-.445.256-.472.334-.028.079-.098.352.16.557l2.774 2.219c.215.173.25.487.078.703-.172.215-.486.25-.703.078l-2.774-2.219c-.505-.404-.693-1.059-.479-1.669.214-.609.77-1.003 1.416-1.003h9.299c.646 0 1.202.394 1.416 1.003.214.61.026 1.265-.479 1.669l-2.774 2.219c-.093.073-.203.109-.313.109zM10 24h-4.5c-3.799 0-5.5-3.265-5.5-6.5 0-4.643 2.451-9.45 5.827-11.432.077-.045.164-.068.253-.068h5.84c.089 0 .176.023.253.068 1.375.807 2.623 2.076 3.607 3.672.145.235.072.543-.163.688-.236.143-.543.072-.688-.163-.871-1.411-1.957-2.537-3.147-3.265h-5.564c-3.03 1.854-5.218 6.243-5.218 10.5 0 2.537 1.179 5.5 4.5 5.5h4.5c.276 0 .5.224.5.5s-.224.5-.5.5z"></path>
                  <path d="m17 24c-3.394 0-7-1.052-7-3 0-.276.224-.5.5-.5s.5.224.5.5c0 .835 2.283 2 6 2s6-1.165 6-2c0-.276.224-.5.5-.5s.5.224.5.5c0 1.948-3.606 3-7 3z"></path>
                  <path d="m17 21c-3.394 0-7-1.052-7-3 0-.276.224-.5.5-.5s.5.224.5.5c0 .835 2.283 2 6 2s6-1.165 6-2c0-.276.224-.5.5-.5s.5.224.5.5c0 1.948-3.606 3-7 3z"></path>
                  <path d="m17 18c-3.394 0-7-1.052-7-3s3.606-3 7-3 7 1.052 7 3-3.606 3-7 3zm0-5c-3.717 0-6 1.165-6 2s2.283 2 6 2 6-1.165 6-2-2.283-2-6-2z"></path>
                  <path d="M23.5 21.5c-.276 0-.5-.224-.5-.5v-6c0-.276.224-.5.5-.5s.5.224.5.5v6c0 .276-.224.5-.5.5zM10.5 21.5c-.276 0-.5-.224-.5-.5v-6c0-.276.224-.5.5-.5s.5.224.5.5v6c0 .276-.224.5-.5.5z"></path>
                </svg>
                {{ formattedPrice }}
              </div>
            </div>
            
            <!-- 显示到期信息 -->
            <div class="license-expiration">
              <div class="expiration-label">到期时间:</div>
              <div class="expiration-value">{{ getExpirationText(selectedExpiration) }}</div>
            </div>
            
            <!-- 显示上传文件信息 -->
            <div class="uploaded-files-info" v-if="originalFiles.length > 0">
              <div class="files-label">已上传原文件:</div>
              <div class="files-value">{{ originalFiles.length }}个文件</div>
            </div>
          </div>
          
          <div class="license-footer">
            <div class="blockchain-indicator">
              <div class="blockchain-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M7 10V7a5 5 0 0 1 10 0v3" stroke="#64EEBC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <rect x="3" y="10" width="18" height="12" rx="2" stroke="#64EEBC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="blockchain-text">链上许可证</div>
            </div>
          </div>
        </div>
      </div>

      <div class="mint-steps">
        <div class="step-indicator">
          <div class="step-circle completed">1</div>
          <div class="step-line active"></div>
          <div class="step-circle completed">2</div>
          <div class="step-line active"></div>
          <div class="step-circle active">3</div>
        </div>
        
        <div class="step-labels">
          <div class="step-label">设置许可价格</div>
          <div class="step-label">选择到期时间</div>
          <div class="step-label">许可证铸造</div>
        </div>
      </div>

      <div class="navigation-section">
        <NavigationButtons 
          @back="navigateBack" 
          @next="navigateNext"
          :next-disabled="false"
          :next-text="'铸造许可证'"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import NavigationButtons from '../../common/NavigationButtons.vue';
import MintLicensePriceModal from '../../modals/MintLicensePriceModal.vue';
import LicenseExpirationPage from './LicenseExpirationPage.vue';

const emit = defineEmits(['navigate-back', 'navigate-next', 'mint-complete']);

// 接收父组件传递的数据
const props = defineProps({
  licenseType: {
    type: String,
    required: true,
    default: 'commercial'
  },
  licensePrice: {
    type: String,
    default: ''
  },
  revenueShare: {
    type: String,
    default: '0'
  }
});

// 当前流程步骤
const step = ref(1);
// 控制铸造价格模态框显示
const showMintPriceModal = ref(true);
// 铸造价格
const mintPrice = ref('');
// 许可证到期时间
const selectedExpiration = ref('never');
// 上传的原文件
const originalFiles = ref<File[]>([]);
// 是否显示价格
const showPrice = computed(() => {
  return props.licenseType === 'commercial' || props.licenseType === 'commercial-remix';
});

// 格式化许可证价格显示
const formattedPrice = computed(() => {
  if (props.licenseType === 'commercial' || props.licenseType === 'commercial-remix') {
    const price = props.licensePrice || '0';
    const revenueShare = props.revenueShare || '0';
    
    if (price && revenueShare && revenueShare !== '0') {
      return `${price} ¥ + ${revenueShare}% 分成`;
    } else if (price) {
      return `${price} ¥`;
    } else if (revenueShare && revenueShare !== '0') {
      return `${revenueShare}% 分成`;
    }
    return '未设置价格';
  }
  return '';
});

// 获取到期文本
const getExpirationText = (expiration: string) => {
  if (expiration === 'never') return '永久';
  if (expiration === '6months') return '6个月';
  if (expiration === '1year') return '1年';
  // 处理自定义日期
  if (expiration && expiration.includes('-')) {
    const date = new Date(expiration);
    return date.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' });
  }
  return expiration;
};

// 下一步按钮是否禁用
const isNextDisabled = computed(() => {
  if (step.value === 1) return !mintPrice.value;
  return false;
});

// 获取许可证名称
const getLicenseName = (licenseType: string) => {
  const licenseNames: Record<string, string> = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音'
  };
  return licenseNames[licenseType] || licenseType;
};

// 获取许可证描述
const getLicenseDescription = (licenseType: string) => {
  const descriptions: Record<string, string> = {
    'open': '开放域是一种公共贡献工具，它允许创作者放弃版权，将作品放入全球公共域。使用者可以在任何媒介或格式中分发、混音、改编和构建作品，无需任何条件。',
    'non-commercial': '任何人都可以使用您的作品创建非商业项目。他们可以修改、调整和构建您的作品，但必须标明原创者，且不能将作品用于商业目的。',
    'commercial': '允许他人按照您设定的经济条款使用您的作品。使用者必须支付许可费和/或版税，但不允许对您的作品进行修改或创建衍生作品。',
    'commercial-remix': '允许他们混音您的作品，同时您获得认可和收益。使用者可以修改和构建您的作品，但必须支付许可费和/或版税，同时标明您是原创者。'
  };
  return descriptions[licenseType] || '';
};

// 获取许可证条款列表
const getLicenseTerms = (licenseType: string) => {
  const commonTerms = [
    { icon: '🤖', text: '允许AI训练' }
  ];
  
  const licenseSpecificTerms: Record<string, Array<{icon: string, text: string}>> = {
    'open': [
      { icon: '📝', text: '无需标明出处' },
      { icon: '💲', text: '允许任何使用' },
      { icon: '↩️', text: '允许混音改编' },
      { icon: '📊', text: '无版税共享' }
    ],
    'non-commercial': [
      { icon: '📝', text: '需要标明出处' },
      { icon: '💲', text: '仅限非商业使用' },
      { icon: '↩️', text: '允许混音改编' },
      { icon: '📊', text: '无版税共享' }
    ],
    'commercial': [
      { icon: '📝', text: '需要标明出处' },
      { icon: '💲', text: '允许商业使用' },
      { icon: '↩️', text: '不允许混音改编' },
      { icon: '📊', text: '收取版税' }
    ],
    'commercial-remix': [
      { icon: '📝', text: '需要标明出处' },
      { icon: '💲', text: '允许商业使用' },
      { icon: '↩️', text: '允许混音改编' },
      { icon: '📊', text: '收取版税' }
    ]
  };
  
  return [...licenseSpecificTerms[licenseType] || [], ...commonTerms];
};

// 导航到上一步
const navigateBack = () => {
  if (step.value > 1) {
    step.value--;
    if (step.value === 1) {
      showMintPriceModal.value = true;
    }
  } else {
    emit('navigate-back');
  }
};

// 导航到下一步
const navigateNext = () => {
  if (step.value === 1) {
    // 如果是第一步，但没有设置价格，则打开模态框
    if (!mintPrice.value) {
      showMintPriceModal.value = true;
      return;
    }
    step.value++;
  } else if (step.value === 2) {
    // 第二步已在LicenseExpirationPage处理
  } else if (step.value === 3) {
    // 完成铸造流程
    emit('mint-complete', {
      licenseType: props.licenseType,
      mintPrice: mintPrice.value,
      expiration: selectedExpiration.value,
      files: originalFiles.value
    });
  }
};

// 关闭铸造价格模态框
const closeMintPriceModal = () => {
  showMintPriceModal.value = false;
  // 如果是初始步骤且没有设置价格，则返回上一页
  if (step.value === 1 && !mintPrice.value) {
    emit('navigate-back');
  }
};

// 确认铸造价格
const confirmMintPrice = (data: { price: string, files: File[] }) => {
  mintPrice.value = data.price;
  originalFiles.value = data.files;
  showMintPriceModal.value = false;
  step.value = 2; // 确认价格后进入到期选择
  
  // 保存上传的文件到Window对象，以便在其他页面访问
  if (typeof window !== 'undefined') {
    // @ts-ignore
    window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
    // @ts-ignore
    window._uploadedLicenseFiles[props.licenseType] = data.files;
    
    console.log(`已保存 ${props.licenseType} 的文件状态，共 ${data.files.length} 个文件`);
  }
};

// 处理到期日期选择
const handleExpirationSelect = (expiration: string) => {
  selectedExpiration.value = expiration;
  step.value = 3; // 选择到期日期后进入确认页面
};

// 从到期页面返回
const handleExpirationBack = () => {
  step.value = 1;
  showMintPriceModal.value = true;
};

// 组件挂载时，如果是第一步，则显示铸造价格模态框
onMounted(() => {
  if (step.value === 1) {
    showMintPriceModal.value = true;
  }
});
</script>

<style scoped>
.mint-license-page {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
}

.full-container {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
}

.confirmation-container {
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

.header {
  text-align: center;
  margin-bottom: 40px;
  width: 100%;
}

.page-title {
  font-size: 32px;
  margin-bottom: 12px;
  color: white;
  font-weight: 600;
}

.page-subtitle {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
}

.license-preview {
  width: 100%;
  margin-bottom: 40px;
  display: flex;
  justify-content: center;
}

.license-card {
  width: 100%;
  max-width: 600px;
  background: rgba(30, 30, 35, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.license-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
  border-color: rgba(255, 255, 255, 0.2);
}

.license-header {
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 15px;
  background: rgba(40, 40, 45, 0.5);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.license-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: rgba(100, 100, 100, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.license-title {
  font-size: 20px;
  font-weight: 500;
  color: white;
}

.license-body {
  padding: 20px;
}

.license-description {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.5;
  margin-bottom: 20px;
}

.license-terms {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 20px;
}

.term-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.term-icon {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
}

.term-text {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
}

.license-price {
  margin-top: 20px;
  padding: 15px;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-left: 3px solid #64EEBC;
}

.price-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.price-value {
  font-size: 15px;
  color: #64EEBC;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 5px;
}

.price-icon {
  color: #64EEBC;
  fill: currentColor;
}

.license-footer {
  padding: 15px 20px;
  background: rgba(30, 30, 35, 0.5);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: flex-end;
}

.blockchain-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(100, 238, 188, 0.1);
  padding: 6px 12px;
  border-radius: 20px;
  border: 1px solid rgba(100, 238, 188, 0.3);
}

.blockchain-icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

.blockchain-text {
  font-size: 12px;
  color: #64EEBC;
  font-weight: 500;
}

.mint-steps {
  width: 100%;
  max-width: 600px;
  margin-bottom: 40px;
}

.step-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
}

.step-circle {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
  border: 2px solid transparent;
  transition: all 0.3s ease;
}

.step-circle.active {
  background: rgba(100, 238, 188, 0.1);
  color: #64EEBC;
  border-color: rgba(100, 238, 188, 0.5);
}

.step-circle.completed {
  background: rgba(100, 238, 188, 0.2);
  color: white;
  border-color: #64EEBC;
}

.step-line {
  width: 80px;
  height: 2px;
  background: rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.step-line.active {
  background: #64EEBC;
}

.step-labels {
  display: flex;
  justify-content: space-between;
  margin-top: 8px;
}

.step-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  padding: 0 15px;
  text-align: center;
  width: 33.33%;
}

.navigation-section {
  width: 100%;
  max-width: 600px;
  margin-top: 30px;
}

.license-expiration {
  display: flex;
  align-items: center;
  margin-top: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.expiration-label {
  font-weight: 500;
  margin-right: 10px;
  color: rgba(255, 255, 255, 0.7);
}

.expiration-value {
  color: white;
}

.uploaded-files-info {
  display: flex;
  align-items: center;
  margin-top: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.files-label {
  font-weight: 500;
  margin-right: 10px;
  color: rgba(255, 255, 255, 0.7);
}

.files-value {
  color: #4A90E2;
  display: flex;
  align-items: center;
}

@media (max-width: 767px) {
  .confirmation-container {
    width: 90%;
    padding: 50px 20px 40px;
    margin-top: 20px;
  }
  
  .page-title {
    font-size: 28px;
  }
  
  .page-subtitle {
    font-size: 16px;
  }
  
  .license-card {
    max-width: 100%;
  }
  
  .step-line {
    width: 40px;
  }
  
  .navigation-section {
    flex-direction: column;
    gap: 16px;
  }
}
</style> 