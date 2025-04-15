<template>
  <div class="revenue-options">
    <div 
      class="revenue-option" 
      :class="{ selected: selectedOption === '1' }"
      @click="selectOption('1')"
    >
      <span>1%</span>
    </div>
    <div 
      class="revenue-option" 
      :class="{ selected: selectedOption === '5' }"
      @click="selectOption('5')"
    >
      <span>5%</span>
    </div>
    <div 
      class="revenue-option" 
      :class="{ selected: selectedOption === 'custom' }"
      @click="selectOption('custom')"
    >
      <span>自定义</span>
    </div>
    <div 
      class="revenue-option" 
      :class="{ selected: selectedOption === 'none' }"
      @click="selectOption('none')"
    >
      <span>没有</span>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps({
  selectedOption: {
    type: String,
    required: true
  }
});

const emit = defineEmits(['select']);

const selectOption = (option: string) => {
  emit('select', option);
};
</script>

<style scoped>
.revenue-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 25px;
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
  margin-bottom: 30px;
}

.revenue-option {
  background: rgba(25, 25, 30, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 14px;
  padding: 20px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.revenue-option.selected {
  background: rgba(74, 144, 226, 0.2);
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.revenue-option:hover {
  background: rgba(40, 40, 45, 0.7);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.revenue-option.selected:hover {
  background: rgba(74, 144, 226, 0.25);
}

.revenue-option span {
  font-size: 17px;
  font-weight: 500;
}

@media (max-width: 767px) {
  .revenue-options {
    grid-template-columns: 1fr;
  }
}
</style> 