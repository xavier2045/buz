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
        <h3>AETRIX平台用户服务协议</h3>
        <div style="width: 16px;"></div> <!-- 占位以保持标题居中 -->
      </div>
      <div class="agreement-body no-padding custom-scrollbar">
        <div class="iframe-wrapper dark-scrollbar">
          <iframe id="service-agreement-iframe" src="/pdf/AETRIX平台用户服务协议2.0.pdf#zoom=page-fit&scrollbar=0&toolbar=0&navpanes=0&pagemode=none" width="100%" height="100%" frameborder="0" style="background-color: #222;"></iframe>
          <div class="scrollbar-mask"></div>
          <div class="scrollbar-mask-left"></div>
          
          <!-- 悬浮高亮链接按钮 -->
          <div class="highlight-links-container">
            <div class="highlight-link" @click="showPrivacyPolicy">
              <span class="link-icon">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" id="File" width="16" height="16">
                  <path fill="rgba(0, 180, 250, 0.9)" d="M26.414 7H22V2.586ZM7 23V6.184A2.995 2.995 0 0 0 5 9v18a3.003 3.003 0 0 0 3 3h12a2.995 2.995 0 0 0 2.816-2H12a5.006 5.006 0 0 1-5-5ZM21 9a1 1 0 0 1-1-1V2h-8a3.003 3.003 0 0 0-3 3v18a3.003 3.003 0 0 0 3 3h12a3.003 3.003 0 0 0 3-3V9Z" class="color404a6b svgShape"></path>
                </svg>
              </span>
              <span class="link-text">查看《AETRIX平台隐私政策》</span>
            </div>
            <div class="highlight-link" @click="showCommunityConvention">
              <span class="link-icon">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" id="File" width="16" height="16">
                  <path fill="rgba(0, 180, 250, 0.9)" d="M26.414 7H22V2.586ZM7 23V6.184A2.995 2.995 0 0 0 5 9v18a3.003 3.003 0 0 0 3 3h12a2.995 2.995 0 0 0 2.816-2H12a5.006 5.006 0 0 1-5-5ZM21 9a1 1 0 0 1-1-1V2h-8a3.003 3.003 0 0 0-3 3v18a3.003 3.003 0 0 0 3 3h12a3.003 3.003 0 0 0 3-3V9Z" class="color404a6b svgShape"></path>
                </svg>
              </span>
              <span class="link-text">查看《社区自律公约》</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <!-- 隐私政策弹框 -->
  <PrivacyPolicyModal
    v-if="showPrivacyPolicyModal"
    :show="showPrivacyPolicyModal"
    @close="showPrivacyPolicyModal = false"
  />
  
  <!-- 社区自律公约弹框 -->
  <CommunityConventionModal
    v-if="showCommunityConventionModal"
    :show="showCommunityConventionModal"
    @close="showCommunityConventionModal = false"
  />
</template>

<script setup lang="ts">
import { defineProps, defineEmits, ref } from 'vue';
import PrivacyPolicyModal from './PrivacyPolicyModal.vue';
import CommunityConventionModal from './CommunityConventionModal.vue';

const props = defineProps({
  show: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['close']);

// 隐私政策弹框控制
const showPrivacyPolicyModal = ref(false);

// 社区自律公约弹框控制
const showCommunityConventionModal = ref(false);

const close = () => {
  emit('close');
};

// 显示隐私政策
const showPrivacyPolicy = () => {
  showPrivacyPolicyModal.value = true;
};

// 显示社区自律公约
const showCommunityConvention = () => {
  showCommunityConventionModal.value = true;
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
  background-color: #111827;
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
  background-color: #111827;
}

.scrollbar-mask {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 20px;
  background-color: #111827;
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
  background-color: #111827;
  opacity: 1;
  z-index: 100;
  pointer-events: none;
}

.agreement-body.no-padding {
  padding: 0;
  margin: 0;
  background-color: #111827;
  border-top: none;
  overflow: hidden;
}

.agreement-content {
  position: relative;
  width: 80%;
  max-width: 780px;
  height: 85vh;
  max-height: 800px;
  background: #111827;
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

/* 高亮链接样式 */
.highlight-links-container {
  position: absolute;
  bottom: 20px;
  right: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  z-index: 110;
}

.highlight-link {
  background: rgba(10, 20, 40, 0.85);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(0, 120, 215, 0.3);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3), 0 0 10px rgba(0, 120, 215, 0.3);
  border-radius: 12px;
  padding: 10px 15px;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
  opacity: 0.9;
  transform: translateX(0);
}

.highlight-link:hover {
  background: rgba(20, 30, 60, 0.95);
  border-color: rgba(0, 120, 215, 0.6);
  opacity: 1;
  transform: translateX(-5px) scale(1.03);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4), 0 0 15px rgba(0, 120, 215, 0.4);
}

.highlight-link:active {
  transform: translateX(0) scale(0.98);
}

.link-icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

.link-text {
  font-size: 14px;
  color: rgba(0, 180, 250, 0.9);
  font-weight: 500;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.highlight-link:hover .link-text {
  text-shadow: 0 0 8px rgba(0, 120, 215, 0.4);
}

/* 添加动画效果 */
.highlight-link {
  animation: slideIn 0.4s ease backwards;
}

.highlight-link:nth-child(1) {
  animation-delay: 0.5s;
}

.highlight-link:nth-child(2) {
  animation-delay: 0.7s;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(30px);
  }
  to {
    opacity: 0.9;
    transform: translateX(0);
  }
}
</style> 