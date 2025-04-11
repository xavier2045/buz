<template>
  <div class="modal" v-if="show">
    <div class="modal-content" :class="{ 'compact': compact }">
      <div class="modal-header">
        <h2>{{ title }}</h2>
        <button class="close-button" @click="onClose">×</button>
      </div>
      <div class="modal-body">
        <p v-if="message">{{ message }}</p>
        <slot v-else></slot>
      </div>
      <button class="modal-button" @click="onClose">{{ buttonText }}</button>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps({
  show: {
    type: Boolean,
    required: true
  },
  title: {
    type: String,
    default: '提示'
  },
  message: {
    type: String,
    default: ''
  },
  buttonText: {
    type: String,
    default: '确定'
  },
  compact: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['close']);

const onClose = () => {
  emit('close');
};
</script>

<style scoped>
.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: rgba(30, 30, 50, 0.9);
  border-radius: 16px;
  width: 90%;
  max-width: 500px;
  padding: 24px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-content.compact {
  max-width: 400px;
  padding: 20px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.modal-header h2 {
  color: white;
  font-size: 24px;
}

.close-button {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  font-size: 24px;
  cursor: pointer;
  transition: all 0.2s;
}

.close-button:hover {
  color: white;
}

.modal-body {
  margin-bottom: 24px;
}

.modal-body p {
  color: rgba(255, 255, 255, 0.8);
  font-size: 16px;
}

.modal-button {
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  color: white;
  border: none;
  padding: 10px 24px;
  border-radius: 24px;
  font-size: 16px;
  cursor: pointer;
  width: 100%;
  transition: all 0.2s;
}

.modal-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(0, 114, 255, 0.4);
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .modal-content {
    width: 95%;
    padding: 20px;
  }
}
</style> 