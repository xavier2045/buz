<template>
  <div class="mint-license-modal">
    <div class="modal-content">
      <div class="modal-header">
        <div class="header-text">
          <p>那么，我们继续</p>
          <p>其人购买许可需要多少钱？</p>
        </div>
        <div class="assistant-avatar">
          <img src="/images/girl-doing-namaste.png" alt="AE Assistant" />
        </div>
      </div>
      
      <div class="mint-price-options">
        <div class="input-container">
          <input 
            type="text" 
            class="mint-price-input" 
            placeholder="输入许可价格" 
            v-model="mintPrice"
            ref="priceInput"
            @keyup.enter="confirmPrice"
          />
          <div class="input-suffix">¥</div>
        </div>
      </div>
      
      <!-- 添加文件上传区域 -->
      <div class="file-upload-section">
        <div class="upload-label">上传原文件（必需）</div>
        <div 
          class="upload-area" 
          :class="{ 'drag-active': isDragging, 'has-files': uploadedFiles.length > 0 }"
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
          
          <div v-if="uploadedFiles.length === 0" class="upload-placeholder">
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
              <div v-for="(file, index) in uploadedFiles" :key="index" class="file-item">
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
      
      <div class="navigation-section">
        <button class="back-btn" @click="$emit('close')">
          <svg class="arrow-icon arrow-back" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M5 12h14M12 5l7 7-7 7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
          </svg>
          <span>取消</span>
        </button>
        
        <button class="uiverse" @click="confirmPrice" :disabled="!isValid">
          <div class="wrapper">
            <span>确认</span>
            <div class="circle circle-1"></div>
            <div class="circle circle-2"></div>
            <div class="circle circle-3"></div>
            <div class="circle circle-4"></div>
            <div class="circle circle-5"></div>
            <div class="circle circle-6"></div>
            <div class="circle circle-7"></div>
            <div class="circle circle-8"></div>
            <div class="circle circle-9"></div>
            <div class="circle circle-10"></div>
            <div class="circle circle-11"></div>
            <div class="circle circle-12"></div>
          </div>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';

const emit = defineEmits(['close', 'confirm']);

const mintPrice = ref('');
const priceInput = ref<HTMLInputElement | null>(null);
const fileInput = ref<HTMLInputElement | null>(null);
const uploadedFiles = ref<File[]>([]);
const isDragging = ref(false);

const isValidPrice = computed(() => {
  const price = mintPrice.value.trim();
  // 价格必须存在且为数字
  if (!price) return false;
  
  // 判断是否为有效的数字
  const numberPattern = /^[0-9]+(\.[0-9]{1,2})?$/;
  return numberPattern.test(price);
});

const isValid = computed(() => {
  return isValidPrice.value && uploadedFiles.value.length > 0;
});

const confirmPrice = () => {
  if (isValid.value) {
    emit('confirm', {
      price: mintPrice.value,
      files: uploadedFiles.value
    });
  } else if (isValidPrice.value && uploadedFiles.value.length === 0) {
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

const addFiles = (files: File[]) => {
  uploadedFiles.value = [...uploadedFiles.value, ...files];
};

const removeFile = (index: number) => {
  uploadedFiles.value = uploadedFiles.value.filter((_, i) => i !== index);
};

const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

onMounted(() => {
  // 自动聚焦到输入框
  if (priceInput.value) {
    priceInput.value.focus();
  }
});
</script>

<style scoped>
.mint-license-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  width: 100%;
  max-width: 800px;
  background: rgba(15, 15, 20, 0.85);
  border-radius: 16px;
  padding: 80px 30px 70px;
  position: relative;
  color: white;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
}

.modal-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 60px;
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

.header-text p:nth-child(2) {
  font-size: 20px;
  color: rgba(255, 255, 255, 0.9);
  margin: 5px 0;
}

.assistant-avatar {
  width: 120px;
  height: 120px;
  overflow: visible;
  background: transparent;
  margin-left: 0px;
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
  transform: translateX(-220px);
}

.mint-price-options {
  display: flex;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 30px;
}

.input-container {
  position: relative;
  width: 100%;
  height: 64px;
  display: flex;
  align-items: center;
}

.mint-price-input {
  width: 100%;
  height: 100%;
  padding: 10px 40px 10px 20px;
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background: rgba(25, 25, 30, 0.6);
  color: white;
  font-size: 17px;
  font-weight: 500;
  outline: none;
  transition: all 0.3s ease;
}

.mint-price-input:focus {
  background: rgba(40, 40, 45, 0.7);
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.input-suffix {
  position: absolute;
  right: 20px;
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
  font-size: 17px;
  pointer-events: none;
}

/* 文件上传区域样式 */
.file-upload-section {
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 40px;
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
  align-items: center;
  justify-content: center;
  padding: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: rgba(30, 30, 35, 0.3);
  position: relative;
}

.upload-area:hover {
  border-color: rgba(255, 255, 255, 0.4);
  background: rgba(40, 40, 45, 0.4);
}

.upload-area.drag-active {
  border-color: #4A90E2;
  background: rgba(74, 144, 226, 0.1);
}

.file-input {
  display: none;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.upload-icon {
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 15px;
}

.upload-text {
  font-size: 16px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
  margin: 0 0 5px 0;
}

.upload-description {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
}

.uploaded-files {
  width: 100%;
}

.file-list {
  width: 100%;
  max-height: 200px;
  overflow-y: auto;
  margin-bottom: 10px;
}

.file-item {
  display: flex;
  align-items: center;
  padding: 10px;
  background: rgba(40, 40, 45, 0.5);
  border-radius: 8px;
  margin-bottom: 8px;
}

.file-icon {
  color: rgba(255, 255, 255, 0.7);
  margin-right: 10px;
}

.file-name {
  flex: 1;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
}

.file-size {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin: 0 10px;
}

.remove-file {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  color: rgba(255, 255, 255, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.2s;
}

.remove-file:hover {
  background: rgba(255, 0, 0, 0.3);
}

.add-more-files {
  text-align: center;
  padding: 8px;
  border-radius: 8px;
  background: rgba(74, 144, 226, 0.1);
  color: #4A90E2;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.add-more-files:hover {
  background: rgba(74, 144, 226, 0.2);
}

.navigation-section {
  display: flex;
  justify-content: space-between;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
}

.back-btn {
  display: flex;
  align-items: center;
  padding: 10px 24px;
  border-radius: 24px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  margin: 0;
}

.back-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.2);
}

.back-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.arrow-icon {
  width: 32px;
  height: 32px;
  fill: none;
  stroke: currentColor;
}

.arrow-back {
  transform: rotate(180deg);
}

/* Uiverse button style */
.uiverse {
  --duration: 7s;
  --easing: linear;
  --c-color-1: #ffd58c;
  --c-color-2: #69a5ff;
  --c-color-3: #c29fff;
  --c-color-4: rgba(140, 232, 255, 0.8);
  --c-shadow: rgba(99, 85, 255, 0.7);
  --c-shadow-inset-top: rgba(132, 156, 255, 0.9);
  --c-shadow-inset-bottom: rgba(62, 145, 255, 0.7);
  --c-radial-inner: #2f3fbb;
  --c-radial-outer: #5264fa;
  --c-color: #ffffff;
  -webkit-tap-highlight-color: transparent;
  -webkit-appearance: none;
  outline: none;
  position: relative;
  cursor: pointer;
  border: none;
  display: table;
  border-radius: 24px;
  padding: 0;
  margin: 0;
  text-align: center;
  font-weight: 600;
  font-size: 16px;
  letter-spacing: 0.05em;
  line-height: 1.5;
  color: var(--c-color);
  background: radial-gradient(
    circle,
    var(--c-radial-inner),
    var(--c-radial-outer) 80%
  );
  box-shadow: 0 0 14px var(--c-shadow);
}

.uiverse:before {
  content: "";
  pointer-events: none;
  position: absolute;
  z-index: 3;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  border-radius: 28px;
  box-shadow:
    inset 0 3px 12px var(--c-shadow-inset-top),
    inset 0 -3px 4px var(--c-shadow-inset-bottom);
}

.uiverse .wrapper {
  -webkit-mask-image: -webkit-radial-gradient(white, black);
  overflow: hidden;
  border-radius: 26px;
  min-width: 132px;
  padding: 12px 24px;
}

.uiverse .wrapper span {
  display: inline-block;
  position: relative;
  z-index: 1;
}

.uiverse:hover {
  --duration: 1400ms;
}

.uiverse:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  --c-radial-inner: #6c6c6c;
  --c-radial-outer: #9c9c9c;
  --c-shadow: rgba(99, 99, 99, 0.59);
}

.uiverse:disabled .wrapper span {
  opacity: 0.8;
}

.uiverse:disabled .wrapper .circle {
  opacity: 0.5;
}

.uiverse .wrapper .circle {
  position: absolute;
  left: 0;
  top: 0;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  filter: blur(var(--blur, 8px));
  background: var(--background, transparent);
  transform: translate(var(--x, 0), var(--y, 0)) translateZ(0);
  animation-name: var(--animation) !important;
  animation-duration: var(--duration) !important;
  animation-timing-function: var(--easing) !important;
  animation-iteration-count: infinite !important;
}

.uiverse .wrapper .circle.circle-1,
.uiverse .wrapper .circle.circle-9,
.uiverse .wrapper .circle.circle-10 {
  --background: var(--c-color-4);
}

.uiverse .wrapper .circle.circle-3,
.uiverse .wrapper .circle.circle-4 {
  --background: var(--c-color-2);
  --blur: 14px;
}

.uiverse .wrapper .circle.circle-5,
.uiverse .wrapper .circle.circle-6 {
  --background: var(--c-color-3);
  --blur: 16px;
}

.uiverse .wrapper .circle.circle-2,
.uiverse .wrapper .circle.circle-7,
.uiverse .wrapper .circle.circle-8,
.uiverse .wrapper .circle.circle-11,
.uiverse .wrapper .circle.circle-12 {
  --background: var(--c-color-1);
  --blur: 12px;
}

.uiverse .wrapper .circle.circle-1 {
  --x: -30%;
  --y: -30%;
  --animation: c1;
}

.uiverse .wrapper .circle.circle-2 {
  --x: -25%;
  --y: 150%;
  --animation: c2;
}

.uiverse .wrapper .circle.circle-3 {
  --x: 150%;
  --y: -30%;
  --animation: c3;
}

.uiverse .wrapper .circle.circle-4 {
  --x: 100%;
  --y: 100%;
  --animation: c4;
}

.uiverse .wrapper .circle.circle-5 {
  --x: 80%;
  --y: -80%;
  --animation: c5;
}

.uiverse .wrapper .circle.circle-6 {
  --x: -70%;
  --y: -70%;
  --animation: c6;
}

.uiverse .wrapper .circle.circle-7 {
  --x: 100%;
  --y: -40%;
  --animation: c7;
}

.uiverse .wrapper .circle.circle-8 {
  --x: -100%;
  --y: -40%;
  --animation: c8;
}

.uiverse .wrapper .circle.circle-9 {
  --x: 40%;
  --y: 100%;
  --animation: c9;
}

.uiverse .wrapper .circle.circle-10 {
  --x: -80%;
  --y: 100%;
  --animation: c10;
}

.uiverse .wrapper .circle.circle-11 {
  --x: 60%;
  --y: -20%;
  --animation: c11;
}

.uiverse .wrapper .circle.circle-12 {
  --x: -40%;
  --y: 30%;
  --animation: c12;
}

@keyframes c1 {
  0%, 100% {
    transform: translate(-30%, -30%) translateZ(0);
  }
  25% {
    transform: translate(30%, 30%) translateZ(0);
  }
  50% {
    transform: translate(140%, -40%) translateZ(0);
  }
  75% {
    transform: translate(30%, 80%) translateZ(0);
  }
}

@keyframes c2 {
  0%, 100% {
    transform: translate(-25%, 150%) translateZ(0);
  }
  25% {
    transform: translate(-40%, 20%) translateZ(0);
  }
  50% {
    transform: translate(-80%, 50%) translateZ(0);
  }
  75% {
    transform: translate(50%, 80%) translateZ(0);
  }
}

@keyframes c3 {
  0%, 100% {
    transform: translate(150%, -30%) translateZ(0);
  }
  25% {
    transform: translate(30%, 40%) translateZ(0);
  }
  50% {
    transform: translate(80%, 20%) translateZ(0);
  }
  75% {
    transform: translate(50%, -30%) translateZ(0);
  }
}

@keyframes c4 {
  0%, 100% {
    transform: translate(100%, 100%) translateZ(0);
  }
  25% {
    transform: translate(120%, 30%) translateZ(0);
  }
  50% {
    transform: translate(80%, -30%) translateZ(0);
  }
  75% {
    transform: translate(-40%, 150%) translateZ(0);
  }
}

@keyframes c5 {
  0%, 100% {
    transform: translate(80%, -80%) translateZ(0);
  }
  25% {
    transform: translate(90%, 40%) translateZ(0);
  }
  50% {
    transform: translate(-20%, 140%) translateZ(0);
  }
  75% {
    transform: translate(50%, 50%) translateZ(0);
  }
}

@keyframes c6 {
  0%, 100% {
    transform: translate(-70%, -70%) translateZ(0);
  }
  25% {
    transform: translate(-40%, -40%) translateZ(0);
  }
  50% {
    transform: translate(40%, -30%) translateZ(0);
  }
  75% {
    transform: translate(10%, 30%) translateZ(0);
  }
}

@keyframes c7 {
  0%, 100% {
    transform: translate(100%, -40%) translateZ(0);
  }
  25% {
    transform: translate(40%, 20%) translateZ(0);
  }
  50% {
    transform: translate(10%, 90%) translateZ(0);
  }
  75% {
    transform: translate(30%, 60%) translateZ(0);
  }
}

@keyframes c8 {
  0%, 100% {
    transform: translate(-100%, -40%) translateZ(0);
  }
  25% {
    transform: translate(-20%, 20%) translateZ(0);
  }
  50% {
    transform: translate(-80%, 80%) translateZ(0);
  }
  75% {
    transform: translate(70%, -20%) translateZ(0);
  }
}

@keyframes c9 {
  0%, 100% {
    transform: translate(40%, 100%) translateZ(0);
  }
  25% {
    transform: translate(12%, 20%) translateZ(0);
  }
  50% {
    transform: translate(0%, -10%) translateZ(0);
  }
  75% {
    transform: translate(100%, 10%) translateZ(0);
  }
}

@keyframes c10 {
  0%, 100% {
    transform: translate(-80%, 100%) translateZ(0);
  }
  25% {
    transform: translate(-40%, 60%) translateZ(0);
  }
  50% {
    transform: translate(0%, 0%) translateZ(0);
  }
  75% {
    transform: translate(-60%, -70%) translateZ(0);
  }
}

@keyframes c11 {
  0%, 100% {
    transform: translate(60%, -20%) translateZ(0);
  }
  25% {
    transform: translate(120%, 20%) translateZ(0);
  }
  50% {
    transform: translate(120%, 120%) translateZ(0);
  }
  75% {
    transform: translate(-20%, 100%) translateZ(0);
  }
}

@keyframes c12 {
  0%, 100% {
    transform: translate(-40%, 30%) translateZ(0);
  }
  25% {
    transform: translate(-20%, -40%) translateZ(0);
  }
  50% {
    transform: translate(0%, -100%) translateZ(0);
  }
  75% {
    transform: translate(40%, 30%) translateZ(0);
  }
}

@media (max-width: 767px) {
  .modal-content {
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
  
  .header-text p:nth-child(2) {
    font-size: 18px;
  }
  
  .navigation-section {
    flex-direction: column;
    gap: 16px;
  }
  
  .back-btn {
    width: 100%;
    justify-content: center;
  }
  
  .uiverse {
    width: 100%;
  }
  
  .uiverse .wrapper {
    width: 100%;
    text-align: center;
  }
}
</style> 