<template>
  <div class="tabs-wrapper">
    <div class="tabs">
      <div 
        v-for="(tab, index) in tabs" 
        :key="tab.id"
        :class="['tab', { active: activeIndex === index }]"
        @click="setActiveTab(index)"
      >
        {{ tab.label }}
      </div>
    </div>
    
    <div class="tab-content">
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Tab {
  id: string;
  label: string;
}

const props = defineProps<{
  tabs: Tab[];
  activeIndex: number;
}>();

const emit = defineEmits(['tab-change']);

const setActiveTab = (index: number) => {
  emit('tab-change', index);
};
</script>

<style scoped>
.tabs-wrapper {
  width: 100%;
}

.tabs {
  display: flex;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  margin-bottom: 24px;
}

.tab {
  padding: 10px 20px;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  position: relative;
  transition: all 0.2s;
  font-size: 16px;
}

.tab:hover {
  color: white;
}

.tab.active {
  color: white;
}

.tab.active::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, #00c6ff, #0072ff);
}

.tab-content {
  min-height: 200px;
}
</style> 