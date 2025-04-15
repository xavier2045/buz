<template>
  <div class="remix-container">
    <div class="remix-header">
      <div class="header-text">
        <p>好的，太好了。</p>
        <p>其他创作者可以重新混合这部作品吗？</p>
      </div>
      <div class="assistant-avatar">
        <img src="/images/girl-pointing-up_1.png" alt="AE Assistant" />
      </div>
    </div>

    <div class="remix-options">
      <div 
        class="remix-option" 
        :class="{ selected: selectedRemix === 'yes' }"
        @click="selectRemix('yes')"
      >
        <span>是的</span>
      </div>
      <div 
        class="remix-option" 
        :class="{ selected: selectedRemix === 'no' }"
        @click="selectRemix('no')"
      >
        <span>不</span>
      </div>
    </div>
    
    <!-- 当选择"是"时显示文件上传组件 -->
    <div class="file-upload-section" v-if="selectedRemix === 'yes'">
      <div class="upload-label">
        <span>上传原文件</span>
        <span class="required-mark">（必需）</span>
      </div>
      <div 
        class="upload-area" 
        :class="{ 
          'drag-active': isDragging, 
          'has-files': files.length > 0,
          'required-upload': true
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
        
        <div v-if="files.length === 0" class="upload-placeholder">
          <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="upload-icon">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
            <polyline points="17 8 12 3 7 8"></polyline>
            <line x1="12" y1="3" x2="12" y2="15"></line>
          </svg>
          <p class="upload-text">点击或拖拽文件到此处上传</p>
          <p class="upload-description">支持所有文件类型</p>
        </div>
        
        <div v-else class="uploaded-files">
          <div class="file-list">
            <div v-for="(file, index) in files" :key="index" class="file-item">
              <div class="file-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                  <polyline points="14 2 14 8 20 8"></polyline>
                </svg>
              </div>
              <div class="file-name">{{ file.name }}</div>
              <div class="file-size">{{ formatFileSize(file.size) }}</div>
              <button class="remove-file" @click.stop="removeFile(index)">×</button>
            </div>
          </div>
          <div class="add-more-files" @click.stop="triggerFileInput">
            <span>+ 添加更多文件</span>
          </div>
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
import { ref, computed } from 'vue';
import NavigationButtons from '../../common/NavigationButtons.vue';

const emit = defineEmits(['select-remix', 'navigate-back']);
const selectedRemix = ref('');
const files = ref<File[]>([]);
const fileInput = ref<HTMLInputElement | null>(null);
const isDragging = ref(false);

// 检查选择是否有效，如果选择"是"，则必须上传文件
const isValidSelection = computed(() => {
  if (selectedRemix.value === '') return false;
  if (selectedRemix.value === 'yes') {
    return files.value.length > 0;
  }
  return true;
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
  }
});

const selectRemix = (remixType: string) => {
  selectedRemix.value = remixType;
};

const goBack = () => {
  // 返回时发送源标签页信息，让父组件知道应该显示哪个标签页
  emit('navigate-back', props.sourceTab);
};

const goNext = () => {
  if (selectedRemix.value === 'no') {
    emit('select-remix', selectedRemix.value);
  } else if (selectedRemix.value === 'yes' && files.value.length > 0) {
    emit('select-remix', selectedRemix.value, files.value);
  } else if (selectedRemix.value === 'yes' && files.value.length === 0) {
    alert('请上传原文件，这是必需的');
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
.remix-container {
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

.remix-header {
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

.remix-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 25px;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 60px;
}

.remix-option {
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

.remix-option.selected {
  background: rgba(74, 144, 226, 0.2);
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.remix-option:hover {
  background: rgba(40, 40, 45, 0.7);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.remix-option.selected:hover {
  background: rgba(74, 144, 226, 0.25);
}

.remix-option span {
  font-size: 17px;
  font-weight: 500;
}

@media (max-width: 767px) {
  .remix-container {
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
  
  .remix-options {
    grid-template-columns: 1fr;
  }
}

/* 文件上传区域样式 */
.file-upload-section {
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-top: 30px;
  margin-bottom: 30px;
}

.upload-label {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 10px;
  font-weight: 500;
}

.upload-area {
  width: 100%;
  min-height: 150px;
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

.upload-icon {
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 5px;
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
  margin-bottom: 10px;
}

.file-item {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  padding: 10px 15px;
  display: flex;
  align-items: center;
  gap: 10px;
  animation: slideInUp 0.3s ease;
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

.file-icon {
  color: #7e57c2;
}

.file-name {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.file-size {
  color: rgba(255, 255, 255, 0.6);
  font-size: 12px;
  margin-left: auto;
}

.remove-file {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.7);
  border: none;
  border-radius: 50%;
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.2s;
  padding: 0;
  line-height: 1;
}

.remove-file:hover {
  background: rgba(255, 80, 80, 0.3);
  color: rgba(255, 255, 255, 0.9);
}

.add-more-files {
  text-align: center;
  padding: 10px;
  color: #7e57c2;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  background: rgba(126, 87, 194, 0.1);
  border-radius: 8px;
  transition: all 0.2s;
}

.add-more-files:hover {
  background: rgba(126, 87, 194, 0.15);
}
</style> 