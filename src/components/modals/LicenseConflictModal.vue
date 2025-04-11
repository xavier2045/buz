<template>
  <div class="license-conflict-modal">
    <div class="modal-content">
      <header class="modal-header">
        <h2>许可证冲突</h2>
        <span class="close-btn" @click="$emit('close')">×</span>
      </header>
      <div class="modal-body">
        <div class="conflict-icon">
          <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="80" height="80" enable-background="new 0 0 48 48" version="1.1" viewBox="0 0 48 48">
            <g>
              <path fill="#000000" d="M26.2,32.5l-1.5-3.4h-6.6l-1.5,3.4h-3.7l6.8-15.7h3.4l6.8,15.7H26.2z M34.8,32.5h-3.4V20.4h3.4V32.5z M34.5,18.9c-0.4,0.4-0.9,0.6-1.4,0.6c-0.6,0-1-0.2-1.4-0.6c-0.4-0.4-0.6-0.9-0.6-1.4c0-0.6,0.2-1,0.6-1.4c0.4-0.4,0.9-0.6,1.4-0.6c0.6,0,1,0.2,1.4,0.6c0.4,0.4,0.6,0.9,0.6,1.4C35.1,18,34.9,18.5,34.5,18.9z"></path>
              <polygon fill="#000000" points="19.5 26 23.4 26 21.4 21.5"></polygon>
            </g>
          </svg>
        </div>
        <div class="conflict-info">
          <p class="conflict-title">无法添加以下许可证：</p>
          <div class="conflict-license new-license">
            <span class="license-tag">{{ conflictData.newLicenseName }}</span>
          </div>
          
          <p class="conflict-title">已选择的冲突许可证：</p>
          <div class="conflict-license existing-license">
            <span class="license-tag" v-for="license in conflictData.conflictingLicenses" :key="license">
              {{ getLicenseName(license) }}
            </span>
          </div>
          
          <p class="conflict-reason">
            <span class="reason-label">冲突原因：</span>
            {{ conflictData.reason }}
          </p>
        </div>
        
        <div class="valid-combinations">
          <h3>有效的许可证组合</h3>
          <div class="combination">
            <div class="combination-group">
              <span class="license-tag blue">开放使用</span>
              <span class="combination-note">（单独使用）</span>
            </div>
          </div>
          <div class="combination">
            <div class="combination-group">
              <span class="license-tag purple">非商业混音</span>
              <span class="plus-sign">+</span>
              <span class="license-tag green">商业使用</span>
              <span class="plus-sign">+</span>
              <span class="license-tag red">商业混音</span>
              <span class="combination-note">（可任意组合）</span>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="modal-btn cancel-btn" @click="$emit('close')">我知道了</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  conflictData: {
    type: Object,
    required: true
  }
});

defineEmits(['close']);

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
</script>

<style scoped>
.license-conflict-modal {
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
  width: 90%;
  max-width: 600px;
  background: #1c1c1e;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  max-height: 90vh;
}

.modal-header {
  padding: 20px;
  background: #2c2c2e;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header h2 {
  margin: 0;
  font-size: 20px;
  color: white;
}

.close-btn {
  font-size: 24px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.7);
  transition: all 0.2s;
}

.close-btn:hover {
  color: white;
}

.modal-body {
  padding: 20px;
  overflow-y: auto;
}

.conflict-icon {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.conflict-icon svg {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  padding: 15px;
}

.conflict-icon svg path, .conflict-icon svg polygon {
  fill: white;
}

.conflict-info {
  margin-bottom: 30px;
}

.conflict-title {
  font-size: 16px;
  color: white;
  margin-bottom: 10px;
}

.conflict-license {
  margin-bottom: 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.license-tag {
  display: inline-block;
  padding: 6px 12px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  font-size: 14px;
}

.license-tag.blue {
  background: rgba(33, 150, 243, 0.2);
  color: rgb(33, 150, 243);
}

.license-tag.purple {
  background: rgba(156, 39, 176, 0.2);
  color: rgb(156, 39, 176);
}

.license-tag.green {
  background: rgba(76, 175, 80, 0.2);
  color: rgb(76, 175, 80);
}

.license-tag.red {
  background: rgba(244, 67, 54, 0.2);
  color: rgb(244, 67, 54);
}

.conflict-reason {
  font-size: 14px;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.8);
}

.reason-label {
  font-weight: 500;
  color: white;
  margin-right: 5px;
}

.valid-combinations {
  margin-top: 20px;
  padding: 15px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
}

.valid-combinations h3 {
  font-size: 16px;
  margin-top: 0;
  margin-bottom: 15px;
  color: white;
}

.combination {
  margin-bottom: 15px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.combination-group {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.plus-sign {
  color: rgba(255, 255, 255, 0.7);
}

.combination-note {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  margin-left: 10px;
}

.modal-footer {
  padding: 15px 20px;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-btn {
  padding: 8px 20px;
  border-radius: 6px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s;
}

.cancel-btn {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.cancel-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}
</style> 