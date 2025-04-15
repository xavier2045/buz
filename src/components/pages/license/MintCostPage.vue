<template>
  <div class="mint-cost-container">
    <div class="mint-cost-header">
      <div class="header-text">
        <p>OK. 还行。</p>
        <p>铸造此许可证需要多少钱?</p>
      </div>
      <div class="assistant-avatar">
        <img src="/images/girl-pointing-up_1.png" alt="AE Assistant" />
      </div>
    </div>

    <div class="mint-cost-options">
      <div class="mint-cost-input">
        <input 
          type="text" 
          class="custom-input" 
          v-model="licenseFee"
          placeholder="请输入资产价格"
        />
        <span class="license-type">¥</span>
      </div>
      
      <!-- 文件上传区域 -->
      <div class="file-upload-section" v-if="props.licenseType !== 'open'">
        <div class="upload-header">
          <div class="upload-label">
            <span>上传原文件</span>
            <span v-if="isRequiredFileUpload" class="required-mark">（必需）</span>
            <span v-else>（推荐）</span>
          </div>
          <div class="file-status" v-if="hasOtherLicenseTypeFiles && files.length === 0">
            <span class="sync-badge">
              <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
              </svg>
              已从其他许可证同步文件
            </span>
          </div>
        </div>
        
        <div 
          class="upload-area" 
          :class="{ 
            'drag-active': isDragging, 
            'has-files': files.length > 0,
            'required-upload': isRequiredFileUpload,
            'other-files-synced': hasOtherLicenseTypeFiles && files.length === 0
          }"
          @click="triggerFileInput"
          @dragover.prevent="onDragOver"
          @dragleave.prevent="onDragLeave"
          @drop.prevent="onDrop"
        >
          <input 
            type="file" 
            ref="fileInput" 
            class="file-input" 
            multiple 
            @change="onFileSelected" 
          />
          
          <div v-if="files.length === 0 && !hasOtherLicenseTypeFiles" class="upload-placeholder">
            <div class="upload-icon-wrapper">
              <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="upload-icon">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                <polyline points="17 8 12 3 7 8"></polyline>
                <line x1="12" y1="3" x2="12" y2="15"></line>
              </svg>
            </div>
            <p class="upload-text">点击或拖拽文件到此处上传</p>
            <p class="upload-description">支持所有文件类型</p>
          </div>
          
          <div v-else-if="hasOtherLicenseTypeFiles && files.length === 0" class="synced-files-message">
            <div class="sync-icon-wrapper">
              <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M8 3H5a2 2 0 0 0-2 2v3"></path>
                <path d="M21 8V5a2 2 0 0 0-2-2h-3"></path>
                <path d="M3 16v3a2 2 0 0 0 2 2h3"></path>
                <path d="M16 21h3a2 2 0 0 0 2-2v-3"></path>
                <rect x="7" y="7" width="10" height="10" rx="2"></rect>
              </svg>
            </div>
            <p class="sync-text">已自动同步文件</p>
            <p class="sync-description">文件已从另一个许可证类型同步，无需重复上传</p>
            <button class="upload-own-btn" @click.stop="triggerFileInput">
              仍要上传新文件
            </button>
          </div>
          
          <div v-else class="uploaded-files">
            <div class="file-list">
              <TransitionGroup name="file-list">
                <div v-for="(file, index) in files" :key="index" class="file-item">
                  <div class="file-preview">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                      <polyline points="14 2 14 8 20 8"></polyline>
                    </svg>
                  </div>
                  <div class="file-details">
                    <div class="file-name">{{ file.name }}</div>
                    <div class="file-size">{{ formatFileSize(file.size) }}</div>
                  </div>
                  <button class="remove-file" @click.stop="removeFile(index)" title="删除文件">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <line x1="18" y1="6" x2="6" y2="18"></line>
                      <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                  </button>
                </div>
              </TransitionGroup>
            </div>
            <div class="add-more-files" @click.stop="triggerFileInput">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
              </svg>
              <span>添加更多文件</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 开放使用许可证类型不需要上传文件 -->
      <div class="open-license-message" v-else>
        <div class="message-box">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M12 8v4"></path>
            <path d="M12 16h0"></path>
          </svg>
          <p>开放使用许可证不需要上传原文件，点击下一步继续。</p>
        </div>
      </div>
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
import { ref, computed, watch } from 'vue';
import { useRouter } from 'vue-router';
import NavigationButtons from '../../common/NavigationButtons.vue';

interface UploadFileItem {
  file: File;
  name: string;
  size: string;
  progress: number;
}

const router = useRouter();

const emit = defineEmits(['select-mint-cost', 'navigate-back']);
const licenseFee = ref('');
const fileInput = ref<HTMLInputElement | null>(null);
const files = ref<File[]>([]);
const isDragging = ref(false);
const selectedTokenId = ref(null);
const uploadProgress = ref<number>(0);
const fileList = ref<UploadFileItem[]>([]);

// 判断是否必须上传文件（商业使用或混合创新）
const isRequiredFileUpload = computed(() => {
  return props.licenseType === 'commercial' || props.licenseType === 'commercial-remix';
});

// 判断是否已经在其他页面上传了文件
const hasOtherLicenseTypeFiles = computed(() => {
  if (typeof window === 'undefined') return false;
  
  // @ts-ignore
  const uploadedFiles = window._uploadedLicenseFiles || {};
  const otherLicenseType = props.licenseType === 'commercial' ? 'commercial-remix' : 'commercial';
  
  // 检查另一个许可证类型是否已上传文件
  return uploadedFiles[otherLicenseType]?.length > 0;
});

const isValidSelection = computed(() => {
  // 如果是开放使用许可证，只需要检查价格字段
  if (props.licenseType === 'open') {
    return licenseFee.value.trim() !== '';
  }
  
  // 已输入价格
  const hasFee = licenseFee.value.trim() !== '';
  
  // 当前许可证类型已上传文件
  const hasCurrentFiles = files.value.length > 0;
  
  // 对于商业使用和混合创新许可证，必须上传文件
  if (isRequiredFileUpload.value) {
    // 如果已经在另一个许可证类型页面已经上传了文件，则可以跳过当前页面的上传
    if (hasOtherLicenseTypeFiles.value) {
      return hasFee; // 只要有价格就可以
    }
    return hasCurrentFiles && hasFee; // 需要文件和价格
  }
  
  // 其他许可证类型，建议上传文件但不是必须的
  return hasFee;
});

const props = defineProps({
  sourceTab: {
    type: String,
    default: '' // 可以是 'preset', 'custom', 'assistant' 或空字符串
  },
  licenseType: {
    type: String,
    default: 'commercial'
  }
});

const goBack = () => {
  // 返回时发送源标签页信息，让父组件知道应该显示哪个标签页
  emit('navigate-back', props.sourceTab);
};

const goNext = () => {
  console.log('尝试进行下一步, 许可证类型:', props.licenseType, '文件数量:', files.value.length);
  
  // 开放使用许可证不需要上传文件
  if (props.licenseType === 'open') {
    if (licenseFee.value.trim()) {
      // 只需要检查费用字段
      emit('select-mint-cost', licenseFee.value.trim(), []);
    }
    return;
  }
  
  // 检查是否有费用
  if (!licenseFee.value.trim()) {
    alert('请输入资产价格');
    return;
  }
  
  // 对于商业使用和混合创新许可证，通常必须上传文件
  if (isRequiredFileUpload.value) {
    // 如果在另一个许可证类型页面已经上传了文件，可以使用那些文件
    if (hasOtherLicenseTypeFiles.value && files.value.length === 0) {
      // @ts-ignore
      const uploadedFiles = window._uploadedLicenseFiles || {};
      const otherLicenseType = props.licenseType === 'commercial' ? 'commercial-remix' : 'commercial';
      const otherFiles = uploadedFiles[otherLicenseType] || [];
      
      emit('select-mint-cost', licenseFee.value.trim(), otherFiles);
      return;
    }
    
    // 否则需要在当前页面上传文件
    if (files.value.length === 0) {
      alert('请上传原文件，这是必需的');
      return;
    }
  }
  
  // 有文件就发送文件，没有文件就只发送价格
  if (files.value.length > 0) {
    // 保存文件到全局对象以供其他页面使用
    if (typeof window !== 'undefined' && isRequiredFileUpload.value) {
      // @ts-ignore
      window._uploadedLicenseFiles = window._uploadedLicenseFiles || {};
      // @ts-ignore
      window._uploadedLicenseFiles[props.licenseType] = files.value;
    }
    
    emit('select-mint-cost', licenseFee.value.trim(), files.value);
  } else {
    // 对于非必需的文件上传，询问用户是否要继续
    const proceed = confirm('上传原文件是推荐的。是否要跳过上传继续？');
    if (proceed) {
      emit('select-mint-cost', licenseFee.value.trim(), []);
    }
  }
};

// 文件上传相关方法
const triggerFileInput = () => {
  if (fileInput.value) {
    fileInput.value.click();
  }
};

const onFileSelected = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files.length > 0) {
    addFiles(Array.from(input.files));
  }
};

const onDragOver = () => {
  isDragging.value = true;
};

const onDragLeave = () => {
  isDragging.value = false;
};

const onDrop = (event: DragEvent) => {
  isDragging.value = false;
  if (event.dataTransfer?.files) {
    addFiles(Array.from(event.dataTransfer.files));
  }
};

const addFiles = (newFiles: File[]) => {
  files.value = [...files.value, ...newFiles];
};

const removeFile = (index: number) => {
  files.value = files.value.filter((_, i) => i !== index);
};

const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};
</script>

<style scoped>
.mint-cost-container {
  width: 100%;
  max-width: 800px;
  background: rgba(15, 15, 20, 0.85);
  border-radius: 16px;
  padding: 80px 30px 70px;
  position: relative;
  color: white;
  margin-top: 40px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
  z-index: 10;
}

.mint-cost-header {
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

.mint-cost-options {
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 60px;
}

.mint-cost-input {
  background: rgba(25, 25, 30, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 14px;
  padding: 15px 20px;
  display: flex;
  align-items: center;
  position: relative;
  overflow: hidden;
  margin-bottom: 20px;
}

.mint-cost-input .custom-input {
  flex: 1;
  background: transparent;
  border: none;
  color: white;
  font-size: 16px;
  outline: none;
  padding: 5px 0;
}

.mint-cost-input .custom-input::placeholder {
  color: rgba(255, 255, 255, 0.4);
  font-style: italic;
}

.mint-cost-input:focus-within {
  background: rgba(40, 40, 45, 0.7);
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
  transition: all 0.3s ease;
}

.mint-cost-input .license-type {
  margin-left: 10px;
  font-size: 16px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
}

/* 文件上传区域样式 */
.file-upload-section {
  width: 100%;
  margin-top: 30px;
}

.upload-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.upload-label {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.9);
  font-weight: 500;
}

.file-status {
  display: flex;
  align-items: center;
}

.sync-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: rgba(126, 87, 194, 0.2);
  color: #b388ff;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 12px;
}

.upload-area {
  width: 100%;
  min-height: 160px;
  border: 2px dashed rgba(255, 255, 255, 0.2);
  border-radius: 14px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  transition: all 0.3s ease;
  padding: 30px 20px;
  position: relative;
  overflow: hidden;
}

.upload-area:hover {
  background: rgba(0, 0, 0, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
}

.upload-area.drag-active {
  background: rgba(126, 87, 194, 0.1);
  border-color: #7e57c2;
}

.upload-area.required-upload {
  border-color: rgba(255, 80, 80, 0.6);
}

.upload-area.required-upload:hover {
  background: rgba(255, 80, 80, 0.05);
  border-color: rgba(255, 80, 80, 0.8);
}

.upload-area.other-files-synced {
  border-color: #7e57c2;
  background: rgba(126, 87, 194, 0.05);
}

.required-mark {
  color: #ff5050;
  font-weight: bold;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  color: rgba(255, 255, 255, 0.7);
}

.upload-icon-wrapper {
  width: 64px;
  height: 64px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
}

.upload-icon {
  color: rgba(255, 255, 255, 0.5);
}

.upload-text {
  font-size: 16px;
  font-weight: 500;
  margin: 0;
}

.upload-description {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
}

.synced-files-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  text-align: center;
}

.sync-icon-wrapper {
  width: 64px;
  height: 64px;
  background: rgba(126, 87, 194, 0.15);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
  color: #b388ff;
}

.sync-text {
  font-size: 16px;
  font-weight: 500;
  color: #b388ff;
  margin: 0;
}

.sync-description {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
  margin: 0;
  max-width: 300px;
}

.upload-own-btn {
  background: rgba(126, 87, 194, 0.2);
  border: 1px solid rgba(126, 87, 194, 0.4);
  color: #b388ff;
  border-radius: 20px;
  padding: 6px 12px;
  margin-top: 10px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.upload-own-btn:hover {
  background: rgba(126, 87, 194, 0.3);
}

.file-input {
  display: none;
}

.uploaded-files {
  width: 100%;
}

.file-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 15px;
}

.file-list-enter-active,
.file-list-leave-active {
  transition: all 0.3s ease;
}

.file-list-enter-from,
.file-list-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.file-item {
  background: rgba(30, 30, 35, 0.7);
  border-radius: 12px;
  padding: 12px 15px;
  display: flex;
  align-items: center;
  gap: 12px;
  transition: all 0.2s;
  animation: slideInUp 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.file-item:hover {
  background: rgba(40, 40, 45, 0.7);
  border-color: rgba(255, 255, 255, 0.2);
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.file-preview {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: rgba(126, 87, 194, 0.15);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #b388ff;
  flex-shrink: 0;
}

.file-details {
  flex: 1;
  min-width: 0; /* 让内容可以自动收缩，避免溢出 */
}

.file-name {
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 14px;
}

.file-size {
  color: rgba(255, 255, 255, 0.6);
  font-size: 12px;
  margin-top: 2px;
}

.remove-file {
  background: transparent;
  color: rgba(255, 255, 255, 0.5);
  border: none;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s;
  padding: 0;
  margin-left: auto;
}

.remove-file:hover {
  background: rgba(255, 80, 80, 0.2);
  color: #ff5050;
}

.add-more-files {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px;
  color: #b388ff;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  background: rgba(126, 87, 194, 0.1);
  border-radius: 12px;
  transition: all 0.2s;
  border: 1px solid rgba(126, 87, 194, 0.2);
}

.add-more-files:hover {
  background: rgba(126, 87, 194, 0.15);
  border-color: rgba(126, 87, 194, 0.3);
}

/* 开放使用许可证消息 */
.open-license-message {
  margin-top: 20px;
}

.message-box {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  background: rgba(0, 118, 255, 0.1);
  border-radius: 12px;
  padding: 15px;
  color: rgba(255, 255, 255, 0.9);
}

.message-box svg {
  color: #0076ff;
  margin-top: 3px;
  flex-shrink: 0;
}

.message-box p {
  margin: 0;
  font-size: 14px;
  line-height: 1.5;
}

@media (max-width: 768px) {
  .mint-cost-container {
    padding: 60px 20px 50px;
  }
  
  .mint-cost-header {
    flex-direction: column;
    align-items: center;
    text-align: center;
    gap: 20px;
    margin-bottom: 40px;
  }
  
  .header-text {
    padding-left: 0;
  }
  
  .assistant-avatar {
    margin: 0;
    transform: none;
  }
  
  .assistant-avatar img {
    transform: none;
  }
}

@media (max-width: 480px) {
  .mint-cost-container {
    padding: 40px 15px 30px;
  }
  
  .header-text p:first-child {
    font-size: 24px;
  }
  
  .header-text p:nth-child(2),
  .header-text p:nth-child(3) {
    font-size: 18px;
  }
  
  .assistant-avatar img {
    width: 100px;
    height: 100px;
  }
  
  .mint-cost-input {
    padding: 12px 15px;
  }
  
  .mint-cost-input .custom-input {
    font-size: 15px;
  }
  
  .upload-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
}
</style> 