<template>
  <div class="blur-container">
    <!-- 添加粒子漩涡背景在容器内部 -->
    <ParticleWhirlpool class="inner-background" />
    
    <!-- 添加可滚动的内容容器 -->
    <div class="content-scroll-container">
      <component 
        :is="getCurrentComponent"
        v-bind="componentProps"
        @navigate="handleNavigate"
        @navigate-back="handleNavigateBack"
        @navigate-next="handleNavigateNext"
        @show-unavailable="handleUnavailable"
        @work-type-select="updateWorkType"
        @license-update="updateLicenses"
        @license-conflict="handleLicenseConflict"
        @license-select="handleLicenseSelect"
        @navigate-to-commercial-pricing="navigateToCommercialPricing"
        @pricing-update="updateCommercialPricing"
        @navigate-to-commercial-remix-pricing="navigateToCommercialRemixPricing"
        @navigate-to-combined-pricing="navigateToCombinedPricing"
        @remix-pricing-update="updateCommercialRemixPricing"
        @ai-permission-update="updateAIPermissions"
        @registration-complete="handleRegistrationComplete"
        @show-license-detail="openLicenseDetail"
        @file-type-error="showFileTypeErrorMessage"
        @navigate-to-add-license="navigateToAddLicense"
        @license-option-conflict="handleOptionConflict"
      />
    </div>
    
    <!-- 添加错误通知 -->
    <div v-if="showFileTypeError" class="file-type-error">
      <div class="error-content">
        <span class="error-icon">⚠️</span>
        <span class="error-message">{{ fileTypeErrorMessage }}</span>
        <button class="error-close" @click="showFileTypeError = false">×</button>
      </div>
    </div>

    <!-- 许可证冲突弹窗 -->
    <LicenseConflictModal
      v-if="showLicenseConflictModal"
      :conflict-data="conflictModalData"
      @close="closeConflictModal"
    />
    
    <!-- 选项冲突弹窗 -->
    <OptionConflictModal
      v-if="showOptionConflictModal"
      :conflict-data="optionConflictData"
      @close="closeOptionConflictModal"
    />

    <!-- 许可证详情弹窗 -->
    <LicenseDetailModal
      v-if="showLicenseDetailModal"
      :license-detail="currentLicenseDetail"
      :ai-training-enabled="aiTrainingEnabled"
      @close="closeLicenseDetailModal"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import StartPage from '../pages/start/StartPage.vue';
import WorkTypePage from '../pages/work/WorkTypePage.vue';
import LicensePage from '../pages/license/LicensePage.vue';
import CommercialLicensePricing from '../pages/license/CommercialLicensePricing.vue';
import CommercialRemixPricing from '../pages/license/CommercialRemixPricing.vue';
import CombinedPricingPage from '../pages/license/CombinedPricingPage.vue';
import AssetDetailsPage from '../pages/asset/AssetDetailsPage.vue';
import CreatorsPage from '../pages/creator/CreatorsPage.vue';
import AIPermissionsSettingsPage from '../pages/ai/AIPermissionsSettingsPage.vue';
import ReviewRegisterPage from '../pages/review/ReviewRegisterPage.vue';
// @ts-ignore - These modules exist but TypeScript can't find them
import LicenseConflictModal from '../modals/LicenseConflictModal.vue';
// @ts-ignore - These modules exist but TypeScript can't find them
import LicenseDetailModal from '../modals/LicenseDetailModal.vue';
// @ts-ignore - These modules exist but TypeScript can't find them
import OptionConflictModal from '../modals/OptionConflictModal.vue';
import ParticleWhirlpool from '../common/ParticleWhirlpool.vue';

// 当前页面状态
const currentPage = ref('start'); // 'start', 'workType', 'license', 'commercialPricing', 'commercialRemixPricing', 'combinedPricing', 'assetDetails', 'creators', 'aiPermissionsSettings', 'reviewRegister'

// 当前选择的作品类型
const selectedWorkType = ref({
  mainType: '',
  creatorType: ''
});

// 当前选择的许可证
const selectedLicense = ref('');
const selectedLicenses = ref<string[]>([]);

// 当前选择的资产类型
const selectedAssetType = ref('');

// State for file type error message
const showFileTypeError = ref(false);
const fileTypeErrorMessage = ref('');

// AI训练设置状态
const aiTrainingEnabled = ref(true); // 默认允许AI训练，但用户可以自由选择

// 许可证冲突弹窗状态
const showLicenseConflictModal = ref(false);
const conflictModalData = ref({
  newLicense: '',
  conflictingLicenses: [] as string[],
  reason: '',
  newLicenseName: '',
  conflictsList: ''
});

// 许可证详情弹窗状态
const showLicenseDetailModal = ref(false);
const currentLicenseDetail = ref({
  license: '',
  name: '',
  summary: ''
});

// 添加资产数据
const assetData = ref({});

// 添加共同创作者列表
const coCreators = ref<Array<{name: string, wallet: string}>>([]);

// 商业许可证价格数据
const commercialLicenseData = ref({
  licensePrice: '',
  revenueShare: ''
});

// 商业混音许可证价格数据
const commercialRemixLicenseData = ref({
  licensePrice: '',
  revenueShare: ''
});

// 选项冲突弹窗状态
const showOptionConflictModal = ref(false);
const optionConflictData = ref({
  message: '',
  filterId: '',
  value: ''
});

// 根据当前页面获取对应的组件
const getCurrentComponent = computed(() => {
  console.log('当前页面:', currentPage.value);
  switch (currentPage.value) {
    case 'start':
      return StartPage;
    case 'workType':
      return WorkTypePage;
    case 'license':
      return LicensePage;
    case 'commercialPricing':
      return CommercialLicensePricing;
    case 'commercialRemixPricing':
      return CommercialRemixPricing;
    case 'combinedPricing':
      console.log('加载组合定价页面组件');
      return CombinedPricingPage;
    case 'assetDetails':
      return AssetDetailsPage;
    case 'creators':
      return CreatorsPage;
    case 'aiPermissionsSettings':
      return AIPermissionsSettingsPage;
    case 'reviewRegister':
      return ReviewRegisterPage;
    default:
      return StartPage;
  }
});

// 传递给组件的props
const componentProps = computed(() => {
  switch (currentPage.value) {
    case 'workType':
      return { selectedWorkType: selectedWorkType.value };
    case 'license':
      return { 
        selectedLicenses: selectedLicenses.value,
        assetType: selectedAssetType.value,
        workType: selectedWorkType.value
      };
    case 'commercialPricing':
      return { 
        licensePrice: commercialLicenseData.value.licensePrice,
        revenueShare: commercialLicenseData.value.revenueShare
      };
    case 'commercialRemixPricing':
      return { 
        licensePrice: commercialRemixLicenseData.value.licensePrice,
        revenueShare: commercialRemixLicenseData.value.revenueShare
      };
    case 'combinedPricing':
      return { 
        selectedLicenses: selectedLicenses.value,
        commercialLicenseData: commercialLicenseData.value,
        commercialRemixLicenseData: commercialRemixLicenseData.value
      };
    case 'assetDetails':
      return {};
    case 'creators':
      return { creators: coCreators.value };
    case 'aiPermissionsSettings':
      return { 
        aiTrainingEnabled: aiTrainingEnabled.value,
        selectedLicenses: selectedLicenses.value 
      };
    case 'reviewRegister':
      return { 
        workType: selectedWorkType.value,
        assetData: assetData.value,
        licenses: selectedLicenses.value,
        aiTrainingEnabled: aiTrainingEnabled.value,
        creators: coCreators.value,
        commercialLicenseData: commercialLicenseData.value,
        commercialRemixLicenseData: commercialRemixLicenseData.value
      };
    default:
      return {};
  }
});

// 页面导航处理
const handleNavigate = (page: string) => {
  console.log(`直接导航至页面: ${page}`);
  currentPage.value = page;
};

const handleNavigateBack = () => {
  // 根据当前页面决定返回哪个页面
  // 由于我们在handleNavigateNext中已经保存了每步的数据
  // 这里只需要更新currentPage，不需要重置任何数据
  if (currentPage.value === 'workType') {
    currentPage.value = 'start';
  } else if (currentPage.value === 'assetDetails') {
    currentPage.value = 'workType';
  } else if (currentPage.value === 'license') {
    currentPage.value = 'creators';
  } else if (currentPage.value === 'commercialPricing') {
    currentPage.value = 'license';
  } else if (currentPage.value === 'commercialRemixPricing') {
    currentPage.value = 'license';
  } else if (currentPage.value === 'combinedPricing') {
    currentPage.value = 'license';
  } else if (currentPage.value === 'creators') {
    currentPage.value = 'assetDetails';
  } else if (currentPage.value === 'aiPermissionsSettings') {
    // 根据用户选择的许可证类型决定返回哪个页面
    if (selectedLicenses.value.includes('commercial-remix') && selectedLicenses.value.includes('commercial')) {
      currentPage.value = 'combinedPricing';
    } else if (selectedLicenses.value.includes('commercial-remix')) {
      currentPage.value = 'commercialRemixPricing';
    } else if (selectedLicenses.value.includes('commercial')) {
      currentPage.value = 'commercialPricing';
    } else {
      currentPage.value = 'license';
    }
  } else if (currentPage.value === 'reviewRegister') {
    currentPage.value = 'aiPermissionsSettings';
  }
};

const handleNavigateNext = (data?: any) => {
  if (currentPage.value === 'workType') {
    // 保存作品类型数据
    if (data) {
      selectedWorkType.value = data;
    }
    currentPage.value = 'assetDetails';
  } else if (currentPage.value === 'assetDetails') {
    // 保存资产数据
    if (data) {
      assetData.value = data;
      // 更新资产类型
      if (data.type) {
        updateAssetType(data.type);
      }
    }
    currentPage.value = 'creators';
  } else if (currentPage.value === 'creators') {
    // 更新共同创作者数据
    if (data && Array.isArray(data)) {
      coCreators.value = data;
      console.log('共同创作者数据已更新:', coCreators.value);
    }
    currentPage.value = 'license';
  } else if (currentPage.value === 'license') {
    // 保存许可证数据
    if (data && Array.isArray(data)) {
      selectedLicenses.value = data;
    }
    currentPage.value = 'aiPermissionsSettings';
  } else if (currentPage.value === 'commercialPricing') {
    // 保存商业许可证价格数据
    if (data) {
      commercialLicenseData.value = data;
    }
    currentPage.value = 'aiPermissionsSettings';
  } else if (currentPage.value === 'commercialRemixPricing') {
    // 保存商业混音许可证价格数据
    if (data) {
      commercialRemixLicenseData.value = data;
    }
    currentPage.value = 'aiPermissionsSettings';
  } else if (currentPage.value === 'combinedPricing') {
    // 保存组合定价数据
    if (data) {
      if (data.commercialLicenseData) {
        commercialLicenseData.value = data.commercialLicenseData;
      }
      if (data.commercialRemixLicenseData) {
        commercialRemixLicenseData.value = data.commercialRemixLicenseData;
      }
    }
    currentPage.value = 'aiPermissionsSettings';
  } else if (currentPage.value === 'aiPermissionsSettings') {
    // 保存AI权限设置
    if (data) {
      aiTrainingEnabled.value = data.global;
    }
    currentPage.value = 'reviewRegister';
  } else if (currentPage.value === 'reviewRegister') {
    // 完成注册
    handleRegistrationComplete(data);
  }
};

// 暂未开放功能提示
const handleUnavailable = (type: string) => {
  alert(`${type === 'task' ? '发布任务' : '发布活动'}功能尚未开放，敬请期待`);
};

// 更新作品类型
const updateWorkType = (type: { mainType: string; creatorType: string }) => {
  selectedWorkType.value = type;
  
  // 根据作品类型重置许可证
  // 这里可以添加不同作品类型对应的默认许可证
  selectedLicenses.value = [];
  selectedLicense.value = '';
};

// 更新资产类型（从AssetDetailsPage获取）
const updateAssetType = (assetType: string) => {
  selectedAssetType.value = assetType;
  
  // 根据资产类型同步调整许可证选项
  // 可以在这里添加基于资产类型的许可证限制逻辑
  console.log('已更新资产类型:', assetType);
};

// 更新许可证
const updateLicenses = (licenses: string[]) => {
  selectedLicenses.value = licenses;
  if (licenses.length > 0) {
    selectedLicense.value = licenses[licenses.length - 1];
  } else {
    selectedLicense.value = '';
  }
};

// 处理许可证冲突
const handleLicenseConflict = (newLicense: string, conflictingLicenses: string[], reason: string) => {
  const licenseNames = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音'
  };
  
  const conflictsList = conflictingLicenses.map(license => licenseNames[license as keyof typeof licenseNames]).join('、');
  const newLicenseName = licenseNames[newLicense as keyof typeof licenseNames];
  
  // 设置冲突数据并显示弹窗
  conflictModalData.value = {
    newLicense,
    conflictingLicenses,
    reason,
    newLicenseName,
    conflictsList
  };
  showLicenseConflictModal.value = true;
};

// 关闭冲突弹窗
const closeConflictModal = () => {
  showLicenseConflictModal.value = false;
};

// 打开许可证详情弹窗
const openLicenseDetail = (licenseDetail: any) => {
  currentLicenseDetail.value = licenseDetail;
  showLicenseDetailModal.value = true;
};

// 关闭许可证详情弹窗
const closeLicenseDetailModal = () => {
  showLicenseDetailModal.value = false;
};

// 显示文件类型错误信息
const showFileTypeErrorMessage = (message: string) => {
  fileTypeErrorMessage.value = message;
  showFileTypeError.value = true;
  
  // 3秒后自动隐藏
  setTimeout(() => {
    showFileTypeError.value = false;
  }, 3000);
};

// 更新AI权限 - 支持用户为每种许可证类型自由选择AI培训设置
const updateAIPermissions = (permissions: {
  global: boolean;
  commercial: boolean;
  'commercial-remix': boolean;
  'non-commercial': boolean;
  open: boolean;
}) => {
  console.log('更新AI权限:', permissions);
  aiTrainingEnabled.value = permissions.global;
};

// 添加一个导航到添加许可证界面的函数
const navigateToAddLicense = () => {
  // 导航到许可证页面
  currentPage.value = 'license';
  console.log('导航到添加许可证界面');
};

// 完成注册
const handleRegistrationComplete = (data: any) => {
  // 在这里处理注册完成逻辑
  alert('注册成功！');
  // 重置页面状态，返回首页
  currentPage.value = 'start';
  selectedWorkType.value = {
    mainType: '',
    creatorType: ''
  };
  selectedLicenses.value = [];
  assetData.value = {};
  coCreators.value = [];
};

// 处理许可证选择
const handleLicenseSelect = (licenseId: string) => {
  console.log('许可证选择处理器被调用', licenseId);
  selectedLicense.value = licenseId;
};

// 处理从许可证页面到商业许可证定价页面的导航
const navigateToCommercialPricing = () => {
  console.log('导航到商业许可证定价页面');
  currentPage.value = 'commercialPricing';
};

// 处理更新商业许可证定价信息
const updateCommercialPricing = (pricingData: { licensePrice: string, revenueShare: string }) => {
  console.log('更新商业许可证定价信息', pricingData);
  commercialLicenseData.value = pricingData;
  // 选择商业许可证
  if (!selectedLicenses.value.includes('commercial')) {
    selectedLicenses.value = [...selectedLicenses.value, 'commercial'];
  }
};

// 处理从许可证页面到商业混音许可证定价页面的导航
const navigateToCommercialRemixPricing = () => {
  console.log('导航到商业混音许可证定价页面');
  currentPage.value = 'commercialRemixPricing';
};

// 处理从许可证页面到组合定价页面的导航
const navigateToCombinedPricing = () => {
  console.log('收到navigate-to-combined-pricing事件');
  console.log('当前选中的许可证:', selectedLicenses.value);
  console.log('商业许可证数据:', commercialLicenseData.value);
  console.log('商业混音许可证数据:', commercialRemixLicenseData.value);
  
  // 确保两种许可证都被选中
  if (!selectedLicenses.value.includes('commercial')) {
    selectedLicenses.value.push('commercial');
  }
  if (!selectedLicenses.value.includes('commercial-remix')) {
    selectedLicenses.value.push('commercial-remix');
  }
  
  currentPage.value = 'combinedPricing';
  console.log('已导航到组合定价页面，当前页面:', currentPage.value);
};

// 处理更新商业混音许可证定价信息
const updateCommercialRemixPricing = (pricingData: { licensePrice: string, revenueShare: string }) => {
  console.log('更新商业混音许可证定价信息', pricingData);
  commercialRemixLicenseData.value = pricingData;
  // 选择商业混音许可证
  if (!selectedLicenses.value.includes('commercial-remix')) {
    selectedLicenses.value = [...selectedLicenses.value, 'commercial-remix'];
  }
};

// 显示选项冲突模态对话框
const handleOptionConflict = (data: {message: string, filterId: string, value: string}) => {
  optionConflictData.value = data;
  showOptionConflictModal.value = true;
};

// 关闭选项冲突模态对话框
const closeOptionConflictModal = () => {
  showOptionConflictModal.value = false;
};

// 导出可能需要的函数
defineExpose({
  openLicenseDetail,
  showFileTypeErrorMessage,
  navigateToAddLicense,
  navigateToCommercialPricing,
  updateCommercialPricing,
  navigateToCommercialRemixPricing,
  updateCommercialRemixPricing,
  navigateToCombinedPricing
});
</script>

<style scoped>
.blur-container {
  width: 90vw;
  max-width: 1280px;
  height: 90vh;
  backdrop-filter: blur(30px);
  -webkit-backdrop-filter: blur(30px);
  background: rgba(20, 25, 45, 0.5);
  border-radius: 20px;
  padding: 0;
  box-shadow: 
    0 10px 40px rgba(0, 0, 0, 0.4),
    0 0 80px rgba(74, 103, 207, 0.2),
    inset 0 0 0 1px rgba(114, 137, 218, 0.2);
  overflow: hidden;
  position: relative;
  animation: fadeInScale 0.8s ease forwards;
  border: 1px solid rgba(140, 232, 255, 0.15);
}

/* 内部背景样式 - 增强粒子效果 */
.inner-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  overflow: hidden; /* 确保粒子不会溢出容器 */
  opacity: 0.9; /* 增加整体透明度以适应更多粒子 */
}

/* 确保所有内容在背景之上 */
.blur-container > *:not(.inner-background) {
  position: relative;
  z-index: 1;
}

.file-type-error {
  position: fixed;
  top: 20px;
  right: 20px;
  background: rgba(220, 53, 69, 0.9);
  color: white;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
  z-index: 1000;
  animation: slideIn 0.3s forwards;
  max-width: 400px;
}

.error-content {
  display: flex;
  align-items: center;
  gap: 10px;
}

.error-icon {
  font-size: 20px;
}

.error-message {
  flex: 1;
}

.error-close {
  background: none;
  border: none;
  color: white;
  font-size: 18px;
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.8;
  transition: opacity 0.2s;
}

.error-close:hover {
  opacity: 1;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.content-scroll-container {
  width: 100%;
  height: 100%;
  position: relative;
  z-index: 1;
  overflow: auto;
  padding: 30px;
  display: flex;
  flex-direction: column;
  align-items: center;
  /* 可选的滚动条样式 */
  scrollbar-width: thin;
  scrollbar-color: rgba(114, 137, 218, 0.3) transparent;
}

.content-scroll-container > * {
  width: 100%;
  max-width: 1100px; /* 限制内容最大宽度 */
}

.content-scroll-container::-webkit-scrollbar {
  width: 8px;
}

.content-scroll-container::-webkit-scrollbar-track {
  background: transparent;
}

.content-scroll-container::-webkit-scrollbar-thumb {
  background-color: rgba(114, 137, 218, 0.3);
  border-radius: 10px;
  border: 2px solid transparent;
}

.content-scroll-container::-webkit-scrollbar-thumb:hover {
  background-color: rgba(114, 137, 218, 0.5);
}
</style> 