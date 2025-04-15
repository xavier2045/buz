<template>
  <div class="file-upload-container">
    <label :for="inputId" class="custom-upload-button" @click.prevent="triggerFileInput">
      <slot name="button-text">上传文件</slot>
    </label>
    <input
      ref="fileInput"
      :id="inputId"
      type="file"
      :accept="accept"
      @change="handleFileChange"
      class="file-input"
    />
    <div v-if="selectedFile" class="file-display">
      <div class="file-info">
        <span class="file-name">{{ selectedFile.name }}</span>
        <span class="file-size">({{ formatFileSize(selectedFile.size) }})</span>
      </div>
      <button @click="removeFile" class="remove-file-btn">
        <slot name="remove-text">移除</slot>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, withDefaults } from 'vue';

interface Props {
  accept?: string;
  inputId: string;
  modelValue?: File[] | null;
  title?: string;
  variant?: string;
}

const props = withDefaults(defineProps<Props>(), {
  accept: '*',
  modelValue: null,
  title: '上传原文件',
  variant: 'blue'
});

const emit = defineEmits(['update:modelValue', 'file-selected', 'file-removed']);

const fileInput = ref<HTMLInputElement | null>(null);
const dragActive = ref(false);
const files = ref<File[]>([]);
const selectedFile = ref<File | null>(null);

// 当props.modelValue变化时，同步本地files数组
watch(() => props.modelValue, (newValue) => {
  if (newValue) {
    files.value = [...newValue];
    if (newValue.length > 0) {
      selectedFile.value = newValue[0];
    }
  } else {
    files.value = [];
    selectedFile.value = null;
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

// 触发文件选择器
const triggerFileInput = () => {
  if (fileInput.value) {
    fileInput.value.click();
  }
};

// 处理文件选择
const handleFileChange = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files.length > 0) {
    const newFiles = Array.from(input.files);
    const updatedFiles = [...files.value, ...newFiles];
    
    // 更新文件列表并触发事件
    files.value = updatedFiles;
    emit('update:modelValue', updatedFiles);
    
    if (newFiles.length > 0) {
      selectedFile.value = newFiles[0];
      emit('file-selected', newFiles[0]);
    }
  }
};

// 处理文件拖放
const handleFileDrop = (event: DragEvent) => {
  dragActive.value = false;
  
  if (event.dataTransfer?.files) {
    const newFiles = Array.from(event.dataTransfer.files);
    const updatedFiles = [...files.value, ...newFiles];
    
    // 更新文件列表并触发事件
    files.value = updatedFiles;
    emit('update:modelValue', updatedFiles);
    
    if (newFiles.length > 0) {
      selectedFile.value = newFiles[0];
      emit('file-selected', newFiles[0]);
    }
  }
};

// 移除特定文件
const removeFile = () => {
  // 创建新的文件数组，移除指定索引的文件
  const updatedFiles = [...files.value];
  updatedFiles.splice(0, 1);
  
  // 更新文件列表并触发事件
  files.value = updatedFiles;
  
  if (updatedFiles.length === 0) {
    emit('update:modelValue', null);
    selectedFile.value = null;
    emit('file-removed');
  } else {
    emit('update:modelValue', updatedFiles);
  }
};

function formatFileSize(bytes: number): string {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}
</script>

<style scoped>
.file-upload-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 15px;
}

.custom-upload-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 16px;
  color: #ffffff;
  background-color: #409eff;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.custom-upload-button:hover {
  background-color: #66b1ff;
}

.file-input {
  display: none;
}

.file-display {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  background-color: #f5f7fa;
  border-radius: 4px;
  border: 1px solid #e4e7ed;
}

.file-info {
  display: flex;
  gap: 5px;
  align-items: center;
}

.file-name {
  font-weight: 500;
  color: #303133;
  word-break: break-all;
}

.file-size {
  color: #909399;
  font-size: 12px;
}

.remove-file-btn {
  background: none;
  border: none;
  color: #f56c6c;
  cursor: pointer;
  font-size: 12px;
  padding: 2px 6px;
  border-radius: 3px;
}

.remove-file-btn:hover {
  background-color: #fef0f0;
}
</style> 