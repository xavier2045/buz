<template>
  <div class="app-container">
    <div class="blur-container">
      <!-- 启动页面 -->
      <div class="start-page" v-if="currentPage === 'start'">
        <div class="header">
          <h1>AETRIX开启您的IP发布</h1>
          <p class="subtitle-zh">选择您要进行的操作</p>
        </div>
        
        <div class="menu-options">
          <div class="menu-card" data-text="发布作品" @click="goToWorkType()">
            <div class="menu-icon product-icon"></div>
          </div>
          
          <div class="menu-card" data-text="发布任务" @click="showUnavailable('task')">
            <div class="menu-icon task-icon"></div>
          </div>
          
          <div class="menu-card" data-text="发布活动" @click="showUnavailable('activity')">
            <div class="menu-icon people-icon"></div>
          </div>
        </div>
      </div>

      <!-- 作品类型选择页面 -->
      <div class="work-type-container" v-if="currentPage === 'workType'">
        <!-- 标题部分 -->
        <div class="header">
          <h1 class="title-with-subtitle">选择作品类型（注册类型）</h1>
          <p class="subtitle-zh">请选择您要发布的作品类型</p>
        </div>

        <!-- 作品类型选项 -->
        <div class="work-type-options">
          <!-- 新IP选项 -->
          <div 
            class="work-type-card" 
            :class="{ selected: selectedWorkType === 'newIP' }"
            @click="selectWorkType('newIP')"
          >
            <div class="work-type-content">
              <div class="work-type-icon new-icon">
                <span class="icon-symbol">✦</span>
              </div>
              <h2>新IP <span class="type-label">新作品</span></h2>
              <p class="work-description">注册原创图片、视频或文字作品</p>
            </div>
          </div>

          <!-- 混音选项 -->
          <div 
            class="work-type-card"
            :class="{ selected: selectedWorkType === 'remix' }"
            @click="selectWorkType('remix')"
          >
            <div class="work-type-content">
              <div class="work-type-icon remix-icon">
                <span class="icon-symbol">↺</span>
              </div>
              <h2>混音 <span class="type-label">衍生作品</span></h2>
              <p class="work-description">注册与现有作品相关的衍生作品</p>
            </div>
          </div>
        </div>

        <!-- 提示信息区域 -->
        <div class="info-panel">
          <div class="info-icon">
            <span class="coin-emoji">🪙</span>
          </div>
          <div class="info-text">
            <h3>获取AETRIX币</h3>
            <p>您需要一定数量的AETRIX币用于支付gas和交易费用</p>
          </div>
          <div class="info-arrow">
            <span>→</span>
          </div>
        </div>

        <!-- 底部导航按钮 -->
        <div class="navigation">
          <button class="back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="next-btn" @click="goNext" :disabled="!selectedWorkType">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 许可证页面 -->
      <div class="license-container" v-if="currentPage === 'license'">
        <!-- 标题部分 -->
        <div class="header">
          <h1>添加许可证</h1>
          <p class="subtitle-zh">您最多可向此资产添加5个许可证</p>
        </div>

        <!-- 标签页切换 -->
        <div class="tabs">
          <div 
            v-for="(tab, index) in tabs" 
            :key="tab.id"
            :class="['tab', { active: activeTabIndex === index }]"
            @click="setActiveTab(index)"
          >
            {{ tab.label }}
          </div>
        </div>

        <!-- 许可证选项 -->
        <div v-if="activeTabIndex === 0" class="license-options">
          <!-- 显示已选择的许可证 -->
          <div class="selected-licenses-header">
            <h3>已选择的许可证: <span class="license-count">{{ selectedLicenses.length }}/5</span></h3>
            <div class="selected-licenses-list">
              <div v-if="selectedLicenses.length === 0" class="no-licenses">尚未选择许可证</div>
              <div v-else class="selected-license-tags">
                <span v-for="license in selectedLicenses" :key="license" class="selected-license-tag">
                  {{ license === 'open' ? '开放使用' : license === 'non-commercial' ? '非商业混音' : 
                     license === 'commercial' ? '商业使用' : '商业混音' }}
                  <span class="remove-tag" @click.stop="removeLicense(license)">×</span>
                </span>
              </div>
            </div>
          </div>

          <!-- 开放使用许可 -->
          <div 
            class="license-card" 
            :class="{ selected: selectedLicenses.includes('open') }"
            @click="selectLicense('open')"
          >
            <div class="license-header">
              <span class="license-tag blue">
                <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" id="ai" width="20" height="20" enable-background="new 0 0 48 48" version="1.1" viewBox="0 0 48 48" class="license-icon">
                  <g>
                    <path d="M26.2,32.5l-1.5-3.4h-6.6l-1.5,3.4h-3.7l6.8-15.7h3.4l6.8,15.7H26.2z M34.8,32.5h-3.4V20.4h3.4V32.5z M34.5,18.9c-0.4,0.4-0.9,0.6-1.4,0.6c-0.6,0-1-0.2-1.4-0.6c-0.4-0.4-0.6-0.9-0.6-1.4c0-0.6,0.2-1,0.6-1.4c0.4-0.4,0.9-0.6,1.4-0.6c0.6,0,1,0.2,1.4,0.6c0.4,0.4,0.6,0.9,0.6,1.4C35.1,18,34.9,18.5,34.5,18.9z"></path>
                    <polygon points="19.5 26 23.4 26 21.4 21.5"></polygon>
                  </g>
                </svg>
                限制最少
              </span>
            </div>
            <h2>开放使用</h2>
            <div class="license-content">
              <p class="license-description-zh">免费分发和混音，无限制、无收入要求、无归属要求</p>
            </div>
            <div class="license-footer license-footer-open">
              <div class="license-icons license-icons-open">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicenses.includes('open')">✓</div>
            </div>
          </div>

          <!-- 非商业Remix -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicenses.includes('non-commercial') }"
            @click="selectLicense('non-commercial')"
          >
            <div class="license-header">
              <span class="license-tag purple"><i class="license-icon">🏆</i> 为您的作品获得认可</span>
            </div>
            <h2>非商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">任何人都可使用您的作品创建非商业项目</p>
            </div>
            <div class="license-footer license-footer-noncommercial">
              <div class="license-icons license-icons-noncommercial">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicenses.includes('non-commercial')">✓</div>
            </div>
          </div>

          <!-- 商业使用 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicenses.includes('commercial') }"
            @click="selectLicense('commercial')"
          >
            <div class="license-header">
              <span class="license-tag green"><i class="license-icon">💲</i> 为您的作品获得报酬</span>
            </div>
            <h2>商业使用</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人按照您设定的经济条款使用您的作品</p>
            </div>
            <div class="license-footer license-footer-commercial">
              <div class="license-icons license-icons-commercial">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="限制混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicenses.includes('commercial')">✓</div>
            </div>
          </div>

          <!-- 商业混音 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicenses.includes('commercial-remix') }"
            @click="selectLicense('commercial-remix')"
          >
            <div class="license-header">
              <span class="license-tag red"><i class="license-icon">💰</i> 获得报酬与认可</span>
            </div>
            <h2>商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人混音您的作品，同时您获得认可和收益</p>
            </div>
            <div class="license-footer license-footer-commercial-remix">
              <div class="license-icons license-icons-commercial-remix">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicenses.includes('commercial-remix')">✓</div>
            </div>
          </div>
        </div>

        <!-- 自定义许可证标签页内容 -->
        <div v-else-if="activeTabIndex === 1" class="custom-license">
          <div class="license-filter-list">
            <!-- Licensing Fee 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['licensing-fee'] }">
              <div class="filter-header" @click="toggleFilter('licensing-fee')">
                <div class="filter-left">
                  <span class="filter-icon">💰</span>
                  <span class="filter-text">许可费用</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status off" :class="{ active: filterSelections['licensing-fee'] === 'custom' }">0%折扣</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['licensing-fee'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['licensing-fee']">
                <div class="filter-question">
                  <h4>此许可证的费用是多少？</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <div class="fee-input-container">
                    <div class="fee-label">许可证价格</div>
                    <div class="fee-input-wrapper">
                      <input type="number" class="fee-input" placeholder="0" min="0">
                      <span class="fee-currency">知识产权</span>
                    </div>
                  </div>
                  <div class="fee-input-container">
                    <div class="fee-label">收入分成</div>
                    <div class="fee-input-wrapper">
                      <input type="number" class="fee-input" placeholder="0" min="0" max="100">
                      <span class="fee-currency">%</span>
                    </div>
                  </div>
                </div>
                <button class="filter-clear">清除</button>
              </div>
            </div>
            
            <!-- Attribution 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['attribution'] }">
              <div class="filter-header" @click="toggleFilter('attribution')">
                <div class="filter-left">
                  <span class="filter-icon">📝</span>
                  <span class="filter-text">标明来源</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status required" :class="{ active: filterSelections['attribution'] === 'yes' }">必填</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['attribution'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['attribution']">
                <div class="filter-question">
                  <h4 class="question-title">使用此模型时，必须标明来源或作者。</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <button 
                    :class="['option-btn', 'yes-btn', { selected: filterSelections['attribution'] === 'yes' }]"
                    @click="setFilterOption('attribution', 'yes')"
                  >
                    是的
                  </button>
                  <button 
                    :class="['option-btn', 'no-btn', { selected: filterSelections['attribution'] === 'no' }]"
                    @click="setFilterOption('attribution', 'no')"
                  >
                    不
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('attribution')">清除</button>
              </div>
            </div>
            
            <!-- Remixing 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['remixing'] }">
              <div class="filter-header" @click="toggleFilter('remixing')">
                <div class="filter-left">
                  <span class="filter-icon">🔄</span>
                  <span class="filter-text">混合创新</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status allowed" :class="{ active: filterSelections['remixing'] === 'yes' }">允许</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['remixing'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['remixing']">
                <div class="filter-question">
                  <h4 class="question-title">允许对模型进行修改、组合或重新创作。</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <button 
                    :class="['option-btn', 'yes-btn', { selected: filterSelections['remixing'] === 'yes' }]"
                    @click="setFilterOption('remixing', 'yes')"
                  >
                    是的
                  </button>
                  <button 
                    :class="['option-btn', 'no-btn', { selected: filterSelections['remixing'] === 'no' }]"
                    @click="setFilterOption('remixing', 'no')"
                  >
                    不
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('remixing')">清除</button>
              </div>
            </div>
            
            <!-- Expiration 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['expiration'] }">
              <div class="filter-header" @click="toggleFilter('expiration')">
                <div class="filter-left">
                  <span class="filter-icon">⏱️</span>
                  <span class="filter-text">到期时间</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status never" :class="{ active: filterSelections['expiration'] !== null }">从不</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['expiration'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['expiration']">
                <div class="filter-question">
                  <h4>此许可证何时到期?</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options expiration-options">
                  <button 
                    :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === 'never' }]"
                    @click="setFilterOption('expiration', 'never')"
                  >
                    从不
                  </button>
                  <button 
                    :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === '1year' }]"
                    @click="setFilterOption('expiration', '1year')"
                  >
                    1年
                  </button>
                  <button 
                    :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === '6month' }]"
                    @click="setFilterOption('expiration', '6month')"
                  >
                    6个月
                  </button>
                  <button 
                    :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === 'custom' }]"
                    @click="setFilterOption('expiration', 'custom')"
                  >
                    选择日期
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('expiration')">清除</button>
              </div>
            </div>
            
            <!-- Commercial Use 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['commercial-use'] }">
              <div class="filter-header" @click="toggleFilter('commercial-use')">
                <div class="filter-left">
                  <span class="filter-icon">💼</span>
                  <span class="filter-text">商业使用</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status allowed" :class="{ active: filterSelections['commercial-use'] === 'yes' }">允许</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['commercial-use'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['commercial-use']">
                <div class="filter-question">
                  <h4 class="question-title">允许将此作品应用于商业目的。</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <button 
                    :class="['option-btn', 'yes-btn', { selected: filterSelections['commercial-use'] === 'yes' }]"
                    @click="setFilterOption('commercial-use', 'yes')"
                  >
                    是的
                  </button>
                  <button 
                    :class="['option-btn', 'no-btn', { selected: filterSelections['commercial-use'] === 'no' }]"
                    @click="setFilterOption('commercial-use', 'no')"
                  >
                    不
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('commercial-use')">清除</button>
              </div>
            </div>
            
            <!-- AI Training 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['ai-training'] }">
              <div class="filter-header" @click="toggleFilter('ai-training')">
                <div class="filter-left">
                  <span class="filter-icon">🤖</span>
                  <span class="filter-text">AI训练</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status allowed" :class="{ active: filterSelections['ai-training'] === 'yes' }">允许</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['ai-training'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['ai-training']">
                <div class="filter-question">
                  <h4 class="question-title">允许将此产品用于AI训练。</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <button 
                    :class="['option-btn', 'yes-btn', { selected: filterSelections['ai-training'] === 'yes' }]"
                    @click="setFilterOption('ai-training', 'yes')"
                  >
                    是的
                  </button>
                  <button 
                    :class="['option-btn', 'no-btn', { selected: filterSelections['ai-training'] === 'no' }]"
                    @click="setFilterOption('ai-training', 'no')"
                  >
                    不
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('ai-training')">清除</button>
              </div>
            </div>
          </div>
          
          <div class="clear-btn-container">
            <button class="clear-all-btn" @click="clearAllFilters">全部清除</button>
          </div>
        </div>

        <!-- 许可证助手标签页内容 -->
        <div v-else-if="activeTabIndex === 2" class="license-assistant">
          <div class="placeholder-content">
            <h2>许可证助手</h2>
            <p>回答几个问题，我们将帮助您选择最合适的许可证</p>
          </div>
        </div>

        <!-- 底部导航按钮 -->
        <div class="navigation">
          <button class="back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="next-btn" @click="submitAsset" :disabled="selectedLicenses.length === 0 && activeTabIndex === 0">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 资产详情页面 -->
      <div class="asset-details-container" v-if="currentPage === 'assetDetails'">
        <!-- 标题部分 -->
        <div class="header">
          <h1>添加资产详细信息</h1>
        </div>

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
              class="asset-type-card"
              :class="{ 
                selected: selectedAssetType === 'video',
                disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== 'video'
              }"
              @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === 'video' ? selectAssetType('video') : null"
            >
              <div class="asset-type-content">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60" id="video" class="monitor-svg">
                  <path fill="#ffffff" d="M52 7H8c-1.1 0-2 .9-2 2v28h48V9c0-1.1-.9-2-2-2zM36.45 23.89l-12 6c-.14.07-.3.11-.45.11a.999.999 0 0 1-1-1V17c0-.35.18-.67.47-.85.3-.18.67-.2.98-.04l12 6c.34.16.55.51.55.89s-.21.73-.55.89zM54 39v4c0 1.1-.9 2-2 2H37v6h3c.55 0 1 .45 1 1s-.45 1-1 1H20c-.55 0-1-.45-1-1s.45-1 1-1h3v-6H8c-1.1 0-2-.9-2-2v-4h48z"></path>
                </svg>
                <p class="asset-type-name">视频类</p>
              </div>
            </div>
            
            <div 
              class="asset-type-card"
              :class="{ 
                selected: selectedAssetType === 'image',
                disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== 'image'
              }"
              @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === 'image' ? selectAssetType('image') : null"
            >
              <div class="asset-type-content">
                <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 60 60" viewBox="0 0 60 60" id="picture" class="monitor-svg">
                  <path d="M8.0050049,38.2349854V14.8150024c0-1.2700195,0.8900146-2.3500366,2.0899658-2.6199951V10.164978
                    c-2.2999878,0.289978-4.0899658,2.2600098-4.0899658,4.6500244v27.3200073c0,2.5799561,2.0999756,4.6799927,4.6799927,4.6799927
                    h11.8499756v3.7299805h-2.6699829c-0.5599976,0-1,0.4500122-1,1c0,0.5599976,0.4400024,1,1,1h16.5900269
                    c0.0100098,0,0.0100098,0,0.0100098,0h3.6699829c0.5499878,0,1-0.4400024,1-1c0-0.5499878-0.4500122-1-1-1h-2.6799927v-3.7299805
                    h11.8599854c2.25,0,4.1400146-1.6100464,4.5800171-3.7399902c0.0700073-0.3099976,0.0999756-0.6300049,0.0999756-0.960022
                    V14.8150024c0-2.3699951-1.789978-4.3400269-4.0899658-4.6400146v2.0299683
                    c1.1999512,0.2800293,2.0899658,1.3500366,2.0899658,2.6100464v23.4199829H8.0050049z M26.9949951,43.2349854
                    c-0.1900024,0.1900024-0.4400024,0.289978-0.710022,0.289978c-0.2599487,0-0.5199585-0.0999756-0.6999512-0.289978
                    c-0.1900024-0.1900024-0.3000488-0.4400024-0.3000488-0.710022c0-0.2599487,0.1100464-0.5199585,0.3000488-0.7099609
                    c0.3699951-0.3699951,1.039978-0.3699951,1.4099731,0c0.1900024,0.1900024,0.289978,0.4500122,0.289978,0.7099609
                    C27.2849731,42.7849731,27.1849976,43.0449829,26.9949951,43.2349854z M30.7050171,43.2349854
                    c-0.1900024,0.1900024-0.4400024,0.289978-0.710022,0.289978c-0.2600098,0-0.5200195-0.0999756-0.710022-0.289978
                    c-0.1799927-0.1900024-0.289978-0.4400024-0.289978-0.710022c0-0.2599487,0.1099854-0.5199585,0.289978-0.7099609
                    c0.3800049-0.3699951,1.0500488-0.3699951,1.4200439,0.0100098c0.1799927,0.1799927,0.289978,0.4400024,0.289978,0.6999512
                    C30.9949951,42.7949829,30.8850098,43.0449829,30.7050171,43.2349854z M34.414978,43.2349854
                    c-0.1900024,0.1900024-0.4499512,0.289978-0.7099609,0.289978c-0.2700195,0-0.5200195-0.0999756-0.710022-0.289978
                    c-0.1799927-0.1900024-0.289978-0.4400024-0.289978-0.710022c0-0.2599487,0.1099854-0.5199585,0.289978-0.6999512
                    c0.3699951-0.3800049,1.039978-0.3800049,1.4199829-0.0100098c0.1799927,0.1900024,0.2900391,0.4500122,0.2900391,0.7099609
                    C34.7050171,42.7949829,34.5949707,43.0449829,34.414978,43.2349854z"></path>
                  <path d="M12.0949707,8.4549561v25.222229l9.5981445-16.9112549c0.1894531-0.3330078,0.5527954-0.5292969,0.9345703-0.5043945
                    c0.3828125,0.0249023,0.7167969,0.2661133,0.8613281,0.6210938l5.000061,12.2808838l7.9412842-12.0186768
                    c0.1895142-0.2871094,0.5127563-0.4702148,0.8575439-0.4482422c0.343689,0.0078125,0.6591187,0.1918945,0.8358765,0.487793
                    l9.78125,16.4194946V8.4549561c0-0.5499878-0.4400024-1-1-1H13.0949707
                    C12.5349731,7.4549561,12.0949707,7.9049683,12.0949707,8.4549561z M34.3660278,16.079895
                    c0.390564,0.390625,0.390564,1.0234375,0,1.4140625c-0.390625,0.390625-1.0235596,0.390625-1.4141235,0
                    c-0.3730469-0.3730469-1.0244141-0.3725586-1.3955078-0.0004883c-0.1875,0.1879883-0.4423828,0.293457-0.7080078,0.293457
                    s-0.5195313-0.1054688-0.7070313-0.2929688c-0.3720703-0.3725586-1.0234985-0.3745117-1.3974609,0
                    c-0.390625,0.390625-1.0234375,0.390625-1.4141235,0c-0.390564-0.390625-0.390564-1.0234375,0-1.4140625
                    c0.9169922-0.9180298,2.406311-1.1185913,3.5186157-0.5259399C31.9577637,14.9621582,33.4489746,15.1629028,34.3660278,16.079895z
                    M22.65802,12.8900146c0.9501953-0.9492188,2.3866577-1.1260376,3.5174561-0.5235596
                    c1.1298828-0.6009521,2.5684204-0.425293,3.5176392,0.5235596c0.390686,0.390564,0.390686,1.0238647,0,1.4144897
                    c-0.1953125,0.1952515-0.4511108,0.2929688-0.7070313,0.2929688s-0.5117188-0.0977173-0.7069702-0.2924805
                    c-0.3848267-0.3848267-1.0118408-0.3848267-1.3965454,0c-0.390564,0.3897095-1.0234985,0.3897095-1.4140625,0
                    c-0.3847046-0.3848267-1.0117188-0.3848267-1.3964844,0c-0.390625,0.3897095-1.0234375,0.3900757-1.4140015-0.0004883
                    C22.2672729,13.9138794,22.2672729,13.2805786,22.65802,12.8900146z"></path>
                  <path d="M29.402771,31.4075928l1.5198364,3.7327881c0.0072632,0.0178833,0.0041504,0.036499,0.010498,0.0545654h15.5913086
                    L37.220459,19.5764771L29.402771,31.4075928z"></path>
                  <polygon points="13.534 35.195 28.786 35.195 22.415 19.547"></polygon>
                </svg>
                <p class="asset-type-name">图片类</p>
              </div>
            </div>
            
            <div 
              class="asset-type-card"
              :class="{ 
                selected: selectedAssetType === 'audio',
                disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== 'audio' 
              }"
              @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === 'audio' ? selectAssetType('audio') : null"
            >
              <div class="asset-type-content">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" id="AudioRecording" class="monitor-svg">
                  <path fill="#ffffff" d="M56.64 7.86H38.48V11l18.15-.06A4.31 4.31 0 0 1 61 15.2v29.42H3V15.2a4.31 4.31 0 0 1 4.32-4.29h18.19V7.86H7.36A7.36 7.36 0 0 0 0 15.2V49a7.21 7.21 0 0 0 7.19 7.2h15.54v1.4L19.85 61a1.39 1.39 0 0 0 1 2.32h22.73a1.41 1.41 0 0 0 1.27-.82 1.38 1.38 0 0 0-.22-1.5l-2.88-3.36v-1.4h15.06A7.21 7.21 0 0 0 64 49V15.2a7.36 7.36 0 0 0-7.36-7.34ZM32.23 52.45a2 2 0 1 1 2-2 2 2 0 0 1-2 2Z"></path>
                  <path fill="#ffffff" d="M23.66 14.71h1.86v-3h-3.38a1.51 1.51 0 0 0-1 .37 1.53 1.53 0 0 0-.52 1.15v9.87a11.33 11.33 0 0 0 9.86 11.28v5.19H28.6a1.53 1.53 0 0 0 0 3h6.8a1.53 1.53 0 1 0 0-3h-1.88v-5.23a11.47 11.47 0 0 0 9.87-11.28v-9.87a1.51 1.51 0 0 0-1.52-1.52H39l-.51.05v3h1.87v8.35a8.37 8.37 0 0 1-7 8.23 1.52 1.52 0 0 0-1.19-.89h-.37a1.49 1.49 0 0 0-1.18.88 8.37 8.37 0 0 1-7-8.23Z"></path>
                  <path fill="#ffffff" d="M28.89 5.87a.31.31 0 0 1-.31.31h-2.25v4h2.25a.3.3 0 1 1 0 .6h-2.25v2.12h11.34v-2.13h-2.24a.3.3 0 0 1 0-.6h2.24v-4h-2.24a.31.31 0 0 1 0-.61h2.27l-.3-.93a5.66 5.66 0 0 0-10.79 0l-.3.93h2.27a.31.31 0 0 1 .31.31zM32 25.77a5.64 5.64 0 0 0 5.39-3.93l.3-.93h-2.26a.29.29 0 0 1-.3-.3.29.29 0 0 1 .3-.31h2.24v-4h-2.24a.29.29 0 0 1-.3-.3.28.28 0 0 1 .3-.3h2.24v-2.16H26.33v2.17h2.25a.3.3 0 1 1 0 .6h-2.25v4h2.25a.31.31 0 0 1 .31.31.31.31 0 0 1-.31.3h-2.27l.3.93A5.64 5.64 0 0 0 32 25.77z"></path>
                </svg>
                <p class="asset-type-name">音频类</p>
              </div>
            </div>
            
            <div 
              class="asset-type-card"
              :class="{ 
                selected: selectedAssetType === 'text',
                disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== 'text'
              }"
              @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === 'text' ? selectAssetType('text') : null"
            >
              <div class="asset-type-content">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" id="file" class="monitor-svg">
                  <path fill="#ffffff" d="M2 44v3a3.003 3.003 0 0 0 3 3h54a3.003 3.003 0 0 0 3-3v-3Zm52 4a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm3 0a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm-15 9a3.003 3.003 0 0 1-3 3H25a3 3 0 0 1 0-6h.28l.666-2h12.108l.667 2H39a3.003 3.003 0 0 1 3 3Zm3.384-44H36V4.555ZM35 15a1 1 0 0 1-1-1V4H21a3.003 3.003 0 0 0-3 3v31a3.003 3.003 0 0 0 3 3h22a3.003 3.003 0 0 0 3-3V15ZM23 32a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm0-4a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm0-4a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm0-4a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm18 12H27a1 1 0 0 1 0-2h14a1 1 0 0 1 0 2Zm0-4H27a1 1 0 0 1 0-2h14a1 1 0 0 1 0 2Zm0-4H27a1 1 0 0 1 0-2h14a1 1 0 0 1 0 2Zm0-4H27a1 1 0 0 1 0-2h14a1 1 0 0 1 0 2Zm21-6v28h-4V16a1 1 0 0 0-1-1h-9v-1c.066-1.285-.93-2.252-1.849-3H59a3.003 3.003 0 0 1 3 3Zm-46 1H7a1 1 0 0 0-1 1v26H2V14a3.003 3.003 0 0 1 3-3h11Z"></path>
                </svg>
                <p class="asset-type-name">文字类</p>
              </div>
            </div>
          </div>
          
          <!-- 选择了资产类型后显示上传区域 -->
          <div v-if="selectedAssetType" class="upload-area-container">
            <div class="upload-header">
              <h3>上传文件</h3>
              <p class="file-types">支持的文件类型:</p>
              <p class="file-types" v-if="selectedAssetType === 'image'">JPG、PNG、GIF、SVG、WEBP</p>
              <p class="file-types" v-if="selectedAssetType === 'video'">MP4、WEBM、MOV</p>
              <p class="file-types" v-if="selectedAssetType === 'audio'">WAV、MP3、FLAC、AAC、OGG、M4A、OPUS</p>
              <p class="file-types" v-if="selectedAssetType === 'text'">TXT、PDF、DOC、DOCX</p>
              <p class="file-size">最大大小1000MB</p>
              <p class="upload-type-info">
                <span class="info-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 500 500" viewBox="0 0 500 500" id="warning">
                    <path fill="#ffffff" d="M174.504,338.955c0.613,0.028,1.227,0.05,1.841,0.05c8.9,0,17.86-2.915,25.343-8.915
                      c6.918-5.545,11.535-12.896,13.723-20.837c-1.731-1.286-3.409-2.659-5.009-4.141c-11.073-10.254-17.801-24.205-18.945-39.289
                      c-1.206-15.891,3.863-31.295,14.273-43.388c10.396-12.076,24.869-19.376,40.753-20.581l75.852-5.73L182.657,28.593
                      c-14.346-17.205-39.921-19.526-57.128-5.179c-17.206,14.345-19.525,39.922-5.179,57.128l57.304,68.731
                      c-8.733-0.501-17.691,1.796-25.431,7.172c-13.448,9.34-19.489,25.354-16.783,40.481c-11.574-2.55-24.155-0.039-34.121,7.95
                      c-15.995,12.821-19.698,35.282-9.476,52.399c-8.464,0.897-16.717,4.45-23.41,10.714c-16.357,15.306-17.208,40.974-1.902,57.331
                      l37.815,40.409c7.986,8.534,18.792,12.847,29.625,12.847c9.931,0,19.884-3.625,27.706-10.945
                      C169.961,359.878,174.26,349.468,174.504,338.955z"></path>
                    <path fill="#ffffff" d="M389.153,266.233l0.161-12.322c0-11.29-4.832-22.07-13.113-29.746c-2.959-2.743-6.345-4.992-9.903-6.722
                      c0,0-8.355-4.266-18.92-4.072c-0.637,0.012-99.464,7.489-99.464,7.489c-22.338,1.694-39.169,21.176-37.474,43.513
                      c1.268,16.723,12.412,30.298,27.3,35.359c0.058-0.019,0.114-0.035,0.172-0.055c3.772,1.295,7.779,2.048,11.924,2.17
                      c0.059,0.001,0.117,0.003,0.175,0.004c0.44,0.011,46.85-3.41,46.85-3.41c5.462-0.418,10.125,3.901,10.125,9.38l0,0
                      c0,3.773-2.237,7.059-5.505,8.551c-5.698,4.216-54.935,41.873-57.694,85.181c-0.322,5.053-4.521,8.937-9.515,8.937
                      c-0.204,0-0.409-0.007-0.616-0.02c-5.26-0.335-9.253-4.871-8.918-10.131c2.128-33.416,25.274-62.516,43.632-80.577
                      c0,0-34.612,0.509-36.64,0.737c-3.786,9.498-9.984,17.977-18.1,24.483c-6.733,5.398-14.567,9.248-22.864,11.326
                      c-3.056,9.548-8.512,18.208-16.046,25.258c-9.343,8.743-21.089,14.161-33.636,15.657l58.992,57.96
                      c40.421,40.421,105.955,40.421,146.375,0l42.64-42.577C429.51,372.187,429.573,306.653,389.153,266.233z"></path>
                  </svg>
                </span>
                <span>您已选择{{ selectedAssetType === 'image' ? '图片' : selectedAssetType === 'video' ? '视频' : selectedAssetType === 'audio' ? '音频' : '文字' }}类，仅能上传对应类型的文件。上传文件后将无法切换类别。</span>
              </p>
            </div>

            <!-- 上传文件预览区域 -->
            <div v-if="uploadedFiles.length > 0" class="uploaded-files-preview">
              <div :class="['preview-files-grid', selectedAssetType === 'audio' ? 'audio-grid' : '']">
                <div 
                  v-for="(file, index) in uploadedFiles" 
                  :key="index" 
                  :class="['preview-file-item', file.type.startsWith('audio/') ? 'audio-file' : '']"
                  draggable="true"
                  @dragstart="dragStart(index, $event)"
                  @dragover.prevent
                  @dragenter.prevent="dragEnter(index, $event)"
                  @dragleave.prevent="dragLeave($event)"
                  @drop.prevent="drop(index, $event)"
                  @dragend="dragEnd()"
                >
                  <div class="preview-file-content">
                    <!-- 图片预览 -->
                    <img v-if="file.type.startsWith('image/')" :src="file.url" class="preview-image" />
                    
                    <!-- 视频预览 -->
                    <div v-else-if="file.type.startsWith('video/')" class="preview-video">
                      <video :src="file.url" controls class="preview-media"></video>
                    </div>
                    
                    <!-- 音频预览 -->
                    <div v-else-if="file.type.startsWith('audio/')" class="preview-audio">
                      <div class="audio-top-row">
                        <div class="audio-play-btn">
                          <div class="play-button">
                            <span class="play-icon">▶</span>
                          </div>
                        </div>
                        <div class="audio-info">
                          <div class="audio-top-section">
                            <div class="audio-title">{{ file.name.split('.')[0] }}</div>
                            <div class="audio-menu-dots">⋮</div>
                          </div>
                          <div class="audio-subtitle">上传音频</div>
                          <div class="audio-details">
                            <span class="audio-format">{{ getAudioFormat(file.name) }}</span>
                            <span class="audio-duration">{{ formatDuration(file.duration || 0) }}</span>
                          </div>
                        </div>
                      </div>
                      <div class="audio-waveform">
                        <div class="waveform-display">
                          <div class="waveform-progress" :style="{ width: '30%' }"></div>
                        </div>
                      </div>
                      <audio :src="file.url" class="hidden-audio" ref="audioPlayer"></audio>
                    </div>
                    
                    <!-- 文档预览 -->
                    <div v-else class="preview-document">
                      <div class="document-placeholder"></div>
                      <p class="document-name">{{ file.name }}</p>
                    </div>
                  </div>
                  
                  <!-- 拖拽手柄 -->
                  <div class="drag-handle">
                    <span class="drag-icon">⋮⋮</span>
                  </div>
                  
                  <!-- 删除按钮 -->
                  <button class="remove-file-btn" @click="removeFile(index)" title="移除文件">×</button>
                </div>
              </div>
              <p class="drag-hint">提示：可拖动文件调整顺序</p>
            </div>

            <div class="upload-area" @click="triggerFileUpload" @dragover.prevent @drop.prevent="onFileDrop">
              <div class="upload-icons">
                <div class="empty-upload-icon"></div>
              </div>
              <p class="upload-text">在此处浏览或拖放您的文件</p>
              <input 
                type="file" 
                ref="fileInput" 
                class="hidden-file-input"
                @change="handleFileSelect"
                multiple
                :accept="fileTypeAccept"
              >
            </div>
            <p v-if="uploadedFiles.length === 0" class="file-required">需要文件</p>
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
        <div class="form-group">
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
        <div class="navigation">
          <button class="back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="next-btn" @click="goNext" :disabled="!assetName || uploadedFiles.length === 0">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 创作者信息页面 -->
      <div class="creators-container" v-if="currentPage === 'creators'">
        <div class="header">
          <h1>创造者</h1>
          <p class="subtitle">将共同创建者添加到此资产（可选）</p>
        </div>

        <!-- 添加共同创作者 -->
        <div class="add-creators-section">
          <h3>添加共同创作者</h3>
          <div class="creators-input-row">
            <input 
              type="text" 
              class="input-field creator-input" 
              placeholder="输入名称搜索"
              v-model="newCreatorName"
            >
            <input 
              type="text" 
              class="input-field creator-input" 
              placeholder="输入用户ID搜索"
              v-model="newCreatorWallet"
            >
            <button 
              class="add-creator-btn" 
              @click="addCoCreator"
              :disabled="!newCreatorName || !newCreatorWallet"
            >
              添加 <span class="plus-icon">+</span>
            </button>
          </div>
        </div>

        <!-- 创作者列表 -->
        <div class="creators-list-section">
          <h3>创作者</h3>
          
          <!-- 当前用户（管理员） -->
          <div class="creator-item current-user">
            <div class="creator-avatar">
              <div class="avatar-image">😀</div>
            </div>
            <div class="creator-info">
              <div class="creator-name">你</div>
              <div class="creator-role">管理</div>
            </div>
          </div>
          
          <!-- 共同创作者列表 -->
          <div v-for="(creator, index) in coCreators" :key="index" class="creator-item">
            <div class="creator-avatar">
              <div class="avatar-image">👤</div>
            </div>
            <div class="creator-info">
              <div class="creator-name">{{ creator.name }}</div>
              <div class="creator-wallet">{{ shortenWallet(creator.wallet) }}</div>
            </div>
            <button class="remove-creator-btn" @click="removeCoCreator(index)">×</button>
          </div>
        </div>

        <!-- 底部导航按钮 -->
        <div class="navigation">
          <button class="back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="next-btn" @click="goNext">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- AI权限设置页面 -->
      <div class="ai-permissions-container" v-if="currentPage === 'aiPermissions'">
        <div class="ai-permissions-header">
          <h1 class="ai-title-main">AI 权限设置</h1>
          <p class="ai-subtitle">控制您的IP是否包含在AI训练程序中</p>
        </div>
        
        <div class="ai-card">
          <div class="ai-card-row">
            <div class="ai-card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 50 50" id="ai" width="36" height="36">
                <path fill="#ffffff" d="M28.5 26.6c-.3-.1-.6-.1-.8-.2-.1.3-.2.7-.3 1.1.3-.3.7-.6 1.1-.9z"></path>
                <path fill="#ffffff" d="M23.2 36.8c.1-3.3 1.4-6.2 3.4-8.4v-.5c0-.5 0-.9.1-1.4-.8.1-1.5.3-2.4.5.3-.5.8-.8 1.3-1.1.5-.3 1.1-.4 1.7-.4.6 0 1.2.2 1.7.5 0 0 .1.1.2.1 2.2-1.5 4.9-2.4 7.7-2.4h.7s0-.1.1-.1c.5-1.6.2-3.4-.6-4.7-.2-.2-.3-.5-.5-.7-.9.8-1.9 1.4-3 1.8-.7.3-1.4.5-2.2.5-.8 0-1.6-.1-2.2-.6.7.2 1.4 0 2.1-.1.7-.2 1.3-.4 1.9-.7 1-.4 2-.8 3.1-1.3-.1-.1-.1-.3-.1-.4v-.3c0-.7 1.2-2.6.3-5.2-.5-1.2-1.3-2.3-2.2-3.3-.2-.2-.4-.5-.6-.7-.8.6-1.6 1.1-2.3 1.7-.5.4-1 .8-1.3 1.3-.4.5-.7 1-1 1.7-.1-.7 0-1.4.3-2.1.3-.7.8-1.2 1.4-1.6.6-.5 1.2-.8 1.8-1 .3-.1.5-.2.8-.3-.4-.5-1-1.2-1.6-2-.6-.8-1.2-1.6-2.1-2.1h-.1c-1.8-.9-3.8-.3-5.7-1-.7-.3-1.2-.7-1.8-1-.5-.2-.9-.3-1.4-.4v7.2h.8c.5 0 1-.2 1.4-.4.5-.2.9-.5 1.3-.9s.7-.8 1.1-1.2c-.3.3-.6.8-.9 1.2-.4.4-.8.8-1.2 1.1-.5.3-1 .6-1.6.7-.3.1-.6.2-1 .2v8.8c.1 0 .2-.1.3-.2.5-.3 1-.5 1.5-.6.5-.1 1.1-.1 1.6 0 .5.2.9.5 1.3.9-.4-.3-.8-.6-1.3-.6s-1 0-1.4.2c-.4.2-.9.4-1.2.7-.2.2-.5.4-.7.6V39c.5.6 1.2 1.1 1.9 1.3.3.1.7.2 1 .2-.3-1.2-.4-2.4-.4-3.7zM15.4 2.3c-1.9.7-4 .1-5.8 1-1 .6-1.6 1.6-2.4 2.5-.6.7-1 1.2-1.2 1.5 1.4.7 2.9 1.8 3.7 3.2.3.6.5 1.3.6 2-.3-2-2.1-3.3-3.9-4.1-.3-.2-.7-.3-1-.4-1 1.2-2.1 2.4-2.6 3.9-.2.6-.3 1.2-.4 1.9 0 .7.1 1.5.3 2.2.2.3.3.7.3 1.1 0 .2 0 .3-.1.5.9.7 1.9 1.2 3 1.7.7.3 1.4.6 2 .7.7.1 1.4.2 2.1-.1-.6.4-1.4.5-2.1.4-.3 0-.6-.1-.9-.1-.4-.1-.9-.2-1.3-.3-1.1-.4-2.2-.8-3.2-1.4-.1.2-.2.3-.3.5-.9 1.5-1.1 3.2-.6 4.7.9 3 1.3 1.5 1.6 5.6 0 .2 0 .5.1.7.2 1.6 1 3 2.1 4.1 1 1 2.4 1.6 3.4 2.5.7.7 1.3 1.5 2.1 2.1.5.4 1 .7 1.6.9.8.7 1.8 1.1 2.9 1.1.5 0 1-.1 1.4-.3.6-.2 1.1-.5 1.6-.9l.2-.2.2-.2V18.8c-.2-.2-.4-.4-.7-.6-.4-.3-.8-.5-1.2-.7-.4-.2-.9-.3-1.4-.2-.5.1-.9.3-1.3.6.3-.4.8-.7 1.3-.9.5-.2 1-.1 1.6 0s1 .3 1.5.6c.1 0 .2.1.3.2V9c-.3 0-.6-.1-.9-.1-.6-.1-1.1-.4-1.6-.7-.5-.3-.9-.7-1.2-1.1-.4-.4-.6-.9-.9-1.4.3.4.7.8 1.1 1.2.4.3.8.7 1.3.9.5.2 1 .4 1.4.4h.8V.8c-.5.1-1 .2-1.4.5-.9.3-1.5.7-2.1 1zm.3 33.6c-.9.3-1.5.6-2 1.1-.2.2-.4.5-.7.9-.1.2-.2.3-.3.5-.1.2-.2.4-.4.6-.3-.9-.1-1.9.6-2.7.4-.4.8-.6 1.3-.7.6 0 1.1.1 1.5.3zm-.6-9c-.9-.2-1.7-.4-2.4-.5.1.5.1.9.1 1.4 0 .6-.1 1.1-.3 1.7-.2.5-.5 1-.9 1.4-.4.4-.9.7-1.3.9.4-.3.9-.6 1.1-1.1.3-.4.5-.9.6-1.4.1-.5.1-1 0-1.5s-.2-1-.3-1.4c-.8.1-1.6.4-2.5.9.2-.5.6-1 1.1-1.4.5-.4 1.1-.5 1.7-.5.6 0 1.2.1 1.7.4.6.3 1 .7 1.4 1.1z"></path>
                <path fill="#ffffff" d="M37.5 25.7c-6.5-.3-12 4.7-12.3 11.2-.3 6.5 4.7 12 11.2 12.3 6.5.3 12-4.7 12.3-11.2.3-6.5-4.7-12-11.2-12.3zm2 16c-.1.2-.3.2-.6.2s-.6-.2-.7-.5l-.7-1.7h-3.7l-.7 1.7c-.1.2-.2.3-.3.4-.3.2-.8.2-1-.1-.1-.2-.2-.3-.2-.6 0-.1 0-.2.1-.3l3.1-7.2c.1-.2.2-.3.3-.5.2-.1.4-.2.6-.2h.1c.2 0 .4.1.6.2.1.1.3.3.3.4l3.1 7.2c.1.1.1.2.1.3-.1.4-.2.5-.4.7zm2.9-.6c0 .2-.1.4-.2.6-.2.1-.3.2-.6.2-.2 0-.4-.1-.6-.2-.2-.2-.2-.3-.2-.6v-7.4c0-.2.1-.4.2-.6.3-.3.8-.3 1.1 0 .2.2.2.3.2.6v7.4z"></path>
                <path fill="#ffffff" d="M34.4 38.2h2.5l-1.3-3z"></path>
              </svg>
            </div>
            <div class="ai-card-text">
              <div class="ai-card-title" style="font-size: 15px; color: #a0a0a0;">允许您的信息用于AI训练</div>
            </div>
            <div class="new-toggle-container">
              <div 
                class="new-toggle" 
                :class="{ active: aiTrainingEnabled }" 
                @click="aiTrainingEnabled = !aiTrainingEnabled"
              >
                <div class="new-toggle-circle"></div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 底部导航按钮 -->
        <div class="ai-navigation">
          <button class="ai-back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="ai-next-btn" @click="handleAISettingsSubmit">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 审核与注册页面 -->
      <div class="review-register-container" v-if="currentPage === 'reviewRegister'">
        <div class="review-content">
          <button class="close-review-btn" @click="goToStart">×</button>
          
          <div class="review-header">
            <h1>审核与注册</h1>
            <p class="review-subtitle">以下是您的注册概览</p>
          </div>
          
          <div class="review-sections">
            <div class="sections-container">
              <div class="review-section-header licenses-header-row">
                <h3 class="section-title">许可证 ({{ selectedLicenses.length }})</h3>
                <button class="add-license-btn" @click="goToLicense">添加许可证</button>
              </div>
              
              <div class="licenses-section">
                <div class="licenses-list">
                  <div v-for="license in selectedLicenses" :key="license" class="license-item">
                    <div class="license-item-content">
                      <div class="license-info">
                        <span class="license-name">{{ getLicenseName(license) }}</span>
                      </div>
                      <div class="license-actions">
                        <button class="license-search-btn" @click="handleLicenseSearch(license)">
                          <span class="search-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" id="search" x="0" y="0" version="1.1" viewBox="0 0 29 29" width="16" height="16">
                              <circle cx="11.854" cy="11.854" r="9" style="fill:none;stroke:#fff;stroke-width:2;stroke-miterlimit:10"></circle>
                              <path d="M18.451 18.451l7.695 7.695" style="fill:none;stroke:#fff;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10"></path>
                            </svg>
                          </span>
                        </button>
                        <button class="license-delete-btn">
                          <span class="delete-icon">×</span>
                        </button>
                      </div>
                    </div>
                  </div>
                  <!-- Show placeholder if no licenses are selected -->
                  <div v-if="selectedLicenses.length === 0" class="no-licenses-placeholder">
                    <p>暂无选择许可证</p>
                  </div>
                </div>
              </div>
              
              <div class="review-section-header">
                <h3 class="section-title">您的资产</h3>
              </div>
              
              <div class="asset-section">
                <!-- 资产部分内容 -->
                <div v-for="(file, index) in uploadedFiles" :key="index" class="asset-preview-card" :class="{ 'audio-asset': file.type.startsWith('audio/') }">
                  <div class="asset-image-container">
                    <!-- 图片文件 -->
                    <img v-if="file.type.startsWith('image/')" :src="file.url" class="asset-preview-image" alt="Asset preview" />
                    
                    <!-- 视频文件 -->
                    <video v-else-if="file.type.startsWith('video/')" :src="file.url" class="asset-preview-video" controls></video>
                    
                    <!-- 音频文件 -->
                    <div v-else-if="file.type.startsWith('audio/')" class="asset-preview-audio">
                      <div class="audio-icon">♪</div>
                    </div>
                    
                    <!-- 其他类型文件 -->
                    <div v-else class="asset-placeholder">
                      <div class="placeholder-icon">📄</div>
                    </div>
                  </div>
                  
                  <div class="asset-preview-info">
                    <div class="asset-source">公共资源门户</div>
                    <div class="asset-name">{{ assetName || "Hiroyoshi Kaninnomiya" }}</div>
                    
                    <!-- 开放使用许可信息区域 -->
                    <div class="license-info-area">
                      <div class="license-badge" @click="toggleLicenseInfo(index)">
                        <span class="license-icon">IP</span>
                        <span class="license-name">开放使用</span>
                        <span class="toggle-icon">{{ showLicenseInfoMap[index] ? '▼' : '▶' }}</span>
                      </div>
                      
                      <!-- 点击展开的许可信息详情 -->
                      <div class="license-details" v-if="showLicenseInfoMap[index]">
                        <div class="license-description">
                          开放使用是一种公共资源工具，它允许创作者放弃版权限制，作品放入全球公共共享库。使用者可以在任何媒体或格式中分享、混音、改编和构建作品，无需付费或获得许可。
                        </div>
                        <div class="license-terms">
                          <div class="term-tag"><span class="term-icon">📝</span>无需标明出处</div>
                          <div class="term-tag"><span class="term-icon">💲</span>允许商业使用</div>
                          <div class="term-tag"><span class="term-icon">↩️</span>允许混音改编</div>
                          <div class="term-tag"><span class="term-icon">🤖</span>允许AI训练</div>
                        </div>
                      </div>
                    </div>
                    
                    <div class="asset-owner">
                      <div class="asset-owner-label">持有者</div>
                      <div class="owners-avatar-row">
                        <!-- 当前用户/主要创作者 -->
                        <div class="avatar-badge current-owner-badge">
                          <span class="owner-icon">●</span>
                        </div>
                        
                        <!-- 显示共同创作者 -->
                        <template v-if="coCreators && coCreators.length > 0">
                          <div v-for="(creator, idx) in coCreators.slice(0, 2)" :key="idx" class="avatar-badge creator-badge">
                            <span class="owner-icon">●</span>
                          </div>
                          
                          <!-- 如果共同创作者超过2个，显示+X -->
                          <div v-if="coCreators.length > 2" class="avatar-badge more-badge">
                            <span class="owner-count">+{{ coCreators.length - 2 }}</span>
                          </div>
                        </template>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- 如果没有文件，显示占位符 -->
                <div v-if="uploadedFiles.length === 0" class="asset-preview-card">
                  <div class="asset-image-container">
                    <div class="asset-placeholder">
                      <div class="placeholder-icon">?</div>
                    </div>
                  </div>
                  
                  <div class="asset-preview-info">
                    <div class="asset-source">公共资源门户</div>
                    <div class="asset-name">{{ assetName || "未命名资产" }}</div>
                    
                    <div class="asset-owner">
                      <div class="asset-owner-label">持有者</div>
                      <div class="owners-avatar-row">
                        <!-- 当前用户/主要创作者 -->
                        <div class="avatar-badge current-owner-badge">
                          <span class="owner-icon">●</span>
                        </div>
                        
                        <!-- 显示共同创作者 -->
                        <template v-if="coCreators && coCreators.length > 0">
                          <div v-for="(creator, idx) in coCreators.slice(0, 2)" :key="idx" class="avatar-badge creator-badge">
                            <span class="owner-icon">●</span>
                          </div>
                          
                          <!-- 如果共同创作者超过2个，显示+X -->
                          <div v-if="coCreators.length > 2" class="avatar-badge more-badge">
                            <span class="owner-count">+{{ coCreators.length - 2 }}</span>
                          </div>
                        </template>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="review-actions">
            <button class="back-review-btn" @click="goBack">
              <span class="arrow">←</span> 返回
            </button>
            <button class="uiverse" @click="handleRegistration">
              <div class="wrapper">
                <span>发布</span>
                <div class="circle circle-1"></div>
                <div class="circle circle-2"></div>
                <div class="circle circle-3"></div>
                <div class="circle circle-4"></div>
                <div class="circle circle-5"></div>
                <div class="circle circle-6"></div>
                <div class="circle circle-7"></div>
                <div class="circle circle-8"></div>
                <div class="circle circle-9"></div>
                <div class="circle circle-10"></div>
                <div class="circle circle-11"></div>
                <div class="circle circle-12"></div>
              </div>
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Add error notification -->
    <div v-if="showFileTypeError" class="file-type-error">
      <div class="error-content">
        <span class="error-icon">⚠️</span>
        <span class="error-message">{{ fileTypeErrorMessage }}</span>
        <button class="error-close" @click="showFileTypeError = false">×</button>
      </div>
    </div>

    <!-- 许可证冲突弹窗 -->
    <div v-if="showLicenseConflictModal" class="license-conflict-modal">
      <div class="modal-content">
        <header class="modal-header">
          <h2>许可证冲突</h2>
          <span class="close-btn" @click="closeConflictModal">×</span>
        </header>
        <div class="modal-body">
          <div class="conflict-icon">
            <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" id="ai" width="80" height="80" enable-background="new 0 0 48 48" version="1.1" viewBox="0 0 48 48">
              <g>
                <path fill="#000000" d="M26.2,32.5l-1.5-3.4h-6.6l-1.5,3.4h-3.7l6.8-15.7h3.4l6.8,15.7H26.2z M34.8,32.5h-3.4V20.4h3.4V32.5z M34.5,18.9c-0.4,0.4-0.9,0.6-1.4,0.6c-0.6,0-1-0.2-1.4-0.6c-0.4-0.4-0.6-0.9-0.6-1.4c0-0.6,0.2-1,0.6-1.4c0.4-0.4,0.9-0.6,1.4-0.6c0.6,0,1,0.2,1.4,0.6c0.4,0.4,0.6,0.9,0.6,1.4C35.1,18,34.9,18.5,34.5,18.9z"></path>
                <polygon fill="#000000" points="19.5 26 23.4 26 21.4 21.5"></polygon>
              </g>
            </svg>
          </div>
          <div class="conflict-info">
            <p class="conflict-title">无法添加以下许可证：</p>
            <div class="conflict-license new-license">
              <span class="license-tag">{{ conflictModalData.newLicenseName }}</span>
            </div>
            
            <p class="conflict-title">已选择的冲突许可证：</p>
            <div class="conflict-license existing-license">
              <span class="license-tag" v-for="license in conflictModalData.conflictingLicenses" :key="license">
                {{ getLicenseName(license) }}
              </span>
            </div>
            
            <p class="conflict-reason">
              <span class="reason-label">冲突原因：</span>
              {{ conflictModalData.reason }}
            </p>
          </div>
          
          <div class="valid-combinations">
            <h3>有效的许可证组合</h3>
            <div class="combination">
              <div class="combination-group">
                <span class="license-tag blue">开放使用</span>
                <span class="combination-note">（单独使用）</span>
              </div>
            </div>
            <div class="combination">
              <div class="combination-group">
                <span class="license-tag purple">非商业混音</span>
                <span class="plus-sign">+</span>
                <span class="license-tag green">商业使用</span>
                <span class="plus-sign">+</span>
                <span class="license-tag red">商业混音</span>
                <span class="combination-note">（可任意组合）</span>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="modal-btn cancel-btn" @click="closeConflictModal">我知道了</button>
        </div>
      </div>
    </div>

    <!-- 许可证详情弹窗 -->
    <div v-if="showLicenseDetailModal" class="license-detail-modal">
      <div class="modal-content license-detail-content">
        <header class="modal-header">
          <div class="license-detail-logo">
            <div class="ip-logo">IP</div>
            <div class="license-detail-title">{{ currentLicenseDetail.name }}</div>
            <div class="license-detail-icons">
              <span v-if="currentLicenseDetail.license === 'open'"><span class="license-icon">📝</span></span>
              <span v-if="currentLicenseDetail.license === 'commercial' || currentLicenseDetail.license === 'commercial-remix'"><span class="license-icon">💲</span></span>
              <span v-if="currentLicenseDetail.license === 'non-commercial' || currentLicenseDetail.license === 'commercial-remix'"><span class="license-icon">↩️</span></span>
            </div>
          </div>
          <span class="close-btn" @click="closeLicenseDetailModal">×</span>
        </header>
        
        <div class="modal-body">
          <div class="license-summary">
            <h3>许可证摘要</h3>
            <p>{{ currentLicenseDetail.summary }}</p>
          </div>
          
          <div class="license-terms">
            <h3>许可条款</h3>
            <div class="terms-list">
              <div class="term-item" v-if="currentLicenseDetail.license === 'open'">
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
                  {{ currentLicenseDetail.license === 'non-commercial' ? '仅限非商业使用' : 
                     currentLicenseDetail.license === 'commercial' || currentLicenseDetail.license === 'commercial-remix' ? '允许商业使用' : '允许任何使用' }}
                </div>
              </div>
              
              <div class="term-item">
                <div class="term-icon">↩️</div>
                <div class="term-text">
                  {{ currentLicenseDetail.license === 'non-commercial' || currentLicenseDetail.license === 'commercial-remix' || currentLicenseDetail.license === 'open' ? '允许混音改编' : '不允许混音改编' }}
                </div>
              </div>
              
              <div class="term-item">
                <div class="term-icon">📊</div>
                <div class="term-text">
                  {{ currentLicenseDetail.license === 'commercial' || currentLicenseDetail.license === 'commercial-remix' ? '收取版税' : '无版税共享' }}
                </div>
              </div>
              
              <div class="term-item">
                <div class="term-icon">🤖</div>
                <div class="term-text">{{ aiTrainingEnabled ? 'AI训练允许' : 'AI训练不允许' }}</div>
              </div>
            </div>
          </div>
          
          <div class="license-view-legal">
            <button class="view-legal-btn">
              <span class="legal-icon">📄</span>
              查看法律条款
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

// 当前页面状态
const currentPage = ref('start') // 'start', 'workType', 'license', 'aiPermissions', 'assetDetails', 或 'creators'

// 标签页数据
const tabs = [
  { id: 'preset', label: '预设许可证' },
  { id: 'custom', label: '自定义许可证' },
  { id: 'assistant', label: '许可证助手' }
]

// 记录展开的过滤器项
const expandedFilters = ref<Record<string, boolean>>({
  'ai-training': false,
  'commercial-use': false,
  'attribution': false, // 修改为默认不展开
  'remixing': false,
  'expiration': false,
  'licensing-fee': false
})

// 切换过滤器项的展开/折叠状态
const toggleFilter = (filterId: string) => {
  expandedFilters.value[filterId] = !expandedFilters.value[filterId]
}

// 作品类型数据
const workTypes = [
  { id: 'newIP', label: '新IP', icon: 'sparkles', description: '注册原创图片、视频或文字作品' },
  { id: 'remix', label: '混音', icon: 'remix', description: '注册与现有作品相关的衍生作品' }
]

// 当前选中的标签页
const activeTabIndex = ref(0)

// 当前选择的许可证
const selectedLicense = ref('')
const selectedLicenses = ref<string[]>([])

// 当前选择的作品类型
const selectedWorkType = ref('')

// 资产详情页面数据
const assetName = ref('')
const assetDescription = ref('')
const activeUploadMethod = ref('file')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const selectedAssetType = ref('')
const uploadedFiles = ref<Array<{name: string, type: string, url: string, file: File, duration?: number}>>([])

// 创作者页面数据
const newCreatorName = ref('')
const newCreatorWallet = ref('')
const coCreators = ref<Array<{name: string, wallet: string}>>([])

// 根据选择的资产类型确定接受的文件类型
const fileTypeAccept = computed(() => {
  switch (selectedAssetType.value) {
    case 'image':
      return 'image/jpeg,image/png,image/gif,image/svg+xml,image/webp';
    case 'video':
      return 'video/mp4,video/webm,video/quicktime';
    case 'audio':
      return 'audio/wav,audio/mpeg,audio/flac,audio/aac,audio/ogg,audio/mp4,audio/opus';
    case 'text':
      return '.txt,.pdf,.doc,.docx,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    default:
      return '';
  }
});

// 页面跳转函数
const goToStart = () => {
  currentPage.value = 'start'
}

const goToWorkType = () => {
  currentPage.value = 'workType'
  // 重置选择状态，确保进入页面时没有默认选中的选项
  selectedWorkType.value = ''
}

const goToAssetDetails = () => {
  currentPage.value = 'assetDetails'
}

const goToCreators = () => {
  currentPage.value = 'creators'
}

const goToLicense = () => {
  currentPage.value = 'license'
  resetExpandedFilters()
}

const showUnavailable = (type: string) => {
  alert(`${type === 'task' ? '发布任务' : '发布活动'}功能尚未开放，敬请期待`)
}

// 选择作品类型
const selectWorkType = (type: string) => {
  selectedWorkType.value = type
}

// 切换标签页
const setActiveTab = (index: number) => {
  activeTabIndex.value = index
  // 切换标签页时清除选择的许可证
  if (index !== 0) {
    selectedLicense.value = ''
  }
  
  // 切换到自定义许可证标签页时重置所有展开状态
  if (index === 1) {
    resetExpandedFilters()
  }
}

// 选择许可证
const selectLicense = (license: string) => {
  const licenseConflicts = checkLicenseConflicts(license)
  
  if (selectedLicenses.value.includes(license)) {
    // 如果已选择，则移除
    selectedLicenses.value = selectedLicenses.value.filter(item => item !== license)
    selectedLicense.value = selectedLicenses.value.length > 0 ? selectedLicenses.value[0] : ''
  } else {
    // 如果有冲突，显示提示
    if (licenseConflicts.hasConflict) {
      showLicenseConflictAlert(license, licenseConflicts.conflictingLicenses, licenseConflicts.reason)
    } else {
      // 无冲突，添加许可证
      selectedLicenses.value.push(license)
      selectedLicense.value = license
      
      // 再次检查当前组合是否有冲突（防止漏检）
      checkCurrentLicenseCombination()
    }
  }
}

// 检查许可证冲突
const checkLicenseConflicts = (newLicense: string) => {
  const conflicts = {
    hasConflict: false,
    conflictingLicenses: [] as string[],
    reason: ''
  }
  
  // 新冲突规则
  // 只有开放使用与其他三个许可证冲突
  if (newLicense === 'open') {
    // 开放使用与其他所有许可证冲突
    const conflicting = selectedLicenses.value.filter(l => 
      ['commercial', 'commercial-remix', 'non-commercial'].includes(l)
    );
    
    if (conflicting.length > 0) {
      conflicts.hasConflict = true;
      conflicts.conflictingLicenses = conflicting;
      conflicts.reason = '开放使用（完全免费无限制）与其他许可证类型互斥，不能同时选择';
    }
  } 
  // 其他三个许可证之间互相不冲突
  else if (selectedLicenses.value.includes('open')) {
    // 如果当前已选择了开放使用，则其他许可证都会与之冲突
    conflicts.hasConflict = true;
    conflicts.conflictingLicenses = ['open'];
    conflicts.reason = '其他许可证类型与开放使用（完全免费无限制）互斥，不能同时选择';
  }
  
  return conflicts
}

// 显示许可证冲突提示
const showLicenseConflictModal = ref(false);
const conflictModalData = ref<{
  newLicense: string;
  conflictingLicenses: string[];
  reason: string;
  newLicenseName: string;
  conflictsList: string;
}>({
  newLicense: '',
  conflictingLicenses: [],
  reason: '',
  newLicenseName: '',
  conflictsList: ''
});

const showLicenseConflictAlert = (newLicense: string, conflictingLicenses: string[], reason: string) => {
  const licenseNames = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音'
  }
  
  const conflictsList = conflictingLicenses.map(license => licenseNames[license as keyof typeof licenseNames]).join('、')
  const newLicenseName = licenseNames[newLicense as keyof typeof licenseNames]
  
  // 设置冲突数据并显示弹窗
  conflictModalData.value = {
    newLicense,
    conflictingLicenses,
    reason,
    newLicenseName,
    conflictsList
  };
  showLicenseConflictModal.value = true;
}

// 当前选择的许可证显示
const getLicenseDisplayText = computed(() => {
  if (selectedLicenses.value.length === 0) {
    return '未选择'
  } else {
    const licenseNames = {
      'open': '开放使用',
      'non-commercial': '非商业混音',
      'commercial': '商业使用',
      'commercial-remix': '商业混音'
    }
    return selectedLicenses.value.map(license => 
      licenseNames[license as keyof typeof licenseNames]
    ).join(', ')
  }
})

// 选择资产类型
const selectAssetType = (type: string) => {
  // Only show confirmation when there are already files uploaded
  if (uploadedFiles.value.length > 0 && selectedAssetType.value && selectedAssetType.value !== type) {
    // Ask for confirmation to change asset type and delete current files
    if (confirm(`切换到${type === 'image' ? '图片' : type === 'video' ? '视频' : type === 'audio' ? '音频' : '文字'}类将会清除当前已上传的文件，确定要继续吗？`)) {
      // Clear all existing uploaded files
      while (uploadedFiles.value.length > 0) {
        removeFile(0);
      }
      // Reset any error messages
      showFileTypeError.value = false;
      // Set new asset type
      selectedAssetType.value = type;
    }
    // If user cancels, keep current asset type
    return;
  }
  
  // Reset any error messages when changing asset types
  showFileTypeError.value = false;
  // Set new asset type
  selectedAssetType.value = type;
}

// 验证文件类型是否符合当前选择的资产类型
const isValidFileType = (file: File) => {
  const fileType = file.type.toLowerCase();
  
  switch (selectedAssetType.value) {
    case 'image':
      return fileType.startsWith('image/');
    case 'video':
      return fileType.startsWith('video/');
    case 'audio':
      return fileType.startsWith('audio/');
    case 'text':
      return fileType.startsWith('text/') || 
             fileType === 'application/pdf' || 
             fileType === 'application/msword' || 
             fileType === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    default:
      return false;
  }
}

// 文件上传处理函数
const triggerFileUpload = () => {
  if (fileInput.value) {
    fileInput.value.click()
  }
}

// State for file type error message
const showFileTypeError = ref(false)
const fileTypeErrorMessage = ref('')

// 添加拖拽相关状态和函数
const draggedItem = ref<number | null>(null);
const draggedOverItem = ref<number | null>(null);

// 开始拖拽
const dragStart = (index: number, event: DragEvent) => {
  if (event.dataTransfer) {
    // 设置拖拽效果和数据
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/plain', index.toString());
    draggedItem.value = index;
    
    // 延迟添加拖拽样式，避免立即添加导致拖拽图像消失
    setTimeout(() => {
      if (event.target instanceof HTMLElement) {
        event.target.classList.add('dragging');
      }
    }, 0);
  }
}

// 拖拽进入其他元素
const dragEnter = (index: number, event: DragEvent) => {
  if (draggedItem.value !== null && draggedItem.value !== index) {
    draggedOverItem.value = index;
    if (event.currentTarget instanceof HTMLElement) {
      event.currentTarget.classList.add('drag-over');
    }
  }
}

// 拖拽离开元素
const dragLeave = (event: DragEvent) => {
  if (event.currentTarget instanceof HTMLElement) {
    event.currentTarget.classList.remove('drag-over');
  }
}

// 放置元素
const drop = (index: number, event: DragEvent) => {
  if (draggedItem.value !== null && draggedItem.value !== index) {
    // 交换文件位置
    const temp = { ...uploadedFiles.value[draggedItem.value] };
    uploadedFiles.value.splice(draggedItem.value, 1);
    uploadedFiles.value.splice(index, 0, temp);
    
    // 更新selectedFile引用
    if (draggedItem.value === 0 || index === 0) {
      selectedFile.value = uploadedFiles.value[0].file;
    }
  }
  
  // 移除样式
  if (event.currentTarget instanceof HTMLElement) {
    event.currentTarget.classList.remove('drag-over');
  }
  
  draggedItem.value = null;
  draggedOverItem.value = null;
}

// 拖拽结束
const dragEnd = () => {
  draggedItem.value = null;
  draggedOverItem.value = null;
  // 移除所有拖拽样式
  document.querySelectorAll('.preview-file-item').forEach(item => {
    item.classList.remove('dragging', 'drag-over');
  });
}

// Update the file handlers to show error messages for wrong file types
const handleFileSelect = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (target.files && target.files.length > 0) {
    let hasInvalidFiles = false;
    // 处理多个文件
    for(let i = 0; i < target.files.length; i++) {
      const file = target.files[i]
      if (isValidFileType(file)) {
        addFileToPreview(file)
      } else {
        hasInvalidFiles = true;
      }
    }
    
    // Show error if any invalid files were detected
    if (hasInvalidFiles) {
      showFileTypeErrorMessage();
    }
    
    // 保持兼容性，设置第一个文件为selectedFile
    if (uploadedFiles.value.length > 0) {
      selectedFile.value = uploadedFiles.value[0].file
    }
  }
}

const onFileDrop = (event: DragEvent) => {
  if (event.dataTransfer && event.dataTransfer.files.length > 0) {
    let hasInvalidFiles = false;
    // 处理多个文件
    for(let i = 0; i < event.dataTransfer.files.length; i++) {
      const file = event.dataTransfer.files[i]
      if (isValidFileType(file)) {
        addFileToPreview(file)
      } else {
        hasInvalidFiles = true;
      }
    }
    
    // Show error if any invalid files were detected
    if (hasInvalidFiles) {
      showFileTypeErrorMessage();
    }
    
    // 保持兼容性，设置第一个文件为selectedFile
    if (uploadedFiles.value.length > 0) {
      selectedFile.value = uploadedFiles.value[0].file
    }
  }
}

// 添加文件到预览
const addFileToPreview = (file: File) => {
  const fileUrl = URL.createObjectURL(file);
  const fileIndex = uploadedFiles.value.length;
  uploadedFiles.value.push({
    name: file.name,
    type: file.type,
    url: fileUrl,
    file: file,
    duration: 0
  });
  
  // 加载音频元数据
  if (file.type.startsWith('audio/')) {
    loadAudioMetadata(file, fileIndex);
  }
}

// 移除文件
const removeFile = (index: number) => {
  // 释放URL对象
  URL.revokeObjectURL(uploadedFiles.value[index].url)
  // 移除文件
  uploadedFiles.value.splice(index, 1)
  // 如果没有文件了，清空selectedFile
  if (uploadedFiles.value.length === 0) {
    selectedFile.value = null
  } else if (index === 0 && uploadedFiles.value.length > 0) {
    // 如果删除的是第一个文件，更新selectedFile为新的第一个文件
    selectedFile.value = uploadedFiles.value[0].file
  }
}

// 添加共同创作者
const addCoCreator = () => {
  if (newCreatorName.value && newCreatorWallet.value) {
    coCreators.value.push({
      name: newCreatorName.value,
      wallet: newCreatorWallet.value
    })
    // 清空输入
    newCreatorName.value = ''
    newCreatorWallet.value = ''
  }
}

// 删除共同创作者
const removeCoCreator = (index: number) => {
  coCreators.value.splice(index, 1)
}

// 缩短钱包地址显示
const shortenWallet = (wallet: string) => {
  if (wallet.length > 12) {
    return wallet.slice(0, 6) + '...' + wallet.slice(-4)
  }
  return wallet
}

// 移除许可证
const removeLicense = (license: string) => {
  selectedLicenses.value = selectedLicenses.value.filter(item => item !== license)
  if (selectedLicenses.value.length > 0) {
    selectedLicense.value = selectedLicenses.value[0]
  } else {
    selectedLicense.value = ''
  }
  
  // 检查剩余的许可证组合是否有冲突
  checkCurrentLicenseCombination()
}

// 提交资产
const submitAsset = () => {
  // 如果选择了开放使用许可证且当前是许可证页面，跳转到AI权限页面
  if (currentPage.value === 'license' && selectedLicenses.value.includes('open')) {
    currentPage.value = 'aiPermissions'
    return
  }
  
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicenses.value)
  console.log('AI训练设置:', aiTrainingEnabled.value)
  // 这里可以添加提交到服务器的逻辑
  alert('资产提交成功!')
  currentPage.value = 'start'
}

// 导航功能
const goBack = () => {
  if (currentPage.value === 'assetDetails') {
    goToWorkType() // 在资产详情页面返回到作品类型选择页面
  } else if (currentPage.value === 'creators') {
    goToAssetDetails() // 在创作者页面返回到资产详情页面
  } else if (currentPage.value === 'license') {
    goToCreators() // 在许可证页面返回到创作者页面
    resetExpandedFilters() // 在离开许可证页面时清除展开状态
  } else if (currentPage.value === 'aiPermissions') {
    currentPage.value = 'license' // 从AI权限页面返回到许可证页面
  } else if (currentPage.value === 'reviewRegister') {
    currentPage.value = 'aiPermissions' // 从审核与注册页面返回到AI权限页面
  } else {
    goToStart() // 返回到首页
  }
}

const goNext = () => {
  if (currentPage.value === 'workType' && selectedWorkType.value) {
    // 从作品类型选择页面前进到资产详情页面
    goToAssetDetails()
  } else if (currentPage.value === 'assetDetails' && assetName.value && uploadedFiles.value.length > 0) {
    // 从资产详情页面前进到创作者页面
    goToCreators()
  } else if (currentPage.value === 'creators') {
    // 从创作者页面前进到许可证页面
    goToLicense()
  }
}

// Add this after the expandedFilters ref declaration
// 记录每个过滤器项的选择状态
const filterSelections = ref<Record<string, string | null>>({
  'ai-training': null,
  'commercial-use': null,
  'attribution': null,
  'remixing': null,
  'expiration': null,
  'licensing-fee': null
})

// 设置过滤器选项
const setFilterOption = (filterId: string, value: string) => {
  filterSelections.value[filterId] = value
}

// 清除过滤器选项
const clearFilterOption = (filterId: string) => {
  filterSelections.value[filterId] = null
}

// Add this after the clearFilterOption function
// 清除所有过滤器选项
const clearAllFilters = () => {
  Object.keys(filterSelections.value).forEach(key => {
    filterSelections.value[key] = null
  })
}

// Add these refs to track license fee values
const licensePrice = ref(0)
const revenueShare = ref(0)

// Update the filterSelections when license fee values change
const updateLicenseFee = () => {
  if (licensePrice.value > 0 || revenueShare.value > 0) {
    filterSelections.value['licensing-fee'] = 'custom'
  } else {
    filterSelections.value['licensing-fee'] = null
  }
}

// Clear license fee values
const clearLicenseFee = () => {
  licensePrice.value = 0
  revenueShare.value = 0
  filterSelections.value['licensing-fee'] = null
}

// 重置所有展开的过滤器状态为false
const resetExpandedFilters = () => {
  Object.keys(expandedFilters.value).forEach(key => {
    expandedFilters.value[key] = false
  })
}

// Show file type error message
const showFileTypeErrorMessage = () => {
  let fileTypesAllowed = '';
  switch (selectedAssetType.value) {
    case 'image':
      fileTypesAllowed = 'JPG、PNG、GIF、SVG、WEBP';
      break;
    case 'video':
      fileTypesAllowed = 'MP4、WEBM、MOV';
      break;
    case 'audio':
      fileTypesAllowed = 'WAV、MP3、FLAC、AAC、OGG、M4A、OPUS';
      break;
    case 'text':
      fileTypesAllowed = 'TXT、PDF、DOC、DOCX';
      break;
  }
  
  fileTypeErrorMessage.value = `只能上传${fileTypesAllowed}格式的文件`;
  showFileTypeError.value = true;
  
  // Auto-hide the error message after 3 seconds
  setTimeout(() => {
    showFileTypeError.value = false;
  }, 3000);
}

// 格式化时长
const formatDuration = (seconds: number) => {
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.floor(seconds % 60);
  return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
}

// 在加载音频文件时获取时长
const loadAudioMetadata = (file: File, index: number) => {
  if (file.type.startsWith('audio/')) {
    const audio = new Audio();
    audio.src = URL.createObjectURL(file);
    audio.onloadedmetadata = () => {
      uploadedFiles.value[index].duration = audio.duration;
    };
  }
};

// 获取音频格式
const getAudioFormat = (filename: string) => {
  const extension = filename.split('.').pop()?.toLowerCase() || '';
  
  switch (extension) {
    case 'mp3':
      return 'MP3';
    case 'wav':
      return 'WAV';
    case 'flac':
      return 'FLAC';
    case 'aac':
      return 'AAC';
    case 'ogg':
      return 'OGG';
    case 'm4a':
      return 'M4A';
    case 'opus':
      return 'OPUS';
    default:
      return 'Audio';
  }
}

// 关闭冲突弹窗
const closeConflictModal = () => {
  showLicenseConflictModal.value = false;
}

// 接受冲突
const acceptConflict = () => {
  // 在这里添加处理冲突的逻辑
  console.log('冲突已接受:', conflictModalData.value);
  closeConflictModal();
}

const getLicenseName = (license: string) => {
  const licenseNames = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音'
  }
  return licenseNames[license as keyof typeof licenseNames] || license;
}

// 检查当前许可证组合是否有冲突
const checkCurrentLicenseCombination = () => {
  // 检查是否包含开放使用许可证
  const hasOpenLicense = selectedLicenses.value.includes('open');
  
  // 检查是否包含其他许可证
  const hasOtherLicenses = selectedLicenses.value.some(license => 
    license === 'commercial' || license === 'commercial-remix' || license === 'non-commercial'
  );
  
  // 只有同时包含开放使用和其他许可证才算冲突
  if (hasOpenLicense && hasOtherLicenses) {
    const otherLicenses = selectedLicenses.value.filter(l => 
      ['commercial', 'commercial-remix', 'non-commercial'].includes(l)
    );
    
    // 声明冲突相关变量
    let conflictingLicense = '';
    let conflictingWithLicense = '';
    let reason = '';
    
    // 根据数量决定保留哪一类
    if (otherLicenses.length >= 1) {
      // 保留其他许可证，移除开放使用
      selectedLicenses.value = otherLicenses;
      conflictingLicense = 'open';
      conflictingWithLicense = otherLicenses[0];
      reason = '开放使用（完全免费无限制）与其他许可证类型互斥。系统已移除开放使用许可证。';
    } else {
      // 保留开放使用，移除其他许可证
      selectedLicenses.value = ['open'];
      conflictingLicense = otherLicenses[0];
      conflictingWithLicense = 'open';
      reason = '其他许可证类型与开放使用（完全免费无限制）互斥。系统已移除其他许可证。';
    }
    
    // 更新selectedLicense以匹配
    if (selectedLicenses.value.length > 0) {
      selectedLicense.value = selectedLicenses.value[0];
    } else {
      selectedLicense.value = '';
    }
    
    // 显示冲突提示
    showLicenseConflictAlert(conflictingLicense, [conflictingWithLicense], reason);
    
    return true;
  }
  
  return false;
}

// 添加AI训练设置状态
const aiTrainingEnabled = ref(true) // 默认允许AI训练

// 添加AI设置页面处理函数
const handleAISettingsSubmit = () => {
  // 跳转到审核与注册页面
  currentPage.value = 'reviewRegister'
}

// 处理资产注册
const handleRegistration = () => {
  // 完成注册流程
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicenses.value)
  console.log('AI训练设置:', aiTrainingEnabled.value)
  // 这里可以添加提交到服务器的逻辑
  alert('资产注册成功!')
  currentPage.value = 'start'
}

// 获取文件类型显示
const getFileTypeDisplay = (fileType: string) => {
  switch (fileType) {
    case 'image/jpeg':
    case 'image/png':
    case 'image/gif':
    case 'image/svg+xml':
    case 'image/webp':
      return '图片';
    case 'video/mp4':
    case 'video/webm':
    case 'video/quicktime':
      return '视频';
    case 'audio/wav':
    case 'audio/mpeg':
    case 'audio/flac':
    case 'audio/aac':
    case 'audio/ogg':
    case 'audio/mp4':
    case 'audio/opus':
      return '音频';
    case 'text/plain':
    case 'application/pdf':
    case 'application/msword':
    case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      return '文字';
    default:
      return '未知';
  }
}

// 添加许可证详情弹窗状态
const showLicenseDetailModal = ref(false);
const currentLicenseDetail = ref({
  license: '',
  name: '',
  summary: ''
});

// 打开许可证详情弹窗
const openLicenseDetail = (license: string) => {
  const licenseDetails = {
    'open': {
      name: '开放使用',
      summary: '开放域是一种公共贡献工具，它允许创作者放弃版权，将作品放入全球公共域。使用者可以在任何媒介或格式中分发、混音、改编和构建作品，无需任何条件。'
    },
    'non-commercial': {
      name: '非商业混音',
      summary: '任何人都可以使用您的作品创建非商业项目。他们可以修改、调整和构建您的作品，但必须标明原创者，且不能将作品用于商业目的。'
    },
    'commercial': {
      name: '商业使用',
      summary: '允许他人按照您设定的经济条款使用您的作品。使用者必须支付许可费和/或版税，但不允许对您的作品进行修改或创建衍生作品。'
    },
    'commercial-remix': {
      name: '商业混音',
      summary: '允许他们混音您的作品，同时您获得认可和收益。使用者可以修改和构建您的作品，但必须支付许可费和/或版税，同时标明您是原创者。'
    }
  };
  
  currentLicenseDetail.value = {
    license,
    name: licenseDetails[license as keyof typeof licenseDetails].name,
    summary: licenseDetails[license as keyof typeof licenseDetails].summary
  };
  
  showLicenseDetailModal.value = true;
};

// 关闭许可证详情弹窗
const closeLicenseDetailModal = () => {
  showLicenseDetailModal.value = false;
};

// 更新license-search-btn点击事件
const handleLicenseSearch = (license: string) => {
  openLicenseDetail(license);
};

// 在资产主要信息之间添加开放许可信息展示
const showLicenseInfoMap = ref({})

const toggleLicenseInfo = (index: number) => {
  showLicenseInfoMap.value[index] = !showLicenseInfoMap.value[index]
}
</script>

<style scoped>
/* 隐藏所有滚动条 */
::-webkit-scrollbar {
  display: none;
}

html, body {
  overflow: hidden;
  margin: 0;
  padding: 0;
}

.app-container {
  width: 100vw;
  height: 100vh;
  box-sizing: border-box;
  background: #3a3a3a; /* Changed from gradient to solid gray */
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  color: white;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
}

.blur-container {
  width: 90vw;
  max-width: 1280px;
  height: 90vh;
  backdrop-filter: blur(30px);
  -webkit-backdrop-filter: blur(30px);
  background: rgba(60, 60, 60, 0.15);
  overflow: hidden;
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

/* 启动页面样式 */
.start-page {
  width: 100%;
  height: 100%;
  padding: 60px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

/* Glass card design from Uiverse.io by codebykay101 */
.menu-options {
  display: flex;
  gap: 0;
  margin-top: 60px;
  position: relative;
  justify-content: center;
  align-items: center;
}

.menu-card {
  position: relative;
  width: 180px;
  height: 200px;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7)); /* Darker background */
  border: 1px solid rgba(100, 100, 100, 0.35); /* Darker border */
  box-shadow: 0 25px 25px rgba(0, 0, 0, 0.35); /* Darker shadow */
  display: flex;
  justify-content: center;
  align-items: center;
  transition: 0.5s;
  border-radius: 10px;
  margin: 0 -45px;
  backdrop-filter: blur(15px);
  cursor: pointer;
}

.menu-card:nth-child(1) {
  transform: rotate(-8deg);
  --r: -8;
}

.menu-card:nth-child(2) {
  transform: rotate(0deg);
  --r: 0;
  z-index: 10;
}

.menu-card:nth-child(3) {
  transform: rotate(8deg);
  --r: 8;
}

.menu-options:hover .menu-card {
  transform: rotate(0deg);
  margin: 0 15px;
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75)); /* Darker hover state */
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
}

.menu-card:hover {
  transform: translateY(-10px) !important;
  border: 1px solid rgba(150, 150, 150, 0.5); /* Brighter border on hover */
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8)); /* Even darker on individual hover */
}

.menu-card::before {
  content: attr(data-text);
  position: absolute;
  bottom: 0;
  width: 100%;
  height: 40px;
  background: rgba(30, 30, 30, 0.75); /* Darker label background */
  display: flex;
  justify-content: center;
  align-items: center;
  color: #fff;
  font-weight: 500;
  font-size: 16px;
}

/* Remove the icon-wrapper styles */
.icon-wrapper {
  display: none;
}

/* Restore the menu-icon styles without the wrapper */
.menu-icon {
  width: 50px;
  height: 50px;
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
  opacity: 1;
  filter: invert(1) drop-shadow(0 2px 3px rgba(0, 0, 0, 0.3));
  margin-bottom: 40px; /* Add bottom margin to push the icon up from the text */
}

/* Restore the specific icon styles */
.people-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='1' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2'%3E%3C/path%3E%3Ccircle cx='9' cy='7' r='4'%3E%3C/circle%3E%3Cpath d='M23 21v-2a4 4 0 0 0-3-3.87'%3E%3C/path%3E%3Cpath d='M16 3.13a4 4 0 0 1 0 7.75'%3E%3C/path%3E%3C/svg%3E");
}

.product-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='1' stroke-linecap='round' stroke-linejoin='round'%3E%3Crect x='3' y='3' width='18' height='18' rx='2' ry='2'%3E%3C/rect%3E%3Ccircle cx='8.5' cy='8.5' r='1.5'%3E%3C/circle%3E%3Cpolyline points='21 15 16 10 5 21'%3E%3C/polyline%3E%3C/svg%3E");
}

.task-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='1' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolygon points='12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2'%3E%3C/polygon%3E%3C/svg%3E");
}

/* Hide the menu title since we're using data-text */
.menu-title {
  display: none;
}

@media (max-width: 900px) {
  .menu-options {
    flex-direction: column;
    gap: 40px;
    margin-top: 40px;
  }
  
  .menu-card {
    width: 180px;
    height: 200px;
    margin: 0;
    transform: rotate(0deg) !important;
    background: linear-gradient(rgba(255, 255, 255, 0.35), rgba(255, 255, 255, 0.15)); /* Brighter on mobile */
  }
  
  .menu-options:hover .menu-card {
    margin: 0;
    box-shadow: 0 25px 25px rgba(0, 0, 0, 0.35);
  }
  
  .menu-card:hover {
    transform: translateY(-5px) !important; /* Reduced lift effect on mobile */
  }
}

.info-panel {
  display: flex;
  align-items: center;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  padding: 16px 25px;
  margin-top: auto;
  margin-bottom: 35px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(100, 100, 100, 0.35);
  cursor: pointer;
  height: 60px;
}

.info-icon {
  width: 36px;
  height: 36px;
  background-color: rgba(50, 50, 50, 0.7);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 18px;
  flex-shrink: 0;
}

.coin-emoji {
  font-size: 20px;
}

.info-text {
  flex: 1;
}

.info-text h3 {
  margin: 0 0 3px 0;
  font-size: 16px;
  font-weight: 600;
}

.info-text p {
  margin: 0;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
}

.info-arrow {
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: 15px;
  color: rgba(255, 255, 255, 0.6);
  font-size: 16px;
}

/* 许可证容器样式 */
.license-container {
  width: 100%;
  height: 100%;
  padding: 40px 50px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  background-color: #212121;
  overflow-y: auto;
}

.header {
  margin-bottom: 32px;
  flex-shrink: 0;
  text-align: center;
}

h1 {
  font-size: 34px;
  margin: 0 0 12px 0;
  font-weight: 600;
  letter-spacing: -0.5px;
}

.subtitle-zh {
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
  font-size: 16px;
  line-height: 1.5;
  text-align: left;
}

.tabs {
  display: flex;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  margin-bottom: 20px;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
}

.tab {
  padding: 12px 20px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.6);
  position: relative;
  font-size: 15px;
  font-weight: 500;
  transition: color 0.2s;
}

.tab:hover {
  color: #ddd;
}

.tab.active {
  color: white;
}

.tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 2px;
  background: #000000;
}

.license-options {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  flex: 1;
  overflow-y: visible; /* 移除滚动效果 */
  padding-right: 10px;
  padding-bottom: 10px;
  position: relative;
  z-index: 1;
  min-height: 0;
  margin-bottom: 20px;
  height: auto; /* 自适应高度 */
}

.license-card {
  flex: 1;
  height: auto; /* 自适应高度 */
  min-height: 180px;
  background: rgba(60, 60, 65, 0.5);
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  padding: 0;
  position: relative;
  overflow: hidden; /* 改为hidden以控制内容 */
  display: flex;
  flex-direction: column;
  box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.1);
  cursor: pointer;
  box-sizing: border-box; /* 确保padding不会增加卡片宽度 */
}

.license-card:hover {
  background: rgba(70, 70, 75, 0.6);
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(255, 255, 255, 0.3);
}

.license-card.selected {
  border: 1px solid #fff;
  background: rgba(80, 80, 85, 0.6);
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.25);
}

.license-card h2 {
  font-size: 22px;
  margin: 8px 24px 12px;
  font-weight: 600;
}

.license-header {
  padding: 20px 24px 0 24px;
  margin-bottom: 0;
}

.license-content {
  padding: 0 24px;
  margin-bottom: 20px;
  flex: 1;
  min-height: auto; /* 允许内容自适应 */
}

.license-description-zh {
  margin: 0;
  font-size: 15px;
  line-height: 1.5;
  color: #bbb;
}

.license-footer {
  margin-top: auto;
  display: flex;
  justify-content: space-between;
  align-items: center; /* 确保垂直居中 */
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 16px; /* 减小水平内边距 */
  width: 100%; /* 确保宽度撑满 */
  box-sizing: border-box; /* 确保padding不会增加宽度 */
  flex-wrap: nowrap; /* 防止元素换行 */
  min-height: 54px; /* 确保足够的高度 */
}

.license-icons {
  display: flex;
  gap: 10px; /* 更小的图标间距 */
  flex-wrap: nowrap; /* 防止图标换行 */
  max-width: calc(100% - 40px); /* 留出空间给检查指示器 */
}

.icon {
  width: 22px; /* 稍微减小图标尺寸 */
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.6;
  flex-shrink: 0; /* 防止图标缩小 */
  font-size: 14px; /* 减小图标字体大小 */
}

.check-indicator {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 50%;
  color: white;
  font-size: 14px;
  font-weight: 500;
}

.navigation {
  margin-top: auto;
  display: flex;
  justify-content: space-between;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
  padding-top: 30px;
}

.back-btn, .next-btn {
  padding: 10px 20px;
  border-radius: 25px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s;
}

.back-btn {
  background: rgba(255, 255, 255, 0.15);
  color: white;
  backdrop-filter: blur(5px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.back-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.next-btn {
  background: white;
  color: #222;
  box-shadow: 0 5px 12px rgba(0, 0, 0, 0.1);
}

.next-btn:hover {
  background: #f0f0f0;
  transform: translateY(-2px);
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
}

.next-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.arrow {
  font-size: 16px;
  line-height: 1;
}

.custom-license, .license-assistant {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow: visible;
  padding-bottom: 20px;
}

.placeholder-content {
  max-width: 600px;
  color: #bbb;
}

.placeholder-content h2 {
  margin-bottom: 20px;
}

.placeholder-content p {
  font-size: 18px;
  line-height: 1.6;
}

@media (max-width: 1200px) {
  .license-options {
    gap: 20px;
  }
  
  .license-card {
    padding: 0;
  }
  
  .menu-options {
    gap: 30px;
  }
  
  .menu-card {
    width: 200px;
    height: 280px;
  }
}

@media (max-width: 900px) {
  .license-options {
    grid-template-columns: 1fr;
    gap: 15px;
  }
  
  .license-container {
    padding: 30px 25px;
  }
  
  .license-card {
    min-height: auto;
    height: auto;
  }
  
  .selected-licenses-header {
    grid-column: span 1;
  }
  
  .license-content {
    margin-bottom: 16px;
  }
  
  .license-footer {
    padding: 15px 20px;
  }
  
  .menu-options {
    flex-direction: column;
    gap: 40px;
    margin-top: 40px;
  }
  
  .menu-card {
    width: 190px;
    height: 254px;
  }
  
  .icon-wrapper {
    width: 80px;
    height: 80px;
    margin-bottom: 0;
    margin-right: 30px;
  }
  
  .start-page {
    padding: 30px;
  }
  
  .work-type-options {
    flex-direction: column;
  }
  
  .work-type-card {
    width: 100%;
  }
}

@media (max-width: 480px) {
  .license-options {
    padding-right: 0;
  }
  
  .license-card {
    min-height: auto;
  }
  
  .license-card h2 {
    font-size: 18px;
    margin: 6px 16px 8px;
  }
  
  .license-header {
    padding: 15px 16px 0 16px;
  }
  
  .license-content {
    padding: 0 16px;
    margin-bottom: 15px;
  }
  
  .license-footer {
    padding: 12px 14px; /* 进一步减小内边距 */
  }
  
  .license-description-zh {
    font-size: 14px;
  }
  
  /* 增加小屏幕下的图标处理 */
  .license-icons {
    gap: 10px; /* 在小屏幕上进一步减小图标间距 */
  }
  
  .icon {
    width: 20px; /* 稍微减小图标尺寸 */
    height: 20px;
    font-size: 12px; /* 减小图标字体大小 */
  }
}

/* 资产详情页面样式 */
.asset-details-container {
  width: 100%;
  height: 100%;
  padding: 40px 50px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  overflow: auto;
  background-color: #212121;
  color: white;
}

.form-group {
  margin-bottom: 30px;
}

.form-group label {
  display: block;
  font-size: 18px;
  font-weight: 500;
  margin-bottom: 12px;
}

.description-help {
  font-size: 14px;
  color: #a1a1aa;
  margin: 5px 0 0 0;
  font-weight: normal;
}

.input-field {
  width: 100%;
  padding: 15px;
  background-color: rgba(60, 60, 65, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 16px;
  transition: all 0.2s;
}

.input-field:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.3);
  background-color: rgba(70, 70, 75, 0.6);
}

.textarea-field {
  width: 100%;
  padding: 15px;
  background-color: rgba(60, 60, 65, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 16px;
  resize: vertical;
  min-height: 100px;
  font-family: inherit;
  transition: all 0.2s;
}

.textarea-field:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.3);
  background-color: rgba(70, 70, 75, 0.6);
}

.upload-tabs {
  display: flex;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  margin-bottom: 20px;
}

.upload-tab {
  padding: 12px 20px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.6);
  position: relative;
  font-size: 15px;
  font-weight: 500;
  transition: color 0.2s;
}

.upload-tab:hover {
  color: #ddd;
}

.upload-tab.active {
  color: white;
}

.upload-tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 2px;
  background: white;
}

.asset-type-section {
  margin-bottom: 30px;
}

.asset-type-grid {
  display: flex;
  justify-content: space-between;
  gap: 15px;
  margin-bottom: 30px;
  flex-wrap: wrap;
}

.asset-type-card {
  flex: 1;
  min-width: 150px;
  background: rgba(60, 60, 65, 0.5);
  border-radius: 12px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.asset-type-card:hover {
  background: rgba(70, 70, 75, 0.6);
  transform: translateY(-3px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.asset-type-card.selected {
  border: 1px solid #fff;
  background: rgba(80, 80, 85, 0.6);
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.25);
}

.asset-type-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
}

.type-icon {
  font-size: 24px;
  color: white;
}

.asset-type-name {
  font-size: 16px;
  font-weight: 500;
  margin-top: 8px;
  color: #ffffff;
}

.upload-area-container {
  margin-top: 20px;
}

/* 上传区域样式 */
.upload-section {
  margin-bottom: 30px;
}

.upload-header h3 {
  font-size: 18px;
  margin: 0 0 10px 0;
}

.file-types {
  margin: 0 0 5px 0;
  font-size: 14px;
  color: #a1a1aa;
}

.file-size {
  margin: 0 0 15px 0;
  font-size: 14px;
  color: #a1a1aa;
}

.upload-area {
  border: 2px dashed #e53935;
  border-radius: 12px;
  padding: 40px 20px;
  text-align: center;
  cursor: pointer;
  background: rgba(229, 57, 53, 0.05);
  transition: all 0.2s;
}

.upload-area:hover {
  background: rgba(229, 57, 53, 0.1);
  transform: translateY(-3px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.upload-icons {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-bottom: 15px;
  min-height: 24px;
}

.upload-icon {
  font-size: 24px;
}

.upload-text {
  margin: 5px 0;
  color: #ddd;
}

.hidden-file-input {
  display: none;
}

.wallet-section {
  margin-bottom: 30px;
  padding: 20px;
  background-color: rgba(60, 60, 65, 0.5);
  border-radius: 12px;
  text-align: center;
}

.wallet-placeholder {
  padding: 40px;
  border: 1px dashed rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  margin-top: 20px;
}

.file-required {
  color: #e53935;
  margin: 10px 0 0 0;
  font-size: 14px;
}

.subtitle-zh {
  font-size: 0.85em;
  opacity: 0.8;
  margin-left: 8px;
  font-weight: normal;
}

@media (max-width: 768px) {
  .asset-details-container {
    padding: 30px 20px;
  }
  
  .asset-type-grid {
    flex-direction: column;
    gap: 10px;
  }
  
  .asset-type-card {
    width: 100%;
    flex-direction: row;
    padding: 12px;
    align-items: center;
    justify-content: flex-start;
  }
  
  .asset-type-icon {
    width: 40px;
    height: 40px;
    margin-bottom: 0;
    margin-right: 15px;
  }
  
  .upload-icons {
    gap: 15px;
  }
  
  .upload-area {
    padding: 30px 15px;
  }
}

/* 上传预览样式 */
.uploaded-files-preview {
  margin-bottom: 20px;
}

.preview-files-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
  margin-bottom: 20px;
}

/* 为音频类型添加单列网格布局 */
.preview-files-grid.audio-grid {
  grid-template-columns: 1fr;
  gap: 10px;
}

.preview-file-item {
  position: relative;
  background-color: rgba(30, 30, 35, 0.5);
  border-radius: 8px;
  overflow: hidden;
  aspect-ratio: 1 / 1;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
  cursor: grab;
}

/* 音频文件特殊样式 - 横向列表布局 */
.preview-file-item.audio-file {
  aspect-ratio: auto;
  height: auto;
  display: flex;
  flex-direction: column;
  cursor: default;
  background-color: #12121a;
  padding: 0;
}

.preview-file-item.audio-file:hover {
  background-color: #18181f;
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
}

.preview-file-item:hover {
  border-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.preview-file-item.dragging {
  opacity: 0.6;
  border: 2px dashed rgba(255, 255, 255, 0.5);
  transform: scale(0.95);
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.preview-file-item.drag-over {
  border: 2px solid rgba(255, 255, 255, 0.7);
  transform: scale(1.05);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
  position: relative;
}

.preview-file-item.drag-over::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.1);
  z-index: 2;
  pointer-events: none;
}

.drag-handle {
  position: absolute;
  top: 5px;
  left: 5px;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius: 4px;
  color: white;
  cursor: grab;
  opacity: 0;
  transition: opacity 0.2s;
  z-index: 2;
}

.preview-file-item:hover .drag-handle {
  opacity: 0.8;
}

.drag-handle:hover {
  opacity: 1 !important;
  background-color: rgba(70, 70, 70, 0.9);
}

.drag-icon {
  font-size: 12px;
  font-weight: bold;
  user-select: none;
}

.drag-hint {
  text-align: center;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  margin: 8px 0 0;
  font-style: italic;
}

.preview-file-content {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.preview-video {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-media {
  max-width: 100%;
  max-height: 100%;
}

.preview-audio {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  background-color: #12121a;
  border-radius: 8px;
  overflow: hidden;
  padding: 16px;
  cursor: default;
  position: relative;
}

/* 音频文件的特殊样式 */
.preview-file-item.audio-file .preview-audio {
  min-height: auto;
  padding: 10px 14px;
  height: auto;
  width: 100%;
}

.audio-track-row {
  display: flex;
  align-items: center;
  width: 100%;
  gap: 16px;
  margin-bottom: 12px;
}

.audio-left {
  display: flex;
  align-items: center;
}

.audio-play-circle {
  width: 40px;
  height: 40px;
  background-color: #18181f;
}

.play-button {
  width: 32px;
  height: 32px;
}

.play-icon {
  color: white;
  font-size: 14px;
  margin-left: 2px;
}

.audio-info {
  flex: 1;
  overflow: hidden;
}

.audio-title-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.audio-title {
  font-size: 14px;
  font-weight: 500;
  color: white;
  margin-bottom: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
}

.audio-menu-dots {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 0 8px;
  transition: color 0.2s;
}

.audio-menu-dots:hover {
  color: white;
}

.audio-subtitle {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 4px;
}

.audio-details {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  width: 100%;
  gap: 10px;
}

.audio-format {
  background-color: rgba(80, 80, 255, 0.2);
  padding: 1px 6px;
  font-size: 11px;
}

.audio-duration {
  font-size: 11px;
}

.audio-waveform {
  margin-top: 0;
}

.waveform-display {
  width: 100%;
  height: 32px;
  background: rgba(30, 30, 40, 0.5);
  border-radius: 4px;
  position: relative;
  overflow: hidden;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.waveform-display::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.05) 2px,
    rgba(255, 255, 255, 0.05) 3px,
    transparent 3px,
    transparent 4px,
    rgba(255, 255, 255, 0.1) 4px,
    rgba(255, 255, 255, 0.1) 5px,
    transparent 5px,
    transparent 7px,
    rgba(255, 255, 255, 0.15) 7px,
    rgba(255, 255, 255, 0.15) 8px,
    transparent 8px,
    transparent 10px,
    rgba(255, 255, 255, 0.2) 10px,
    rgba(255, 255, 255, 0.2) 11px,
    transparent 11px,
    transparent 14px,
    rgba(255, 255, 255, 0.1) 14px,
    rgba(255, 255, 255, 0.1) 15px,
    transparent 15px,
    transparent 17px,
    rgba(255, 255, 255, 0.05) 17px,
    rgba(255, 255, 255, 0.05) 18px,
    transparent 18px,
    transparent 21px
  );
}

.waveform-progress {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  background: linear-gradient(
    90deg, 
    rgba(0, 0, 0, 0.5) 0%,
    rgba(0, 0, 0, 0.7) 100%
  );
  z-index: 1;
}

.waveform-progress::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.1) 2px,
    rgba(255, 255, 255, 0.1) 3px,
    transparent 3px,
    transparent 4px,
    rgba(255, 255, 255, 0.2) 4px,
    rgba(255, 255, 255, 0.2) 5px,
    transparent 5px,
    transparent 7px,
    rgba(255, 255, 255, 0.3) 7px,
    rgba(255, 255, 255, 0.3) 8px,
    transparent 8px,
    transparent 10px,
    rgba(255, 255, 255, 0.4) 10px,
    rgba(255, 255, 255, 0.4) 11px,
    transparent 11px,
    transparent 14px,
    rgba(255, 255, 255, 0.2) 14px,
    rgba(255, 255, 255, 0.2) 15px,
    transparent 15px,
    transparent 17px,
    rgba(255, 255, 255, 0.1) 17px,
    rgba(255, 255, 255, 0.1) 18px,
    transparent 18px,
    transparent 21px
  );
}

.preview-file-item.audio-file .waveform-display {
  height: 24px;
  background: rgba(20, 20, 35, 0.5);
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
  border-radius: 4px;
}

.preview-file-item.audio-file .waveform-display::before {
  background-image: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.03) 2px,
    rgba(255, 255, 255, 0.03) 3px,
    transparent 3px,
    transparent 4px,
    rgba(255, 255, 255, 0.06) 4px,
    rgba(255, 255, 255, 0.06) 5px,
    transparent 5px,
    transparent 6px,
    rgba(255, 255, 255, 0.09) 6px,
    rgba(255, 255, 255, 0.09) 7px,
    transparent 7px,
    transparent 9px,
    rgba(255, 255, 255, 0.12) 9px,
    rgba(255, 255, 255, 0.12) 10px,
    transparent 10px,
    transparent 13px,
    rgba(255, 255, 255, 0.06) 13px,
    rgba(255, 255, 255, 0.06) 14px,
    transparent 14px,
    transparent 16px,
    rgba(255, 255, 255, 0.03) 16px,
    rgba(255, 255, 255, 0.03) 17px,
    transparent 17px,
    transparent 19px
  );
}

.preview-file-item.audio-file .waveform-progress::before {
  background-image: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.05) 2px,
    rgba(255, 255, 255, 0.05) 3px,
    transparent 3px,
    transparent 4px,
    rgba(255, 255, 255, 0.1) 4px,
    rgba(255, 255, 255, 0.1) 5px,
    transparent 5px,
    transparent 6px,
    rgba(255, 255, 255, 0.15) 6px,
    rgba(255, 255, 255, 0.15) 7px,
    transparent 7px,
    transparent 9px,
    rgba(255, 255, 255, 0.2) 9px,
    rgba(255, 255, 255, 0.2) 10px,
    transparent 10px,
    transparent 13px,
    rgba(255, 255, 255, 0.1) 13px,
    rgba(255, 255, 255, 0.1) 14px,
    transparent 14px,
    transparent 16px,
    rgba(255, 255, 255, 0.05) 16px,
    rgba(255, 255, 255, 0.05) 17px,
    transparent 17px,
    transparent 19px
  );
}

/* 为音频文件添加特殊的拖拽手柄和删除按钮样式，使其位于右侧 */
.preview-file-item.audio-file .drag-handle {
  top: 50%;
  left: auto;
  right: 35px;
  transform: translateY(-50%);
  background-color: transparent;
  opacity: 0.4;
}

.preview-file-item.audio-file .remove-file-btn {
  top: 50%;
  right: 5px;
  transform: translateY(-50%);
  background-color: rgba(0, 0, 0, 0.3);
}

.preview-file-item.audio-file:hover .drag-handle,
.preview-file-item.audio-file:hover .remove-file-btn {
  opacity: 0.8;
}

.hidden-audio {
  display: none;
}

.preview-document {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 10px;
}

.document-icon {
  width: 50px;
  height: 50px;
  border-radius: 10px;
  background-color: rgba(100, 200, 100, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
}

.doc-icon {
  font-size: 30px;
}

.document-name {
  font-size: 12px;
  margin: 0;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  max-width: 100%;
}

.remove-file-btn {
  position: absolute;
  top: 5px;
  right: 5px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 14px;
  opacity: 0;
  transition: opacity 0.2s;
  z-index: 2;
}

.preview-file-item:hover .remove-file-btn {
  opacity: 1;
}

.remove-file-btn:hover {
  background-color: rgba(229, 57, 53, 0.8);
}

@media (max-width: 1024px) {
  .preview-files-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .preview-files-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  /* ... existing mobile styles ... */
}

@media (max-width: 480px) {
  .preview-files-grid {
    grid-template-columns: 1fr;
  }
}

/* 创作者页面样式 */
.creators-container {
  width: 100%;
  height: 100%;
  padding: 40px 50px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  overflow: auto;
  background-color: #212121;
  color: white;
}

.add-creators-section {
  margin-bottom: 30px;
  background-color: rgba(30, 30, 35, 0.3);
  border-radius: 12px;
  padding: 20px;
}

.add-creators-section h3 {
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 18px;
  font-weight: 500;
}

.creators-input-row {
  display: flex;
  gap: 15px;
  align-items: center;
}

.creator-input {
  flex: 1;
  background-color: rgba(20, 20, 25, 0.5);
}

.add-creator-btn {
  height: 50px;
  border-radius: 8px;
  background-color: #333;
  color: white;
  border: none;
  padding: 0 25px;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.add-creator-btn:hover:not(:disabled) {
  background-color: #444;
}

.add-creator-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.plus-icon {
  margin-left: 5px;
  font-size: 18px;
}

.creators-list-section {
  margin-bottom: 30px;
  flex: 1;
}

.creators-list-section h3 {
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 18px;
  font-weight: 500;
}

.creator-item {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.3);
  border-radius: 12px;
  padding: 15px;
  margin-bottom: 15px;
  position: relative;
}

.creator-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #2f2f2f;
  flex-shrink: 0;
}

.avatar-image {
  font-size: 28px;
}

.creator-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.creator-name {
  font-size: 17px;
  font-weight: 500;
}

.creator-role, .creator-wallet {
  font-size: 14px;
  color: #a1a1aa;
}

.remove-creator-btn {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 18px;
  transition: all 0.2s;
}

.remove-creator-btn:hover {
  background-color: rgba(229, 57, 53, 0.8);
}

@media (max-width: 768px) {
  .creators-container {
    padding: 30px 20px;
  }
  
  .creators-input-row {
    flex-direction: column;
  }
  
  .add-creator-btn {
    width: 100%;
  }
}

.license-filter-list {
  margin: 10px 0 30px;
  max-width: 900px;
  margin: 0 auto;
  padding: 10px 5px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
}

@media (max-width: 768px) {
  .license-filter-list {
    grid-template-columns: 1fr;
  }
}

.license-filter-item {
  display: flex;
  flex-direction: column;
  background-color: rgba(60, 60, 65, 0.5);
  border-radius: 14px;
  margin-bottom: 0;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  position: relative;
}

.license-filter-item.expanded {
  background-color: rgba(70, 70, 75, 0.6);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
  transform: translateY(-2px);
  z-index: 10;
  border-color: rgba(255, 255, 255, 0.2);
}

.filter-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 18px;
  cursor: pointer;
  position: relative;
  z-index: 2;
}

.filter-right {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 160px; /* Ensure the width is maintained even when status is hidden */
  justify-content: flex-end;
}

.expand-arrow {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.7);
  transition: transform 0.3s ease;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.expand-arrow span {
  display: inline-block;
  transition: all 0.3s ease;
}

.expand-arrow span.rotated {
  transform: rotate(180deg);
}

.filter-content {
  padding: 0 18px 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.07);
  background-color: rgba(70, 70, 75, 0.6);
  text-align: center;
  animation: fadeIn 0.2s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.filter-question {
  margin: 16px 0;
}

.filter-question h4 {
  font-size: 15px;
  font-weight: 500;
  margin: 0 0 8px 0;
  color: #fff;
}

.filter-question p {
  font-size: 13px;
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
}

.filter-description {
  margin-bottom: 16px;
  padding: 12px;
  background-color: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  text-align: left;
}

.en-description {
  font-size: 14px;
  margin: 0 0 5px 0;
  color: #fff;
}

.cn-description {
  font-size: 13px;
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
}

.filter-options {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 16px;
  justify-content: center;
}

.option-btn {
  min-width: 100px;
  padding: 8px 12px;
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background-color: rgba(24, 24, 28, 0.8);
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: center;
}

.option-btn:hover {
  background-color: rgba(35, 35, 40, 0.9);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.option-btn.selected {
  border-color: rgba(255, 255, 255, 0.4);
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.yes-btn.selected {
  background-color: rgba(0, 0, 0, 0.4);
  color: rgb(255, 255, 255);
}

.no-btn.selected {
  background-color: rgba(0, 0, 0, 0.4);
  color: rgb(255, 255, 255);
}

.expiration-btn.selected {
  background-color: rgba(0, 0, 0, 0.4);
}

.filter-clear {
  display: block;
  padding: 6px 16px;
  font-size: 13px;
  background-color: transparent;
  color: #fff;
  border: none;
  border-radius: 16px;
  cursor: pointer;
  margin-left: auto;
  transition: all 0.2s;
}

.filter-clear:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.license-filter-item:before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 3px;
  height: 100%;
  opacity: 0.9;
  transition: all 0.3s ease;
}

.license-filter-item:nth-child(1):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(2):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(3):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(4):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(5):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(6):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:hover:not(.expanded) {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
  background-color: rgba(70, 70, 75, 0.6);
}

.license-filter-item:hover:before {
  width: 5px;
}

.filter-left {
  display: flex;
  align-items: center;
  gap: 15px;
}

.filter-icon {
  font-size: 22px;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.filter-header:hover .filter-icon {
  transform: scale(1.05);
}

.filter-text {
  font-size: 16px;
  font-weight: 500;
  color: #fff;
  transition: color 0.3s;
}

.filter-status {
  padding: 8px 16px;
  border-radius: 30px;
  font-size: 14px;
  font-weight: 600;
  text-align: center;
  min-width: 110px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  opacity: 0;
  visibility: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
}

.license-filter-item.expanded .filter-status,
.filter-status.active {
  opacity: 1;
  visibility: visible;
}

.filter-header:hover .filter-status:before {
  opacity: 1;
}

.filter-status.allowed {
  background-color: rgba(0, 0, 0, 0.3);
  color: rgb(255, 255, 255);
}

.filter-status.required {
  background-color: rgba(0, 0, 0, 0.3);
  color: rgb(255, 255, 255);
}

.filter-status.never {
  background-color: rgba(0, 0, 0, 0.3);
  color: rgb(255, 255, 255);
}

.filter-status.off {
  background-color: rgba(0, 0, 0, 0.3);
  color: rgb(255, 255, 255);
}

.clear-btn-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.clear-all-btn {
  background-color: rgba(40, 40, 45, 0.6);
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 30px;
  padding: 10px 24px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 8px;
  position: relative;
  overflow: hidden;
  letter-spacing: 0.5px;
}

.clear-all-btn:hover {
  background-color: rgba(60, 60, 65, 0.8);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.clear-all-btn:active {
  transform: translateY(0);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
}

.custom-license {
  padding: 15px 30px;
  overflow: auto;
  display: flex;
  flex-direction: column;
  height: 100%;
  background-color: #212121;
}

.fee-input-container {
  width: 100%;
  margin-bottom: 10px;
}

.fee-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 6px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  overflow: hidden;
}

.fee-input {
  flex: 1;
  background: transparent;
  border: none;
  color: white;
  padding: 10px 12px;
  font-size: 16px;
  outline: none;
}

.fee-currency {
  padding: 10px 12px;
  background-color: rgba(0, 0, 0, 0.2);
  font-size: 14px;
  color: #bbb;
}

.expiration-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  width: 100%;
}

.expiration-btn {
  width: 100%;
  text-align: center;
}

.question-title {
  text-align: center;
  font-size: 18px;
  font-weight: 500;
  margin: 15px 0;
  color: #ffffff;
  background-color: #1e1e1e;
  padding: 10px;
  border-radius: 4px;
  width: 100%;
}

.start-container {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #3a3a3a;
  color: white;
  position: relative;
  overflow: hidden;
  padding: 20px;
}

.card-container {
  display: flex;
  gap: 20px;
  margin-top: 40px;
  justify-content: center;
  z-index: 1;
  background-color: rgba(80, 80, 80, 0.25);
  border-radius: 20px;
  padding: 50px;
  backdrop-filter: blur(5px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.menu-title {
  display: none;
}

@media (max-width: 900px) {
  .menu-options {
    flex-direction: column;
    gap: 30px;
    margin-top: 40px;
  }
  
  .menu-card {
    width: 180px;
    height: 200px;
    margin: 0;
    transform: rotate(0deg) !important;
    background: linear-gradient(rgba(255, 255, 255, 0.35), rgba(255, 255, 255, 0.15));
  }
  
  .menu-options:hover .menu-card {
    margin: 0;
    box-shadow: 0 25px 25px rgba(0, 0, 0, 0.35);
  }
  
  .menu-card:hover {
    transform: translateY(-5px) !important; /* Reduced lift effect on mobile */
  }
}

/* 作品类型选择页面样式 */
.work-type-container {
  width: 100%;
  height: 100%;
  padding: 70px 70px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background-color: #303030;
}

.title-with-subtitle {
  font-size: 27px;
  margin: 0 0 8px 0;
  font-weight: 600;
  text-align: center;
  color: white;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.subtitle-zh {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.6);
  margin: 0 0 50px 0;
  font-weight: normal;
  text-align: center;
}

.work-type-options {
  margin-top: 20px;
  display: flex;
  gap: 40px;
  flex-direction: row;
  justify-content: space-between;
}

.work-type-card {
  display: flex;
  flex-direction: column;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  padding: 0;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(100, 100, 100, 0.35);
  width: calc(50% - 15px);
  overflow: hidden;
  backdrop-filter: blur(15px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5);
  height: 180px;
  position: relative;
}

.work-type-content {
  padding: 30px 35px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  height: 100%;
}

.work-type-icon {
  width: 50px;
  height: 50px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 22px;
  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.25);
}

.work-type-content h2 {
  font-size: 22px;
  margin: 0 0 8px 0;
  display: flex;
  align-items: center;
  color: #ffffff;
}

.work-description {
  margin: 5px 0 0 0;
  color: rgba(255, 255, 255, 0.6);
  font-size: 15px;
  line-height: 1.5;
}

.navigation {
  margin-top: 60px;
  display: flex;
  justify-content: space-between;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
  padding-top: 40px;
}

.back-btn, .next-btn {
  padding: 12px 25px;
  border-radius: 30px;
  border: none;
  cursor: pointer;
  font-size: 15px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s;
}

/* License card styles */
.license-card::after {
  content: '添加此许可证 →';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 34px;
  background-color: #000;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px;
  font-weight: 400;
  opacity: 0;
  transition: opacity 0.2s ease;
  z-index: 10;
  letter-spacing: 0.2px;
}

.license-card:hover::after {
  opacity: 1;
}

.license-card.selected::after {
  content: '移除此许可证 ×';
  background-color: #1a1a1a;
}

.license-tag {
  display: inline-flex;
  align-items: center;
  padding: 3px 8px;
  border-radius: 15px;
  font-size: 12px;
  font-weight: 400;
  background-color: rgba(0, 0, 0, 0.6);
  color: rgba(255, 255, 255, 0.9);
}

.license-tag.blue {
  background-color: rgba(0, 0, 0, 0.7);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.license-tag.purple {
  background-color: rgba(0, 0, 0, 0.7);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.license-tag.green {
  background-color: rgba(0, 0, 0, 0.7);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.license-tag.red {
  background-color: rgba(0, 0, 0, 0.7);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.license-icon {
  margin-right: 6px;
  font-style: normal;
}

.work-type-card:hover {
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75));
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(150, 150, 150, 0.5);
}

.work-type-card.selected {
  border: 1px solid rgba(150, 150, 150, 0.7);
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8));
  transform: translateY(-8px);
  box-shadow: 0 30px 35px rgba(0, 0, 0, 0.4);
}

.work-type-icon.new-icon {
  background-color: #000000;
}

.work-type-icon.remix-icon {
  background-color: #000000;
}

.type-label {
  font-size: 12px;
  background-color: rgba(50, 50, 50, 0.6);
  padding: 3px 8px;
  border-radius: 15px;
  margin-left: 10px;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.9);
}

.asset-type-icon svg {
  width: 40px;
  height: 40px;
  fill: white;
  opacity: 0.9;
}

.asset-type-card.selected .asset-type-icon svg {
  fill: white;
  opacity: 1;
}

.placeholder-icon {
  display: none;
}

.asset-type-icon {
  display: none;
}

.asset-type-icon-container {
  display: none;
}

.empty-upload-icon {
  width: 24px;
  height: 24px;
  margin: 0 10px;
  display: inline-block;
}

.audio-placeholder {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background-color: rgba(100, 100, 255, 0.2);
  margin-bottom: 10px;
}

.document-placeholder {
  width: 50px;
  height: 50px;
  border-radius: 10px;
<template>
  <div class="app-container">
    <div class="blur-container">
      <!-- 启动页面 -->
      <div class="start-page" v-if="currentPage === 'start'">
        <div class="header">
          <h1>AETRIX开启您的IP发布</h1>
          <p class="subtitle-zh">选择您要进行的操作</p>
        </div>
        
        <div class="menu-options">
          <div class="menu-card" data-text="发布作品" @click="goToWorkType()">
            <div class="menu-icon product-icon"></div>
          </div>
          
          <div class="menu-card" data-text="发布任务" @click="showUnavailable('task')">
            <div class="menu-icon task-icon"></div>
          </div>
          
          <div class="menu-card" data-text="发布活动" @click="showUnavailable('activity')">
            <div class="menu-icon people-icon"></div>
          </div>
        </div>
      </div>

      <!-- 作品类型选择页面 -->
      <div class="work-type-container" v-if="currentPage === 'workType'">
        <!-- 标题部分 -->
        <div class="header">
          <h1 class="title-with-subtitle">选择作品类型（注册类型）</h1>
          <p class="subtitle-zh">请选择您要发布的作品类型</p>
        </div>

        <!-- 作品类型选项 -->
        <div class="work-type-options">
          <!-- 新IP选项 -->
          <div 
            class="work-type-card" 
            :class="{ selected: selectedWorkType === 'newIP' }"
            @click="selectWorkType('newIP')"
          >
            <div class="work-type-content">
              <div class="work-type-icon new-icon">
                <span class="icon-symbol">✦</span>
              </div>
              <h2>新IP <span class="type-label">新作品</span></h2>
              <p class="work-description">注册原创图片、视频或文字作品</p>
            </div>
          </div>

          <!-- 混音选项 -->
          <div 
            class="work-type-card"
            :class="{ selected: selectedWorkType === 'remix' }"
            @click="selectWorkType('remix')"
          >
            <div class="work-type-content">
              <div class="work-type-icon remix-icon">
                <span class="icon-symbol">↺</span>
              </div>
              <h2>混音 <span class="type-label">衍生作品</span></h2>
              <p class="work-description">注册与现有作品相关的衍生作品</p>
            </div>
          </div>
        </div>

        <!-- 提示信息区域 -->
        <div class="info-panel">
          <div class="info-icon">
            <span class="coin-emoji">🪙</span>
          </div>
          <div class="info-text">
            <h3>获取AETRIX币</h3>
            <p>您需要一定数量的AETRIX币用于支付gas和交易费用</p>
          </div>
          <div class="info-arrow">
            <span>→</span>
          </div>
        </div>

        <!-- 底部导航按钮 -->
        <div class="navigation">
          <button class="back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="next-btn" @click="goNext" :disabled="!selectedWorkType">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 许可证页面 -->
      <div class="license-container" v-if="currentPage === 'license'">
        <!-- 标题部分 -->
        <div class="header">
          <h1>添加许可证</h1>
          <p class="subtitle-zh">您最多可向此资产添加5个许可证</p>
        </div>

        <!-- 标签页切换 -->
        <div class="tabs">
          <div 
            v-for="(tab, index) in tabs" 
            :key="tab.id"
            :class="['tab', { active: activeTabIndex === index }]"
            @click="setActiveTab(index)"
          >
            {{ tab.label }}
          </div>
        </div>

        <!-- 许可证选项 -->
        <div v-if="activeTabIndex === 0" class="license-options">
          <!-- 显示已选择的许可证 -->
          <div class="selected-licenses-header">
            <h3>已选择的许可证: <span class="license-count">{{ selectedLicenses.length }}/5</span></h3>
            <div class="selected-licenses-list">
              <div v-if="selectedLicenses.length === 0" class="no-licenses">尚未选择许可证</div>
              <div v-else class="selected-license-tags">
                <span v-for="license in selectedLicenses" :key="license" class="selected-license-tag">
                  {{ license === 'open' ? '开放使用' : license === 'non-commercial' ? '非商业混音' : 
                     license === 'commercial' ? '商业使用' : '商业混音' }}
                  <span class="remove-tag" @click.stop="removeLicense(license)">×</span>
                </span>
              </div>
            </div>
          </div>

          <!-- 开放使用许可 -->
          <div 
            class="license-card" 
            :class="{ selected: selectedLicenses.includes('open') }"
            @click="selectLicense('open')"
          >
            <div class="license-header">
              <span class="license-tag blue">
                <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" id="ai" width="20" height="20" enable-background="new 0 0 48 48" version="1.1" viewBox="0 0 48 48" class="license-icon">
                  <g>
                    <path d="M26.2,32.5l-1.5-3.4h-6.6l-1.5,3.4h-3.7l6.8-15.7h3.4l6.8,15.7H26.2z M34.8,32.5h-3.4V20.4h3.4V32.5z M34.5,18.9c-0.4,0.4-0.9,0.6-1.4,0.6c-0.6,0-1-0.2-1.4-0.6c-0.4-0.4-0.6-0.9-0.6-1.4c0-0.6,0.2-1,0.6-1.4c0.4-0.4,0.9-0.6,1.4-0.6c0.6,0,1,0.2,1.4,0.6c0.4,0.4,0.6,0.9,0.6,1.4C35.1,18,34.9,18.5,34.5,18.9z"></path>
                    <polygon points="19.5 26 23.4 26 21.4 21.5"></polygon>
                  </g>
                </svg>
                限制最少
              </span>
            </div>
            <h2>开放使用</h2>
            <div class="license-content">
              <p class="license-description-zh">免费分发和混音，无限制、无收入要求、无归属要求</p>
            </div>
            <div class="license-footer license-footer-open">
              <div class="license-icons license-icons-open">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicenses.includes('open')">✓</div>
            </div>
          </div>

          <!-- 非商业Remix -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicenses.includes('non-commercial') }"
            @click="selectLicense('non-commercial')"
          >
            <div class="license-header">
              <span class="license-tag purple"><i class="license-icon">🏆</i> 为您的作品获得认可</span>
            </div>
            <h2>非商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">任何人都可使用您的作品创建非商业项目</p>
            </div>
            <div class="license-footer license-footer-noncommercial">
              <div class="license-icons license-icons-noncommercial">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicenses.includes('non-commercial')">✓</div>
            </div>
          </div>

          <!-- 商业使用 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicenses.includes('commercial') }"
            @click="selectLicense('commercial')"
          >
            <div class="license-header">
              <span class="license-tag green"><i class="license-icon">💲</i> 为您的作品获得报酬</span>
            </div>
            <h2>商业使用</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人按照您设定的经济条款使用您的作品</p>
            </div>
            <div class="license-footer license-footer-commercial">
              <div class="license-icons license-icons-commercial">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="限制混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicenses.includes('commercial')">✓</div>
            </div>
          </div>

          <!-- 商业混音 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicenses.includes('commercial-remix') }"
            @click="selectLicense('commercial-remix')"
          >
            <div class="license-header">
              <span class="license-tag red"><i class="license-icon">💰</i> 获得报酬与认可</span>
            </div>
            <h2>商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人混音您的作品，同时您获得认可和收益</p>
            </div>
            <div class="license-footer license-footer-commercial-remix">
              <div class="license-icons license-icons-commercial-remix">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicenses.includes('commercial-remix')">✓</div>
            </div>
          </div>
        </div>

        <!-- 自定义许可证标签页内容 -->
        <div v-else-if="activeTabIndex === 1" class="custom-license">
          <div class="license-filter-list">
            <!-- Licensing Fee 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['licensing-fee'] }">
              <div class="filter-header" @click="toggleFilter('licensing-fee')">
                <div class="filter-left">
                  <span class="filter-icon">💰</span>
                  <span class="filter-text">许可费用</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status off" :class="{ active: filterSelections['licensing-fee'] === 'custom' }">0%折扣</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['licensing-fee'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['licensing-fee']">
                <div class="filter-question">
                  <h4>此许可证的费用是多少？</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <div class="fee-input-container">
                    <div class="fee-label">许可证价格</div>
                    <div class="fee-input-wrapper">
                      <input type="number" class="fee-input" placeholder="0" min="0">
                      <span class="fee-currency">知识产权</span>
                    </div>
                  </div>
                  <div class="fee-input-container">
                    <div class="fee-label">收入分成</div>
                    <div class="fee-input-wrapper">
                      <input type="number" class="fee-input" placeholder="0" min="0" max="100">
                      <span class="fee-currency">%</span>
                    </div>
                  </div>
                </div>
                <button class="filter-clear">清除</button>
              </div>
            </div>
            
            <!-- Attribution 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['attribution'] }">
              <div class="filter-header" @click="toggleFilter('attribution')">
                <div class="filter-left">
                  <span class="filter-icon">📝</span>
                  <span class="filter-text">标明来源</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status required" :class="{ active: filterSelections['attribution'] === 'yes' }">必填</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['attribution'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['attribution']">
                <div class="filter-question">
                  <h4 class="question-title">使用此模型时，必须标明来源或作者。</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <button 
                    :class="['option-btn', 'yes-btn', { selected: filterSelections['attribution'] === 'yes' }]"
                    @click="setFilterOption('attribution', 'yes')"
                  >
                    是的
                  </button>
                  <button 
                    :class="['option-btn', 'no-btn', { selected: filterSelections['attribution'] === 'no' }]"
                    @click="setFilterOption('attribution', 'no')"
                  >
                    不
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('attribution')">清除</button>
              </div>
            </div>
            
            <!-- Remixing 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['remixing'] }">
              <div class="filter-header" @click="toggleFilter('remixing')">
                <div class="filter-left">
                  <span class="filter-icon">🔄</span>
                  <span class="filter-text">混合创新</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status allowed" :class="{ active: filterSelections['remixing'] === 'yes' }">允许</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['remixing'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['remixing']">
                <div class="filter-question">
                  <h4 class="question-title">允许对模型进行修改、组合或重新创作。</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <button 
                    :class="['option-btn', 'yes-btn', { selected: filterSelections['remixing'] === 'yes' }]"
                    @click="setFilterOption('remixing', 'yes')"
                  >
                    是的
                  </button>
                  <button 
                    :class="['option-btn', 'no-btn', { selected: filterSelections['remixing'] === 'no' }]"
                    @click="setFilterOption('remixing', 'no')"
                  >
                    不
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('remixing')">清除</button>
              </div>
            </div>
            
            <!-- Expiration 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['expiration'] }">
              <div class="filter-header" @click="toggleFilter('expiration')">
                <div class="filter-left">
                  <span class="filter-icon">⏱️</span>
                  <span class="filter-text">到期时间</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status never" :class="{ active: filterSelections['expiration'] !== null }">从不</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['expiration'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['expiration']">
                <div class="filter-question">
                  <h4>此许可证何时到期?</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options expiration-options">
                  <button 
                    :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === 'never' }]"
                    @click="setFilterOption('expiration', 'never')"
                  >
                    从不
                  </button>
                  <button 
                    :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === '1year' }]"
                    @click="setFilterOption('expiration', '1year')"
                  >
                    1年
                  </button>
                  <button 
                    :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === '6month' }]"
                    @click="setFilterOption('expiration', '6month')"
                  >
                    6个月
                  </button>
                  <button 
                    :class="['option-btn', 'expiration-btn', { selected: filterSelections['expiration'] === 'custom' }]"
                    @click="setFilterOption('expiration', 'custom')"
                  >
                    选择日期
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('expiration')">清除</button>
              </div>
            </div>
            
            <!-- Commercial Use 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['commercial-use'] }">
              <div class="filter-header" @click="toggleFilter('commercial-use')">
                <div class="filter-left">
                  <span class="filter-icon">💼</span>
                  <span class="filter-text">商业使用</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status allowed" :class="{ active: filterSelections['commercial-use'] === 'yes' }">允许</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['commercial-use'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['commercial-use']">
                <div class="filter-question">
                  <h4 class="question-title">允许将此作品应用于商业目的。</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <button 
                    :class="['option-btn', 'yes-btn', { selected: filterSelections['commercial-use'] === 'yes' }]"
                    @click="setFilterOption('commercial-use', 'yes')"
                  >
                    是的
                  </button>
                  <button 
                    :class="['option-btn', 'no-btn', { selected: filterSelections['commercial-use'] === 'no' }]"
                    @click="setFilterOption('commercial-use', 'no')"
                  >
                    不
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('commercial-use')">清除</button>
              </div>
            </div>
            
            <!-- AI Training 选项 -->
            <div class="license-filter-item" :class="{ expanded: expandedFilters['ai-training'] }">
              <div class="filter-header" @click="toggleFilter('ai-training')">
                <div class="filter-left">
                  <span class="filter-icon">🤖</span>
                  <span class="filter-text">AI训练</span>
                </div>
                <div class="filter-right">
                  <div class="filter-status allowed" :class="{ active: filterSelections['ai-training'] === 'yes' }">允许</div>
                  <div class="expand-arrow">
                    <span :class="{ rotated: expandedFilters['ai-training'] }">▼</span>
                  </div>
                </div>
              </div>
              <div class="filter-content" v-if="expandedFilters['ai-training']">
                <div class="filter-question">
                  <h4 class="question-title">允许将此产品用于AI训练。</h4>
                </div>
                <div class="filter-description">
                </div>
                <div class="filter-options">
                  <button 
                    :class="['option-btn', 'yes-btn', { selected: filterSelections['ai-training'] === 'yes' }]"
                    @click="setFilterOption('ai-training', 'yes')"
                  >
                    是的
                  </button>
                  <button 
                    :class="['option-btn', 'no-btn', { selected: filterSelections['ai-training'] === 'no' }]"
                    @click="setFilterOption('ai-training', 'no')"
                  >
                    不
                  </button>
                </div>
                <button class="filter-clear" @click="clearFilterOption('ai-training')">清除</button>
              </div>
            </div>
          </div>
          
          <div class="clear-btn-container">
            <button class="clear-all-btn" @click="clearAllFilters">全部清除</button>
          </div>
        </div>

        <!-- 许可证助手标签页内容 -->
        <div v-else-if="activeTabIndex === 2" class="license-assistant">
          <div class="placeholder-content">
            <h2>许可证助手</h2>
            <p>回答几个问题，我们将帮助您选择最合适的许可证</p>
          </div>
        </div>

        <!-- 底部导航按钮 -->
        <div class="navigation">
          <button class="back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="next-btn" @click="submitAsset" :disabled="selectedLicenses.length === 0 && activeTabIndex === 0">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 资产详情页面 -->
      <div class="asset-details-container" v-if="currentPage === 'assetDetails'">
        <!-- 标题部分 -->
        <div class="header">
          <h1>添加资产详细信息</h1>
        </div>

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
              class="asset-type-card"
              :class="{ 
                selected: selectedAssetType === 'video',
                disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== 'video'
              }"
              @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === 'video' ? selectAssetType('video') : null"
            >
              <div class="asset-type-content">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60" id="video" class="monitor-svg">
                  <path fill="#ffffff" d="M52 7H8c-1.1 0-2 .9-2 2v28h48V9c0-1.1-.9-2-2-2zM36.45 23.89l-12 6c-.14.07-.3.11-.45.11a.999.999 0 0 1-1-1V17c0-.35.18-.67.47-.85.3-.18.67-.2.98-.04l12 6c.34.16.55.51.55.89s-.21.73-.55.89zM54 39v4c0 1.1-.9 2-2 2H37v6h3c.55 0 1 .45 1 1s-.45 1-1 1H20c-.55 0-1-.45-1-1s.45-1 1-1h3v-6H8c-1.1 0-2-.9-2-2v-4h48z"></path>
                </svg>
                <p class="asset-type-name">视频类</p>
              </div>
            </div>
            
            <div 
              class="asset-type-card"
              :class="{ 
                selected: selectedAssetType === 'image',
                disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== 'image'
              }"
              @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === 'image' ? selectAssetType('image') : null"
            >
              <div class="asset-type-content">
                <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 60 60" viewBox="0 0 60 60" id="picture" class="monitor-svg">
                  <path d="M8.0050049,38.2349854V14.8150024c0-1.2700195,0.8900146-2.3500366,2.0899658-2.6199951V10.164978
                    c-2.2999878,0.289978-4.0899658,2.2600098-4.0899658,4.6500244v27.3200073c0,2.5799561,2.0999756,4.6799927,4.6799927,4.6799927
                    h11.8499756v3.7299805h-2.6699829c-0.5599976,0-1,0.4500122-1,1c0,0.5599976,0.4400024,1,1,1h16.5900269
                    c0.0100098,0,0.0100098,0,0.0100098,0h3.6699829c0.5499878,0,1-0.4400024,1-1c0-0.5499878-0.4500122-1-1-1h-2.6799927v-3.7299805
                    h11.8599854c2.25,0,4.1400146-1.6100464,4.5800171-3.7399902c0.0700073-0.3099976,0.0999756-0.6300049,0.0999756-0.960022
                    V14.8150024c0-2.3699951-1.789978-4.3400269-4.0899658-4.6400146v2.0299683
                    c1.1999512,0.2800293,2.0899658,1.3500366,2.0899658,2.6100464v23.4199829H8.0050049z M26.9949951,43.2349854
                    c-0.1900024,0.1900024-0.4400024,0.289978-0.710022,0.289978c-0.2599487,0-0.5199585-0.0999756-0.6999512-0.289978
                    c-0.1900024-0.1900024-0.3000488-0.4400024-0.3000488-0.710022c0-0.2599487,0.1100464-0.5199585,0.3000488-0.7099609
                    c0.3699951-0.3699951,1.039978-0.3699951,1.4099731,0c0.1900024,0.1900024,0.289978,0.4500122,0.289978,0.7099609
                    C27.2849731,42.7849731,27.1849976,43.0449829,26.9949951,43.2349854z M30.7050171,43.2349854
                    c-0.1900024,0.1900024-0.4400024,0.289978-0.710022,0.289978c-0.2600098,0-0.5200195-0.0999756-0.710022-0.289978
                    c-0.1799927-0.1900024-0.289978-0.4400024-0.289978-0.710022c0-0.2599487,0.1099854-0.5199585,0.289978-0.7099609
                    c0.3800049-0.3699951,1.0500488-0.3699951,1.4200439,0.0100098c0.1799927,0.1799927,0.289978,0.4400024,0.289978,0.6999512
                    C30.9949951,42.7949829,30.8850098,43.0449829,30.7050171,43.2349854z M34.414978,43.2349854
                    c-0.1900024,0.1900024-0.4499512,0.289978-0.7099609,0.289978c-0.2700195,0-0.5200195-0.0999756-0.710022-0.289978
                    c-0.1799927-0.1900024-0.289978-0.4400024-0.289978-0.710022c0-0.2599487,0.1099854-0.5199585,0.289978-0.6999512
                    c0.3699951-0.3800049,1.039978-0.3800049,1.4199829-0.0100098c0.1799927,0.1900024,0.2900391,0.4500122,0.2900391,0.7099609
                    C34.7050171,42.7949829,34.5949707,43.0449829,34.414978,43.2349854z"></path>
                  <path d="M12.0949707,8.4549561v25.222229l9.5981445-16.9112549c0.1894531-0.3330078,0.5527954-0.5292969,0.9345703-0.5043945
                    c0.3828125,0.0249023,0.7167969,0.2661133,0.8613281,0.6210938l5.000061,12.2808838l7.9412842-12.0186768
                    c0.1895142-0.2871094,0.5127563-0.4702148,0.8575439-0.4482422c0.343689,0.0078125,0.6591187,0.1918945,0.8358765,0.487793
                    l9.78125,16.4194946V8.4549561c0-0.5499878-0.4400024-1-1-1H13.0949707
                    C12.5349731,7.4549561,12.0949707,7.9049683,12.0949707,8.4549561z M34.3660278,16.079895
                    c0.390564,0.390625,0.390564,1.0234375,0,1.4140625c-0.390625,0.390625-1.0235596,0.390625-1.4141235,0
                    c-0.3730469-0.3730469-1.0244141-0.3725586-1.3955078-0.0004883c-0.1875,0.1879883-0.4423828,0.293457-0.7080078,0.293457
                    s-0.5195313-0.1054688-0.7070313-0.2929688c-0.3720703-0.3725586-1.0234985-0.3745117-1.3974609,0
                    c-0.390625,0.390625-1.0234375,0.390625-1.4141235,0c-0.390564-0.390625-0.390564-1.0234375,0-1.4140625
                    c0.9169922-0.9180298,2.406311-1.1185913,3.5186157-0.5259399C31.9577637,14.9621582,33.4489746,15.1629028,34.3660278,16.079895z
                    M22.65802,12.8900146c0.9501953-0.9492188,2.3866577-1.1260376,3.5174561-0.5235596
                    c1.1298828-0.6009521,2.5684204-0.425293,3.5176392,0.5235596c0.390686,0.390564,0.390686,1.0238647,0,1.4144897
                    c-0.1953125,0.1952515-0.4511108,0.2929688-0.7070313,0.2929688s-0.5117188-0.0977173-0.7069702-0.2924805
                    c-0.3848267-0.3848267-1.0118408-0.3848267-1.3965454,0c-0.390564,0.3897095-1.0234985,0.3897095-1.4140625,0
                    c-0.3847046-0.3848267-1.0117188-0.3848267-1.3964844,0c-0.390625,0.3897095-1.0234375,0.3900757-1.4140015-0.0004883
                    C22.2672729,13.9138794,22.2672729,13.2805786,22.65802,12.8900146z"></path>
                  <path d="M29.402771,31.4075928l1.5198364,3.7327881c0.0072632,0.0178833,0.0041504,0.036499,0.010498,0.0545654h15.5913086
                    L37.220459,19.5764771L29.402771,31.4075928z"></path>
                  <polygon points="13.534 35.195 28.786 35.195 22.415 19.547"></polygon>
                </svg>
                <p class="asset-type-name">图片类</p>
              </div>
            </div>
            
            <div 
              class="asset-type-card"
              :class="{ 
                selected: selectedAssetType === 'audio',
                disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== 'audio' 
              }"
              @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === 'audio' ? selectAssetType('audio') : null"
            >
              <div class="asset-type-content">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" id="AudioRecording" class="monitor-svg">
                  <path fill="#ffffff" d="M56.64 7.86H38.48V11l18.15-.06A4.31 4.31 0 0 1 61 15.2v29.42H3V15.2a4.31 4.31 0 0 1 4.32-4.29h18.19V7.86H7.36A7.36 7.36 0 0 0 0 15.2V49a7.21 7.21 0 0 0 7.19 7.2h15.54v1.4L19.85 61a1.39 1.39 0 0 0 1 2.32h22.73a1.41 1.41 0 0 0 1.27-.82 1.38 1.38 0 0 0-.22-1.5l-2.88-3.36v-1.4h15.06A7.21 7.21 0 0 0 64 49V15.2a7.36 7.36 0 0 0-7.36-7.34ZM32.23 52.45a2 2 0 1 1 2-2 2 2 0 0 1-2 2Z"></path>
                  <path fill="#ffffff" d="M23.66 14.71h1.86v-3h-3.38a1.51 1.51 0 0 0-1 .37 1.53 1.53 0 0 0-.52 1.15v9.87a11.33 11.33 0 0 0 9.86 11.28v5.19H28.6a1.53 1.53 0 0 0 0 3h6.8a1.53 1.53 0 1 0 0-3h-1.88v-5.23a11.47 11.47 0 0 0 9.87-11.28v-9.87a1.51 1.51 0 0 0-1.52-1.52H39l-.51.05v3h1.87v8.35a8.37 8.37 0 0 1-7 8.23 1.52 1.52 0 0 0-1.19-.89h-.37a1.49 1.49 0 0 0-1.18.88 8.37 8.37 0 0 1-7-8.23Z"></path>
                  <path fill="#ffffff" d="M28.89 5.87a.31.31 0 0 1-.31.31h-2.25v4h2.25a.3.3 0 1 1 0 .6h-2.25v2.12h11.34v-2.13h-2.24a.3.3 0 0 1 0-.6h2.24v-4h-2.24a.31.31 0 0 1 0-.61h2.27l-.3-.93a5.66 5.66 0 0 0-10.79 0l-.3.93h2.27a.31.31 0 0 1 .31.31zM32 25.77a5.64 5.64 0 0 0 5.39-3.93l.3-.93h-2.26a.29.29 0 0 1-.3-.3.29.29 0 0 1 .3-.31h2.24v-4h-2.24a.29.29 0 0 1-.3-.3.28.28 0 0 1 .3-.3h2.24v-2.16H26.33v2.17h2.25a.3.3 0 1 1 0 .6h-2.25v4h2.25a.31.31 0 0 1 .31.31.31.31 0 0 1-.31.3h-2.27l.3.93A5.64 5.64 0 0 0 32 25.77z"></path>
                </svg>
                <p class="asset-type-name">音频类</p>
              </div>
            </div>
            
            <div 
              class="asset-type-card"
              :class="{ 
                selected: selectedAssetType === 'text',
                disabled: uploadedFiles.length > 0 && selectedAssetType && selectedAssetType !== 'text'
              }"
              @click="!uploadedFiles.length || !selectedAssetType || selectedAssetType === 'text' ? selectAssetType('text') : null"
            >
              <div class="asset-type-content">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" id="file" class="monitor-svg">
                  <path fill="#ffffff" d="M2 44v3a3.003 3.003 0 0 0 3 3h54a3.003 3.003 0 0 0 3-3v-3Zm52 4a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm3 0a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm-15 9a3.003 3.003 0 0 1-3 3H25a3 3 0 0 1 0-6h.28l.666-2h12.108l.667 2H39a3.003 3.003 0 0 1 3 3Zm3.384-44H36V4.555ZM35 15a1 1 0 0 1-1-1V4H21a3.003 3.003 0 0 0-3 3v31a3.003 3.003 0 0 0 3 3h22a3.003 3.003 0 0 0 3-3V15ZM23 32a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm0-4a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm0-4a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm0-4a1 1 0 1 1 1-1 1 1 0 0 1-1 1Zm18 12H27a1 1 0 0 1 0-2h14a1 1 0 0 1 0 2Zm0-4H27a1 1 0 0 1 0-2h14a1 1 0 0 1 0 2Zm0-4H27a1 1 0 0 1 0-2h14a1 1 0 0 1 0 2Zm0-4H27a1 1 0 0 1 0-2h14a1 1 0 0 1 0 2Zm21-6v28h-4V16a1 1 0 0 0-1-1h-9v-1c.066-1.285-.93-2.252-1.849-3H59a3.003 3.003 0 0 1 3 3Zm-46 1H7a1 1 0 0 0-1 1v26H2V14a3.003 3.003 0 0 1 3-3h11Z"></path>
                </svg>
                <p class="asset-type-name">文字类</p>
              </div>
            </div>
          </div>
          
          <!-- 选择了资产类型后显示上传区域 -->
          <div v-if="selectedAssetType" class="upload-area-container">
            <div class="upload-header">
              <h3>上传文件</h3>
              <p class="file-types">支持的文件类型:</p>
              <p class="file-types" v-if="selectedAssetType === 'image'">JPG、PNG、GIF、SVG、WEBP</p>
              <p class="file-types" v-if="selectedAssetType === 'video'">MP4、WEBM、MOV</p>
              <p class="file-types" v-if="selectedAssetType === 'audio'">WAV、MP3、FLAC、AAC、OGG、M4A、OPUS</p>
              <p class="file-types" v-if="selectedAssetType === 'text'">TXT、PDF、DOC、DOCX</p>
              <p class="file-size">最大大小1000MB</p>
              <p class="upload-type-info">
                <span class="info-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 500 500" viewBox="0 0 500 500" id="warning">
                    <path fill="#ffffff" d="M174.504,338.955c0.613,0.028,1.227,0.05,1.841,0.05c8.9,0,17.86-2.915,25.343-8.915
                      c6.918-5.545,11.535-12.896,13.723-20.837c-1.731-1.286-3.409-2.659-5.009-4.141c-11.073-10.254-17.801-24.205-18.945-39.289
                      c-1.206-15.891,3.863-31.295,14.273-43.388c10.396-12.076,24.869-19.376,40.753-20.581l75.852-5.73L182.657,28.593
                      c-14.346-17.205-39.921-19.526-57.128-5.179c-17.206,14.345-19.525,39.922-5.179,57.128l57.304,68.731
                      c-8.733-0.501-17.691,1.796-25.431,7.172c-13.448,9.34-19.489,25.354-16.783,40.481c-11.574-2.55-24.155-0.039-34.121,7.95
                      c-15.995,12.821-19.698,35.282-9.476,52.399c-8.464,0.897-16.717,4.45-23.41,10.714c-16.357,15.306-17.208,40.974-1.902,57.331
                      l37.815,40.409c7.986,8.534,18.792,12.847,29.625,12.847c9.931,0,19.884-3.625,27.706-10.945
                      C169.961,359.878,174.26,349.468,174.504,338.955z"></path>
                    <path fill="#ffffff" d="M389.153,266.233l0.161-12.322c0-11.29-4.832-22.07-13.113-29.746c-2.959-2.743-6.345-4.992-9.903-6.722
                      c0,0-8.355-4.266-18.92-4.072c-0.637,0.012-99.464,7.489-99.464,7.489c-22.338,1.694-39.169,21.176-37.474,43.513
                      c1.268,16.723,12.412,30.298,27.3,35.359c0.058-0.019,0.114-0.035,0.172-0.055c3.772,1.295,7.779,2.048,11.924,2.17
                      c0.059,0.001,0.117,0.003,0.175,0.004c0.44,0.011,46.85-3.41,46.85-3.41c5.462-0.418,10.125,3.901,10.125,9.38l0,0
                      c0,3.773-2.237,7.059-5.505,8.551c-5.698,4.216-54.935,41.873-57.694,85.181c-0.322,5.053-4.521,8.937-9.515,8.937
                      c-0.204,0-0.409-0.007-0.616-0.02c-5.26-0.335-9.253-4.871-8.918-10.131c2.128-33.416,25.274-62.516,43.632-80.577
                      c0,0-34.612,0.509-36.64,0.737c-3.786,9.498-9.984,17.977-18.1,24.483c-6.733,5.398-14.567,9.248-22.864,11.326
                      c-3.056,9.548-8.512,18.208-16.046,25.258c-9.343,8.743-21.089,14.161-33.636,15.657l58.992,57.96
                      c40.421,40.421,105.955,40.421,146.375,0l42.64-42.577C429.51,372.187,429.573,306.653,389.153,266.233z"></path>
                  </svg>
                </span>
                <span>您已选择{{ selectedAssetType === 'image' ? '图片' : selectedAssetType === 'video' ? '视频' : selectedAssetType === 'audio' ? '音频' : '文字' }}类，仅能上传对应类型的文件。上传文件后将无法切换类别。</span>
              </p>
            </div>

            <!-- 上传文件预览区域 -->
            <div v-if="uploadedFiles.length > 0" class="uploaded-files-preview">
              <div :class="['preview-files-grid', selectedAssetType === 'audio' ? 'audio-grid' : '']">
                <div 
                  v-for="(file, index) in uploadedFiles" 
                  :key="index" 
                  :class="['preview-file-item', file.type.startsWith('audio/') ? 'audio-file' : '']"
                  draggable="true"
                  @dragstart="dragStart(index, $event)"
                  @dragover.prevent
                  @dragenter.prevent="dragEnter(index, $event)"
                  @dragleave.prevent="dragLeave($event)"
                  @drop.prevent="drop(index, $event)"
                  @dragend="dragEnd()"
                >
                  <div class="preview-file-content">
                    <!-- 图片预览 -->
                    <img v-if="file.type.startsWith('image/')" :src="file.url" class="preview-image" />
                    
                    <!-- 视频预览 -->
                    <div v-else-if="file.type.startsWith('video/')" class="preview-video">
                      <video :src="file.url" controls class="preview-media"></video>
                    </div>
                    
                    <!-- 音频预览 -->
                    <div v-else-if="file.type.startsWith('audio/')" class="preview-audio">
                      <div class="audio-top-row">
                        <div class="audio-play-btn">
                          <div class="play-button">
                            <span class="play-icon">▶</span>
                          </div>
                        </div>
                        <div class="audio-info">
                          <div class="audio-top-section">
                            <div class="audio-title">{{ file.name.split('.')[0] }}</div>
                            <div class="audio-menu-dots">⋮</div>
                          </div>
                          <div class="audio-subtitle">上传音频</div>
                          <div class="audio-details">
                            <span class="audio-format">{{ getAudioFormat(file.name) }}</span>
                            <span class="audio-duration">{{ formatDuration(file.duration || 0) }}</span>
                          </div>
                        </div>
                      </div>
                      <div class="audio-waveform">
                        <div class="waveform-display">
                          <div class="waveform-progress" :style="{ width: '30%' }"></div>
                        </div>
                      </div>
                      <audio :src="file.url" class="hidden-audio" ref="audioPlayer"></audio>
                    </div>
                    
                    <!-- 文档预览 -->
                    <div v-else class="preview-document">
                      <div class="document-placeholder"></div>
                      <p class="document-name">{{ file.name }}</p>
                    </div>
                  </div>
                  
                  <!-- 拖拽手柄 -->
                  <div class="drag-handle">
                    <span class="drag-icon">⋮⋮</span>
                  </div>
                  
                  <!-- 删除按钮 -->
                  <button class="remove-file-btn" @click="removeFile(index)" title="移除文件">×</button>
                </div>
              </div>
              <p class="drag-hint">提示：可拖动文件调整顺序</p>
            </div>

            <div class="upload-area" @click="triggerFileUpload" @dragover.prevent @drop.prevent="onFileDrop">
              <div class="upload-icons">
                <div class="empty-upload-icon"></div>
              </div>
              <p class="upload-text">在此处浏览或拖放您的文件</p>
              <input 
                type="file" 
                ref="fileInput" 
                class="hidden-file-input"
                @change="handleFileSelect"
                multiple
                :accept="fileTypeAccept"
              >
            </div>
            <p v-if="uploadedFiles.length === 0" class="file-required">需要文件</p>
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
        <div class="form-group">
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
        <div class="navigation">
          <button class="back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="next-btn" @click="goNext" :disabled="!assetName || uploadedFiles.length === 0">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 创作者信息页面 -->
      <div class="creators-container" v-if="currentPage === 'creators'">
        <div class="header">
          <h1>创造者</h1>
          <p class="subtitle">将共同创建者添加到此资产（可选）</p>
        </div>

        <!-- 添加共同创作者 -->
        <div class="add-creators-section">
          <h3>添加共同创作者</h3>
          <div class="creators-input-row">
            <input 
              type="text" 
              class="input-field creator-input" 
              placeholder="输入名称搜索"
              v-model="newCreatorName"
            >
            <input 
              type="text" 
              class="input-field creator-input" 
              placeholder="输入用户ID搜索"
              v-model="newCreatorWallet"
            >
            <button 
              class="add-creator-btn" 
              @click="addCoCreator"
              :disabled="!newCreatorName || !newCreatorWallet"
            >
              添加 <span class="plus-icon">+</span>
            </button>
          </div>
        </div>

        <!-- 创作者列表 -->
        <div class="creators-list-section">
          <h3>创作者</h3>
          
          <!-- 当前用户（管理员） -->
          <div class="creator-item current-user">
            <div class="creator-avatar">
              <div class="avatar-image">😀</div>
            </div>
            <div class="creator-info">
              <div class="creator-name">你</div>
              <div class="creator-role">管理</div>
            </div>
          </div>
          
          <!-- 共同创作者列表 -->
          <div v-for="(creator, index) in coCreators" :key="index" class="creator-item">
            <div class="creator-avatar">
              <div class="avatar-image">👤</div>
            </div>
            <div class="creator-info">
              <div class="creator-name">{{ creator.name }}</div>
              <div class="creator-wallet">{{ shortenWallet(creator.wallet) }}</div>
            </div>
            <button class="remove-creator-btn" @click="removeCoCreator(index)">×</button>
          </div>
        </div>

        <!-- 底部导航按钮 -->
        <div class="navigation">
          <button class="back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="next-btn" @click="goNext">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- AI权限设置页面 -->
      <div class="ai-permissions-container" v-if="currentPage === 'aiPermissions'">
        <div class="ai-permissions-header">
          <h1 class="ai-title-main">AI 权限设置</h1>
          <p class="ai-subtitle">控制您的IP是否包含在AI训练程序中</p>
        </div>
        
        <div class="ai-card">
          <div class="ai-card-row">
            <div class="ai-card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 50 50" id="ai" width="36" height="36">
                <path fill="#ffffff" d="M28.5 26.6c-.3-.1-.6-.1-.8-.2-.1.3-.2.7-.3 1.1.3-.3.7-.6 1.1-.9z"></path>
                <path fill="#ffffff" d="M23.2 36.8c.1-3.3 1.4-6.2 3.4-8.4v-.5c0-.5 0-.9.1-1.4-.8.1-1.5.3-2.4.5.3-.5.8-.8 1.3-1.1.5-.3 1.1-.4 1.7-.4.6 0 1.2.2 1.7.5 0 0 .1.1.2.1 2.2-1.5 4.9-2.4 7.7-2.4h.7s0-.1.1-.1c.5-1.6.2-3.4-.6-4.7-.2-.2-.3-.5-.5-.7-.9.8-1.9 1.4-3 1.8-.7.3-1.4.5-2.2.5-.8 0-1.6-.1-2.2-.6.7.2 1.4 0 2.1-.1.7-.2 1.3-.4 1.9-.7 1-.4 2-.8 3.1-1.3-.1-.1-.1-.3-.1-.4v-.3c0-.7 1.2-2.6.3-5.2-.5-1.2-1.3-2.3-2.2-3.3-.2-.2-.4-.5-.6-.7-.8.6-1.6 1.1-2.3 1.7-.5.4-1 .8-1.3 1.3-.4.5-.7 1-1 1.7-.1-.7 0-1.4.3-2.1.3-.7.8-1.2 1.4-1.6.6-.5 1.2-.8 1.8-1 .3-.1.5-.2.8-.3-.4-.5-1-1.2-1.6-2-.6-.8-1.2-1.6-2.1-2.1h-.1c-1.8-.9-3.8-.3-5.7-1-.7-.3-1.2-.7-1.8-1-.5-.2-.9-.3-1.4-.4v7.2h.8c.5 0 1-.2 1.4-.4.5-.2.9-.5 1.3-.9s.7-.8 1.1-1.2c-.3.3-.6.8-.9 1.2-.4.4-.8.8-1.2 1.1-.5.3-1 .6-1.6.7-.3.1-.6.2-1 .2v8.8c.1 0 .2-.1.3-.2.5-.3 1-.5 1.5-.6.5-.1 1.1-.1 1.6 0 .5.2.9.5 1.3.9-.4-.3-.8-.6-1.3-.6s-1 0-1.4.2c-.4.2-.9.4-1.2.7-.2.2-.5.4-.7.6V39c.5.6 1.2 1.1 1.9 1.3.3.1.7.2 1 .2-.3-1.2-.4-2.4-.4-3.7zM15.4 2.3c-1.9.7-4 .1-5.8 1-1 .6-1.6 1.6-2.4 2.5-.6.7-1 1.2-1.2 1.5 1.4.7 2.9 1.8 3.7 3.2.3.6.5 1.3.6 2-.3-2-2.1-3.3-3.9-4.1-.3-.2-.7-.3-1-.4-1 1.2-2.1 2.4-2.6 3.9-.2.6-.3 1.2-.4 1.9 0 .7.1 1.5.3 2.2.2.3.3.7.3 1.1 0 .2 0 .3-.1.5.9.7 1.9 1.2 3 1.7.7.3 1.4.6 2 .7.7.1 1.4.2 2.1-.1-.6.4-1.4.5-2.1.4-.3 0-.6-.1-.9-.1-.4-.1-.9-.2-1.3-.3-1.1-.4-2.2-.8-3.2-1.4-.1.2-.2.3-.3.5-.9 1.5-1.1 3.2-.6 4.7.9 3 1.3 1.5 1.6 5.6 0 .2 0 .5.1.7.2 1.6 1 3 2.1 4.1 1 1 2.4 1.6 3.4 2.5.7.7 1.3 1.5 2.1 2.1.5.4 1 .7 1.6.9.8.7 1.8 1.1 2.9 1.1.5 0 1-.1 1.4-.3.6-.2 1.1-.5 1.6-.9l.2-.2.2-.2V18.8c-.2-.2-.4-.4-.7-.6-.4-.3-.8-.5-1.2-.7-.4-.2-.9-.3-1.4-.2-.5.1-.9.3-1.3.6.3-.4.8-.7 1.3-.9.5-.2 1-.1 1.6 0s1 .3 1.5.6c.1 0 .2.1.3.2V9c-.3 0-.6-.1-.9-.1-.6-.1-1.1-.4-1.6-.7-.5-.3-.9-.7-1.2-1.1-.4-.4-.6-.9-.9-1.4.3.4.7.8 1.1 1.2.4.3.8.7 1.3.9.5.2 1 .4 1.4.4h.8V.8c-.5.1-1 .2-1.4.5-.9.3-1.5.7-2.1 1zm.3 33.6c-.9.3-1.5.6-2 1.1-.2.2-.4.5-.7.9-.1.2-.2.3-.3.5-.1.2-.2.4-.4.6-.3-.9-.1-1.9.6-2.7.4-.4.8-.6 1.3-.7.6 0 1.1.1 1.5.3zm-.6-9c-.9-.2-1.7-.4-2.4-.5.1.5.1.9.1 1.4 0 .6-.1 1.1-.3 1.7-.2.5-.5 1-.9 1.4-.4.4-.9.7-1.3.9.4-.3.9-.6 1.1-1.1.3-.4.5-.9.6-1.4.1-.5.1-1 0-1.5s-.2-1-.3-1.4c-.8.1-1.6.4-2.5.9.2-.5.6-1 1.1-1.4.5-.4 1.1-.5 1.7-.5.6 0 1.2.1 1.7.4.6.3 1 .7 1.4 1.1z"></path>
                <path fill="#ffffff" d="M37.5 25.7c-6.5-.3-12 4.7-12.3 11.2-.3 6.5 4.7 12 11.2 12.3 6.5.3 12-4.7 12.3-11.2.3-6.5-4.7-12-11.2-12.3zm2 16c-.1.2-.3.2-.6.2s-.6-.2-.7-.5l-.7-1.7h-3.7l-.7 1.7c-.1.2-.2.3-.3.4-.3.2-.8.2-1-.1-.1-.2-.2-.3-.2-.6 0-.1 0-.2.1-.3l3.1-7.2c.1-.2.2-.3.3-.5.2-.1.4-.2.6-.2h.1c.2 0 .4.1.6.2.1.1.3.3.3.4l3.1 7.2c.1.1.1.2.1.3-.1.4-.2.5-.4.7zm2.9-.6c0 .2-.1.4-.2.6-.2.1-.3.2-.6.2-.2 0-.4-.1-.6-.2-.2-.2-.2-.3-.2-.6v-7.4c0-.2.1-.4.2-.6.3-.3.8-.3 1.1 0 .2.2.2.3.2.6v7.4z"></path>
                <path fill="#ffffff" d="M34.4 38.2h2.5l-1.3-3z"></path>
              </svg>
            </div>
            <div class="ai-card-text">
              <div class="ai-card-title" style="font-size: 15px; color: #a0a0a0;">允许您的信息用于AI训练</div>
            </div>
            <div class="new-toggle-container">
              <div 
                class="new-toggle" 
                :class="{ active: aiTrainingEnabled }" 
                @click="aiTrainingEnabled = !aiTrainingEnabled"
              >
                <div class="new-toggle-circle"></div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 底部导航按钮 -->
        <div class="ai-navigation">
          <button class="ai-back-btn" @click="goBack">
            <span class="arrow">←</span> 返回
          </button>
          <button class="ai-next-btn" @click="handleAISettingsSubmit">
            下一步 <span class="arrow">→</span>
          </button>
        </div>
      </div>

      <!-- 审核与注册页面 -->
      <div class="review-register-container" v-if="currentPage === 'reviewRegister'">
        <div class="review-content">
          <button class="close-review-btn" @click="goToStart">×</button>
          
          <div class="review-header">
            <h1>审核与注册</h1>
            <p class="review-subtitle">以下是您的注册概览</p>
          </div>
          
          <div class="review-sections">
            <div class="sections-container">
              <div class="review-section-header licenses-header-row">
                <h3 class="section-title">许可证 ({{ selectedLicenses.length }})</h3>
                <button class="add-license-btn" @click="goToLicense">添加许可证</button>
              </div>
              
              <div class="licenses-section">
                <div class="licenses-list">
                  <div v-for="license in selectedLicenses" :key="license" class="license-item">
                    <div class="license-item-content">
                      <div class="license-info">
                        <span class="license-name">{{ getLicenseName(license) }}</span>
                      </div>
                      <div class="license-actions">
                        <button class="license-search-btn" @click="handleLicenseSearch(license)">
                          <span class="search-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" id="search" x="0" y="0" version="1.1" viewBox="0 0 29 29" width="16" height="16">
                              <circle cx="11.854" cy="11.854" r="9" style="fill:none;stroke:#fff;stroke-width:2;stroke-miterlimit:10"></circle>
                              <path d="M18.451 18.451l7.695 7.695" style="fill:none;stroke:#fff;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10"></path>
                            </svg>
                          </span>
                        </button>
                        <button class="license-delete-btn">
                          <span class="delete-icon">×</span>
                        </button>
                      </div>
                    </div>
                  </div>
                  <!-- Show placeholder if no licenses are selected -->
                  <div v-if="selectedLicenses.length === 0" class="no-licenses-placeholder">
                    <p>暂无选择许可证</p>
                  </div>
                </div>
              </div>
              
              <div class="review-section-header">
                <h3 class="section-title">您的资产</h3>
              </div>
              
              <div class="asset-section">
                <!-- 资产部分内容 -->
                <div v-for="(file, index) in uploadedFiles" :key="index" class="asset-preview-card" :class="{ 'audio-asset': file.type.startsWith('audio/') }">
                  <div class="asset-image-container">
                    <!-- 图片文件 -->
                    <img v-if="file.type.startsWith('image/')" :src="file.url" class="asset-preview-image" alt="Asset preview" />
                    
                    <!-- 视频文件 -->
                    <video v-else-if="file.type.startsWith('video/')" :src="file.url" class="asset-preview-video" controls></video>
                    
                    <!-- 音频文件 -->
                    <div v-else-if="file.type.startsWith('audio/')" class="asset-preview-audio">
                      <div class="audio-icon">♪</div>
                    </div>
                    
                    <!-- 其他类型文件 -->
                    <div v-else class="asset-placeholder">
                      <div class="placeholder-icon">📄</div>
                    </div>
                  </div>
                  
                  <div class="asset-preview-info">
                    <div class="asset-source">公共资源门户</div>
                    <div class="asset-name">{{ assetName || "Hiroyoshi Kaninnomiya" }}</div>
                    
                    <div class="asset-owner">
                      <div class="asset-owner-label">持有者</div>
                      <div class="owners-avatar-row">
                        <!-- 当前用户/主要创作者 -->
                        <div class="avatar-badge current-owner-badge">
                          <span class="owner-icon">●</span>
                        </div>
                        
                        <!-- 显示共同创作者 -->
                        <template v-if="coCreators && coCreators.length > 0">
                          <div v-for="(creator, idx) in coCreators.slice(0, 2)" :key="idx" class="avatar-badge creator-badge">
                            <span class="owner-icon">●</span>
                          </div>
                          
                          <!-- 如果共同创作者超过2个，显示+X -->
                          <div v-if="coCreators.length > 2" class="avatar-badge more-badge">
                            <span class="owner-count">+{{ coCreators.length - 2 }}</span>
                          </div>
                        </template>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- 如果没有文件，显示占位符 -->
                <div v-if="uploadedFiles.length === 0" class="asset-preview-card">
                  <div class="asset-image-container">
                    <div class="asset-placeholder">
                      <div class="placeholder-icon">?</div>
                    </div>
                  </div>
                  
                  <div class="asset-preview-info">
                    <div class="asset-source">公共资源门户</div>
                    <div class="asset-name">{{ assetName || "未命名资产" }}</div>
                    
                    <div class="asset-owner">
                      <div class="asset-owner-label">持有者</div>
                      <div class="owners-avatar-row">
                        <!-- 当前用户/主要创作者 -->
                        <div class="avatar-badge current-owner-badge">
                          <span class="owner-icon">●</span>
                        </div>
                        
                        <!-- 显示共同创作者 -->
                        <template v-if="coCreators && coCreators.length > 0">
                          <div v-for="(creator, idx) in coCreators.slice(0, 2)" :key="idx" class="avatar-badge creator-badge">
                            <span class="owner-icon">●</span>
                          </div>
                          
                          <!-- 如果共同创作者超过2个，显示+X -->
                          <div v-if="coCreators.length > 2" class="avatar-badge more-badge">
                            <span class="owner-count">+{{ coCreators.length - 2 }}</span>
                          </div>
                        </template>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="review-actions">
            <button class="back-review-btn" @click="goBack">
              <span class="arrow">←</span> 返回
            </button>
            <button class="uiverse" @click="handleRegistration">
              <div class="wrapper">
                <span>发布</span>
                <div class="circle circle-1"></div>
                <div class="circle circle-2"></div>
                <div class="circle circle-3"></div>
                <div class="circle circle-4"></div>
                <div class="circle circle-5"></div>
                <div class="circle circle-6"></div>
                <div class="circle circle-7"></div>
                <div class="circle circle-8"></div>
                <div class="circle circle-9"></div>
                <div class="circle circle-10"></div>
                <div class="circle circle-11"></div>
                <div class="circle circle-12"></div>
              </div>
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Add error notification -->
    <div v-if="showFileTypeError" class="file-type-error">
      <div class="error-content">
        <span class="error-icon">⚠️</span>
        <span class="error-message">{{ fileTypeErrorMessage }}</span>
        <button class="error-close" @click="showFileTypeError = false">×</button>
      </div>
    </div>

    <!-- 许可证冲突弹窗 -->
    <div v-if="showLicenseConflictModal" class="license-conflict-modal">
      <div class="modal-content">
        <header class="modal-header">
          <h2>许可证冲突</h2>
          <span class="close-btn" @click="closeConflictModal">×</span>
        </header>
        <div class="modal-body">
          <div class="conflict-icon">
            <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" id="ai" width="80" height="80" enable-background="new 0 0 48 48" version="1.1" viewBox="0 0 48 48">
              <g>
                <path fill="#000000" d="M26.2,32.5l-1.5-3.4h-6.6l-1.5,3.4h-3.7l6.8-15.7h3.4l6.8,15.7H26.2z M34.8,32.5h-3.4V20.4h3.4V32.5z M34.5,18.9c-0.4,0.4-0.9,0.6-1.4,0.6c-0.6,0-1-0.2-1.4-0.6c-0.4-0.4-0.6-0.9-0.6-1.4c0-0.6,0.2-1,0.6-1.4c0.4-0.4,0.9-0.6,1.4-0.6c0.6,0,1,0.2,1.4,0.6c0.4,0.4,0.6,0.9,0.6,1.4C35.1,18,34.9,18.5,34.5,18.9z"></path>
                <polygon fill="#000000" points="19.5 26 23.4 26 21.4 21.5"></polygon>
              </g>
            </svg>
          </div>
          <div class="conflict-info">
            <p class="conflict-title">无法添加以下许可证：</p>
            <div class="conflict-license new-license">
              <span class="license-tag">{{ conflictModalData.newLicenseName }}</span>
            </div>
            
            <p class="conflict-title">已选择的冲突许可证：</p>
            <div class="conflict-license existing-license">
              <span class="license-tag" v-for="license in conflictModalData.conflictingLicenses" :key="license">
                {{ getLicenseName(license) }}
              </span>
            </div>
            
            <p class="conflict-reason">
              <span class="reason-label">冲突原因：</span>
              {{ conflictModalData.reason }}
            </p>
          </div>
          
          <div class="valid-combinations">
            <h3>有效的许可证组合</h3>
            <div class="combination">
              <div class="combination-group">
                <span class="license-tag blue">开放使用</span>
                <span class="combination-note">（单独使用）</span>
              </div>
            </div>
            <div class="combination">
              <div class="combination-group">
                <span class="license-tag purple">非商业混音</span>
                <span class="plus-sign">+</span>
                <span class="license-tag green">商业使用</span>
                <span class="plus-sign">+</span>
                <span class="license-tag red">商业混音</span>
                <span class="combination-note">（可任意组合）</span>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="modal-btn cancel-btn" @click="closeConflictModal">我知道了</button>
        </div>
      </div>
    </div>

    <!-- 许可证详情弹窗 -->
    <div v-if="showLicenseDetailModal" class="license-detail-modal">
      <div class="modal-content license-detail-content">
        <header class="modal-header">
          <div class="license-detail-logo">
            <div class="ip-logo">IP</div>
            <div class="license-detail-title">{{ currentLicenseDetail.name }}</div>
            <div class="license-detail-icons">
              <span v-if="currentLicenseDetail.license === 'open'"><span class="license-icon">📝</span></span>
              <span v-if="currentLicenseDetail.license === 'commercial' || currentLicenseDetail.license === 'commercial-remix'"><span class="license-icon">💲</span></span>
              <span v-if="currentLicenseDetail.license === 'non-commercial' || currentLicenseDetail.license === 'commercial-remix'"><span class="license-icon">↩️</span></span>
            </div>
          </div>
          <span class="close-btn" @click="closeLicenseDetailModal">×</span>
        </header>
        
        <div class="modal-body">
          <div class="license-summary">
            <h3>许可证摘要</h3>
            <p>{{ currentLicenseDetail.summary }}</p>
          </div>
          
          <div class="license-terms">
            <h3>许可条款</h3>
            <div class="terms-list">
              <div class="term-item" v-if="currentLicenseDetail.license === 'open'">
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
                  {{ currentLicenseDetail.license === 'non-commercial' ? '仅限非商业使用' : 
                     currentLicenseDetail.license === 'commercial' || currentLicenseDetail.license === 'commercial-remix' ? '允许商业使用' : '允许任何使用' }}
                </div>
              </div>
              
              <div class="term-item">
                <div class="term-icon">↩️</div>
                <div class="term-text">
                  {{ currentLicenseDetail.license === 'non-commercial' || currentLicenseDetail.license === 'commercial-remix' || currentLicenseDetail.license === 'open' ? '允许混音改编' : '不允许混音改编' }}
                </div>
              </div>
              
              <div class="term-item">
                <div class="term-icon">📊</div>
                <div class="term-text">
                  {{ currentLicenseDetail.license === 'commercial' || currentLicenseDetail.license === 'commercial-remix' ? '收取版税' : '无版税共享' }}
                </div>
              </div>
              
              <div class="term-item">
                <div class="term-icon">🤖</div>
                <div class="term-text">{{ aiTrainingEnabled ? 'AI训练允许' : 'AI训练不允许' }}</div>
              </div>
            </div>
          </div>
          
          <div class="license-view-legal">
            <button class="view-legal-btn">
              <span class="legal-icon">📄</span>
              查看法律条款
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

// 当前页面状态
const currentPage = ref('start') // 'start', 'workType', 'license', 'aiPermissions', 'assetDetails', 或 'creators'

// 标签页数据
const tabs = [
  { id: 'preset', label: '预设许可证' },
  { id: 'custom', label: '自定义许可证' },
  { id: 'assistant', label: '许可证助手' }
]

// 记录展开的过滤器项
const expandedFilters = ref<Record<string, boolean>>({
  'ai-training': false,
  'commercial-use': false,
  'attribution': false, // 修改为默认不展开
  'remixing': false,
  'expiration': false,
  'licensing-fee': false
})

// 切换过滤器项的展开/折叠状态
const toggleFilter = (filterId: string) => {
  expandedFilters.value[filterId] = !expandedFilters.value[filterId]
}

// 作品类型数据
const workTypes = [
  { id: 'newIP', label: '新IP', icon: 'sparkles', description: '注册原创图片、视频或文字作品' },
  { id: 'remix', label: '混音', icon: 'remix', description: '注册与现有作品相关的衍生作品' }
]

// 当前选中的标签页
const activeTabIndex = ref(0)

// 当前选择的许可证
const selectedLicense = ref('')
const selectedLicenses = ref<string[]>([])

// 当前选择的作品类型
const selectedWorkType = ref('')

// 资产详情页面数据
const assetName = ref('')
const assetDescription = ref('')
const activeUploadMethod = ref('file')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const selectedAssetType = ref('')
const uploadedFiles = ref<Array<{name: string, type: string, url: string, file: File, duration?: number}>>([])

// 创作者页面数据
const newCreatorName = ref('')
const newCreatorWallet = ref('')
const coCreators = ref<Array<{name: string, wallet: string}>>([])

// 根据选择的资产类型确定接受的文件类型
const fileTypeAccept = computed(() => {
  switch (selectedAssetType.value) {
    case 'image':
      return 'image/jpeg,image/png,image/gif,image/svg+xml,image/webp';
    case 'video':
      return 'video/mp4,video/webm,video/quicktime';
    case 'audio':
      return 'audio/wav,audio/mpeg,audio/flac,audio/aac,audio/ogg,audio/mp4,audio/opus';
    case 'text':
      return '.txt,.pdf,.doc,.docx,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    default:
      return '';
  }
});

// 页面跳转函数
const goToStart = () => {
  currentPage.value = 'start'
}

const goToWorkType = () => {
  currentPage.value = 'workType'
  // 重置选择状态，确保进入页面时没有默认选中的选项
  selectedWorkType.value = ''
}

const goToAssetDetails = () => {
  currentPage.value = 'assetDetails'
}

const goToCreators = () => {
  currentPage.value = 'creators'
}

const goToLicense = () => {
  currentPage.value = 'license'
  resetExpandedFilters()
}

const showUnavailable = (type: string) => {
  alert(`${type === 'task' ? '发布任务' : '发布活动'}功能尚未开放，敬请期待`)
}

// 选择作品类型
const selectWorkType = (type: string) => {
  selectedWorkType.value = type
}

// 切换标签页
const setActiveTab = (index: number) => {
  activeTabIndex.value = index
  // 切换标签页时清除选择的许可证
  if (index !== 0) {
    selectedLicense.value = ''
  }
  
  // 切换到自定义许可证标签页时重置所有展开状态
  if (index === 1) {
    resetExpandedFilters()
  }
}

// 选择许可证
const selectLicense = (license: string) => {
  const licenseConflicts = checkLicenseConflicts(license)
  
  if (selectedLicenses.value.includes(license)) {
    // 如果已选择，则移除
    selectedLicenses.value = selectedLicenses.value.filter(item => item !== license)
    selectedLicense.value = selectedLicenses.value.length > 0 ? selectedLicenses.value[0] : ''
  } else {
    // 如果有冲突，显示提示
    if (licenseConflicts.hasConflict) {
      showLicenseConflictAlert(license, licenseConflicts.conflictingLicenses, licenseConflicts.reason)
    } else {
      // 无冲突，添加许可证
      selectedLicenses.value.push(license)
      selectedLicense.value = license
      
      // 再次检查当前组合是否有冲突（防止漏检）
      checkCurrentLicenseCombination()
    }
  }
}

// 检查许可证冲突
const checkLicenseConflicts = (newLicense: string) => {
  const conflicts = {
    hasConflict: false,
    conflictingLicenses: [] as string[],
    reason: ''
  }
  
  // 新冲突规则
  // 只有开放使用与其他三个许可证冲突
  if (newLicense === 'open') {
    // 开放使用与其他所有许可证冲突
    const conflicting = selectedLicenses.value.filter(l => 
      ['commercial', 'commercial-remix', 'non-commercial'].includes(l)
    );
    
    if (conflicting.length > 0) {
      conflicts.hasConflict = true;
      conflicts.conflictingLicenses = conflicting;
      conflicts.reason = '开放使用（完全免费无限制）与其他许可证类型互斥，不能同时选择';
    }
  } 
  // 其他三个许可证之间互相不冲突
  else if (selectedLicenses.value.includes('open')) {
    // 如果当前已选择了开放使用，则其他许可证都会与之冲突
    conflicts.hasConflict = true;
    conflicts.conflictingLicenses = ['open'];
    conflicts.reason = '其他许可证类型与开放使用（完全免费无限制）互斥，不能同时选择';
  }
  
  return conflicts
}

// 显示许可证冲突提示
const showLicenseConflictModal = ref(false);
const conflictModalData = ref<{
  newLicense: string;
  conflictingLicenses: string[];
  reason: string;
  newLicenseName: string;
  conflictsList: string;
}>({
  newLicense: '',
  conflictingLicenses: [],
  reason: '',
  newLicenseName: '',
  conflictsList: ''
});

const showLicenseConflictAlert = (newLicense: string, conflictingLicenses: string[], reason: string) => {
  const licenseNames = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音'
  }
  
  const conflictsList = conflictingLicenses.map(license => licenseNames[license as keyof typeof licenseNames]).join('、')
  const newLicenseName = licenseNames[newLicense as keyof typeof licenseNames]
  
  // 设置冲突数据并显示弹窗
  conflictModalData.value = {
    newLicense,
    conflictingLicenses,
    reason,
    newLicenseName,
    conflictsList
  };
  showLicenseConflictModal.value = true;
}

// 当前选择的许可证显示
const getLicenseDisplayText = computed(() => {
  if (selectedLicenses.value.length === 0) {
    return '未选择'
  } else {
    const licenseNames = {
      'open': '开放使用',
      'non-commercial': '非商业混音',
      'commercial': '商业使用',
      'commercial-remix': '商业混音'
    }
    return selectedLicenses.value.map(license => 
      licenseNames[license as keyof typeof licenseNames]
    ).join(', ')
  }
})

// 选择资产类型
const selectAssetType = (type: string) => {
  // Only show confirmation when there are already files uploaded
  if (uploadedFiles.value.length > 0 && selectedAssetType.value && selectedAssetType.value !== type) {
    // Ask for confirmation to change asset type and delete current files
    if (confirm(`切换到${type === 'image' ? '图片' : type === 'video' ? '视频' : type === 'audio' ? '音频' : '文字'}类将会清除当前已上传的文件，确定要继续吗？`)) {
      // Clear all existing uploaded files
      while (uploadedFiles.value.length > 0) {
        removeFile(0);
      }
      // Reset any error messages
      showFileTypeError.value = false;
      // Set new asset type
      selectedAssetType.value = type;
    }
    // If user cancels, keep current asset type
    return;
  }
  
  // Reset any error messages when changing asset types
  showFileTypeError.value = false;
  // Set new asset type
  selectedAssetType.value = type;
}

// 验证文件类型是否符合当前选择的资产类型
const isValidFileType = (file: File) => {
  const fileType = file.type.toLowerCase();
  
  switch (selectedAssetType.value) {
    case 'image':
      return fileType.startsWith('image/');
    case 'video':
      return fileType.startsWith('video/');
    case 'audio':
      return fileType.startsWith('audio/');
    case 'text':
      return fileType.startsWith('text/') || 
             fileType === 'application/pdf' || 
             fileType === 'application/msword' || 
             fileType === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    default:
      return false;
  }
}

// 文件上传处理函数
const triggerFileUpload = () => {
  if (fileInput.value) {
    fileInput.value.click()
  }
}

// State for file type error message
const showFileTypeError = ref(false)
const fileTypeErrorMessage = ref('')

// 添加拖拽相关状态和函数
const draggedItem = ref<number | null>(null);
const draggedOverItem = ref<number | null>(null);

// 开始拖拽
const dragStart = (index: number, event: DragEvent) => {
  if (event.dataTransfer) {
    // 设置拖拽效果和数据
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/plain', index.toString());
    draggedItem.value = index;
    
    // 延迟添加拖拽样式，避免立即添加导致拖拽图像消失
    setTimeout(() => {
      if (event.target instanceof HTMLElement) {
        event.target.classList.add('dragging');
      }
    }, 0);
  }
}

// 拖拽进入其他元素
const dragEnter = (index: number, event: DragEvent) => {
  if (draggedItem.value !== null && draggedItem.value !== index) {
    draggedOverItem.value = index;
    if (event.currentTarget instanceof HTMLElement) {
      event.currentTarget.classList.add('drag-over');
    }
  }
}

// 拖拽离开元素
const dragLeave = (event: DragEvent) => {
  if (event.currentTarget instanceof HTMLElement) {
    event.currentTarget.classList.remove('drag-over');
  }
}

// 放置元素
const drop = (index: number, event: DragEvent) => {
  if (draggedItem.value !== null && draggedItem.value !== index) {
    // 交换文件位置
    const temp = { ...uploadedFiles.value[draggedItem.value] };
    uploadedFiles.value.splice(draggedItem.value, 1);
    uploadedFiles.value.splice(index, 0, temp);
    
    // 更新selectedFile引用
    if (draggedItem.value === 0 || index === 0) {
      selectedFile.value = uploadedFiles.value[0].file;
    }
  }
  
  // 移除样式
  if (event.currentTarget instanceof HTMLElement) {
    event.currentTarget.classList.remove('drag-over');
  }
  
  draggedItem.value = null;
  draggedOverItem.value = null;
}

// 拖拽结束
const dragEnd = () => {
  draggedItem.value = null;
  draggedOverItem.value = null;
  // 移除所有拖拽样式
  document.querySelectorAll('.preview-file-item').forEach(item => {
    item.classList.remove('dragging', 'drag-over');
  });
}

// Update the file handlers to show error messages for wrong file types
const handleFileSelect = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (target.files && target.files.length > 0) {
    let hasInvalidFiles = false;
    // 处理多个文件
    for(let i = 0; i < target.files.length; i++) {
      const file = target.files[i]
      if (isValidFileType(file)) {
        addFileToPreview(file)
      } else {
        hasInvalidFiles = true;
      }
    }
    
    // Show error if any invalid files were detected
    if (hasInvalidFiles) {
      showFileTypeErrorMessage();
    }
    
    // 保持兼容性，设置第一个文件为selectedFile
    if (uploadedFiles.value.length > 0) {
      selectedFile.value = uploadedFiles.value[0].file
    }
  }
}

const onFileDrop = (event: DragEvent) => {
  if (event.dataTransfer && event.dataTransfer.files.length > 0) {
    let hasInvalidFiles = false;
    // 处理多个文件
    for(let i = 0; i < event.dataTransfer.files.length; i++) {
      const file = event.dataTransfer.files[i]
      if (isValidFileType(file)) {
        addFileToPreview(file)
      } else {
        hasInvalidFiles = true;
      }
    }
    
    // Show error if any invalid files were detected
    if (hasInvalidFiles) {
      showFileTypeErrorMessage();
    }
    
    // 保持兼容性，设置第一个文件为selectedFile
    if (uploadedFiles.value.length > 0) {
      selectedFile.value = uploadedFiles.value[0].file
    }
  }
}

// 添加文件到预览
const addFileToPreview = (file: File) => {
  const fileUrl = URL.createObjectURL(file);
  const fileIndex = uploadedFiles.value.length;
  uploadedFiles.value.push({
    name: file.name,
    type: file.type,
    url: fileUrl,
    file: file,
    duration: 0
  });
  
  // 加载音频元数据
  if (file.type.startsWith('audio/')) {
    loadAudioMetadata(file, fileIndex);
  }
}

// 移除文件
const removeFile = (index: number) => {
  // 释放URL对象
  URL.revokeObjectURL(uploadedFiles.value[index].url)
  // 移除文件
  uploadedFiles.value.splice(index, 1)
  // 如果没有文件了，清空selectedFile
  if (uploadedFiles.value.length === 0) {
    selectedFile.value = null
  } else if (index === 0 && uploadedFiles.value.length > 0) {
    // 如果删除的是第一个文件，更新selectedFile为新的第一个文件
    selectedFile.value = uploadedFiles.value[0].file
  }
}

// 添加共同创作者
const addCoCreator = () => {
  if (newCreatorName.value && newCreatorWallet.value) {
    coCreators.value.push({
      name: newCreatorName.value,
      wallet: newCreatorWallet.value
    })
    // 清空输入
    newCreatorName.value = ''
    newCreatorWallet.value = ''
  }
}

// 删除共同创作者
const removeCoCreator = (index: number) => {
  coCreators.value.splice(index, 1)
}

// 缩短钱包地址显示
const shortenWallet = (wallet: string) => {
  if (wallet.length > 12) {
    return wallet.slice(0, 6) + '...' + wallet.slice(-4)
  }
  return wallet
}

// 移除许可证
const removeLicense = (license: string) => {
  selectedLicenses.value = selectedLicenses.value.filter(item => item !== license)
  if (selectedLicenses.value.length > 0) {
    selectedLicense.value = selectedLicenses.value[0]
  } else {
    selectedLicense.value = ''
  }
  
  // 检查剩余的许可证组合是否有冲突
  checkCurrentLicenseCombination()
}

// 提交资产
const submitAsset = () => {
  // 如果选择了开放使用许可证且当前是许可证页面，跳转到AI权限页面
  if (currentPage.value === 'license' && selectedLicenses.value.includes('open')) {
    currentPage.value = 'aiPermissions'
    return
  }
  
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicenses.value)
  console.log('AI训练设置:', aiTrainingEnabled.value)
  // 这里可以添加提交到服务器的逻辑
  alert('资产提交成功!')
  currentPage.value = 'start'
}

// 导航功能
const goBack = () => {
  if (currentPage.value === 'assetDetails') {
    goToWorkType() // 在资产详情页面返回到作品类型选择页面
  } else if (currentPage.value === 'creators') {
    goToAssetDetails() // 在创作者页面返回到资产详情页面
  } else if (currentPage.value === 'license') {
    goToCreators() // 在许可证页面返回到创作者页面
    resetExpandedFilters() // 在离开许可证页面时清除展开状态
  } else if (currentPage.value === 'aiPermissions') {
    currentPage.value = 'license' // 从AI权限页面返回到许可证页面
  } else if (currentPage.value === 'reviewRegister') {
    currentPage.value = 'aiPermissions' // 从审核与注册页面返回到AI权限页面
  } else {
    goToStart() // 返回到首页
  }
}

const goNext = () => {
  if (currentPage.value === 'workType' && selectedWorkType.value) {
    // 从作品类型选择页面前进到资产详情页面
    goToAssetDetails()
  } else if (currentPage.value === 'assetDetails' && assetName.value && uploadedFiles.value.length > 0) {
    // 从资产详情页面前进到创作者页面
    goToCreators()
  } else if (currentPage.value === 'creators') {
    // 从创作者页面前进到许可证页面
    goToLicense()
  }
}

// Add this after the expandedFilters ref declaration
// 记录每个过滤器项的选择状态
const filterSelections = ref<Record<string, string | null>>({
  'ai-training': null,
  'commercial-use': null,
  'attribution': null,
  'remixing': null,
  'expiration': null,
  'licensing-fee': null
})

// 设置过滤器选项
const setFilterOption = (filterId: string, value: string) => {
  filterSelections.value[filterId] = value
}

// 清除过滤器选项
const clearFilterOption = (filterId: string) => {
  filterSelections.value[filterId] = null
}

// Add this after the clearFilterOption function
// 清除所有过滤器选项
const clearAllFilters = () => {
  Object.keys(filterSelections.value).forEach(key => {
    filterSelections.value[key] = null
  })
}

// Add these refs to track license fee values
const licensePrice = ref(0)
const revenueShare = ref(0)

// Update the filterSelections when license fee values change
const updateLicenseFee = () => {
  if (licensePrice.value > 0 || revenueShare.value > 0) {
    filterSelections.value['licensing-fee'] = 'custom'
  } else {
    filterSelections.value['licensing-fee'] = null
  }
}

// Clear license fee values
const clearLicenseFee = () => {
  licensePrice.value = 0
  revenueShare.value = 0
  filterSelections.value['licensing-fee'] = null
}

// 重置所有展开的过滤器状态为false
const resetExpandedFilters = () => {
  Object.keys(expandedFilters.value).forEach(key => {
    expandedFilters.value[key] = false
  })
}

// Show file type error message
const showFileTypeErrorMessage = () => {
  let fileTypesAllowed = '';
  switch (selectedAssetType.value) {
    case 'image':
      fileTypesAllowed = 'JPG、PNG、GIF、SVG、WEBP';
      break;
    case 'video':
      fileTypesAllowed = 'MP4、WEBM、MOV';
      break;
    case 'audio':
      fileTypesAllowed = 'WAV、MP3、FLAC、AAC、OGG、M4A、OPUS';
      break;
    case 'text':
      fileTypesAllowed = 'TXT、PDF、DOC、DOCX';
      break;
  }
  
  fileTypeErrorMessage.value = `只能上传${fileTypesAllowed}格式的文件`;
  showFileTypeError.value = true;
  
  // Auto-hide the error message after 3 seconds
  setTimeout(() => {
    showFileTypeError.value = false;
  }, 3000);
}

// 格式化时长
const formatDuration = (seconds: number) => {
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.floor(seconds % 60);
  return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
}

// 在加载音频文件时获取时长
const loadAudioMetadata = (file: File, index: number) => {
  if (file.type.startsWith('audio/')) {
    const audio = new Audio();
    audio.src = URL.createObjectURL(file);
    audio.onloadedmetadata = () => {
      uploadedFiles.value[index].duration = audio.duration;
    };
  }
};

// 获取音频格式
const getAudioFormat = (filename: string) => {
  const extension = filename.split('.').pop()?.toLowerCase() || '';
  
  switch (extension) {
    case 'mp3':
      return 'MP3';
    case 'wav':
      return 'WAV';
    case 'flac':
      return 'FLAC';
    case 'aac':
      return 'AAC';
    case 'ogg':
      return 'OGG';
    case 'm4a':
      return 'M4A';
    case 'opus':
      return 'OPUS';
    default:
      return 'Audio';
  }
}

// 关闭冲突弹窗
const closeConflictModal = () => {
  showLicenseConflictModal.value = false;
}

// 接受冲突
const acceptConflict = () => {
  // 在这里添加处理冲突的逻辑
  console.log('冲突已接受:', conflictModalData.value);
  closeConflictModal();
}

const getLicenseName = (license: string) => {
  const licenseNames = {
    'open': '开放使用',
    'non-commercial': '非商业混音',
    'commercial': '商业使用',
    'commercial-remix': '商业混音'
  }
  return licenseNames[license as keyof typeof licenseNames] || license;
}

// 检查当前许可证组合是否有冲突
const checkCurrentLicenseCombination = () => {
  // 检查是否包含开放使用许可证
  const hasOpenLicense = selectedLicenses.value.includes('open');
  
  // 检查是否包含其他许可证
  const hasOtherLicenses = selectedLicenses.value.some(license => 
    license === 'commercial' || license === 'commercial-remix' || license === 'non-commercial'
  );
  
  // 只有同时包含开放使用和其他许可证才算冲突
  if (hasOpenLicense && hasOtherLicenses) {
    const otherLicenses = selectedLicenses.value.filter(l => 
      ['commercial', 'commercial-remix', 'non-commercial'].includes(l)
    );
    
    // 声明冲突相关变量
    let conflictingLicense = '';
    let conflictingWithLicense = '';
    let reason = '';
    
    // 根据数量决定保留哪一类
    if (otherLicenses.length >= 1) {
      // 保留其他许可证，移除开放使用
      selectedLicenses.value = otherLicenses;
      conflictingLicense = 'open';
      conflictingWithLicense = otherLicenses[0];
      reason = '开放使用（完全免费无限制）与其他许可证类型互斥。系统已移除开放使用许可证。';
    } else {
      // 保留开放使用，移除其他许可证
      selectedLicenses.value = ['open'];
      conflictingLicense = otherLicenses[0];
      conflictingWithLicense = 'open';
      reason = '其他许可证类型与开放使用（完全免费无限制）互斥。系统已移除其他许可证。';
    }
    
    // 更新selectedLicense以匹配
    if (selectedLicenses.value.length > 0) {
      selectedLicense.value = selectedLicenses.value[0];
    } else {
      selectedLicense.value = '';
    }
    
    // 显示冲突提示
    showLicenseConflictAlert(conflictingLicense, [conflictingWithLicense], reason);
    
    return true;
  }
  
  return false;
}

// 添加AI训练设置状态
const aiTrainingEnabled = ref(true) // 默认允许AI训练

// 添加AI设置页面处理函数
const handleAISettingsSubmit = () => {
  // 跳转到审核与注册页面
  currentPage.value = 'reviewRegister'
}

// 处理资产注册
const handleRegistration = () => {
  // 完成注册流程
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicenses.value)
  console.log('AI训练设置:', aiTrainingEnabled.value)
  // 这里可以添加提交到服务器的逻辑
  alert('资产注册成功!')
  currentPage.value = 'start'
}

// 获取文件类型显示
const getFileTypeDisplay = (fileType: string) => {
  switch (fileType) {
    case 'image/jpeg':
    case 'image/png':
    case 'image/gif':
    case 'image/svg+xml':
    case 'image/webp':
      return '图片';
    case 'video/mp4':
    case 'video/webm':
    case 'video/quicktime':
      return '视频';
    case 'audio/wav':
    case 'audio/mpeg':
    case 'audio/flac':
    case 'audio/aac':
    case 'audio/ogg':
    case 'audio/mp4':
    case 'audio/opus':
      return '音频';
    case 'text/plain':
    case 'application/pdf':
    case 'application/msword':
    case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      return '文字';
    default:
      return '未知';
  }
}

// 添加许可证详情弹窗状态
const showLicenseDetailModal = ref(false);
const currentLicenseDetail = ref({
  license: '',
  name: '',
  summary: ''
});

// 打开许可证详情弹窗
const openLicenseDetail = (license: string) => {
  const licenseDetails = {
    'open': {
      name: '开放使用',
      summary: '开放域是一种公共贡献工具，它允许创作者放弃版权，将作品放入全球公共域。使用者可以在任何媒介或格式中分发、混音、改编和构建作品，无需任何条件。'
    },
    'non-commercial': {
      name: '非商业混音',
      summary: '任何人都可以使用您的作品创建非商业项目。他们可以修改、调整和构建您的作品，但必须标明原创者，且不能将作品用于商业目的。'
    },
    'commercial': {
      name: '商业使用',
      summary: '允许他人按照您设定的经济条款使用您的作品。使用者必须支付许可费和/或版税，但不允许对您的作品进行修改或创建衍生作品。'
    },
    'commercial-remix': {
      name: '商业混音',
      summary: '允许他们混音您的作品，同时您获得认可和收益。使用者可以修改和构建您的作品，但必须支付许可费和/或版税，同时标明您是原创者。'
    }
  };
  
  currentLicenseDetail.value = {
    license,
    name: licenseDetails[license as keyof typeof licenseDetails].name,
    summary: licenseDetails[license as keyof typeof licenseDetails].summary
  };
  
  showLicenseDetailModal.value = true;
};

// 关闭许可证详情弹窗
const closeLicenseDetailModal = () => {
  showLicenseDetailModal.value = false;
};

// 更新license-search-btn点击事件
const handleLicenseSearch = (license: string) => {
  openLicenseDetail(license);
};
</script>

<style scoped>
/* 隐藏所有滚动条 */
::-webkit-scrollbar {
  display: none;
}

html, body {
  overflow: hidden;
  margin: 0;
  padding: 0;
}

.app-container {
  width: 100vw;
  height: 100vh;
  box-sizing: border-box;
  background: #3a3a3a; /* Changed from gradient to solid gray */
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  color: white;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
}

.blur-container {
  width: 90vw;
  max-width: 1280px;
  height: 90vh;
  backdrop-filter: blur(30px);
  -webkit-backdrop-filter: blur(30px);
  background: rgba(60, 60, 60, 0.15);
  overflow: hidden;
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

/* 启动页面样式 */
.start-page {
  width: 100%;
  height: 100%;
  padding: 60px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

/* Glass card design from Uiverse.io by codebykay101 */
.menu-options {
  display: flex;
  gap: 0;
  margin-top: 60px;
  position: relative;
  justify-content: center;
  align-items: center;
}

.menu-card {
  position: relative;
  width: 180px;
  height: 200px;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7)); /* Darker background */
  border: 1px solid rgba(100, 100, 100, 0.35); /* Darker border */
  box-shadow: 0 25px 25px rgba(0, 0, 0, 0.35); /* Darker shadow */
  display: flex;
  justify-content: center;
  align-items: center;
  transition: 0.5s;
  border-radius: 10px;
  margin: 0 -45px;
  backdrop-filter: blur(15px);
  cursor: pointer;
}

.menu-card:nth-child(1) {
  transform: rotate(-8deg);
  --r: -8;
}

.menu-card:nth-child(2) {
  transform: rotate(0deg);
  --r: 0;
  z-index: 10;
}

.menu-card:nth-child(3) {
  transform: rotate(8deg);
  --r: 8;
}

.menu-options:hover .menu-card {
  transform: rotate(0deg);
  margin: 0 15px;
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75)); /* Darker hover state */
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
}

.menu-card:hover {
  transform: translateY(-10px) !important;
  border: 1px solid rgba(150, 150, 150, 0.5); /* Brighter border on hover */
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8)); /* Even darker on individual hover */
}

.menu-card::before {
  content: attr(data-text);
  position: absolute;
  bottom: 0;
  width: 100%;
  height: 40px;
  background: rgba(30, 30, 30, 0.75); /* Darker label background */
  display: flex;
  justify-content: center;
  align-items: center;
  color: #fff;
  font-weight: 500;
  font-size: 16px;
}

/* Remove the icon-wrapper styles */
.icon-wrapper {
  display: none;
}

/* Restore the menu-icon styles without the wrapper */
.menu-icon {
  width: 50px;
  height: 50px;
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
  opacity: 1;
  filter: invert(1) drop-shadow(0 2px 3px rgba(0, 0, 0, 0.3));
  margin-bottom: 40px; /* Add bottom margin to push the icon up from the text */
}

/* Restore the specific icon styles */
.people-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='1' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2'%3E%3C/path%3E%3Ccircle cx='9' cy='7' r='4'%3E%3C/circle%3E%3Cpath d='M23 21v-2a4 4 0 0 0-3-3.87'%3E%3C/path%3E%3Cpath d='M16 3.13a4 4 0 0 1 0 7.75'%3E%3C/path%3E%3C/svg%3E");
}

.product-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='1' stroke-linecap='round' stroke-linejoin='round'%3E%3Crect x='3' y='3' width='18' height='18' rx='2' ry='2'%3E%3C/rect%3E%3Ccircle cx='8.5' cy='8.5' r='1.5'%3E%3C/circle%3E%3Cpolyline points='21 15 16 10 5 21'%3E%3C/polyline%3E%3C/svg%3E");
}

.task-icon {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='1' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolygon points='12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2'%3E%3C/polygon%3E%3C/svg%3E");
}

/* Hide the menu title since we're using data-text */
.menu-title {
  display: none;
}

@media (max-width: 900px) {
  .menu-options {
    flex-direction: column;
    gap: 40px;
    margin-top: 40px;
  }
  
  .menu-card {
    width: 180px;
    height: 200px;
    margin: 0;
    transform: rotate(0deg) !important;
    background: linear-gradient(rgba(255, 255, 255, 0.35), rgba(255, 255, 255, 0.15)); /* Brighter on mobile */
  }
  
  .menu-options:hover .menu-card {
    margin: 0;
    box-shadow: 0 25px 25px rgba(0, 0, 0, 0.35);
  }
  
  .menu-card:hover {
    transform: translateY(-5px) !important; /* Reduced lift effect on mobile */
  }
}

.info-panel {
  display: flex;
  align-items: center;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  padding: 16px 25px;
  margin-top: auto;
  margin-bottom: 35px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(100, 100, 100, 0.35);
  cursor: pointer;
  height: 60px;
}

.info-icon {
  width: 36px;
  height: 36px;
  background-color: rgba(50, 50, 50, 0.7);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 18px;
  flex-shrink: 0;
}

.coin-emoji {
  font-size: 20px;
}

.info-text {
  flex: 1;
}

.info-text h3 {
  margin: 0 0 3px 0;
  font-size: 16px;
  font-weight: 600;
}

.info-text p {
  margin: 0;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
}

.info-arrow {
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: 15px;
  color: rgba(255, 255, 255, 0.6);
  font-size: 16px;
}

/* 许可证容器样式 */
.license-container {
  width: 100%;
  height: 100%;
  padding: 40px 50px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  background-color: #212121;
  overflow-y: auto;
}

.header {
  margin-bottom: 32px;
  flex-shrink: 0;
  text-align: center;
}

h1 {
  font-size: 34px;
  margin: 0 0 12px 0;
  font-weight: 600;
  letter-spacing: -0.5px;
}

.subtitle-zh {
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
  font-size: 16px;
  line-height: 1.5;
  text-align: left;
}

.tabs {
  display: flex;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  margin-bottom: 20px;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
}

.tab {
  padding: 12px 20px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.6);
  position: relative;
  font-size: 15px;
  font-weight: 500;
  transition: color 0.2s;
}

.tab:hover {
  color: #ddd;
}

.tab.active {
  color: white;
}

.tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 2px;
  background: #000000;
}

.license-options {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  flex: 1;
  overflow-y: visible; /* 移除滚动效果 */
  padding-right: 10px;
  padding-bottom: 10px;
  position: relative;
  z-index: 1;
  min-height: 0;
  margin-bottom: 20px;
  height: auto; /* 自适应高度 */
}

.license-card {
  flex: 1;
  height: auto; /* 自适应高度 */
  min-height: 180px;
  background: rgba(60, 60, 65, 0.5);
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  padding: 0;
  position: relative;
  overflow: hidden; /* 改为hidden以控制内容 */
  display: flex;
  flex-direction: column;
  box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.1);
  cursor: pointer;
  box-sizing: border-box; /* 确保padding不会增加卡片宽度 */
}

.license-card:hover {
  background: rgba(70, 70, 75, 0.6);
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(255, 255, 255, 0.3);
}

.license-card.selected {
  border: 1px solid #fff;
  background: rgba(80, 80, 85, 0.6);
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.25);
}

.license-card h2 {
  font-size: 22px;
  margin: 8px 24px 12px;
  font-weight: 600;
}

.license-header {
  padding: 20px 24px 0 24px;
  margin-bottom: 0;
}

.license-content {
  padding: 0 24px;
  margin-bottom: 20px;
  flex: 1;
  min-height: auto; /* 允许内容自适应 */
}

.license-description-zh {
  margin: 0;
  font-size: 15px;
  line-height: 1.5;
  color: #bbb;
}

.license-footer {
  margin-top: auto;
  display: flex;
  justify-content: space-between;
  align-items: center; /* 确保垂直居中 */
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 16px; /* 减小水平内边距 */
  width: 100%; /* 确保宽度撑满 */
  box-sizing: border-box; /* 确保padding不会增加宽度 */
  flex-wrap: nowrap; /* 防止元素换行 */
  min-height: 54px; /* 确保足够的高度 */
}

.license-icons {
  display: flex;
  gap: 10px; /* 更小的图标间距 */
  flex-wrap: nowrap; /* 防止图标换行 */
  max-width: calc(100% - 40px); /* 留出空间给检查指示器 */
}

.icon {
  width: 22px; /* 稍微减小图标尺寸 */
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.6;
  flex-shrink: 0; /* 防止图标缩小 */
  font-size: 14px; /* 减小图标字体大小 */
}

.check-indicator {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 50%;
  color: white;
  font-size: 14px;
  font-weight: 500;
}

.navigation {
  margin-top: auto;
  display: flex;
  justify-content: space-between;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
  padding-top: 30px;
}

.back-btn, .next-btn {
  padding: 10px 20px;
  border-radius: 25px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s;
}

.back-btn {
  background: rgba(255, 255, 255, 0.15);
  color: white;
  backdrop-filter: blur(5px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.back-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.next-btn {
  background: white;
  color: #222;
  box-shadow: 0 5px 12px rgba(0, 0, 0, 0.1);
}

.next-btn:hover {
  background: #f0f0f0;
  transform: translateY(-2px);
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
}

.next-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.arrow {
  font-size: 16px;
  line-height: 1;
}

.custom-license, .license-assistant {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow: visible;
  padding-bottom: 20px;
}

.placeholder-content {
  max-width: 600px;
  color: #bbb;
}

.placeholder-content h2 {
  margin-bottom: 20px;
}

.placeholder-content p {
  font-size: 18px;
  line-height: 1.6;
}

@media (max-width: 1200px) {
  .license-options {
    gap: 20px;
  }
  
  .license-card {
    padding: 0;
  }
  
  .menu-options {
    gap: 30px;
  }
  
  .menu-card {
    width: 200px;
    height: 280px;
  }
}

@media (max-width: 900px) {
  .license-options {
    grid-template-columns: 1fr;
    gap: 15px;
  }
  
  .license-container {
    padding: 30px 25px;
  }
  
  .license-card {
    min-height: auto;
    height: auto;
  }
  
  .selected-licenses-header {
    grid-column: span 1;
  }
  
  .license-content {
    margin-bottom: 16px;
  }
  
  .license-footer {
    padding: 15px 20px;
  }
  
  .menu-options {
    flex-direction: column;
    gap: 40px;
    margin-top: 40px;
  }
  
  .menu-card {
    width: 190px;
    height: 254px;
  }
  
  .icon-wrapper {
    width: 80px;
    height: 80px;
    margin-bottom: 0;
    margin-right: 30px;
  }
  
  .start-page {
    padding: 30px;
  }
  
  .work-type-options {
    flex-direction: column;
  }
  
  .work-type-card {
    width: 100%;
  }
}

@media (max-width: 480px) {
  .license-options {
    padding-right: 0;
  }
  
  .license-card {
    min-height: auto;
  }
  
  .license-card h2 {
    font-size: 18px;
    margin: 6px 16px 8px;
  }
  
  .license-header {
    padding: 15px 16px 0 16px;
  }
  
  .license-content {
    padding: 0 16px;
    margin-bottom: 15px;
  }
  
  .license-footer {
    padding: 12px 14px; /* 进一步减小内边距 */
  }
  
  .license-description-zh {
    font-size: 14px;
  }
  
  /* 增加小屏幕下的图标处理 */
  .license-icons {
    gap: 10px; /* 在小屏幕上进一步减小图标间距 */
  }
  
  .icon {
    width: 20px; /* 稍微减小图标尺寸 */
    height: 20px;
    font-size: 12px; /* 减小图标字体大小 */
  }
}

/* 资产详情页面样式 */
.asset-details-container {
  width: 100%;
  height: 100%;
  padding: 40px 50px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  overflow: auto;
  background-color: #212121;
  color: white;
}

.form-group {
  margin-bottom: 30px;
}

.form-group label {
  display: block;
  font-size: 18px;
  font-weight: 500;
  margin-bottom: 12px;
}

.description-help {
  font-size: 14px;
  color: #a1a1aa;
  margin: 5px 0 0 0;
  font-weight: normal;
}

.input-field {
  width: 100%;
  padding: 15px;
  background-color: rgba(60, 60, 65, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 16px;
  transition: all 0.2s;
}

.input-field:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.3);
  background-color: rgba(70, 70, 75, 0.6);
}

.textarea-field {
  width: 100%;
  padding: 15px;
  background-color: rgba(60, 60, 65, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  font-size: 16px;
  resize: vertical;
  min-height: 100px;
  font-family: inherit;
  transition: all 0.2s;
}

.textarea-field:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.3);
  background-color: rgba(70, 70, 75, 0.6);
}

.upload-tabs {
  display: flex;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  margin-bottom: 20px;
}

.upload-tab {
  padding: 12px 20px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.6);
  position: relative;
  font-size: 15px;
  font-weight: 500;
  transition: color 0.2s;
}

.upload-tab:hover {
  color: #ddd;
}

.upload-tab.active {
  color: white;
}

.upload-tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 2px;
  background: white;
}

.asset-type-section {
  margin-bottom: 30px;
}

.asset-type-grid {
  display: flex;
  justify-content: space-between;
  gap: 15px;
  margin-bottom: 30px;
  flex-wrap: wrap;
}

.asset-type-card {
  flex: 1;
  min-width: 150px;
  background: rgba(60, 60, 65, 0.5);
  border-radius: 12px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.asset-type-card:hover {
  background: rgba(70, 70, 75, 0.6);
  transform: translateY(-3px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.asset-type-card.selected {
  border: 1px solid #fff;
  background: rgba(80, 80, 85, 0.6);
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.25);
}

.asset-type-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
}

.type-icon {
  font-size: 24px;
  color: white;
}

.asset-type-name {
  font-size: 16px;
  font-weight: 500;
  margin-top: 8px;
  color: #ffffff;
}

.upload-area-container {
  margin-top: 20px;
}

/* 上传区域样式 */
.upload-section {
  margin-bottom: 30px;
}

.upload-header h3 {
  font-size: 18px;
  margin: 0 0 10px 0;
}

.file-types {
  margin: 0 0 5px 0;
  font-size: 14px;
  color: #a1a1aa;
}

.file-size {
  margin: 0 0 15px 0;
  font-size: 14px;
  color: #a1a1aa;
}

.upload-area {
  border: 2px dashed #e53935;
  border-radius: 12px;
  padding: 40px 20px;
  text-align: center;
  cursor: pointer;
  background: rgba(229, 57, 53, 0.05);
  transition: all 0.2s;
}

.upload-area:hover {
  background: rgba(229, 57, 53, 0.1);
  transform: translateY(-3px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.upload-icons {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-bottom: 15px;
  min-height: 24px;
}

.upload-icon {
  font-size: 24px;
}

.upload-text {
  margin: 5px 0;
  color: #ddd;
}

.hidden-file-input {
  display: none;
}

.wallet-section {
  margin-bottom: 30px;
  padding: 20px;
  background-color: rgba(60, 60, 65, 0.5);
  border-radius: 12px;
  text-align: center;
}

.wallet-placeholder {
  padding: 40px;
  border: 1px dashed rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  margin-top: 20px;
}

.file-required {
  color: #e53935;
  margin: 10px 0 0 0;
  font-size: 14px;
}

.subtitle-zh {
  font-size: 0.85em;
  opacity: 0.8;
  margin-left: 8px;
  font-weight: normal;
}

@media (max-width: 768px) {
  .asset-details-container {
    padding: 30px 20px;
  }
  
  .asset-type-grid {
    flex-direction: column;
    gap: 10px;
  }
  
  .asset-type-card {
    width: 100%;
    flex-direction: row;
    padding: 12px;
    align-items: center;
    justify-content: flex-start;
  }
  
  .asset-type-icon {
    width: 40px;
    height: 40px;
    margin-bottom: 0;
    margin-right: 15px;
  }
  
  .upload-icons {
    gap: 15px;
  }
  
  .upload-area {
    padding: 30px 15px;
  }
}

/* 上传预览样式 */
.uploaded-files-preview {
  margin-bottom: 20px;
}

.preview-files-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
  margin-bottom: 20px;
}

/* 为音频类型添加单列网格布局 */
.preview-files-grid.audio-grid {
  grid-template-columns: 1fr;
  gap: 10px;
}

.preview-file-item {
  position: relative;
  background-color: rgba(30, 30, 35, 0.5);
  border-radius: 8px;
  overflow: hidden;
  aspect-ratio: 1 / 1;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
  cursor: grab;
}

/* 音频文件特殊样式 - 横向列表布局 */
.preview-file-item.audio-file {
  aspect-ratio: auto;
  height: auto;
  display: flex;
  flex-direction: column;
  cursor: default;
  background-color: #12121a;
  padding: 0;
}

.preview-file-item.audio-file:hover {
  background-color: #18181f;
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
}

.preview-file-item:hover {
  border-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.preview-file-item.dragging {
  opacity: 0.6;
  border: 2px dashed rgba(255, 255, 255, 0.5);
  transform: scale(0.95);
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.preview-file-item.drag-over {
  border: 2px solid rgba(255, 255, 255, 0.7);
  transform: scale(1.05);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
  position: relative;
}

.preview-file-item.drag-over::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.1);
  z-index: 2;
  pointer-events: none;
}

.drag-handle {
  position: absolute;
  top: 5px;
  left: 5px;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius: 4px;
  color: white;
  cursor: grab;
  opacity: 0;
  transition: opacity 0.2s;
  z-index: 2;
}

.preview-file-item:hover .drag-handle {
  opacity: 0.8;
}

.drag-handle:hover {
  opacity: 1 !important;
  background-color: rgba(70, 70, 70, 0.9);
}

.drag-icon {
  font-size: 12px;
  font-weight: bold;
  user-select: none;
}

.drag-hint {
  text-align: center;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  margin: 8px 0 0;
  font-style: italic;
}

.preview-file-content {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.preview-video {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-media {
  max-width: 100%;
  max-height: 100%;
}

.preview-audio {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  background-color: #12121a;
  border-radius: 8px;
  overflow: hidden;
  padding: 16px;
  cursor: default;
  position: relative;
}

/* 音频文件的特殊样式 */
.preview-file-item.audio-file .preview-audio {
  min-height: auto;
  padding: 10px 14px;
  height: auto;
  width: 100%;
}

.audio-track-row {
  display: flex;
  align-items: center;
  width: 100%;
  gap: 16px;
  margin-bottom: 12px;
}

.audio-left {
  display: flex;
  align-items: center;
}

.audio-play-circle {
  width: 40px;
  height: 40px;
  background-color: #18181f;
}

.play-button {
  width: 32px;
  height: 32px;
}

.play-icon {
  color: white;
  font-size: 14px;
  margin-left: 2px;
}

.audio-info {
  flex: 1;
  overflow: hidden;
}

.audio-title-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.audio-title {
  font-size: 14px;
  font-weight: 500;
  color: white;
  margin-bottom: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
}

.audio-menu-dots {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 0 8px;
  transition: color 0.2s;
}

.audio-menu-dots:hover {
  color: white;
}

.audio-subtitle {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 4px;
}

.audio-details {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  width: 100%;
  gap: 10px;
}

.audio-format {
  background-color: rgba(80, 80, 255, 0.2);
  padding: 1px 6px;
  font-size: 11px;
}

.audio-duration {
  font-size: 11px;
}

.audio-waveform {
  margin-top: 0;
}

.waveform-display {
  width: 100%;
  height: 32px;
  background: rgba(30, 30, 40, 0.5);
  border-radius: 4px;
  position: relative;
  overflow: hidden;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.waveform-display::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.05) 2px,
    rgba(255, 255, 255, 0.05) 3px,
    transparent 3px,
    transparent 4px,
    rgba(255, 255, 255, 0.1) 4px,
    rgba(255, 255, 255, 0.1) 5px,
    transparent 5px,
    transparent 7px,
    rgba(255, 255, 255, 0.15) 7px,
    rgba(255, 255, 255, 0.15) 8px,
    transparent 8px,
    transparent 10px,
    rgba(255, 255, 255, 0.2) 10px,
    rgba(255, 255, 255, 0.2) 11px,
    transparent 11px,
    transparent 14px,
    rgba(255, 255, 255, 0.1) 14px,
    rgba(255, 255, 255, 0.1) 15px,
    transparent 15px,
    transparent 17px,
    rgba(255, 255, 255, 0.05) 17px,
    rgba(255, 255, 255, 0.05) 18px,
    transparent 18px,
    transparent 21px
  );
}

.waveform-progress {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  background: linear-gradient(
    90deg, 
    rgba(0, 0, 0, 0.5) 0%,
    rgba(0, 0, 0, 0.7) 100%
  );
  z-index: 1;
}

.waveform-progress::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.1) 2px,
    rgba(255, 255, 255, 0.1) 3px,
    transparent 3px,
    transparent 4px,
    rgba(255, 255, 255, 0.2) 4px,
    rgba(255, 255, 255, 0.2) 5px,
    transparent 5px,
    transparent 7px,
    rgba(255, 255, 255, 0.3) 7px,
    rgba(255, 255, 255, 0.3) 8px,
    transparent 8px,
    transparent 10px,
    rgba(255, 255, 255, 0.4) 10px,
    rgba(255, 255, 255, 0.4) 11px,
    transparent 11px,
    transparent 14px,
    rgba(255, 255, 255, 0.2) 14px,
    rgba(255, 255, 255, 0.2) 15px,
    transparent 15px,
    transparent 17px,
    rgba(255, 255, 255, 0.1) 17px,
    rgba(255, 255, 255, 0.1) 18px,
    transparent 18px,
    transparent 21px
  );
}

.preview-file-item.audio-file .waveform-display {
  height: 24px;
  background: rgba(20, 20, 35, 0.5);
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
  border-radius: 4px;
}

.preview-file-item.audio-file .waveform-display::before {
  background-image: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.03) 2px,
    rgba(255, 255, 255, 0.03) 3px,
    transparent 3px,
    transparent 4px,
    rgba(255, 255, 255, 0.06) 4px,
    rgba(255, 255, 255, 0.06) 5px,
    transparent 5px,
    transparent 6px,
    rgba(255, 255, 255, 0.09) 6px,
    rgba(255, 255, 255, 0.09) 7px,
    transparent 7px,
    transparent 9px,
    rgba(255, 255, 255, 0.12) 9px,
    rgba(255, 255, 255, 0.12) 10px,
    transparent 10px,
    transparent 13px,
    rgba(255, 255, 255, 0.06) 13px,
    rgba(255, 255, 255, 0.06) 14px,
    transparent 14px,
    transparent 16px,
    rgba(255, 255, 255, 0.03) 16px,
    rgba(255, 255, 255, 0.03) 17px,
    transparent 17px,
    transparent 19px
  );
}

.preview-file-item.audio-file .waveform-progress::before {
  background-image: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.05) 2px,
    rgba(255, 255, 255, 0.05) 3px,
    transparent 3px,
    transparent 4px,
    rgba(255, 255, 255, 0.1) 4px,
    rgba(255, 255, 255, 0.1) 5px,
    transparent 5px,
    transparent 6px,
    rgba(255, 255, 255, 0.15) 6px,
    rgba(255, 255, 255, 0.15) 7px,
    transparent 7px,
    transparent 9px,
    rgba(255, 255, 255, 0.2) 9px,
    rgba(255, 255, 255, 0.2) 10px,
    transparent 10px,
    transparent 13px,
    rgba(255, 255, 255, 0.1) 13px,
    rgba(255, 255, 255, 0.1) 14px,
    transparent 14px,
    transparent 16px,
    rgba(255, 255, 255, 0.05) 16px,
    rgba(255, 255, 255, 0.05) 17px,
    transparent 17px,
    transparent 19px
  );
}

/* 为音频文件添加特殊的拖拽手柄和删除按钮样式，使其位于右侧 */
.preview-file-item.audio-file .drag-handle {
  top: 50%;
  left: auto;
  right: 35px;
  transform: translateY(-50%);
  background-color: transparent;
  opacity: 0.4;
}

.preview-file-item.audio-file .remove-file-btn {
  top: 50%;
  right: 5px;
  transform: translateY(-50%);
  background-color: rgba(0, 0, 0, 0.3);
}

.preview-file-item.audio-file:hover .drag-handle,
.preview-file-item.audio-file:hover .remove-file-btn {
  opacity: 0.8;
}

.hidden-audio {
  display: none;
}

.preview-document {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 10px;
}

.document-icon {
  width: 50px;
  height: 50px;
  border-radius: 10px;
  background-color: rgba(100, 200, 100, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
}

.doc-icon {
  font-size: 30px;
}

.document-name {
  font-size: 12px;
  margin: 0;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  max-width: 100%;
}

.remove-file-btn {
  position: absolute;
  top: 5px;
  right: 5px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 14px;
  opacity: 0;
  transition: opacity 0.2s;
  z-index: 2;
}

.preview-file-item:hover .remove-file-btn {
  opacity: 1;
}

.remove-file-btn:hover {
  background-color: rgba(229, 57, 53, 0.8);
}

@media (max-width: 1024px) {
  .preview-files-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .preview-files-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  /* ... existing mobile styles ... */
}

@media (max-width: 480px) {
  .preview-files-grid {
    grid-template-columns: 1fr;
  }
}

/* 创作者页面样式 */
.creators-container {
  width: 100%;
  height: 100%;
  padding: 40px 50px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  overflow: auto;
  background-color: #212121;
  color: white;
}

.add-creators-section {
  margin-bottom: 30px;
  background-color: rgba(30, 30, 35, 0.3);
  border-radius: 12px;
  padding: 20px;
}

.add-creators-section h3 {
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 18px;
  font-weight: 500;
}

.creators-input-row {
  display: flex;
  gap: 15px;
  align-items: center;
}

.creator-input {
  flex: 1;
  background-color: rgba(20, 20, 25, 0.5);
}

.add-creator-btn {
  height: 50px;
  border-radius: 8px;
  background-color: #333;
  color: white;
  border: none;
  padding: 0 25px;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.add-creator-btn:hover:not(:disabled) {
  background-color: #444;
}

.add-creator-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.plus-icon {
  margin-left: 5px;
  font-size: 18px;
}

.creators-list-section {
  margin-bottom: 30px;
  flex: 1;
}

.creators-list-section h3 {
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 18px;
  font-weight: 500;
}

.creator-item {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.3);
  border-radius: 12px;
  padding: 15px;
  margin-bottom: 15px;
  position: relative;
}

.creator-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #2f2f2f;
  flex-shrink: 0;
}

.avatar-image {
  font-size: 28px;
}

.creator-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.creator-name {
  font-size: 17px;
  font-weight: 500;
}

.creator-role, .creator-wallet {
  font-size: 14px;
  color: #a1a1aa;
}

.remove-creator-btn {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 18px;
  transition: all 0.2s;
}

.remove-creator-btn:hover {
  background-color: rgba(229, 57, 53, 0.8);
}

@media (max-width: 768px) {
  .creators-container {
    padding: 30px 20px;
  }
  
  .creators-input-row {
    flex-direction: column;
  }
  
  .add-creator-btn {
    width: 100%;
  }
}

.license-filter-list {
  margin: 10px 0 30px;
  max-width: 900px;
  margin: 0 auto;
  padding: 10px 5px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
}

@media (max-width: 768px) {
  .license-filter-list {
    grid-template-columns: 1fr;
  }
}

.license-filter-item {
  display: flex;
  flex-direction: column;
  background-color: rgba(60, 60, 65, 0.5);
  border-radius: 14px;
  margin-bottom: 0;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  position: relative;
}

.license-filter-item.expanded {
  background-color: rgba(70, 70, 75, 0.6);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
  transform: translateY(-2px);
  z-index: 10;
  border-color: rgba(255, 255, 255, 0.2);
}

.filter-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 18px;
  cursor: pointer;
  position: relative;
  z-index: 2;
}

.filter-right {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 160px; /* Ensure the width is maintained even when status is hidden */
  justify-content: flex-end;
}

.expand-arrow {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.7);
  transition: transform 0.3s ease;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.expand-arrow span {
  display: inline-block;
  transition: all 0.3s ease;
}

.expand-arrow span.rotated {
  transform: rotate(180deg);
}

.filter-content {
  padding: 0 18px 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.07);
  background-color: rgba(70, 70, 75, 0.6);
  text-align: center;
  animation: fadeIn 0.2s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.filter-question {
  margin: 16px 0;
}

.filter-question h4 {
  font-size: 15px;
  font-weight: 500;
  margin: 0 0 8px 0;
  color: #fff;
}

.filter-question p {
  font-size: 13px;
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
}

.filter-description {
  margin-bottom: 16px;
  padding: 12px;
  background-color: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  text-align: left;
}

.en-description {
  font-size: 14px;
  margin: 0 0 5px 0;
  color: #fff;
}

.cn-description {
  font-size: 13px;
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
}

.filter-options {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 16px;
  justify-content: center;
}

.option-btn {
  min-width: 100px;
  padding: 8px 12px;
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background-color: rgba(24, 24, 28, 0.8);
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: center;
}

.option-btn:hover {
  background-color: rgba(35, 35, 40, 0.9);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.option-btn.selected {
  border-color: rgba(255, 255, 255, 0.4);
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.yes-btn.selected {
  background-color: rgba(0, 0, 0, 0.4);
  color: rgb(255, 255, 255);
}

.no-btn.selected {
  background-color: rgba(0, 0, 0, 0.4);
  color: rgb(255, 255, 255);
}

.expiration-btn.selected {
  background-color: rgba(0, 0, 0, 0.4);
}

.filter-clear {
  display: block;
  padding: 6px 16px;
  font-size: 13px;
  background-color: transparent;
  color: #fff;
  border: none;
  border-radius: 16px;
  cursor: pointer;
  margin-left: auto;
  transition: all 0.2s;
}

.filter-clear:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.license-filter-item:before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 3px;
  height: 100%;
  opacity: 0.9;
  transition: all 0.3s ease;
}

.license-filter-item:nth-child(1):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(2):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(3):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(4):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(5):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:nth-child(6):before {
  background-color: rgba(0, 0, 0, 0.8);
}

.license-filter-item:hover:not(.expanded) {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
  background-color: rgba(70, 70, 75, 0.6);
}

.license-filter-item:hover:before {
  width: 5px;
}

.filter-left {
  display: flex;
  align-items: center;
  gap: 15px;
}

.filter-icon {
  font-size: 22px;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.filter-header:hover .filter-icon {
  transform: scale(1.05);
}

.filter-text {
  font-size: 16px;
  font-weight: 500;
  color: #fff;
  transition: color 0.3s;
}

.filter-status {
  padding: 8px 16px;
  border-radius: 30px;
  font-size: 14px;
  font-weight: 600;
  text-align: center;
  min-width: 110px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  opacity: 0;
  visibility: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
}

.license-filter-item.expanded .filter-status,
.filter-status.active {
  opacity: 1;
  visibility: visible;
}

.filter-header:hover .filter-status:before {
  opacity: 1;
}

.filter-status.allowed {
  background-color: rgba(0, 0, 0, 0.3);
  color: rgb(255, 255, 255);
}

.filter-status.required {
  background-color: rgba(0, 0, 0, 0.3);
  color: rgb(255, 255, 255);
}

.filter-status.never {
  background-color: rgba(0, 0, 0, 0.3);
  color: rgb(255, 255, 255);
}

.filter-status.off {
  background-color: rgba(0, 0, 0, 0.3);
  color: rgb(255, 255, 255);
}

.clear-btn-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.clear-all-btn {
  background-color: rgba(40, 40, 45, 0.6);
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 30px;
  padding: 10px 24px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 8px;
  position: relative;
  overflow: hidden;
  letter-spacing: 0.5px;
}

.clear-all-btn:hover {
  background-color: rgba(60, 60, 65, 0.8);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.clear-all-btn:active {
  transform: translateY(0);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
}

.custom-license {
  padding: 15px 30px;
  overflow: auto;
  display: flex;
  flex-direction: column;
  height: 100%;
  background-color: #212121;
}

.fee-input-container {
  width: 100%;
  margin-bottom: 10px;
}

.fee-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 6px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  overflow: hidden;
}

.fee-input {
  flex: 1;
  background: transparent;
  border: none;
  color: white;
  padding: 10px 12px;
  font-size: 16px;
  outline: none;
}

.fee-currency {
  padding: 10px 12px;
  background-color: rgba(0, 0, 0, 0.2);
  font-size: 14px;
  color: #bbb;
}

.expiration-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  width: 100%;
}

.expiration-btn {
  width: 100%;
  text-align: center;
}

.question-title {
  text-align: center;
  font-size: 18px;
  font-weight: 500;
  margin: 15px 0;
  color: #ffffff;
  background-color: #1e1e1e;
  padding: 10px;
  border-radius: 4px;
  width: 100%;
}

.start-container {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #3a3a3a;
  color: white;
  position: relative;
  overflow: hidden;
  padding: 20px;
}

.card-container {
  display: flex;
  gap: 20px;
  margin-top: 40px;
  justify-content: center;
  z-index: 1;
  background-color: rgba(80, 80, 80, 0.25);
  border-radius: 20px;
  padding: 50px;
  backdrop-filter: blur(5px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.menu-title {
  display: none;
}

@media (max-width: 900px) {
  .menu-options {
    flex-direction: column;
    gap: 30px;
    margin-top: 40px;
  }
  
  .menu-card {
    width: 180px;
    height: 200px;
    margin: 0;
    transform: rotate(0deg) !important;
    background: linear-gradient(rgba(255, 255, 255, 0.35), rgba(255, 255, 255, 0.15));
  }
  
  .menu-options:hover .menu-card {
    margin: 0;
    box-shadow: 0 25px 25px rgba(0, 0, 0, 0.35);
  }
  
  .menu-card:hover {
    transform: translateY(-5px) !important; /* Reduced lift effect on mobile */
  }
}

/* 作品类型选择页面样式 */
.work-type-container {
  width: 100%;
  height: 100%;
  padding: 70px 70px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background-color: #303030;
}

.title-with-subtitle {
  font-size: 27px;
  margin: 0 0 8px 0;
  font-weight: 600;
  text-align: center;
  color: white;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.subtitle-zh {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.6);
  margin: 0 0 50px 0;
  font-weight: normal;
  text-align: center;
}

.work-type-options {
  margin-top: 20px;
  display: flex;
  gap: 40px;
  flex-direction: row;
  justify-content: space-between;
}

.work-type-card {
  display: flex;
  flex-direction: column;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  padding: 0;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(100, 100, 100, 0.35);
  width: calc(50% - 15px);
  overflow: hidden;
  backdrop-filter: blur(15px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5);
  height: 180px;
  position: relative;
}

.work-type-content {
  padding: 30px 35px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  height: 100%;
}

.work-type-icon {
  width: 50px;
  height: 50px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 22px;
  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.25);
}

.work-type-content h2 {
  font-size: 22px;
  margin: 0 0 8px 0;
  display: flex;
  align-items: center;
  color: #ffffff;
}

.work-description {
  margin: 5px 0 0 0;
  color: rgba(255, 255, 255, 0.6);
  font-size: 15px;
  line-height: 1.5;
}

.navigation {
  margin-top: 60px;
  display: flex;
  justify-content: space-between;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
  padding-top: 40px;
}

.back-btn, .next-btn {
  padding: 12px 25px;
  border-radius: 30px;
  border: none;
  cursor: pointer;
  font-size: 15px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s;
}

/* License card styles */
.license-card::after {
  content: '添加此许可证 →';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 34px;
  background-color: #000;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px;
  font-weight: 400;
  opacity: 0;
  transition: opacity 0.2s ease;
  z-index: 10;
  letter-spacing: 0.2px;
}

.license-card:hover::after {
  opacity: 1;
}

.license-card.selected::after {
  content: '移除此许可证 ×';
  background-color: #1a1a1a;
}

.license-tag {
  display: inline-flex;
  align-items: center;
  padding: 3px 8px;
  border-radius: 15px;
  font-size: 12px;
  font-weight: 400;
  background-color: rgba(0, 0, 0, 0.6);
  color: rgba(255, 255, 255, 0.9);
}

.license-tag.blue {
  background-color: rgba(0, 0, 0, 0.7);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.license-tag.purple {
  background-color: rgba(0, 0, 0, 0.7);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.license-tag.green {
  background-color: rgba(0, 0, 0, 0.7);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.license-tag.red {
  background-color: rgba(0, 0, 0, 0.7);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.license-icon {
  margin-right: 6px;
  font-style: normal;
}

.work-type-card:hover {
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75));
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(150, 150, 150, 0.5);
}

.work-type-card.selected {
  border: 1px solid rgba(150, 150, 150, 0.7);
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8));
  transform: translateY(-8px);
  box-shadow: 0 30px 35px rgba(0, 0, 0, 0.4);
}

.work-type-icon.new-icon {
  background-color: #000000;
}

.work-type-icon.remix-icon {
  background-color: #000000;
}

.type-label {
  font-size: 12px;
  background-color: rgba(50, 50, 50, 0.6);
  padding: 3px 8px;
  border-radius: 15px;
  margin-left: 10px;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.9);
}

.asset-type-icon svg {
  width: 40px;
  height: 40px;
  fill: white;
  opacity: 0.9;
}

.asset-type-card.selected .asset-type-icon svg {
  fill: white;
  opacity: 1;
}

.placeholder-icon {
  display: none;
}

.asset-type-icon {
  display: none;
}

.asset-type-icon-container {
  display: none;
}

.empty-upload-icon {
  width: 24px;
  height: 24px;
  margin: 0 10px;
  display: inline-block;
}

.audio-placeholder {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background-color: rgba(100, 100, 255, 0.2);
  margin-bottom: 10px;
}

.document-placeholder {
  width: 50px;
  height: 50px;
  border-radius: 10px;
  background-color: rgba(100, 200, 100, 0.2);
  margin-bottom: 10px;
}

.type-icon-placeholder {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.7;
}

.asset-type-card.selected .monitor-svg,
.asset-type-card:hover .monitor-svg {
  opacity: 1;
}

.asset-type-card.selected .type-icon-placeholder,
.asset-type-card:hover .type-icon-placeholder {
  opacity: 1;
}

.asset-type-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 20px 15px;
}

.monitor-svg {
  width: 100%;
  height: 100%;
  max-width: 80px;
  max-height: 80px;
  fill: #ffffff;
  opacity: 0.9;
  margin-bottom: 8px;
}

#picture.monitor-svg {
  max-width: 88px;
  max-height: 88px;
}

.monitor-svg path,
.monitor-svg polygon {
  fill: #ffffff;
}

.asset-type-card.selected .monitor-svg {
  opacity: 1;
}

.asset-type-card.selected .monitor-svg path,
.asset-type-card.selected .monitor-svg polygon {
  fill: #ffffff;
}

.type-icon-placeholder {
  width: 50px;
  height: 50px;
  margin-bottom: 15px;
  opacity: 0.7;
}

.asset-type-name {
  font-size: 13px;
  margin: 0;
  text-align: center;
  opacity: 0.85;
}

.asset-type-card.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  filter: grayscale(1);
  pointer-events: none;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.asset-type-card.disabled .monitor-svg {
  opacity: 0.4;
}

.asset-type-card.disabled .asset-type-name {
  opacity: 0.5;
}

/* Remove the unused styles */

/* Error message styles */
.file-type-error {
  position: fixed;
  top: 20px;
  right: 20px;
  background: rgba(200, 0, 0, 0.85);
  border-radius: 8px;
  padding: 12px 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  z-index: 1000;
  max-width: 350px;
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.error-content {
  display: flex;
  align-items: center;
  gap: 10px;
}

.error-icon {
  font-size: 18px;
}

.error-message {
  font-size: 14px;
  flex: 1;
  color: white;
}

.error-close {
  background: none;
  border: none;
  color: white;
  font-size: 18px;
  cursor: pointer;
  padding: 0;
  margin: 0;
  opacity: 0.8;
  transition: opacity 0.2s;
}

.error-close:hover {
  opacity: 1;
}

/* Add to style section */
.upload-type-info {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.8);
  background: rgba(0, 0, 0, 0.15);
  padding: 8px 12px;
  border-radius: 6px;
  margin-top: 8px;
  border-left: 3px solid rgba(0, 0, 0, 0.7);
}

.info-icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

.info-icon svg {
  width: 18px;
  height: 18px;
  margin-right: 4px;
}

.selected-licenses-header {
  grid-column: span 2; /* 跨两列显示 */
  margin-bottom: 20px;
  background: rgba(40, 40, 45, 0.5);
  border-radius: 12px;
  padding: 16px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  width: 100%;
}

.selected-licenses-header h3 {
  margin-top: 0;
  margin-bottom: 15px;
  font-size: 18px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.license-count {
  background: rgba(0, 0, 0, 0.5);
  color: rgba(255, 255, 255, 0.9);
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 14px;
}

.selected-licenses-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 8px;
}

.selected-license-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  width: 100%;
}

.selected-license-tag {
  background: rgba(70, 70, 75, 0.6);
  border-radius: 20px;
  padding: 5px 12px;
  font-size: 14px;
  color: #fff;
  display: inline-flex;
  align-items: center;
  gap: 5px;
  border: 1px solid rgba(255, 255, 255, 0.15);
}

.remove-tag {
  cursor: pointer;
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
  width: 18px;
  height: 18px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.2);
  margin-left: 5px;
  transition: all 0.2s;
}

.remove-tag:hover {
  background: rgba(0, 0, 0, 0.4);
  color: white;
}

.no-licenses {
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
  font-size: 14px;
  padding: 5px 0;
  width: 100%;
  text-align: center;
}

/* 许可证标签样式 */
.license-tag {
  display: inline-flex;
  align-items: center;
  font-size: 12px;
  padding: 4px 8px;
  border-radius: 4px;
  gap: 4px;
}

.license-tag.blue {
  background-color: rgba(0, 122, 255, 0.15);
  color: #0077ff;
}

.license-tag.purple {
  background-color: rgba(175, 82, 222, 0.15);
  color: #af52de;
}

.license-tag.green {
  background-color: rgba(52, 199, 89, 0.15);
  color: #34c759;
}

.license-tag.red {
  background-color: rgba(255, 59, 48, 0.15);
  color: #ff3b30;
}

.license-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-style: normal;
}

/* 许可证冲突弹窗样式 */
.license-conflict-modal {
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
  backdrop-filter: blur(5px);
  animation: modalFadeIn 0.3s ease;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.modal-content {
  background-color: #212121;
  border-radius: 16px;
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4);
  max-width: 550px;
  width: 90%;
  overflow: hidden;
  transform: translateY(0);
  animation: modalSlideIn 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

@keyframes modalSlideIn {
  from {
    transform: translateY(50px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  background-color: rgba(40, 40, 45, 0.6);
}

.modal-header h2 {
  margin: 0;
  font-size: 22px;
  font-weight: 600;
}

.close-btn {
  font-size: 28px;
  font-weight: 300;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.6);
  transition: color 0.2s;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
}

.close-btn:hover {
  color: white;
  background-color: rgba(255, 255, 255, 0.1);
}

.modal-body {
  padding: 24px;
  color: #f5f5f5;
}

.conflict-icon {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.conflict-info {
  margin-bottom: 30px;
}

.conflict-title {
  font-size: 16px;
  font-weight: 500;
  margin: 15px 0 8px;
}

.conflict-license {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  padding: 12px 16px;
  background-color: rgba(60, 60, 65, 0.5);
  border-radius: 8px;
  margin-bottom: 15px;
}

.conflict-license.new-license {
  border-left: 3px solid #000000;
}

.conflict-license.existing-license {
  border-left: 3px solid #000000;
}

.conflict-reason {
  font-size: 15px;
  line-height: 1.5;
  background-color: rgba(60, 60, 65, 0.5);
  padding: 12px 16px;
  border-radius: 8px;
  border-left: 3px solid #000000;
}

.reason-label {
  font-weight: 500;
  margin-right: 6px;
}

.valid-combinations {
  background-color: rgba(40, 40, 45, 0.5);
  border-radius: 12px;
  padding: 16px;
  margin-top: 24px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}

.valid-combinations h3 {
  margin: 0 0 16px 0;
  font-size: 18px;
  font-weight: 500;
  text-align: center;
  color: #ffffff;
}

.combination {
  display: flex;
  justify-content: center;
  margin-bottom: 15px;
}

.combination:last-child {
  margin-bottom: 0;
}

.combination-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.plus-sign {
  font-size: 18px;
  font-weight: 300;
  color: rgba(255, 255, 255, 0.6);
}

.modal-footer {
  padding: 16px 24px;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  background-color: rgba(40, 40, 45, 0.6);
}

.modal-btn {
  padding: 10px 24px;
  border-radius: 30px;
  cursor: pointer;
  font-size: 15px;
  font-weight: 500;
  transition: all 0.2s;
  border: none;
  outline: none;
}

.cancel-btn {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.15);
}

.cancel-btn:hover {
  background-color: rgba(255, 255, 255, 0.15);
  transform: translateY(-2px);
}

.combination-note {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
  margin-left: 5px;
}

/* AI权限设置页面样式 */
.ai-permissions-container {
  width: 100%;
  height: 100%;
  padding: 40px 50px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  overflow: auto;
  background-color: #212121;
  color: white;
}

.ai-permissions-header {
  margin-bottom: 32px;
  flex-shrink: 0;
  text-align: left;
}

h1.ai-title-main {
  font-size: 34px;
  margin: 0 0 12px 0;
  font-weight: 600;
  letter-spacing: -0.5px;
}

.ai-subtitle {
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
  font-size: 16px;
  line-height: 1.5;
}

.ai-card {
  background-color: rgba(35, 35, 40, 0.5);
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(60, 60, 65, 0.3);
  max-width: 700px;
}

.ai-card-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.ai-card-text {
  flex: 1;
}

.ai-card-title {
  font-size: 18px;
  font-weight: 500;
  color: white;
}

.simple-switch {
  position: relative;
  cursor: pointer;
  flex-shrink: 0;
}

.switch-track {
  width: 48px;
  height: 28px;
  border-radius: 14px;
  background-color: rgba(50, 50, 50, 0.7);
  transition: background-color 0.2s ease;
  border: 1px solid rgba(255, 255, 255, 0.15);
  position: relative;
}

.switch-track.active {
  background-color: #00e676;
  border-color: rgba(0, 230, 118, 0.5);
}

.switch-indicator {
  width: 20px;
  height: 20px;
  background-color: white;
  border-radius: 50%;
  position: absolute;
  top: 4px;
  left: 4px;
  transition: transform 0.2s ease;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
}

.switch-track.active .switch-indicator {
  transform: translateX(20px);
}

.ai-navigation {
  margin-top: auto;
  display: flex;
  justify-content: space-between;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
  padding-top: 40px;
}

.ai-back-btn, .ai-next-btn {
  padding: 12px 25px;
  border-radius: 30px;
  border: none;
  cursor: pointer;
  font-size: 15px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s;
}

.ai-back-btn {
  background: rgba(255, 255, 255, 0.15);
  color: white;
  backdrop-filter: blur(5px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.ai-back-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.ai-next-btn {
  background: white;
  color: #222;
  box-shadow: 0 5px 12px rgba(0, 0, 0, 0.1);
}

.ai-next-btn:hover {
  background: #f0f0f0;
  transform: translateY(-2px);
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
}

.license-tag.blue svg path,
.license-tag.blue svg polygon,
.ai-card-icon svg path,
.ai-card-icon svg polygon {
  fill: white;
}

.license-icon {
  margin-right: 6px;
  vertical-align: middle;
}

.switch {
  position: relative;
  display: inline-block;
  width: 44px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(50, 50, 50, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.15);
  transition: .3s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 2px;
  background-color: white;
  transition: .3s;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
}

input:checked + .slider {
  background-color: #00e676;
  border-color: rgba(0, 230, 118, 0.5);
}

input:checked + .slider:before {
  transform: translateX(20px);
}

.slider.round {
  border-radius: 12px;
}

.slider.round:before {
  border-radius: 50%;
}

/* From Uiverse.io by vinodjangid07 */
/* To hide the checkbox */
#aiTrainingCheckbox {
  display: none;
}

.toggleSwitch {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  width: 50px;
  height: 17px;
  background-color: rgb(82, 82, 82);
  border-radius: 20px;
  cursor: pointer;
  transition-duration: .2s;
}

.toggleSwitch::after {
  content: "";
  position: absolute;
  height: 22px;
  width: 22px;
  left: 0px;
  background-color: rgb(41, 41, 41);
  border-radius: 50%;
  transition-duration: .2s;
  border: 2px solid rgb(82, 82, 82);
}

#checkboxInput:checked+.toggleSwitch::after {
  transform: translateX(100%);
  transition-duration: .2s;
  border: 2px solid rgb(165, 255, 105);
}

/* Switch background change */
#checkboxInput:checked+.toggleSwitch {
  background-color: rgb(165, 255, 105);
  transition-duration: .2s;
}

.new-toggle-container {
  margin-right: 5px;
}

.new-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  width: 46px;
  height: 28px;
  background-color: #2B2C30;
  border-radius: 30px;
  cursor: pointer;
  transition-duration: .2s;
  border: 1px solid #333;
}

.new-toggle.active {
  background-color: #00E676;
  border-color: #00B259;
}

.new-toggle-circle {
  position: absolute;
  height: 22px;
  width: 22px;
  left: 3px;
  top: 50%;
  transform: translateY(-50%);
  background-color: #444;
  border-radius: 50%;
  transition-duration: .2s;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.4);
}

.new-toggle.active .new-toggle-circle {
  transform: translate(19px, -50%);
  background-color: white;
}

.ai-card-icon {
  margin-right: 8px;
}

/* 审核与注册页面样式 */
.review-register-container {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: auto;
  background-color: #121212;
  color: white;
  padding: 0;
}

.review-content {
  width: 100%;
  height: 100%;
  position: relative;
  display: flex;
  flex-direction: column;
}

.close-review-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  background: none;
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
  z-index: 10;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background-color 0.2s;
}

.close-review-btn:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.review-header {
  padding: 30px 40px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.review-header h1 {
  font-size: 32px;
  margin: 0 0 8px 0;
  font-weight: 600;
}

.review-subtitle {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.6);
  margin: 0;
}

.review-sections {
  flex: 1;
  padding: 0;
  overflow: auto;
}

.sections-container {
  padding: 20px 40px;
  display: flex;
  flex-direction: column;
}

.review-section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.section-title {
  font-size: 18px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  margin: 0;
}

.licenses-header-row {
  margin-top: 30px;
}

.asset-section {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 20px;
  width: 100%;
}

.asset-preview-card {
  position: relative;
  background-color: #1a1a1a;
  border-radius: 12px;
  overflow: hidden;
  width: 100%;
  transition: transform 0.2s, box-shadow 0.2s;
  display: flex;
  flex-direction: column;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.asset-preview-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5);
}

/* Special case for audio files - allow them to be smaller */
.asset-preview-card.audio-asset {
  grid-column: span 1;
}

/* All other asset types - force them to maintain 4 per row */
.asset-preview-card:not(.audio-asset) {
  grid-column: span 1;
}

.asset-image-container {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background-color: #0f0f0f;
  border-radius: 8px 8px 0 0;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.asset-preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.asset-preview-info {
  padding: 12px;
  background-color: #111;
  border-radius: 0 0 12px 12px;
}

.asset-source {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 4px;
}

.asset-name {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  color: rgba(255, 255, 255, 0.9);
}

.asset-owner {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
}

.asset-owner-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.5);
}

.avatar-badge {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(255, 255, 0, 0.15);
  border-radius: 50%;
  width: 24px;
  height: 24px;
}

.owner-icon {
  color: #ffcc00;
  font-size: 12px;
}

.add-license-btn {
  padding: 6px 14px;
  border-radius: 5px;
  background-color: #333;
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.2);
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.add-license-btn:hover {
  background-color: #444;
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

.licenses-section {
  margin-bottom: 20px;
}

.review-actions {
  padding: 20px 40px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.back-review-btn {
  padding: 12px 25px;
  border-radius: 50px;
  background-color: transparent;
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s;
}

.back-review-btn:hover {
  background-color: rgba(255, 255, 255, 0.05);
  transform: translateY(-2px);
}

.register-btn {
  padding: 12px 30px;
  border-radius: 50px;
  background: linear-gradient(to right, #4a36e0, #9039b5);
  color: white;
  border: none;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  box-shadow: 0 4px 15px rgba(74, 54, 224, 0.3);
  transition: all 0.2s;
}

.register-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(74, 54, 224, 0.4);
}

.no-licenses-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30px 20px;
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
  font-size: 14px;
}

/* 新增的缩略图样式 */
.main-preview {
  width: 100%;
  height: 180px;
  overflow: hidden;
  background-color: #333;
  margin-bottom: 4px;
}

.thumbnails-row {
  display: flex;
  height: 36px;
  gap: 4px;
  overflow: hidden;
}

.thumbnail-item {
  width: 36px;
  height: 36px;
  border-radius: 4px;
  overflow: hidden;
  position: relative;
  background-color: #252525;
}

.thumbnail-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.thumbnail-video,
.thumbnail-audio,
.thumbnail-file {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
}

.more-thumbnails {
  width: 36px;
  height: 36px;
  border-radius: 4px;
  background-color: rgba(60, 60, 60, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: white;
}

/* 文件展示样式 */
.files-gallery {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 15px;
  background-color: #1a1a1a;
}

.gallery-item {
  display: flex;
  flex-direction: column;
  background-color: #2a2a2a;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.gallery-image-container, 
.gallery-video-container {
  width: 100%;
  height: 180px;
  background-color: #222;
  display: flex;
  align-items: center;
  justify-content: center;
}

.gallery-image, .gallery-video {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.gallery-audio-container, 
.gallery-file-container {
  width: 100%;
  height: 100px;
  background-color: #252525;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 15px;
}

.audio-info-display {
  display: flex;
  align-items: center;
  width: 100%;
}

.audio-icon-large, .file-icon-large {
  font-size: 36px;
  margin-right: 15px;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.1);
}

.audio-details-display {
  flex: 1;
}

.audio-name, .file-name {
  font-size: 16px;
  margin-bottom: 5px;
  color: white;
  font-weight: 500;
}

.audio-format-duration {
  display: flex;
  gap: 15px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
}

.gallery-item-info {
  padding: 12px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.file-number {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 5px;
}

.file-name-display {
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 5px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.file-type-display {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

.no-files-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 250px;
  background-color: #2a2a2a;
  border-radius: 8px;
  border: 1px dashed rgba(255, 255, 255, 0.2);
}

.placeholder-icon {
  font-size: 48px;
  color: rgba(255, 255, 255, 0.3);
  margin-bottom: 15px;
}

.placeholder-text {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.5);
}

/* 资产预览卡样式 */
.asset-preview-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
  border-color: rgba(70, 70, 70, 0.8);
}

.asset-image-container {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background-color: #333;
  position: relative;
}

.asset-preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.asset-preview-video {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.asset-preview-audio, .asset-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #333;
  color: rgba(255, 255, 255, 0.5);
  font-size: 40px;
}

.asset-preview-info {
  padding: 15px;
}

.asset-source {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 5px;
}

.asset-name {
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 5px;
  color: white;
}

.asset-owner {
  display: flex;
  align-items: center;
  margin-top: 5px;
  justify-content: flex-start;
  gap: 8px;
}

.asset-owner-label {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

.avatar-badge {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(255, 255, 0, 0.2);
  border-radius: 50%;
  width: 24px;
  height: 24px;
}

.owner-icon {
  color: yellow;
  font-size: 10px;
}

/* 许可证列表样式 */
.licenses-list {
  background-color: #212121;
  border-radius: 10px;
  overflow: hidden;
  min-height: 100px;
  border: 1px solid rgba(50, 50, 50, 0.8);
}

.license-item {
  padding: 16px 18px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  transition: background-color 0.2s;
}

.license-item:hover {
  background-color: rgba(255, 255, 255, 0.05);
}

.license-item:last-child {
  border-bottom: none;
}

.license-item-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.license-info {
  display: flex;
  flex-direction: column;
}

.license-name {
  font-size: 15px;
  color: white;
}

.license-actions {
  display: flex;
  align-items: center;
  opacity: 0.7;
  transition: opacity 0.2s;
}

.license-item:hover .license-actions {
  opacity: 1;
}

.license-search-btn, .license-delete-btn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 16px;
  margin-left: 5px;
  border-radius: 50%;
  transition: all 0.2s;
}

.license-search-btn:hover, .license-delete-btn:hover {
  color: white;
  background-color: rgba(255, 255, 255, 0.1);
}

.no-licenses-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30px 20px;
  color: rgba(255, 255, 255, 0.5);
  font-style: italic;
  font-size: 14px;
}

/* New styles for the owner relationship display */
.owners-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 5px;
}

.owner-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.current-owner .avatar-badge {
  background-color: rgba(255, 255, 0, 0.2);
}

.current-owner .owner-icon {
  color: yellow;
}

.creator-badge {
  background-color: rgba(100, 149, 237, 0.2);
}

.creator-badge .owner-icon {
  color: cornflowerblue;
}

.owner-name {
  font-size: 14px;
  color: white;
}

.owner-role, .owner-id {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

/* Updated styles for horizontal avatar display */
.owners-avatar-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  max-width: 120px;
}

.avatar-badge {
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  flex-shrink: 0;
}

.current-owner-badge {
  background-color: rgba(255, 255, 0, 0.2);
}

.current-owner-badge .owner-icon {
  color: yellow;
}

.creator-badge {
  background-color: rgba(100, 149, 237, 0.2);
}

.creator-badge .owner-icon {
  color: cornflowerblue;
}

.more-badge {
  background-color: rgba(150, 150, 150, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  font-size: 10px;
  flex-shrink: 0;
}

.owner-count {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
  text-align: center;
}

.owner-icon {
  font-size: 12px;
}

/* 许可证详情弹窗样式 */
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
  backdrop-filter: blur(5px);
  animation: modalFadeIn 0.3s ease;
}

.license-detail-content {
  background-color: #1e1e1e;
  width: 500px;
  max-width: 90%;
  max-height: 90vh;
  overflow-y: auto;
}

.license-detail-logo {
  display: flex;
  align-items: center;
  gap: 12px;
}

.ip-logo {
  width: 40px;
  height: 40px;
  background-color: black;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 16px;
  color: white;
  border: 2px solid white;
}

.license-detail-title {
  font-size: 20px;
  font-weight: 600;
}

.license-detail-icons {
  display: flex;
  gap: 10px;
  margin-left: 10px;
}

.license-summary, .license-terms {
  margin-bottom: 24px;
}

.license-summary h3, .license-terms h3 {
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 12px;
  color: rgba(255, 255, 255, 0.9);
}

.license-summary p {
  font-size: 14px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.7);
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
  font-size: 18px;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.term-text {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
}

.license-view-legal {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}

.view-legal-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background-color: transparent;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 20px;
  padding: 8px 16px;
  color: white;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.view-legal-btn:hover {
  background-color: rgba(255, 255, 255, 0.1);
  transform: translateY(-2px);
}

.legal-icon {
  font-size: 16px;
}

/* 更新许可证列表中的按钮样式 */
.license-search-btn, .license-delete-btn {
  border-radius: 4px;
}

.search-icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 增加小屏幕下的图标处理 */
.license-icons {
  gap: 8px; /* 在小屏幕上进一步减小图标间距 */
  max-width: calc(100% - 36px); /* 更新检查指示器留白 */
}

.icon {
  width: 20px; /* 稍微减小图标尺寸 */
  height: 20px;
  font-size: 12px; /* 减小图标字体大小 */
}

.check-indicator {
  width: 22px;
  height: 22px;
  font-size: 12px;
}

/* 添加超小屏幕的处理 */
@media (max-width: 380px) {
  .license-card h2 {
    font-size: 16px;
    margin: 6px 14px 6px;
  }
  
  .license-header {
    padding: 12px 14px 0 14px;
  }
  
  .license-content {
    padding: 0 14px;
    margin-bottom: 12px;
  }
  
  .license-description-zh {
    font-size: 13px;
  }
  
  .license-footer {
    padding: 10px 12px; /* 再减小内边距 */
    min-height: 48px; /* 减小最小高度 */
  }
  
  .license-icons {
    gap: 6px; /* 再减小图标间距 */
  }
  
  .icon {
    width: 18px; /* 更小的图标 */
    height: 18px;
    font-size: 11px;
  }
  
  .check-indicator {
    width: 20px;
    height: 20px;
    font-size: 11px;
  }
}

/* 为每种许可证添加特定的底部样式 */
.license-footer-open,
.license-footer-noncommercial,
.license-footer-commercial,
.license-footer-commercial-remix {
  /* 共同基础样式 */
  padding: 15px 16px;
  width: 100%;
  box-sizing: border-box;
  min-height: 54px;
}

/* 图标容器自适应宽度 */
.license-icons-open,
.license-icons-noncommercial,
.license-icons-commercial,
.license-icons-commercial-remix {
  display: flex;
  flex-wrap: nowrap;
  gap: 10px;
  /* 确保每个图标都正常显示 */
  width: calc(100% - 40px);
  min-width: 0; /* 允许容器缩小到内容以下 */
}

/* 确保每个图标都有足够的空间 */
.license-icons-open .icon,
.license-icons-noncommercial .icon,
.license-icons-commercial .icon,
.license-icons-commercial-remix .icon {
  flex: 0 0 22px; /* 固定宽度，不允许缩小 */
  width: 22px;
  height: 22px;
  overflow: hidden; /* 防止内容溢出 */
  font-size: 14px;
}

/* 小屏幕调整 */
@media (max-width: 480px) {
  .license-footer-open,
  .license-footer-noncommercial,
  .license-footer-commercial,
  .license-footer-commercial-remix {
    padding: 12px 14px;
  }
  
  .license-icons-open,
  .license-icons-noncommercial,
  .license-icons-commercial,
  .license-icons-commercial-remix {
    gap: 8px;
  }
  
  .license-icons-open .icon,
  .license-icons-noncommercial .icon,
  .license-icons-commercial .icon,
  .license-icons-commercial-remix .icon {
    flex: 0 0 20px;
    width: 20px;
    height: 20px;
    font-size: 12px;
  }
}

/* 超小屏幕调整 */
@media (max-width: 380px) {
  .license-footer-open,
  .license-footer-noncommercial,
  .license-footer-commercial,
  .license-footer-commercial-remix {
    padding: 10px 12px;
    min-height: 48px;
  }
  
  .license-icons-open,
  .license-icons-noncommercial,
  .license-icons-commercial,
  .license-icons-commercial-remix {
    gap: 6px;
  }
  
  .license-icons-open .icon,
  .license-icons-noncommercial .icon,
  .license-icons-commercial .icon,
  .license-icons-commercial-remix .icon {
    flex: 0 0 18px;
    width: 18px;
    height: 18px;
    font-size: 11px;
  }
}

/* 辉光按钮样式 - From Uiverse.io by Ashon-G */
.uiverse {
  --duration: 7s;
  --easing: linear;
  --c-color-1: rgba(255, 163, 26, 0.7);
  --c-color-2: #1a23ff;
  --c-color-3: #e21bda;
  --c-color-4: rgba(255, 232, 26, 0.7);
  --c-shadow: rgba(255, 223, 87, 0.5);
  --c-shadow-inset-top: rgba(255, 223, 52, 0.9);
  --c-shadow-inset-bottom: rgba(255, 250, 215, 0.8);
  --c-radial-inner: #ffd215;
  --c-radial-outer: #fff172;
  --c-color: #fff;
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
  letter-spacing: 0.02em;
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
  border-radius: 24px;
  box-shadow:
    inset 0 3px 12px var(--c-shadow-inset-top),
    inset 0 -3px 4px var(--c-shadow-inset-bottom);
}

.uiverse .wrapper {
  -webkit-mask-image: -webkit-radial-gradient(white, black);
  overflow: hidden;
  border-radius: 24px;
  min-width: 132px;
  padding: 12px 0;
}

.uiverse .wrapper span {
  display: inline-block;
  position: relative;
  z-index: 1;
}

.uiverse:hover {
  --duration: 1400ms;
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
  animation: var(--animation, none) var(--duration) var(--easing) infinite;
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
</style>