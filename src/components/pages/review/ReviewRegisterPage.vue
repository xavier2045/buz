<template>
  <div class="review-register-container">
    <h1 class="page-title">审核与注册</h1>
    <p class="page-subtitle">这是您注册的概览</p>

    <div class="review-content">
      <!-- 资产预览 - 所有文件独立展示 -->
      <div class="asset-section">
        <h2 class="section-title">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" id="paper">
            <path d="M59 10v20a1 1 0 0 1-1 1h-7v23a5 5 0 0 1-5 5H12a7 7 0 1 1 0-14h30a4.84 4.84 0 0 1 1.24.13 1 1 0 0 1-.08 2 4.85 4.85 0 0 0-2.69 1.38 5 5 0 0 0 2.69 8.44 1.06 1.06 0 0 1 .25.09H46a3 3 0 0 0 3-3V10a4.92 4.92 0 0 1 1-3H18a3 3 0 0 0-3 3v32h-2V10a5 5 0 0 1 5-5h36a5 5 0 0 1 5 5ZM42 21H22v2h20ZM22 31h20v-2H22Z"></path>
          </svg>
          您的资产
        </h2>
        
        <!-- 资产名称显示 -->
        <div class="asset-name-display" v-if="assetName">
          <div class="asset-name">{{ assetName }}</div>
          <div class="asset-type-tag">{{ getAssetTypeName }}</div>
        </div>

        <!-- 所有资产文件独立展示 -->
        <div class="assets-carousel" v-if="assetFiles.length > 0">
          <div v-for="(file, index) in assetFiles" :key="index" class="asset-preview">
            <div class="asset-preview-image">
              <!-- 图片文件预览 -->
              <img v-if="file.type && file.type.startsWith('image/')" 
                :src="file.url" alt="Asset" class="preview-image">
              
              <!-- 视频文件预览 -->
              <div v-else-if="file.type && file.type.startsWith('video/')" 
                class="preview-video"
                :class="{ 'paused': reviewVideoPaused[index] }"
              >
                <video 
                  :id="`review-video-${index}`"
                  muted 
                  autoplay 
                  loop 
                  class="preview-media"
                  @loadeddata="initializeReviewVideo(index, $event)"
                >
                  <source :src="file.url" :type="file.type">
                </video>
                <div class="video-controls">
                  <div class="video-progress-container" @click="seekVideo($event, index)">
                    <div class="video-progress-bar">
                      <div class="video-progress" :style="{ width: videoProgress[index] ? `${videoProgress[index]}%` : '0%' }"></div>
                    </div>
                  </div>
                  <div class="video-buttons">
                    <button class="video-control-btn" @click.stop="toggleReviewVideoPlay(index)">
                      <svg v-if="reviewVideoPaused[index]" width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <polygon points="5 3 19 12 5 21" fill="white"/>
                      </svg>
                      <svg v-else width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="6" y="4" width="4" height="16" fill="white"/>
                        <rect x="14" y="4" width="4" height="16" fill="white"/>
                      </svg>
                    </button>
                    <button class="video-control-btn" @click.stop="toggleReviewVideoMute(index)">
                      <svg v-if="reviewVideoMuted[index]" width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M11 5L6 9H2v6h4l5 4V5z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="white"/>
                        <path d="M23 9l-6 6M17 9l6 6" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                      <svg v-else width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M11 5L6 9H2v6h4l5 4V5z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="white"/>
                        <path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                    <button class="video-control-btn" @click.stop="toggleReviewVideoFullscreen(index)">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M8 3H5a2 2 0 0 0-2 2v3M21 8V5a2 2 0 0 0-2-2h-3M3 16v3a2 2 0 0 0 2 2h3M16 21h3a2 2 0 0 0 2-2v-3" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                  </div>
                </div>
              </div>
              
              <!-- 音频文件预览 -->
              <div v-else-if="file.type && file.type.startsWith('audio/')" class="preview-audio">
                <!-- 如果有封面图片则显示 -->
                <img v-if="props.assetData.coverImage" 
                    :src="props.assetData.coverImage.url" 
                    alt="Cover" 
                    class="preview-image audio-cover">
                <!-- 没有封面图片显示默认图标 -->
                <span v-else class="file-type-icon">🎵</span>
                <div class="audio-info">{{ file.name }}</div>
              </div>
              
              <!-- 文档文件预览 -->
              <div v-else class="preview-doc">
                <!-- 如果有封面图片则显示 -->
                <img v-if="props.assetData.coverImage" 
                    :src="props.assetData.coverImage.url" 
                    alt="Cover" 
                    class="preview-image doc-cover">
                <!-- 没有封面图片显示默认图标 -->
                <span v-else class="file-type-icon">📄</span>
                <div class="doc-info">{{ file.name }}</div>
              </div>
            </div>
            <div class="asset-info">
              <div class="info-label">{{ collectionName }}</div>
              <div class="asset-id">{{ assetName || generateAssetId(index) }}</div>
              
              <!-- 创作者头像区域 - 放在资产信息中，与文件计数同行 -->
              <div class="creators-info">
                <div class="creators-avatars">
                  <!-- 主创作者头像 -->
                  <div class="creator-avatar main-creator animated-tooltip-trigger">
                    <span class="avatar-icon">😀</span>
                    <!-- 动画提示框 -->
                    <div class="animated-tooltip">
                      <div class="tooltip-content">
                        <div class="tooltip-title">您（主创作者）</div>
                        <div class="tooltip-badge">管理</div>
                      </div>
                    </div>
                  </div>
                  
                  <!-- 共同创作者头像 - 最多显示3个，其余用数字表示 -->
                  <template v-if="creators.length > 0">
                    <div v-for="(creator, creatorIndex) in creators.slice(0, 3)" :key="creatorIndex" 
                        class="creator-avatar co-creator animated-tooltip-trigger"
                        :style="{zIndex: 10-creatorIndex, marginLeft: '-5px'}">
                      <span class="avatar-icon">👤</span>
                      <!-- 动画提示框 -->
                      <div class="animated-tooltip">
                        <div class="tooltip-content">
                          <div class="tooltip-title">{{ creator.name }}</div>
                          <div class="tooltip-detail">{{ shortenWallet(creator.wallet) }}</div>
                        </div>
                      </div>
                    </div>
                    
                    <!-- 如果共同创作者超过3个，显示剩余数量 -->
                    <div v-if="creators.length > 3" 
                        class="creator-avatar more-count animated-tooltip-trigger"
                        :style="{zIndex: 6, marginLeft: '-5px'}">
                      <span class="avatar-icon">+{{ creators.length - 3 }}</span>
                      <!-- 动画提示框 -->
                      <div class="animated-tooltip">
                        <div class="tooltip-content">
                          <div class="tooltip-title">更多{{ creators.length - 3 }}位共创者</div>
                          <div v-for="(creator, idx) in creators.slice(3)" :key="idx" class="tooltip-list-item">
                            <span>{{ creator.name }}</span>
                            <span class="tooltip-list-detail">{{ shortenWallet(creator.wallet) }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </template>
                </div>
              </div>
            </div>
            
            <!-- 移除文件计数指示器 -->
          </div>
        </div>
      </div>

      <!-- 许可证部分 -->
      <div class="licenses-section">
        <div class="section-header">
          <h2 class="section-title">
            <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 48 48" viewBox="0 0 48 48" id="paper" width="20" height="20">
              <path d="M41,11c0.552,0,1-0.448,1-1h2c0.552,0,1-0.448,1-1V5c0-0.552-0.448-1-1-1h-2c0-0.552-0.448-1-1-1H7C6.448,3,6,3.448,6,4H4
              C3.448,4,3,4.448,3,5v4c0,0.552,0.448,1,1,1h2c0,0.552,0.448,1,1,1h2v26H7c-0.552,0-1,0.448-1,1H4c-0.552,0-1,0.448-1,1v4
              c0,0.552,0.448,1,1,1h2c0,0.552,0.448,1,1,1h34c0.552,0,1-0.448,1-1h2c0.552,0,1-0.448,1-1v-4c0-0.552-0.448-1-1-1h-2
              c0-0.552-0.448-1-1-1h-2V11H41z M42,6h1v2h-1V6z M39,5h1v4h-1V5z M6,8H5V6h1V8z M6,42H5v-2h1V42z M9,43H8v-4h1V43z M42,40h1v2h-1V40
              z M9,9H8V5h1V9z M37,43H11v-4h26V43z M37,37H11V11h26V37z M37,9H11V5h26V9z M40,39v4h-1v-4H40z M13.293,16.707
              c-0.391-0.391-0.391-1.023,0-1.414l2-2c0.391-0.391,1.023-0.391,1.414,0L18,14.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0
              L22,14.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L26,14.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0l2,2c0.391,0.391,0.391,1.023,0,1.414s-1.023,0.391-1.414,0L32,15.414l-1.293,1.293
              c-0.391,0.391-1.023,0.391-1.414,0L28,15.414l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L24,15.414l-1.293,1.293
              c-0.391,0.391-1.023,0.391-1.414,0L20,15.414l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L16,15.414l-1.293,1.293
              C14.316,17.098,13.684,17.098,13.293,16.707z M13.293,22.707c-0.391-0.391-0.391-1.023,0-1.414l2-2c0.391-0.391,1.023-0.391,1.414,0
              L18,20.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L22,20.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L26,20.586
              l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L30,20.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0l2,2
              c0.391,0.391,0.391,1.023,0,1.414s-1.023,0.391-1.414,0L32,21.414l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L28,21.414
              l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L24,21.414l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L20,21.414l-1.293,1.293
              c-0.391,0.391-1.023,0.391-1.414,0L16,21.414l-1.293,1.293C14.316,23.098,13.684,23.098,13.293,22.707z M13.293,28.707
              c-0.391-0.391-0.391-1.023,0-1.414l2-2c0.391-0.391,1.023-0.391,1.414,0L18,26.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0
              L22,26.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L26,26.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L30,26.586
              l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0l2,2c0.391,0.391,0.391,1.023,0,1.414s-1.023,0.391-1.414,0L32,27.414l-1.293,1.293
              c-0.391,0.391-1.023,0.391-1.414,0L28,27.414l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L24,27.414l-1.293,1.293
              c-0.391,0.391-1.023,0.391-1.414,0L20,27.414l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L16,27.414l-1.293,1.293
              C14.316,29.098,13.684,29.098,13.293,28.707z M13.293,34.707c-0.391-0.391-0.391-1.023,0-1.414l2-2c0.391-0.391,1.023-0.391,1.414,0
              L18,32.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L22,32.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L26,32.586
              l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0L30,32.586l1.293-1.293c0.391-0.391,1.023-0.391,1.414,0l2,2
              c0.391,0.391,0.391,1.023,0,1.414s-1.023,0.391-1.414,0L32,33.414l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L28,33.414
              l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L24,33.414l-1.293,1.293c-0.391,0.391-1.023,0.391-1.414,0L20,33.414l-1.293,1.293
              c-0.391,0.391-1.023,0.391-1.414,0L16,33.414l-1.293,1.293C14.316,35.098,13.684,35.098,13.293,34.707z"></path>
            </svg>
            许可证 ({{ licenses.length }})
          </h2>
          <div class="asset-type-badge" v-if="assetType">
            资产类型: <span class="asset-type-name">{{ getAssetTypeName }}</span>
          </div>
          <div class="work-type-badge" v-if="workType.mainType">
            作品类型: <span class="work-type-name">{{ workTypeDisplay.mainType }}</span>
            <span class="creator-type-pill">{{ workTypeDisplay.creatorType }}</span>
          </div>
          <button class="add-license-btn" :class="{'highlight-btn': licenses.length === 0}" @click="navigateToAddLicense">添加许可证</button>
        </div>
        
        <div class="license-list">
          <div v-for="(license, index) in licenses" :key="index" class="license-item">
            <div class="license-content">
              <div class="license-header">
                <div class="license-name">{{ getLicenseName(license) }}</div>
                <!-- 锁图标显示在许可证名称旁边 -->
                <div class="file-lock-indicator">
                  <svg xmlns="http://www.w3.org/2000/svg" id="lock" width="16" height="16" viewBox="18.696 10 62.608 80" style="fill: rgba(255, 255, 255, 0.8);">
                    <path d="M50 10c-12.281 0-22.462 8.976-24.13 20.87v.543c-.018.145-.095.29-.11.435l-.108 2.5v3.478c-3.842 0-6.956 3.13-6.956 6.957v38.261c0 3.826 3.114 6.956 6.956 6.956h48.696c3.843 0 6.956-3.13 6.956-6.956V44.783c0-3.826-3.113-6.957-6.956-6.957v-3.478l-.11-2.5C72.993 19.486 62.607 10 50 10zm0 10.435c7.683 0 13.913 6.23 13.913 13.913v3.478H36.087v-3.478c0-.957.14-1.923.326-2.826.168-.824.346-1.628.652-2.391.199-.493.509-.95.76-1.413.136-.253.285-.519.435-.761.357-.57.763-1.12 1.196-1.63.066-.08.15-.141.217-.218.342-.386.705-.74 1.087-1.087.383-.346.777-.677 1.196-.978.215-.155.428-.292.652-.435.492-.314.99-.62 1.522-.87.15-.07.281-.152.435-.217.031-.014.078.014.108 0 .491-.204 1.005-.396 1.522-.544a14.163 14.163 0 0 1 3.804-.543zM25.652 55.217h48.695v3.479H25.652v-3.478zm0 6.957h48.695v3.478H25.652v-3.478zm0 6.957h48.695v3.478H25.652V69.13zm0 6.956h48.695v3.478H25.652v-3.478z"></path>
                  </svg>
                  <span class="file-count">{{ getOriginalFileCount(index) }}</span>
                  <div class="lock-tooltip">原文件</div>
                </div>
              </div>
              <!-- 添加商业许可证价格显示 -->
              <div v-if="license === 'commercial' || license === 'commercial-remix'" class="license-price">
                <span class="price-tag">
                  <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="bag-coin" width="14" height="14">
                    <path d="m12.5 7h-7c-.827 0-1.5-.673-1.5-1.5s.673-1.5 1.5-1.5h7c.827 0 1.5.673 1.5 1.5s-.673 1.5-1.5 1.5zm-7-2c-.276 0-.5.225-.5.5s.224.5.5.5h7c.276 0 .5-.225.5-.5s-.224-.5-.5-.5z"></path>
                    <path d="M11.5 5c-.147 0-.292-.064-.391-.188-.172-.216-.137-.53.078-.703l2.774-2.219c.257-.205.188-.478.16-.557-.027-.077-.143-.333-.472-.333h-9.298c-.329 0-.445.256-.472.334-.028.079-.098.352.16.557l2.774 2.219c.215.173.25.487.078.703-.172.215-.486.25-.703.078l-2.774-2.219c-.505-.404-.693-1.059-.479-1.669.214-.609.77-1.003 1.416-1.003h9.299c.646 0 1.202.394 1.416 1.003.214.61.026 1.265-.479 1.669l-2.774 2.219c-.093.073-.203.109-.313.109zM10 24h-4.5c-3.799 0-5.5-3.265-5.5-6.5 0-4.643 2.451-9.45 5.827-11.432.077-.045.164-.068.253-.068h5.84c.089 0 .176.023.253.068 1.375.807 2.623 2.076 3.607 3.672.145.235.072.543-.163.688-.236.143-.543.072-.688-.163-.871-1.411-1.957-2.537-3.147-3.265h-5.564c-3.03 1.854-5.218 6.243-5.218 10.5 0 2.537 1.179 5.5 4.5 5.5h4.5c.276 0 .5.224.5.5s-.224.5-.5.5z"></path>
                    <path d="m17 24c-3.394 0-7-1.052-7-3 0-.276.224-.5.5-.5s.5.224.5.5c0 .835 2.283 2 6 2s6-1.165 6-2c0-.276.224-.5.5-.5s.5.224.5.5c0 1.948-3.606 3-7 3z"></path>
                    <path d="m17 21c-3.394 0-7-1.052-7-3 0-.276.224-.5.5-.5s.5.224.5.5c0 .835 2.283 2 6 2s6-1.165 6-2c0-.276.224-.5.5-.5s.5.224.5.5c0 1.948-3.606 3-7 3z"></path>
                    <path d="m17 18c-3.394 0-7-1.052-7-3s3.606-3 7-3 7 1.052 7 3-3.606 3-7 3zm0-5c-3.717 0-6 1.165-6 2s2.283 2 6 2 6-1.165 6-2-2.283-2-6-2z"></path>
                    <path d="M23.5 21.5c-.276 0-.5-.224-.5-.5v-6c0-.276.224-.5.5-.5s.5.224.5.5v6c0 .276-.224.5-.5.5zM10.5 21.5c-.276 0-.5-.224-.5-.5v-6c0-.276.224-.5.5-.5s.5.224.5.5v6c0 .276-.224.5-.5.5z"></path>
                  </svg>
                  {{ getLicensePrice(license) }}
                </span>
              </div>
            </div>
            <div class="license-right">
              <div class="license-compatibility" v-if="isLicenseRecommended(license)">
                <span class="compatibility-icon">✓</span>
                <span class="compatibility-text">推荐</span>
              </div>
              <div class="license-actions">
                <button class="license-detail-btn magnify-btn" @click.stop="viewLicenseDetail(license)">
                  <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" id="search" x="0" y="0" version="1.1" viewBox="0 0 29 29" width="16" height="16">
                    <circle cx="11.854" cy="11.854" r="9" style="fill:none;stroke:#fff;stroke-width:2;stroke-miterlimit:10"></circle>
                    <path d="M18.451 18.451l7.695 7.695" style="fill:none;stroke:#fff;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10"></path>
                  </svg>
                </button>
                <button class="license-remove-btn" @click.stop="removeLicense(index)">
                  <span class="action-icon">✕</span>
                </button>
              </div>
            </div>
          </div>
          
          <div v-if="licenses.length === 0" class="empty-licenses">
            <div class="license-required-warning">
              <span class="warning-icon">⚠️</span>
              <span class="warning-text">您需要至少添加一个许可证才能完成注册</span>
            </div>
            <div class="empty-text">暂无许可证</div>
          </div>
        </div>
      </div>

      <!-- 确认选项 -->
      <div class="confirmation-section">
        <div class="confirmation-item" @click="toggleConfirm('originalWork')">
          <div class="checkbox" :class="{ checked: confirmations.originalWork }">
            <div v-if="confirmations.originalWork" class="check">✓</div>
          </div>
          <div class="confirmation-text">
            我确认这是我的原创作品，或者我已获得所有必要权利，可以在此发布此作品。
          </div>
        </div>
        
        <div class="confirmation-item" @click="toggleConfirm('termsAgreed')">
          <div class="checkbox" :class="{ checked: confirmations.termsAgreed }">
            <div v-if="confirmations.termsAgreed" class="check">✓</div>
          </div>
          <div class="confirmation-text">
            我已阅读并同意<a href="javascript:void(0);" @click.stop="showServiceAgreementModal = true" class="terms-link">服务条款</a>和<a href="javascript:void(0);" @click.stop="showPrivacyPolicyModal = true" class="terms-link">隐私政策</a>。
          </div>
        </div>
      </div>
    </div>

    <!-- 底部导航按钮 -->
    <div class="navigation-section">
      <NavigationButtons 
        @back="$emit('navigate-back')" 
        @next="completeRegistration"
        :next-disabled="!isConfirmationComplete"
        :is-final-step="true"
      />
    </div>

    <!-- 注册提示信息 -->
    <div v-if="!isConfirmationComplete" class="registration-tips">
      <span class="tips-icon">ℹ️</span>
      <div class="tips-content">
        <span v-if="!confirmations.originalWork || !confirmations.termsAgreed">请确认所有勾选项</span>
        <span v-if="licenses.length === 0">请至少添加一个许可证</span>
      </div>
    </div>

    <!-- 弹出许可证详情框 -->
    <LicenseDetailModal
      v-if="showLicenseDetailModal"
      :license-detail="currentLicenseDetail"
      :ai-training-enabled="aiTrainingEnabled"
      :file-count="getOriginalFileCount(0)"
      @close="closeLicenseDetailModal"
    />

    <!-- 服务协议弹框 -->
    <ServiceAgreementModal
      v-if="showServiceAgreementModal"
      :show="showServiceAgreementModal"
      @close="showServiceAgreementModal = false"
    />

    <!-- 隐私政策弹框 -->
    <PrivacyPolicyModal
      v-if="showPrivacyPolicyModal"
      :show="showPrivacyPolicyModal"
      @close="showPrivacyPolicyModal = false"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onUnmounted, onMounted } from 'vue';
import LicenseDetailModal from '../../modals/LicenseDetailModal.vue';
import NavigationButtons from '../../common/NavigationButtons.vue';
import ServiceAgreementModal from '../../modals/ServiceAgreementModal.vue';
import PrivacyPolicyModal from '../../modals/PrivacyPolicyModal.vue';

const emit = defineEmits(['navigate-back', 'registration-complete', 'navigate', 'license-update', 'show-license-detail']);

// 从父组件接收的数据
const props = defineProps({
  workType: {
    type: Object as () => { mainType: string; creatorType: string },
    default: () => ({ mainType: '', creatorType: '' })
  },
  assetData: {
    type: Object as () => Record<string, any>,
    default: () => ({})
  },
  licenses: {
    type: Array as () => string[],
    default: () => []
  },
  aiTrainingEnabled: {
    type: Boolean,
    default: true
  },
  creators: {
    type: Array as () => Array<{name: string, wallet: string}>,
    default: () => []
  },
  assetName: {
    type: String,
    default: ''
  },
  // 添加商业许可定价数据
  commercialLicenseData: {
    type: Object as () => { licensePrice: string, revenueShare: string },
    default: () => ({ licensePrice: '', revenueShare: '0' })
  },
  // 添加商业混音许可定价数据
  commercialRemixLicenseData: {
    type: Object as () => { licensePrice: string, revenueShare: string },
    default: () => ({ licensePrice: '', revenueShare: '0' })
  }
});

// 使用扩展的许可证详情类型
interface LicenseDetailType {
  license: string;
  name: string;
  summary: string;
  licensePrice?: string;
  revenueShare?: string;
}

// 许可证详情弹窗控制
const showLicenseDetailModal = ref(false);
const currentLicenseDetail = ref<LicenseDetailType>({
  license: '',
  name: '',
  summary: ''
});

// 关闭许可证详情弹窗
const closeLicenseDetailModal = () => {
  showLicenseDetailModal.value = false;
};

// 从资产数据中获取所有文件
const assetFiles = computed(() => {
  if (props.assetData.files && Array.isArray(props.assetData.files)) {
    return props.assetData.files;
  }
  return [];
});

// 获取资产类型
const assetType = computed(() => {
  return props.assetData.type || '';
});

// 获取资产名称
const assetName = computed(() => {
  return props.assetData.name || '';
});

// 获取共同创作者列表
const creators = computed(() => {
  console.log('ReviewRegisterPage接收到的creators数据:', props.creators);
  return props.creators || [];
});

// 集合名称
const collectionName = computed(() => {
  return '门户公共集合';
});

// 为每个资产生成ID
const generateAssetId = (index: number) => {
  return `${123 + index}`;
};

// 缩短钱包地址显示
const shortenWallet = (wallet: string) => {
  if (wallet.length <= 10) return wallet;
  return wallet.substring(0, 6) + '...' + wallet.substring(wallet.length - 4);
};

// 用户确认
const confirmations = ref({
  originalWork: false,
  termsAgreed: false
});

// 切换确认状态
const toggleConfirm = (key: 'originalWork' | 'termsAgreed') => {
  confirmations.value[key] = !confirmations.value[key];
};

// 计算是否所有确认都已完成
const isConfirmationComplete = computed(() => {
  // 必须有至少一个许可证且所有确认选项已勾选
  return confirmations.value.originalWork && 
         confirmations.value.termsAgreed && 
         props.licenses.length > 0;
});

// 获取许可证名称
const getLicenseName = (license: string) => {
  const names: Record<string, string> = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音'
  };
  return names[license] || license;
};

// 查看许可证详情
const viewLicenseDetail = (license: string) => {
  // 构建许可证详情数据
  const licenseDetails: Record<string, LicenseDetailType> = {
    'open': {
      license: 'open',
      name: '开放使用',
      summary: '开放域是一种公共贡献工具，它允许创作者放弃版权，将作品放入全球公共域。使用者可以在任何媒介或格式中分发、混音、改编和构建作品，无需任何条件。'
    },
    'non-commercial': {
      license: 'non-commercial',
      name: '非商业混音',
      summary: '任何人都可以使用您的作品创建非商业项目。他们可以修改、调整和构建您的作品，但必须标明原创者，且不能将作品用于商业目的。'
    },
    'commercial': {
      license: 'commercial',
      name: '商业使用',
      summary: '允许他人按照您设定的经济条款使用您的作品。使用者必须支付许可费和/或版税，但不允许对您的作品进行修改或创建衍生作品。'
    },
    'commercial-remix': {
      license: 'commercial-remix',
      name: '商业混音',
      summary: '允许他们混音您的作品，同时您获得认可和收益。使用者可以修改和构建您的作品，但必须支付许可费和/或版税，同时标明您是原创者。'
    }
  };
  
  // 设置当前许可证详情并显示弹窗
  if (licenseDetails[license as keyof typeof licenseDetails]) {
    currentLicenseDetail.value = licenseDetails[license as keyof typeof licenseDetails];
    
    // 获取价格数据
    let priceSetting = '';
    let revenueSetting = '0';
    
    if (license === 'commercial') {
      priceSetting = props.commercialLicenseData.licensePrice || '';
      revenueSetting = props.commercialLicenseData.revenueShare || '0';
    } else if (license === 'commercial-remix') {
      priceSetting = props.commercialRemixLicenseData.licensePrice || '';
      revenueSetting = props.commercialRemixLicenseData.revenueShare || '0';
    }
    
    // 更新当前许可证数据，并将价格信息作为附加参数
    currentLicenseDetail.value.licensePrice = priceSetting;
    currentLicenseDetail.value.revenueShare = revenueSetting;
    
    showLicenseDetailModal.value = true;
  }
};

// 移除许可证
const removeLicense = (index: number) => {
  // 创建一个新的许可证数组，移除指定索引的许可证
  const updatedLicenses = [...props.licenses];
  updatedLicenses.splice(index, 1);
  
  // 发出事件更新许可证
  emit('license-update', updatedLicenses);
};

// 完成注册
const completeRegistration = () => {
  if (!isConfirmationComplete.value) return;
  
  // 整合所有数据以便发送
  const registrationData = {
    workType: props.workType,
    assetData: props.assetData,
    licenses: props.licenses,
    aiTrainingEnabled: props.aiTrainingEnabled,
    creators: props.creators
  };
  
  emit('registration-complete', registrationData);
};

// 获取资产类型名称
const getAssetTypeName = computed(() => {
  const types: Record<string, string> = {
    'image': '图片',
    'video': '视频',
    'audio': '音频',
    'text': '文档'
  };
  return types[assetType.value] || assetType.value;
});

// 判断许可证是否为当前资产类型的推荐许可证
const isLicenseRecommended = (license: string) => {
  // 基于资产类型的推荐许可证
  const recommendedLicenses: Record<string, string[]> = {
    'video': ['commercial', 'commercial-remix'],
    'image': ['open', 'non-commercial', 'commercial'],
    'audio': ['commercial-remix', 'non-commercial'],
    'text': ['open', 'non-commercial']
  };
  
  // 如果没有资产类型或没有该类型的推荐许可证，则所有许可证都不推荐
  if (!assetType.value || !recommendedLicenses[assetType.value]) {
    return false;
  }
  
  // 检查该许可证是否在推荐列表中
  return recommendedLicenses[assetType.value].includes(license);
};

// 导航到添加许可证页面
const navigateToAddLicense = () => {
  emit('navigate', 'license');
};

// 视频控制相关变量
const reviewVideoPaused = ref<{[key: number]: boolean}>({});
const reviewVideoMuted = ref<{[key: number]: boolean}>({});
const videoProgress = ref<{[key: number]: number}>({});
const videoIntervals = ref<{[key: number]: number}>({});

// 初始化审核页面视频
const initializeReviewVideo = (index: number, event: Event) => {
  const video = event.target as HTMLVideoElement;
  reviewVideoPaused.value[index] = video.paused;
  reviewVideoMuted.value[index] = true; // 默认静音
  videoProgress.value[index] = 0;
  
  // 暂停其他所有视频，只允许一个视频同时播放
  pauseAllVideosExcept(index);
  
  // 设置定时器更新进度条
  if (videoIntervals.value[index]) {
    clearInterval(videoIntervals.value[index]);
  }
  
  videoIntervals.value[index] = window.setInterval(() => {
    const videoElement = document.getElementById(`review-video-${index}`) as HTMLVideoElement;
    if (videoElement && videoElement.duration) {
      videoProgress.value[index] = (videoElement.currentTime / videoElement.duration) * 100;
    }
  }, 200);
};

// 暂停除指定索引外的所有视频
const pauseAllVideosExcept = (exceptIndex: number) => {
  // 查找所有视频元素
  const videos = document.querySelectorAll('video[id^="review-video-"]');
  videos.forEach((videoEl, idx) => {
    const videoElement = videoEl as HTMLVideoElement;
    const videoIndex = parseInt(videoElement.id.replace('review-video-', ''));
    
    if (videoIndex !== exceptIndex) {
      videoElement.pause();
      reviewVideoPaused.value[videoIndex] = true;
    }
  });
};

// 切换播放/暂停
const toggleReviewVideoPlay = (index: number) => {
  const videoElement = document.getElementById(`review-video-${index}`) as HTMLVideoElement;
  if (!videoElement) return;
  
  if (videoElement.paused) {
    // 暂停其他视频
    pauseAllVideosExcept(index);
    
    videoElement.play().then(() => {
      reviewVideoPaused.value[index] = false;
    }).catch(error => {
      console.error('播放失败:', error);
    });
  } else {
    videoElement.pause();
    reviewVideoPaused.value[index] = true;
  }
};

// 切换静音/取消静音
const toggleReviewVideoMute = (index: number) => {
  const videoElement = document.getElementById(`review-video-${index}`) as HTMLVideoElement;
  if (!videoElement) return;
  
  videoElement.muted = !videoElement.muted;
  reviewVideoMuted.value[index] = videoElement.muted;
};

// 切换全屏
const toggleReviewVideoFullscreen = (index: number) => {
  const videoElement = document.getElementById(`review-video-${index}`) as HTMLVideoElement;
  if (!videoElement) return;
  
  if (document.fullscreenElement) {
    document.exitFullscreen();
  } else {
    videoElement.requestFullscreen();
  }
};

// 拖动进度条
const seekVideo = (event: MouseEvent, index: number) => {
  const progressContainer = event.currentTarget as HTMLElement;
  const rect = progressContainer.getBoundingClientRect();
  const percent = (event.clientX - rect.left) / rect.width;
  
  const videoElement = document.getElementById(`review-video-${index}`) as HTMLVideoElement;
  if (videoElement && videoElement.duration) {
    videoElement.currentTime = percent * videoElement.duration;
    videoProgress.value[index] = percent * 100;
  }
};

// 清理所有定时器
onUnmounted(() => {
  // 清除所有视频进度更新定时器
  Object.values(videoIntervals.value).forEach(interval => {
    if (interval) {
      clearInterval(interval);
    }
  });
});

// 初始化页面时暂停所有视频播放
const pauseAllVideosOnLoad = () => {
  setTimeout(() => {
    const videos = document.querySelectorAll('video[id^="review-video-"]');
    videos.forEach((videoEl) => {
      const videoElement = videoEl as HTMLVideoElement;
      const videoIndex = parseInt(videoElement.id.replace('review-video-', ''));
      // 为了避免自动播放而导致多个视频同时播放的情况
      if (videoIndex !== 0) { // 可以选择让第一个视频继续播放
        videoElement.pause();
        reviewVideoPaused.value[videoIndex] = true;
      }
    });
  }, 500); // 短暂延迟，确保视频元素已加载
};

// 页面加载后调用
pauseAllVideosOnLoad();

// 滚动到视频元素时自动播放该视频
const setupIntersectionObserver = () => {
  if (typeof IntersectionObserver === 'undefined') return;
  
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting && entry.target instanceof HTMLElement) {
        const videoId = entry.target.querySelector('video')?.id;
        if (videoId) {
          const index = parseInt(videoId.replace('review-video-', ''));
          const videoElement = document.getElementById(videoId) as HTMLVideoElement;
          if (videoElement && videoElement.paused) {
            pauseAllVideosExcept(index);
            videoElement.play().then(() => {
              reviewVideoPaused.value[index] = false;
            }).catch(err => {
              console.error('自动播放失败:', err);
            });
          }
        }
      }
    });
  }, {
    threshold: 0.7 // 当70%的元素可见时触发
  });
  
  // 监听所有视频容器
  setTimeout(() => {
    const videoContainers = document.querySelectorAll('.preview-video');
    videoContainers.forEach(container => {
      observer.observe(container);
    });
  }, 1000);
  
  // 组件卸载时取消观察
  onUnmounted(() => {
    observer.disconnect();
  });
};

// 设置视频可见性观察器
setupIntersectionObserver();

// 获取作品类型和创作者类型的显示名称
const workTypeDisplay = computed(() => {
  // 主作品类型映射
  const mainTypeNames: Record<string, string> = {
    'newIP': '新IP',
    'remix': '混音'
  };
  
  // 创作者类型映射
  const creatorTypeNames: Record<string, string> = {
    'human': '人类创作',
    'humanAI': '人+AI'
  };
  
  const mainTypeName = props.workType.mainType ? mainTypeNames[props.workType.mainType] || props.workType.mainType : '';
  const creatorTypeName = props.workType.creatorType ? creatorTypeNames[props.workType.creatorType] || props.workType.creatorType : '';
  
  return {
    mainType: mainTypeName,
    creatorType: creatorTypeName,
    fullName: `${mainTypeName} (${creatorTypeName})`
  };
});

// Add script to handle hover animation speed for the complete button
onMounted(() => {
  const uiverseButton = document.querySelector('.review-register-container .uiverse');
  const circles = document.querySelectorAll('.review-register-container .uiverse .circle');

  if (uiverseButton) {
    uiverseButton.addEventListener('mouseenter', () => {
      circles.forEach(circle => {
        (circle as HTMLElement).style.animationDuration = '1.4s';
      });
    });

    uiverseButton.addEventListener('mouseleave', () => {
      circles.forEach(circle => {
        (circle as HTMLElement).style.animationDuration = '7s';
      });
    });
    
    // 立即触发一次动画效果，确保动画始终可见
    setTimeout(() => {
      circles.forEach(circle => {
        const currentDuration = (circle as HTMLElement).style.animationDuration;
        (circle as HTMLElement).style.animationDuration = '1.4s';
        
        setTimeout(() => {
          (circle as HTMLElement).style.animationDuration = currentDuration || '7s';
        }, 800);
      });
    }, 500);
  }
});

// 服务协议弹框控制
const showServiceAgreementModal = ref(false);

// 隐私政策弹框控制
const showPrivacyPolicyModal = ref(false);

// 修复视频全屏问题
const handleFullscreenChange = () => {
  // 更新视频全屏状态
  const isFullscreen = !!document.fullscreenElement;
  
  if (!isFullscreen) {
    // 退出全屏时重新播放所有视频
    Object.keys(videoIntervals.value).forEach(key => {
      const index = parseInt(key);
      const videoElement = document.getElementById(`review-video-${index}`) as HTMLVideoElement;
      if (videoElement && !reviewVideoPaused.value[index]) {
        videoElement.play();
      }
    });
  }
};

// 获取上传的原文件数量
const getOriginalFileCount = (index: number) => {
  // 从localStorage或window中获取对应许可证的上传文件数量
  try {
    // 检查window对象中是否有保存的文件
    // @ts-ignore
    const windowFiles = typeof window !== 'undefined' && window._uploadedLicenseFiles;
    
    if (windowFiles) {
      // 获取所有许可证类型
      const licenseTypes = ['commercial', 'commercial-remix', 'non-commercial', 'open'];
      
      // 遍历所有许可证类型，累计文件数量
      let totalFiles = 0;
      licenseTypes.forEach(licenseId => {
        if (windowFiles[licenseId] && Array.isArray(windowFiles[licenseId])) {
          totalFiles += windowFiles[licenseId].length;
        }
      });
      
      return totalFiles > 0 ? totalFiles : 1; // 至少显示1个文件
    }
    
    // 如果window对象中没有，尝试从localStorage获取
    let totalFiles = 0;
    for (const licenseId of ['commercial', 'commercial-remix', 'non-commercial', 'open']) {
      const storedFileInfo = typeof localStorage !== 'undefined' && localStorage.getItem(`uploaded_files_${licenseId}`);
      if (storedFileInfo) {
        const fileInfos = JSON.parse(storedFileInfo);
        totalFiles += fileInfos.length;
      }
    }
    
    return totalFiles > 0 ? totalFiles : 1; // 至少显示1个文件
  } catch (e) {
    console.error('获取文件数量失败:', e);
    return 1; // 默认至少显示1个文件
  }
};

// 获取许可证价格显示
const getLicensePrice = (license: string) => {
  if (license === 'commercial') {
    const price = props.commercialLicenseData.licensePrice || '0';
    return price ? `${price} ¥` : '价格未设置';
  } else if (license === 'commercial-remix') {
    const price = props.commercialRemixLicenseData.licensePrice || '0';
    const revenueShare = props.commercialRemixLicenseData.revenueShare || '0';
    
    if (price && revenueShare && revenueShare !== '0') {
      return `${price} ¥ + ${revenueShare}% 分成`;
    } else if (price) {
      return `${price} ¥`;
    } else if (revenueShare && revenueShare !== '0') {
      return `${revenueShare}% 分成`;
    } else {
      return '价格未设置';
    }
  }
  return '';
};
</script>

<style scoped>
.review-register-container {
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
  padding: 30px;
  color: #fff;
}

.page-title {
  font-size: 32px;
  margin-bottom: 8px;
  font-weight: normal;
  line-height: 1.2;
}

.page-subtitle {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 30px;
}

.review-content {
  display: flex;
  flex-direction: column;
  gap: 25px;
}

/* 调整资产部分的上边距，使标题向上移动 */
.asset-section {
  margin-bottom: 20px;
  margin-top: -10px;
}

.section-title {
  font-size: 18px;
  font-weight: 500;
  margin-bottom: 15px;
  color: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  position: relative;
  top: -5px;
}

.section-title svg {
  width: 20px;
  height: 20px;
  margin-right: 8px;
  fill: currentColor;
  vertical-align: middle;
}

/* 资产预览部分 */
.asset-section {
  margin-bottom: 20px;
}

.asset-name-display {
  background: rgba(30, 30, 35, 0.6);
  border-radius: 12px;
  padding: 15px 20px;
  margin-bottom: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.asset-name {
  font-size: 18px;
  font-weight: 500;
  color: white;
}

.asset-type-tag {
  background: rgba(52, 152, 219, 0.2);
  color: rgba(52, 152, 219, 0.9);
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
}

.assets-carousel {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
  width: 100%;
  margin-top: 20px;
  max-width: 100%;
  overflow-x: auto;
}

.asset-preview {
  background: rgba(30, 30, 35, 0.7);
  border-radius: 15px;
  overflow: hidden;
  min-width: 180px;
  max-width: 350px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
  position: relative;
}

.asset-preview:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  border-color: rgba(255, 255, 255, 0.2);
}

.asset-preview-image {
  width: 100%;
  height: 200px;
  background: #18181f;
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.asset-preview:hover .preview-image {
  transform: scale(1.05);
}

.preview-video {
  width: 100%;
  height: 100%;
  position: relative;
  overflow: hidden;
  border-radius: 8px;
  background-color: #000;
}

.preview-media {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.video-controls {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  padding: 15px;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
  display: flex;
  flex-direction: column;
  gap: 10px;
  opacity: 0;
  transition: opacity 0.3s;
  z-index: 10;
}

.preview-video:hover .video-controls {
  opacity: 1;
}

/* 视频播放指示器 */
.preview-video::after {
  content: '';
  position: absolute;
  bottom: 10px;
  right: 10px;
  width: 8px;
  height: 8px;
  background-color: #3498db;
  border-radius: 50%;
  opacity: 0;
  transition: opacity 0.3s;
}

.preview-video:not(.paused)::after {
  opacity: 1;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% {
    transform: scale(0.95);
    box-shadow: 0 0 0 0 rgba(52, 152, 219, 0.7);
  }
  
  70% {
    transform: scale(1);
    box-shadow: 0 0 0 6px rgba(52, 152, 219, 0);
  }
  
  100% {
    transform: scale(0.95);
    box-shadow: 0 0 0 0 rgba(52, 152, 219, 0);
  }
}

.video-progress-container {
  width: 100%;
  height: 12px;
  cursor: pointer;
  position: relative;
}

.video-progress-bar {
  width: 100%;
  height: 6px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
  overflow: hidden;
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
}

.video-progress {
  height: 100%;
  background: #3498db;
  border-radius: 3px;
  transition: width 0.1s linear;
}

.video-buttons {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
}

.video-control-btn {
  background: rgba(0, 0, 0, 0.5);
  border: none;
  color: white;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 16px;
  backdrop-filter: blur(2px);
}

.video-control-btn:hover {
  background: rgba(52, 152, 219, 0.7);
  transform: scale(1.1);
}

.preview-audio, .preview-doc {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.audio-info, .doc-info {
  margin-top: 10px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  max-width: 90%;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.file-type-icon {
  font-size: 40px;
}

.asset-info {
  padding: 8px 12px 36px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  position: relative;
  min-height: 70px;
}

.info-label {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 3px;
}

.asset-id {
  font-size: 14px;
  font-weight: bold;
  margin-bottom: 2px;
}

.creators-info {
  position: absolute;
  left: 12px;
  bottom: 10px;
  z-index: 5;
}

.creators-avatars {
  display: flex;
  align-items: center;
}

.creator-avatar {
  width: 22px;
  height: 22px;
  border-radius: 50%;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(52, 152, 219, 0.2);
  position: relative;
  transition: all 0.3s ease;
  border: 1.5px solid transparent;
}

.creator-avatar:hover {
  transform: scale(1.1);
  z-index: 15;
  box-shadow: 0 0 15px rgba(114, 137, 218, 0.7);
  border-color: rgba(114, 137, 218, 0.7);
}

.animated-tooltip-trigger:hover .creator-avatar {
  transform: scale(1.1);
  z-index: 15;
  box-shadow: 0 0 15px rgba(114, 137, 218, 0.7);
  border-color: rgba(114, 137, 218, 0.7);
}

.creator-avatar.main-creator {
  background: rgba(255, 193, 7, 0.2);
  border: 2px solid rgba(255, 193, 7, 0.5);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  cursor: pointer;
}

.creator-avatar.main-creator:hover {
  transform: scale(1.15);
  z-index: 20;
  box-shadow: 0 0 15px rgba(255, 193, 7, 0.8);
  border-color: rgba(255, 193, 7, 0.8);
}

.creator-avatar.co-creator {
  background: rgba(52, 152, 219, 0.2);
  border: 2px solid rgba(52, 152, 219, 0.3);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  cursor: pointer;
}

.creator-avatar.co-creator:hover {
  transform: scale(1.15);
  z-index: 20;
  box-shadow: 0 0 15px rgba(52, 152, 219, 0.8);
  border-color: rgba(52, 152, 219, 0.8);
}

.creator-avatar.more-count {
  background: rgba(156, 39, 176, 0.2);
  border: 2px solid rgba(156, 39, 176, 0.3);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  cursor: pointer;
}

.creator-avatar.more-count:hover {
  transform: scale(1.15);
  z-index: 20;
  box-shadow: 0 0 15px rgba(156, 39, 176, 0.8);
  border-color: rgba(156, 39, 176, 0.8);
}

.avatar-icon {
  font-size: 12px;
}

/* 许可证部分 */
.licenses-section {
  margin-bottom: 25px;
  background: rgba(25, 25, 35, 0.3);
  border-radius: 18px;
  padding: 20px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 10px;
  padding-bottom: 15px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.section-title {
  font-size: 18px;
  font-weight: 500;
  margin-bottom: 0;
  color: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
}

.section-title svg {
  width: 20px;
  height: 20px;
  margin-right: 8px;
  fill: currentColor;
  vertical-align: middle;
}

.add-license-btn {
  background: rgba(74, 103, 207, 0.15);
  border: 1px solid rgba(74, 103, 207, 0.3);
  color: white;
  padding: 10px 16px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  display: flex;
  align-items: center;
  gap: 6px;
}

.add-license-btn:before {
  content: "+";
  font-size: 16px;
  font-weight: bold;
}

.add-license-btn:hover {
  background: rgba(74, 103, 207, 0.25);
  border-color: rgba(74, 103, 207, 0.5);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(74, 103, 207, 0.2);
}

.add-license-btn:active {
  transform: translateY(0px);
}

.add-license-btn.highlight-btn {
  background: rgba(52, 152, 219, 0.3);
  border-color: rgba(52, 152, 219, 0.8);
  color: #fff;
  animation: pulse-border 2s infinite;
  box-shadow: 0 0 10px rgba(52, 152, 219, 0.4);
}

.add-license-btn.highlight-btn:hover {
  background: rgba(52, 152, 219, 0.5);
  transform: translateY(-2px);
}

@keyframes pulse-border {
  0% {
    border-color: rgba(52, 152, 219, 0.5);
    box-shadow: 0 0 5px rgba(52, 152, 219, 0.4);
  }
  50% {
    border-color: rgba(52, 152, 219, 1);
    box-shadow: 0 0 15px rgba(52, 152, 219, 0.6);
  }
  100% {
    border-color: rgba(52, 152, 219, 0.5);
    box-shadow: 0 0 5px rgba(52, 152, 219, 0.4);
  }
}

.license-list {
  background: rgba(20, 20, 30, 0.3);
  border-radius: 16px;
  overflow: hidden;
  padding: 12px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
}

.license-item {
  background: rgba(25, 25, 30, 0.8);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 0.2s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.license-item:hover {
  background: rgba(35, 35, 40, 0.8);
  transform: none;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
}

.license-content {
  display: flex;
  flex-direction: column;
  gap: 5px;
  position: relative;
}

.license-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 5px;
}

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
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
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

.file-lock-indicator svg {
  width: 12px;
  height: 12px;
}

.file-lock-indicator .file-count {
  position: relative;
  top: 1px;
}

.license-name {
  font-size: 16px;
  font-weight: 600;
  color: white;
  margin-right: 8px;
}

.license-price {
  display: flex;
  margin-top: 8px;
}

.price-tag {
  display: flex;
  align-items: center;
  gap: 5px;
  background: transparent;
  color: #00E676;
  padding: 0;
  font-size: 15px;
  font-weight: 600;
}

.price-tag svg {
  color: #00E676;
  fill: currentColor;
}

/* 文件计数指示器样式 - 调整适合许可证内部显示 */
.license-content .file-count-indicator {
  position: relative;
  margin-top: 8px;
  align-self: flex-start;
  display: flex;
  align-items: center;
  gap: 4px;
  background-color: rgba(255, 255, 255, 0.15);
  padding: 4px 8px;
  border-radius: 16px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.license-content .file-count-indicator:hover {
  background-color: rgba(52, 152, 219, 0.4);
  transform: translateY(-1px);
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
}

.license-content .file-count-indicator svg {
  color: currentColor;
  width: 14px;
  height: 14px;
  fill: currentColor;
}

.license-content .file-count {
  font-weight: 500;
}

.license-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.license-compatibility {
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(46, 204, 113, 0.2);
  color: rgb(46, 204, 113);
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 12px;
}

.license-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}

.license-detail-btn, .license-remove-btn {
  background: none;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  position: relative;
  overflow: hidden;
}

.license-detail-btn {
  background: rgba(74, 103, 207, 0.15);
  border: 1px solid rgba(74, 103, 207, 0.2);
}

.license-detail-btn:hover {
  background: rgba(74, 103, 207, 0.25);
  transform: scale(1.1);
  box-shadow: 0 0 15px rgba(74, 103, 207, 0.3);
}

.license-remove-btn {
  background: rgba(231, 76, 60, 0.1);
  border: 1px solid rgba(231, 76, 60, 0.2);
}

.license-remove-btn:hover {
  background: rgba(231, 76, 60, 0.2);
  transform: scale(1.1);
  box-shadow: 0 0 15px rgba(231, 76, 60, 0.3);
}

.action-icon {
  color: rgba(231, 76, 60, 0.9);
  font-size: 12px;
  text-shadow: 0 0 3px rgba(231, 76, 60, 0.3);
}

/* 放大镜按钮样式增强 */
.magnify-btn {
  position: relative;
  background: rgba(74, 103, 207, 0.15);
  overflow: hidden;
}

.magnify-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: radial-gradient(circle at center, rgba(114, 137, 218, 0.3) 0%, transparent 70%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.magnify-btn:hover {
  background: rgba(74, 103, 207, 0.25);
  border-color: rgba(74, 103, 207, 0.3);
  transform: scale(1.1);
  box-shadow: 0 0 15px rgba(74, 103, 207, 0.3);
}

.magnify-btn:hover::before {
  opacity: 1;
  animation: pulse 2s infinite;
}

.magnify-btn:active {
  transform: scale(0.95);
}

.magnify-btn svg {
  position: relative;
  z-index: 2;
  filter: drop-shadow(0 1px 2px rgba(0,0,0,0.3));
}

@keyframes pulse {
  0% {
    opacity: 0.3;
    transform: scale(0.95);
  }
  70% {
    opacity: 0.5;
    transform: scale(1.05);
  }
  100% {
    opacity: 0.3;
    transform: scale(0.95);
  }
}

/* 动画提示框样式 */
.animated-tooltip-trigger {
  position: relative;
  cursor: pointer;
}

.animated-tooltip {
  position: absolute;
  bottom: 110%;
  left: 50%;
  transform: translateX(-50%) translateY(10px);
  min-width: 180px;
  background: rgba(29, 36, 59, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 8px;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.4), 0 0 0 1px rgba(255, 255, 255, 0.1) inset;
  padding: 0;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55);
  z-index: 100;
  overflow: hidden;
  pointer-events: none;
  border: 1px solid transparent;
}

.animated-tooltip-trigger:hover .animated-tooltip {
  opacity: 1;
  visibility: visible;
  transform: translateX(-50%) translateY(0);
  border-color: rgba(114, 137, 218, 0.4);
  box-shadow: 
    0 5px 20px rgba(0, 0, 0, 0.4), 
    0 0 0 1px rgba(255, 255, 255, 0.1) inset,
    0 0 15px rgba(114, 137, 218, 0.3);
  animation: tooltipGlow 1.5s ease-in-out infinite;
}

@keyframes tooltipGlow {
  0% {
    border-color: rgba(114, 137, 218, 0.4);
    box-shadow: 
      0 5px 20px rgba(0, 0, 0, 0.4), 
      0 0 0 1px rgba(255, 255, 255, 0.1) inset,
      0 0 15px rgba(114, 137, 218, 0.3);
  }
  50% {
    border-color: rgba(114, 137, 218, 0.7);
    box-shadow: 
      0 5px 20px rgba(0, 0, 0, 0.4), 
      0 0 0 1px rgba(255, 255, 255, 0.1) inset,
      0 0 20px rgba(114, 137, 218, 0.5);
  }
  100% {
    border-color: rgba(114, 137, 218, 0.4);
    box-shadow: 
      0 5px 20px rgba(0, 0, 0, 0.4), 
      0 0 0 1px rgba(255, 255, 255, 0.1) inset,
      0 0 15px rgba(114, 137, 218, 0.3);
  }
}

.tooltip-content {
  padding: 10px 14px;
  background: linear-gradient(135deg, rgba(41, 50, 81, 0.95) 0%, rgba(29, 36, 59, 0.95) 100%);
  border-radius: 6px;
  position: relative;
  overflow: hidden;
}

.tooltip-title {
  font-weight: 600;
  font-size: 14px;
  margin-bottom: 4px;
  background: linear-gradient(to right, #ffffff, #e0e7ff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  display: inline-block;
}

.tooltip-detail {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.8);
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
}

.tooltip-badge {
  display: inline-block;
  font-size: 11px;
  padding: 3px 8px;
  background: linear-gradient(90deg, #4a67cf, #7289da);
  border-radius: 12px;
  color: white;
  margin-top: 2px;
  box-shadow: 0 2px 6px rgba(74, 103, 207, 0.5);
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.tooltip-list-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  font-size: 13px;
  color: white;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.2s ease;
  position: relative;
  overflow: hidden;
}

.tooltip-list-item:hover {
  background-color: rgba(114, 137, 218, 0.15);
  padding-left: 5px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.tooltip-list-item:hover::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  width: 3px;
  background: linear-gradient(to bottom, #7289da, #4a67cf);
}

.tooltip-list-item:first-child {
  border-top: none;
}

.tooltip-list-detail {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
  margin-left: 10px;
  transition: all 0.2s ease;
}

.tooltip-list-item:hover .tooltip-list-detail {
  color: rgba(255, 255, 255, 0.9);
}

/* 在移动设备上调整提示框位置 */
@media (max-width: 768px) {
  .animated-tooltip {
    width: 160px;
    bottom: 100%;
  }
}

/* 确认选项部分 */
.confirmation-section {
  margin-bottom: 30px;
}

.confirmation-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 15px;
  cursor: pointer;
}

.checkbox {
  width: 22px;
  height: 22px;
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-radius: 4px;
  margin-right: 12px;
  margin-top: 2px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: all 0.2s;
}

.checkbox.checked {
  background: rgba(52, 152, 219, 0.8);
  border-color: rgba(52, 152, 219, 0.8);
}

.check {
  color: white;
  font-size: 14px;
  font-weight: bold;
}

.confirmation-text {
  font-size: 14px;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.9);
}

.terms-link {
  color: rgb(52, 152, 219);
  text-decoration: none;
}

.terms-link:hover {
  text-decoration: underline;
}

/* 底部导航按钮 */
.navigation-section {
  width: 100%;
  max-width: 600px;
  margin: 30px auto 0;
}

.back-btn, .next-btn {
  padding: 10px 20px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.3s;
  color: white;
  font-size: 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.back-btn {
  background: rgba(255, 255, 255, 0.1);
}

.back-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

/* Uiverse button style */
.uiverse {
  --duration: 7s;
  --easing: linear;
  --c-color-1: #ffd58c;
  --c-color-2: #69a5ff;
  --c-color-3: #c29fff;
  --c-color-4: rgba(140, 232, 255, 0.8);
  --c-shadow: rgba(99, 85, 255, 0.7);
  --c-shadow-inset-top: rgba(132, 156, 255, 0.9);
  --c-shadow-inset-bottom: rgba(62, 145, 255, 0.7);
  --c-radial-inner: #2f3fbb;
  --c-radial-outer: #5264fa;
  --c-color: #ffffff;
  -webkit-tap-highlight-color: transparent;
  -webkit-appearance: none;
  outline: none;
  position: relative;
  cursor: pointer;
  border: none;
  display: table;
  border-radius: 24px;
  padding: 0;
  margin: 0;
  text-align: center;
  font-weight: 600;
  font-size: 16px;
  letter-spacing: 0.05em;
  line-height: 1.5;
  color: var(--c-color);
  background: radial-gradient(
    circle,
    var(--c-radial-inner),
    var(--c-radial-outer) 80%
  );
  box-shadow: 0 0 14px var(--c-shadow);
}

.uiverse:before {
  content: "";
  pointer-events: none;
  position: absolute;
  z-index: 3;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  border-radius: 28px;
  box-shadow:
    inset 0 3px 12px var(--c-shadow-inset-top),
    inset 0 -3px 4px var(--c-shadow-inset-bottom);
}

.uiverse .wrapper {
  -webkit-mask-image: -webkit-radial-gradient(white, black);
  overflow: hidden;
  border-radius: 26px;
  min-width: 132px;
  padding: 12px 24px;
}

.uiverse .wrapper span {
  display: inline-block;
  position: relative;
  z-index: 1;
}

.uiverse:hover {
  --duration: 1400ms;
}

.uiverse:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  --c-radial-inner: #6c6c6c;
  --c-radial-outer: #9c9c9c;
  --c-shadow: rgba(99, 99, 99, 0.59);
}

.uiverse:disabled .wrapper span {
  opacity: 0.8;
}

.uiverse:disabled .wrapper .circle {
  opacity: 0.5;
}

.uiverse .wrapper .circle {
  position: absolute;
  left: 0;
  top: 0;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  filter: blur(var(--blur, 8px));
  background: var(--background, transparent);
  transform: translate(var(--x, 0), var(--y, 0)) translateZ(0);
  animation-name: var(--animation) !important;
  animation-duration: var(--duration) !important;
  animation-timing-function: var(--easing) !important;
  animation-iteration-count: infinite !important;
}

.uiverse .wrapper .circle.circle-1,
.uiverse .wrapper .circle.circle-9,
.uiverse .wrapper .circle.circle-10 {
  --background: var(--c-color-4);
}

.uiverse .wrapper .circle.circle-3,
.uiverse .wrapper .circle.circle-4 {
  --background: var(--c-color-2);
  --blur: 14px;
}

.uiverse .wrapper .circle.circle-5,
.uiverse .wrapper .circle.circle-6 {
  --background: var(--c-color-3);
  --blur: 16px;
}

.uiverse .wrapper .circle.circle-2,
.uiverse .wrapper .circle.circle-7,
.uiverse .wrapper .circle.circle-8,
.uiverse .wrapper .circle.circle-11,
.uiverse .wrapper .circle.circle-12 {
  --background: var(--c-color-1);
  --blur: 12px;
}

.uiverse .wrapper .circle.circle-1 {
  --x: 0;
  --y: -40px;
  --animation: circle-1;
}

.uiverse .wrapper .circle.circle-2 {
  --x: 92px;
  --y: 8px;
  --animation: circle-2;
}

.uiverse .wrapper .circle.circle-3 {
  --x: -12px;
  --y: -12px;
  --animation: circle-3;
}

.uiverse .wrapper .circle.circle-4 {
  --x: 80px;
  --y: -12px;
  --animation: circle-4;
}

.uiverse .wrapper .circle.circle-5 {
  --x: 12px;
  --y: -4px;
  --animation: circle-5;
}

.uiverse .wrapper .circle.circle-6 {
  --x: 56px;
  --y: 16px;
  --animation: circle-6;
}

.uiverse .wrapper .circle.circle-7 {
  --x: 8px;
  --y: 28px;
  --animation: circle-7;
}

.uiverse .wrapper .circle.circle-8 {
  --x: 28px;
  --y: -4px;
  --animation: circle-8;
}

.uiverse .wrapper .circle.circle-9 {
  --x: 20px;
  --y: -12px;
  --animation: circle-9;
}

.uiverse .wrapper .circle.circle-10 {
  --x: 64px;
  --y: 16px;
  --animation: circle-10;
}

.uiverse .wrapper .circle.circle-11 {
  --x: 4px;
  --y: 4px;
  --animation: circle-11;
}

.uiverse .wrapper .circle.circle-12 {
  --blur: 14px;
  --x: 52px;
  --y: 4px;
  --animation: circle-12;
}

@keyframes circle-1 {
  33% {
    transform: translate(0px, 16px) translateZ(0);
  }

  66% {
    transform: translate(12px, 64px) translateZ(0);
  }
}

@keyframes circle-2 {
  33% {
    transform: translate(80px, -10px) translateZ(0);
  }

  66% {
    transform: translate(72px, -48px) translateZ(0);
  }
}

@keyframes circle-3 {
  33% {
    transform: translate(20px, 12px) translateZ(0);
  }

  66% {
    transform: translate(12px, 4px) translateZ(0);
  }
}

@keyframes circle-4 {
  33% {
    transform: translate(76px, -12px) translateZ(0);
  }

  66% {
    transform: translate(112px, -8px) translateZ(0);
  }
}

@keyframes circle-5 {
  33% {
    transform: translate(84px, 28px) translateZ(0);
  }

  66% {
    transform: translate(40px, -32px) translateZ(0);
  }
}

@keyframes circle-6 {
  33% {
    transform: translate(28px, -16px) translateZ(0);
  }

  66% {
    transform: translate(76px, -56px) translateZ(0);
  }
}

@keyframes circle-7 {
  33% {
    transform: translate(8px, 28px) translateZ(0);
  }

  66% {
    transform: translate(20px, -60px) translateZ(0);
  }
}

@keyframes circle-8 {
  33% {
    transform: translate(32px, -4px) translateZ(0);
  }

  66% {
    transform: translate(56px, -20px) translateZ(0);
  }
}

@keyframes circle-9 {
  33% {
    transform: translate(20px, -12px) translateZ(0);
  }

  66% {
    transform: translate(80px, -8px) translateZ(0);
  }
}

@keyframes circle-10 {
  33% {
    transform: translate(68px, 20px) translateZ(0);
  }

  66% {
    transform: translate(100px, 28px) translateZ(0);
  }
}

@keyframes circle-11 {
  33% {
    transform: translate(4px, 4px) translateZ(0);
  }

  66% {
    transform: translate(68px, 20px) translateZ(0);
  }
}

@keyframes circle-12 {
  33% {
    transform: translate(56px, 0px) translateZ(0);
  }

  66% {
    transform: translate(60px, -32px) translateZ(0);
  }
}

/* 响应式布局 */
@media (max-width: 1200px) {
  .assets-carousel {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .asset-preview-image {
    height: 280px;
  }
}

@media (max-width: 900px) {
  .assets-carousel {
    grid-template-columns: repeat(1, 1fr);
  }
  
  .asset-preview-image {
    height: 320px;
  }
}

.asset-type-badge {
  display: inline-flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 4px 12px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.8);
  margin-right: 10px;
}

.asset-type-name {
  font-weight: bold;
  color: white;
  margin-left: 4px;
}

.work-type-badge {
  display: inline-flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 4px 12px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.8);
  margin-right: 10px;
}

.work-type-name {
  font-weight: bold;
  color: white;
  margin-left: 4px;
}

.creator-type-pill {
  background: rgba(52, 152, 219, 0.2);
  color: rgba(52, 152, 219, 0.9);
  padding: 5px 10px;
  border-radius: 12px;
  font-size: 11px;
  margin-left: 8px;
  font-weight: 500;
  display: inline-block;
}

.arrow-icon {
  width: 32px;
  height: 32px;
  fill: currentColor;
}

.arrow-back {
  transform: rotate(180deg);
}

.animated-tooltip-trigger:hover .tooltip-content {
  animation: gentle-pulse 2s ease-in-out infinite;
}

@keyframes gentle-pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.02);
  }
  100% {
    transform: scale(1);
  }
}

.tooltip-title {
  background: linear-gradient(90deg, #ffffff, #e0e7ff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  display: inline-block;
}

.animated-tooltip::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, #7289da, #c29fff, #69a5ff);
  background-size: 200% 100%;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.animated-tooltip-trigger:hover .animated-tooltip::after {
  opacity: 1;
  animation: gradientFlow 3s ease infinite;
}

@keyframes gradientFlow {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

.empty-licenses {
  padding: 30px;
  text-align: center;
  color: rgba(255, 255, 255, 0.6);
  font-style: italic;
  background: rgba(35, 35, 50, 0.3);
  border-radius: 12px;
  border: 1px dashed rgba(74, 103, 207, 0.3);
  margin: 10px 0;
  position: relative;
  overflow: hidden;
}

.empty-licenses:before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(to right,
    rgba(74, 103, 207, 0),
    rgba(74, 103, 207, 0.5) 50%,
    rgba(74, 103, 207, 0)
  );
  opacity: 0.6;
}

.license-required-warning {
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 15px;
  padding: 10px;
  background: rgba(231, 76, 60, 0.1);
  border-radius: 8px;
  border: 1px solid rgba(231, 76, 60, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
}

.warning-icon {
  margin-right: 8px;
  font-size: 18px;
}

.warning-text {
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.3px;
}

.empty-text {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.5);
  margin-top: 5px;
}

/* 注册提示信息 */
.registration-tips {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
  padding: 10px;
  background: rgba(30, 30, 35, 0.3);
  border-radius: 12px;
  border: 1px dashed rgba(255, 255, 255, 0.1);
}

.tips-icon {
  margin-right: 5px;
}

.tips-content {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

/* 创建者头像和更多计数 */
.creator-avatar.more-count .avatar-icon {
  font-size: 12px;
  font-weight: bold;
}

/* 文件计数指示器样式 */
.file-count-indicator {
  display: flex;
  align-items: center;
  gap: 4px;
  background-color: rgba(255, 255, 255, 0.15);
  padding: 4px 8px;
  border-radius: 16px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  position: absolute;
  bottom: 10px;
  right: 10px;
  z-index: 5;
  transition: all 0.3s ease;
}

.file-count-indicator svg {
  color: currentColor;
  width: 16px;
  height: 16px;
  fill: currentColor;
}

.file-count {
  font-weight: 500;
}

.asset-preview:hover .file-count-indicator {
  background-color: rgba(52, 152, 219, 0.4);
  color: white;
  transform: translateY(-2px);
}

/* 动画提示框样式 */
.file-icon-tooltip {
  display: flex;
  align-items: center;
  gap: 4px;
  position: relative;
  cursor: pointer;
}

.file-icon-tooltip svg {
  color: currentColor;
  width: 16px;
  height: 16px;
  fill: currentColor;
  transition: transform 0.3s ease;
}

.file-icon-tooltip:hover svg {
  transform: scale(1.15);
}

.icon-tooltip {
  font-size: 12px;
  color: #ffffff;
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%) translateY(10px);
  white-space: nowrap;
  background: rgba(0, 0, 0, 0.75);
  padding: 5px 10px;
  border-radius: 4px;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
  z-index: 10;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  font-weight: 500;
  pointer-events: none;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.icon-tooltip::after {
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

.file-icon-tooltip:hover .icon-tooltip {
  opacity: 1;
  visibility: visible;
  transform: translateX(-50%) translateY(0);
}

.preview-image.audio-cover {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.preview-image.doc-cover {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

/* 商业许可证锁图标样式 */
.license-actions .file-icon-tooltip {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(74, 103, 207, 0.15);
  border: 1px solid rgba(74, 103, 207, 0.2);
  transition: all 0.3s;
  cursor: pointer;
  position: relative;
}

.license-actions .file-icon-tooltip:hover {
  background: rgba(74, 103, 207, 0.25);
  transform: scale(1.1);
  box-shadow: 0 0 15px rgba(74, 103, 207, 0.3);
}

.license-actions .file-icon-tooltip svg {
  fill: rgba(255, 255, 255, 0.8);
  filter: drop-shadow(0 1px 2px rgba(0, 0, 0, 0.3));
}

.license-actions .file-icon-tooltip .icon-tooltip {
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(20, 20, 25, 0.9);
  color: white;
  font-size: 12px;
  padding: 4px 8px;
  border-radius: 4px;
  white-space: nowrap;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s;
  pointer-events: none;
  z-index: 10;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
}

.license-actions .file-icon-tooltip .icon-tooltip::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  border-width: 5px;
  border-style: solid;
  border-color: rgba(20, 20, 25, 0.9) transparent transparent transparent;
}

.license-actions .file-icon-tooltip:hover .icon-tooltip {
  opacity: 1;
  visibility: visible;
  top: -35px;
}
</style> 