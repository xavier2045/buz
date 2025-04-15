<template>
  <div class="license-container">
    <!-- 标题部分 -->
    <div class="header" v-if="!showNonCommercialExpiration && !showLicenseExpiration && !showRemixPermission && !showCommercialRemixPermission && !showRevenueShare && !showAttribution && !showAttributionRequired && !showAITraining">
      <h1>添加许可证</h1>
      <p class="subtitle-zh">您最多可向此资产添加5个许可证</p>
    </div>

    <!-- 标签页切换 - 始终显示标签页，但内容通过条件渲染隐藏 -->
    <div class="tabs" @click="debugTabClick">
      <button 
        v-for="(tab, index) in tabs" 
        :key="tab.id"
        :class="['tab', { active: activeTabIndex === index }]"
        @click.stop.prevent="setActiveTab(index)"
        type="button"
      >
        {{ tab.label }}
      </button>
    </div>

    <!-- 非商业许可证到期日期页面 -->
    <NonCommercialExpirationPage
      v-if="showNonCommercialExpiration"
      :source-tab="sourceTab"
      @select-expiration="handleExpirationSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- 铸造此许可证需要多少钱页面 -->
    <MintCostPage
      v-if="showMintCost"
      :source-tab="sourceTab"
      :license-type="currentLicenseType"
      @select-mint-cost="handleMintCostSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- 商业许可证到期日期页面 -->
    <LicenseExpirationPage
      v-if="showLicenseExpiration"
      :source-tab="sourceTab"
      :license-type="currentLicenseType"
      @select-expiration="handleCommercialExpirationSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- 混音许可选择页面 -->
    <RemixPermissionPage
      v-if="showRemixPermission"
      :source-tab="sourceTab"
      @select-remix="handleRemixSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- 商业混音许可选择页面 -->
    <CommercialRemixPermissionPage
      v-if="showCommercialRemixPermission"
      :source-tab="sourceTab"
      :license-type="currentLicenseType"
      :expiration="tempLicenseData.expiration"
      @select-remix="handleCommercialRemixSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- 收入分成选择页面 -->
    <RevenueSharePage
      v-if="showRevenueShare"
      :source-tab="sourceTab"
      :license-type="currentLicenseType"
      :expiration="tempLicenseData.expiration"
      :allow-remix="tempLicenseData.allowRemix"
      @select-revenue-share="handleRevenueShareSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- 注明出处选择页面 -->
    <AttributionPage
      v-if="showAttribution"
      :source-tab="sourceTab"
      :license-type="currentLicenseType"
      :expiration="tempLicenseData.expiration"
      :allow-remix="tempLicenseData.allowRemix"
      :revenue-share="tempLicenseData.revenueShare"
      @select-attribution="handleAttributionPageSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- AI训练选择页面 -->
    <AITrainingPage
      v-if="showAITraining"
      :source-tab="sourceTab"
      @select-ai-training="handleAITrainingSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- 归属要求选择页面 -->
    <AttributionRequiredPage 
      v-if="showAttributionRequired"
      :source-tab="sourceTab"
      @select-attribution="handleAttributionSelect"
      @navigate-back="handleNavigateBack"
    />
    
    <!-- 铸造许可证页面 -->
    <MintLicensePage
      v-if="showMintLicensePage"
      :license-type="selectedMintLicense"
      :license-price="licensePrice"
      :revenue-share="revenueShare"
      @navigate-back="handleNavigateBack"
      @mint-complete="handleMintComplete"
    />

    <!-- 预设许可证标签页内容 -->
    <div v-else-if="activeTabIndex === 0 && !showMintCost && !showNonCommercialExpiration && !showLicenseExpiration && !showRemixPermission && !showCommercialRemixPermission && !showRevenueShare && !showAttribution && !showAttributionRequired && !showAITraining" class="license-options">
      <!-- 显示已选择的许可证 -->
      <div class="selected-licenses-header">
        <h3>已选择的许可证: <span class="license-count">{{ selectedLicenses.length }}/5</span></h3>
        <div v-if="assetType" class="asset-type-info">
          当前资产类型: <span class="asset-type-value">{{ getAssetTypeChinese }}</span>
          <div class="asset-type-hint">基于您的资产类型，我们为您推荐以下许可证</div>
        </div>
        
        <div class="selected-licenses-list">
          <div v-if="selectedLicenses.length === 0" class="no-licenses">尚未选择许可证</div>
          <div v-else class="selected-license-tags">
            <span v-for="license in selectedLicenses" :key="license" class="selected-license-tag">
              {{ getLicenseName(license) }}
              <span class="remove-tag" @click.stop="removeLicense(license)">×</span>
            </span>
          </div>
        </div>
      </div>

      <!-- 添加共享的原文件显示区域 -->
      <div 
        v-if="hasCommercialLicensesSelected && hasUploadedCommercialFiles && !props.selectedLicenses.includes('open')" 
        class="shared-files-container grid-full-width"
      >
        <div class="shared-files-header">
          <h4>已上传原文件</h4>
          <div class="shared-files-info">这些文件将用于"商业使用"和"商业混音"许可证</div>
        </div>
        <div class="shared-files-list">
          <div 
            v-for="(file, index) in commercialFiles" 
            :key="index" 
            class="shared-file-item"
          >
            <div class="file-type-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
              </svg>
            </div>
            <div class="file-name-truncate">{{ file.name }}</div>
            <div class="file-size-info">{{ formatFileSize(file.size) }}</div>
            <!-- 文件删除按钮 -->
            <button class="shared-file-delete-btn" @click="deleteSharedFile(index)" title="删除文件">
              <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 6h18"></path>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>
                <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                <line x1="10" y1="11" x2="10" y2="17"></line>
                <line x1="14" y1="11" x2="14" y2="17"></line>
              </svg>
            </button>
          </div>
          <!-- 添加更多文件按钮 -->
          <div class="shared-add-files-btn" @click="openCommercialFileSelector">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M12 5v14"></path>
              <path d="M5 12h14"></path>
            </svg>
            <span>添加更多文件</span>
          </div>
        </div>
      </div>

      <!-- 许可证冲突提示组件 -->
      <LicenseConflictAlert
        v-if="showConflictAlert"
        :is-visible="showConflictAlert"
        :conflicting-licenses="currentConflict.conflictingLicenses"
        :conflict-reason="currentConflict.reason"
        @close="closeConflictAlert"
        class="grid-full-width"
      />

      <!-- 许可证选项卡片 -->
      <div v-for="license in filteredLicenseOptions" 
           :key="license.id"
           class="license-card-wrapper">
        <LicenseCard 
          :license="license"
          :is-selected="selectedLicenses.includes(license.id)"
          :is-recommended="recommendedLicenses.includes(license.id)"
          :uploaded-files="getCardUploadedFiles(license.id)"
          :is-disabled="(props.selectedLicenses.includes('open') && license.id !== 'open') || 
                        (license.id === 'open' && (props.selectedLicenses.includes('commercial') || 
                                                props.selectedLicenses.includes('commercial-remix') || 
                                                props.selectedLicenses.includes('non-commercial')))"
          @select="selectLicense"
          @file-upload="handleFileUpload"
        />
      </div>
    </div>

    <!-- 自定义许可证标签页内容 -->
    <CustomLicenseTab
      v-else-if="activeTabIndex === 1 && !showMintCost && !showNonCommercialExpiration && !showLicenseExpiration && !showRemixPermission && !showCommercialRemixPermission && !showRevenueShare && !showAttribution && !showAttributionRequired && !showAITraining"
      :selected-licenses="selectedLicenses"
      :expanded-filters="expandedFilters"
      :filter-selections="filterSelections"
      :is-active="activeTabIndex === 1"
      @set-filter="setFilter"
      @toggle-filter="toggleFilter"
      @clear-filter="clearFilter"
      @license-option-conflict="handleOptionConflict"
      @validate-licensing-fee="handleLicensingFeeValidation"
      @validate-file-upload="handleFileUploadValidation"
      @file-upload="handleCustomFileUpload"
    />

    <!-- 添加自定义许可证上传文件按钮 -->
    
    <!-- 显示自定义许可证已上传文件 -->
    <div v-if="activeTabIndex === 1 && !showMintCost && !showNonCommercialExpiration && !showLicenseExpiration && !showRemixPermission && !showCommercialRemixPermission && !showRevenueShare && !showAttribution && !showAttributionRequired && !showAITraining && (filterSelections['commercial-use'] === 'yes' || (filterSelections['remixing'] === 'yes' && filterSelections['commercial-use'] === 'yes')) && customLicenseFilesValid" class="custom-files-container">
      <div class="custom-files-header">
        <h4>已上传原文件</h4>
        <div class="custom-files-info">商业使用和混合创新许可证使用的文件</div>
      </div>
      <div class="custom-files-list">
        <div class="custom-files-item" v-for="(file, index) in getCustomUploadedFiles()" :key="index">
          <div class="file-type-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
            </svg>
          </div>
          <div class="file-name-truncate">{{ file.name }}</div>
          <div class="file-size-info">{{ formatFileSize(file.size) }}</div>
        </div>
      </div>
    </div>

    <!-- 许可证助手标签页内容 -->
    <LicenseAssistantTab 
      v-else-if="activeTabIndex === 2 && !showMintCost && !showNonCommercialExpiration && !showLicenseExpiration && !showRemixPermission && !showCommercialRemixPermission && !showRevenueShare && !showAttribution && !showAttributionRequired && !showAITraining"
      @select-license="handleAssistantLicenseSelect"
      @navigate-to-expiration="navigateToExpiration"
      @navigate-to-commercial-expiration="navigateToCommercialExpiration"
      @navigate-to-mint="navigateToMint"
    />
    

    <!-- 底部导航按钮 -->
    <div class="navigation-section" v-if="!showNonCommercialExpiration && !showLicenseExpiration && !showRemixPermission && !showCommercialRemixPermission && !showRevenueShare && !showAttribution && !showAttributionRequired && !showAITraining && !showMintCost">
      <NavigationButtons 
        @back="goBack" 
        @next="goNext"
        :next-disabled="!hasValidLicenseSelection"
      />
    </div>

    <!-- 添加选项冲突模态窗口 -->
    <OptionConflictModal
      v-if="showOptionConflictModal"
      :conflict-data="optionConflictData"
      @close="closeOptionConflictModal"
    />

    <!-- 自动生成的许可类型提示 -->
    <div class="auto-license-message" v-if="activeTabIndex === 1 && hasAutoDetectedLicense">
      <div class="license-auto-detected">
        <span>当前选择等同于: <strong>{{ autoDetectedLicenseType }}</strong></span>
      </div>
    </div>

    <!-- 简化上传提示弹框 -->
    <div class="upload-prompt-modal" v-if="showUploadPrompt">
      <div class="upload-prompt-container">
        <div class="modal-content">
          <!-- 标题栏 -->
          <div class="modal-header">
            <h3>需要上传原文件</h3>
            <button class="close-button" @click="closeUploadPrompt">×</button>
          </div>
          
          <!-- 主要内容 -->
          <div class="modal-body">
            <div class="upload-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" class="icon">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                <polyline points="17 8 12 3 7 8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></polyline>
                <line x1="12" y1="3" x2="12" y2="15" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></line>
              </svg>
            </div>
            
            <p class="upload-message">商业使用或商业混音使用必须上传原文件</p>
            
            <div class="license-types">
              <div class="license-item">
                <div class="license-bar commercial"></div>
                <span>商业使用</span>
              </div>
              <div class="license-item">
                <div class="license-bar remix"></div>
                <span>商业混音</span>
              </div>
            </div>
          </div>
          
          <!-- 底部按钮 -->
          <div class="modal-footer">
            <button @click="closeUploadPrompt" class="confirm-button">我知道了</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 自定义确认对话框组件 -->
    <div class="custom-confirm-modal" v-if="showConfirmModal">
      <div class="custom-confirm-container">
        <div class="custom-confirm-content">
          {{ confirmModalMessage }}
          <div class="custom-confirm-buttons">
            <button @click="handleConfirmCancel" class="custom-confirm-cancel">取消</button>
            <button @click="handleConfirmOk" class="custom-confirm-ok">确定</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, defineComponent, PropType, onMounted, onUnmounted } from 'vue';
import NavigationButtons from '../../common/NavigationButtons.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import LicenseCard from '../license/LicenseCard.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import CustomLicenseTab from '../license/CustomLicenseTab.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import LicenseAssistantTab from '../license/LicenseAssistantTab.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import LicenseConflictAlert from '../license/LicenseConflictAlert.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import NonCommercialExpirationPage from '../license/NonCommercialExpirationPage.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import LicenseExpirationPage from '../license/LicenseExpirationPage.vue';
import OptionConflictModal from '../../modals/OptionConflictModal.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import RemixPermissionPage from '../license/RemixPermissionPage.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import CommercialRemixPermissionPage from '../license/CommercialRemixPermissionPage.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import AttributionRequiredPage from '../license/AttributionRequiredPage.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import AITrainingPage from '../license/AITrainingPage.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import MintLicensePage from '../license/MintLicensePage.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import RevenueSharePage from '../license/RevenueSharePage.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import AttributionPage from '../license/AttributionPage.vue';
// 导入上传区域组件
import UploadDropArea from '../license/UploadDropArea.vue';
// @ts-ignore - 模块存在但TypeScript找不到类型声明
import MintCostPage from '../license/MintCostPage.vue';

const emit = defineEmits(['navigate-back', 'navigate-next', 'license-update', 'license-conflict', 'license-select', 'navigate-to-commercial-pricing', 'navigate-to-commercial-remix-pricing', 'navigate-to-combined-pricing']);

// 错误提示状态
const showLicenseError = ref(false);
const showValidationError = ref(false);
const validationErrorMessage = ref('');  // 清空默认错误提示
const licenseFeesValid = ref(true);  // 许可费用验证状态

const props = defineProps({
  selectedLicenses: {
    type: Array as () => string[],
    default: () => []
  },
  assetType: {
    type: String,
    default: ''
  },
  workType: {
    type: String,
    default: ''
  }
});

// 显示非商业许可证到期日期页面的状态
const showNonCommercialExpiration = ref(false);
const currentLicenseType = ref('');

// 显示铸造许可证费用页面的状态
const showMintCost = ref(false);

// 显示商业许可证到期日期页面的状态
const showLicenseExpiration = ref(false);

// 显示混音许可选择页面的状态
const showRemixPermission = ref(false);

// 显示商业混音许可选择页面的状态
const showCommercialRemixPermission = ref(false);

// 显示收入分成页面的状态
const showRevenueShare = ref(false);

// 显示注明出处页面的状态
const showAttribution = ref(false);

// 显示归属要求选择页面的状态
const showAttributionRequired = ref(false);

// 显示AI训练选择页面的状态
const showAITraining = ref(false);

// 显示铸造许可证页面的状态
const showMintLicensePage = ref(false);
const selectedMintLicense = ref('');
const licensePrice = ref('');
const revenueShare = ref('0');

// 临时存储许可数据
const tempLicenseData = ref<{
  licenseId: string;
  expiration: string;
  allowRemix?: boolean;
  revenueShare?: string;
  requireAttribution?: boolean;
  aiTraining?: boolean;
}>({
  licenseId: '',
  expiration: ''
});

// 标签页数据
const tabs = [
  { id: 'preset', label: '预设许可证' },
  { id: 'custom', label: '自定义许可证' },
  { id: 'assistant', label: '许可证助手' }
];

// 当前选中的标签页
const activeTabIndex = ref(0);

// 记录展开的过滤器项
interface ExpandedFilters {
  'ai-training': boolean;
  'commercial-use': boolean;
  'attribution': boolean;
  'remixing': boolean;
  'expiration': boolean;
  'licensing-fee': boolean;
  [key: string]: boolean; // 添加索引签名，允许使用字符串索引
}

const expandedFilters = ref<ExpandedFilters>({
  'ai-training': false,
  'commercial-use': false,
  'attribution': false,
  'remixing': false,
  'expiration': false,
  'licensing-fee': false
});

// 过滤器选择状态
interface FilterSelections {
  'ai-training': string | null;
  'commercial-use': string | null;
  'attribution': string | null;
  'remixing': string | null;
  'expiration': string | null;
  'licensing-fee': string | null;
  [key: string]: string | null; // 添加索引签名，允许使用字符串索引
}

const filterSelections = ref<FilterSelections>({
  'ai-training': null,
  'commercial-use': null,
  'attribution': null,
  'remixing': null,
  'expiration': null,
  'licensing-fee': null
});

// 冲突提示状态
const showConflictAlert = ref(false);
const currentConflict = ref<{
  newLicense: string;
  conflictingLicenses: string[];
  reason: string;
}>({
  newLicense: '',
  conflictingLicenses: [],
  reason: ''
});

// 添加选项冲突模态窗口的状态
const showOptionConflictModal = ref(false);
const optionConflictData = ref({
  message: '',
  filterId: '',
  value: ''
});

// 添加上传原文件模态窗口的状态
const showUploadFileModal = ref(false);
const originalFiles = ref<File[]>([]);
const pendingLicenseId = ref('');

// 添加文件上传跟踪状态，修改为支持多文件
const uploadedFiles = ref<Record<string, File[]>>({
  'commercial': [],
  'commercial-remix': [],
  'non-commercial': [],
  'open': []
});

// 自定义许可证文件上传状态
const customLicenseFilesValid = ref(true);

// 添加showUploadArea变量仅为了兼容现有代码
const showUploadArea = ref(false);

// 添加上传文件提示弹框的状态
const showUploadPrompt = ref(false);

// 关闭上传提示弹框
const closeUploadPrompt = () => {
  showUploadPrompt.value = false;
};

// 导航到非商业许可证到期日期页面
const navigateToExpiration = (licenseType: string) => {
  currentLicenseType.value = licenseType;
  // 设置来源标签页，便于返回时导航回正确的页面
  sourceTab.value = tabs[activeTabIndex.value].id;
  showNonCommercialExpiration.value = true;
  // 保持当前标签页索引不变，但标签页内容已通过条件渲染被隐藏
};

// 处理到期日期选择
const handleExpirationSelect = (expirationType: string) => {
  // 处理到期日期选择
  console.log(`选择了到期类型: ${expirationType}, 许可类型: ${currentLicenseType.value}`);
  
  // 保存到期类型到临时数据
  tempLicenseData.value = {
    licenseId: currentLicenseType.value,
    expiration: expirationType
  };
  
  // 导航到混音许可页面
  showNonCommercialExpiration.value = false;
  showRemixPermission.value = true;
};

// 获取基于资产类型和作品类型的推荐许可证
const recommendedLicenses = computed(() => {
  // 根据资产类型返回推荐的许可证ID列表
  const recommendations: Record<string, string[]> = {
    // 视频资产推荐
    'video': ['commercial', 'commercial-remix'],
    // 图片资产推荐
    'image': ['open', 'non-commercial', 'commercial'],
    // 音频资产推荐
    'audio': ['commercial-remix', 'non-commercial'],
    // 文本资产推荐
    'text': ['open', 'non-commercial']
  };
  
  // 返回适合当前资产类型的推荐许可证，如果没有特定推荐则返回所有选项
  return props.assetType && recommendations[props.assetType] 
    ? recommendations[props.assetType] 
    : ['open', 'non-commercial', 'commercial', 'commercial-remix'];
});

// 预设许可证选项
const licenseOptions = [
  {
    id: 'open',
    name: '开放使用',
    description: '免费分发和混音，无限制、无收入要求、无归属要求',
    tagStyle: 'blue',
    tagIcon: 'ai',
    tagText: '限制最少',
    icons: ['document', 'free', 'remix', 'terms']
  },
  {
    id: 'non-commercial',
    name: '非商业混音',
    description: '任何人都可使用您的作品创建非商业项目',
    tagStyle: 'purple',
    tagIcon: '🏆',
    tagText: '为您的作品获得认可',
    icons: ['document', 'free', 'remix', 'terms']
  },
  {
    id: 'commercial',
    name: '商业使用',
    description: '允许他人按照您设定的经济条款使用您的作品',
    tagStyle: 'green',
    tagIcon: '💲',
    tagText: '为您的作品获得报酬',
    icons: ['document', 'paid', 'no-remix', 'terms']
  },
  {
    id: 'commercial-remix',
    name: '商业混音',
    description: '允许他人混音您的作品，同时您获得认可和收益',
    tagStyle: 'red',
    tagIcon: '💰',
    tagText: '获得报酬与认可',
    icons: ['document', 'paid', 'remix', 'terms']
  }
];

// 根据资产类型筛选出可用的许可证选项
const filteredLicenseOptions = computed(() => {
  // 始终显示所有许可证选项，不再根据资产类型筛选
  return licenseOptions;
});

// 切换标签页
const setActiveTab = (index: number) => {
  console.log(`Attempting to switch to tab ${index}`);
  
  // 如果当前显示的是特殊页面，先返回主标签页
  if (showMintCost.value || showNonCommercialExpiration.value || 
      showLicenseExpiration.value || showRemixPermission.value || 
      showCommercialRemixPermission.value || showRevenueShare.value || 
      showAttribution.value || showAttributionRequired.value || 
      showAITraining.value || showMintLicensePage.value) {
    
    // 对于来自许可证助手的特殊页面，如果要切换标签页，需要确认
    if (activeTabIndex.value === 2 && index !== 2) {
      const confirmMessage = '切换标签页将清除当前的许可证助手设置。是否继续？';
      
      showConfirm(confirmMessage, (result) => {
        if (result) {
          // 清除所有选择
          clearAllSelections();
          // 重置所有页面状态
          resetAllPageStates();
          // 更新标签页
          activeTabIndex.value = index;
        }
      });
      return;
    }
    
    // 如果不是从许可证助手切换到其他标签页，只需重置页面状态
    resetAllPageStates();
  }
  
  // Check if we're switching to a different tab
  if (activeTabIndex.value !== index) {
    // 检查是否需要确认切换
    let needsConfirmation = false;
    let confirmMessage = '';
    
    // 检查用户是否已经在当前标签页中做出了选择
    if (props.selectedLicenses.length > 0) {
      // 已经选择了预设许可证
      needsConfirmation = true;
      confirmMessage = '切换标签页将清除当前选择的所有许可证。是否继续？';
    } else if (activeTabIndex.value === 1 && isAnyCustomFilterSelected()) {
      // 在自定义许可证标签中做了选择，但可能还没有最终生成许可证
      needsConfirmation = true;
      confirmMessage = '切换标签页将清除当前的自定义许可证设置。是否继续？';
    } else if (activeTabIndex.value === 2) {
      // 检查许可证助手中是否真的有用户数据需要确认清除
      const hasUserData = hasAnyTempLicenseData();
      if (hasUserData) {
        needsConfirmation = true;
        confirmMessage = '切换标签页将清除当前的许可证助手设置。是否继续？';
      } else {
        // 如果许可证助手中没有实际的用户数据，直接切换无需确认
        needsConfirmation = false;
      }
    }
    
    // 如果需要确认
    if (needsConfirmation) {
      showConfirm(confirmMessage, (result) => {
        if (result) {
          // 清除所有选择
          clearAllSelections();
          // 更新标签页
          activeTabIndex.value = index;
        }
      });
    } else {
      // 没有需要确认的情况，直接切换
      activeTabIndex.value = index;
    }
    
    // 无论是否切换，都关闭冲突提示
    showConflictAlert.value = false;
  }
};

// 检查是否有任何自定义过滤器被选中
const isAnyCustomFilterSelected = () => {
  return Object.values(filterSelections.value).some(value => value !== null);
};

// 检查是否有任何临时许可证数据
const hasAnyTempLicenseData = () => {
  // 检查许可证助手是否有实际的用户输入或选择
  // 只有当真正有用户操作的数据时才返回true
  
  // 1. 检查是否有任何相关页面处于打开状态
  if (showMintCost.value || showNonCommercialExpiration.value || 
      showLicenseExpiration.value || showRemixPermission.value || 
      showCommercialRemixPermission.value || showRevenueShare.value || 
      showAttribution.value || showAttributionRequired.value || 
      showAITraining.value || showMintLicensePage.value) {
    return true;
  }
  
  // 2. 检查临时数据对象中是否有用户填写的数据
  if (tempLicenseData.value.licenseId !== '' || 
      tempLicenseData.value.expiration !== '' || 
      tempLicenseData.value.allowRemix !== undefined || 
      tempLicenseData.value.revenueShare !== undefined || 
      tempLicenseData.value.requireAttribution !== undefined || 
      tempLicenseData.value.aiTraining !== undefined) {
    return true;
  }
  
  // 如果只是设置了currentLicenseType但没有做其他操作，不视为有用户数据
  // 这样从许可证助手切换到其他标签页时，如果用户没有实际操作，就不会弹出确认对话框
  if (currentLicenseType.value !== '' && 
      tempLicenseData.value.licenseId === '' && 
      tempLicenseData.value.expiration === '' && 
      tempLicenseData.value.allowRemix === undefined && 
      tempLicenseData.value.revenueShare === undefined && 
      tempLicenseData.value.requireAttribution === undefined && 
      tempLicenseData.value.aiTraining === undefined) {
    return false;
  }
  
  return currentLicenseType.value !== '';
};

// 清除所有选择和状态
const clearAllSelections = () => {
  // 清除所有选择的许可证
  emit('license-update', []);
  
  // 清除所有上传的文件
  Object.keys(uploadedFiles.value).forEach(key => {
    uploadedFiles.value[key] = [];
  });
  
  // 重置自定义过滤器选择
  resetFilterSelections();
  
  // 重置临时许可证数据
  tempLicenseData.value = {
    licenseId: '',
    expiration: ''
  };
  
  // 重置所有展开的过滤器
  resetExpandedFilters();
  
  // 重置其他可能的状态
  showOptionConflictModal.value = false;
  pendingLicenseId.value = '';
  originalFiles.value = [];
};

// Reset filter selections
const resetFilterSelections = () => {
  filterSelections.value = {
    'ai-training': null,
    'commercial-use': null,
    'attribution': null,
    'remixing': null,
    'expiration': null,
    'licensing-fee': null
  };
};

// 切换过滤器项的展开/折叠状态
const toggleFilter = (filterId: string) => {
  if (filterId in expandedFilters.value) {
    expandedFilters.value[filterId] = !expandedFilters.value[filterId];
  }
};

// 设置过滤器选项
const setFilter = (filterId: string, value: string) => {
  if (filterId in filterSelections.value) {
    filterSelections.value[filterId] = value;
    
    // 当用户选择商业使用或者混合创新选项时，检查是否已有上传的文件
    if ((filterId === 'commercial-use' && value === 'yes') || 
        (filterId === 'remixing' && value === 'yes' && filterSelections.value['commercial-use'] === 'yes')) {
      
      // 检查是否存在通用的自定义许可证文件或商业许可证文件
      const hasCustomFile = typeof window !== 'undefined' && 
                          // @ts-ignore - 自定义窗口属性
                          window._customLicenseFiles && 
                          // @ts-ignore - 自定义窗口属性
                          window._customLicenseFiles.length > 0;
      
      const hasCommercialFile = uploadedFiles.value['commercial'] && 
                               uploadedFiles.value['commercial'].length > 0;
      
      const hasCommercialRemixFile = uploadedFiles.value['commercial-remix'] && 
                                  uploadedFiles.value['commercial-remix'].length > 0;
      
      // 如果没有任何一个文件，则将customLicenseFilesValid设置为false
      customLicenseFilesValid.value = hasCustomFile || hasCommercialFile || hasCommercialRemixFile;
      
      // 如果需要但没有文件，则显示验证错误
      if (!customLicenseFilesValid.value) {
        showValidationError.value = true;
        validationErrorMessage.value = '选择商业使用或混合创新时，必须上传原文件';
      } else {
        showValidationError.value = false;
      }
    }
  }
};

// 清除过滤器选项
const clearFilter = (filterId: string) => {
  if (filterId in filterSelections.value) {
    filterSelections.value[filterId] = null;
  }
};

// 添加直接打开系统文件选择器的方法
const openFileSelector = (licenseId: string) => {
  // 如果已经选择了开放使用许可证，且当前不是开放使用，阻止打开文件选择器
  if (props.selectedLicenses.includes('open') && licenseId !== 'open') {
    alert("已选择开放使用许可证，不能为其他许可证上传文件");
    return;
  }
  
  // 如果当前是开放使用许可证，但已经选择了其他三种许可证中的任何一种，阻止上传
  if (licenseId === 'open' && (
    props.selectedLicenses.includes('commercial') || 
    props.selectedLicenses.includes('commercial-remix') || 
    props.selectedLicenses.includes('non-commercial')
  )) {
    alert("已选择其他许可证类型，不能为开放使用许可证上传文件");
    return;
  }
  
  pendingLicenseId.value = licenseId;
  
  // 创建文件输入元素
  const fileInput = document.createElement('input');
  fileInput.type = 'file';
  fileInput.accept = '*/*';
  fileInput.style.display = 'none';
  fileInput.multiple = true; // 允许多选文件
  
  // 添加文件变更事件处理
  fileInput.onchange = (event) => {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const filesArray = Array.from(input.files) as File[];
      originalFiles.value = filesArray;
      handleOriginalFileUploaded(filesArray);
    }
  };
  
  // 添加到文档并触发点击
  document.body.appendChild(fileInput);
  fileInput.click();
  
  // 点击后移除元素
  setTimeout(() => {
    document.body.removeChild(fileInput);
  }, 1000);
};

// 修改选择许可证的方法，不再显示底部上传区域
const selectLicense = (licenseId: string) => {
  const licenseConflicts = checkLicenseConflicts(licenseId);
  const currentLicenses = [...props.selectedLicenses];
  
  if (currentLicenses.includes(licenseId)) {
    // 如果已选择，则移除
    const updatedLicenses = currentLicenses.filter(item => item !== licenseId);
    emit('license-update', updatedLicenses);
    // 移除许可证时也关闭冲突提示
    showConflictAlert.value = false;
    // 清除该许可证的上传文件状态
    uploadedFiles.value[licenseId] = [];
  } else {
    // 如果超过了最大选择数量（5个），显示提示
    if (currentLicenses.length >= 5) {
      alert('您最多可以选择5个许可证');
      return;
    }
    
    // 检查冲突
    if (licenseConflicts.hasConflict) {
      // 设置当前冲突数据
      currentConflict.value = {
        newLicense: licenseId,
        conflictingLicenses: licenseConflicts.conflictingLicenses,
        reason: licenseConflicts.reason
      };
      // 显示内联冲突提示
      showConflictAlert.value = true;
      // 同时发送冲突事件给父组件，用于可能的弹窗显示
      emit('license-conflict', licenseId, licenseConflicts.conflictingLicenses, licenseConflicts.reason);
      return;
    }
    
    // 无冲突，添加许可证
    const updatedLicenses = [...currentLicenses, licenseId];
    emit('license-update', updatedLicenses);
    
    // 检查是否需要同步文件上传状态
    // 如果添加的是商业使用或商业混音许可证
    if (licenseId === 'commercial' || licenseId === 'commercial-remix') {
      const otherLicenseId = licenseId === 'commercial' ? 'commercial-remix' : 'commercial';
      // 检查当前许可证和另一个许可证是否都被选中
      const willHaveBothLicenses = updatedLicenses.includes('commercial') && updatedLicenses.includes('commercial-remix');
      
      if (willHaveBothLicenses) {
        // 如果添加新许可证后，两个许可证都被选中
        // 检查另一个许可证是否已经有上传的文件
        if (uploadedFiles.value[otherLicenseId] && uploadedFiles.value[otherLicenseId].length > 0) {
          // 另一个许可证有文件，同步到当前许可证
          uploadedFiles.value[licenseId] = [...uploadedFiles.value[otherLicenseId]];
          console.log(`已将文件从 ${otherLicenseId} 同步到 ${licenseId}，共 ${uploadedFiles.value[otherLicenseId].length} 个文件`);
          
          // 同步保存到localStorage和window对象
          try {
            // 创建可以序列化的文件信息对象
            const fileInfos = uploadedFiles.value[otherLicenseId].map(file => ({
              name: file.name,
              size: file.size,
              type: file.type,
              lastModified: file.lastModified,
            }));
            
            // 保存到localStorage
            localStorage.setItem(`uploaded_files_${licenseId}`, JSON.stringify(fileInfos));
            
            // 在Window对象上也保存文件引用
            if (typeof window !== 'undefined') {
              // @ts-ignore
              window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
              // @ts-ignore
              window._uploadedLicenseFiles[licenseId] = uploadedFiles.value[otherLicenseId];
            }
          } catch (e) {
            console.error(`同步文件状态到 ${licenseId} 失败:`, e);
          }
        }
      }
    }
    
    // 添加成功时关闭冲突提示
    showConflictAlert.value = false;
  }
};

// 检查许可证冲突
const checkLicenseConflicts = (newLicense: string) => {
  const conflicts = {
    hasConflict: false,
    conflictingLicenses: [] as string[],
    reason: ''
  };
  
  // 开放使用与其他所有许可证互斥
  if (newLicense === 'open') {
    // 开放使用与其他所有许可证冲突
    const conflicting = props.selectedLicenses.filter(l => 
      ['commercial', 'commercial-remix', 'non-commercial'].includes(l)
    );
    
    if (conflicting.length > 0) {
      conflicts.hasConflict = true;
      conflicts.conflictingLicenses = conflicting;
      conflicts.reason = '开放使用（完全免费无限制）与其他许可证类型互斥，不能同时选择';
    }
  } 
  // 如果选择其他许可证时，已经有了开放使用许可证
  else if (props.selectedLicenses.includes('open')) {
    conflicts.hasConflict = true;
    conflicts.conflictingLicenses = ['open'];
    conflicts.reason = '其他许可证类型与开放使用（完全免费无限制）互斥，不能同时选择';
  }
  
  return conflicts;
};

// 关闭冲突提示
const closeConflictAlert = () => {
  showConflictAlert.value = false;
};

// 移除许可证
const removeLicense = (license: string) => {
  const updatedLicenses = props.selectedLicenses.filter(item => item !== license);
  emit('license-update', updatedLicenses);
  // 移除许可证时关闭冲突提示
  showConflictAlert.value = false;
};

// 获取许可证名称
const getLicenseName = (license: string) => {
  const licenseNames = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音'
  };
  return (licenseNames as any)[license] || license;
};

// 页面导航
const goBack = () => {
  resetExpandedFilters();
  emit('navigate-back');
};

// 根据自定义选择情况判断是否有有效的许可证
const hasValidLicenseSelection = computed(() => {
  // 如果已经选择了预设许可证，检查商业许可是否上传了文件
  if (hasSelectedLicenses.value) {
    // 检查是否选择了商业使用或商业混音许可证，并且必须上传了文件
    const commercialSelected = props.selectedLicenses.includes('commercial');
    const commercialRemixSelected = props.selectedLicenses.includes('commercial-remix');
    
    // 如果同时选择了商业使用和商业混音，只要任一个上传了文件即可
    if (commercialSelected && commercialRemixSelected) {
      const hasCommercialFiles = uploadedFiles.value['commercial'] && uploadedFiles.value['commercial'].length > 0;
      const hasCommercialRemixFiles = uploadedFiles.value['commercial-remix'] && uploadedFiles.value['commercial-remix'].length > 0;
      // 只要有一个上传了文件就可以继续
      if (!hasCommercialFiles && !hasCommercialRemixFiles) {
        return false; // 两者都没有上传文件
      }
    } else {
      // 单独选择检查
      if (commercialSelected && (!uploadedFiles.value['commercial'] || uploadedFiles.value['commercial'].length === 0)) {
        return false; // 选择了商业使用但没有上传文件
      }
      
      if (commercialRemixSelected && (!uploadedFiles.value['commercial-remix'] || uploadedFiles.value['commercial-remix'].length === 0)) {
        return false; // 选择了商业混音但没有上传文件
      }
    }
    
    return true; // 其他情况通过验证
  }
  
  // 如果在自定义许可证页面，检查是否有有效的自定义选择
  if (activeTabIndex.value === 1) {
    // 只有在选择了商业使用为'yes'时才检查许可费用
    if (filterSelections.value['commercial-use'] === 'yes' && !licenseFeesValid.value) {
      // 更新验证错误信息
      showValidationError.value = true;
      validationErrorMessage.value = '选择商业使用时，必须设置许可费用';
      return false;
    } 
    // 检查商业使用选项为'yes'时，检查是否上传了文件
    else if (filterSelections.value['commercial-use'] === 'yes' && !customLicenseFilesValid.value) {
      // 更新验证错误信息
      showValidationError.value = true;
      validationErrorMessage.value = '选择商业使用时，必须上传原文件';
      return false;
    }
    // 检查混合创新选项为'yes'时，检查是否上传了文件
    else if (filterSelections.value['remixing'] === 'yes' && 
             filterSelections.value['commercial-use'] === 'yes' && 
             !customLicenseFilesValid.value) {
      // 更新验证错误信息
      showValidationError.value = true;
      validationErrorMessage.value = '选择混合创新时，必须上传原文件';
      return false;
    }
    else if (hasValidCustomSelection.value) {
      // 对于其他情况，只要有选择即可
      showValidationError.value = false;
      return true;
    } else {
      // 没有有效的自定义选择
      return false;
    }
  }
  
  // 其他情况返回false
  return false;
});

// 修改validationMessages计算属性，加入自定义许可证文件验证
const validationMessages = computed(() => {
  const messages = [];
  
  // 检查商业使用和商业混音许可证的文件上传状态
  const commercialSelected = props.selectedLicenses.includes('commercial');
  const commercialRemixSelected = props.selectedLicenses.includes('commercial-remix');
  
  // 如果同时选择了商业使用和商业混音
  if (commercialSelected && commercialRemixSelected) {
    const hasCommercialFiles = uploadedFiles.value['commercial'] && uploadedFiles.value['commercial'].length > 0;
    const hasCommercialRemixFiles = uploadedFiles.value['commercial-remix'] && uploadedFiles.value['commercial-remix'].length > 0;
    
    // 只有当两个许可证都没有上传文件时，才显示错误信息
    if (!hasCommercialFiles && !hasCommercialRemixFiles) {
      messages.push('商业使用和商业混音许可证至少需要上传一个原文件才能继续');
    }
  } else {
    // 单独许可证检查
    if (commercialSelected && (!uploadedFiles.value['commercial'] || uploadedFiles.value['commercial'].length === 0)) {
      messages.push('商业使用许可证必须上传原文件才能继续');
    }
    
    if (commercialRemixSelected && (!uploadedFiles.value['commercial-remix'] || uploadedFiles.value['commercial-remix'].length === 0)) {
      messages.push('商业混音许可证必须上传原文件才能继续');
    }
  }
  
  // 自定义许可证验证
  if (activeTabIndex.value === 1) {
    if (filterSelections.value['commercial-use'] === 'yes' && !customLicenseFilesValid.value) {
      messages.push('选择商业使用时，必须上传原文件才能继续');
    }
    
    if (filterSelections.value['remixing'] === 'yes' && 
        filterSelections.value['commercial-use'] === 'yes' && 
        !customLicenseFilesValid.value) {
      messages.push('选择混合创新时，必须上传原文件才能继续');
    }
  }
  
  return messages;
});

// 修改goNext函数，使用弹框替代alert，并修改提示文本
const goNext = () => {
  // 检查文件上传状态
  const commercialSelected = props.selectedLicenses.includes('commercial');
  const commercialRemixSelected = props.selectedLicenses.includes('commercial-remix');
  
  // 检查是否有商业许可证未上传文件
  let needsFileUpload = false;
  
  // 如果同时选择了商业使用和商业混音
  if (commercialSelected && commercialRemixSelected) {
    const hasCommercialFiles = uploadedFiles.value['commercial'] && uploadedFiles.value['commercial'].length > 0;
    const hasCommercialRemixFiles = uploadedFiles.value['commercial-remix'] && uploadedFiles.value['commercial-remix'].length > 0;
    
    // 只有当两个许可证都没有上传文件时，才需要上传
    needsFileUpload = !hasCommercialFiles && !hasCommercialRemixFiles;
  } else {
    // 单独检查
    needsFileUpload = (commercialSelected && (!uploadedFiles.value['commercial'] || uploadedFiles.value['commercial'].length === 0)) || 
                    (commercialRemixSelected && (!uploadedFiles.value['commercial-remix'] || uploadedFiles.value['commercial-remix'].length === 0));
  }
  
  if (needsFileUpload) {
    // 显示上传提示弹框，但修改提示文本内容
    showUploadPrompt.value = true;
    return;
  }
  
  // 确保已上传的文件会被持久化保存
  persistUploadedFiles();
  
  // 保存当前选择的许可证数据
  
  // 如果是在自定义许可证页面，并且有有效的自定义选择
  if (activeTabIndex.value === 1 && hasValidCustomSelection.value) {
    // 将自定义选择转换为预设许可证
    addAutoDetectedLicense();
    
    // 等待许可证更新后再导航
    setTimeout(() => {
      navigateBasedOnLicenses();
    }, 100);
  } else {
    // 立即导航
    navigateBasedOnLicenses();
  }
};

// 确保上传的文件被持久化保存
const persistUploadedFiles = () => {
  // 检查是否同时选择了商业使用和商业混音
  const hasCommercial = props.selectedLicenses.includes('commercial');
  const hasCommercialRemix = props.selectedLicenses.includes('commercial-remix');
  
  // 如果同时选择了商业使用和商业混音，先同步文件
  if (hasCommercial && hasCommercialRemix) {
    // 检查哪个许可证有文件
    const commercialHasFiles = uploadedFiles.value['commercial'] && uploadedFiles.value['commercial'].length > 0;
    const commercialRemixHasFiles = uploadedFiles.value['commercial-remix'] && uploadedFiles.value['commercial-remix'].length > 0;
    
    // 同步文件
    if (commercialHasFiles && !commercialRemixHasFiles) {
      // 商业使用有文件，商业混音没有，从商业使用同步到商业混音
      uploadedFiles.value['commercial-remix'] = [...uploadedFiles.value['commercial']];
      console.log('从商业使用同步文件到商业混音');
    } else if (!commercialHasFiles && commercialRemixHasFiles) {
      // 商业混音有文件，商业使用没有，从商业混音同步到商业使用
      uploadedFiles.value['commercial'] = [...uploadedFiles.value['commercial-remix']];
      console.log('从商业混音同步文件到商业使用');
    }
  }
  
  // 遍历所有许可证类型
  Object.keys(uploadedFiles.value).forEach(licenseId => {
    const files = uploadedFiles.value[licenseId];
    if (files && files.length > 0) {
      try {
        // 保存到window对象
        if (typeof window !== 'undefined') {
          // @ts-ignore
          window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
          // @ts-ignore
          window._uploadedLicenseFiles[licenseId] = files;
          
          // 同时将元数据保存到localStorage
          const fileInfos = files.map(file => ({
            name: file.name,
            size: file.size,
            type: file.type,
            lastModified: file.lastModified,
          }));
          localStorage.setItem(`uploaded_files_${licenseId}`, JSON.stringify(fileInfos));
          
          console.log(`持久化保存 ${licenseId} 的文件状态，共 ${files.length} 个文件`);
        }
      } catch (e) {
        console.error(`持久化保存 ${licenseId} 的文件状态失败:`, e);
      }
    }
  });
};

// 根据选择的许可证决定导航目标
const navigateBasedOnLicenses = () => {
  emit('license-update', props.selectedLicenses);
  
  // 直接进入下一步，不需要再通过定价页面
  emit('navigate-next');
};

// 获取资产类型中文名称
const getAssetTypeChinese = computed(() => {
  const assetTypeNames: Record<string, string> = {
    'video': '视频',
    'image': '图片',
    'audio': '音频',
    'text': '文档'
  };
  return assetTypeNames[props.assetType] || props.assetType;
});

// 处理选项冲突
const handleOptionConflict = (conflictData: any) => {
  optionConflictData.value = conflictData;
  showOptionConflictModal.value = true;
};

// 关闭选项冲突模态窗口
const closeOptionConflictModal = () => {
  showOptionConflictModal.value = false;
};

// 处理原文件上传完成
const handleOriginalFileUploaded = (files: File[]) => {
  // 保存上传的文件
  originalFiles.value = files;
  console.log('上传的原文件:', files.length > 0 ? files[0].name : '无文件', '等', files.length, '个文件');
  
  // 如果有待处理的许可证ID，保存文件状态
  if (pendingLicenseId.value) {
    const licenseId = pendingLicenseId.value;
    
    // 保存上传的文件到对应的许可证
    uploadedFiles.value[licenseId] = files;
    
    // 发送选择事件
    emit('license-select', licenseId);
    
    // 重置变量
    pendingLicenseId.value = '';
    
    // 关闭上传区域
    showUploadArea.value = false;
    
    // 关闭冲突提示
    showConflictAlert.value = false;
  }
};

// 从许可证助手标签页导航到非商业许可证到期日期页面
const handleAssistantLicenseSelect = (licenseType: string) => {
  console.log(`从许可证助手选择了许可证: ${licenseType}`);
  // 处理许可证助手选择的许可证
  
  // 如果是商业许可证，则不处理，由LicenseAssistantTab自己处理
};

// 处理铸造许可证完成
const handleMintComplete = (data: { licenseType: string, mintPrice: string, expiration: string, files: File[] }) => {
  console.log(`铸造许可证完成: ${data.licenseType}, 价格: ${data.mintPrice}`);
  
  // 将许可证添加到选中列表
  const updatedLicenses = [...props.selectedLicenses, data.licenseType];
  
  // 保存上传的文件
  uploadedFiles.value[data.licenseType] = data.files;
  
  // 发出更新许可证事件
  emit('license-update', updatedLicenses);
  
  // 保存上传的文件信息到localStorage和window对象
  try {
    // 创建可以序列化的文件信息对象
    const fileInfos = data.files.map(file => ({
      name: file.name,
      size: file.size,
      type: file.type,
      lastModified: file.lastModified,
    }));
    
    // 保存到localStorage
    localStorage.setItem(`uploaded_files_${data.licenseType}`, JSON.stringify(fileInfos));
    
    // 在Window对象上也保存文件引用
    if (typeof window !== 'undefined') {
      // @ts-ignore - 添加到Window对象
      window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
      // @ts-ignore
      window._uploadedLicenseFiles[data.licenseType] = data.files;
    }
    
    console.log(`已保存 ${data.licenseType} 的文件状态，共 ${data.files.length} 个文件`);
  } catch (e) {
    console.error('保存文件状态失败:', e);
  }
  
  // 返回主页面
  showMintLicensePage.value = false;
};

// 从许可证助手导航到铸造页面
const navigateToMint = (licenseType: string) => {
  selectedMintLicense.value = licenseType;
  
  // 如果是商业许可证，设置相应的价格信息
  if (licenseType === 'commercial' || licenseType === 'commercial-remix') {
    // 这里可以设置默认价格或从其他地方获取
    licensePrice.value = '';
    revenueShare.value = licenseType === 'commercial-remix' ? '10' : '0';
  }
  
  // 显示铸造页面，隐藏其他页面
  showMintLicensePage.value = true;
  // 保持当前标签页索引不变，但标签页内容已通过条件渲染被隐藏
};

// 处理导航返回
const handleNavigateBack = (source: string = '') => {
  // 根据当前显示的页面状态，确定返回到哪一步
  if (showLicenseExpiration.value) {
    showLicenseExpiration.value = false;
    showMintCost.value = true;
    return;
  }
  
  if (showCommercialRemixPermission.value) {
    showCommercialRemixPermission.value = false;
    showLicenseExpiration.value = true;
    return;
  }
  
  if (showRevenueShare.value) {
    showRevenueShare.value = false;
    showCommercialRemixPermission.value = true;
    return;
  }
  
  if (showAttribution.value) {
    showAttribution.value = false;
    // 检查上一步是否是收入分成页面或商业混音页面
    if (tempLicenseData.value.allowRemix) {
      showRevenueShare.value = true;
    } else {
      showCommercialRemixPermission.value = true;
    }
    return;
  }
  
  if (showAttributionRequired.value) {
    showAttributionRequired.value = false;
    if (currentLicenseType.value === 'non-commercial') {
      showRemixPermission.value = true;
    } else {
      showAttribution.value = true;
    }
    return;
  }
  
  if (showAITraining.value) {
    showAITraining.value = false;
    showAttributionRequired.value = true;
    return;
  }
  
  if (showRemixPermission.value) {
    showRemixPermission.value = false;
    showNonCommercialExpiration.value = true;
    return;
  }
  
  if (showNonCommercialExpiration.value) {
    showNonCommercialExpiration.value = false;
    // 返回到主标签页
    resetTab();
    return;
  }
  
  if (showMintCost.value) {
    showMintCost.value = false;
    // 返回到主标签页
    resetTab();
    return;
  }
  
  if (showMintLicensePage.value) {
    showMintLicensePage.value = false;
    resetTab();
    return;
  }
  
  // 重置所有页面状态
  resetAllPageStates();
  
  // 如果传入了来源参数，优先使用它
  resetTab(source || sourceTab.value);
};

// 重置所有页面状态的辅助函数
const resetAllPageStates = () => {
  showNonCommercialExpiration.value = false;
  showMintCost.value = false;
  showLicenseExpiration.value = false;
  showRemixPermission.value = false;
  showCommercialRemixPermission.value = false;
  showRevenueShare.value = false;
  showAttribution.value = false;
  showAttributionRequired.value = false;
  showAITraining.value = false;
  showMintLicensePage.value = false;
};

// 重置标签页的辅助函数
const resetTab = (tabId: string = '') => {
  if (tabId === 'preset') {
    resetExpandedFilters();
    activeTabIndex.value = 0;
  } else if (tabId === 'custom') {
    activeTabIndex.value = 1;
  } else if (tabId === 'assistant') {
    activeTabIndex.value = 2;
  } else {
    // 默认返回预设标签页
    activeTabIndex.value = 0;
  }
};

// 设置源标签页
const sourceTab = ref('preset');

// 处理混音许可选择
const handleRemixSelect = (remixType: string) => {
  console.log('从混音许可收到选择:', remixType);
  
  // 确保licenseId已设置
  if (!tempLicenseData.value.licenseId) {
    tempLicenseData.value.licenseId = currentLicenseType.value;
  }
  
  // 更新临时数据，添加混音选项
  tempLicenseData.value.allowRemix = remixType === 'yes';
  
  // 导航到归属要求页面
  showRemixPermission.value = false;
  showAttributionRequired.value = true;
};

// 处理归属要求选择
const handleAttributionSelect = (attributionType: string) => {
  console.log('从归属要求收到选择:', attributionType);
  
  // 更新临时数据，添加归属要求选项
  tempLicenseData.value.requireAttribution = attributionType === 'yes';
  
  // 导航到AI训练页面
  showAttributionRequired.value = false;
  showAITraining.value = true;
};

// 处理AI训练选择
const handleAITrainingSelect = (aiTrainingType: string) => {
  console.log('从AI训练收到选择:', aiTrainingType);
  
  // 更新临时数据，添加AI训练选项
  tempLicenseData.value.aiTraining = aiTrainingType === 'yes';
  
  // 获取许可证ID
  const licenseId = tempLicenseData.value.licenseId;
  
  // 检查许可证冲突
  const licenseConflicts = checkLicenseConflicts(licenseId);
  
  if (licenseConflicts.hasConflict) {
    // 显示冲突信息
    currentConflict.value = {
      newLicense: licenseId,
      conflictingLicenses: licenseConflicts.conflictingLicenses,
      reason: licenseConflicts.reason
    };
    showConflictAlert.value = true;
    emit('license-conflict', licenseId, licenseConflicts.conflictingLicenses, licenseConflicts.reason);
  } else {
    // 无冲突，添加许可证
    const currentLicenses = [...props.selectedLicenses];
    if (!currentLicenses.includes(licenseId)) {
      const updatedLicenses = [...currentLicenses, licenseId];
      emit('license-update', updatedLicenses);
      
      // 如果是商业许可证，发送选择事件
      if (licenseId === 'commercial' || licenseId === 'commercial-remix') {
        emit('license-select', licenseId);
      }
    }
  }
  
  // 返回到源标签页
  showAITraining.value = false;
  handleNavigateBack(sourceTab.value);
};

// 自动检测的许可证类型
const autoDetectedLicenseType = computed(() => {
  // 只有当有基本的自定义选择时才进行匹配
  if (!hasValidCustomSelection.value) {
    return '开放使用'; // 默认返回开放使用
  }

  // 根据自定义设置自动匹配许可证类型
  const fs = filterSelections.value;
  
  // 优先匹配完全匹配的情况
  
  // 开放使用：允许商用且不需要署名
  if (fs['commercial-use'] === 'yes' && fs['attribution'] === 'no') {
    return '开放使用';
  }
  
  // 非商业混音：不允许商用、需要署名、允许混音
  if (fs['commercial-use'] === 'no' && fs['attribution'] === 'yes' && fs['remixing'] === 'yes') {
    return '非商业混音';
  }
  
  // 商业使用：允许商用、需要署名、不允许混音
  if (fs['commercial-use'] === 'yes' && fs['attribution'] === 'yes' && fs['remixing'] === 'no') {
    return '商业使用';
  }
  
  // 商业混音：允许商用、需要署名、允许混音
  if (fs['commercial-use'] === 'yes' && fs['attribution'] === 'yes' && fs['remixing'] === 'yes') {
    return '商业混音';
  }

  // 当无法完全匹配时，根据最重要特征匹配
  
  // 商业用途是最主要的判断标准
  if (fs['commercial-use'] === 'yes') {
    // 商业用途 + 允许混音 = 商业混音，否则 = 商业使用
    return fs['remixing'] === 'yes' ? '商业混音' : '商业使用';
  } else if (fs['commercial-use'] === 'no') {
    // 非商业用途 + 允许混音 = 非商业混音，否则 = 开放使用
    return fs['remixing'] === 'yes' ? '非商业混音' : '开放使用';
  }
  
  // 如果商业用途未设置，则根据混音和署名判断
  if (fs['remixing'] === 'yes') {
    return fs['attribution'] === 'yes' ? '非商业混音' : '开放使用';
  } else if (fs['remixing'] === 'no') {
    return fs['attribution'] === 'yes' ? '商业使用' : '开放使用';
  }
  
  // 最后的默认值是开放使用
  return '开放使用';
});

// 自动检测的许可证状态
const hasAutoDetectedLicense = computed(() => {
  // 只要有基本的自定义选择，就应该显示自动检测到的许可证类型
  return hasValidCustomSelection.value;
});

// 判断是否有已选择的许可证
const hasSelectedLicenses = computed(() => {
  return props.selectedLicenses.length > 0;
});

// 判断是否有有效的自定义选择
const hasValidCustomSelection = computed(() => {
  // 如果自定义选择页面不是当前页面，直接返回false
  if (activeTabIndex.value !== 1) return false;
  
  // 检查是否至少设置了商业使用、署名和混音这三个基本选项
  const fs = filterSelections.value;
  return fs['commercial-use'] !== null && 
         fs['attribution'] !== null && 
         fs['remixing'] !== null;
});

// 将自动检测的许可证添加到选择列表
const addAutoDetectedLicense = () => {
  // 将自动检测的许可证类型转换为许可证ID
  let licenseId = '';
  switch (autoDetectedLicenseType.value) {
    case '开放使用':
      licenseId = 'open';
      break;
    case '非商业混音':
      licenseId = 'non-commercial';
      break;
    case '商业使用':
      licenseId = 'commercial';
      break;
    case '商业混音':
      licenseId = 'commercial-remix';
      break;
    default:
      // 兜底方案，如果无法匹配则默认为开放使用
      licenseId = 'open';
      break;
  }
  
  // 只有有效的许可证ID才添加
  if (licenseId && !props.selectedLicenses.includes(licenseId)) {
    const updatedLicenses = [...props.selectedLicenses, licenseId];
    emit('license-update', updatedLicenses);
    
    console.log(`自动添加许可证: ${licenseId} (${autoDetectedLicenseType.value})`);
  }
};

// 处理许可证费用验证
const handleLicensingFeeValidation = (valid: boolean) => {
  licenseFeesValid.value = valid;
  
  // 如果是商业使用，根据许可费用验证状态更新错误提示
  if (filterSelections.value['commercial-use'] === 'yes') {
    if (valid) {
      // 许可费用有效，隐藏错误提示
      showValidationError.value = false;
    } else {
      // 许可费用无效，显示错误提示
      showValidationError.value = true;
      validationErrorMessage.value = '选择商业使用时，必须设置许可费用';
    }
  }
};

// 处理自定义许可证页面的文件上传
const handleCustomFileUpload = (fileData: { isCommercial: boolean, file: File }) => {
  console.log('收到自定义许可证文件上传:', fileData);
  // 根据商业/非商业使用情况，更新文件状态
  if (fileData.isCommercial) {
    customLicenseFilesValid.value = true;
  }
};

// 处理文件上传验证
const handleFileUploadValidation = (isValid: boolean) => {
  customLicenseFilesValid.value = isValid;
};

// 处理文件上传
const handleFileUpload = (fileData: { licenseId: string, file: File | File[] | null }) => {
  const { licenseId, file } = fileData;
  
  // 如果已经选择了开放使用许可证，且当前不是开放使用，阻止上传
  if (props.selectedLicenses.includes('open') && licenseId !== 'open') {
    alert("已选择开放使用许可证，不能为其他许可证上传文件");
    return;
  }
  
  // 如果当前是开放使用许可证，但已经选择了其他三种许可证中的任何一种，阻止上传
  if (licenseId === 'open' && (
    props.selectedLicenses.includes('commercial') || 
    props.selectedLicenses.includes('commercial-remix') || 
    props.selectedLicenses.includes('non-commercial')
  )) {
    alert("已选择其他许可证类型，不能为开放使用许可证上传文件");
    return;
  }
  
  // 确保文件是数组格式或者为null（删除情况）
  let files: File[] = [];
  if (file === null) {
    // 处理删除文件的情况 - 确保为空数组
    files = [];
  } else {
    files = Array.isArray(file) ? [...file] : [file];
  }
  
  // 如果是商业相关许可证，使用专门的更新函数处理
  if (licenseId === 'commercial' || licenseId === 'commercial-remix') {
    updateCommercialFiles(files);
  } else {
    // 非商业许可证，只更新自己的文件
    uploadedFiles.value[licenseId] = files;
    
    // 持久化保存到localStorage和window对象
    try {
      if (files.length > 0) {
        // 有文件时保存文件信息
        const fileInfos = files.map(file => ({
          name: file.name,
          size: file.size,
          type: file.type,
          lastModified: file.lastModified,
        }));
        
        // 保存到localStorage
        localStorage.setItem(`uploaded_files_${licenseId}`, JSON.stringify(fileInfos));
        
        // 在Window对象上也保存文件引用
        if (typeof window !== 'undefined') {
          // @ts-ignore
          window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
          // @ts-ignore
          window._uploadedLicenseFiles[licenseId] = [...files];
        }
      } else {
        // 删除文件时清除存储
        localStorage.removeItem(`uploaded_files_${licenseId}`);
        
        if (typeof window !== 'undefined') {
          // @ts-ignore
          window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
          // @ts-ignore
          window._uploadedLicenseFiles[licenseId] = [];
        }
      }
      
      console.log(`已处理 ${licenseId} 的文件状态，${files.length > 0 ? `共 ${files.length} 个文件` : '已清空'}`);
    } catch (e) {
      console.error('保存文件状态失败:', e);
    }
  }
  
  // 发送选择事件
  emit('license-select', licenseId);
};

// 添加页面加载时恢复文件状态的逻辑
onMounted(() => {
  // 尝试从localStorage或window对象恢复上传的文件
  restoreUploadedFiles();
});

// 恢复之前上传的文件
const restoreUploadedFiles = () => {
  // 许可证类型列表
  const licenseTypes = ['open', 'non-commercial', 'commercial', 'commercial-remix'];
  
  try {
    licenseTypes.forEach(licenseId => {
      // 首先尝试从window对象恢复实际文件
      // @ts-ignore
      const windowFiles = typeof window !== 'undefined' && window._uploadedLicenseFiles && window._uploadedLicenseFiles[licenseId];
      if (windowFiles && windowFiles.length > 0) {
        uploadedFiles.value[licenseId] = windowFiles;
        console.log(`从window对象恢复 ${licenseId} 的文件状态，共 ${windowFiles.length} 个文件`);
        return;
      }
      
      // 如果window对象中没有，则尝试从localStorage恢复文件信息（但无法恢复实际文件内容）
      const storedFileInfo = typeof localStorage !== 'undefined' && localStorage.getItem(`uploaded_files_${licenseId}`);
      if (storedFileInfo) {
        const fileInfos = JSON.parse(storedFileInfo);
        console.log(`找到 ${licenseId} 的文件信息，共 ${fileInfos.length} 个文件，但无法恢复实际文件内容`);
        // 这里只能恢复文件元数据，无法恢复实际文件内容
        // 如果文件内容不可用，可以选择提示用户重新上传
      }
    });
  } catch (e) {
    console.error('恢复文件状态失败:', e);
  }
};

// 导航到商业许可证到期日期页面
const navigateToCommercialExpiration = (licenseType: string) => {
  currentLicenseType.value = licenseType;
  // 设置来源标签页，便于返回时导航回正确的页面
  sourceTab.value = tabs[activeTabIndex.value].id;
  // 首先显示铸造许可证费用页面
  showMintCost.value = true;
  // 保持当前标签页索引不变，但标签页内容已通过条件渲染被隐藏
};

// 处理商业许可证到期日期选择
const handleCommercialExpirationSelect = (expirationType: string) => {
  // 处理到期日期选择
  console.log(`选择了商业许可到期类型: ${expirationType}, 许可类型: ${currentLicenseType.value}`);
  
  // 保存到期类型到临时数据
  tempLicenseData.value = {
    licenseId: currentLicenseType.value,
    expiration: expirationType
  };
  
  // 导航到商业混音许可页面
  showLicenseExpiration.value = false;
  showCommercialRemixPermission.value = true;
};

// 处理商业混音许可选择
const handleCommercialRemixSelect = (remixType: string, files?: File[]) => {
  console.log('从商业混音许可收到选择:', remixType, files ? `，上传了${files.length}个文件` : '');
  
  // 确保licenseId已设置
  if (!tempLicenseData.value.licenseId && currentLicenseType.value) {
    tempLicenseData.value.licenseId = currentLicenseType.value;
  }
  
  // 更新临时数据，添加混音选项
  tempLicenseData.value.allowRemix = remixType === 'yes';
  
  // 如果选择了是，并且上传了文件，保存文件
  if (remixType === 'yes' && files && files.length > 0) {
    // 更新商业混音许可证的文件
    uploadedFiles.value['commercial-remix'] = files;
    
    // 保存上传的文件信息到localStorage和window对象
    try {
      // 创建可以序列化的文件信息对象
      const fileInfos = files.map(file => ({
        name: file.name,
        size: file.size,
        type: file.type,
        lastModified: file.lastModified,
      }));
      
      // 保存到localStorage
      localStorage.setItem('uploaded_files_commercial-remix', JSON.stringify(fileInfos));
      
      // 在Window对象上也保存文件引用
      if (typeof window !== 'undefined') {
        // @ts-ignore
        window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
        // @ts-ignore
        window._uploadedLicenseFiles['commercial-remix'] = files;
      }
      
      console.log(`已保存商业混音许可证的文件状态，共 ${files.length} 个文件`);
    } catch (e) {
      console.error('保存商业混音文件状态失败:', e);
    }
  }
  
  // 如果选择了是，导航到收入分成页面，否则直接到注明出处页面
  showCommercialRemixPermission.value = false;
  
  if (remixType === 'yes') {
    showRevenueShare.value = true;
  } else {
    // 如果选择不允许混音，跳过收入分成步骤
    showAttribution.value = true;
  }
};

// 处理收入分成选择
const handleRevenueShareSelect = (revenueShare: string) => {
  console.log('从收入分成收到选择:', revenueShare);
  
  // 更新临时数据，添加收入分成选项
  tempLicenseData.value.revenueShare = revenueShare;
  
  // 导航到注明出处页面
  showRevenueShare.value = false;
  showAttribution.value = true;
};

// 处理注明出处选择
const handleAttributionPageSelect = (attributionType: string) => {
  console.log('从注明出处收到选择:', attributionType);
  
  // 更新临时数据，添加注明出处选项
  tempLicenseData.value.requireAttribution = attributionType === 'yes';
  
  // 导航到归属要求页面
  showAttribution.value = false;
  showAttributionRequired.value = true;
};

// 处理铸造许可证费用选择
const handleMintCostSelect = (cost: string, files?: File[]) => {
  // 保存铸造许可证费用
  licensePrice.value = cost;
  
  // 如果提供了文件，保存上传的文件
  if (files && files.length > 0) {
    // 如果是商业相关许可证，使用专门的更新函数处理
    if (currentLicenseType.value === 'commercial' || currentLicenseType.value === 'commercial-remix') {
      updateCommercialFiles([...files]);
    } else {
      // 非商业许可证，只更新自己的文件
      uploadedFiles.value[currentLicenseType.value] = [...files];
      
      // 保存文件到localStorage和window对象
      try {
        // 创建可以序列化的文件信息对象
        const fileInfos = files.map(file => ({
          name: file.name,
          size: file.size,
          type: file.type,
          lastModified: file.lastModified,
        }));
        
        // 保存到localStorage
        localStorage.setItem(`uploaded_files_${currentLicenseType.value}`, JSON.stringify(fileInfos));
        
        // 在Window对象上也保存文件引用
        if (typeof window !== 'undefined') {
          // @ts-ignore
          window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
          // @ts-ignore
          window._uploadedLicenseFiles[currentLicenseType.value] = [...files];
        }
        
        console.log(`已保存 ${currentLicenseType.value} 的文件状态，共 ${files.length} 个文件`);
      } catch (e) {
        console.error('保存文件状态失败:', e);
      }
    }
  }
  
  // 关闭费用页面，显示过期日期页面
  showMintCost.value = false;
  showLicenseExpiration.value = true;
  
  // 更新临时数据，记录费用信息
  if (!tempLicenseData.value.licenseId) {
    tempLicenseData.value.licenseId = currentLicenseType.value;
  }
  tempLicenseData.value.expiration = ''; // 将在LicenseExpirationPage中设置
};

// 计算属性：是否选择了任何商业许可证（商业使用或商业混音）
const hasCommercialLicensesSelected = computed(() => {
  return props.selectedLicenses.includes('commercial') || props.selectedLicenses.includes('commercial-remix');
});

// 计算属性：是否上传了商业许可证的文件
const hasUploadedCommercialFiles = computed(() => {
  const hasCommercialFiles = uploadedFiles.value['commercial'] && uploadedFiles.value['commercial'].length > 0;
  const hasCommercialRemixFiles = uploadedFiles.value['commercial-remix'] && uploadedFiles.value['commercial-remix'].length > 0;
  return hasCommercialFiles || hasCommercialRemixFiles;
});

// 计算属性：获取用于显示的商业文件（使用商业使用或商业混音的文件，两者应该是同步的）
const commercialFiles = computed(() => {
  // 优先使用商业使用的文件
  if (uploadedFiles.value['commercial'] && uploadedFiles.value['commercial'].length > 0) {
    return uploadedFiles.value['commercial'];
  }
  // 否则使用商业混音的文件
  else if (uploadedFiles.value['commercial-remix'] && uploadedFiles.value['commercial-remix'].length > 0) {
    return uploadedFiles.value['commercial-remix'];
  }
  // 如果都没有，返回空数组
  return [];
});

// 打开商业文件选择器
const openCommercialFileSelector = () => {
  // 如果已经选择了开放使用许可证，阻止打开文件选择器
  if (props.selectedLicenses.includes('open')) {
    alert("已选择开放使用许可证，不能为其他许可证上传文件");
    return;
  }
  
  // 创建文件输入元素
  const fileInput = document.createElement('input');
  fileInput.type = 'file';
  fileInput.accept = '*/*';
  fileInput.style.display = 'none';
  fileInput.multiple = true; // 允许多选文件
  
  // 添加文件变更事件处理
  fileInput.onchange = (event) => {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const filesArray = Array.from(input.files) as File[];
      
      // 同时更新商业使用和商业混音的文件
      updateCommercialFiles(filesArray);
    }
  };
  
  // 添加到文档并触发点击
  document.body.appendChild(fileInput);
  fileInput.click();
  
  // 点击后移除元素
  setTimeout(() => {
    document.body.removeChild(fileInput);
  }, 1000);
};

// 更新商业文件（同时更新商业使用和商业混音）
const updateCommercialFiles = (files: File[]) => {
  // 同时更新两种商业许可证的文件
  uploadedFiles.value['commercial'] = [...files];
  uploadedFiles.value['commercial-remix'] = [...files];
  
  // 持久化保存到localStorage和window对象
  try {
    if (files.length === 0) {
      // 如果没有文件，清除存储
      localStorage.removeItem('uploaded_files_commercial');
      localStorage.removeItem('uploaded_files_commercial-remix');
      
      if (typeof window !== 'undefined') {
        // @ts-ignore
        window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
        // @ts-ignore
        window._uploadedLicenseFiles['commercial'] = [];
        // @ts-ignore
        window._uploadedLicenseFiles['commercial-remix'] = [];
      }
      
      console.log('已清除商业许可证文件');
    } else {
      const fileInfos = files.map(file => ({
        name: file.name,
        size: file.size,
        type: file.type,
        lastModified: file.lastModified,
      }));
      
      // 保存到localStorage
      localStorage.setItem('uploaded_files_commercial', JSON.stringify(fileInfos));
      localStorage.setItem('uploaded_files_commercial-remix', JSON.stringify(fileInfos));
      
      // 保存到window对象
      if (typeof window !== 'undefined') {
        // @ts-ignore
        window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
        // @ts-ignore
        window._uploadedLicenseFiles['commercial'] = [...files];
        // @ts-ignore
        window._uploadedLicenseFiles['commercial-remix'] = [...files];
        
        // 设置同步标记
        // @ts-ignore
        window._shouldSyncCommercialFiles = true;
      }
      
      console.log(`已更新商业许可证文件，共 ${files.length} 个文件`);
    }
  } catch (e) {
    console.error('保存商业文件状态失败:', e);
  }
};

// 删除共享文件
const deleteSharedFile = (index: number) => {
  // 获取当前文件列表
  const currentFiles = [...commercialFiles.value];
  
  // 删除指定索引的文件
  currentFiles.splice(index, 1);
  
  // 确保如果删除了所有文件，currentFiles为空数组而不是undefined或null
  const filesToUpdate = currentFiles.length > 0 ? currentFiles : [];
  
  // 更新商业文件
  updateCommercialFiles(filesToUpdate);
};

// 格式化文件大小
const formatFileSize = (bytes: number): string => {
  if (bytes < 1024) {
    return `${bytes} B`;
  } else if (bytes < 1024 * 1024) {
    return `${(bytes / 1024).toFixed(1)} KB`;
  } else if (bytes < 1024 * 1024 * 1024) {
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  } else {
    return `${(bytes / (1024 * 1024 * 1024)).toFixed(1)} GB`;
  }
};

// 获取用于显示的商业文件
const getCardUploadedFiles = (licenseId: string) => {
  // 如果是商业使用或商业混音许可证，始终确保两者显示相同的文件
  if (licenseId === 'commercial' || licenseId === 'commercial-remix') {
    const commercialFiles = uploadedFiles.value['commercial'] || [];
    const commercialRemixFiles = uploadedFiles.value['commercial-remix'] || [];
    
    // 优先返回非空的文件列表
    if (commercialFiles.length > 0) {
      return commercialFiles;
    } else if (commercialRemixFiles.length > 0) {
      return commercialRemixFiles;
    }
    return [];
  }
  
  // 其他许可证类型，返回自己的文件
  return uploadedFiles.value[licenseId] || [];
};

// 添加选择或取消选择的方法

// 重置所有展开的过滤器状态为false
const resetExpandedFilters = () => {
  Object.keys(expandedFilters.value).forEach(key => {
    expandedFilters.value[key] = false;
  });
  // 切换标签页时关闭冲突提示
  showConflictAlert.value = false;
};

// 页面导航
const debugTabClick = (event: MouseEvent) => {
  console.log('Tab container clicked:', event.target);
};

// 确认对话框状态
const showConfirmModal = ref(false);
const confirmModalMessage = ref('');
const confirmCallback = ref<((result: boolean) => void) | null>(null);

// 显示确认对话框
const showConfirm = (message: string, callback: (result: boolean) => void) => {
  confirmModalMessage.value = message;
  confirmCallback.value = callback;
  showConfirmModal.value = true;
};

// 确认对话框按钮处理
const handleConfirmOk = () => {
  showConfirmModal.value = false;
  if (confirmCallback.value) {
    confirmCallback.value(true);
  }
};

const handleConfirmCancel = () => {
  showConfirmModal.value = false;
  if (confirmCallback.value) {
    confirmCallback.value(false);
  }
};

// 添加上传自定义许可证文件的方法
const uploadCustomLicenseFile = () => {
  // 创建文件输入元素
  const fileInput = document.createElement('input');
  fileInput.type = 'file';
  fileInput.accept = '*/*';
  fileInput.style.display = 'none';
  fileInput.multiple = true; // 允许多选文件
  
  // 添加文件变更事件处理
  fileInput.onchange = (event) => {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const filesArray = Array.from(input.files) as File[];
      
      // 保存自定义许可证文件
      // @ts-ignore - 自定义窗口属性
      window._customLicenseFiles = filesArray;
      
      // 更新验证状态
      customLicenseFilesValid.value = true;
      showValidationError.value = false;
      
      // 如果选择了商业使用的自定义许可证，同时更新商业许可证文件
      if (filterSelections.value['commercial-use'] === 'yes') {
        uploadedFiles.value['commercial'] = filesArray;
        
        // 如果选择了混合创新，同时更新商业混音许可证文件
        if (filterSelections.value['remixing'] === 'yes') {
          uploadedFiles.value['commercial-remix'] = filesArray;
        }
        
        // 保存到localStorage和window对象，以便其他地方使用
        try {
          // 创建可以序列化的文件信息对象
          const fileInfos = filesArray.map(file => ({
            name: file.name,
            size: file.size,
            type: file.type,
            lastModified: file.lastModified,
          }));
          
          // 保存到localStorage
          localStorage.setItem('uploaded_files_commercial', JSON.stringify(fileInfos));
          localStorage.setItem('uploaded_files_commercial-remix', JSON.stringify(fileInfos));
          
          // 保存到window对象
          if (typeof window !== 'undefined') {
            // @ts-ignore
            window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
            // @ts-ignore
            window._uploadedLicenseFiles['commercial'] = [...filesArray];
            // @ts-ignore
            window._uploadedLicenseFiles['commercial-remix'] = [...filesArray];
          }
          
          console.log(`已上传自定义许可证文件，共 ${filesArray.length} 个文件`);
        } catch (e) {
          console.error('保存自定义许可证文件状态失败:', e);
        }
      }
    }
  };
  
  // 添加到文档并触发点击
  document.body.appendChild(fileInput);
  fileInput.click();
  
  // 点击后移除元素
  setTimeout(() => {
    document.body.removeChild(fileInput);
  }, 1000);
};

// 获取自定义许可证上传的文件
const getCustomUploadedFiles = () => {
  // 优先从window._customLicenseFiles获取
  // @ts-ignore - 自定义窗口属性
  if (typeof window !== 'undefined' && window._customLicenseFiles && window._customLicenseFiles.length > 0) {
    // @ts-ignore - 自定义窗口属性
    return window._customLicenseFiles;
  }
  
  // 然后检查商业使用和商业混音许可证的文件
  if (uploadedFiles.value['commercial'] && uploadedFiles.value['commercial'].length > 0) {
    return uploadedFiles.value['commercial'];
  }
  
  if (uploadedFiles.value['commercial-remix'] && uploadedFiles.value['commercial-remix'].length > 0) {
    return uploadedFiles.value['commercial-remix'];
  }
  
  // 如果都没有，返回空数组
  return [];
};
</script>

<style scoped>
/* 保持现有样式不变 */
.license-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

/* 修改虚线上传区域的样式，让其在适当位置显示 */
.upload-drop-area {
  border: 2px dashed rgba(255, 255, 255, 0.3);
  border-radius: 12px;
  padding: 30px 20px;
  margin: 20px auto;
  width: 100%;
  max-width: 500px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 15px;
  background-color: rgba(0, 0, 0, 0.15);
  position: relative; /* 添加相对定位，用于放置关闭按钮 */
  z-index: 10; /* 确保上传区域在其他元素之上 */
}

.upload-drop-area:hover {
  background-color: rgba(0, 0, 0, 0.25);
  border-color: rgba(255, 255, 255, 0.5);
}

.upload-drop-area.drag-active {
  background-color: rgba(0, 0, 0, 0.3);
  border-color: rgba(255, 255, 255, 0.6);
}

/* 删除强制上传的高亮边框 */
.upload-drop-area.mandatory {
  border-color: rgba(255, 255, 255, 0.3);
}

.upload-drop-area .upload-icon {
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.upload-drop-area .upload-icon svg {
  width: 40px;
  height: 40px;
}

.upload-drop-area .upload-text {
  color: rgba(255, 255, 255, 0.8);
  font-size: 15px;
}

.upload-drop-area .upload-description {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-top: 5px;
}

.header {
  text-align: center;
  margin-bottom: 30px;
}

.header h1 {
  font-size: 32px;
  margin-bottom: 8px;
  color: #ffffff;
}

.subtitle-zh {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
}

.tabs {
  display: flex;
  width: 100%;
  max-width: 600px;
  margin-bottom: 40px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  overflow: hidden;
  position: relative;
  z-index: 50;
  overflow: visible;
}

.tab {
  flex: 1;
  padding: 15px 10px;
  text-align: center;
  color: rgba(255, 255, 255, 0.8);
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
  background: transparent;
  border: none;
  font-family: inherit;
  position: relative;
  z-index: 51;
  pointer-events: auto;
}

.tab.active {
  background: rgba(255, 255, 255, 0.25);
  color: white;
  font-weight: 500;
}

.tab:hover:not(.active) {
  background: rgba(255, 255, 255, 0.15);
}

.license-options {
  width: 100%;
  max-width: 900px;
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 30px;
  align-items: start; /* 确保每个卡片从顶部对齐 */
  grid-auto-rows: min-content; /* 让每行高度自适应内容 */
}

/* 确保网格中的项目保持独立 */
.license-card-wrapper {
  display: flex;
  flex-direction: column;
  height: auto;
  position: relative;
  break-inside: avoid;
  contain: layout; /* 确保布局隔离 */
}

/* 确保卡片内部的上传区域不会溢出影响布局 */
.file-upload-container {
  margin-top: 10px;
  animation: slideDown 0.3s ease forwards;
  max-height: 300px; /* 设置最大高度，防止内容过多时影响布局 */
  overflow: hidden;
  width: 100%;
  border-radius: 8px;
}

.grid-full-width {
  grid-column: 1 / -1;
  margin-bottom: 10px;
}

.selected-licenses-header {
  grid-column: 1 / -1;
  background: rgba(255, 255, 255, 0.08);
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 10px;
}

.selected-licenses-header h3 {
  font-size: 16px;
  margin-bottom: 12px;
  font-weight: 500;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: rgba(255, 255, 255, 0.9);
}

.license-count {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.no-licenses {
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
  font-size: 14px;
}

.selected-license-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.selected-license-tag {
  background: rgba(255, 255, 255, 0.2);
  padding: 6px 12px;
  border-radius: 30px;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.remove-tag {
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 12px;
  transition: all 0.2s;
}

.remove-tag:hover {
  background: rgba(255, 0, 0, 0.5);
}

@media (max-width: 768px) {
  .license-options {
    grid-template-columns: 1fr;
  }
}

/* 添加导航和错误信息的样式 */
.navigation-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  margin-top: 30px;
}

.license-error-message {
  color: #ff4757;
  background-color: rgba(255, 71, 87, 0.1);
  border: 1px solid rgba(255, 71, 87, 0.3);
  border-radius: 6px;
  padding: 10px 15px;
  font-size: 14px;
  margin-bottom: 15px;
  text-align: center;
  width: 100%;
  max-width: 500px;
  animation: pulse 2s infinite;
}

/* 许可证验证错误的样式 */
.license-validation-error {
  display: none; /* 隐藏验证错误提示 */
}

.validation-message {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #e74c3c;
  font-weight: 500;
}

.warning-icon {
  flex-shrink: 0;
  width: 20px;
  height: 20px;
  stroke: #e74c3c;
}

/* 上传按钮样式 */
.upload-now-btn {
  display: none; /* 隐藏上传按钮 */
}

/* 删除底部上传区域样式 */
.upload-area-container {
  display: none; /* 隐藏上传区域容器 */
}

/* 为主上传区域添加容器样式 */
.upload-area-container {
  width: 100%;
  position: relative;
  margin: 20px 0;
  display: flex;
  justify-content: center;
}

/* 特定许可证样式 */
.license-open {
  background-color: rgba(40, 167, 69, 0.1);
  border-left: 3px solid #28a745;
}

.license-non-commercial {
  background-color: rgba(255, 255, 255, 0.1);
  border-left: 3px solid #ffffff;
}

.license-commercial {
  background-color: rgba(220, 53, 69, 0.1);
  border-left: 3px solid #dc3545;
}

.license-commercial-remix {
  background-color: rgba(255, 193, 7, 0.1);
  border-left: 3px solid #ffc107;
}

/* 简化的上传提示弹框样式 */
.upload-prompt-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.75);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  animation: fadeIn 0.3s ease;
  backdrop-filter: blur(5px);
}

.upload-prompt-container {
  width: 90%;
  max-width: 400px;
}

.modal-content {
  background-color: #1e1e22;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 25px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background-color: #272730;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 500;
  color: white;
}

.close-button {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  font-size: 20px;
  cursor: pointer;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.close-button:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.modal-body {
  padding: 25px 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

.upload-icon {
  width: 56px;
  height: 56px;
  background-color: rgba(45, 212, 191, 0.1);
  color: rgb(45, 212, 191);
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.upload-icon .icon {
  width: 28px;
  height: 28px;
}

.upload-message {
  color: rgba(255, 255, 255, 0.9);
  text-align: center;
  font-size: 15px;
  line-height: 1.5;
  margin: 0;
}

.license-types {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 12px;
  background-color: rgba(0, 0, 0, 0.2);
  padding: 16px;
  border-radius: 10px;
}

.license-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.license-bar {
  height: 8px;
  width: 100px;
  border-radius: 4px;
}

.license-bar.commercial {
  background-color: rgb(45, 212, 191);
}

.license-bar.remix {
  background-color: rgb(34, 211, 238);
}

.license-item span {
  color: rgba(255, 255, 255, 0.85);
  font-size: 14px;
}

.modal-footer {
  padding: 16px 20px;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.confirm-button {
  padding: 8px 20px;
  background-color: rgb(45, 212, 191);
  color: #0f172a;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.confirm-button:hover {
  background-color: rgb(20, 184, 166);
  transform: translateY(-2px);
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* 共享文件区域样式 */
.shared-files-container {
  background: rgba(30, 30, 40, 0.5);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
  border: 1px solid rgba(74, 144, 226, 0.3);
}

.shared-files-header {
  margin-bottom: 15px;
}

.shared-files-header h4 {
  font-size: 16px;
  font-weight: 500;
  margin: 0 0 5px 0;
  color: rgba(255, 255, 255, 0.9);
}

.shared-files-info {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
}

.shared-files-list {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.shared-file-item {
  background: rgba(40, 40, 50, 0.5);
  border-radius: 8px;
  padding: 10px 12px;
  display: flex;
  align-items: center;
  position: relative;
  min-width: 180px;
  max-width: 300px;
  flex: 1;
}

.shared-file-item .file-type-icon {
  color: rgba(74, 144, 226, 0.8);
  margin-right: 10px;
  flex-shrink: 0;
}

.shared-file-item .file-name-truncate {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
}

.shared-file-item .file-size-info {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-left: 10px;
  flex-shrink: 0;
}

.shared-file-delete-btn {
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  margin-left: 8px;
  transition: all 0.2s;
  flex-shrink: 0;
}

.shared-file-delete-btn:hover {
  background: rgba(255, 80, 80, 0.3);
  transform: scale(1.1);
}

.shared-add-files-btn {
  background: rgba(74, 144, 226, 0.15);
  color: rgba(74, 144, 226, 0.9);
  border-radius: 8px;
  padding: 10px 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  cursor: pointer;
  transition: all 0.2s;
  min-width: 150px;
}

.shared-add-files-btn:hover {
  background: rgba(74, 144, 226, 0.25);
  transform: translateY(-2px);
}

/* 自定义确认对话框样式 */
.custom-confirm-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  backdrop-filter: blur(3px);
}

.custom-confirm-container {
  width: 90%;
  max-width: 420px;
}

.custom-confirm-content {
  background-color: #1a1a1f;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
  padding: 20px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  text-align: center;
  line-height: 1.6;
}

.custom-confirm-buttons {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 20px;
}

.custom-confirm-buttons button {
  padding: 8px 22px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
}

.custom-confirm-cancel {
  background-color: #333338;
  color: rgba(255, 255, 255, 0.8);
}

.custom-confirm-cancel:hover {
  background-color: #3d3d44;
}

.custom-confirm-ok {
  background-color: #0077ff;
  color: white;
}

.custom-confirm-ok:hover {
  background-color: #0066e0;
}

/* 自定义许可证上传文件按钮样式 */
.custom-upload-button-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.custom-upload-button {
  background-color: rgba(74, 144, 226, 0.15);
  color: rgba(74, 144, 226, 0.9);
  border: none;
  border-radius: 8px;
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 8px;
}

.custom-upload-button:hover {
  background-color: rgba(74, 144, 226, 0.25);
  transform: translateY(-2px);
}

.custom-upload-button svg {
  width: 16px;
  height: 16px;
}

/* 已上传文件显示区域样式 */
.custom-files-container {
  margin-top: 20px;
  background-color: rgba(74, 144, 226, 0.05);
  border-radius: 8px;
  padding: 15px;
}

.custom-files-header {
  margin-bottom: 12px;
}

.custom-files-header h4 {
  margin: 0;
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.custom-files-info {
  font-size: 12px;
  color: #666;
  margin-top: 4px;
}

.custom-files-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.custom-files-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background-color: white;
  border-radius: 6px;
  border: 1px solid #eee;
}

.file-type-icon {
  color: #4a90e2;
}

.file-name-truncate {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 14px;
}

.file-size-info {
  font-size: 12px;
  color: #888;
}

.custom-add-files-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px;
  background-color: white;
  border: 1px dashed #ccc;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  margin-top: 8px;
  color: #4a90e2;
}

.custom-add-files-btn:hover {
  background-color: rgba(74, 144, 226, 0.05);
  border-color: #4a90e2;
}

/* 自定义许可证上传文件按钮样式 */
.custom-upload-button-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.custom-upload-button {
  background-color: rgba(74, 144, 226, 0.15);
  color: rgba(74, 144, 226, 0.9);
  border: none;
  border-radius: 8px;
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 8px;
}

.custom-upload-button:hover {
  background-color: rgba(74, 144, 226, 0.25);
  transform: translateY(-2px);
}

.custom-upload-button svg {
  width: 16px;
  height: 16px;
}
</style> 