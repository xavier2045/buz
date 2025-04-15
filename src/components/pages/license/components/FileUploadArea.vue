<template>
  <div class="file-upload-section">
    <div class="upload-header">
      <div class="upload-label">
        <span>上传原文件</span>
        <span v-if="isRequired" class="required-mark">（必需）</span>
        <span v-else>（推荐）</span>
      </div>
      <div class="file-status" v-if="hasOtherFiles && files.length === 0">
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
        'required-upload': isRequired,
        'other-files-synced': hasOtherFiles && files.length === 0,
        [variantClass]: true
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
      
      <div v-if="files.length === 0 && !hasOtherFiles" class="upload-placeholder">
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
      
      <div v-else-if="hasOtherFiles && files.length === 0" class="synced-files-message">
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
      
      <div v-else class="file-list">
        <transition-group name="file-item" tag="div" class="file-list-wrapper">
          <div v-for="(file, index) in files" :key="file.name + index" class="file-item">
            <div class="file-info">
              <div class="file-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                  <polyline points="14 2 14 8 20 8"></polyline>
                </svg>
              </div>
              <div class="file-details">
                <div class="file-name" :title="file.name">{{ file.name }}</div>
                <div class="file-size">{{ formatFileSize(file.size) }}</div>
              </div>
            </div>
            <button class="file-remove-btn" @click.stop="removeFile(index)" title="移除文件">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
        </transition-group>
        <div class="add-more-files">
          <button class="add-file-btn" @click.stop="triggerFileInput">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            添加更多文件
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed, defineProps, defineEmits, withDefaults } from 'vue';

interface Props {
  modelValue: File[] | null;
  isRequired?: boolean;
  hasOtherFiles?: boolean;
  variant?: 'default' | 'commercial' | 'remix';
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: null,
  isRequired: false,
  hasOtherFiles: false,
  variant: 'default'
});

const emit = defineEmits(['update:modelValue']);

const files = ref<File[]>(props.modelValue ? [...props.modelValue] : []);
const fileInput = ref<HTMLInputElement | null>(null);
const isDragging = ref(false);

// 根据variant属性计算CSS类名
const variantClass = computed(() => {
  switch (props.variant) {
    case 'commercial':
      return 'variant-commercial';
    case 'remix':
      return 'variant-remix';
    default:
      return 'variant-default';
  }
});

// 文件上传相关方法
const triggerFileInput = (event?: Event) => {
  if (event) {
    event.stopPropagation(); // 阻止事件冒泡，确保不会触发其他绑定的click事件
  }
  if (fileInput.value) {
    fileInput.value.click();
  }
};

const onFileSelected = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files.length > 0) {
    addFiles(Array.from(input.files));
    input.value = ''; // 重置input的值，确保相同文件可以被再次选择
  }
};

const onDragOver = (event: DragEvent) => {
  event.preventDefault(); // 确保阻止默认行为
  isDragging.value = true;
};

const onDragLeave = (event: DragEvent) => {
  event.preventDefault(); // 确保阻止默认行为
  isDragging.value = false;
};

const onDrop = (event: DragEvent) => {
  event.preventDefault(); // 确保阻止默认行为
  isDragging.value = false;
  if (event.dataTransfer?.files) {
    addFiles(Array.from(event.dataTransfer.files));
  }
};

const addFiles = (newFiles: File[]) => {
  // 过滤掉重复文件（基于文件名+大小进行简单比较）
  const uniqueNewFiles = newFiles.filter(newFile => 
    !files.value.some(existingFile => 
      existingFile.name === newFile.name && existingFile.size === newFile.size
    )
  );
  
  if (uniqueNewFiles.length > 0) {
    files.value = [...files.value, ...uniqueNewFiles];
    emit('update:modelValue', files.value);
  }
};

const removeFile = (index: number) => {
  files.value = files.value.filter((_, i) => i !== index);
  emit('update:modelValue', files.value);
};

const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

// 监听props变化，更新本地files
watch(() => props.modelValue, (newFiles) => {
  if (newFiles === null) {
    files.value = [];
  } else if (Array.isArray(newFiles)) {
    files.value = [...newFiles];
  }
}, { deep: true });
</script>

<style scoped>
.file-upload-section {
  width: 100%;
  margin-bottom: 20px;
}

/* 上传区域标题样式 */
.upload-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.upload-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.85);
  display: flex;
  align-items: center;
  gap: 5px;
}

.required-mark {
  color: #ff7875;
}

.file-status {
  font-size: 12px;
}

.sync-badge {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 4px 8px;
  background: rgba(60, 60, 67, 0.3);
  border-radius: 12px;
  color: rgba(255, 255, 255, 0.8);
}

.sync-badge svg {
  color: #1890ff;
}

/* 上传区域主体样式 */
.upload-area {
  position: relative;
  width: 100%;
  min-height: 150px;
  border: 2px dashed rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  cursor: pointer;
  overflow: hidden;
  box-sizing: border-box;
}

.upload-area:hover {
  border-color: rgba(255, 255, 255, 0.4);
  background-color: rgba(255, 255, 255, 0.03);
}

.upload-area.drag-active {
  border-color: #1890ff;
  background-color: rgba(24, 144, 255, 0.05);
}

.upload-area.has-files {
  border-style: solid;
  align-items: stretch;
  background-color: rgba(30, 30, 35, 0.3);
  padding: 15px;
}

.upload-area.required-upload {
  border-color: rgba(255, 120, 117, 0.4);
}

.upload-area.required-upload:hover {
  border-color: rgba(255, 120, 117, 0.7);
}

.upload-area.other-files-synced {
  border-color: rgba(24, 144, 255, 0.4);
  border-style: solid;
}

/* 文件输入样式 */
.file-input {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  cursor: pointer;
  z-index: -1; /* 隐藏但保持可访问性 */
}

/* 上传占位符样式 */
.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  width: 100%;
}

.upload-icon-wrapper {
  margin-bottom: 15px;
  color: rgba(255, 255, 255, 0.6);
}

.upload-text {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 6px;
}

.upload-description {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
}

/* 同步文件消息样式 */
.synced-files-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
}

.sync-icon-wrapper {
  margin-bottom: 15px;
  color: #1890ff;
}

.sync-text {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 6px;
}

.sync-description {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 15px;
}

.upload-own-btn {
  background: rgba(24, 144, 255, 0.2);
  border: 1px solid rgba(24, 144, 255, 0.4);
  border-radius: 4px;
  padding: 6px 12px;
  font-size: 13px;
  color: #1890ff;
  cursor: pointer;
  transition: all 0.3s;
}

.upload-own-btn:hover {
  background: rgba(24, 144, 255, 0.3);
}

/* 文件列表样式 */
.file-list {
  width: 100%;
}

.file-list-wrapper {
  margin-bottom: 15px;
}

.file-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px;
  background: rgba(60, 60, 67, 0.2);
  border-radius: 6px;
  margin-bottom: 8px;
  transition: all 0.3s;
}

.file-item:hover {
  background: rgba(60, 60, 67, 0.3);
}

.file-info {
  display: flex;
  align-items: center;
  gap: 10px;
  overflow: hidden;
}

.file-icon {
  color: rgba(255, 255, 255, 0.7);
  flex-shrink: 0;
}

.file-details {
  overflow: hidden;
}

.file-name {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 3px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 250px;
}

.file-size {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

.file-remove-btn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 5px;
  border-radius: 4px;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.file-remove-btn:hover {
  color: #ff7875;
  background: rgba(255, 255, 255, 0.1);
}

/* 添加更多文件按钮 */
.add-more-files {
  display: flex;
  justify-content: center;
}

.add-file-btn {
  display: flex;
  align-items: center;
  gap: 5px;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  border-radius: 4px;
  padding: 6px 12px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.8);
  cursor: pointer;
  transition: all 0.3s;
}

.add-file-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

/* 动画效果 */
.file-item-enter-active, .file-item-leave-active {
  transition: all 0.3s;
}

.file-item-enter-from, .file-item-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* 变体样式 */
.variant-commercial {
  border-color: rgba(76, 175, 80, 0.4);
}

.variant-commercial:hover {
  border-color: rgba(76, 175, 80, 0.7);
}

.variant-remix {
  border-color: rgba(255, 152, 0, 0.4);
}

.variant-remix:hover {
  border-color: rgba(255, 152, 0, 0.7);
}

/* 响应式调整 */
@media (max-width: 768px) {
  .upload-area {
    min-height: 120px;
    padding: 15px;
  }
  
  .file-name {
    max-width: 150px;
  }
}
</style> 