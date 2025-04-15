<template>
  <div class="custom-license">
    <!-- 显示已选择的预设许可证 -->
    <div class="selected-preset-licenses" v-if="selectedLicenses && selectedLicenses.length > 0">
      <h3>您选择的预设许可证</h3>
      <div class="preset-licenses-list">
        <div v-for="license in selectedLicenses" :key="license" class="preset-license-tag">
          <span class="license-name">{{ getLicenseName(license) }}</span>
        </div>
      </div>
      <p class="license-hint">您可以根据以下选项，进一步自定义许可证条款</p>
    </div>

    <div class="license-filter-list">
      <!-- AI Training 选项 -->
      <div class="license-filter-item" :class="{ expanded: expandedFilters['ai-training'] }">
        <div class="filter-header" @click="toggleFilter('ai-training')">
          <div class="filter-left">
            <span class="filter-icon">
              <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 512 512" viewBox="0 0 512 512" id="ai" width="20" height="20" fill="currentColor" style="vertical-align: middle; position: relative; top: -1px;">
                <path d="M338.158 102.509H173.842c-39.366 0-71.32 31.955-71.32 71.4v164.236c0 39.366 31.955 71.32 71.32 71.32h164.316c39.366 0 71.32-31.955 71.32-71.32V173.909C409.478 134.463 377.523 102.509 338.158 102.509zM359.036 311.13c0 26.456-21.436 47.892-47.892 47.892H200.856c-26.456 0-47.892-21.436-47.892-47.892V200.843c0-26.456 21.436-47.892 47.892-47.892h110.287c26.456 0 47.892 21.436 47.892 47.892V311.13zM190.25 73.007c4.405 0 7.969-3.564 7.969-7.969V8.969c0-4.405-3.564-7.969-7.969-7.969s-7.969 3.564-7.969 7.969v56.069C182.281 69.443 185.845 73.007 190.25 73.007zM256 73.007c4.405 0 7.969-3.564 7.969-7.969V8.969C263.969 4.564 260.405 1 256 1s-7.969 3.564-7.969 7.969v56.069C248.031 69.443 251.595 73.007 256 73.007zM321.75 73.007c4.405 0 7.969-3.564 7.969-7.969V8.969c0-4.405-3.564-7.969-7.969-7.969s-7.969 3.564-7.969 7.969v56.069C313.781 69.443 317.345 73.007 321.75 73.007zM190.25 439.001c-4.405 0-7.969 3.564-7.969 7.969v56.061c0 4.405 3.564 7.969 7.969 7.969s7.969-3.564 7.969-7.969V446.97C198.219 442.565 194.655 439.001 190.25 439.001zM256 439.001c-4.405 0-7.969 3.564-7.969 7.969v56.061c0 4.405 3.564 7.969 7.969 7.969s7.969-3.564 7.969-7.969V446.97C263.969 442.565 260.405 439.001 256 439.001zM321.75 439.001c-4.405 0-7.969 3.564-7.969 7.969v56.061c0 4.405 3.564 7.969 7.969 7.969s7.969-3.564 7.969-7.969V446.97C329.719 442.565 326.155 439.001 321.75 439.001zM446.962 198.219h56.069c4.405 0 7.969-3.564 7.969-7.969s-3.564-7.969-7.969-7.969h-56.069c-4.405 0-7.969 3.564-7.969 7.969S442.557 198.219 446.962 198.219zM503.031 248.031h-56.069c-4.405 0-7.969 3.564-7.969 7.969s3.564 7.969 7.969 7.969h56.069c4.405 0 7.969-3.564 7.969-7.969S507.436 248.031 503.031 248.031zM503.031 313.789h-56.069c-4.405 0-7.969 3.564-7.969 7.969s3.564 7.969 7.969 7.969h56.069c4.405 0 7.969-3.564 7.969-7.969S507.436 313.789 503.031 313.789zM65.038 182.281H8.969c-4.405 0-7.969 3.564-7.969 7.969s3.564 7.969 7.969 7.969h56.069c4.405 0 7.969-3.564 7.969-7.969S69.443 182.281 65.038 182.281zM65.038 248.031H8.969C4.564 248.031 1 251.595 1 256s3.564 7.969 7.969 7.969h56.069c4.405 0 7.969-3.564 7.969-7.969S69.443 248.031 65.038 248.031zM65.038 313.789H8.969c-4.405 0-7.969 3.564-7.969 7.969s3.564 7.969 7.969 7.969h56.069c4.405 0 7.969-3.564 7.969-7.969S69.443 313.789 65.038 313.789z"></path>
                <path d="M235.281 201.72c-19.922 0-36.099 16.176-36.099 36.098v64.467c0 4.383 3.586 7.969 7.969 7.969 4.383 0 7.969-3.586 7.969-7.969v-38.33h40.322v38.33c0 4.383 3.506 7.969 7.969 7.969 4.383 0 7.969-3.586 7.969-7.969v-64.467C271.38 217.896 255.124 201.72 235.281 201.72zM255.442 248.018H215.12v-10.2c0-11.076 9.005-20.161 20.161-20.161 11.076 0 20.161 9.085 20.161 20.161V248.018zM304.855 201.736c-4.405 0-7.969 3.564-7.969 7.969v92.598c0 4.405 3.564 7.969 7.969 7.969s7.969-3.564 7.969-7.969v-92.598C312.824 205.3 309.26 201.736 304.855 201.736z"></path>
              </svg>
            </span>
            <span class="filter-text">AI培训</span>
          </div>
          <div class="filter-right">
            <div class="filter-status allowed" :class="{ active: filterSelections['ai-training'] === 'yes' }">{{ getAITrainingStatus() }}</div>
            <div class="expand-arrow">
              <span :class="{ rotated: expandedFilters['ai-training'] }">▼</span>
            </div>
          </div>
        </div>
        <div class="filter-content" v-if="expandedFilters['ai-training']">
          <div class="filter-question">
            <h4 class="question-title">允许使用该作品训练AI模型。</h4>
          </div>
          <div class="filter-options">
            <button 
              :class="['option-btn', 'yes-btn', { selected: filterSelections['ai-training'] === 'yes' }]"
              @click="setFilter('ai-training', 'yes')"
            >
              是的
            </button>
            <button 
              :class="['option-btn', 'no-btn', { selected: filterSelections['ai-training'] === 'no' }]"
              @click="setFilter('ai-training', 'no')"
            >
              不
            </button>
          </div>
          <button class="filter-clear" @click="clearFilter('ai-training')">清除</button>
        </div>
      </div>
      
      <!-- Commercial Use 选项 -->
      <div class="license-filter-item" :class="{ expanded: expandedFilters['commercial-use'] }">
        <div class="filter-header" @click="toggleFilter('commercial-use')">
          <div class="filter-left">
            <span class="filter-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" id="business-law" width="20" height="20" fill="currentColor" style="vertical-align: middle; position: relative; top: -1px;">
                <path d="M29.42,66.82H5.09A.78.78,0,0,0,4.44,68a15.62,15.62,0,0,0,25.63,0,.77.77,0,0,0-.65-1.21"></path>
                <path d="M30.35,62.35h-.86L18.11,39.29a1,1,0,0,0-.85-.53h0a.93.93,0,0,0-.85.54L5.16,62.35h-1a.62.62,0,0,0-.62.62v1.39a.62.62,0,0,0,.62.62H30.35a.62.62,0,0,0,.62-.62V63a.62.62,0,0,0-.62-.62M17.26,41.87,27.37,62.35H7.27Z"></path>
                <path d="M96.91,52.86H72.55a.79.79,0,0,0-.65,1.22,15.62,15.62,0,0,0,25.65,0,.78.78,0,0,0-.64-1.22"></path>
                <path d="M97.83 48.39H97L85.58 25.31a1 1 0 0 0-.85-.53h0a1 1 0 0 0-.86.53L72.62 48.39h-1A.62.62 0 0 0 71 49V50.4a.62.62 0 0 0 .62.62H97.83a.62.62 0 0 0 .62-.62V49a.62.62 0 0 0-.62-.62m-13.1-20.5l10.12 20.5H74.74zM89.13 15.24a5.38 5.38 0 0 0-6.3-3.67L16.09 25.69a5.36 5.36 0 0 0-4.27 5.91 5.26 5.26 0 0 0 10.47-1 5.41 5.41 0 0 0-.17-1.08.86.86 0 0 1 1.08-1 58.19 58.19 0 0 0 28.55 1A58.12 58.12 0 0 0 77.46 17a.86.86 0 0 1 1.41.52 5.14 5.14 0 0 0 .29 1 5.26 5.26 0 0 0 10-3.34M50.47 26.39a2.6 2.6 0 1 1 2.6-2.6 2.59 2.59 0 0 1-2.6 2.6"></path>
                <path d="M73.65,84.39H70.2A1.19,1.19,0,0,1,69,83.28a1.18,1.18,0,0,0-1.24-1.12H60.28a1.06,1.06,0,0,1-1-.94l-5-48.57A1,1,0,0,0,53,31.79l-1.32.3q-2.07.44-4.14.72a1,1,0,0,0-.85.88L41.76,81.22a1,1,0,0,1-1,.94h-7.5A1.18,1.18,0,0,0,32,83.28a1.19,1.19,0,0,1-1.24,1.11H27.29a1.18,1.18,0,0,0-1.24,1.12v3.92a1.18,1.18,0,0,0,1.24,1.12H73.65a1.18,1.18,0,0,0,1.24-1.12V85.51a1.18,1.18,0,0,0-1.24-1.12"></path>
              </svg>
            </span>
            <span class="filter-text">商业使用</span>
          </div>
          <div class="filter-right">
            <div class="filter-status allowed" :class="{ active: filterSelections['commercial-use'] === 'yes' }">{{ getCommercialUseStatus() }}</div>
            <div class="expand-arrow">
              <span :class="{ rotated: expandedFilters['commercial-use'] }">▼</span>
            </div>
          </div>
        </div>
        <div class="filter-content" v-if="expandedFilters['commercial-use']">
          <div class="filter-question">
            <h4 class="question-title">允许将作品用于商业目的。</h4>
          </div>
          <div class="filter-options">
            <button 
              :class="['option-btn', 'yes-btn', { selected: filterSelections['commercial-use'] === 'yes' }]"
              @click="setFilter('commercial-use', 'yes')"
            >
              是的
            </button>
            <button 
              :class="['option-btn', 'no-btn', { selected: filterSelections['commercial-use'] === 'no' }]"
              @click="setFilter('commercial-use', 'no')"
            >
              不
            </button>
          </div>
          
          <!-- 商业使用上传文件触发器 -->
          <div v-if="filterSelections['commercial-use'] === 'yes'" class="file-upload-toggle" @click.stop="toggleCommercialUpload">
            <div class="toggle-header">
              <span class="toggle-icon commercial">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                  <polyline points="17 8 12 3 7 8"></polyline>
                  <line x1="12" y1="3" x2="12" y2="15"></line>
                </svg>
              </span>
              <span class="toggle-text">
                选择商业使用必须上传原文件
                <svg class="warning-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" id="caution">
                  <g>
                    <path fill="#fbd63b" d="M28 28H4L16 6l12 22z"></path>
                    <path fill="#f8be31" d="m16 6 12 22H16V6z"></path>
                    <path fill="#333" d="m16 21-2-7h4l-2 7z"></path>
                    <circle cx="16" cy="25" r="1" fill="#333"></circle>
                    <path d="M16 14h2l-2 7v-7zM16 24a1 1 0 0 1 0 2Z"></path>
                    <path d="M28 29H4a1 1 0 0 1-.878-1.479l12-22a1.04 1.04 0 0 1 1.756 0l12 22A1 1 0 0 1 28 29ZM5.685 27h20.63L16 8.088Z"></path>
                  </g>
                </svg>
              </span>
              <span class="toggle-arrow" :class="{ 'rotated': showCommercialUpload }">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" id="down" width="16" height="16">
                  <path d="M511.9 40.9c-24.8 0-49.4 2.2-73.9 5.9-47.6 7.3-93.7 22.4-136.8 43.8-42 20.9-80.9 48.6-114.9 81-33.9 32.3-63.1 70.1-85.9 111-23.2 41.7-40.3 87.2-49.8 134-9.8 48.7-12.4 98.9-6.6 148.3 5.8 49.6 18.9 97.3 39.5 142.8 19.4 42.9 45.7 82.6 77 117.8 31.1 35 67.8 65.4 107.9 89.7 40.6 24.6 85.4 43.2 131.6 54.4 48.1 11.7 98.3 15.9 147.6 12 48.4-3.8 96.2-14.6 141.2-33.1 44.9-18.5 86.2-43.2 123.7-74 36.2-29.8 67.7-65.4 93.5-104.5 26.1-39.6 46.1-83.5 59.1-129.1 13.4-47.4 19.4-97.3 17.5-146.5-1.9-48.7-11.1-97.4-27.9-143.2-16.4-44.5-39-86.4-67.8-124-29.5-38.5-64-72-103.5-100.1-38.6-27.5-81.6-48.8-126.6-63.5-46.6-15.1-95.9-22.7-144.9-22.7zm-3 232.8c16.3.7 30 13.2 30 30v341.6c3.8-3.9 7.6-7.9 11.4-11.9 32.9-34.5 65.9-69 98.9-103.5 7.5-8 15.1-15.9 22.7-23.8 10.8-11.4 31.6-11.8 42.4 0 11.2 12.2 11.6 30.3 0 42.4-20.8 21.8-41.7 43.7-62.6 65.5-32.9 34.5-65.9 69-98.9 103.5-7.6 7.9-15.1 15.9-22.7 23.8-10.9 11.4-31.6 11.7-42.4 0-20.1-21.8-40.3-43.5-60.4-65.3-31.9-34.6-63.8-69.1-95.8-103.7-7.3-7.9-14.7-15.9-22-23.8-10.7-11.5-12.3-31.1 0-42.4 11.6-10.6 31-12.3 42.4 0 20.1 21.7 40.3 43.5 60.4 65.3 22.2 24.1 44.4 48.1 66.6 72.1V354.7c0-16.8-.3-33.6 0-50.3v-.7c0-15.7 13.8-30.7 30-30z"></path>
                </svg>
              </span>
            </div>
          </div>
          
          <!-- 商业使用上传文件组件（隐藏/显示） -->
          <div v-if="filterSelections['commercial-use'] === 'yes' && showCommercialUpload" class="file-upload-section">
            <FileUploadArea
              v-model="commercialFile"
              :isRequired="true"
              variant="commercial"
              @update:modelValue="handleCommercialUpload"
            />
          </div>
          
          <!-- 非商业使用上传文件触发器 -->
          <div v-if="filterSelections['commercial-use'] === 'no'" class="file-upload-toggle" @click.stop="toggleNonCommercialUpload">
            <div class="toggle-header">
              <span class="toggle-icon non-commercial">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                  <polyline points="17 8 12 3 7 8"></polyline>
                  <line x1="12" y1="3" x2="12" y2="15"></line>
                </svg>
              </span>
              <span class="toggle-text">选择非商业使用可选上传原文件</span>
              <span class="toggle-arrow" :class="{ 'rotated': showNonCommercialUpload }">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" id="down" width="16" height="16">
                  <path d="M511.9 40.9c-24.8 0-49.4 2.2-73.9 5.9-47.6 7.3-93.7 22.4-136.8 43.8-42 20.9-80.9 48.6-114.9 81-33.9 32.3-63.1 70.1-85.9 111-23.2 41.7-40.3 87.2-49.8 134-9.8 48.7-12.4 98.9-6.6 148.3 5.8 49.6 18.9 97.3 39.5 142.8 19.4 42.9 45.7 82.6 77 117.8 31.1 35 67.8 65.4 107.9 89.7 40.6 24.6 85.4 43.2 131.6 54.4 48.1 11.7 98.3 15.9 147.6 12 48.4-3.8 96.2-14.6 141.2-33.1 44.9-18.5 86.2-43.2 123.7-74 36.2-29.8 67.7-65.4 93.5-104.5 26.1-39.6 46.1-83.5 59.1-129.1 13.4-47.4 19.4-97.3 17.5-146.5-1.9-48.7-11.1-97.4-27.9-143.2-16.4-44.5-39-86.4-67.8-124-29.5-38.5-64-72-103.5-100.1-38.6-27.5-81.6-48.8-126.6-63.5-46.6-15.1-95.9-22.7-144.9-22.7zm-3 232.8c16.3.7 30 13.2 30 30v341.6c3.8-3.9 7.6-7.9 11.4-11.9 32.9-34.5 65.9-69 98.9-103.5 7.5-8 15.1-15.9 22.7-23.8 10.8-11.4 31.6-11.8 42.4 0 11.2 12.2 11.6 30.3 0 42.4-20.8 21.8-41.7 43.7-62.6 65.5-32.9 34.5-65.9 69-98.9 103.5-7.6 7.9-15.1 15.9-22.7 23.8-10.9 11.4-31.6 11.7-42.4 0-20.1-21.8-40.3-43.5-60.4-65.3-31.9-34.6-63.8-69.1-95.8-103.7-7.3-7.9-14.7-15.9-22-23.8-10.7-11.5-12.3-31.1 0-42.4 11.6-10.6 31-12.3 42.4 0 20.1 21.7 40.3 43.5 60.4 65.3 22.2 24.1 44.4 48.1 66.6 72.1V354.7c0-16.8-.3-33.6 0-50.3v-.7c0-15.7 13.8-30.7 30-30z"></path>
                </svg>
              </span>
            </div>
          </div>
          
          <!-- 非商业使用上传文件组件（隐藏/显示） -->
          <div v-if="filterSelections['commercial-use'] === 'no' && showNonCommercialUpload" class="file-upload-section">
            <FileUploadArea
              v-model="nonCommercialFile"
              variant="default"
              @update:modelValue="handleNonCommercialUpload"
            />
          </div>
          
          <button class="filter-clear" @click="clearFilter('commercial-use')">清除</button>
        </div>
      </div>
      
      <!-- Licensing Fee 选项 -->
      <div class="license-filter-item" :class="{ expanded: expandedFilters['licensing-fee'] }" data-filter="licensing-fee">
        <div class="filter-header" @click="toggleFilter('licensing-fee')">
          <div class="filter-left">
            <span class="filter-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" id="Currency" width="20" height="20" fill="currentColor" style="vertical-align: middle; position: relative; top: -1px;">
                <path fill-rule="evenodd" d="M18 2.107 34 13H2zM18 5c-1.65 0-3 1.35-3 3 0 1.651 1.35 3 3 3s3-1.349 3-3c0-1.65-1.35-3-3-3zm0 1c1.11 0 2 .89 2 2 0 1.11-.89 2-2 2-1.11 0-2-.89-2-2 0-1.11.89-2 2-2zM2.5 14h3c.286 0 .5.214.5.5 0 .286-.214.5-.5.5h-3a.488.488 0 0 1-.5-.5c0-.286.214-.5.5-.5zm7 0h3c.286 0 .5.214.5.5 0 .286-.214.5-.5.5h-3a.488.488 0 0 1-.5-.5c0-.286.214-.5.5-.5zm14 0h3c.286 0 .5.214.5.5 0 .286-.214.5-.5.5h-3a.488.488 0 0 1-.5-.5c0-.286.214-.5.5-.5zm7 0h3c.286 0 .5.214.5.5 0 .286-.214.5-.5.5h-3a.488.488 0 0 1-.5-.5c0-.286.214-.5.5-.5zM3 16h2v14c-.342.054-.945.065-2 0zm7 0h2v14h-2zm14 0h2v14h-2zm7 0h2v14h-2zm-15.64 4 1.585 3H15.5v1h2v1h-2v1h2v2h1v-2h2v-1h-2v-1h2v-1h-1.445l1.586-3H19.51L18 22.857 16.49 20zM2.5 31h3c.286 0 .5.214.5.5 0 .286-.214.5-.5.5h-3a.488.488 0 0 1-.5-.5c0-.286.214-.5.5-.5zm7 0h3c.286 0 .5.214.5.5 0 .286-.214.5-.5.5h-3a.488.488 0 0 1-.5-.5c0-.286.214-.5.5-.5zm14 0h3c.286 0 .5.214.5.5 0 .286-.214.5-.5.5h-3a.488.488 0 0 1-.5-.5c0-.286.214-.5.5-.5zm7 0h3c.286 0 .5.214.5.5 0 .286-.214.5-.5.5h-3a.488.488 0 0 1-.5-.5c0-.286.214-.5.5-.5zM2 33h32c.563 0 1 .437 1 1s-.437 1-1 1H2c-.563 0-1-.437-1-1s.437-1 1-1z"></path>
              </svg>
            </span>
            <span class="filter-text">许可费用</span>
          </div>
          <div class="filter-right">
            <div class="filter-status off" :class="{ active: filterSelections['licensing-fee'] === 'custom' }">{{ getLicensingFeeStatus() }}</div>
            <div class="expand-arrow">
              <span :class="{ rotated: expandedFilters['licensing-fee'] }">▼</span>
            </div>
          </div>
        </div>
        <div class="filter-content" v-if="expandedFilters['licensing-fee']">
          <div class="filter-question">
            <h4>此许可证的费用是多少？</h4>
          </div>
          <div class="filter-options">
            <div class="fee-input-container">
              <div class="fee-label">许可证价格</div>
              <div class="fee-input-wrapper">
                <input type="number" v-model="licensePrice" class="fee-input" placeholder="0" min="0">
                <span class="fee-currency">知识产权</span>
              </div>
            </div>
            <!-- 仅当同时选择了商业使用和混合创新时才显示收入分成输入框 -->
            <!-- 收入分成始终不可用 -->
            <div class="fee-input-container disabled-section">
              <div class="fee-label disabled-label">收入分成</div>
              <div class="fee-input-wrapper">
                <input type="number" disabled class="fee-input disabled-input" placeholder="不可用" min="0" max="100">
                <span class="fee-currency">%</span>
              </div>
              <div class="disabled-note">不可用</div>
            </div>
            <!-- 删除条件性显示的收入分成输入框 -->
          </div>
          <button class="filter-clear" @click="clearLicenseFee">清除</button>
        </div>
      </div>
      
      <!-- Attribution 选项 -->
      <div class="license-filter-item" :class="{ expanded: expandedFilters['attribution'] }">
        <div class="filter-header" @click="toggleFilter('attribution')">
          <div class="filter-left">
            <span class="filter-icon">
              <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" id="arrow-in-square" width="20" height="20" fill="currentColor" style="vertical-align: middle; position: relative; top: -1px;" viewBox="0 0 5000 5000">
                <path d="M3611.627,812.348H1388.373c-317.619,0-576.025,258.406-576.025,576.025v213.749
                c0,317.619,258.406,576.025,576.025,576.025h668.891c150.451,0,272.854-122.403,272.854-272.854V1287.01
                c0-12.257,7.382-23.32,18.711-28.008c11.339-4.708,24.386-2.092,33.041,6.573l1212.99,1212.99c11.843,11.833,11.843,31.037,0,42.87
                l-1212.99,1212.99c-8.655,8.665-21.702,11.29-33.041,6.573c-11.33-4.688-18.711-15.75-18.711-28.008v-618.283
                c0-150.451-122.403-272.854-272.854-272.854h-668.891c-317.619,0-576.025,258.406-576.025,576.025v213.75
                c0,317.619,258.406,576.025,576.025,576.025h2223.254c317.619,0,576.025-258.406,576.025-576.025V1388.373
                C4187.652,1070.754,3929.246,812.348,3611.627,812.348z"></path>
              </svg>
            </span>
            <span class="filter-text">标明来源</span>
          </div>
          <div class="filter-right">
            <div class="filter-status required" :class="{ active: filterSelections['attribution'] === 'yes' }">{{ getAttributionStatus() }}</div>
            <div class="expand-arrow">
              <span :class="{ rotated: expandedFilters['attribution'] }">▼</span>
            </div>
          </div>
        </div>
        <div class="filter-content" v-if="expandedFilters['attribution']">
          <div class="filter-question">
            <h4 class="question-title">使用此模型时，必须标明来源或作者。</h4>
          </div>
          <div class="filter-options">
            <button 
              :class="['option-btn', 'yes-btn', { selected: filterSelections['attribution'] === 'yes' }]"
              @click="setFilter('attribution', 'yes')"
            >
              是的
            </button>
            <button 
              :class="['option-btn', 'no-btn', { selected: filterSelections['attribution'] === 'no' }]"
              @click="setFilter('attribution', 'no')"
            >
              不
            </button>
          </div>
          <button class="filter-clear" @click="clearFilter('attribution')">清除</button>
        </div>
      </div>
      
      <!-- Remixing 选项 -->
      <div class="license-filter-item" :class="{ expanded: expandedFilters['remixing'] }">
        <div class="filter-header" @click="toggleFilter('remixing')">
          <div class="filter-left">
            <span class="filter-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" id="einstein" width="20" height="20" fill="currentColor" style="vertical-align: middle; position: relative; top: -1px;">
                <path d="M215.993,191.463a8.812,8.812,0,0,1-6.2-2.573,8,8,0,0,1-1.1-1.329,8.7,8.7,0,0,1-1.3-3.158,8.367,8.367,0,0,1-.175-1.71,8.77,8.77,0,0,1,17.539,0,8.366,8.366,0,0,1-.174,1.71,8.748,8.748,0,0,1-1.3,3.158,8.049,8.049,0,0,1-1.1,1.329,7.933,7.933,0,0,1-1.331,1.1,8.606,8.606,0,0,1-3.155,1.3A8.4,8.4,0,0,1,215.993,191.463Z"></path>
                <path d="M452.322,176.34c-5.684-24.929-26.521-41.551-41.11-50.418a33.27,33.27,0,0,1-15.539-24.085,92.774,92.774,0,0,0-12.144-34.659,51.375,51.375,0,0,0-11.759-13.7c-17.6-14.238-39.028-16.212-50.515-16.083a28.127,28.127,0,0,1-14.79-4.189C285.416,20.545,256,22.588,256,22.588S226.584,20.545,205.535,33.2a28.127,28.127,0,0,1-14.79,4.189c-11.487-.129-32.912,1.845-50.515,16.083a51.393,51.393,0,0,0-11.759,13.7,92.774,92.774,0,0,0-12.144,34.659,33.27,33.27,0,0,1-15.539,24.085c-14.589,8.867-35.426,25.489-41.11,50.418a39.251,39.251,0,0,0,3.283,27.4A29.612,29.612,0,0,0,69.353,212a16.554,16.554,0,0,1,5.6,14.236c-1.3,12.151,1.045,31.992,27.852,38.694,0,0,29.51,5.361,47.581-16.225a18.323,18.323,0,0,1,18.437-6.039,54.7,54.7,0,0,0,7.111,1.234,5.843,5.843,0,0,0,6.116-7.729c-5.7-16.318-16.648-55.3-7.339-93.435,6.939-28.432,27.113-52.14,54.787-61.663a80.413,80.413,0,0,1,53,0c27.674,9.523,47.848,33.231,54.787,61.663,9.309,38.139-1.636,77.117-7.339,93.435a5.843,5.843,0,0,0,6.116,7.729,54.7,54.7,0,0,0,7.111-1.234,18.324,18.324,0,0,1,18.437,6.039c18.071,21.586,47.581,16.225,47.581,16.225,26.807-6.7,29.148-26.543,27.852-38.694a16.551,16.551,0,0,1,5.6-14.236,29.631,29.631,0,0,0,6.392-8.26A39.251,39.251,0,0,0,452.322,176.34Z"></path>
                <path d="M296 191.463a8.785 8.785 0 1 1 6.2-2.573A8.813 8.813 0 0 1 296 191.463zM330.217 278.415c-12.1-19.234-30.858-29.7-46.487-35.357a81.387 81.387 0 0 0-55.46 0c-15.629 5.654-34.385 16.123-46.487 35.357a7.934 7.934 0 0 0 8.374 11.961l.2-.04c10.023-1.97 14.231-.727 23.516 2.7 6.964 2.573 18.584 3.8 28.327-10.052A18.962 18.962 0 0 1 249.038 277a14.606 14.606 0 0 1 13.924 0 18.942 18.942 0 0 1 6.836 5.986c9.744 13.851 21.364 12.625 28.328 10.052 9.284-3.43 13.494-4.673 23.516-2.7l.2.04A7.934 7.934 0 0 0 330.217 278.415zM279.224 412.105L262.83 362.179a7.189 7.189 0 0 0-13.66 0l-16.394 49.927a16.808 16.808 0 0 0 1.5 13.8l16.138 27.3a6.49 6.49 0 0 0 11.174 0l16.137-27.3A16.81 16.81 0 0 0 279.224 412.105z"></path>
                <path d="M416.126,480.86c-3.894-23.072-18.695-87.3-67.47-132.927-1.831-1.713-7.552-6.208-7.552-6.208s-3.389,5.8-4.672,8.028l-69.4,120.579a12.6,12.6,0,0,1-4.795,4.726l-.132.074a12.572,12.572,0,0,1-12.234,0l-.133-.074a12.6,12.6,0,0,1-4.794-4.726l-69.4-120.579c-.929-1.613-3.42-6.178-4.326-7.841a.565.565,0,0,0-.868-.159c-1.434,1.233-5.381,4.637-7.03,6.18-48.774,45.626-63.576,109.853-67.47,132.926a7.434,7.434,0,0,0,7.335,8.675h305.6A7.434,7.434,0,0,0,416.126,480.86Z"></path>
              </svg>
            </span>
            <span class="filter-text">混合创新</span>
          </div>
          <div class="filter-right">
            <div class="filter-status allowed" :class="{ active: filterSelections['remixing'] === 'yes' }">{{ getRemixingStatus() }}</div>
            <div class="expand-arrow">
              <span :class="{ rotated: expandedFilters['remixing'] }">▼</span>
            </div>
          </div>
        </div>
        <div class="filter-content" v-if="expandedFilters['remixing']">
          <div class="filter-question">
            <h4 class="question-title">允许对模型进行修改、组合或重新创作。</h4>
          </div>
          <div class="filter-options">
            <button 
              :class="['option-btn', 'yes-btn', { selected: filterSelections['remixing'] === 'yes' }]"
              @click="setFilter('remixing', 'yes')"
            >
              是的
            </button>
            <button 
              :class="['option-btn', 'no-btn', { selected: filterSelections['remixing'] === 'no' }]"
              @click="setFilter('remixing', 'no')"
            >
              不
            </button>
          </div>

          <!-- 添加商业混音上传文件触发器 -->
          <div v-if="filterSelections['remixing'] === 'yes'" class="file-upload-toggle" @click.stop="toggleRemixUpload">
            <div class="toggle-header">
              <span class="toggle-icon remix">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                  <polyline points="17 8 12 3 7 8"></polyline>
                  <line x1="12" y1="3" x2="12" y2="15"></line>
                </svg>
              </span>
              <span class="toggle-text">
                选择商业混音必须上传原文件
                <svg class="warning-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" id="caution">
                  <g>
                    <path fill="#fbd63b" d="M28 28H4L16 6l12 22z"></path>
                    <path fill="#f8be31" d="m16 6 12 22H16V6z"></path>
                    <path fill="#333" d="m16 21-2-7h4l-2 7z"></path>
                    <circle cx="16" cy="25" r="1" fill="#333"></circle>
                    <path d="M16 14h2l-2 7v-7zM16 24a1 1 0 0 1 0 2Z"></path>
                    <path d="M28 29H4a1 1 0 0 1-.878-1.479l12-22a1.04 1.04 0 0 1 1.756 0l12 22A1 1 0 0 1 28 29ZM5.685 27h20.63L16 8.088Z"></path>
                  </g>
                </svg>
              </span>
              <span class="toggle-arrow" :class="{ 'rotated': showRemixUpload }">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" id="down" width="16" height="16">
                  <path d="M511.9 40.9c-24.8 0-49.4 2.2-73.9 5.9-47.6 7.3-93.7 22.4-136.8 43.8-42 20.9-80.9 48.6-114.9 81-33.9 32.3-63.1 70.1-85.9 111-23.2 41.7-40.3 87.2-49.8 134-9.8 48.7-12.4 98.9-6.6 148.3 5.8 49.6 18.9 97.3 39.5 142.8 19.4 42.9 45.7 82.6 77 117.8 31.1 35 67.8 65.4 107.9 89.7 40.6 24.6 85.4 43.2 131.6 54.4 48.1 11.7 98.3 15.9 147.6 12 48.4-3.8 96.2-14.6 141.2-33.1 44.9-18.5 86.2-43.2 123.7-74 36.2-29.8 67.7-65.4 93.5-104.5 26.1-39.6 46.1-83.5 59.1-129.1 13.4-47.4 19.4-97.3 17.5-146.5-1.9-48.7-11.1-97.4-27.9-143.2-16.4-44.5-39-86.4-67.8-124-29.5-38.5-64-72-103.5-100.1-38.6-27.5-81.6-48.8-126.6-63.5-46.6-15.1-95.9-22.7-144.9-22.7zm-3 232.8c16.3.7 30 13.2 30 30v341.6c3.8-3.9 7.6-7.9 11.4-11.9 32.9-34.5 65.9-69 98.9-103.5 7.5-8 15.1-15.9 22.7-23.8 10.8-11.4 31.6-11.8 42.4 0 11.2 12.2 11.6 30.3 0 42.4-20.8 21.8-41.7 43.7-62.6 65.5-32.9 34.5-65.9 69-98.9 103.5-7.6 7.9-15.1 15.9-22.7 23.8-10.9 11.4-31.6 11.7-42.4 0-20.1-21.8-40.3-43.5-60.4-65.3-31.9-34.6-63.8-69.1-95.8-103.7-7.3-7.9-14.7-15.9-22-23.8-10.7-11.5-12.3-31.1 0-42.4 11.6-10.6 31-12.3 42.4 0 20.1 21.7 40.3 43.5 60.4 65.3 22.2 24.1 44.4 48.1 66.6 72.1V354.7c0-16.8-.3-33.6 0-50.3v-.7c0-15.7 13.8-30.7 30-30z"></path>
                </svg>
              </span>
            </div>
          </div>
          
          <!-- 商业混音上传文件组件（隐藏/显示） -->
          <div v-if="filterSelections['remixing'] === 'yes' && showRemixUpload" class="file-upload-section">
            <FileUploadArea
              v-model="remixFile"
              :isRequired="true"
              variant="remix"
              @update:modelValue="handleRemixUpload"
            />
          </div>
          
          <!-- 添加混合创新许可证价格输入框 -->
          <div v-if="filterSelections['remixing'] === 'yes'" class="license-fee-container">
            <div class="fee-input-container">
              <div class="fee-label">许可证价格</div>
              <div class="fee-input-wrapper">
                <input type="number" v-model="remixLicensePrice" class="fee-input" placeholder="0" min="0">
                <span class="fee-currency">知识产权</span>
              </div>
            </div>
            
            <div class="fee-input-container">
              <div class="fee-label">收入分成</div>
              <div class="fee-input-wrapper">
                <input type="number" v-model="remixRevenueShare" class="fee-input" placeholder="0" min="0" max="100">
                <span class="fee-currency">%</span>
              </div>
            </div>
          </div>
          
          <button class="filter-clear" @click="clearFilter('remixing')">清除</button>
        </div>
      </div>
      
      <!-- Expiration 选项 -->
      <div class="license-filter-item" :class="{ expanded: expandedFilters['expiration'] }">
        <div class="filter-header" @click="toggleFilter('expiration')">
          <div class="filter-left">
            <span class="filter-icon">
              <svg xmlns="http://www.w3.org/2000/svg" id="burning-time" width="20" height="20" fill="currentColor" style="vertical-align: middle; position: relative; top: -1px;" viewBox="0 0 128 128">
                <path d="M58.6,63.4L41.2,76.5c-0.2,0.2-0.5,0.5-0.7,0.7c-2,2.3-1.8,5.8,0.5,7.8c2.3,2,5.8,1.8,7.8-0.5l14.1-16.7
                  c1-1.1,1.1-2.8,0.1-4C62,62.5,60,62.3,58.6,63.4z"></path>
                <path d="M109.7,44.3l-1.4,1.4c-1.5,1.5-3.2,2.8-5.1,2.7c-13.2-0.8-0.7-21.9,2.4-27.1c2.5-4.4,5.2-8.6,8.9-12.1
                  c0.7-0.7,1.8-1.2,2.5-1.9c0.1-0.1,0.2-0.2,0.3-0.2c-12-3.6-24.3,2.9-31.5,12.4c-3,4-6.6,7.4-10.5,10.6c-2.2,1.8-4.2,3.8-6.7,5.2
                  c-2,1.1-9.7,4.4-9.3-0.6c0.3-3.1,5.8-5.9,8.1-7.3c2.7-2.1,5.5-4.1,8.2-6.5c1.2-1.2,2.7-2.4,3.8-3.8l0,0C83.5,12.5,85,3.1,84,4.2
                  c-6.3,6-16.4,7.2-24.3,9.9c-4.1,1.4-8.4,3.2-12.5,5.4c0,0-0.1,0-0.1,0.1c-4.7,2.7-9,6-12.6,9.8L14.9,49c-0.2,0.2-0.4,0.3-0.5,0.5
                  c-0.2,0.2-0.4,0.4-0.5,0.5c-1.4,1.5-2.7,3-3.9,4.6c-12.4,17-10.9,41.1,4.4,56.6c8.2,8.2,19.2,12.7,30.8,12.7
                  c9.3,0,18.2-2.9,25.6-8.3c1.8-1.3,3.6-2.8,5.2-4.4l20.1-20.1L96,91c2.2-1.8,4.2-3.9,5.9-6c0.2-0.3,0.5-0.6,0.7-0.8
                  c9.7-12.2,13.7-27.7,20.3-41.6c1.1-2.2,2.2-4.4,3.4-6.6C120,36.8,114.2,39.9,109.7,44.3z M70.4,105.5c-1.6,1.6-3.4,3.1-5.3,4.3
                  c-5.8,4-12.7,6.1-19.9,6.1c-9.5,0-18.5-3.7-25.3-10.4C7.8,93.3,6.3,74.2,15.7,60.4c1.2-1.9,2.7-3.6,4.3-5.3
                  c6.7-6.7,15.7-10.4,25.2-10.4c9.5,0,18.5,3.7,25.2,10.4l0,0C84.3,69,84.3,91.6,70.4,105.5z"></path>
              </svg>
            </span>
            <span class="filter-text">到期时间</span>
          </div>
          <div class="filter-right">
            <div class="filter-status never" :class="{ active: filterSelections['expiration'] !== null }">{{ getExpirationStatus() }}</div>
            <div class="expand-arrow">
              <span :class="{ rotated: expandedFilters['expiration'] }">▼</span>
            </div>
          </div>
        </div>
        <div class="filter-content" v-if="expandedFilters['expiration']">
          <div class="filter-question">
            <h4>此许可证何时到期?</h4>
          </div>
          <div class="filter-options expiration-options">
            <button 
              :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === 'never' }]"
              @click="setFilter('expiration', 'never')"
            >
              从不
            </button>
            <button 
              :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === '1year' }]"
              @click="setFilter('expiration', '1year')"
            >
              1年
            </button>
            <button 
              :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === '6month' }]"
              @click="setFilter('expiration', '6month')"
            >
              6个月
            </button>
            <button 
              :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === 'custom' }]"
              @click="setFilter('expiration', 'custom')"
            >
              选择日期
            </button>
          </div>
          
          <!-- 添加自定义日期选择器 -->
          <div class="custom-date-picker" v-if="filterSelections['expiration'] === 'custom'">
            <input 
              type="date" 
              v-model="customExpirationDate" 
              class="date-input"
              :min="getMinDate()"
              @change="updateCustomExpirationDate"
              @focus="showDatePicker"
              ref="dateInput"
            >
          </div>
          
          <button class="filter-clear" @click="clearFilter('expiration')">清除</button>
        </div>
      </div>

      <!-- 其他过滤器可以添加在这里 -->
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, computed } from 'vue';
import FileUploadArea from './components/FileUploadArea.vue';

interface FilterSelections {
  'ai-training': string | null;
  'commercial-use': string | null;
  'licensing-fee': string | null;
  'attribution': string | null;
  'remixing': string | null;
  'expiration': string | null;
}

interface ExpandedFilters {
  'ai-training': boolean;
  'commercial-use': boolean;
  'licensing-fee': boolean;
  'attribution': boolean;
  'remixing': boolean;
  'expiration': boolean;
}

const props = defineProps({
  selectedLicenses: {
    type: Array as () => string[],
    default: () => []
  },
  expandedFilters: {
    type: Object as () => ExpandedFilters,
    default: () => ({
      'ai-training': false,
      'commercial-use': false,
      'licensing-fee': false,
      'attribution': false,
      'remixing': false,
      'expiration': false
    })
  },
  filterSelections: {
    type: Object as () => FilterSelections,
    default: () => ({
      'ai-training': null,
      'commercial-use': null,
      'licensing-fee': null,
      'attribution': null,
      'remixing': null,
      'expiration': null
    })
  }
});

const emit = defineEmits(['toggle-filter', 'set-filter', 'clear-filter', 'license-option-conflict', 'validate-licensing-fee', 'file-upload', 'validate-file-upload']);

const licensePrice = ref(0);
const revenueShare = ref(0);
const customExpirationDate = ref('');
const dateInput = ref<HTMLInputElement | null>(null);
const commercialFile = ref<File[] | null>(null);
const nonCommercialFile = ref<File[] | null>(null);
const remixFile = ref<File[] | null>(null);
const remixLicensePrice = ref(0);
const remixRevenueShare = ref(0);
const showCommercialUpload = ref(false);
const showNonCommercialUpload = ref(false);
const showRemixUpload = ref(false);

// 添加文件上传状态跟踪
const commercialFileUploaded = ref(false);
const nonCommercialFileUploaded = ref(false);

// 格式化日期函数
const formatDate = (dateString: string): string => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
};

// 根据所选预设许可证设置初始过滤器状态
onMounted(() => {
  initializeFiltersFromPresets();
});

// 初始化过滤器状态
const initializeFiltersFromPresets = () => {
  // 初始化时不设置任何默认值，保持所有选项为空
};

// 检查选项是否与预设许可证冲突 - 现在只显示提示，不阻止选择
const checkPresetConflict = (filterId: string, value: string): boolean => {
  // 移除预设许可证冲突检查，返回false表示没有冲突
  // 这样用户可以自由设置自定义选项
  return false;
};

// 判断是否有冲突的选择 - 始终返回false
const hasConflictSelections = computed(() => {
  return false;
});

// 获取许可证冲突提示信息
const getLicenseConflictWarning = (filterId: string, value: string): string => {
  if (props.selectedLicenses.includes('open')) {
    if (filterId === 'attribution' && value === 'required') {
      return `选择的"${getLicenseName('open')}"许可证与要求归属冲突`;
    }
    if (filterId === 'remixing' && value === 'prohibited') {
      return `选择的"${getLicenseName('open')}"许可证与禁止混音冲突`;
    }
    if (filterId === 'commercial-use' && value === 'prohibited') {
      return `选择的"${getLicenseName('open')}"许可证与禁止商业使用冲突`;
    }
    // 移除AI培训警告
    // if (filterId === 'ai-training' && value === 'prohibited') {
    //   return `选择的"${getLicenseName('open')}"许可证与禁止AI训练冲突`;
    // }
  }
  
  if (props.selectedLicenses.includes('non-commercial')) {
    if (filterId === 'remixing' && value === 'prohibited') {
      return `选择的"${getLicenseName('non-commercial')}"许可证与禁止混音冲突`;
    }
    if (filterId === 'commercial-use' && value === 'allowed') {
      return `选择的"${getLicenseName('non-commercial')}"许可证与允许商业使用冲突`;
    }
    // 移除AI培训警告
    // if (filterId === 'ai-training' && value === 'prohibited') {
    //   return `选择的"${getLicenseName('non-commercial')}"许可证与禁止AI训练冲突`;
    // }
  }
  
  if (props.selectedLicenses.includes('commercial')) {
    if (filterId === 'commercial-use' && value === 'prohibited') {
      return `选择的"${getLicenseName('commercial')}"许可证与禁止商业使用冲突`;
    }
    // 移除AI培训警告
    // if (filterId === 'ai-training' && value === 'prohibited') {
    //   return `选择的"${getLicenseName('commercial')}"许可证与禁止AI训练冲突`;
    // }
    if (!props.selectedLicenses.includes('commercial-remix') && filterId === 'remixing' && value === 'allowed') {
      return `选择的"${getLicenseName('commercial')}"许可证与允许混音冲突`;
    }
  }
  
  if (props.selectedLicenses.includes('commercial-remix')) {
    if (filterId === 'remixing' && value === 'prohibited') {
      return `选择的"${getLicenseName('commercial-remix')}"许可证与禁止混音冲突`;
    }
    if (filterId === 'commercial-use' && value === 'prohibited') {
      return `选择的"${getLicenseName('commercial-remix')}"许可证与禁止商业使用冲突`;
    }
    // 移除AI培训警告
    // if (filterId === 'ai-training' && value === 'prohibited') {
    //   return `选择的"${getLicenseName('commercial-remix')}"许可证与禁止AI训练冲突`;
    // }
  }
  
  return '';
};

// 修改 setFilter 方法，确保在选择商业使用时自动展开许可费用选项
const setFilter = (filterId: string, value: string) => {
  emit('set-filter', filterId, value);
  
  // 如果选择了商业使用为"是"，自动展开许可费用选项
  if (filterId === 'commercial-use' && value === 'yes') {
    // 自动展开许可费用选项
    emit('toggle-filter', 'licensing-fee');
    
    // 添加必填样式提示用户
    setTimeout(() => {
      const feeSection = document.querySelector('.license-filter-item[data-filter="licensing-fee"]');
      if (feeSection) {
        feeSection.classList.add('required-field');
      }
    }, 100);
    
    // 通知父组件许可费用验证未通过
    emit('validate-licensing-fee', 'false');
  }
};

const toggleFilter = (filterId: string) => {
  emit('toggle-filter', filterId);
};

const clearFilter = (filterId: string) => {
  emit('clear-filter', filterId);
  
  if (filterId === 'commercial-use') {
    showCommercialUpload.value = false;
    showNonCommercialUpload.value = false;
    
    // 如果清除的是商业使用选项，也移除许可费用的必填提示
    const feeSection = document.querySelector('.license-filter-item[data-filter="licensing-fee"]');
    if (feeSection) {
      feeSection.classList.remove('required-field');
    }
    emit('validate-licensing-fee', 'true');
  }
};

const clearLicenseFee = () => {
  licensePrice.value = 0;
  revenueShare.value = 0; // 收入分成始终为0
  emit('clear-filter', 'licensing-fee');
  
  // 通知父组件价格和分成更新，收入分成始终为0
  emit('validate-licensing-fee', {
    type: 'commercial',
    price: 0,
    revenueShare: 0 // 始终保持为0
  });
  
  // 如果当前选择了商业使用为"是"，保持必填提示
  if (props.filterSelections['commercial-use'] === 'yes') {
    const feeSection = document.querySelector('.license-filter-item[data-filter="licensing-fee"]');
    if (feeSection) {
      feeSection.classList.add('required-field');
    }
    emit('validate-licensing-fee', 'false');
  }
};

// 获取许可证名称
const getLicenseName = (licenseId: string) => {
  const licenseNames: Record<string, string> = {
    'commercial': '商业使用',
    'commercial-remix': '商业混音',
    'non-commercial': '非商业混音',
    'open': '开放使用'
  };
  return licenseNames[licenseId] || licenseId;
};

// 获取许可费用状态文本
const getLicensingFeeStatus = () => {
  if (props.filterSelections['licensing-fee'] === 'custom') {
    let status = '';
    if (licensePrice.value > 0) {
      status += `${licensePrice.value}知识产权`;
    }
    if (revenueShare.value > 0) {
      if (status) status += ' + ';
      status += `${revenueShare.value}%分成`;
    }
    return status || '自定义';
  } else {
    return '请选择';
  }
};

// 获取标明来源状态文本
const getAttributionStatus = () => {
  if (props.filterSelections['attribution'] === 'required') {
    return '必须';
  } else if (props.filterSelections['attribution'] === 'not-required') {
    return '不需要';
  } else {
    return '请选择';
  }
};

// 获取混音状态文本
const getRemixingStatus = () => {
  if (props.filterSelections['remixing'] === 'yes') {
    return "允许";
  } else if (props.filterSelections['remixing'] === 'no') {
    return "不允许";
  }
  return "请选择";
};

// 获取到期时间状态文本
const getExpirationStatus = () => {
  if (props.filterSelections['expiration'] === 'never') {
    return '永久';
  } else if (props.filterSelections['expiration'] === '1year') {
    return '1年';
  } else if (props.filterSelections['expiration'] === '6month') {
    return '6个月';
  } else if (props.filterSelections['expiration'] === 'custom' && customExpirationDate.value) {
    return formatDate(customExpirationDate.value);
  } else {
    return '请选择';
  }
};

// 获取AI培训状态文本
const getAITrainingStatus = () => {
  if (props.filterSelections['ai-training'] === 'yes') {
    return "允许";
  } else if (props.filterSelections['ai-training'] === 'no') {
    return "不允许";
  }
  return "请选择";
};

// 获取商用状态文本
const getCommercialUseStatus = () => {
  if (props.filterSelections['commercial-use'] === 'yes') {
    return "允许";
  } else if (props.filterSelections['commercial-use'] === 'no') {
    return "不允许";
  }
  return "请选择";
};

// 观察商业使用和许可费用的变化
watch([() => props.filterSelections['commercial-use'], () => props.filterSelections['remixing'], licensePrice], ([commercialUse, remixingValue, price]) => {
  // 只有当选择了商业使用为'yes'时才验证许可费用
  if (commercialUse === 'yes') {
    // 检查许可费用的有效性：只需检查价格，收入分成始终为0且不可用
    const isValid = Number(price) > 0;
    
    // 添加或移除必填样式
    const feeSection = document.querySelector('.license-filter-item[data-filter="licensing-fee"]');
    if (feeSection) {
      if (!isValid) {
        feeSection.classList.add('required-field');
      } else {
        feeSection.classList.remove('required-field');
      }
    }
    
    // 通知父组件验证状态
    emit('validate-licensing-fee', isValid ? 'true' : 'false');
    
    // 如果有效，将自定义设置添加到许可费用
    if (isValid) {
      emit('set-filter', 'licensing-fee', 'custom');
      // 确保收入分成始终为0
      emit('validate-licensing-fee', {
        type: 'commercial',
        price: licensePrice.value,
        revenueShare: 0 // 始终保持为0
      });
    }
  } else {
    // 没有选择商业使用时，移除必填样式，并且默认通过验证
    const feeSection = document.querySelector('.license-filter-item[data-filter="licensing-fee"]');
    if (feeSection) {
      feeSection.classList.remove('required-field');
    }
    emit('validate-licensing-fee', 'true');
    
    // 如果存在许可费用设置，清除它
    if (props.filterSelections['licensing-fee'] !== null) {
      emit('clear-filter', 'licensing-fee');
    }
  }
}, { immediate: true });

// 计算自定义许可证详情
const computeCustomLicense = () => {
  const customDetails = [];
  
  // AI Training
  if (props.filterSelections['ai-training'] === 'yes') {
    customDetails.push('允许AI培训');
  } else if (props.filterSelections['ai-training'] === 'no') {
    customDetails.push('不允许AI培训');
  }
  
  // Commercial Use
  if (props.filterSelections['commercial-use'] === 'yes') {
    customDetails.push('允许商用');
  } else if (props.filterSelections['commercial-use'] === 'no') {
    customDetails.push('不允许商用');
  }
  
  // Licensing Fee
  if (props.filterSelections['licensing-fee'] === 'free') {
    customDetails.push('免费使用');
  } else if (props.filterSelections['licensing-fee'] === 'one-time') {
    customDetails.push(`一次性付费: ${licensePrice.value}元`);
  } else if (props.filterSelections['licensing-fee'] === 'revenue-share') {
    customDetails.push(`收益分成: ${revenueShare.value}%`);
  }
  
  // Attribution
  if (props.filterSelections['attribution'] === 'required') {
    customDetails.push('必须署名');
  } else if (props.filterSelections['attribution'] === 'not-required') {
    customDetails.push('无需署名');
  }
  
  // Remixing
  if (props.filterSelections['remixing'] === 'allowed') {
    customDetails.push('允许二创');
  } else if (props.filterSelections['remixing'] === 'not-allowed') {
    customDetails.push('禁止二创');
  }
  
  // Expiration
  if (props.filterSelections['expiration'] === 'never') {
    customDetails.push('永久有效');
  } else if (props.filterSelections['expiration'] === '1-year') {
    customDetails.push('有效期1年');
  } else if (props.filterSelections['expiration'] === '2-years') {
    customDetails.push('有效期2年');
  } else if (props.filterSelections['expiration'] === '5-years') {
    customDetails.push('有效期5年');
  }
  
  return customDetails.join('，');
};

// 获取最小可选日期（今天）
const getMinDate = () => {
  const today = new Date();
  return `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
};

// 更新自定义到期日期
const updateCustomExpirationDate = () => {
  if (customExpirationDate.value) {
    emit('set-filter', 'expiration', 'custom');
  }
};

// 新增 showDatePicker 函数，用于直接弹出日期选择器
const showDatePicker = () => {
  // 使用DOM API 模拟点击日历图标
  if (dateInput.value) {
    const event = new MouseEvent('mousedown', {
      bubbles: true,
      cancelable: true,
      view: window
    });
    // 触发日期选择器打开
    dateInput.value.showPicker();
  }
};

// 修改handleFileUpload方法
const handleFileUpload = (type: 'commercial' | 'nonCommercial' | 'remix', files: File[] | null) => {
  if (type === 'commercial') {
    commercialFile.value = files;
    // 更新上传状态标志
    commercialFileUploaded.value = files !== null && files.length > 0;
  } else if (type === 'nonCommercial') {
    nonCommercialFile.value = files;
    // 更新上传状态标志
    nonCommercialFileUploaded.value = files !== null && files.length > 0;
  } else if (type === 'remix') {
    remixFile.value = files;
  }
  
  // 保存文件到全局存储
  if (typeof window !== 'undefined') {
    // @ts-ignore
    window._customLicenseFiles = window._customLicenseFiles || {};
    // @ts-ignore
    window._customLicenseFiles[type] = files;
  }
  
  // 触发文件上传事件，传递给父组件
  if (files && files.length > 0) {
    emit('file-upload', {
      isCommercial: type === 'commercial' || type === 'remix',
      files: files
    });
  }
};

// 更新处理函数
const handleCommercialUpload = (files: File[] | null) => {
  handleFileUpload('commercial', files);
};

const handleNonCommercialUpload = (files: File[] | null) => {
  handleFileUpload('nonCommercial', files);
};

const handleRemixUpload = (files: File[] | null) => {
  handleFileUpload('remix', files);
};

// 切换商业使用上传文件的显示状态
const toggleCommercialUpload = (event: Event) => {
  event.stopPropagation();
  showCommercialUpload.value = !showCommercialUpload.value;
};

// 切换非商业使用上传文件的显示状态
const toggleNonCommercialUpload = (event: Event) => {
  event.stopPropagation();
  showNonCommercialUpload.value = !showNonCommercialUpload.value;
};

// 切换商业混音上传文件的显示状态
const toggleRemixUpload = (event: Event) => {
  event.stopPropagation();
  showRemixUpload.value = !showRemixUpload.value;
};

// 直接打开文件选择器
const triggerFileInput = (isCommercial: boolean) => {
  const fileInput = document.createElement('input');
  fileInput.type = 'file';
  fileInput.accept = '*/*';
  fileInput.style.display = 'none';
  
  fileInput.onchange = (event) => {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const selectedFiles = Array.from(input.files);
      const type = isCommercial ? 'commercial' : 'nonCommercial';
      handleFileUpload(type as 'commercial' | 'nonCommercial', selectedFiles);
    }
  };
  
  document.body.appendChild(fileInput);
  fileInput.click();
  document.body.removeChild(fileInput);
};

// 观察商业使用选择变化
watch(() => props.filterSelections['commercial-use'], (newValue) => {
  // 如果选择了商业使用为yes，但还没有上传文件
  if (newValue === 'yes' && !commercialFileUploaded.value) {
    // 自动展开上传文件区域
    showCommercialUpload.value = true;
    // 通知父组件文件尚未上传
    emit('validate-file-upload', false);
  } else if (newValue === 'no') {
    // 如果选择了非商业使用，重置商业上传区域
    showCommercialUpload.value = false;
    // 文件上传状态检查移交给父组件
    emit('validate-file-upload', true);
  }
}, { immediate: true });

// 观察混合创新选择变化
watch(() => props.filterSelections['remixing'], (newValue) => {
  // 如果选择了混合创新为yes
  if (newValue === 'yes') {
    // 自动展开上传文件区域
    showRemixUpload.value = true;
  } else {
    // 如果取消了混合创新，重置相关值
    showRemixUpload.value = false;
    remixLicensePrice.value = 0;
    remixRevenueShare.value = 0;
    
    // 通知父组件价格和分成更新
    emit('validate-licensing-fee', {
      type: 'remix',
      price: 0,
      revenueShare: 0
    });
  }
}, { immediate: true });

// 观察混合创新价格和收入分成变化
watch([remixLicensePrice, remixRevenueShare], () => {
  if (props.filterSelections['remixing'] === 'yes') {
    // 通知父组件价格和分成更新，使用实际的收入分成值
    emit('validate-licensing-fee', {
      type: 'remix',
      price: remixLicensePrice.value,
      revenueShare: remixRevenueShare.value
    });
  }
});

// 对外公开必填验证方法
defineExpose({
  isCommercialFileUploaded: commercialFileUploaded,
  isNonCommercialFileUploaded: nonCommercialFileUploaded
});
</script>

<style scoped>
.custom-license {
  width: 100%;
  max-width: 800px;
}

/* 已选择预设许可证样式 */
.selected-preset-licenses {
  background: rgba(30, 30, 35, 0.5);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
}

.selected-preset-licenses h3 {
  font-size: 16px;
  margin-bottom: 12px;
  color: rgba(255, 255, 255, 0.9);
}

.preset-licenses-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 12px;
}

.preset-license-tag {
  background: rgba(80, 80, 160, 0.3);
  padding: 8px 16px;
  border-radius: 30px;
  font-size: 14px;
  border: 1px solid rgba(120, 120, 200, 0.3);
}

.license-hint {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
  font-style: italic;
  margin-top: 8px;
}

.license-filter-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
  width: 100%;
}

.license-filter-item {
  background: rgba(30, 30, 35, 0.6);
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s;
}

.license-filter-item.expanded {
  background: rgba(40, 40, 45, 0.8);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.filter-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  cursor: pointer;
}

.filter-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-icon {
  font-size: 24px;
}

.filter-text {
  font-size: 16px;
  font-weight: 500;
  color: white;
}

.filter-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.filter-status {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
  padding: 4px 12px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.1);
  transition: all 0.3s;
}

.filter-status.active {
  color: white;
  background: rgba(80, 80, 160, 0.4);
}

.filter-status.required.active {
  background: rgba(0, 150, 136, 0.3);
}

.filter-status.allowed.active {
  background: rgba(76, 175, 80, 0.3);
}

.filter-status.off.active {
  background: rgba(233, 30, 99, 0.3);
}

.filter-status.never.active {
  background: rgba(255, 193, 7, 0.3);
}

.expand-arrow {
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.expand-arrow span {
  font-size: 10px;
  transition: transform 0.3s;
}

.expand-arrow span.rotated {
  transform: rotate(180deg);
}

.filter-content {
  padding: 0 20px 20px 20px;
  animation: slideDown 0.3s forwards;
}

.filter-question {
  margin-bottom: 15px;
}

.filter-question h4 {
  font-weight: 400;
  font-size: 15px;
  color: rgba(255, 255, 255, 0.8);
}

.filter-options {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.file-requirement-notice {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 4px;
  font-size: 13px;
  margin-bottom: 15px;
  background-color: rgba(0, 0, 0, 0.2);
  color: rgba(255, 255, 255, 0.9);
}

.file-requirement-notice.required {
  /* 删除边框样式 */
}

.file-requirement-notice.optional {
  /* 删除边框样式 */
}

.option-btn {
  background: rgba(255, 255, 255, 0.1);
  border: none;
  padding: 8px 16px;
  border-radius: 20px;
  color: white;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
}

.option-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

.option-btn.selected {
  background: rgba(80, 80, 160, 0.6);
}

.option-btn.yes-btn.selected {
  background: rgba(76, 175, 80, 0.5);
}

.option-btn.no-btn.selected {
  background: rgba(233, 30, 99, 0.5);
}

.filter-clear {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 0;
  font-size: 13px;
  text-decoration: underline;
}

.filter-clear:hover {
  color: white;
}

/* 费用输入样式 */
.fee-input-container {
  flex: 1;
}

.fee-label {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 5px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  padding: 0 12px;
  height: 40px;
}

.fee-input {
  flex: 1;
  background: transparent;
  border: none;
  color: white;
  font-size: 15px;
}

.fee-input:focus {
  outline: none;
}

.fee-currency {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.7);
}

/* 日期选择样式 */
.expiration-options {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.expiration-btn {
  flex: 1 0 calc(50% - 5px);
  min-width: 80px;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 600px) {
  .filter-options {
    flex-direction: column;
  }
  
  .expiration-btn {
    flex: 1 0 100%;
  }
}

.license-conflict-warning {
  font-size: 14px;
  color: #ff6b6b;
  font-weight: 500;
  margin-top: 10px;
  padding: 8px 12px;
  background: rgba(255, 0, 0, 0.1);
  border-radius: 6px;
  border-left: 3px solid #ff6b6b;
}

.custom-date-picker {
  margin-top: 15px;
  margin-bottom: 15px;
}

.date-input {
  width: 100%;
  background: rgba(255, 255, 255, 0.1);
  border: none;
  border-radius: 8px;
  color: white;
  padding: 10px 15px;
  font-size: 14px;
}

.date-input:focus {
  outline: none;
  background: rgba(255, 255, 255, 0.15);
}

/* 日期选择器弹出层样式 */
:deep(.date-input::-webkit-calendar-picker-indicator) {
  filter: invert(1);
  opacity: 0.6;
  cursor: pointer;
}

:deep(input[type="date"]) {
  position: relative;
  color-scheme: dark;
}

/* 指示必填项的CSS样式 */
.license-filter-item.required-field {
  border: 2px solid rgba(255, 87, 87, 0.7);
  position: relative;
  box-shadow: 0 0 5px rgba(255, 87, 87, 0.3);
}

.license-filter-item.required-field .filter-header {
  color: rgba(255, 87, 87, 1);
}

/* 文件上传区域样式 */
.file-upload-section {
  margin: 15px 0;
  overflow-x: auto;
  max-width: 100%;
  scrollbar-width: thin;
  scrollbar-color: rgba(255, 255, 255, 0.3) rgba(0, 0, 0, 0.1);
}

.file-upload-section::-webkit-scrollbar {
  height: 6px;
}

.file-upload-section::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 3px;
}

.file-upload-section::-webkit-scrollbar-thumb {
  background-color: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
}

/* 为过多文件添加水平滚动指示器 */
.file-upload-section::after {
  content: '';
  display: block;
  position: absolute;
  right: 0;
  top: 0;
  height: 100%;
  width: 30px;
  background: linear-gradient(to right, transparent, rgba(30, 30, 35, 0.7));
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s;
}

.file-upload-section.has-overflow::after {
  opacity: 1;
}

/* 商业使用上传文件触发器样式 */
.file-upload-toggle {
  cursor: pointer;
  margin-top: 10px;
  padding: 10px;
  border: 1px dashed rgba(255, 255, 255, 0.3);
  border-radius: 6px;
  transition: all 0.3s;
}

.file-upload-toggle:hover {
  border-color: rgba(255, 255, 255, 0.5);
}

.toggle-header {
  display: flex;
  align-items: center;
  gap: 10px;
}

.toggle-icon {
  display: flex;
  align-items: center;
}

.toggle-icon.commercial {
  color: #2ecc71;
}

.toggle-icon.non-commercial {
  color: #d479e8;
}

.toggle-icon.remix {
  color: #e74c3c;
}

.toggle-text {
  flex: 1;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  display: flex;
  align-items: center;
  gap: 6px;
}

.warning-icon {
  width: 20px;
  height: 20px;
  transform: translateY(-2px);
}

.toggle-arrow {
  transition: transform 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.toggle-arrow svg {
  fill: currentColor;
  width: 16px;
  height: 16px;
}

.toggle-arrow.rotated {
  transform: rotate(180deg);
}

/* 商业和非商业使用的箭头颜色 */
.toggle-icon.commercial ~ .toggle-arrow {
  color: #2ecc71;
}

.toggle-icon.non-commercial ~ .toggle-arrow {
  color: #d479e8;
}

.toggle-icon.remix ~ .toggle-arrow {
  color: #e74c3c;
}

/* 混合创新许可证价格和收入分成样式 */
.license-fee-container {
  margin-top: 20px;
  padding: 15px;
  background: rgba(25, 25, 30, 0.6);
  border: 1px solid rgba(255, 152, 0, 0.3);
  border-radius: 10px;
}

.fee-input-container {
  margin-bottom: 15px;
}

.fee-input-container:last-child {
  margin-bottom: 0;
}

.fee-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.85);
  margin-bottom: 8px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background: rgba(30, 30, 35, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 8px;
  padding: 8px 12px;
}

.fee-input {
  flex: 1;
  background: transparent;
  border: none;
  color: white;
  font-size: 15px;
  outline: none;
}

.fee-input::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

.fee-currency {
  margin-left: 8px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.disabled-section {
  opacity: 0.6;
  pointer-events: none;
}

.disabled-label {
  color: rgba(255, 255, 255, 0.5);
}

.disabled-input {
  cursor: not-allowed;
  color: rgba(255, 255, 255, 0.5);
}

.disabled-note {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-top: 5px;
  font-style: italic;
}

.attribution-button:hover {
  color: #e74c3c;
}
</style> 