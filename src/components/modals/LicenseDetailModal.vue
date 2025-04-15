<template>
  <div class="license-detail-modal">
    <div class="modal-content license-detail-content">
      <header class="modal-header">
        <div class="license-detail-logo">
          <div class="ip-logo">
            <svg width="32" height="32" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M50 95C74.8528 95 95 74.8528 95 50C95 25.1472 74.8528 5 50 5C25.1472 5 5 25.1472 5 50C5 74.8528 25.1472 95 50 95Z" stroke="white" stroke-width="8"/>
              <text x="50" y="65" text-anchor="middle" fill="white" font-size="40" font-weight="bold">IP</text>
            </svg>
          </div>
          <div class="license-detail-title">{{ licenseDetail.name }}</div>
        </div>
        <div class="license-detail-icons">
          <div class="file-lock-indicator">
            <svg xmlns="http://www.w3.org/2000/svg" id="lock" width="16" height="16" viewBox="18.696 10 62.608 80" style="fill: rgba(255, 255, 255, 0.8);">
              <path d="M50 10c-12.281 0-22.462 8.976-24.13 20.87v.543c-.018.145-.095.29-.11.435l-.108 2.5v3.478c-3.842 0-6.956 3.13-6.956 6.957v38.261c0 3.826 3.114 6.956 6.956 6.956h48.696c3.843 0 6.956-3.13 6.956-6.956V44.783c0-3.826-3.113-6.957-6.956-6.957v-3.478l-.11-2.5C72.993 19.486 62.607 10 50 10zm0 10.435c7.683 0 13.913 6.23 13.913 13.913v3.478H36.087v-3.478c0-.957.14-1.923.326-2.826.168-.824.346-1.628.652-2.391.199-.493.509-.95.76-1.413.136-.253.285-.519.435-.761.357-.57.763-1.12 1.196-1.63.066-.08.15-.141.217-.218.342-.386.705-.74 1.087-1.087.383-.346.777-.677 1.196-.978.215-.155.428-.292.652-.435.492-.314.99-.62 1.522-.87.15-.07.281-.152.435-.217.031-.014.078.014.108 0 .491-.204 1.005-.396 1.522-.544a14.163 14.163 0 0 1 3.804-.543zM25.652 55.217h48.695v3.479H25.652v-3.478zm0 6.957h48.695v3.478H25.652v-3.478zm0 6.957h48.695v3.478H25.652V69.13zm0 6.956h48.695v3.478H25.652v-3.478z"></path>
            </svg>
            <span class="file-count">{{ fileCount }}</span>
            <div class="lock-tooltip">原文件</div>
          </div>
          <span v-if="licenseDetail.license === 'open'"><span class="license-icon">📝</span></span>
          <span v-if="licenseDetail.license === 'commercial' || licenseDetail.license === 'commercial-remix'"><span class="license-icon">💲</span></span>
          <span v-if="licenseDetail.license === 'non-commercial' || licenseDetail.license === 'commercial-remix'"><span class="license-icon">↩️</span></span>
        </div>
        <span class="close-btn" @click="$emit('close')">×</span>
      </header>
      
      <div class="modal-body">
        <div class="license-summary">
          <h3>许可证摘要</h3>
          <p>{{ licenseDetail.summary }}</p>
          
          <div v-if="licenseDetail.license === 'commercial' || licenseDetail.license === 'commercial-remix'" class="license-price-display">
            <div class="price-label">许可价格:</div>
            <div class="price-value">
              <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="bag-coin" width="14" height="14" class="price-icon">
                <path d="m12.5 7h-7c-.827 0-1.5-.673-1.5-1.5s.673-1.5 1.5-1.5h7c.827 0 1.5.673 1.5 1.5s-.673 1.5-1.5 1.5zm-7-2c-.276 0-.5.225-.5.5s.224.5.5.5h7c.276 0 .5-.225.5-.5s-.224-.5-.5-.5z"></path>
                <path d="M11.5 5c-.147 0-.292-.064-.391-.188-.172-.216-.137-.53.078-.703l2.774-2.219c.257-.205.188-.478.16-.557-.027-.077-.143-.333-.472-.333h-9.298c-.329 0-.445.256-.472.334-.028.079-.098.352.16.557l2.774 2.219c.215.173.25.487.078.703-.172.215-.486.25-.703.078l-2.774-2.219c-.505-.404-.693-1.059-.479-1.669.214-.609.77-1.003 1.416-1.003h9.299c.646 0 1.202.394 1.416 1.003.214.61.026 1.265-.479 1.669l-2.774 2.219c-.093.073-.203.109-.313.109zM10 24h-4.5c-3.799 0-5.5-3.265-5.5-6.5 0-4.643 2.451-9.45 5.827-11.432.077-.045.164-.068.253-.068h5.84c.089 0 .176.023.253.068 1.375.807 2.623 2.076 3.607 3.672.145.235.072.543-.163.688-.236.143-.543.072-.688-.163-.871-1.411-1.957-2.537-3.147-3.265h-5.564c-3.03 1.854-5.218 6.243-5.218 10.5 0 2.537 1.179 5.5 4.5 5.5h4.5c.276 0 .5.224.5.5s-.224.5-.5.5z"></path>
                <path d="m17 24c-3.394 0-7-1.052-7-3 0-.276.224-.5.5-.5s.5.224.5.5c0 .835 2.283 2 6 2s6-1.165 6-2c0-.276.224-.5.5-.5s.5.224.5.5c0 1.948-3.606 3-7 3z"></path>
                <path d="m17 21c-3.394 0-7-1.052-7-3 0-.276.224-.5.5-.5s.5.224.5.5c0 .835 2.283 2 6 2s6-1.165 6-2c0-.276.224-.5.5-.5s.5.224.5.5c0 1.948-3.606 3-7 3z"></path>
                <path d="m17 18c-3.394 0-7-1.052-7-3s3.606-3 7-3 7 1.052 7 3-3.606 3-7 3zm0-5c-3.717 0-6 1.165-6 2s2.283 2 6 2 6-1.165 6-2-2.283-2-6-2z"></path>
                <path d="M23.5 21.5c-.276 0-.5-.224-.5-.5v-6c0-.276.224-.5.5-.5s.5.224.5.5v6c0 .276-.224.5-.5.5zM10.5 21.5c-.276 0-.5-.224-.5-.5v-6c0-.276.224-.5.5-.5s.5.224.5.5v6c0 .276-.224.5-.5.5z"></path>
              </svg>
              {{ formattedPrice }}
            </div>
          </div>
        </div>
        
        <div class="license-terms">
          <h3>许可条款</h3>
          <div class="terms-list">
            <div class="term-item" v-if="licenseDetail.license === 'open'">
              <div class="term-icon">📝</div>
              <div class="term-text">无需标明出处</div>
            </div>
            <div class="term-item" v-else>
              <div class="term-icon">📝</div>
              <div class="term-text">需要标明出处</div>
            </div>
            
            <div class="term-item">
              <div class="term-icon">💲</div>
              <div class="term-text">
                {{ licenseDetail.license === 'non-commercial' ? '仅限非商业使用' : 
                   licenseDetail.license === 'commercial' || licenseDetail.license === 'commercial-remix' ? '允许商业使用' : '允许任何使用' }}
              </div>
            </div>
            
            <div class="term-item">
              <div class="term-icon">↩️</div>
              <div class="term-text">
                {{ licenseDetail.license === 'non-commercial' || licenseDetail.license === 'commercial-remix' || licenseDetail.license === 'open' ? '允许混音改编' : '不允许混音改编' }}
              </div>
            </div>
            
            <div class="term-item">
              <div class="term-icon">📊</div>
              <div class="term-text">
                {{ licenseDetail.license === 'commercial' || licenseDetail.license === 'commercial-remix' ? '收取版税' : '无版税共享' }}
              </div>
            </div>
            
            <div class="term-item">
              <div class="term-icon">🤖</div>
              <div class="term-text">{{ aiTrainingEnabled ? '允许AI训练' : '不允许AI训练' }}</div>
            </div>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <button class="view-legal-btn" @click="showLegalTerms = true">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M14 3v4a1 1 0 0 0 1 1h4" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M17 21H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7l5 5v11a2 2 0 0 1-2 2z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          查看法律条款
        </button>
      </div>
    </div>
  </div>

  <!-- 法律条款弹窗 -->
  <div v-if="showLegalTerms" class="legal-terms-modal">
    <div class="legal-terms-content">
      <header class="legal-terms-header">
        <div class="legal-terms-title">
          <div class="license-icon">⚖️</div>
          <h2>{{ licenseDetail.name }} - 法律条款</h2>
        </div>
        <span class="close-btn" @click="showLegalTerms = false">×</span>
      </header>

      <div class="legal-terms-body">
        <section class="terms-section">
          <h3>使用说明</h3>
          <p>本许可证允许使用者在遵守特定条件下使用本作品。以下是关于如何合法使用本数字资产的说明：</p>
          
          <ul class="terms-list-details">
            <li v-if="licenseDetail.license === 'non-commercial'">
              <strong>非商业使用：</strong>您可以复制、分发、展示和表演本作品以及基于本作品的演绎作品，但仅限于非商业目的。
            </li>
            <li v-else-if="licenseDetail.license === 'commercial' || licenseDetail.license === 'commercial-remix'">
              <strong>商业使用：</strong>您可以将本作品用于商业目的，但需要支付相关费用和/或版税。
            </li>
            <li v-else>
              <strong>自由使用：</strong>您可以自由地使用、修改、分发和商业化本作品，无需任何限制。
            </li>
            
            <li v-if="licenseDetail.license !== 'open'">
              <strong>署名要求：</strong>您必须以合理的方式标明原作者的身份，但不得以任何方式暗示原作者为您或您对本作品的使用提供背书。
            </li>
            
            <li v-if="licenseDetail.license === 'commercial-remix' || licenseDetail.license === 'non-commercial'">
              <strong>关于衍生作品：</strong>您可以修改、转换或以本作品为基础进行创作，但必须遵循与原作品相同的许可条款分发衍生作品。
            </li>
            
            <li v-if="licenseDetail.license === 'commercial'">
              <strong>禁止修改：</strong>本许可不允许对作品进行任何修改或创建衍生作品。
            </li>
            
            <li v-if="aiTrainingEnabled">
              <strong>AI训练：</strong>允许将本作品用于AI模型训练。
            </li>
            <li v-else>
              <strong>AI训练限制：</strong>不允许将本作品用于任何AI模型的训练。
            </li>
          </ul>
        </section>

        <section class="terms-section">
          <h3>作者声明</h3>
          <p>作为本数字资产的原创作者，我确认：</p>
          <ul class="terms-list-details">
            <li>我是本作品的合法创作者或拥有必要的权利授予此许可。</li>
            <li>本作品不侵犯任何第三方的知识产权或其他法律权利。</li>
            <li>我授权按照本许可证条款使用此作品。</li>
            <li>我保留所有未明确授予的权利。</li>
          </ul>
        </section>

        <section class="terms-section blockchain-section">
          <h3>区块链验证</h3>
          <div class="blockchain-info">
            <div class="blockchain-icon">
              <svg width="32" height="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M16 18v-3.87a2.5 2.5 0 0 0-5 0V18" stroke="#64EEBC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M12 19.5V16m6.5-7.1v11.3a2 2 0 0 1-2 2h-9a2 2 0 0 1-2-2V8.9a2 2 0 0 1 .59-1.42l4.82-4.83a2 2 0 0 1 2.83 0l4.82 4.83A2 2 0 0 1 18.5 8.9z" stroke="#64EEBC" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <div class="blockchain-status">
              <p class="blockchain-status-text">资产已上链存证</p>
              <p class="blockchain-hash">
                交易哈希: <span class="hash-value">0x8f6a9c3d5e47b8c7f2a9b1e3f5a4c7d9e1f2a3b4c5d6e7f8a9b0c1d2e3f4</span>
              </p>
              <p class="blockchain-time">上链时间: 2025-03-10 14:32:51</p>
            </div>
          </div>
          <div class="verification-note">
            <p>您可以通过区块链浏览器验证此资产的存证证明，确保作品的原创性和版权归属。</p>
          </div>
        </section>
      </div>

      <div class="legal-terms-footer">
        <button class="confirm-btn" @click="showLegalTerms = false">确认并关闭</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

const props = defineProps({
  licenseDetail: {
    type: Object,
    required: true
  },
  aiTrainingEnabled: {
    type: Boolean,
    default: true
  },
  fileCount: {
    type: Number,
    default: 1
  }
});

defineEmits(['close']);

const showLegalTerms = ref(false);

const formattedPrice = computed(() => {
  if (props.licenseDetail.license === 'commercial' || props.licenseDetail.license === 'commercial-remix') {
    const price = props.licenseDetail.licensePrice || '0';
    const revenueShare = props.licenseDetail.revenueShare || '0';
    
    if (price && revenueShare && revenueShare !== '0') {
      return `${price} ¥ + ${revenueShare}% 分成`;
    } else if (price) {
      return `${price} ¥`;
    } else if (revenueShare && revenueShare !== '0') {
      return `${revenueShare}% 分成`;
    }
    return '未设置价格';
  }
  return '';
});
</script>

<style scoped>
.license-detail-modal {
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
  max-width: 450px;
  background: #1c1c1e;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  max-height: 90vh;
}

.license-detail-content {
  background: #1a1a1a;
}

.modal-header {
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.license-detail-logo {
  display: flex;
  align-items: center;
  flex: 1;
}

.ip-logo {
  margin-right: 12px;
}

.license-detail-title {
  font-size: 22px;
  font-weight: 400;
  color: white;
}

.license-detail-icons {
  display: flex;
  gap: 10px;
  margin-top: 4px;
}

.license-icon {
  font-size: 18px;
  opacity: 0.7;
}

.close-btn {
  font-size: 20px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.7);
  transition: all 0.2s;
  margin-left: 16px;
  line-height: 1;
  padding: 4px 8px;
}

.close-btn:hover {
  color: white;
}

.modal-body {
  padding: 20px;
  overflow-y: auto;
}

.license-summary, .license-terms {
  margin-bottom: 24px;
}

.license-summary h3, .license-terms h3 {
  font-size: 16px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 12px;
}

.license-summary p {
  font-size: 14px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.8);
}

.terms-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.term-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.term-icon {
  width: 24px;
  height: 24px;
  background: transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
}

.term-text {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
}

.modal-footer {
  padding: 16px 0;
  display: flex;
  justify-content: center;
  margin-bottom: 8px;
}

.view-legal-btn {
  background: transparent;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 40px;
  padding: 10px 24px;
  color: white;
  font-size: 14px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s;
}

.view-legal-btn:hover {
  background: rgba(255, 255, 255, 0.05);
}

/* 法律条款弹窗样式 */
.legal-terms-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1100; /* 需要比许可证详情弹窗更高 */
}

.legal-terms-content {
  width: 90%;
  max-width: 600px;
  background: #1a1a1a;
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  max-height: 90vh;
}

.legal-terms-header {
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.legal-terms-title {
  display: flex;
  align-items: center;
  gap: 12px;
}

.legal-terms-title h2 {
  font-size: 18px;
  font-weight: 500;
  color: white;
}

.legal-terms-body {
  padding: 20px;
  overflow-y: auto;
  max-height: 60vh;
}

.terms-section {
  margin-bottom: 24px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding-bottom: 20px;
}

.terms-section:last-child {
  border-bottom: none;
  margin-bottom: 0;
}

.terms-section h3 {
  font-size: 16px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 12px;
}

.terms-section p {
  font-size: 14px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 12px;
}

.terms-list-details {
  padding-left: 20px;
  margin-bottom: 16px;
}

.terms-list-details li {
  margin-bottom: 8px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 14px;
  line-height: 1.6;
}

.blockchain-section {
  background: rgba(100, 238, 188, 0.05);
  border-radius: 12px;
  padding: 16px;
  margin-top: 20px;
}

.blockchain-info {
  display: flex;
  align-items: flex-start;
  gap: 15px;
  margin-bottom: 16px;
}

.blockchain-icon {
  flex-shrink: 0;
}

.blockchain-status {
  flex: 1;
}

.blockchain-status-text {
  font-weight: 500;
  color: #64EEBC !important;
  margin-bottom: 8px !important;
}

.blockchain-hash {
  font-size: 13px !important;
  margin-bottom: 8px !important;
  line-height: 1.5 !important;
  color: rgba(255, 255, 255, 0.7) !important;
  word-break: break-all;
}

.hash-value {
  font-family: monospace;
  background: rgba(255, 255, 255, 0.1);
  padding: 2px 4px;
  border-radius: 4px;
  font-size: 12px;
}

.blockchain-time {
  font-size: 13px !important;
  color: rgba(255, 255, 255, 0.7) !important;
  margin-bottom: 0 !important;
}

.verification-note {
  margin-top: 12px;
  background: rgba(255, 255, 255, 0.05);
  padding: 10px;
  border-radius: 6px;
}

.verification-note p {
  font-size: 13px !important;
  color: rgba(255, 255, 255, 0.7) !important;
  margin-bottom: 0 !important;
}

.legal-terms-footer {
  padding: 16px 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: center;
}

.confirm-btn {
  background: #64EEBC;
  color: #1a1a1a;
  border: none;
  border-radius: 40px;
  padding: 12px 32px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.confirm-btn:hover {
  background: #7affca;
}

.license-price-display {
  margin-top: 16px;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  padding: 10px 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-left: 3px solid #64EEBC;
}

.price-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.price-value {
  font-size: 15px;
  color: #64EEBC;
  font-weight: 500;
}

/* 添加价格图标样式 */
.price-icon {
  color: #64EEBC;
  fill: currentColor;
  margin-right: 5px;
  vertical-align: -2px;
}

/* 锁图标和文件计数样式 */
.file-lock-indicator {
  display: flex;
  align-items: center;
  gap: 3px;
  background-color: rgba(20, 20, 25, 0.85);
  padding: 1px 6px;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  position: relative;
  height: 20px;
  margin-right: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.file-lock-indicator svg {
  width: 12px;
  height: 12px;
}

.file-lock-indicator .file-count {
  position: relative;
  top: 1px;
}

.file-lock-indicator .lock-tooltip {
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(0, 0, 0, 0.75);
  color: white;
  font-size: 12px;
  padding: 4px 8px;
  border-radius: 4px;
  white-space: nowrap;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
  pointer-events: none;
  z-index: 10;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
}

.file-lock-indicator .lock-tooltip::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 50%;
  transform: translateX(-50%);
  width: 0;
  height: 0;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-top: 5px solid rgba(0, 0, 0, 0.75);
}

.file-lock-indicator:hover .lock-tooltip {
  opacity: 1;
  visibility: visible;
}
</style> 