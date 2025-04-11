<template>
  <div class="file-upload">
    <div 
      class="upload-container"
      :class="[
        variant,
        files.length > 0 ? 'has-file' : '',
        disabled ? 'disabled' : '',
        dragActive ? 'drag-active' : ''
      ]"
      @dragover.prevent
      @dragenter.prevent="dragActive = true"
      @dragleave.prevent="dragActive = false"
      @drop.prevent="handleFileDrop"
      @click="triggerFileInput"
    >
      <!-- 上传图标 -->
      <div v-if="files.length === 0" class="upload-icon" :class="variant">
        <slot name="icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
            <polyline points="17 8 12 3 7 8"></polyline>
            <line x1="12" y1="3" x2="12" y2="15"></line>
          </svg>
        </slot>
      </div>
      
      <!-- 文件预览列表 -->
      <div v-if="files.length > 0" class="file-list">
        <div v-for="(file, index) in files" :key="index" class="file-preview">
          <div class="file-icon">
            <slot name="file-icon">
              <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="document">
                <path d="M15,8h4.4L14,2.6V7C14,7.6,14.4,8,15,8z M15,10c-1.7,0-3-1.3-3-3V2H7C5.3,2,4,3.3,4,5v14c0,1.7,1.3,3,3,3h10
                c1.7,0,3-1.3,3-3v-9H15z" :fill="getThemeColor()" class="color000000 svgShape"></path>
              </svg>
            </slot>
          </div>
          <div class="file-info">
            <div class="file-name">{{ getFileName(file) }}</div>
            <div class="file-size">{{ getFileSize(file) }}</div>
          </div>
          <button 
            v-if="!disabled" 
            type="button" 
            class="remove-file-btn"
            @click.stop="removeFile(index)"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
      </div>
      
      <!-- 上传文本 -->
      <div v-if="files.length === 0" class="upload-text">
        <div class="upload-title">{{ title }}</div>
        <div class="upload-description">上传原文件</div>
      </div>
      
      <!-- 添加更多文件按钮 -->
      <div v-if="files.length > 0" class="add-more-files">
        <button @click.stop="triggerFileInput" class="add-files-btn">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
          添加更多原文件
        </button>
      </div>
      
      <!-- 隐藏的文件输入 -->
      <input 
        type="file" 
        ref="fileInput" 
        class="file-input"
        :accept="accept"
        :disabled="disabled"
        multiple
        @change="handleFileChange"
      >
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';

const props = defineProps({
  modelValue: {
    type: [File, Array, null],
    default: null
  },
  variant: {
    type: String,
    default: 'blue',
    validator: (value: string) => {
      return ['blue', 'purple', 'green', 'red'].includes(value);
    }
  },
  accept: {
    type: String,
    default: '*/*'
  },
  disabled: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: '点击或拖放文件至此处'
  },
  description: {
    type: String,
    default: '上传原文件'
  }
});

const emit = defineEmits(['update:modelValue']);

const fileInput = ref<HTMLInputElement | null>(null);
const dragActive = ref(false);
const files = ref<File[]>([]);

// 当props.modelValue变化时，同步本地files数组
watch(() => props.modelValue, (newVal) => {
  if (newVal === null) {
    files.value = [];
  } else if (Array.isArray(newVal)) {
    files.value = [...newVal];
  } else if (newVal instanceof File) {
    files.value = [newVal];
  }
}, { immediate: true });

// 获取根据变体设置颜色
const getThemeColor = () => {
  const colorMap: Record<string, string> = {
    'blue': '#32aaff',
    'purple': '#d479e8',
    'green': '#2ecc71',
    'red': '#e76655'
  };
  return colorMap[props.variant] || colorMap.blue;
};

// 获取文件名
const getFileName = (file: File) => {
  return file?.name || '';
};

// 获取文件大小
const getFileSize = (file: File) => {
  if (!file) return '';
  
  const size = file.size;
  if (size < 1024) {
    return `${size} B`;
  } else if (size < 1024 * 1024) {
    return `${(size / 1024).toFixed(2)} KB`;
  } else if (size < 1024 * 1024 * 1024) {
    return `${(size / (1024 * 1024)).toFixed(2)} MB`;
  } else {
    return `${(size / (1024 * 1024 * 1024)).toFixed(2)} GB`;
  }
};

// 触发文件选择
const triggerFileInput = () => {
  if (props.disabled) return;
  fileInput.value?.click();
};

// 处理文件选择
const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (!target.files || target.files.length === 0) return;
  
  // 将FileList转换为数组并添加到现有文件列表，确保类型正确
  const newFiles = Array.from(target.files) as File[];
  const updatedFiles = [...files.value, ...newFiles];
  
  // 更新文件列表并触发事件
  files.value = updatedFiles;
  emit('update:modelValue', updatedFiles);
};

// 处理文件拖放
const handleFileDrop = (event: DragEvent) => {
  if (props.disabled) return;
  
  dragActive.value = false;
  if (!event.dataTransfer?.files.length) return;
  
  // 将拖放的文件添加到现有文件列表，确保类型正确
  const newFiles = Array.from(event.dataTransfer.files) as File[];
  const updatedFiles = [...files.value, ...newFiles];
  
  // 更新文件列表并触发事件
  files.value = updatedFiles;
  emit('update:modelValue', updatedFiles);
};

// 移除特定文件
const removeFile = (index: number) => {
  // 创建新的文件数组，移除指定索引的文件
  const updatedFiles = [...files.value];
  updatedFiles.splice(index, 1);
  
  // 更新文件列表并触发事件
  files.value = updatedFiles;
  
  if (updatedFiles.length === 0) {
    emit('update:modelValue', null);
  } else {
    emit('update:modelValue', updatedFiles);
  }
  
  // 重置文件输入框，允许重新选择同一文件
  if (fileInput.value) {
    fileInput.value.value = '';
  }
};
</script>

<style scoped>
.file-upload {
  width: 100%;
}

.upload-container {
  border: 2px dashed rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  transition: all 0.3s ease;
  background-color: rgba(0, 0, 0, 0.15);
  cursor: pointer;
}

.upload-container:hover {
  background-color: rgba(0, 0, 0, 0.25);
}

.drag-active {
  background-color: rgba(0, 0, 0, 0.25);
}

.upload-container.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.upload-icon {
  color: rgba(255, 255, 255, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
}

.upload-icon.blue svg { color: #32aaff; }
.upload-icon.purple svg { color: #d479e8; }
.upload-icon.green svg { color: #2ecc71; }
.upload-icon.red svg { color: #e76655; }

.upload-text {
  text-align: center;
}

.upload-title {
  font-weight: 500;
  margin-bottom: 4px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.upload-description {
  color: rgba(255, 255, 255, 0.6);
  font-size: 12px;
}

.file-input {
  display: none;
}

/* 文件列表样式 */
.file-list {
  width: 100%;
  display: flex;
  flex-direction: row;
  flex-wrap: nowrap;
  gap: 10px;
  overflow-x: auto;
  padding-bottom: 5px;
  scrollbar-width: thin;
  scrollbar-color: rgba(255, 255, 255, 0.3) rgba(0, 0, 0, 0.1);
}

.file-list::-webkit-scrollbar {
  height: 5px;
}

.file-list::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 3px;
}

.file-list::-webkit-scrollbar-thumb {
  background-color: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
}

/* 文件预览样式 */
.file-preview {
  min-width: 200px;
  max-width: 300px;
  display: flex;
  align-items: center;
  gap: 12px;
  background-color: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  padding: 12px;
  flex-shrink: 0;
}

.file-icon {
  flex-shrink: 0;
  width: 24px;
  height: 24px;
}

.file-info {
  flex: 1;
  min-width: 0;
}

.file-name {
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.file-size {
  color: rgba(255, 255, 255, 0.6);
  font-size: 12px;
}

.remove-file-btn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
}

.remove-file-btn:hover {
  color: rgba(255, 255, 255, 0.9);
  background-color: rgba(255, 255, 255, 0.1);
}

/* 添加更多文件按钮样式 */
.add-more-files {
  margin-top: 10px;
  width: 100%;
  display: flex;
  justify-content: center;
}

.add-files-btn {
  background: rgba(0, 0, 0, 0.3);
  border: none;
  border-radius: 6px;
  padding: 8px 16px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
}

.add-files-btn:hover {
  background: rgba(0, 0, 0, 0.4);
  transform: translateY(-2px);
}

.add-files-btn svg {
  width: 16px;
  height: 16px;
}

/* 变体样式 */
.upload-container.blue {
  border-color: rgba(50, 170, 255, 0.3);
}
.upload-container.purple {
  border-color: rgba(212, 121, 232, 0.3);
}
.upload-container.green {
  border-color: rgba(46, 204, 113, 0.3);
}
.upload-container.red {
  border-color: rgba(231, 102, 85, 0.3);
}

.upload-container.blue.drag-active {
  border-color: #32aaff;
}
.upload-container.purple.drag-active {
  border-color: #d479e8;
}
.upload-container.green.drag-active {
  border-color: #2ecc71;
}
.upload-container.red.drag-active {
  border-color: #e76655;
}
</style> 