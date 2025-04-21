<template>
  <div class="license-conflict-alert" v-if="isVisible">
    <div class="alert-icon">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="10"></circle>
        <line x1="12" y1="8" x2="12" y2="12"></line>
        <line x1="12" y1="16" x2="12.01" y2="16"></line>
      </svg>
    </div>
    <div class="alert-content">
      <div class="alert-header">
        <h3>许可证冲突</h3>
        <button class="close-button" @click="closeAlert">×</button>
      </div>
      <p class="alert-description">{{ conflictReason }}</p>
      
      <div class="conflicting-licenses">
        <span>冲突的许可证：</span>
        <div class="license-tags">
          <span v-for="license in conflictingLicenses" :key="license" class="license-tag">
            {{ getLicenseName(license) }}
          </span>
        </div>
      </div>
      
      <div class="alert-suggestions" v-if="suggestions && suggestions.length > 0">
        <h4>解决建议:</h4>
        <ul>
          <li v-for="(suggestion, index) in suggestions" :key="index">
            {{ suggestion }}
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';
import { getLicenseName } from '../../services/LicenseService';

defineProps({
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
    default: ''
  },
  suggestions: {
    type: Array as () => string[],
    default: () => []
  }
});

const emit = defineEmits(['close']);

const closeAlert = () => {
  emit('close');
};
</script>

<style scoped>
.license-conflict-alert {
  background: rgba(255, 73, 73, 0.1);
  border: 1px solid rgba(255, 73, 73, 0.5);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 30px;
  display: flex;
  align-items: flex-start;
  color: rgba(255, 255, 255, 0.9);
  width: 100%;
}

.alert-icon {
  flex-shrink: 0;
  margin-right: 15px;
  color: #ff4949;
  display: flex;
  align-items: center;
  justify-content: center;
}

.alert-content {
  flex: 1;
}

.alert-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.alert-header h3 {
  margin: 0;
  font-size: 18px;
  color: #ff4949;
}

.close-button {
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  font-size: 24px;
  cursor: pointer;
  line-height: 1;
  padding: 0;
  margin: 0;
  font-family: inherit;
}

.close-button:hover {
  color: rgba(255, 255, 255, 0.9);
}

.alert-description {
  margin-top: 0;
  margin-bottom: 15px;
  font-size: 15px;
}

.conflicting-licenses {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  margin-bottom: 15px;
  gap: 10px;
}

.license-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.license-tag {
  background-color: rgba(255, 73, 73, 0.2);
  color: rgba(255, 255, 255, 0.95);
  padding: 4px 10px;
  border-radius: 100px;
  font-size: 14px;
  display: inline-block;
}

.alert-suggestions {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  padding: 12px 15px;
  margin-top: 15px;
}

.alert-suggestions h4 {
  margin: 0 0 8px 0;
  font-size: 15px;
  color: rgba(255, 255, 255, 0.9);
}

.alert-suggestions ul {
  margin: 0;
  padding-left: 20px;
}

.alert-suggestions li {
  margin-bottom: 6px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
}

.alert-suggestions li:last-child {
  margin-bottom: 0;
}

@media (max-width: 767px) {
  .license-conflict-alert {
    padding: 15px;
  }
  
  .conflicting-licenses {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style> 