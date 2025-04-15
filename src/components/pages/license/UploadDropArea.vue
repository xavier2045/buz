<template>
  <div 
    class="upload-drop-area"
    :class="{ 'drag-active': dragActive, 'mandatory': isMandatory }"
    @click="handleClick"
    @dragover.prevent
    @dragenter.prevent="dragActive = true"
    @dragleave.prevent="dragActive = false"
    @drop="handleDrop"
  >
    <div class="close-area" @click.stop="handleClose">×</div>
    <div class="upload-icon">
      <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 30 30" id="down">
        <g>
          <g id="arrow" fill="none" fill-rule="evenodd" stroke="none" stroke-width="1">
            <path id="arrow_011-down-bottom-download-direction" fill="currentColor" d="M162 104.5c0-6.904-5.596-12.5-12.5-12.5S137 97.596 137 104.5s5.596 12.5 12.5 12.5 12.5-5.596 12.5-12.5zm-12.853 8.354l-6-6a.5.5 0 0 1 .354-.854h3.5v-8.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 .5.5v8.5h3.5a.5.5 0 0 1 .354.854l-6 6a.5.5 0 0 1-.708 0z" transform="translate(-135 -90)"></path>
          </g>
        </g>
      </svg>
    </div>
    <div class="upload-text">
      <p>点击或拖放文件至此处</p>
      <p class="upload-description">支持上传多个原文件</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits } from 'vue';

const props = defineProps({
  licenseId: {
    type: String,
    required: true
  },
  isMandatory: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['click', 'file-drop', 'close']);
const dragActive = ref(false);

// 处理点击事件
const handleClick = () => {
  emit('click', props.licenseId);
};

// 处理拖放
const handleDrop = (e: DragEvent) => {
  e.preventDefault();
  dragActive.value = false;
  if (e.dataTransfer?.files.length) {
    const filesArray = Array.from(e.dataTransfer.files) as File[];
    emit('file-drop', {
      licenseId: props.licenseId,
      files: filesArray
    });
  }
};

// 处理关闭
const handleClose = (e: Event) => {
  e.stopPropagation(); // 阻止冒泡，避免触发点击事件
  emit('close');
};
</script>

<style scoped>
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

.upload-drop-area.mandatory {
  border-color: #ff9800;
}

.upload-drop-area .upload-icon {
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.upload-drop-area .upload-icon svg {
  width: 30px;
  height: 30px;
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

/* 添加关闭按钮样式 */
.upload-drop-area .close-area {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  cursor: pointer;
  z-index: 2;
}

.upload-drop-area .close-area:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style> 