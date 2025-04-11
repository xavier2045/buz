<template>
  <div class="asset-details-container">
    <h1 class="page-title">添加资产详细信息</h1>

    <!-- 资产名称输入 -->
    <div class="form-group">
      <label for="assetName">为您的资产命名</label>
      <input 
        type="text" 
        id="assetName" 
        v-model="assetName" 
        placeholder="输入资产名称"
        class="input-field"
      >
    </div>

    <!-- 上传资产选项卡 -->
    <div class="upload-tabs">
      <div 
        :class="['upload-tab', { active: activeUploadMethod === 'file' }]"
        @click="activeUploadMethod = 'file'"
      >
        上传资产
      </div>
      <div 
        :class="['upload-tab', { active: activeUploadMethod === 'wallet' }]"
        @click="activeUploadMethod = 'wallet'"
      >
        从已有作品中选择
      </div>
    </div>

    <!-- 资产类型选择区域 -->
    <div v-if="activeUploadMethod === 'file'" class="asset-type-section">
      <div class="asset-type-grid">
        <div 
          v-for="type in assetTypes" 
          :key="type.id"
          class="asset-type-card"
          :class="{ 
            selected: selectedAssetType === type.id,
            disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== type.id
          }"
          :data-type="type.id"
          @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === type.id ? selectAssetType(type.id) : null"
        >
          <div class="asset-type-content">
            <div class="asset-type-icon" v-html="type.icon"></div>
            <p class="asset-type-name">{{ type.name }}</p>
            <div v-if="selectedAssetType === type.id" class="selected-mark">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="12" cy="12" r="10" fill="currentColor" fill-opacity="0.3"/>
                <path d="M8 12L11 15L16 9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 选择了资产类型后显示上传区域 -->
      <div v-if="selectedAssetType" class="upload-area-container">
        <div class="upload-header">
          <h3>上传文件</h3>
          <p class="file-types">支持的文件类型:</p>
          <p class="file-types">{{ getSupportedFileTypes }}</p>
          <p class="file-size">最大大小1000MB</p>
          <p class="upload-type-info">
            <span class="info-icon">⚠️</span>
            <span>您已选择{{ getAssetTypeName }}类，仅能上传对应类型的文件。上传文件后将无法切换类别。</span>
          </p>
        </div>

        <!-- 音频或文本类型的封面上传区域 -->
        <div v-if="['audio', 'text'].includes(selectedAssetType) && !coverImage" class="cover-upload-section">
          <h4 class="cover-upload-title">添加封面图片（推荐）</h4>
          <p class="cover-upload-desc">为您的{{ getAssetTypeName }}资产添加封面图片，以便更好地展示。</p>
          
          <div class="cover-upload-area" 
            @click="triggerCoverUpload" 
            @dragover="dragOverCoverZone"
            @dragleave="dragLeaveCoverZone"
            @drop="onCoverDrop"
          >
            <div class="upload-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                <circle cx="8.5" cy="8.5" r="1.5"/>
                <polyline points="21 15 16 10 5 21"/>
              </svg>
            </div>
            <p class="upload-text">上传封面图片</p>
            <p class="upload-subtext">支持JPG、PNG、WEBP格式，建议尺寸1000x1000像素</p>
            <input 
              type="file" 
              ref="coverInput" 
              class="hidden-file-input"
              @change="handleCoverSelect"
              accept=".jpg,.jpeg,.png,.webp"
            >
          </div>
        </div>

        <!-- 显示已上传的封面 -->
        <div v-if="coverImage" class="cover-preview-container">
          <div class="cover-preview">
            <img :src="coverImage.url" alt="Cover" class="cover-preview-image">
            <div class="cover-info">
              <span class="cover-filename">{{ coverImage.name }}</span>
              <span class="cover-dimensions">{{ coverImage.dimensions || '加载中...' }}</span>
            </div>
            <button class="remove-cover-btn" @click="removeCover" title="移除封面">×</button>
          </div>
        </div>

        <!-- 上传文件预览区域 -->
        <div v-if="uploadedFiles.length > 0" class="uploaded-files-preview">
          <div class="uploaded-files-grid">
            <div 
              v-for="(file, index) in uploadedFiles" 
              :key="index" 
              class="uploaded-file-item"
              draggable="true"
              @dragstart="dragStart(index, $event)"
              @dragover.prevent
              @dragenter.prevent="dragEnter($event)"
              @dragleave.prevent="dragLeave($event)"
              @drop.prevent="drop(index, $event)"
            >
              <div class="file-preview-container">
                <!-- 图片预览 -->
                <template v-if="file.type.startsWith('image/')">
                  <div class="image-wrapper">
                    <img :src="file.url" class="file-preview-image" :data-filename="file.name" @click="previewImageFullscreen(file.url, file.name)" />
                    <div class="image-info-badge">
                      {{ file.dimensions || '加载中...' }} | {{ formatFileSize(file.size) }}
                    </div>
                    <!-- 图片控制按钮 -->
                    <div class="image-preview-controls">
                      <button class="image-control-btn" @click.stop="previewImageFullscreen(file.url, file.name)" title="全屏预览">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M8 3H5a2 2 0 0 0-2 2v3M21 8V5a2 2 0 0 0-2-2h-3M3 16v3a2 2 0 0 0 2 2h3M16 21h3a2 2 0 0 0 2-2v-3" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                      </button>
                      <button class="image-control-btn" title="下载">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                      </button>
                    </div>
                  </div>
                </template>
                
                <!-- 视频预览 -->
                <div v-else-if="file.type.startsWith('video/')" class="file-preview-video" :class="{ 'playing': !videoStatus[index], 'loading': videoLoading[index] }" :data-filename="file.name">
                  <video 
                    :id="`video-${index}`"
                    muted 
                    autoplay 
                    loop 
                    class="file-preview-media"
                    @loadstart="handleVideoLoadStart(index)"
                    @loadeddata="initializeVideo(index, $event)"
                    @error="handleVideoError(index, $event)"
                    @click.stop="toggleVideoPlay(index, $event)"
                  >
                    <source :src="file.url" :type="file.type">
                  </video>
                  <div class="video-controls">
                    <div class="video-progress-bar" @click="seekVideo($event, index)">
                      <div class="video-progress" :style="{ width: `${videoProgress[index] || 0}%` }"></div>
                    </div>
                    <div class="video-control-buttons">
                      <button class="video-btn volume-btn" @click.stop="toggleMute(index, $event)" title="静音/取消静音">
                        <svg v-if="videoMuted[index]" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M11 5L6 9H2v6h4l5 4V5z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="white"/>
                          <path d="M23 9l-6 6M17 9l6 6" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                        <svg v-else width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M11 5L6 9H2v6h4l5 4V5z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="white"/>
                          <path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                      </button>
                      <button class="video-btn play-btn" @click.stop="toggleVideoPlay(index, $event)" title="播放/暂停">
                        <svg v-if="videoStatus[index]" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <polygon points="5 3 19 12 5 21" fill="white"/>
                        </svg>
                        <svg v-else width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <rect x="6" y="4" width="4" height="16" fill="white"/>
                          <rect x="14" y="4" width="4" height="16" fill="white"/>
                        </svg>
                      </button>
                      <button class="video-btn fullscreen-btn" @click.stop="toggleFullscreen(index, $event)" title="全屏">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M8 3H5a2 2 0 0 0-2 2v3M21 8V5a2 2 0 0 0-2-2h-3M3 16v3a2 2 0 0 0 2 2h3M16 21h3a2 2 0 0 0 2-2v-3" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
                
                <!-- 音频预览 -->
                <div v-else-if="file.type.startsWith('audio/')" class="file-preview-audio music-track-layout" :class="{ 'playing': audioPlaying[index] }" :data-filename="file.name" :data-index="index">
                  <div class="music-play-button" @click.stop="toggleAudioPlay(index, $event)" :class="{ 'playing': audioPlaying[index] }">
                    <div class="play-button-inner">
                      <svg v-if="!audioPlaying[index]" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <polygon points="5 3 19 12 5 21" fill="white"/>
                      </svg>
                      <svg v-else width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="6" y="4" width="4" height="16" fill="white"/>
                        <rect x="14" y="4" width="4" height="16" fill="white"/>
                      </svg>
                    </div>
                  </div>
                  
                  <div class="music-track-info">
                    <div class="music-track-title">{{ file.name.split('.')[0] }}</div>
                    <div class="music-track-artist">{{ file.name.includes(' - ') ? file.name.split(' - ')[0] : 'Unknown Artist' }}</div>
                  </div>
                  
                  <div class="music-track-type">
                    {{ file.type.split('/')[1].toUpperCase() }}
                  </div>
                  
                  <div class="music-track-waveform">
                    <div class="waveform-display" 
                        :id="`waveform-${index}`"
                        :style="{ '--progress': `${audioProgress[index] || 0}%` }"
                        @click="seekAudio($event, index)"></div>
                  </div>
                  
                  <div class="music-track-time">
                    {{ file.audioDuration || '00:00' }}
                  </div>
                  
                  <div class="music-track-controls">
                    <button class="music-control-btn volume-btn" @click.stop="toggleAudioMute(index, $event)" title="静音">
                      <svg v-if="audioMuted[index]" width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M11 5L6 9H2v6h4l5 4V5z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="white"/>
                        <path d="M23 9l-6 6M17 9l6 6" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                      <svg v-else width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M11 5L6 9H2v6h4l5 4V5z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="white"/>
                        <path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                    
                    <button class="music-control-btn menu-btn" @click.stop="showAudioMenu(index, $event)" title="更多选项">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="12" cy="5" r="2" fill="white"/>
                        <circle cx="12" cy="12" r="2" fill="white"/>
                        <circle cx="12" cy="19" r="2" fill="white"/>
                      </svg>
                    </button>
                  </div>
                  
                  <audio :id="`audio-${index}`" :src="file.url" preload="metadata" @timeupdate="updateAudioTime(index, $event)" :muted="audioMuted[index]"></audio>
                </div>
                
                <!-- 文档预览 -->
                <div v-else class="file-preview-document" :data-filename="file.name">
                  <div class="document-icon" :class="getDocumentClass(file.name)">
                    {{ getDocumentIcon(file.name) }}
                  </div>
                  <div class="document-name">{{ file.name }}</div>
                  <!-- 文件类型标签 -->
                  <div class="document-type-badge">{{ getFileExtension(file.name) }}</div>
                </div>
              </div>
              
              <!-- 删除按钮 -->
              <button class="remove-file-btn" @click="removeFile(index)" title="移除文件">×</button>
            </div>
          </div>
        </div>

        <div class="upload-dropzone" 
          @click="triggerFileUpload" 
          @dragover="dragOverUploadZone"
          @dragleave="dragLeaveUploadZone"
          @drop="onFileDrop"
        >
          <div class="upload-icon">+</div>
          <p class="upload-text">在此处浏览或拖放您的文件</p>
          <p class="upload-subtext">支持多个文件同时上传，单个文件最大1000MB</p>
          <input 
            type="file" 
            ref="fileInput" 
            class="hidden-file-input"
            @change="handleFileSelect"
            multiple
            :accept="fileTypeAccept"
          >
        </div>
      </div>
    </div>

    <!-- 钱包选择区域 -->
    <div v-if="activeUploadMethod === 'wallet'" class="wallet-section">
      <h3>从已有作品中选择</h3>
      <p>查看您之前已创建的作品</p>
      <!-- 钱包内容占位 -->
      <div class="wallet-placeholder">
        <p>暂无已创建作品</p>
      </div>
    </div>

    <!-- 资产描述 -->
    <div class="form-group description-group">
      <label for="assetDescription">
        描述资产
        <p class="description-help">您可以包含历史记录、使用指南或其他有用的详细信息等信息。</p>
      </label>
      <textarea 
        id="assetDescription" 
        v-model="assetDescription" 
        placeholder="添加描述"
        class="textarea-field"
        rows="4"
      ></textarea>
    </div>

    <!-- 底部导航按钮 -->
    <div class="navigation-buttons">
      <button class="back-btn" @click="$emit('navigate-back')">
        <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="arrow" class="arrow-icon arrow-back">
          <path d="M17.7,11.2C17.7,11.2,17.7,11.2,17.7,11.2l-5-5c-0.4-0.4-1-0.4-1.4,0c-0.4,0.4-0.4,1,0,1.4l3.3,3.3H7c-0.6,0-1,0.4-1,1
            s0.4,1,1,1h7.6l-3.3,3.3c-0.4,0.4-0.4,1,0,1.4c0.4,0.4,1,0.4,1.4,0c0,0,0,0,0,0l5-5C18.1,12.3,18.1,11.6,17.7,11.2z"></path>
        </svg>
      </button>
      
      <!-- Uiverse animated button for next -->
      <button class="uiverse" @click="goNext" :disabled="!assetName || uploadedFiles.length === 0">
        <div class="wrapper">
          <span>
            <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" id="arrow" class="arrow-icon">
              <path d="M17.7,11.2C17.7,11.2,17.7,11.2,17.7,11.2l-5-5c-0.4-0.4-1-0.4-1.4,0c-0.4,0.4-0.4,1,0,1.4l3.3,3.3H7c-0.6,0-1,0.4-1,1
                s0.4,1,1,1h7.6l-3.3,3.3c-0.4,0.4-0.4,1,0,1.4c0.4,0.4,1,0.4,1.4,0c0,0,0,0,0,0l5-5C18.1,12.3,18.1,11.6,17.7,11.2z"></path>
            </svg>
          </span>
          
          <!-- Animated circles -->
          <div class="circle circle-1" style="animation: circle-1 7s linear infinite;"></div>
          <div class="circle circle-2" style="animation: circle-2 7s linear infinite;"></div>
          <div class="circle circle-3" style="animation: circle-3 7s linear infinite;"></div>
          <div class="circle circle-4" style="animation: circle-4 7s linear infinite;"></div>
          <div class="circle circle-5" style="animation: circle-5 7s linear infinite;"></div>
          <div class="circle circle-6" style="animation: circle-6 7s linear infinite;"></div>
          <div class="circle circle-7" style="animation: circle-7 7s linear infinite;"></div>
          <div class="circle circle-8" style="animation: circle-8 7s linear infinite;"></div>
          <div class="circle circle-9" style="animation: circle-9 7s linear infinite;"></div>
          <div class="circle circle-10" style="animation: circle-10 7s linear infinite;"></div>
          <div class="circle circle-11" style="animation: circle-11 7s linear infinite;"></div>
          <div class="circle circle-12" style="animation: circle-12 7s linear infinite;"></div>
        </div>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import NavigationButtons from '../../common/NavigationButtons.vue';

const emit = defineEmits(['navigate-back', 'navigate-next', 'show-unavailable']);

// 资产基本信息
const assetName = ref('');
const assetDescription = ref('');

// 上传方式
const activeUploadMethod = ref('file');

// 资产类型选择
const selectedAssetType = ref('');
const uploadedFiles = ref<any[]>([]);

// 资产类型定义
const assetTypes = [
  {
    id: 'video',
    name: '视频类',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60" width="40" height="40"><path fill="#ffffff" d="M52 7H8c-1.1 0-2 .9-2 2v28h48V9c0-1.1-.9-2-2-2zM36.45 23.89l-12 6c-.14.07-.3.11-.45.11a.999.999 0 0 1-1-1V17c0-.35.18-.67.47-.85.3-.18.67-.2.98-.04l12 6c.34.16.55.51.55.89s-.21.73-.55.89zM54 39v4c0 1.1-.9 2-2 2H37v6h3c.55 0 1 .45 1 1s-.45 1-1 1H20c-.55 0-1-.45-1-1s.45-1 1-1h3v-6H8c-1.1 0-2-.9-2-2v-4h48z"></path></svg>',
    accept: '.mp4,.webm,.mov'
  },
  {
    id: 'image',
    name: '图片类',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 60 60" viewBox="0 0 60 60" id="picture" width="40" height="40"><path fill="#ffffff" d="M8.0050049,38.2349854V14.8150024c0-1.2700195,0.8900146-2.3500366,2.0899658-2.6199951V10.164978c-2.2999878,0.289978-4.0899658,2.2600098-4.0899658,4.6500244v27.3200073c0,2.5799561,2.0999756,4.6799927,4.6799927,4.6799927h11.8499756v3.7299805h-2.6699829c-0.5599976,0-1,0.4500122-1,1c0,0.5599976,0.4400024,1,1,1h16.5900269c0.0100098,0,0.0100098,0,0.0100098,0h3.6699829c0.5499878,0,1-0.4400024,1-1c0-0.5499878-0.4500122-1-1-1h-2.6799927v-3.7299805h11.8599854c2.25,0,4.1400146-1.6100464,4.5800171-3.7399902c0.0700073-0.3099976,0.0999756-0.6300049,0.0999756-0.960022V14.8150024c0-2.3699951-1.789978-4.3400269-4.0899658-4.6400146v2.0299683c1.1999512,0.2800293,2.0899658,1.3500366,2.0899658,2.6100464v23.4199829H8.0050049z M26.9949951,43.2349854c-0.1900024,0.1900024-0.4400024,0.289978-0.710022,0.289978c-0.2599487,0-0.5199585-0.0999756-0.6999512-0.289978c-0.1900024-0.1900024-0.3000488-0.4400024-0.3000488-0.710022c0-0.2599487,0.1100464-0.5199585,0.3000488-0.7099609c0.3699951-0.3699951,1.039978-0.3699951,1.4099731,0c0.1900024,0.1900024,0.289978,0.4500122,0.289978,0.7099609C27.2849731,42.7849731,27.1849976,43.0449829,26.9949951,43.2349854z M30.7050171,43.2349854c-0.1900024,0.1900024-0.4400024,0.289978-0.710022,0.289978c-0.2600098,0-0.5200195-0.0999756-0.710022-0.289978c-0.1799927-0.1900024-0.289978-0.4400024-0.289978-0.710022c0-0.2599487,0.1099854-0.5199585,0.289978-0.7099609c0.3800049-0.3699951,1.0500488-0.3699951,1.4200439,0.0100098c0.1799927,0.1799927,0.289978,0.4400024,0.289978,0.6999512C30.9949951,42.7949829,30.8850098,43.0449829,30.7050171,43.2349854z M34.414978,43.2349854c-0.1900024,0.1900024-0.4499512,0.289978-0.7099609,0.289978c-0.2700195,0-0.5200195-0.0999756-0.710022-0.289978c-0.1799927-0.1900024-0.289978-0.4400024-0.289978-0.710022c0-0.2599487,0.1099854-0.5199585,0.289978-0.6999512c0.3699951-0.3800049,1.039978-0.3800049,1.4199829-0.0100098c0.1799927,0.1900024,0.2900391,0.4500122,0.2900391,0.7099609C34.7050171,42.7949829,34.5949707,43.0449829,34.414978,43.2349854z"></path><path fill="#ffffff" d="M12.0949707,8.4549561v25.222229l9.5981445-16.9112549c0.1894531-0.3330078,0.5527954-0.5292969,0.9345703-0.5043945c0.3828125,0.0249023,0.7167969,0.2661133,0.8613281,0.6210938l5.000061,12.2808838l7.9412842-12.0186768c0.1895142-0.2871094,0.5127563-0.4702148,0.8575439-0.4482422c0.343689,0.0078125,0.6591187,0.1918945,0.8358765,0.487793l9.78125,16.4194946V8.4549561c0-0.5499878-0.4400024-1-1-1H13.0949707C12.5349731,7.4549561,12.0949707,7.9049683,12.0949707,8.4549561z M34.3660278,16.079895c0.390564,0.390625,0.390564,1.0234375,0,1.4140625c-0.390625,0.390625-1.0235596,0.390625-1.4141235,0c-0.3730469-0.3730469-1.0244141-0.3725586-1.3955078-0.0004883c-0.1875,0.1879883-0.4423828,0.293457-0.7080078,0.293457s-0.5195313-0.1054688-0.7070313-0.2929688c-0.3720703-0.3725586-1.0234985-0.3745117-1.3974609,0c-0.390625,0.390625-1.0234375,0.390625-1.4141235,0c-0.390564-0.390625-0.390564-1.0234375,0-1.4140625c0.9169922-0.9180298,2.406311-1.1185913,3.5186157-0.5259399C31.9577637,14.9621582,33.4489746,15.1629028,34.3660278,16.079895z M22.65802,12.8900146c0.9501953-0.9492188,2.3866577-1.1260376,3.5174561-0.5235596c1.1298828-0.6009521,2.5684204-0.425293,3.5176392,0.5235596c0.390686,0.390564,0.390686,1.0238647,0,1.4144897c-0.1953125,0.1952515-0.4511108,0.2929688-0.7070313,0.2929688s-0.5117188-0.0977173-0.7069702-0.2924805c-0.3848267-0.3848267-1.0118408-0.3848267-1.3965454,0c-0.390564,0.3897095-1.0234985,0.3897095-1.4140625,0c-0.3847046-0.3848267-1.0117188-0.3848267-1.3964844,0c-0.390625,0.3897095-1.0234375,0.3900757-1.4140015-0.0004883C22.2672729,13.9138794,22.2672729,13.2805786,22.65802,12.8900146z"></path><path fill="#ffffff" d="M29.402771,31.4075928l1.5198364,3.7327881c0.0072632,0.0178833,0.0041504,0.036499,0.010498,0.0545654h15.5913086L37.220459,19.5764771L29.402771,31.4075928z"></path><polygon fill="#ffffff" points="13.534 35.195 28.786 35.195 22.415 19.547"></polygon></svg>',
    accept: '.jpg,.jpeg,.png,.gif,.svg,.webp'
  },
  {
    id: 'audio',
    name: '音频类',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 110 110" id="voice-recording" width="40" height="40"><path fill="#ffffff" d="M48.85,66.84H54V61.19H52.21A14.26,14.26,0,0,1,38,47V35.66a1,1,0,0,1,2,0v2.67H44V31a7.85,7.85,0,0,1,7.83-7.83h6.26A7.85,7.85,0,0,1,66,31v7.37H70V35.66a1,1,0,0,1,2,0V47A14.26,14.26,0,0,1,57.79,61.19H56v5.65h5.15a.88.88,0,0,1,.33.07H93.86V16.54H16.14V66.91H48.52A.88.88,0,0,1,48.85,66.84ZM82.94,30.31a1,1,0,0,1,2,0V51.73a1,1,0,0,1-2,0ZM77.27,35.8a1,1,0,0,1,2,0V46.24a1,1,0,0,1-2,0ZM27.07,51.73a1,1,0,0,1-2,0V30.31a1,1,0,1,1,2,0Zm5.67-5.49a1,1,0,0,1-2,0V35.8a1,1,0,0,1,2,0ZM57,75.93a2,2,0,1,1-2-2A2,2,0,0,1,57,75.93ZM65,85V95.66H45V85ZM44,97.67H70a4.92,4.92,0,0,1,3.5,1.46,5,5,0,0,1,1.34,2.5H35.18a5,5,0,0,1,4.84-4h4ZM15.27,83H44L44,83H66l.08,0H94.73A7.28,7.28,0,0,0,102,75.76V15.82a7.44,7.44,0,0,0-7.43-7.44H15.27A7.27,7.27,0,0,0,8,15.64V75.76A7.28,7.28,0,0,0,15.27,83ZM55,79.93a4,4,0,1,1,4-4A4,4,0,0,1,55,79.93ZM14.14,15.54a1,1,0,0,1,1-1H94.86a1,1,0,0,1,1,1V67.91a1,1,0,0,1-1,1H15.14a1,1,0,0,1-1-1ZM44,40.33v7.38a7.84,7.84,0,0,0,7.83,7.82h6.26A7.84,7.84,0,0,0,66,47.71V40.33H70V47A12.25,12.25,0,0,1,57.79,59.19H52.21A12.25,12.25,0,0,1,40,47V40.33Zm7.74,4.82a1,1,0,0,0-1-1H46V40.33h4.74a1,1,0,0,0,0-2H46V34.52h4.74a1,1,0,0,0,0-2H46V31a5.84,5.84,0,0,1,5.83-5.83h6.26A5.84,5.84,0,0,1,64,31v1.56H59.22a1,1,0,0,0,0,2H64v3.81H59.22a1,1,0,0,0,0,2H64v3.82H59.22a1,1,0,0,0,0,2H64v1.56a5.83,5.83,0,0,1-5.83,5.82H51.87A5.83,5.83,0,0,1,46,47.71V46.15h4.74A1,1,0,0,0,51.78,45.15Z"></path></svg>',
    accept: '.wav,.mp3,.flac,.aac,.ogg,.m4a,.opus'
  },
  {
    id: 'text',
    name: '文字类',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 66 66" id="pc-folder" width="40" height="40"><path fill="#ffffff" d="M1.93,48.59V52a3.17,3.17,0,0,0,3.16,3.16H60.91A3.17,3.17,0,0,0,64.07,52v-3.4Z"></path><polygon fill="#ffffff" points="23.93 57.15 21.78 61.99 44.22 61.99 42.08 57.15 23.93 57.15"></polygon><path fill="#ffffff" d="M47 63H19a1 1 0 1 0 0 2H47a1 1 0 0 0 0-2zM21.92 12.41H52.25V9a2.14 2.14 0 0 0-2.13-2.14H30.44a4.14 4.14 0 0 1-3.26-1.58l-2.73-3.5A2.14 2.14 0 0 0 22.76 1H15.17A2.13 2.13 0 0 0 13 3.13V27.87l5-12.83A4.12 4.12 0 0 1 21.92 12.41z"></path><path fill="#ffffff" d="M15.18,35.89H49.65a2.14,2.14,0,0,0,2-1.35l6.74-17.21a2.14,2.14,0,0,0-.22-2,2.11,2.11,0,0,0-1.76-.93H21.92a2.11,2.11,0,0,0-2,1.36L13.19,33a2.13,2.13,0,0,0,2,2.91Z"></path><path fill="#ffffff" d="M60.91,9.56H54.26v2.85H56.4a4.13,4.13,0,0,1,3.85,5.65L53.5,35.27a4.11,4.11,0,0,1-3.85,2.63H15.18a4.15,4.15,0,0,1-.79-.08l-.08,0a4.29,4.29,0,0,1-.72-.22l-.06,0a4.12,4.12,0,0,1-1.26-.85l0-.05a3.67,3.67,0,0,1-.47-.56,3.53,3.53,0,0,1-.36-.66l-.06-.12a4.11,4.11,0,0,1-.21-.68s0-.08,0-.13a4,4,0,0,1-.07-.69V9.56H5.09a3.16,3.16,0,0,0-3.16,3.16V46.58H64.07V12.72A3.16,3.16,0,0,0,60.91,9.56Z"></path></svg>',
    accept: '.txt,.pdf,.doc,.docx'
  }
];

// 计算属性：获取当前资产类型的名称
const getAssetTypeName = computed(() => {
  const type = assetTypes.find(t => t.id === selectedAssetType.value);
  return type ? type.name.replace('类', '') : '';
});

// 计算属性：获取当前资产类型支持的文件类型
const getSupportedFileTypes = computed(() => {
  const type = assetTypes.find(t => t.id === selectedAssetType.value);
  if (!type) return '';
  
  const typeMap: Record<string, string> = {
    'video': 'MP4、WEBM、MOV',
    'image': 'JPG、PNG、GIF、SVG、WEBP',
    'audio': 'WAV、MP3、FLAC、AAC、OGG、M4A、OPUS',
    'text': 'TXT、PDF、DOC、DOCX'
  };
  
  return typeMap[type.id] || '';
});

// 计算属性：文件上传接受的类型
const fileTypeAccept = computed(() => {
  const type = assetTypes.find(t => t.id === selectedAssetType.value);
  return type ? type.accept : '';
});

// 选择资产类型
const selectAssetType = (type: string) => {
  selectedAssetType.value = type;
  if (uploadedFiles.value.length > 0) {
    // 如果切换了资产类型，清空已上传的文件
    uploadedFiles.value = [];
  }
};

// 触发文件选择
const fileInput = ref<HTMLInputElement | null>(null);
const triggerFileUpload = () => {
  if (fileInput.value) {
    fileInput.value.click();
  }
};

// 处理文件选择
const handleFileSelect = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files.length > 0) {
    const files = Array.from(input.files);
    
    // 检查文件类型是否匹配当前选择的资产类型
    const validFiles = files.filter(file => {
      const fileType = file.type.split('/')[0];
      if (selectedAssetType.value === 'video' && fileType === 'video') return true;
      if (selectedAssetType.value === 'image' && fileType === 'image') return true;
      if (selectedAssetType.value === 'audio' && fileType === 'audio') return true;
      if (selectedAssetType.value === 'text' && 
         (fileType === 'text' || file.name.endsWith('.pdf') || 
          file.name.endsWith('.doc') || file.name.endsWith('.docx'))) return true;
      return false;
    });
    
    if (validFiles.length !== files.length) {
      // 提示用户文件类型不匹配
      emit('show-unavailable', '文件类型不匹配当前选择的资产类型');
      return;
    }
    
    // 添加文件到上传列表
    for (const file of validFiles) {
      const url = URL.createObjectURL(file);
      const fileObj = {
        name: file.name,
        type: file.type,
        size: file.size,
        file,
        url,
        audioDuration: null as string | null,
        dimensions: null as string | null
      };
      
      uploadedFiles.value.push(fileObj);
      
      // 如果是音频文件，获取时长并创建波形图
      if (file.type.startsWith('audio/')) {
        const currentIndex = uploadedFiles.value.length - 1;
        
        getAudioDuration(url).then(duration => {
          const index = uploadedFiles.value.findIndex(f => f.url === url);
          if (index !== -1) {
            uploadedFiles.value[index].audioDuration = formatDuration(duration);
          }
        }).catch(err => {
          console.error('获取音频时长失败:', err);
        });
        
        // 延迟300ms确保DOM已经渲染，然后创建波形图
        setTimeout(() => {
          console.log(`延迟后创建波形图 index=${currentIndex}`);
          createWaveformEffect(currentIndex);
        }, 300);
      }
      
      // 如果是图片文件，获取尺寸信息
      if (file.type.startsWith('image/')) {
        const currentIndex = uploadedFiles.value.length - 1;
        const img = new Image();
        img.src = url;
        
        img.onload = () => {
          const index = uploadedFiles.value.findIndex(f => f.url === url);
          if (index !== -1) {
            // 保存图片尺寸
            uploadedFiles.value[index].dimensions = `${img.naturalWidth} × ${img.naturalHeight}`;
            
            // 延迟一下确保DOM更新
            setTimeout(() => {
              // 更新图片容器的data-dimensions属性
              const imgContainer = document.querySelector(`.uploaded-file-item:nth-child(${index + 1}) .file-preview-container`);
              if (imgContainer) {
                imgContainer.setAttribute('data-dimensions', uploadedFiles.value[index].dimensions as string);
              }
            }, 100);
          }
        };
      }
    }
    
    // 重置input以允许再次选择相同文件
    input.value = '';
  }
};

// 获取音频时长
const getAudioDuration = (url: string): Promise<number> => {
  return new Promise((resolve, reject) => {
    const audio = new Audio();
    audio.src = url;
    
    audio.addEventListener('loadedmetadata', () => {
      resolve(audio.duration);
    });
    
    audio.addEventListener('error', (err) => {
      reject(err);
    });
  });
};

// 格式化时长
const formatDuration = (seconds: number): string => {
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.floor(seconds % 60);
  
  const formattedMinutes = String(minutes).padStart(2, '0');
  const formattedSeconds = String(remainingSeconds).padStart(2, '0');
  
  return `${formattedMinutes}:${formattedSeconds}`;
};

// 拖拽排序相关变量和函数
let draggedItem = -1;

const dragStart = (index: number, event: DragEvent) => {
  draggedItem = index;
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/plain', index.toString());
  }
};

const dragEnter = (event: DragEvent) => {
  if (event.currentTarget) {
    (event.currentTarget as HTMLElement).classList.add('drag-over');
  }
};

const dragLeave = (event: DragEvent) => {
  if (event.currentTarget) {
    (event.currentTarget as HTMLElement).classList.remove('drag-over');
  }
};

const drop = (index: number, event: DragEvent) => {
  if (event.currentTarget) {
    (event.currentTarget as HTMLElement).classList.remove('drag-over');
  }
  
  if (draggedItem !== -1 && draggedItem !== index) {
    // 获取要移动的文件
    const itemToMove = uploadedFiles.value[draggedItem];
    // 移除原位置的文件
    uploadedFiles.value.splice(draggedItem, 1);
    // 插入到新位置
    uploadedFiles.value.splice(index, 0, itemToMove);
    // 重置拖拽项
    draggedItem = -1;
  }
};

// 删除文件
const removeFile = (index: number) => {
  // 释放对象URL
  if (uploadedFiles.value[index].url) {
    URL.revokeObjectURL(uploadedFiles.value[index].url);
  }
  uploadedFiles.value.splice(index, 1);
};

// 下一步
const goNext = () => {
  if (assetName.value && uploadedFiles.value.length > 0) {
    const assetData = {
      name: assetName.value,
      description: assetDescription.value,
      type: selectedAssetType.value,
      files: uploadedFiles.value,
      coverImage: coverImage.value
    };
    emit('navigate-next', assetData);
  }
};

// 视频播放状态跟踪
const videoStatus = ref<{[key: number]: boolean}>({});
const videoMuted = ref<{[key: number]: boolean}>({});
const videoProgress = ref<{[key: number]: number}>({});

// 视频加载状态
const videoLoading = ref<{[key: number]: boolean}>({});

// 视频控制 - 切换播放/暂停
const toggleVideoPlay = (index: number, event: Event) => {
  event.stopPropagation();
  const videoElement = document.querySelector(`#video-${index}`) as HTMLVideoElement;
  const videoContainer = videoElement?.closest('.file-preview-video') as HTMLElement;
  
  if (videoElement && videoContainer) {
    const wasPaused = videoElement.paused;
    
    if (wasPaused) {
      videoElement.play();
      videoStatus.value[index] = false; // 不是暂停状态
      
      // 添加播放动画
      const animation = document.createElement('div');
      animation.className = 'video-play-animation';
      animation.innerHTML = `
        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <polygon points="5 3 19 12 5 21" fill="white"/>
        </svg>
      `;
      videoContainer.appendChild(animation);
      
      // 动画结束后移除元素
      setTimeout(() => {
        if (animation && animation.parentNode) {
          animation.parentNode.removeChild(animation);
        }
      }, 800);
    } else {
      videoElement.pause();
      videoStatus.value[index] = true; // 是暂停状态
      
      // 添加暂停动画
      const animation = document.createElement('div');
      animation.className = 'video-play-animation';
      animation.innerHTML = `
        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <rect x="6" y="4" width="4" height="16" fill="white"/>
          <rect x="14" y="4" width="4" height="16" fill="white"/>
        </svg>
      `;
      videoContainer.appendChild(animation);
      
      // 动画结束后移除元素
      setTimeout(() => {
        if (animation && animation.parentNode) {
          animation.parentNode.removeChild(animation);
        }
      }, 800);
    }
  }
};

// 切换静音
const toggleMute = (index: number, event: Event) => {
  event.stopPropagation();
  const videoElement = document.querySelector(`#video-${index}`) as HTMLVideoElement;
  if (videoElement) {
    videoElement.muted = !videoElement.muted;
    videoMuted.value[index] = videoElement.muted;
  }
};

// 切换全屏
const toggleFullscreen = (index: number, event: Event) => {
  event.stopPropagation();
  const videoContainer = document.querySelector(`.uploaded-file-item:nth-child(${index + 1}) .file-preview-video`) as HTMLElement;
  const videoElement = document.querySelector(`#video-${index}`) as HTMLVideoElement;
  
  if (!videoContainer || !videoElement) return;
  
  if (document.fullscreenElement) {
    document.exitFullscreen();
  } else {
    // 使用整个视频容器而不仅仅是视频元素进入全屏
    // 这样可以在全屏时也显示控制条
    videoContainer.requestFullscreen().catch(err => {
      console.error('全屏请求被拒绝', err);
      // 如果容器全屏失败，尝试视频元素
      videoElement.requestFullscreen();
    });
  }
};

// 初始化视频状态
const initializeVideo = (index: number, event: Event) => {
  const video = event.target as HTMLVideoElement;
  videoStatus.value[index] = video.paused;
  videoMuted.value[index] = video.muted;
  videoProgress.value[index] = 0;
  videoLoading.value[index] = false; // 视频已加载完成
  
  // 设置视频加载完成后自动播放
  if (video.readyState >= 2) { // HAVE_CURRENT_DATA or higher
    video.play().catch(() => {
      // 自动播放可能被浏览器阻止
      videoStatus.value[index] = true;
    });
  }
  
  // 添加视频进度更新
  video.addEventListener('timeupdate', () => {
    if (video.duration > 0) {
      videoProgress.value[index] = (video.currentTime / video.duration) * 100;
    }
  });
};

// 处理视频加载开始
const handleVideoLoadStart = (index: number) => {
  videoLoading.value[index] = true;
};

// 处理视频加载错误
const handleVideoError = (index: number, event: Event) => {
  console.error(`Video loading error for index ${index}:`, event);
  videoStatus.value[index] = true; // 显示播放按钮
  
  // 显示错误提示
  const videoElement = event.target as HTMLVideoElement;
  if (videoElement) {
    videoElement.style.display = 'none';
    // 可以在这里添加错误提示的UI显示
  }
};

// 拖拽相关
const dragOverUploadZone = (event: DragEvent) => {
  event.preventDefault();
  const dropzone = event.currentTarget as HTMLElement;
  dropzone.classList.add('drag-over');
};

const dragLeaveUploadZone = (event: DragEvent) => {
  event.preventDefault();
  const dropzone = event.currentTarget as HTMLElement;
  dropzone.classList.remove('drag-over');
};

// 文件拖拽处理
const onFileDrop = (event: DragEvent) => {
  event.preventDefault();
  const dropzone = event.currentTarget as HTMLElement;
  dropzone.classList.remove('drag-over');
  
  if (event.dataTransfer?.files && event.dataTransfer.files.length > 0) {
    // 模拟文件选择
    const dT = new DataTransfer();
    for (let i = 0; i < event.dataTransfer.files.length; i++) {
      dT.items.add(event.dataTransfer.files[i]);
    }
    
    if (fileInput.value) {
      fileInput.value.files = dT.files;
      const changeEvent = new Event('change', { bubbles: true });
      fileInput.value.dispatchEvent(changeEvent);
    }
  }
};

// 视频进度条点击事件
const seekVideo = (event: MouseEvent, index: number) => {
  const progressBar = event.currentTarget as HTMLElement;
  if (!progressBar) return;
  
  const videoElement = document.querySelector(`#video-${index}`) as HTMLVideoElement;
  if (videoElement) {
    const rect = progressBar.getBoundingClientRect();
    const clickX = event.clientX - rect.left;
    const percentage = clickX / rect.width;
    const seekTime = percentage * videoElement.duration;
    videoElement.currentTime = seekTime;
    videoProgress.value[index] = percentage * 100;
  }
};

// 音频播放状态跟踪
const audioPlaying = ref<{[key: number]: boolean}>({});
const audioElements = ref<{[key: number]: HTMLAudioElement | null}>({});

// 切换音频播放/暂停
const toggleAudioPlay = (index: number, event: Event) => {
  event.stopPropagation();
  
  // 停止所有其他音频播放
  Object.keys(audioPlaying.value).forEach(key => {
    const audioIndex = parseInt(key);
    if (audioIndex !== index && audioPlaying.value[audioIndex]) {
      const audio = document.getElementById(`audio-${audioIndex}`) as HTMLAudioElement;
      if (audio) {
        audio.pause();
        audioPlaying.value[audioIndex] = false;
      }
    }
  });
  
  // 播放/暂停当前音频
  const audio = document.getElementById(`audio-${index}`) as HTMLAudioElement;
  if (audio) {
    if (audio.paused) {
      audio.play().then(() => {
        audioPlaying.value[index] = true;
        // 确保波形图已创建
        createWaveformEffect(index);
      }).catch(error => {
        console.error('音频播放失败:', error);
      });
    } else {
      audio.pause();
      audioPlaying.value[index] = false;
    }
  }
};

// 音频静音状态跟踪
const audioMuted = ref<{[key: number]: boolean}>({});

// 切换音频静音
const toggleAudioMute = (index: number, event: Event) => {
  event.stopPropagation();
  const audioElement = document.getElementById(`audio-${index}`) as HTMLAudioElement;
  if (audioElement) {
    audioElement.muted = !audioElement.muted;
    audioMuted.value[index] = audioElement.muted;
  }
};

// 音频进度条更新
const audioProgress = ref<{[key: number]: number}>({});

// 更新音频进度
const updateAudioTime = (index: number, event: Event) => {
  const audioElement = event.target as HTMLAudioElement;
  if (audioElement && audioElement.duration) {
    const progress = (audioElement.currentTime / audioElement.duration) * 100;
    audioProgress.value[index] = progress;
    
    // 更新CSS变量，用于进度显示
    const waveformDisplay = document.querySelector(`.uploaded-file-item:nth-child(${index + 1}) .waveform-display`);
    if (waveformDisplay) {
      (waveformDisplay as HTMLElement).style.setProperty('--progress', `${progress}%`);
    }
    
    // 如果波形图尚未创建，则创建
    if (waveformDisplay && !waveformDisplay.querySelector('.waveform-bar')) {
      createWaveformEffect(index);
    }
  }
};

// 创建波形图效果 - 确保无论播放状态如何都显示，并且为每个文件生成唯一的波形
const createWaveformEffect = (index: number) => {
  console.log(`创建波形图 index=${index}`);
  
  // 直接使用ID选择器找到对应的波形容器
  const waveformContainer = document.getElementById(`waveform-${index}`);
  
  if (!waveformContainer) {
    console.error(`找不到波形容器，index=${index}`);
    // 如果无法找到容器，延迟再试一次
    setTimeout(() => createWaveformEffect(index), 100);
    return;
  }
  
  // 如果已经有波形条，不重复创建
  if (waveformContainer.children.length > 0) {
    console.log(`波形图已存在，无需重复创建 index=${index}`);
    return;
  }
  
  console.log('找到波形容器，开始创建波形');
  
  // 清空现有内容
  waveformContainer.innerHTML = '';

  // 为容器设置内联样式确保其正确显示
  waveformContainer.style.display = 'flex';
  waveformContainer.style.width = '100%';
  waveformContainer.style.height = '100%';
  waveformContainer.style.alignItems = 'center';
  waveformContainer.style.gap = '0px';
  waveformContainer.style.backgroundColor = '#16161a';
  
  // 获取当前音频文件信息，用于生成唯一波形图
  const audioFile = uploadedFiles.value[index];
  const fileName = audioFile ? audioFile.name : `audio-${index}`;
  
  // 使用文件名和索引创建一个简单的随机数生成器
  const seedValue = fileName.split('').reduce((acc: number, char: string, i: number) => acc + char.charCodeAt(0) * (i + 1), 0) + index * 100;
  
  // 简单的伪随机数生成器函数
  const pseudoRandom = (min: number, max: number, seed: number) => {
    const a = 1664525;
    const c = 1013904223;
    const m = Math.pow(2, 32);
    let currentSeed = (a * (seed + index * 10000) + c) % m;
    // 返回一个0到1的随机数
    const random = currentSeed / m;
    // 映射到指定范围
    return min + random * (max - min);
  };
  
  // 生成波形模式 - 按文件特性分类
  let patternType = 0;
  if (fileName.toLowerCase().includes('vocal') || fileName.toLowerCase().includes('voice')) {
    patternType = 1; // 人声模式 - 中间高两端低
  } else if (fileName.toLowerCase().includes('beat') || fileName.toLowerCase().includes('drum')) {
    patternType = 2; // 鼓点模式 - 均匀分布的高低交替
  } else if (fileName.toLowerCase().includes('ambient') || fileName.toLowerCase().includes('pad')) {
    patternType = 3; // 环境音模式 - 平滑变化
  } else if (fileName.toLowerCase().includes('bass')) {
    patternType = 4; // 低音模式 - 低频主导
  } else {
    patternType = index % 5; // 随机一种模式
  }
  
  // 定义不同的波形模式生成函数
  const generatePatternHeight = (i: number, barCount: number, patternType: number, seed: number): number => {
    const position = i / barCount; // 0到1之间的位置
    let height = 0;
    
    switch(patternType) {
      case 0: // 默认模式 - 随机波形
        height = pseudoRandom(20, 80, seed + i * 10);
        break;
      case 1: // 人声模式 - 中间高两端低
        const centerDistance = Math.abs(position - 0.5) * 2; // 0到1，表示离中心的距离
        height = 70 - centerDistance * 50 + pseudoRandom(-15, 15, seed + i * 10);
        break;
      case 2: // 鼓点模式 - 高低交替
        height = i % 2 === 0 ? 
          pseudoRandom(60, 80, seed + i * 10) : 
          pseudoRandom(20, 40, seed + i * 10);
        break;
      case 3: // 环境音模式 - 平滑变化
        const step = i % (barCount / 4);
        const cycle = Math.sin((step / (barCount / 4)) * Math.PI * 2);
        height = 40 + cycle * 30 + pseudoRandom(-10, 10, seed + i * 10);
        break;
      case 4: // 低音模式 - 低频主导
        if (i % 8 === 0) {
          height = pseudoRandom(60, 80, seed + i * 10);
        } else {
          height = pseudoRandom(20, 40, seed + i * 10);
        }
        break;
      default:
        height = pseudoRandom(20, 80, seed + i * 10);
    }
    
    // 确保高度在允许范围内
    return Math.max(15, Math.min(85, height));
  };
  
  // 确定波形条数量 - 增加密度使其更真实
  const barCount = 120; 
  
  // 创建双波形容器 - 黄色上方，深色下方，分别向上/向下扩展
  const topWaveformContainer = document.createElement('div');
  topWaveformContainer.className = 'waveform-top-container';
  topWaveformContainer.style.cssText = `
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 50%;
    display: flex;
    align-items: flex-end;
    gap: 0px;
    transform: translateY(1px);
    z-index: 2;
  `;
  
  const bottomWaveformContainer = document.createElement('div');
  bottomWaveformContainer.className = 'waveform-bottom-container';
  bottomWaveformContainer.style.cssText = `
    position: absolute;
    left: 0;
    bottom: 0;
    width: 100%;
    height: 50%;
    display: flex;
    align-items: flex-start;
    gap: 0px;
    transform: translateY(-1px);
    z-index: 2;
  `;
  
  waveformContainer.appendChild(topWaveformContainer);
  waveformContainer.appendChild(bottomWaveformContainer);
  
  // 创建中心分隔线
  const centerLine = document.createElement('div');
  centerLine.className = 'waveform-center-line';
  centerLine.style.cssText = `
    position: absolute;
    left: 0;
    top: 50%;
    width: 100%;
    height: 1px;
    background-color: rgba(255, 255, 255, 0.05);
    z-index: 1;
  `;
  waveformContainer.appendChild(centerLine);
  
  // 生成波形条
  for (let i = 0; i < barCount; i++) {
    const height = generatePatternHeight(i, barCount, patternType, seedValue);
    
    // 创建上半部分的条
    const topBar = document.createElement('div');
    topBar.className = 'waveform-bar';
    
    // 创建下半部分的条
    const bottomBar = document.createElement('div');
    bottomBar.className = 'waveform-bar';
    
    // 设置样式
    const isYellow = i % 2 === 0;
    const barColor = isYellow ? 
      `rgba(254, 202, 37, ${pseudoRandom(0.7, 0.9, seedValue + i)})` : 
      `rgba(20, 20, 25, ${pseudoRandom(0.9, 1.0, seedValue + i)})`;
    
    const topHeight = height / 2;
    const bottomHeight = height / 2;
    
    topBar.style.cssText = `
      flex: 1;
      height: ${topHeight}%;
      min-width: 1px;
      max-width: 2px;
      background-color: ${barColor};
      display: block;
      transition: height 0.1s ease;
    `;
    
    bottomBar.style.cssText = `
      flex: 1;
      height: ${bottomHeight}%;
      min-width: 1px;
      max-width: 2px;
      background-color: ${barColor};
      display: block;
      transition: height 0.1s ease;
    `;
    
    topWaveformContainer.appendChild(topBar);
    bottomWaveformContainer.appendChild(bottomBar);
  }
  
  // 添加进度指示器
  const progressIndicator = document.createElement('div');
  progressIndicator.className = 'waveform-progress-indicator';
  progressIndicator.style.cssText = `
    position: absolute;
    top: 0;
    left: 0;
    width: var(--progress, 0%);
    height: 100%;
    background: linear-gradient(90deg, 
      rgba(254, 202, 37, 0.1) 0%, 
      rgba(254, 202, 37, 0.03) 100%);
    pointer-events: none;
    z-index: 1;
  `;
  waveformContainer.appendChild(progressIndicator);
  
  // 添加播放头指示器
  const playhead = document.createElement('div');
  playhead.className = 'waveform-playhead';
  playhead.style.cssText = `
    position: absolute;
    top: 0;
    left: var(--progress, 0%);
    width: 2px;
    height: 100%;
    background-color: rgba(254, 202, 37, 0.9);
    box-shadow: 0 0 4px rgba(254, 202, 37, 0.5);
    pointer-events: none;
    z-index: 3;
    transition: left 0.1s linear;
  `;
  waveformContainer.appendChild(playhead);
  
  // 设置初始进度为0
  waveformContainer.style.setProperty('--progress', '0%');
  
  console.log(`波形图创建完成 index=${index}, 条数=${barCount}, 模式=${patternType}`);
};

// 显示音频菜单
const showAudioMenu = (index: number, event: Event) => {
  event.stopPropagation();
  console.log('显示音频菜单:', index);
  // 这里可以实现菜单功能，例如弹出一个包含更多选项的下拉菜单
};

// 添加音频进度条点击事件，实现点击波形跳转到相应位置
const seekAudio = (event: MouseEvent, index: number) => {
  const waveform = event.currentTarget as HTMLElement;
  const audio = document.getElementById(`audio-${index}`) as HTMLAudioElement;
  
  if (!audio || !waveform) return;
  
  const rect = waveform.getBoundingClientRect();
  const clickX = event.clientX - rect.left;
  const percentage = clickX / rect.width;
  
  // 设置音频当前播放位置
  if (audio.duration) {
    audio.currentTime = percentage * audio.duration;
    audioProgress.value[index] = percentage * 100;
    waveform.style.setProperty('--progress', `${percentage * 100}%`);
  }
};

// 在组件加载后初始化所有已有的音频文件波形图
onMounted(() => {
  console.log('组件挂载完成，初始化所有音频波形图');
  setTimeout(() => {
    uploadedFiles.value.forEach((file, index) => {
      if (file.type.startsWith('audio/')) {
        createWaveformEffect(index);
      }
    });
  }, 500);
  
  // 为uiverse按钮添加动画效果
  const uiverseButton = document.querySelector('.asset-details-container .uiverse');
  const circles = document.querySelectorAll('.asset-details-container .uiverse .circle');

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

// 监听上传文件列表变化
watch(uploadedFiles, (newFiles) => {
  // 对每个音频文件尝试创建波形图
  console.log('文件列表变化，重新检查音频波形图');
  setTimeout(() => {
    newFiles.forEach((file, index) => {
      if (file.type.startsWith('audio/')) {
        createWaveformEffect(index);
      }
    });
  }, 300);
}, { deep: true });

// 格式化文件大小
const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 B';
  
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
  const i = Math.floor(Math.log(bytes) / Math.log(1024));
  
  return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`;
};

// 图片预览功能
const previewImageFullscreen = (url: string, name: string) => {
  // 创建遮罩层
  const overlay = document.createElement('div');
  overlay.style.cssText = `
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.9);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 9999;
  `;
  
  // 创建关闭按钮
  const closeBtn = document.createElement('button');
  closeBtn.textContent = '×';
  closeBtn.style.cssText = `
    position: absolute;
    top: 20px;
    right: 20px;
    background: none;
    border: none;
    color: white;
    font-size: 30px;
    cursor: pointer;
    z-index: 10000;
  `;
  
  // 创建文件名显示
  const fileName = document.createElement('div');
  fileName.textContent = name;
  fileName.style.cssText = `
    color: white;
    margin-bottom: 15px;
    font-size: 16px;
  `;
  
  // 创建图片容器
  const imgContainer = document.createElement('div');
  imgContainer.style.cssText = `
    max-width: 90%;
    max-height: 80%;
    display: flex;
    align-items: center;
    justify-content: center;
  `;
  
  // 创建图片元素
  const img = document.createElement('img');
  img.src = url;
  img.style.cssText = `
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
  `;
  
  // 添加到DOM
  imgContainer.appendChild(img);
  overlay.appendChild(closeBtn);
  overlay.appendChild(fileName);
  overlay.appendChild(imgContainer);
  document.body.appendChild(overlay);
  
  // 点击关闭按钮或背景关闭预览
  closeBtn.addEventListener('click', () => {
    document.body.removeChild(overlay);
  });
  
  overlay.addEventListener('click', (e) => {
    if (e.target === overlay) {
      document.body.removeChild(overlay);
    }
  });
};

// 获取文件扩展名
const getFileExtension = (filename: string): string => {
  return filename.split('.').pop()?.toUpperCase() || '';
};

// 获取文档图标字母
const getDocumentIcon = (filename: string): string => {
  const ext = getFileExtension(filename).toLowerCase();
  
  switch(ext) {
    case 'pdf': return 'P';
    case 'doc':
    case 'docx': return 'W';
    case 'txt': return 'T';
    default: return 'D';
  }
};

// 获取文档类型对应的CSS类
const getDocumentClass = (filename: string): string => {
  const ext = getFileExtension(filename).toLowerCase();
  
  switch(ext) {
    case 'pdf': return 'doc-pdf';
    case 'doc':
    case 'docx': return 'doc-word';
    case 'txt': return 'doc-text';
    default: return '';
  }
};

// 封面图片
const coverImage = ref<{ url: string; name: string; dimensions?: string } | null>(null);

// 触发封面图片上传
const coverInput = ref<HTMLInputElement | null>(null);
const triggerCoverUpload = () => {
  if (coverInput.value) {
    coverInput.value.click();
  }
};

// 处理封面图片选择
const handleCoverSelect = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files.length > 0) {
    const file = input.files[0];
    const url = URL.createObjectURL(file);
    
    coverImage.value = {
      url: url,
      name: file.name,
      dimensions: '加载中...'
    };
    
    // 获取图片尺寸
    const img = new Image();
    img.src = url;
    
    img.onload = () => {
      if (coverImage.value) {
        coverImage.value.dimensions = `${img.naturalWidth} × ${img.naturalHeight}`;
      }
    };
    
    input.value = '';
  }
};

// 移除封面图片
const removeCover = () => {
  coverImage.value = null;
};

// 拖拽封面图片
const dragOverCoverZone = (event: DragEvent) => {
  event.preventDefault();
  const dropzone = event.currentTarget as HTMLElement;
  dropzone.classList.add('drag-over');
};

const dragLeaveCoverZone = (event: DragEvent) => {
  event.preventDefault();
  const dropzone = event.currentTarget as HTMLElement;
  dropzone.classList.remove('drag-over');
};

// 封面图片拖拽处理
const onCoverDrop = (event: DragEvent) => {
  event.preventDefault();
  const dropzone = event.currentTarget as HTMLElement;
  dropzone.classList.remove('drag-over');
  
  if (event.dataTransfer?.files && event.dataTransfer.files.length > 0) {
    // 模拟文件选择
    const dT = new DataTransfer();
    for (let i = 0; i < event.dataTransfer.files.length; i++) {
      dT.items.add(event.dataTransfer.files[i]);
    }
    
    if (coverInput.value) {
      coverInput.value.files = dT.files;
      const changeEvent = new Event('change', { bubbles: true });
      coverInput.value.dispatchEvent(changeEvent);
    }
  }
};
</script>

<style scoped>
.asset-details-container {
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
  padding: 30px;
  color: #fff;
}

.page-title {
  font-size: 28px;
  text-align: center;
  margin-bottom: 30px;
  font-weight: normal;
}

.form-group {
  margin-bottom: 25px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 16px;
  color: rgba(255, 255, 255, 0.9);
}

.description-help {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
  margin-top: 4px;
}

.input-field, .textarea-field {
  width: 100%;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  padding: 12px 15px;
  color: white;
  font-size: 16px;
  transition: all 0.3s;
}

.input-field:focus, .textarea-field:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.4);
  background: rgba(255, 255, 255, 0.15);
}

.upload-tabs {
  display: flex;
  margin-bottom: 25px;
  background: transparent;
  border-radius: 8px;
  overflow: hidden;
}

.upload-tab {
  flex: 1;
  padding: 12px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  color: rgba(255, 255, 255, 0.7);
  border-bottom: 2px solid transparent;
  background: transparent;
}

.upload-tab.active {
  background: transparent;
  color: white;
  border-bottom: 2px solid rgba(255, 255, 255, 0.5);
}

.upload-tab:hover:not(.active) {
  background: transparent;
  transform: translateY(-2px);
}

.asset-type-section {
  margin-bottom: 25px;
}

.asset-type-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
  margin-bottom: 20px;
}

/* 基础资产类型卡片样式 */
.asset-type-card {
  background: transparent;
  border-radius: 10px;
  padding: 15px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  border: 1px solid transparent;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  aspect-ratio: 1/1;
  position: relative;
  overflow: hidden;
}

.asset-type-card:hover:not(.disabled) {
  background: transparent;
  transform: translateY(-3px);
  box-shadow: 0 0 15px rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
}

/* Glowing Effect 基础样式 - 移除背景色 */
.asset-type-card::before {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  background: transparent;
  z-index: -1;
  border-radius: 12px;
  transition: all 0.5s ease;
  opacity: 0;
  filter: blur(3px);
}

.asset-type-card::after {
  content: '';
  position: absolute;
  inset: 0;
  z-index: -2;
  background: transparent;
  border-radius: 10px;
  filter: blur(15px);
  opacity: 0;
  transition: all 0.5s ease;
}

.asset-type-card:hover::before {
  opacity: 1;
  animation: glowing-border 3s linear infinite;
}

.asset-type-card:hover::after {
  opacity: 0.4;
  animation: glowing-shadow 3s ease infinite;
}

/* 视频类发光效果 - 移除背景色 */
.asset-type-card[data-type="video"]::before {
  background: transparent;
  border: 1px solid rgba(121, 40, 202, 0.4);
}

.asset-type-card[data-type="video"]::after {
  background: transparent;
  box-shadow: 0 0 20px rgba(121, 40, 202, 0.4);
}

/* 图片类发光效果 - 移除背景色 */
.asset-type-card[data-type="image"]::before {
  background: transparent;
  border: 1px solid rgba(0, 112, 243, 0.4);
}

.asset-type-card[data-type="image"]::after {
  background: transparent;
  box-shadow: 0 0 20px rgba(0, 112, 243, 0.4);
}

/* 音频类发光效果 - 移除背景色 */
.asset-type-card[data-type="audio"]::before {
  background: transparent;
  border: 1px solid rgba(254, 202, 37, 0.4);
}

.asset-type-card[data-type="audio"]::after {
  background: transparent;
  box-shadow: 0 0 20px rgba(254, 202, 37, 0.4);
}

/* 文字类发光效果 - 移除背景色 */
.asset-type-card[data-type="text"]::before {
  background: transparent;
  border: 1px solid rgba(0, 183, 106, 0.4);
}

.asset-type-card[data-type="text"]::after {
  background: transparent;
  box-shadow: 0 0 20px rgba(0, 183, 106, 0.4);
}

/* 选中状态发光效果加强 - 确保使用透明背景 */
.asset-type-card.selected::before {
  opacity: 1;
  animation: none;
  border: 1px solid;
  background: transparent;
}

.asset-type-card.selected::after {
  opacity: 0.5;
  animation: none;
  background: transparent;
}

/* 增强发光动画效果 - 移除背景色渐变 */
@keyframes glowing-border {
  0%, 50%, 100% {
    opacity: 0.7;
  }
}

@keyframes glowing-shadow {
  0% {
    opacity: 0.2;
    filter: blur(15px);
  }
  50% {
    opacity: 0.5;
    filter: blur(20px);
  }
  100% {
    opacity: 0.2;
    filter: blur(15px);
  }
}

/* 图标颜色变化效果 */
.asset-type-card[data-type="video"] .asset-type-icon svg path {
  transition: all 0.3s ease;
}

.asset-type-card.selected[data-type="video"] .asset-type-icon svg path {
  fill: rgba(255, 0, 128, 0.9) !important;
}

.asset-type-card[data-type="image"] .asset-type-icon svg path {
  transition: all 0.3s ease;
}

.asset-type-card.selected[data-type="image"] .asset-type-icon svg path {
  fill: rgba(0, 112, 243, 0.9) !important;
}

.asset-type-card[data-type="audio"] .asset-type-icon svg path {
  transition: all 0.3s ease;
}

.asset-type-card.selected[data-type="audio"] .asset-type-icon svg path {
  fill: #FECA25 !important;
}

.asset-type-card[data-type="text"] .asset-type-icon svg path {
  transition: all 0.3s ease;
}

.asset-type-card.selected[data-type="text"] .asset-type-icon svg path {
  fill: rgba(0, 183, 106, 0.9) !important;
}

.asset-type-card.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.asset-type-card.disabled::before {
  display: none;
}

.asset-type-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  position: relative;
  z-index: 1;
}

.asset-type-icon {
  margin-bottom: 18px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
  transition: all 0.3s ease;
}

.asset-type-card.selected .asset-type-icon {
  transform: scale(1.1);
  filter: drop-shadow(0 3px 6px rgba(0, 0, 0, 0.2));
}

.asset-type-name {
  font-size: 15px;
  font-weight: 500;
  color: white;
  text-align: center;
  margin-top: 5px;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
}

.upload-area-container {
  margin-top: 20px;
}

.upload-header {
  margin-bottom: 15px;
}

.upload-header h3 {
  font-size: 18px;
  margin-bottom: 8px;
  color: white;
  font-weight: normal;
}

.file-types, .file-size {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 4px;
}

.upload-type-info {
  display: flex;
  align-items: center;
  background: rgba(255, 165, 0, 0.2);
  padding: 10px;
  border-radius: 6px;
  margin-top: 10px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
}

.info-icon {
  margin-right: 10px;
  font-size: 18px;
}

.uploaded-files-preview {
  margin-bottom: 30px;
  background: rgba(20, 20, 25, 0.4);
  border-radius: 12px;
  padding: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.uploaded-files-grid {
  display: grid;
  grid-template-columns: repeat(1, 1fr);
  gap: 10px;
  margin-bottom: 20px;
}

.uploaded-file-item {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s;
}

/* 音频文件的容器样式 */
.uploaded-file-item:has(.music-track-layout) {
  aspect-ratio: auto;
  background: transparent;
  box-shadow: none;
  height: auto;
  border: none;
}

/* 非音频文件的容器样式 */
.uploaded-file-item:not(:has(.music-track-layout)) {
  background: rgba(30, 30, 35, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.1);
  aspect-ratio: 16/10;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

.uploaded-file-item:not(:has(.music-track-layout)):hover {
  transform: translateY(-3px);
  border-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.4);
}

.file-preview-container {
  height: 100%;
  width: 100%;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #1a1a20;
}

.file-preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.file-preview-video {
  width: 100%;
  height: 100%;
  position: relative;
  overflow: hidden;
  border-radius: 4px;
  background: #000;
}

/* 播放/暂停动画效果 */
@keyframes playPauseAnimation {
  0% { opacity: 0; transform: scale(0.5); }
  50% { opacity: 1; transform: scale(1.2); }
  100% { opacity: 0; transform: scale(1.5); }
}

.video-play-animation {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 80px;
  height: 80px;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: playPauseAnimation 0.8s ease-out forwards;
  z-index: 20;
  pointer-events: none;
}

.file-preview-video:hover .video-controls {
  opacity: 1;
}

/* 文件名始终显示在顶部 */
.file-preview-video::before,
.file-preview-image::before,
.file-preview-audio::before,
.file-preview-document::before {
  content: attr(data-filename);
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  padding: 8px 10px;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0));
  color: rgba(255, 255, 255, 0.95);
  font-size: 13px;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  pointer-events: none;
  z-index: 9;
  backdrop-filter: blur(3px);
}

/* 确保删除所有冲突的CSS规则 */
.file-name {
  display: none;
}

/* 移除所有冲突的悬停规则 */
.file-preview-video:hover::after,
.file-preview-image:hover::after,
.file-preview-audio:hover::after,
.file-preview-document:hover::after {
  display: none;
}

/* 移除所有冲突的悬停前规则 */
.file-preview-video:hover::before,
.file-preview-image:hover::before,
.file-preview-audio:hover::before,
.file-preview-document:hover::before {
  /* 不需要任何特殊处理，继承上面的样式 */
}

.video-controls {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  padding: 12px 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0));
  opacity: 0;
  transition: opacity 0.2s ease-in-out;
  z-index: 10;
}

.video-progress-bar {
  position: relative;
  width: 100%;
  height: 4px;
  background: rgba(255, 255, 255, 0.2);
  margin-bottom: 8px;
  cursor: pointer;
}

.video-progress {
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  background: #3498db;
  border-radius: 0 2px 2px 0;
  transition: width 0.1s linear;
}

.video-control-buttons {
  width: 100%;
  display: flex;
  justify-content: center;
  gap: 16px;
  padding: 0 10px;
}

.video-btn {
  background: rgba(0, 0, 0, 0.5);
  border: none;
  border-radius: 50%;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  backdrop-filter: blur(3px);
}

.video-btn:hover {
  background: rgba(52, 152, 219, 0.8);
  transform: scale(1.1);
}

.video-btn svg {
  width: 18px;
  height: 18px;
}

.file-preview-audio, .file-preview-document {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.audio-icon, .document-icon {
  width: 60px;
  height: 60px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  margin-bottom: 10px;
}

.document-icon {
  background: rgba(75, 125, 85, 0.4);
  color: rgba(255, 255, 255, 0.9);
}

.audio-info, .document-name {
  text-align: center;
}

.audio-name, .document-name {
  font-size: 14px;
  color: white;
  max-width: 120px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.audio-type {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

.remove-file-btn {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 28px;
  height: 28px;
  background: rgba(0, 0, 0, 0.7);
  border: none;
  border-radius: 50%;
  color: white;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  z-index: 2;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
}

.remove-file-btn:hover {
  background: rgba(231, 76, 60, 0.9);
  transform: scale(1.1);
}

/* 专门为音频文件的删除按钮定义样式 */
.uploaded-file-item:has(.music-track-layout) .remove-file-btn {
  top: 50%;
  transform: translateY(-50%);
  right: 8px;
  background: rgba(231, 76, 60, 0.7);
  z-index: 11;
  width: 26px;
  height: 26px;
  font-size: 14px;
}

.uploaded-file-item:has(.music-track-layout) .remove-file-btn:hover {
  background: rgba(231, 76, 60, 1);
  transform: translateY(-50%) scale(1.1);
}

.upload-dropzone {
  border: 2px dashed rgba(255, 255, 255, 0.3);
  border-radius: 16px;
  padding: 40px 30px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 220px;
  background: rgba(30, 30, 35, 0.4);
  position: relative;
  overflow: hidden;
}

.upload-dropzone:hover {
  border-color: rgba(100, 138, 255, 0.6);
  background: rgba(40, 40, 50, 0.5);
  transform: translateY(-3px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}

.upload-dropzone::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(45deg, transparent, rgba(100, 138, 255, 0.1), transparent);
  background-size: 200% 200%;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.upload-dropzone:hover::before {
  opacity: 1;
  animation: shimmer 2s linear infinite;
}

@keyframes shimmer {
  0% {
    background-position: 0% 50%;
  }
  100% {
    background-position: 200% 50%;
  }
}

.upload-icon {
  font-size: 40px;
  margin-bottom: 20px;
  color: rgba(255, 255, 255, 0.8);
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: rgba(100, 138, 255, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.upload-dropzone:hover .upload-icon {
  background: rgba(100, 138, 255, 0.3);
  transform: scale(1.05);
}

.upload-text {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 10px;
}

.upload-subtext {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
  max-width: 400px;
  margin: 0 auto;
}

.hidden-file-input {
  display: none;
}

.wallet-section {
  text-align: center;
  padding: 30px;
  margin-top: 20px;
}

.wallet-section h3 {
  font-size: 18px;
  margin-bottom: 10px;
  color: white;
  font-weight: normal;
}

.wallet-section p {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 20px;
}

.wallet-placeholder {
  background: rgba(30, 30, 35, 0.6);
  border-radius: 10px;
  padding: 40px;
}

.wallet-placeholder p {
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
}

.description-group {
  margin-top: 30px;
}

.textarea-field {
  height: 120px;
  resize: none;
}

.navigation-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 40px;
}

.back-btn, .next-btn {
  padding: 12px 20px;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  transition: all 0.3s;
}

.back-btn {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
}

.back-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

.next-btn {
  background: #3498db;
  border: none;
  color: white;
}

.next-btn:hover:not(:disabled) {
  background: #2980b9;
}

.next-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.arrow {
  margin: 0 5px;
}

/* 拖拽相关样式 */
.uploaded-file-item.drag-over {
  border-color: rgba(100, 138, 255, 0.8);
  background: rgba(100, 138, 255, 0.2);
  transform: scale(1.05);
}

/* 视频加载状态 */
.file-preview-video.loading::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 3;
}

.file-preview-video.loading::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 40px;
  height: 40px;
  margin-top: -20px;
  margin-left: -20px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-top: 3px solid #64EEBC;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  z-index: 4;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.file-preview-media {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.file-preview-video.playing::after {
  content: '';
  position: absolute;
  bottom: 6px;
  right: 6px;
  width: 8px;
  height: 8px;
  background-color: #64EEBC;
  border-radius: 50%;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% {
    transform: scale(0.95);
    box-shadow: 0 0 0 0 rgba(100, 238, 188, 0.7);
  }
  
  70% {
    transform: scale(1);
    box-shadow: 0 0 0 6px rgba(100, 238, 188, 0);
  }
  
  100% {
    transform: scale(0.95);
    box-shadow: 0 0 0 0 rgba(100, 238, 188, 0);
  }
}

.file-preview-audio.music-track-layout {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 8px 15px;
  background-color: rgba(20, 20, 25, 0.7);
  border-radius: 6px;
  height: auto;
  width: 100%;
  margin-bottom: 0;
  position: relative;
}

.music-track-thumbnail {
  width: 48px;
  height: 48px;
  min-width: 48px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.music-thumbnail-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(40, 40, 45, 0.8);
}

.music-track-info {
  flex: 0 1 180px;
  min-width: 0;
  overflow: hidden;
  margin: 0 10px 0 5px;
  text-align: left;
}

.music-track-title {
  font-size: 14px;
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  color: white;
  margin-bottom: 4px;
}

.music-track-artist {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.music-track-tags {
  display: flex;
  align-items: center;
  gap: 5px;
}

.track-tag {
  background-color: rgba(255, 255, 255, 0.2);
  padding: 2px 5px;
  border-radius: 4px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  min-width: 40px;
  text-align: right;
}

.music-track-controls {
  display: flex;
  gap: 10px;
  flex-shrink: 0;
  margin-right: 35px;
}

.music-duration {
  font-size: 14px;
  color: white;
}

.music-control-buttons {
  display: flex;
  align-items: center;
  gap: 5px;
}

.music-btn {
  background: rgba(0, 0, 0, 0.5);
  border: none;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  padding: 0;
  transition: all 0.2s;
  backdrop-filter: blur(3px);
}

.music-btn:hover {
  background: rgba(52, 152, 219, 0.8);
  transform: scale(1.1);
}

.music-btn svg {
  width: 16px;
  height: 16px;
}

.audio-progress-bar {
  width: 100%;
  height: 4px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 2px;
  overflow: hidden;
}

.audio-progress {
  height: 100%;
  background: #FECA25;
  border-radius: 2px;
  transition: width 0.1s linear;
}

/* 视频和图片的网格布局 */
@media (min-width: 768px) {
  .uploaded-files-grid:has(.file-preview-video), 
  .uploaded-files-grid:has(.file-preview-image) {
    grid-template-columns: repeat(2, 1fr);
    gap: 30px;
  }
}

.music-track-waveform {
  flex: 1;
  height: 40px;
  position: relative;
  margin: 0 15px;
  display: flex !important;
  align-items: center;
  overflow: hidden;
  border-radius: 4px;
  background: rgba(30, 30, 35, 0.7) !important;
  min-width: 180px;
  cursor: pointer;
  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.5);
  padding: 0;
}

.waveform-display {
  width: 100%;
  height: 100%;
  position: relative;
  display: flex;
  align-items: center;
  background: #16161a;
  overflow: hidden;
  border-radius: 3px;
}

/* Pro audio waveform container styles */
.audio-track-waveform {
  flex: 1;
  height: 40px;
  position: relative;
  border-radius: 3px;
  overflow: hidden;
  background: #16161a;
  min-width: 100px;
  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.7);
  border: 1px solid rgba(0, 0, 0, 0.8);
}

/* Playhead animation effect */
@keyframes pulse-playhead {
  0%, 100% { opacity: 0.8; box-shadow: 0 0 4px rgba(254, 202, 37, 0.5); }
  50% { opacity: 1; box-shadow: 0 0 8px rgba(254, 202, 37, 0.7); }
}

/* Time markings - subtle tick marks in the waveform */
.waveform-display::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: 
    repeating-linear-gradient(
      90deg,
      transparent,
      transparent 50px,
      rgba(255, 255, 255, 0.03) 50px,
      rgba(255, 255, 255, 0.03) 51px
    );
  z-index: 0;
  pointer-events: none;
}

/* Audio controls & layout improvement */
.audio-track-controls {
  display: flex;
  gap: 8px;
  flex-shrink: 0;
  margin-right: 25px;
}

.audio-track-time {
  flex-shrink: 0;
  min-width: 45px;
  font-family: 'Courier New', monospace;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.8);
  text-align: right;
  margin-left: 10px;
  margin-right: 8px;
}

/* Enhance the overall audio track item */
.audio-track-item {
  display: flex;
  align-items: center;
  padding: 8px 15px;
  background: rgba(20, 20, 22, 0.8);
  border-radius: 0;
  position: relative;
  gap: 12px;
  transition: all 0.25s ease;
  border-bottom: 1px solid rgba(30, 30, 35, 0.3);
  height: 56px;
}

.audio-track-item:hover {
  background: rgba(25, 25, 28, 0.9);
}

.audio-track-item.playing {
  background: rgba(28, 28, 32, 0.95);
}

/* Fix waveform playhead visibility when playing */
.audio-track-item.playing .waveform-playhead {
  animation: pulse-playhead 1.5s infinite;
}

.format-label {
  display: inline-block;
  background: rgba(254, 202, 37, 0.5);
  color: white;
  font-size: 10px;
  padding: 2px 5px;
  border-radius: 3px;
  font-weight: 500;
  letter-spacing: 0.5px;
  flex-shrink: 0;
  min-width: 35px;
  text-align: center;
}

@keyframes pulse-vertical {
  0%, 100% { opacity: 0.7; }
  50% { opacity: 1; }
}

/* Music Track Layout Styles */
.music-track-layout {
  display: flex;
  align-items: center;
  padding: 10px 15px;
  background: rgba(20, 20, 25, 0.8);
  border-radius: 5px;
  height: 60px;
  position: relative;
  gap: 10px;
  border-left: 3px solid rgba(254, 202, 37, 0.8);
  margin-bottom: 8px;
}

.music-track-layout.playing {
  background: rgba(25, 25, 30, 0.9);
  border-left-color: rgba(254, 202, 37, 1);
}

.music-track-layout::before {
  display: none;
}

/* 音频播放按钮优化样式 */
.music-play-button {
  width: 38px;
  height: 38px;
  min-width: 38px;
  background: rgba(30, 30, 35, 0.6);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(254, 202, 37, 0.3);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
}

.music-play-button::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at center, rgba(254, 202, 37, 0.3) 0%, rgba(30, 30, 35, 0) 70%);
  opacity: 0;
  transition: opacity 0.3s ease;
  z-index: 1;
}

.music-play-button:hover::before {
  opacity: 1;
}

.play-button-inner {
  position: relative;
  z-index: 2;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.music-play-button svg {
  filter: drop-shadow(0 1px 2px rgba(0, 0, 0, 0.5));
  transition: all 0.25s ease;
  transform-origin: center;
}

.music-play-button:hover {
  background: rgba(254, 202, 37, 0.8);
  transform: scale(1.08);
  box-shadow: 0 3px 10px rgba(254, 202, 37, 0.3);
}

.music-play-button:hover svg {
  transform: scale(1.1);
}

.music-play-button:active {
  transform: scale(0.95);
}

.music-play-button.playing {
  background: rgba(254, 202, 37, 0.85);
  box-shadow: 0 0 15px rgba(254, 202, 37, 0.4);
  animation: pulse-play-btn 2s infinite alternate;
}

@keyframes pulse-play-btn {
  0% {
    box-shadow: 0 0 5px rgba(254, 202, 37, 0.4);
  }
  100% {
    box-shadow: 0 0 15px rgba(254, 202, 37, 0.6);
  }
}

.music-play-button.playing:hover {
  background: rgba(254, 202, 37, 1);
}

/* 其他控制按钮样式 */
.music-track-controls {
  display: flex;
  gap: 10px;
  flex-shrink: 0;
  margin-right: 35px;
}

.music-control-btn {
  width: 32px;
  height: 32px;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

.image-control-btn:hover {
  background: rgba(0, 120, 250, 0.8);
  transform: scale(1.1);
}

/* 图片网格布局调整 - 一行显示4个图片 */
@media (min-width: 768px) {
  .uploaded-files-grid:has(.file-preview-image) {
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
  }
}

@media (min-width: 992px) {
  .uploaded-files-grid:has(.file-preview-image) {
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
  }
}

/* 适配图片尺寸，保持高宽比例，确保一行能放4个 */
.uploaded-file-item:has(.image-wrapper) {
  aspect-ratio: 1/1;
  max-height: 220px;
  overflow: hidden;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  position: relative;
  border: 1px solid rgba(0, 112, 243, 0.2);
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.uploaded-file-item:has(.image-wrapper):hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
  border-color: rgba(0, 112, 243, 0.5);
}

.image-wrapper {
  width: 100%;
  height: 100%;
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.file-preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.uploaded-file-item:has(.image-wrapper):hover .file-preview-image {
  transform: scale(1.05);
}

.image-info-badge {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.7), transparent);
  color: white;
  padding: 10px 8px 6px;
  font-size: 11px;
  text-align: center;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.3s ease;
}

.uploaded-file-item:has(.image-wrapper):hover .image-info-badge {
  opacity: 1;
  transform: translateY(0);
}

.image-preview-controls {
  position: absolute;
  top: 8px;
  right: 8px;
  display: flex;
  gap: 8px;
  opacity: 0;
  transform: translateY(-10px);
  transition: all 0.3s ease;
}

.uploaded-file-item:has(.image-wrapper):hover .image-preview-controls {
  opacity: 1;
  transform: translateY(0);
}

.image-control-btn {
  width: 28px;
  height: 28px;
  background: rgba(0, 0, 0, 0.6);
  border: none;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  backdrop-filter: blur(2px);
}

.image-control-btn:hover {
  background: rgba(0, 120, 250, 0.8);
  transform: scale(1.1);
}

/* 小屏幕设备上使用2列布局 */
@media (max-width: 767px) {
  .uploaded-files-grid:has(.image-wrapper) {
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }
  
  .uploaded-file-item:has(.image-wrapper) {
    max-height: 160px;
  }
}

/* 特小屏幕设备使用1列布局 */
@media (max-width: 479px) {
  .uploaded-files-grid:has(.image-wrapper) {
    grid-template-columns: repeat(1, 1fr);
  }
  
  .uploaded-file-item:has(.image-wrapper) {
    max-height: 200px;
  }
}

/* 修复上传文件网格的通用样式 */
.uploaded-files-grid {
  display: grid;
  gap: 15px;
  width: 100%;
  margin-bottom: 20px;
}

.uploaded-file-item {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
}

.uploaded-file-item .remove-file-btn {
  z-index: 10;
  opacity: 0;
  transition: opacity 0.2s ease, transform 0.2s ease;
  position: absolute;
  top: 8px;
  right: 8px;
  width: 28px;
  height: 28px;
  background: rgba(0, 0, 0, 0.7);
  border: none;
  border-radius: 50%;
  color: white;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
}

.uploaded-file-item:hover .remove-file-btn {
  opacity: 1;
}

.uploaded-file-item .remove-file-btn:hover {
  background: rgba(231, 76, 60, 0.9);
  transform: scale(1.1);
}

/* 调整图片内删除按钮的位置，避免与全屏预览按钮重叠 */
.uploaded-file-item:has(.image-wrapper) .remove-file-btn {
  top: 8px;
  left: 8px;
  right: auto;
}

/* 确保图片预览控制按钮与删除按钮不重叠 */
.uploaded-file-item:has(.image-wrapper) .image-preview-controls {
  top: 8px;
  right: 8px;
}

/* 文字类文件展示为4列布局 */
@media (min-width: 768px) {
  .uploaded-files-grid:has(.file-preview-document) {
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
  }
}

@media (min-width: 992px) {
  .uploaded-files-grid:has(.file-preview-document) {
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
  }
}

/* 响应式布局调整：小屏幕上文字类展示为2列 */
@media (max-width: 767px) {
  .uploaded-files-grid:has(.file-preview-document) {
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }
  
  .uploaded-file-item:has(.file-preview-document) {
    height: 140px;
  }
}

/* 特小屏幕设备文字类使用1列布局 */
@media (max-width: 479px) {
  .uploaded-files-grid:has(.file-preview-document) {
    grid-template-columns: repeat(1, 1fr);
  }
  
  .uploaded-file-item:has(.file-preview-document) {
    height: 200px;
  }
}

/* 文字类预览容器样式优化 */
.uploaded-file-item:has(.file-preview-document) {
  aspect-ratio: 1/1;
  height: 180px;
  background: rgba(0, 183, 106, 0.08);
  border: 1px solid rgba(0, 183, 106, 0.2);
  border-radius: 8px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.uploaded-file-item:has(.file-preview-document):hover {
  transform: translateY(-5px);
  background: rgba(0, 183, 106, 0.12);
  border-color: rgba(0, 183, 106, 0.4);
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.4), 0 0 0 1px rgba(0, 183, 106, 0.3);
}

/* 文字类文件内容样式优化 */
.file-preview-document {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  width: 100%;
  padding: 15px;
  position: relative;
  text-align: center;
}

.document-icon {
  width: 60px;
  height: 60px;
  background: rgba(0, 183, 106, 0.25);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  margin-bottom: 15px;
  color: rgba(255, 255, 255, 0.9);
  border: 2px solid rgba(0, 183, 106, 0.4);
  transition: all 0.3s ease;
}

.uploaded-file-item:has(.file-preview-document):hover .document-icon {
  transform: scale(1.1);
  background: rgba(0, 183, 106, 0.35);
  box-shadow: 0 0 15px rgba(0, 183, 106, 0.4);
}

.document-name {
  font-size: 14px;
  color: white;
  max-width: 90%;
  padding-top: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: all 0.2s ease;
}

/* 文件类型标签 */
.document-type-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(0, 183, 106, 0.3);
  padding: 3px 8px;
  border-radius: 4px;
  font-size: 11px;
  color: rgba(255, 255, 255, 0.9);
  font-weight: 500;
  opacity: 0;
  transform: translateY(-5px);
  transition: all 0.3s ease;
  z-index: 2;
}

.uploaded-file-item:has(.file-preview-document):hover .document-type-badge {
  opacity: 1;
  transform: translateY(0);
}

/* 不同类型文档的样式 */
.document-icon.doc-pdf {
  background: rgba(230, 80, 60, 0.25);
  border-color: rgba(230, 80, 60, 0.4);
  color: rgba(255, 255, 255, 0.95);
}

.uploaded-file-item:has(.document-icon.doc-pdf):hover {
  background: rgba(230, 80, 60, 0.08);
  border-color: rgba(230, 80, 60, 0.3);
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.4), 0 0 0 1px rgba(230, 80, 60, 0.3);
}

.uploaded-file-item:has(.document-icon.doc-pdf):hover .document-icon {
  background: rgba(230, 80, 60, 0.35);
  box-shadow: 0 0 15px rgba(230, 80, 60, 0.4);
}

.uploaded-file-item:has(.document-icon.doc-pdf) .document-type-badge {
  background: rgba(230, 80, 60, 0.3);
}

.document-icon.doc-word {
  background: rgba(50, 100, 210, 0.25);
  border-color: rgba(50, 100, 210, 0.4);
  color: rgba(255, 255, 255, 0.95);
}

.uploaded-file-item:has(.document-icon.doc-word):hover {
  background: rgba(50, 100, 210, 0.08);
  border-color: rgba(50, 100, 210, 0.3);
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.4), 0 0 0 1px rgba(50, 100, 210, 0.3);
}

.uploaded-file-item:has(.document-icon.doc-word):hover .document-icon {
  background: rgba(50, 100, 210, 0.35);
  box-shadow: 0 0 15px rgba(50, 100, 210, 0.4);
}

.uploaded-file-item:has(.document-icon.doc-word) .document-type-badge {
  background: rgba(50, 100, 210, 0.3);
}

.document-icon.doc-text {
  background: rgba(150, 150, 150, 0.25);
  border-color: rgba(150, 150, 150, 0.4);
  color: rgba(255, 255, 255, 0.95);
}

.uploaded-file-item:has(.document-icon.doc-text):hover {
  background: rgba(150, 150, 150, 0.08);
  border-color: rgba(150, 150, 150, 0.3);
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.4), 0 0 0 1px rgba(150, 150, 150, 0.3);
}

.uploaded-file-item:has(.document-icon.doc-text):hover .document-icon {
  background: rgba(150, 150, 150, 0.35);
  box-shadow: 0 0 15px rgba(150, 150, 150, 0.4);
}

.uploaded-file-item:has(.document-icon.doc-text) .document-type-badge {
  background: rgba(150, 150, 150, 0.3);
}

/* 视频类选中状态 - 保持背景透明 */
.asset-type-card.selected[data-type="video"] {
  background: transparent;
  box-shadow: 0 0 20px rgba(121, 40, 202, 0.4);
  border: 1px solid rgba(121, 40, 202, 0.4);
  transform: translateY(-2px) scale(1.02);
  transition: all 0.3s ease;
}

/* 图片类选中状态 - 保持背景透明 */
.asset-type-card.selected[data-type="image"] {
  background: transparent;
  box-shadow: 0 0 20px rgba(0, 112, 243, 0.4);
  border: 1px solid rgba(0, 112, 243, 0.4);
  transform: translateY(-2px) scale(1.02);
  transition: all 0.3s ease;
}

/* 音频类选中状态 - 保持背景透明 */
.asset-type-card.selected[data-type="audio"] {
  background: transparent;
  box-shadow: 0 0 20px rgba(254, 202, 37, 0.4);
  border: 1px solid rgba(254, 202, 37, 0.4);
  transform: translateY(-2px) scale(1.02);
  transition: all 0.3s ease;
}

/* 文字类选中状态 - 保持背景透明 */
.asset-type-card.selected[data-type="text"] {
  background: transparent;
  box-shadow: 0 0 20px rgba(0, 183, 106, 0.4);
  border: 1px solid rgba(0, 183, 106, 0.4);
  transform: translateY(-2px) scale(1.02);
  transition: all 0.3s ease;
}

/* 控制按钮的增强样式 */
.music-control-btn {
  width: 32px;
  height: 32px;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
}

.music-control-btn::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at center, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.music-control-btn:hover::before {
  opacity: 1;
}

.music-control-btn svg {
  filter: drop-shadow(0 1px 1px rgba(0, 0, 0, 0.3));
  transition: transform 0.2s ease;
}

.music-control-btn:hover {
  background: rgba(254, 202, 37, 0.6);
  transform: scale(1.1);
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.25);
}

.music-control-btn:hover svg {
  transform: scale(1.1);
}

.music-control-btn:active {
  transform: scale(0.95);
}

.music-control-btn.menu-btn:hover {
  background: rgba(255, 255, 255, 0.3);
}

.music-control-btn.volume-btn:hover {
  background: rgba(254, 202, 37, 0.8);
}

.uiverse {
  background: #3498db;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 12px 20px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
  overflow: hidden;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.uiverse:hover {
  background: #2980b9;
  transform: scale(1.05);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
}

.uiverse:active {
  transform: scale(0.95);
}

.wrapper {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.circle {
  position: absolute;
  border-radius: 50%;
  animation: circle-animation 7s linear infinite;
}

.circle-1 {
  width: 10px;
  height: 10px;
  background: rgba(255, 255, 255, 0.3);
  top: 0;
  left: 0;
}

.circle-2 {
  width: 15px;
  height: 15px;
  background: rgba(255, 255, 255, 0.2);
  top: 0;
  right: 0;
}

.circle-3 {
  width: 20px;
  height: 20px;
  background: rgba(255, 255, 255, 0.1);
  bottom: 0;
  left: 0;
}

.circle-4 {
  width: 25px;
  height: 25px;
  background: rgba(255, 255, 255, 0.05);
  bottom: 0;
  right: 0;
}

.circle-5 {
  width: 30px;
  height: 30px;
  background: rgba(255, 255, 255, 0.03);
  top: 0;
  left: 0;
}

.circle-6 {
  width: 35px;
  height: 35px;
  background: rgba(255, 255, 255, 0.02);
  top: 0;
  right: 0;
}

.circle-7 {
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.01);
  bottom: 0;
  left: 0;
}

.circle-8 {
  width: 45px;
  height: 45px;
  background: rgba(255, 255, 255, 0.005);
  bottom: 0;
  right: 0;
}

.circle-9 {
  width: 50px;
  height: 50px;
  background: rgba(255, 255, 255, 0.002);
  top: 0;
  left: 0;
}

.circle-10 {
  width: 55px;
  height: 55px;
  background: rgba(255, 255, 255, 0.001);
  top: 0;
  right: 0;
}

.circle-11 {
  width: 60px;
  height: 60px;
  background: rgba(255, 255, 255, 0.0005);
  bottom: 0;
  left: 0;
}

.circle-12 {
  width: 65px;
  height: 65px;
  background: rgba(255, 255, 255, 0.0002);
  bottom: 0;
  right: 0;
}

@keyframes circle-animation {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.2);
    opacity: 0.8;
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

/* Uiverse button style */
.uiverse {
  --duration: 7s;
  --easing: linear;
  --c-color-1: #ffd58c;
  --c-color-2: #69a5ff;
  --c-color-3: #c29fff;
  --c-color-4: rgba(140, 232, 255, 0.7);
  --c-shadow: rgba(99, 85, 255, 0.59);
  --c-shadow-inset-top: rgba(132, 156, 255, 0.9);
  --c-shadow-inset-bottom: rgba(62, 145, 255, 0.614);
  --c-radial-inner: #2637a4;
  --c-radial-outer: #5f64ea;
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

.arrow-icon {
  width: 32px;
  height: 32px;
  fill: currentColor;
}

.arrow-back {
  transform: rotate(180deg);
}

.cover-upload-section {
  margin-bottom: 20px;
}

.cover-upload-title {
  font-size: 16px;
  margin-bottom: 10px;
  color: white;
}

.cover-upload-desc {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.cover-upload-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border: 2px dashed rgba(255, 255, 255, 0.3);
  border-radius: 10px;
  padding: 40px 20px;
  margin-top: 15px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  background-color: rgba(30, 30, 40, 0.4);
}

.cover-upload-area.drag-over {
  border-color: rgba(100, 138, 255, 0.8);
  background-color: rgba(40, 40, 60, 0.6);
  transform: scale(1.02);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.cover-upload-area .upload-icon {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  width: 64px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
  transition: all 0.3s ease;
}

.cover-upload-area .upload-icon svg {
  color: white;
}

.cover-upload-area .upload-text {
  font-size: 16px;
  font-weight: 500;
  color: white;
  margin: 10px 0;
}

.cover-preview-container {
  margin-top: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px dashed rgba(255, 255, 255, 0.3);
  border-radius: 10px;
  padding: 20px;
}

.cover-preview {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.cover-preview-image {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 5px;
  margin-bottom: 10px;
}

.cover-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.cover-filename {
  font-size: 14px;
  color: white;
  margin-bottom: 5px;
}

.cover-dimensions {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
}

.remove-cover-btn {
  background: rgba(231, 76, 60, 0.7);
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  color: white;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
  position: absolute;
  top: 5px;
  right: 5px;
}

.remove-cover-btn:hover {
  background: rgba(231, 76, 60, 1);
  transform: scale(1.1);
}
</style> 
