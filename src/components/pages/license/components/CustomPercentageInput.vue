<template>
  <div class="custom-percentage">
    <input 
      type="number" 
      class="percentage-input" 
      :value="modelValue"
      @input="updateValue"
      min="1"
      max="100"
      placeholder="输入百分比"
    />
    <span class="percentage-sign">%</span>
  </div>
</template>

<script setup lang="ts">
defineProps({
  modelValue: {
    type: String,
    default: ''
  }
});

const emit = defineEmits(['update:modelValue']);

const updateValue = (event: Event) => {
  const target = event.target as HTMLInputElement;
  emit('update:modelValue', target.value);
};
</script>

<style scoped>
.custom-percentage {
  width: 100%;
  max-width: 300px;
  margin: 0 auto 40px;
  position: relative;
}

.percentage-input {
  width: 100%;
  height: 64px;
  padding: 10px 20px;
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background: rgba(25, 25, 30, 0.6);
  color: white;
  font-size: 17px;
  outline: none;
  transition: all 0.3s ease;
  padding-right: 40px;
}

.percentage-input:focus {
  border-color: #4A90E2;
  box-shadow: 0 0 10px rgba(74, 144, 226, 0.3);
}

.percentage-sign {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
}
</style> 