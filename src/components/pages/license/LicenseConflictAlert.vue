<template>
  <div class="license-conflict-alert" :class="{ visible: isVisible }">
    <div class="alert-content">
      <div class="alert-icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
      </div>
      <div class="alert-message">
        <h3>许可证冲突提示</h3>
        <p>{{ conflictReason }}</p>
        
        <div class="conflict-details">
          <div class="conflict-license-section">
            <span class="section-label">有效的许可证组合:</span>
            <div class="license-combinations">
              <div class="combination">
                <span class="license-tag blue">开放使用</span>
                <span class="combination-note">（单独使用）</span>
              </div>
              <div class="combination">
                <span class="license-tag purple">非商业混音</span>
                <span class="combination-separator">+</span>
                <span class="license-tag green">商业使用</span>
                <span class="combination-separator">+</span>
                <span class="license-tag red">商业混音</span>
                <span class="combination-note">（可任意组合）</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <button class="close-button" @click="$emit('close')" aria-label="关闭提示">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="18" y1="6" x2="6" y2="18"></line>
          <line x1="6" y1="6" x2="18" y2="18"></line>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  isVisible: {
    type: Boolean,
    default: false
  },
  conflictingLicenses: {
    type: Array as () => string[],
    default: () => []
  },
  conflictReason: {
    type: String,
    default: '开放使用（完全免费无限制）与其他许可证类型互斥，不能同时选择'
  }
});

defineEmits(['close']);
</script>

<style scoped>
.license-conflict-alert {
  width: 100%;
  margin: 20px 0;
  background: rgba(255, 77, 79, 0.1);
  border: 1px solid rgba(255, 77, 79, 0.3);
  border-radius: 12px;
  overflow: hidden;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.3s ease;
}

.license-conflict-alert.visible {
  opacity: 1;
  transform: translateY(0);
}

.alert-content {
  padding: 16px;
  display: flex;
  gap: 16px;
  align-items: flex-start;
}

.alert-icon {
  flex-shrink: 0;
  color: rgba(255, 77, 79, 0.9);
}

.alert-message {
  flex: 1;
}

.alert-message h3 {
  margin: 0 0 8px 0;
  font-size: 16px;
  color: rgba(255, 77, 79, 0.9);
}

.alert-message p {
  margin: 0 0 12px 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.4;
}

.close-button {
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  line-height: 0;
  transition: all 0.2s;
}

.close-button:hover {
  color: rgba(255, 255, 255, 0.9);
  background: rgba(255, 255, 255, 0.1);
}

.conflict-details {
  margin-top: 12px;
  padding: 12px;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
}

.conflict-license-section {
  margin-bottom: 12px;
}

.section-label {
  font-size: 14px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 8px;
  display: block;
}

.license-combinations {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 8px;
}

.combination {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
}

.license-tag {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 16px;
  font-size: 13px;
}

.license-tag.blue {
  background: rgba(33, 150, 243, 0.2);
  color: rgb(80, 170, 243);
}

.license-tag.purple {
  background: rgba(156, 39, 176, 0.2);
  color: rgb(186, 104, 200);
}

.license-tag.green {
  background: rgba(76, 175, 80, 0.2);
  color: rgb(100, 180, 100);
}

.license-tag.red {
  background: rgba(244, 67, 54, 0.2);
  color: rgb(255, 99, 71);
}

.combination-separator {
  color: rgba(255, 255, 255, 0.5);
  font-size: 14px;
}

.combination-note {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  margin-left: 8px;
}

@media (max-width: 768px) {
  .license-combinations {
    flex-direction: column;
  }
  
  .combination {
    margin-bottom: 8px;
  }
}
</style> 