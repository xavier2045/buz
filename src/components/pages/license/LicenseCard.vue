<template>
  <div 
    class="license-card" 
    :class="{ selected: isSelected, [licenseClass]: true }"
    @click="selectOrDeselect"
  >
    <div class="license-header">
      <span :class="['license-tag', license.tagStyle]">
        <i v-if="license.tagIcon !== 'ai' && license.id !== 'non-commercial' && license.id !== 'commercial' && license.id !== 'commercial-remix'" class="license-icon">{{ license.tagIcon }}</i>
        <svg v-else-if="license.id === 'open'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60" id="Open" width="20" height="20" class="license-icon">
          <path d="M25 22.5h10v-7.5h7.5L30 2.5 17.5 15h7.5v7.5zm-2.5 2.5h-7.5v-7.5L2.5 30l12.5 12.5v-7.5h7.5v-10zm35 5L45 17.5v7.5h-7.5v10H45v7.5L57.5 30zM32.5 40h-10v7.5h-7.5L30 60l15-12.5h-7.5V40z" fill="rgb(50, 170, 255)" class="color000000 svgShape"></path>
          <path fill="none" d="M0 0h60v60H0z"></path>
        </svg>
        <svg v-else-if="license.id === 'non-commercial'" xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 60 60" viewBox="0 0 60 60" id="like" width="20" height="20" class="license-icon">
          <path d="M40.41,27.84h-7.08c-0.36,0-0.69-0.19-0.87-0.5c-0.18-0.31-0.18-0.69,0-1c0.08-0.13,1.88-3.44,0.02-7.73
          c-0.14-0.32-0.45-0.53-0.8-0.53c-0.47,0-0.86,0.38-0.86,0.86v3.02c0,0.2-0.06,0.4-0.18,0.57l-4.94,7.08
          c-0.19,0.27-0.49,0.43-0.82,0.43h-0.57v8.74c0.97,0.72,2.14,1.13,3.35,1.13h9.52c0.41,0,0.75-0.34,0.75-0.75
          c0-0.41-0.34-0.75-0.75-0.75h-0.53c-0.55,0-1-0.45-1-1s0.45-1,1-1h2.28c0.21,0,0.38-0.17,0.38-0.38v-0.57
          c0-0.21-0.17-0.38-0.38-0.38h-1.3c-0.55,0-1-0.45-1-1s0.45-1,1-1h2.07c0.37,0,0.67-0.3,0.67-0.67s-0.3-0.67-0.67-0.67h-1.91
          c-0.55,0-1-0.45-1-1s0.45-1,1-1h2.6c0.52,0,0.95-0.43,0.95-0.95S40.94,27.84,40.41,27.84z" fill="rgb(212, 121, 232)"></path>
          <path d="M53.08,27.02c-0.49-0.44-1.15-1.03-1.22-1.37c-0.07-0.38,0.31-1.17,0.61-1.8c0.52-1.08,1.1-2.3,0.64-3.42
          c-0.48-1.14-1.77-1.6-2.9-2c-0.66-0.23-1.47-0.51-1.68-0.81c-0.2-0.31-0.16-1.18-0.12-1.88c0.07-1.2,0.14-2.55-0.73-3.42
          c-0.86-0.87-2.22-0.79-3.42-0.73c-0.7,0.04-1.57,0.09-1.88-0.12c-0.3-0.2-0.58-1.02-0.81-1.67c-0.4-1.14-0.85-2.43-1.99-2.9
          c-1.13-0.47-2.35,0.11-3.42,0.63c-0.64,0.3-1.42,0.69-1.81,0.61c-0.34-0.07-0.93-0.73-1.37-1.21C32.17,6.02,31.25,5,30,5
          s-2.16,1.02-2.98,1.93C26.59,7.41,26,8.07,25.66,8.14c-0.38,0.07-1.17-0.31-1.81-0.61c-1.07-0.52-2.29-1.1-3.42-0.64
          c-1.14,0.48-1.59,1.77-1.99,2.91c-0.23,0.65-0.52,1.47-0.82,1.67c-0.3,0.2-1.17,0.16-1.87,0.12c-1.2-0.06-2.56-0.14-3.42,0.73
          c-0.87,0.86-0.8,2.22-0.73,3.42c0.03,0.7,0.08,1.57-0.13,1.88c-0.2,0.3-1.01,0.58-1.67,0.81c-1.13,0.4-2.42,0.86-2.9,2
          c-0.46,1.12,0.12,2.34,0.64,3.42c0.3,0.63,0.68,1.42,0.61,1.8c-0.07,0.34-0.73,0.93-1.22,1.37C6.03,27.83,5,28.75,5,30
          s1.03,2.17,1.93,2.98c0.49,0.43,1.15,1.02,1.22,1.37c0.07,0.37-0.31,1.16-0.61,1.8c-0.52,1.07-1.1,2.29-0.64,3.42
          c0.48,1.14,1.76,1.59,2.9,1.99c0.66,0.23,1.47,0.52,1.67,0.82c0.21,0.3,0.16,1.17,0.13,1.87c-0.07,1.2-0.14,2.56,0.73,3.42
          c0.86,0.87,2.22,0.8,3.42,0.73c0.7-0.03,1.57-0.08,1.87,0.13c0.3,0.2,0.59,1.01,0.82,1.67c0.4,1.14,0.85,2.43,1.99,2.9
          c1.12,0.46,2.35-0.12,3.42-0.63c0.64-0.31,1.43-0.69,1.8-0.61c0.35,0.06,0.94,0.73,1.37,1.21C27.84,53.97,28.75,55,30,55
          s2.17-1.03,2.98-1.93c0.44-0.48,1.03-1.15,1.37-1.21c0.38-0.08,1.17,0.3,1.81,0.61c1.07,0.51,2.29,1.09,3.41,0.63
          c1.15-0.47,1.6-1.76,2-2.9c0.23-0.66,0.51-1.47,0.81-1.67c0.31-0.21,1.18-0.16,1.88-0.12c1.2,0.06,2.55,0.13,3.42-0.73
          c0.87-0.87,0.79-2.23,0.73-3.43c-0.04-0.69-0.08-1.56,0.12-1.87c0.21-0.3,1.02-0.59,1.67-0.82c1.14-0.4,2.43-0.85,2.91-1.99
          c0.46-1.12-0.12-2.34-0.64-3.42c-0.3-0.64-0.68-1.43-0.61-1.8c0.07-0.35,0.73-0.94,1.22-1.37C53.98,32.17,55,31.25,55,30
          S53.98,27.83,53.08,27.02z M42.1,31.21c0.18,0.36,0.29,0.77,0.29,1.2c0,0.93-0.48,1.75-1.2,2.23c0.09,0.26,0.15,0.53,0.15,0.82v0.57
          c0,1.02-0.64,1.88-1.54,2.23c0.1,0.28,0.15,0.59,0.15,0.9c0,1.52-1.23,2.75-2.75,2.75h-9.52c-1.19,0-2.34-0.28-3.39-0.8
          c-0.1,0.45-0.48,0.8-0.96,0.8h-5.69c-0.55,0-1-0.45-1-1V27.98c0-0.55,0.45-1,1-1h5.69c0.55,0,1,0.45,1,1v0.06h0.05l4.46-6.39v-2.71
          c0-1.57,1.28-2.86,2.86-2.86c1.14,0,2.17,0.68,2.63,1.74c1.48,3.41,1.02,6.35,0.49,8.02h5.59c1.63,0,2.95,1.32,2.95,2.95
          C43.37,29.79,42.87,30.68,42.1,31.21z" fill="rgb(212, 121, 232)"></path>
          <rect width="3.69" height="10.93" x="18.64" y="28.98" fill="rgb(212, 121, 232)"></rect>
        </svg>
        <svg v-else-if="license.id === 'commercial'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" id="yuan" width="20" height="20" class="license-icon">
          <g>
            <path d="M466.125 382.347H351.06a196.785 196.785 0 0 1-82.483 57.75h197.548a28.875 28.875 0 1 0 0-57.75zm0-80.51a28.875 28.875 0 1 0 0-57.75h-69.296c.236 3.962.355 7.947.355 11.91a196.959 196.959 0 0 1-5.384 45.84zm-29.84 11.38h-47.58a194.003 194.003 0 0 1-28.726 57.75h76.306a28.875 28.875 0 1 0 0-57.75zm9.52-81.13a28.87 28.87 0 1 0 0-57.74H379.42a194.062 194.062 0 0 1 16.322 57.74z" fill="rgb(46, 204, 113)"></path>
            <path d="M201.094 71.906C99.584 71.906 17 154.49 17 256s82.584 184.094 184.094 184.094S385.188 357.51 385.188 256 302.604 71.906 201.094 71.906Zm2.002 327.62c-80.73 1.107-146.636-64.8-145.529-145.53 1.062-77.421 64.104-140.462 141.525-141.523 80.732-1.106 146.636 64.8 145.53 145.53-1.062 77.422-64.104 140.463-141.526 141.524Z" fill="rgb(46, 204, 113)"></path>
            <path d="M163.966 170.965h.17a15.346 15.346 0 0 1 14.007 9.076l20.049 44.78a3.257 3.257 0 0 0 5.942.01l20.249-44.836a15.346 15.346 0 0 1 13.985-9.03 15.346 15.346 0 0 1 13.986 21.664l-25.269 55.944a1.699 1.699 0 0 0 1.548 2.398h18.592a9.422 9.422 0 0 1 9.422 9.422 9.423 9.423 0 0 1-9.422 9.423h-29.771v14.799h29.424a9.77 9.77 0 0 1 9.77 9.77 9.77 9.77 0 0 1-9.77 9.768h-29.424v20.522a16.36 16.36 0 0 1-16.36 16.36 16.36 16.36 0 0 1-16.36-16.36v-20.522h-29.423a9.77 9.77 0 0 1-9.77-9.769 9.77 9.77 0 0 1 9.77-9.77h29.424v-14.798h-29.771a9.423 9.423 0 0 1-9.423-9.423 9.422 9.422 0 0 1 9.423-9.422h18.516a1.699 1.699 0 0 0 1.55-2.393l-25.07-55.995a15.346 15.346 0 0 1 14.006-21.618Z" fill="rgb(46, 204, 113)"></path>
          </g>
        </svg>
        <svg v-else-if="license.id === 'commercial-remix'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" id="encouragement" width="20" height="20" class="license-icon">
          <path d="M11.76243 34.003V20.88462A4.00874 4.00874 0 007.7629 16.88509H5.30318a1.0028 1.0028 0 00-.99989.99988V37.00269a1.00284 1.00284 0 00.99989.99988H7.7629A4.00143 4.00143 0 0011.76243 34.003zM17.03182 36.9427H28.95038a7.69975 7.69975 0 007.58906-6.58924l1.10991-7.789A4.04219 4.04219 0 0033.65977 17.955h-7.629V8.27607c0-1.14982-.58-2.78964-3.31955-4.05945a2.22678 2.22678 0 00-3.1397 2.24967c.59881 3.52882-1.05633 11.2417-5.96956 13.05826a5.41159 5.41159 0 01.16026 1.36007c-.0783.83632.20322 14.34039-.21 14.68824A5.14722 5.14722 0 0017.03182 36.9427zM58.69682 38.88247H56.2371A4.00882 4.00882 0 0052.23757 42.882V56.00042a4.00128 4.00128 0 003.99953 3.99952h2.45972a1.00284 1.00284 0 00.99989-.99988V39.88235A1.00279 1.00279 0 0058.69682 38.88247z" fill="rgb(231, 102, 85)"></path>
          <path d="M50.23781 42.882a5.61287 5.61287 0 01.16-1.36983 9.1529 9.1529 0 01-4.6795-4.83945 16.45374 16.45374 0 01-1.28982-8.209A2.23064 2.23064 0 0041.27886 26.214c-2.72965 1.2698-3.3096 2.90962-3.3096 4.05945v9.6789h-7.629a4.04071 4.04071 0 00-3.98952 4.59942l1.10985 7.79906a7.69975 7.69975 0 007.58906 6.58924H46.96818a5.10978 5.10978 0 003.47963-1.37984C50.03142 57.22934 50.31825 43.70294 50.23781 42.882zM16.32188 45.96158a6.5607 6.5607 0 01-3.45961-2.51966 1.03111 1.03111 0 00-1.64977 0 6.57983 6.57983 0 01-3.45961 2.5196c-1.75839.79354.23954 2.15544.51 3.47968a5.80964 5.80964 0 01.28995 2.11968 1.00559 1.00559 0 001.33986.98994 6.53983 6.53983 0 014.27946 0 1.01172 1.01172 0 001.34988-.98994 6.12679 6.12679 0 011.30984-4.02948A1.00543 1.00543 0 0016.32188 45.96158zM52.28756 9.96587A6.48458 6.48458 0 0148.828 7.44622a1.04121 1.04121 0 00-1.65984 0 6.4847 6.4847 0 01-3.45955 2.51959c-1.73258.81894.21916 2.08545.50989 3.47969a5.82254 5.82254 0 01.3 2.11968.9984.9984 0 001.33981.98993 6.54016 6.54016 0 014.27952 0 1.00059 1.00059 0 001.33981-.98993 6.21369 6.21369 0 011.30984-4.02949A1.00957 1.00957 0 0052.28756 9.96587z" fill="rgb(231, 102, 85)"></path>
        </svg>
        <svg v-else xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="20" height="20" enable-background="new 0 0 48 48" version="1.1" viewBox="0 0 48 48" class="license-icon">
          <g>
            <path d="M26.2,32.5l-1.5-3.4h-6.6l-1.5,3.4h-3.7l6.8-15.7h3.4l6.8,15.7H26.2z M34.8,32.5h-3.4V20.4h3.4V32.5z M34.5,18.9c-0.4,0.4-0.9,0.6-1.4,0.6c-0.6,0-1-0.2-1.4-0.6c-0.4-0.4-0.6-0.9-0.6-1.4c0-0.6,0.2-1,0.6-1.4c0.4-0.4,0.9-0.6,1.4-0.6c0.6,0,1,0.2,1.4,0.6c0.4,0.4,0.6,0.9,0.6,1.4C35.1,18,34.9,18.5,34.5,18.9z"></path>
            <polygon points="19.5 26 23.4 26 21.4 21.5"></polygon>
          </g>
        </svg>
        {{ license.tagText }}
      </span>
      <span v-if="isRecommended" class="recommended-tag">推荐</span>
    </div>
    <h2>{{ license.name }}</h2>
    <div class="license-content">
      <p class="license-description-zh">{{ license.description }}</p>
      
      <!-- 修改上传文件按钮，删除上传文件的文字提示 -->
      <div class="file-upload-toggle" 
           @click.stop="toggleFileUpload"
           :class="{ 'highlight-upload': false }">
        <div class="toggle-header">
          <span class="toggle-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
              <polyline points="17 8 12 3 7 8"></polyline>
              <line x1="12" y1="3" x2="12" y2="15"></line>
            </svg>
          </span>
          <span class="toggle-text">
            原文件上传
          </span>
          <span class="toggle-arrow" :class="{ 'rotated': showFileUpload }">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 30 30" id="down">
              <g>
                <g id="arrow" fill="none" fill-rule="evenodd" stroke="none" stroke-width="1">
                  <path id="arrow_011-down-bottom-download-direction" fill="currentColor" d="M162 104.5c0-6.904-5.596-12.5-12.5-12.5S137 97.596 137 104.5s5.596 12.5 12.5 12.5 12.5-5.596 12.5-12.5zm-12.853 8.354l-6-6a.5.5 0 0 1 .354-.854h3.5v-8.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 .5.5v8.5h3.5a.5.5 0 0 1 .354.854l-6 6a.5.5 0 0 1-.708 0z" transform="translate(-135 -90)"></path>
                </g>
              </g>
            </svg>
          </span>
        </div>
      </div>
      
      <!-- 文件上传组件（隐藏/显示） -->
      <div v-if="showFileUpload" class="file-upload-container">
        <FileUpload 
          v-model="file"
          :variant="fileUploadVariant"
          :description="isRequired ? '必须上传原文件' : '可选上传原文件'"
          @update:modelValue="handleFileUpload"
        />
      </div>

      <!-- 添加已上传文件水平滚动容器 -->
      <div class="uploaded-files-container" v-if="uploadedFiles && uploadedFiles.length > 0">
        <div class="uploaded-files-scroll">
          <div v-for="(file, index) in uploadedFiles" :key="index" class="uploaded-file-item">
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
    </div>
    <div class="license-footer" :class="licenseFooterClass">
      <div class="license-icons" :class="licenseIconsClass">
        <div v-if="uploadedFiles && uploadedFiles.length > 0" class="uploaded-files-indicator">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
          </svg>
          <span>{{ uploadedFiles.length }}</span>
        </div>
      </div>
      <div class="check-indicator" v-if="isSelected">✓</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import FileUpload from '../../ui/FileUpload.vue';

const props = defineProps({
  license: {
    type: Object,
    required: true
  },
  isSelected: {
    type: Boolean,
    default: false
  },
  isRecommended: {
    type: Boolean,
    default: false
  },
  uploadedFiles: {
    type: Array as () => File[],
    default: () => []
  }
});

const file = ref<File | File[] | null>(null);
const showFileUpload = ref(false);

// 监听uploadedFiles的变化，更新本地file值
watch(() => props.uploadedFiles, (newFiles) => {
  if (newFiles && newFiles.length > 0) {
    file.value = newFiles;
  }
}, { immediate: true });

// 文件上传处理
const handleFileUpload = (newFiles: File | File[] | null) => {
  file.value = newFiles;
  if (newFiles) {
    emit('file-upload', {
      licenseId: props.license.id,
      file: newFiles
    });
  }
};

// 添加选择或取消选择的方法
const selectOrDeselect = () => {
  emit('select', props.license.id);
};

// 切换文件上传显示/隐藏
const toggleFileUpload = (event: Event) => {
  event.stopPropagation();
  // 仅切换上传区域的显示状态，不直接触发文件上传
  showFileUpload.value = !showFileUpload.value;
};

// 根据许可证类型设置变体颜色
const fileUploadVariant = computed(() => {
  const variantMap: Record<string, string> = {
    'open': 'blue',
    'non-commercial': 'purple',
    'commercial': 'green',
    'commercial-remix': 'red'
  };
  return variantMap[props.license.id] || 'blue';
});

// 是否为必需上传
const isRequired = computed(() => {
  return props.license.id === 'commercial' || props.license.id === 'commercial-remix';
});

const emit = defineEmits(['select', 'file-upload']);

const licenseClass = computed(() => {
  return `license-${props.license.id}`;
});

const licenseFooterClass = computed(() => {
  return `license-footer-${props.license.id}`;
});

const licenseIconsClass = computed(() => {
  return `license-icons-${props.license.id}`;
});

// 格式化文件大小的辅助函数
const formatFileSize = (size: number): string => {
  if (size < 1024) {
    return `${size} B`;
  } else if (size < 1024 * 1024) {
    return `${(size / 1024).toFixed(1)} KB`;
  } else if (size < 1024 * 1024 * 1024) {
    return `${(size / (1024 * 1024)).toFixed(1)} MB`;
  } else {
    return `${(size / (1024 * 1024 * 1024)).toFixed(1)} GB`;
  }
};
</script>

<style scoped>
.license-card {
  background: rgba(30, 30, 35, 0.6);
  border-radius: 12px;
  padding: 25px;
  display: flex;
  flex-direction: column;
  transition: all 0.25s;
  position: relative;
  overflow: visible;
  cursor: pointer;
  border: 1px solid transparent;
  height: auto;
  min-height: 250px;
}

.license-card:hover {
  background: rgba(40, 40, 45, 0.8);
  transform: translateY(-4px);
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.3);
}

.license-card.selected {
  border-color: rgba(255, 255, 255, 0.8);
  background: rgba(50, 50, 55, 0.8);
  transform: translateY(-4px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4);
}

.license-header {
  margin-bottom: 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.license-tag {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 500;
  gap: 6px;
}

.recommended-tag {
  background: rgba(46, 204, 113, 0.2);
  color: rgb(46, 204, 113);
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 4px;
}

.recommended-tag::before {
  content: "✓";
  font-size: 12px;
}

.license-icon {
  font-style: normal;
}

.license-card h2 {
  font-size: 20px;
  margin-bottom: 14px;
  color: white;
}

.license-description-zh {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.5;
  margin-bottom: 20px;
}

.file-requirement-notice {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 4px;
  font-size: 13px;
  margin-bottom: 15px;
  background-color: rgba(0, 0, 0, 0.2);
  color: rgba(255, 255, 255, 0.9);
}

.file-requirement-notice.required {
  /* 删除边框样式 */
}

.file-requirement-notice.optional {
  /* 删除边框样式 */
}

.license-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
}

.license-icons {
  display: flex;
  gap: 12px;
}

.uploaded-files-indicator {
  display: flex;
  align-items: center;
  gap: 4px;
  background-color: rgba(255, 255, 255, 0.15);
  padding: 4px 8px;
  border-radius: 16px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
}

.uploaded-files-indicator svg {
  color: currentColor;
}

.license-open .uploaded-files-indicator {
  background-color: rgba(50, 170, 255, 0.2);
  color: rgb(50, 170, 255);
}

.license-non-commercial .uploaded-files-indicator {
  background-color: rgba(212, 121, 232, 0.2);
  color: rgb(212, 121, 232);
}

.license-commercial .uploaded-files-indicator {
  background-color: rgba(46, 204, 113, 0.2);
  color: rgb(46, 204, 113);
}

.license-commercial-remix .uploaded-files-indicator {
  background-color: rgba(231, 102, 85, 0.2);
  color: rgb(231, 102, 85);
}

.icon {
  opacity: 0.7;
  transition: opacity 0.2s;
  font-size: 16px;
}

.check-indicator {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: white;
  color: #333;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}

/* 标签颜色样式 */
.blue {
  background: rgba(0, 140, 255, 0.2);
  color: rgb(50, 170, 255);
}

.purple {
  background: rgba(190, 75, 219, 0.2);
  color: rgb(212, 121, 232);
}

.green {
  background: rgba(46, 204, 113, 0.2);
  color: rgb(46, 204, 113);
}

.red {
  background: rgba(231, 76, 60, 0.2);
  color: rgb(231, 102, 85);
}

/* 特定许可证样式 */
.license-open {
  background: linear-gradient(135deg, rgba(30, 30, 35, 0.7), rgba(0, 80, 120, 0.3));
}

.license-non-commercial {
  background: linear-gradient(135deg, rgba(30, 30, 35, 0.7), rgba(140, 0, 170, 0.3));
}

.license-commercial {
  background: linear-gradient(135deg, rgba(30, 30, 35, 0.7), rgba(0, 120, 50, 0.3));
}

.license-commercial-remix {
  background: linear-gradient(135deg, rgba(30, 30, 35, 0.7), rgba(150, 40, 30, 0.3));
}

/* 文件上传切换按钮样式 */
.file-upload-toggle {
  background-color: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  padding: 10px 16px;
  cursor: pointer;
  margin-bottom: 15px;
  user-select: none;
  transition: all 0.2s ease;
}

.file-upload-toggle:hover {
  background-color: rgba(0, 0, 0, 0.3);
}

.toggle-header {
  display: flex;
  align-items: center;
  gap: 10px;
}

.toggle-icon {
  display: flex;
  align-items: center;
}

.toggle-icon svg {
  stroke: currentColor;
  width: 16px;
  height: 16px;
}

/* 为不同许可证类型设置图标颜色 */
.license-open .toggle-icon {
  color: #32aaff;
}

.license-non-commercial .toggle-icon {
  color: #d479e8;
}

.license-commercial .toggle-icon {
  color: #2ecc71;
}

.license-commercial-remix .toggle-icon {
  color: #e76655;
}

.toggle-text {
  flex: 1;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  gap: 6px;
}

.warning-icon {
  width: 20px;
  height: 20px;
  transform: translateY(-2px);
}

.toggle-arrow {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-left: auto;
  transition: transform 0.3s ease;
}

.toggle-arrow svg {
  width: 16px;
  height: 16px;
}

.toggle-arrow.rotated {
  transform: rotate(180deg);
}

/* 为不同许可证类型设置箭头颜色 */
.license-open .toggle-arrow {
  color: #32aaff;
}

.license-non-commercial .toggle-arrow {
  color: #d479e8;
}

.license-commercial .toggle-arrow {
  color: #2ecc71;
}

.license-commercial-remix .toggle-arrow {
  color: #e76655;
}

.file-upload-container {
  margin-top: 10px;
  animation: slideDown 0.3s ease forwards;
  max-height: 300px; /* 设置最大高度，防止内容过多时影响布局 */
  overflow: hidden;
  width: 100%;
  border-radius: 8px;
}

@keyframes slideDown {
  from {
    opacity: 0;
    max-height: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    max-height: 500px;
    transform: translateY(0);
  }
}

/* 新增已上传文件的水平滚动样式 */
.uploaded-files-container {
  margin-top: 15px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding-top: 10px;
}

.uploaded-files-scroll {
  display: flex;
  overflow-x: auto;
  gap: 8px;
  padding-bottom: 5px;
  scrollbar-width: thin;
  scrollbar-color: rgba(255, 255, 255, 0.2) transparent;
}

.uploaded-files-scroll::-webkit-scrollbar {
  height: 4px;
}

.uploaded-files-scroll::-webkit-scrollbar-track {
  background: transparent;
}

.uploaded-files-scroll::-webkit-scrollbar-thumb {
  background-color: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
}

.uploaded-file-item {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 6px;
  padding: 8px 12px;
  font-size: 12px;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 100px;
  max-width: 150px;
  flex: 0 0 auto;
}

.file-type-icon {
  margin-bottom: 5px;
  opacity: 0.7;
}

.file-name-truncate {
  width: 100%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: center;
  color: rgba(255, 255, 255, 0.9);
}

.file-size-info {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.5);
  margin-top: 2px;
}

/* 添加必须上传文件的提示样式 */
.file-required-alert {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px;
  border-radius: 6px;
  margin-bottom: 15px;
  background-color: rgba(231, 76, 60, 0.15);
  color: #e74c3c;
  font-weight: 500;
  animation: pulse 1.5s infinite;
}

.file-required-alert .warning-icon {
  width: 18px;
  height: 18px;
  stroke: #e74c3c;
}

/* 高亮上传区域 */
.file-upload-toggle.highlight-upload {
  border: 2px dashed #e74c3c;
  background-color: rgba(231, 76, 60, 0.1);
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% {
    opacity: 0.8;
  }
  50% {
    opacity: 1;
    box-shadow: 0 0 5px rgba(231, 76, 60, 0.3);
  }
  100% {
    opacity: 0.8;
  }
}
</style> 