<template>
  <div class="navigation">
    <button class="back-btn" @click="onBack" :disabled="backDisabled">
      <span class="arrow">←</span> {{ backText }}
    </button>
    <button class="next-btn" @click="onNext" :disabled="nextDisabled">
      {{ nextText }} <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup lang="ts">
defineProps({
  backText: {
    type: String,
    default: '返回'
  },
  nextText: {
    type: String,
    default: '下一步'
  },
  backDisabled: {
    type: Boolean,
    default: false
  },
  nextDisabled: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['back', 'next']);

const onBack = () => {
  emit('back');
};

const onNext = () => {
  emit('next');
};
</script>

<style scoped>
.navigation {
  display: flex;
  justify-content: space-between;
  width: 100%;
  max-width: 500px;
  margin-top: 20px;
}

.back-btn, .next-btn {
  display: flex;
  align-items: center;
  padding: 10px 24px;
  border-radius: 24px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
}

.back-btn {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.back-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.2);
}

.next-btn {
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  color: white;
}

.next-btn:hover:not(:disabled) {
  box-shadow: 0 4px 15px rgba(0, 114, 255, 0.4);
  transform: translateY(-2px);
}

.back-btn:disabled, .next-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.arrow {
  font-size: 18px;
}
</style> 