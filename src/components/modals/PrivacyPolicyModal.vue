<template>
  <div class="agreement-modal" v-if="show">
    <div class="modal-backdrop" @click="close"></div>
    <div class="agreement-content glow-effect">
      <div class="agreement-header">
        <button class="back-button" @click="close">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M19 12H5"></path>
            <path d="M12 19l-7-7 7-7"></path>
          </svg>
        </button>
        <h3>AETRIX平台隐私政策</h3>
        <div style="width: 16px;"></div> <!-- 占位以保持标题居中 -->
      </div>
      <div class="agreement-body no-padding custom-scrollbar">
        <div class="iframe-wrapper dark-scrollbar">
          <iframe src="/pdf/AETRIX平台隐私政策（新版）.pdf#zoom=page-fit&scrollbar=0&toolbar=0&navpanes=0&pagemode=none" width="100%" height="100%" frameborder="0" style="background-color: #111827;"></iframe>
          <div class="scrollbar-mask"></div>
          <div class="scrollbar-mask-left"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  show: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['close']);

const close = () => {
  emit('close');
};
</script>

<style scoped>
/* 协议弹框样式 */
.agreement-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1200;
  padding: 20px;
}

.modal-backdrop {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(5px);
}

.glow-effect {
  position: relative;
  border: 1px solid rgba(0, 120, 215, 0.8);
  box-shadow: 0 0 30px rgba(0, 120, 215, 0.4), 
              0 0 50px rgba(0, 120, 215, 0.3),
              inset 0 0 10px rgba(0, 120, 215, 0.2);
  overflow: hidden;
  background-color: #111827;
  animation: pulse-glow 3s ease-in-out infinite alternate;
  z-index: 1202;
}

.glow-effect::before {
  content: "";
  position: absolute;
  top: -3px;
  left: -3px;
  right: -3px;
  bottom: -3px;
  z-index: -1;
  background: linear-gradient(45deg, 
    rgba(0, 102, 204, 0.1) 0%,
    rgba(0, 140, 255, 0.4) 50%, 
    rgba(0, 102, 204, 0.1) 100%);
  background-size: 200% 200%;
  animation: shimmer 3s linear infinite;
  pointer-events: none;
  border-radius: 15px;
}

@keyframes shimmer {
  0% {
    background-position: 0% 0%;
  }
  100% {
    background-position: 200% 200%;
  }
}

@keyframes pulse-glow {
  0% {
    box-shadow: 0 0 30px rgba(0, 120, 215, 0.4), 
                0 0 50px rgba(0, 120, 215, 0.3),
                inset 0 0 10px rgba(0, 120, 215, 0.2);
  }
  50% {
    box-shadow: 0 0 40px rgba(0, 120, 215, 0.6), 
                0 0 70px rgba(0, 120, 215, 0.5),
                inset 0 0 20px rgba(0, 120, 215, 0.3);
  }
  100% {
    box-shadow: 0 0 30px rgba(0, 120, 215, 0.4), 
                0 0 50px rgba(0, 120, 215, 0.3),
                inset 0 0 10px rgba(0, 120, 215, 0.2);
  }
}

.agreement-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 8px;
  background: linear-gradient(to right, #0c1222, #142446, #0c1222);
  border-bottom: 1px solid rgba(0, 120, 215, 0.25);
  position: relative;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.15);
}

.agreement-header h3 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: rgba(0, 180, 250, 0.9);
  text-align: center;
  flex: 1;
  text-shadow: 0 0 8px rgba(0, 120, 215, 0.4), 0 1px 2px rgba(0, 0, 0, 0.5);
  letter-spacing: 0.5px;
}

.agreement-header .back-button {
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 3px;
  border-radius: 50%;
}

.agreement-header .back-button:hover {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}

.agreement-header .back-button svg {
  width: 16px;
  height: 16px;
}

.agreement-body {
  flex: 1;
  overflow: hidden;
  background-color: #222;
  position: relative;
  padding: 0;
  margin: 0;
}

.iframe-wrapper {
  width: 100%;
  height: 100%;
  overflow: auto;
  background-color: #222;
  position: relative;
  scrollbar-width: thin;
  scrollbar-color: rgba(70, 70, 75, 0.6) rgba(40, 40, 45, 0.3);
}

.dark-scrollbar::-webkit-scrollbar {
  width: 5px;
  height: 5px;
}

.dark-scrollbar::-webkit-scrollbar-track {
  background: rgba(40, 40, 45, 0.3);
  border-radius: 10px;
}

.dark-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(70, 70, 75, 0.6);
  border-radius: 10px;
}

.dark-scrollbar::-webkit-scrollbar-thumb:hover {
  background: rgba(90, 90, 95, 0.8);
}

.iframe-wrapper iframe {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
  background-color: #222;
}

.scrollbar-mask {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 20px;
  background-color: #222;
  opacity: 1;
  z-index: 100;
  pointer-events: none;
}

.scrollbar-mask-left {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  width: 20px;
  background-color: #222;
  opacity: 1;
  z-index: 100;
  pointer-events: none;
}

.agreement-body.no-padding {
  padding: 0;
  margin: 0;
  background-color: #222;
  border-top: none;
  overflow: hidden;
}

.agreement-content {
  position: relative;
  width: 80%;
  max-width: 780px;
  height: 85vh;
  max-height: 800px;
  background: #222;
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.6);
  display: flex;
  flex-direction: column;
  z-index: 1201;
  animation: agreementFadeIn 0.25s ease;
  overflow: hidden;
  margin: 0 auto;
}

@keyframes agreementFadeIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.agreement-content.glow-effect::after {
  content: "";
  position: absolute;
  top: -5px;
  left: -5px;
  right: -5px;
  bottom: -5px;
  border-radius: 16px;
  background: transparent;
  border: 2px solid rgba(0, 120, 215, 0.3);
  box-shadow: 0 0 50px rgba(0, 120, 215, 0.6), 
              0 0 100px rgba(0, 120, 215, 0.4);
  z-index: -2;
  animation: outer-glow 4s ease-in-out infinite alternate;
  pointer-events: none;
}

@keyframes outer-glow {
  0% {
    border-color: rgba(0, 120, 215, 0.3);
    box-shadow: 0 0 50px rgba(0, 120, 215, 0.6), 
                0 0 100px rgba(0, 120, 215, 0.4);
  }
  100% {
    border-color: rgba(0, 120, 215, 0.5);
    box-shadow: 0 0 70px rgba(0, 120, 215, 0.8), 
                0 0 130px rgba(0, 120, 215, 0.6);
  }
}
</style> 