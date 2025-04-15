<template>
  <div class="ai-permissions-container">
    <div class="ai-permissions-header">
      <h1 class="ai-title-main">AI权限设置</h1>
      <p class="ai-subtitle-zh">控制您的 IP 是否包含在 AI 训练计划中</p>
    </div>
    
    <div class="permission-card">
      <!-- 开放使用许可证 -->
      <div class="permission-row" v-if="shouldShowLicenseOption('open')">
        <div class="permission-icon">
          <div class="icon-container purple">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="8" y1="12" x2="16" y2="12"></line>
              <line x1="12" y1="8" x2="12" y2="16"></line>
            </svg>
          </div>
        </div>
        <div class="permission-label">
          <span>开放使用</span>
          <div class="permission-description">允许您的作品无限制地被AI系统学习与使用</div>
        </div>
        <div class="permission-toggle">
          <div 
            class="toggle" 
            :class="{ active: openAIEnabled }" 
            @click="togglePermission('open')"
          >
            <div class="toggle-handle"></div>
          </div>
        </div>
      </div>

      <!-- 商业使用许可证 -->
      <div class="permission-row" v-if="shouldShowLicenseOption('commercial')">
        <div class="permission-icon">
          <div class="icon-container green">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="12" y1="1" x2="12" y2="23"></line>
              <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
            </svg>
          </div>
        </div>
        <div class="permission-label">
          <span>商业使用</span>
          <div class="permission-description">允许您的作品被用于AI的商业训练与应用</div>
        </div>
        <div class="permission-toggle">
          <div 
            class="toggle" 
            :class="{ active: commercialAIEnabled }" 
            @click="togglePermission('commercial')"
          >
            <div class="toggle-handle"></div>
          </div>
        </div>
      </div>

      <!-- 非商业混音许可证 -->
      <div class="permission-row" v-if="shouldShowLicenseOption('non-commercial')">
        <div class="permission-icon">
          <div class="icon-container blue">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
              <polyline points="2 17 12 22 22 17"></polyline>
              <polyline points="2 12 12 17 22 12"></polyline>
            </svg>
          </div>
        </div>
        <div class="permission-label">
          <span>非商业混音</span>
          <div class="permission-description">允许您的作品在AI非商业环境中被混合与衍生</div>
        </div>
        <div class="permission-toggle">
          <div 
            class="toggle" 
            :class="{ active: nonCommercialAIEnabled }" 
            @click="togglePermission('non-commercial')"
          >
            <div class="toggle-handle"></div>
          </div>
        </div>
      </div>

      <!-- 商业混音许可证 -->
      <div class="permission-row" v-if="shouldShowLicenseOption('commercial-remix')">
        <div class="permission-icon">
          <div class="icon-container red">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M12 2L2 7l10 5 10-5-10-5z" />
              <path d="M2 17l10 5 10-5" />
              <path d="M2 12l10 5 10-5" />
            </svg>
          </div>
        </div>
        <div class="permission-label">
          <span>商业混音</span>
          <div class="permission-description">允许您的作品在AI商业环境中被混合与衍生</div>
        </div>
        <div class="permission-toggle">
          <div 
            class="toggle" 
            :class="{ active: remixAIEnabled }" 
            @click="togglePermission('commercial-remix')"
          >
            <div class="toggle-handle"></div>
          </div>
        </div>
      </div>
    </div>

    <div class="ai-info-section">
      <div class="ai-info-item">
        <div class="ai-info-icon">🔍</div>
        <div class="ai-info-content">
          <h3>什么是AI训练？</h3>
          <p>
            AI训练是通过向AI系统提供许多示例来"教导"它如何识别模式、创建内容并对查询做出响应的过程。
            这些示例可能包括艺术品、写作、代码或其他类型的内容。
          </p>
        </div>
      </div>
      
      <div class="ai-info-item">
        <div class="ai-info-icon">🔒</div>
        <div class="ai-info-content">
          <h3>为什么需要您的许可？</h3>
          <p>
            我们尊重创作者的知识产权。与其他平台不同，我们明确请求您的许可，以确保您了解并同意您的作品如何被使用。
            这为创作者提供了选择权，并确保尊重权利。
          </p>
        </div>
      </div>
      
      <div class="ai-info-item">
        <div class="ai-info-icon">💡</div>
        <div class="ai-info-content">
          <h3>这对您有什么好处？</h3>
          <p>
            通过允许您的作品用于AI训练，您将帮助改进AI的能力，这可能会使创作过程变得更容易，
            并促进创新。您也在帮助建立一个更开放、更有创造力的社区。
          </p>
        </div>
      </div>
    </div>

    <!-- 底部导航按钮 -->
    <NavigationButtons
      @back="$emit('navigate-back')"
      @next="confirmAndNavigate"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import NavigationButtons from '../../common/NavigationButtons.vue';

const props = defineProps({
  selectedLicenses: {
    type: Array as () => string[],
    default: () => []
  },
  aiTrainingEnabled: {
    type: Boolean,
    default: true
  }
});

const emit = defineEmits(['navigate-back', 'navigate-next', 'ai-permission-update']);

// 各许可证AI训练状态
const commercialAIEnabled = ref(true);
const remixAIEnabled = ref(true);
const nonCommercialAIEnabled = ref(true);
const openAIEnabled = ref(true);

onMounted(() => {
  // Debug logs
  console.log('AIPermissionsSettingsPage mounted with selectedLicenses:', props.selectedLicenses);
  console.log('AIPermissionsSettingsPage includes commercial?', props.selectedLicenses.includes('commercial'));
  console.log('AIPermissionsSettingsPage includes commercial-remix?', props.selectedLicenses.includes('commercial-remix'));
  console.log('AIPermissionsSettingsPage includes non-commercial?', props.selectedLicenses.includes('non-commercial'));
  console.log('AIPermissionsSettingsPage includes open?', props.selectedLicenses.includes('open'));
  
  // 初始化AI权限状态 - 不再强制设置为 true，而是使用传入的值
  commercialAIEnabled.value = props.aiTrainingEnabled;
  remixAIEnabled.value = props.aiTrainingEnabled;
  nonCommercialAIEnabled.value = props.aiTrainingEnabled;
  openAIEnabled.value = props.aiTrainingEnabled;
});

// 切换特定许可证的AI训练状态 - 移除任何限制检查，允许全部自由切换
const togglePermission = (type: string) => {
  if (type === 'commercial') {
    commercialAIEnabled.value = !commercialAIEnabled.value;
  } else if (type === 'commercial-remix') {
    remixAIEnabled.value = !remixAIEnabled.value;
  } else if (type === 'non-commercial') {
    nonCommercialAIEnabled.value = !nonCommercialAIEnabled.value;
  } else if (type === 'open') {
    openAIEnabled.value = !openAIEnabled.value;
  }
};

// 确认选择并导航至下一页
const confirmAndNavigate = () => {
  // 创建包含所有许可证AI训练状态的权限对象
  const aiPermissions = {
    global: (commercialAIEnabled.value || remixAIEnabled.value || nonCommercialAIEnabled.value || openAIEnabled.value),
    commercial: commercialAIEnabled.value,
    'commercial-remix': remixAIEnabled.value,
    'non-commercial': nonCommercialAIEnabled.value,
    open: openAIEnabled.value
  };
  
  console.log('AI权限设置已更新:', aiPermissions);
  
  // 发送AI权限更新事件
  emit('ai-permission-update', aiPermissions);
  
  // 导航至下一页
  emit('navigate-next', { global: aiPermissions.global });
};

// 新增的watch函数
watch(() => props.selectedLicenses, (newLicenses) => {
  console.log('selectedLicenses changed to:', newLicenses);
  console.log('AIPermissionsSettingsPage includes commercial?', newLicenses.includes('commercial'));
  console.log('AIPermissionsSettingsPage includes commercial-remix?', newLicenses.includes('commercial-remix'));
  console.log('AIPermissionsSettingsPage includes non-commercial?', newLicenses.includes('non-commercial'));
  console.log('AIPermissionsSettingsPage includes open?', newLicenses.includes('open'));
});

// 新增的shouldShowLicenseOption函数
const shouldShowLicenseOption = (type: string) => {
  return props.selectedLicenses.includes(type);
};
</script>

<style scoped>
.ai-permissions-container {
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  padding: 30px 20px;
}

.ai-permissions-header {
  text-align: center;
  margin-bottom: 40px;
}

.ai-title-main {
  font-size: 32px;
  margin-bottom: 10px;
  color: #ffffff;
}

.ai-subtitle {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 4px;
}

.ai-subtitle-zh {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
}

.permission-card {
  background: rgba(30, 30, 35, 0.3);
  border-radius: 12px;
  margin-bottom: 40px;
  overflow: hidden;
}

.permission-row {
  display: flex;
  align-items: center;
  padding: 18px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.permission-row:last-child {
  border-bottom: none;
}

.permission-icon {
  margin-right: 16px;
  flex-shrink: 0;
}

.icon-container {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon-container.green {
  background: rgba(46, 204, 113, 0.2);
  color: rgb(46, 204, 113);
}

.icon-container.red {
  background: rgba(231, 76, 60, 0.2);
  color: rgb(231, 76, 60);
}

.icon-container.blue {
  background: rgba(52, 152, 219, 0.2);
  color: rgb(52, 152, 219);
}

.icon-container.purple {
  background: rgba(155, 89, 255, 0.2);
  color: rgb(155, 89, 255);
}

.permission-label {
  flex: 1;
  font-size: 18px;
  font-weight: 500;
  color: white;
}

.permission-description {
  font-size: 12px;
  font-weight: normal;
  color: rgba(255, 255, 255, 0.6);
  margin-top: 4px;
}

.permission-toggle {
  margin-left: 20px;
  flex-shrink: 0;
}

.toggle {
  width: 55px;
  height: 30px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 30px;
  position: relative;
  cursor: pointer;
  transition: all 0.3s;
}

.toggle.active {
  background: linear-gradient(90deg, #06D6A0, #00C692);
}

.toggle-handle {
  width: 24px;
  height: 24px;
  background: white;
  border-radius: 50%;
  position: absolute;
  top: 3px;
  left: 3px;
  transition: all 0.3s;
}

.toggle.active .toggle-handle {
  left: 28px;
}

.ai-info-section {
  margin-bottom: 40px;
}

.ai-info-item {
  background: rgba(30, 30, 35, 0.4);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 15px;
  display: flex;
}

.ai-info-icon {
  font-size: 24px;
  margin-right: 15px;
  flex-shrink: 0;
}

.ai-info-content {
  flex: 1;
}

.ai-info-content h3 {
  font-size: 18px;
  margin-bottom: 8px;
  color: white;
}

.ai-info-content p {
  font-size: 14px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.7);
}
</style> 