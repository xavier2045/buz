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
          <!-- 开放使用许可 -->
          <div 
            class="license-card" 
            :class="{ selected: selectedLicense === 'open' }"
            @click="selectLicense('open')"
          >
            <div class="license-header">
              <span class="license-tag blue"><i class="license-icon">🔓</i> 限制最少</span>
            </div>
            <h2>开放使用</h2>
            <div class="license-content">
              <p class="license-description-zh">免费分发和混音，无限制、无收入要求、无归属要求</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'open'">✓</div>
            </div>
          </div>

          <!-- 非商业Remix -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'non-commercial' }"
            @click="selectLicense('non-commercial')"
          >
            <div class="license-header">
              <span class="license-tag purple"><i class="license-icon">🏆</i> 为您的作品获得认可</span>
            </div>
            <h2>非商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">任何人都可使用您的作品创建非商业项目</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'non-commercial'">✓</div>
            </div>
          </div>

          <!-- 商业使用 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial' }"
            @click="selectLicense('commercial')"
          >
            <div class="license-header">
              <span class="license-tag green"><i class="license-icon">💲</i> 为您的作品获得报酬</span>
            </div>
            <h2>商业使用</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人按照您设定的经济条款使用您的作品</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="限制混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial'">✓</div>
            </div>
          </div>

          <!-- 商业混音 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial-remix' }"
            @click="selectLicense('commercial-remix')"
          >
            <div class="license-header">
              <span class="license-tag red"><i class="license-icon">💰</i> 获得报酬与认可</span>
            </div>
            <h2>商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人混音您的作品，同时您获得认可和收益</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial-remix'">✓</div>
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
          <button class="next-btn" @click="submitAsset" :disabled="!selectedLicense && activeTabIndex === 0">
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
              <div class="preview-files-grid">
                <div 
                  v-for="(file, index) in uploadedFiles" 
                  :key="index" 
                  class="preview-file-item"
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
                      <AudioFileItem 
                        :name="file.name"
                        artist="Unknown Artist"
                        :duration="getDuration(file.url)"
                        :tags="['Music']"
                      />
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
    </div>
    
    <!-- Add error notification -->
    <div v-if="showFileTypeError" class="file-type-error">
      <div class="error-content">
        <span class="error-icon">⚠️</span>
        <span class="error-message">{{ fileTypeErrorMessage }}</span>
        <button class="error-close" @click="showFileTypeError = false">×</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import AudioFileItem from './components/AudioFileItem.vue'

// 当前页面状态
const currentPage = ref('start') // 'start', 'workType', 'license', 'assetDetails', 或 'creators'

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

// 当前选择的作品类型
const selectedWorkType = ref('')

// 资产详情页面数据
const assetName = ref('')
const assetDescription = ref('')
const activeUploadMethod = ref('file')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const selectedAssetType = ref('')
const uploadedFiles = ref<Array<{name: string, type: string, url: string, file: File}>>([])

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
  selectedLicense.value = license
}

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
  const fileUrl = URL.createObjectURL(file)
  uploadedFiles.value.push({
    name: file.name,
    type: file.type,
    url: fileUrl,
    file: file
  })
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

// 提交资产
const submitAsset = () => {
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicense.value)
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

// 获取音频时长
const getDuration = (url: string) => {
  const audio = new Audio(url);
  return Math.floor(audio.duration);
}

// 获取随机高度
const getRandomHeight = () => {
  return Math.floor(Math.random() * 100) + 10;
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
  background: rgba(60, 60, 60, 0.15); /* Changed to match gray theme */
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
  overflow: hidden;
  background-color: #2c5464;
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
  border-bottom: 1px solid rgba(100, 100, 100, 0.35);
  margin-bottom: 20px;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
}

.tab {
  padding: 12px 20px;
  font-size: 15px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  position: relative;
  transition: all 0.3s;
}

.tab:hover {
  color: white;
  background-color: rgba(80, 80, 80, 0.3);
}

.tab.active {
  color: white;
}

.tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: white;
}

.license-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  flex: 1;
  overflow-y: auto;
  padding-right: 10px;
  padding-bottom: 10px;
  position: relative;
  z-index: 1;
  min-height: 0;
  margin-bottom: 20px;
}

.license-card {
  flex: 1;
  min-width: 220px;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  padding: 0;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(100, 100, 100, 0.35);
  cursor: pointer;
}

.license-card:hover {
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75));
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(150, 150, 150, 0.5);
}

.license-card.selected {
  border: 1px solid rgba(150, 150, 150, 0.7);
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8));
  transform: translateY(-8px);
  box-shadow: 0 30px 35px rgba(0, 0, 0, 0.4);
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
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 24px;
  background-color: rgba(0, 0, 0, 0.2);
}

.license-icons {
  display: flex;
  gap: 18px;
}

.icon {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.6;
}

.check-indicator {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(52, 199, 89, 0.3);
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
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: auto;
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
  }
  
  .license-container, .work-type-container {
    padding: 30px;
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
  align-items: center;
  justify-content: center;
  padding: 10px;
}

.audio-icon {
  font-size: 30px;
  margin-bottom: 10px;
  background-color: rgba(100, 100, 255, 0.2);
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-media-audio {
  width: 100%;
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
  background-color: rgba(60, 60, 65, 0.5); /* Changed to match the predefined license cards */
  border-radius: 14px;
  margin-bottom: 0;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  position: relative;
}

.license-filter-item.expanded {
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the hover state of predefined license cards */
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
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
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the expanded card background */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background-color: rgba(24, 24, 28, 0.8); /* Changed to match original style */
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: center;
}

.option-btn:hover {
  background-color: rgba(35, 35, 40, 0.9); /* Changed to match original style */
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.option-btn.selected {
  border-color: rgba(255, 255, 255, 0.4);
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.yes-btn.selected {
  background-color: rgba(52, 199, 89, 0.25); /* Changed to match original style */
  color: rgb(146, 237, 172);
}

.no-btn.selected {
  background-color: rgba(255, 59, 48, 0.25); /* Changed to match original style */
  color: rgb(255, 145, 140);
}

.expiration-btn.selected {
  background-color: rgba(175, 82, 222, 0.3); /* Changed to match original style */
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
  background-color: rgba(255, 59, 48, 0.8);
}

.license-filter-item:nth-child(2):before {
  background-color: rgba(0, 122, 255, 0.8);
}

.license-filter-item:nth-child(3):before {
  background-color: rgba(52, 199, 89, 0.8);
}

.license-filter-item:nth-child(4):before {
  background-color: rgba(175, 82, 222, 0.8);
}

.license-filter-item:nth-child(5):before {
  background-color: rgba(255, 149, 0, 0.8);
}

.license-filter-item:nth-child(6):before {
  background-color: rgba(88, 86, 214, 0.8);
}

.license-filter-item:hover:not(.expanded) {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match license card hover state */
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
  opacity: 0; /* Hide by default */
  visibility: hidden; /* Hide by default but keep space */
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
  background-color: #1b5e20;
  color: white;
}

.filter-status.required {
  background-color: #0d47a1;
  color: white;
}

.filter-status.never {
  background-color: #4a148c;
  color: white;
}

.filter-status.off {
  background-color: #8b0000;
  color: white;
}

.clear-btn-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.clear-all-btn {
  background-color: rgba(40, 40, 45, 0.6); /* Changed to match original style */
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
}

.fee-input-container {
  width: 100%;
  margin-bottom: 10px;
}

.fee-label {
  font-size: 14px;
  color: #bbb;
  margin-bottom: 6px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.6); /* Changed to match original style */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background: #3a3a3a; /* Changed from gradient to solid gray */
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
  background-color: rgba(80, 80, 80, 0.25); /* Slightly lighter gray with transparency */
  border-radius: 20px;
  padding: 50px;
  backdrop-filter: blur(5px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.menu-title {
  display: none; /* Hide this since we're now using data-text attribute */
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
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
}

.license-tag.blue {
  background: rgba(0, 122, 255, 0.3);
  color: #7abbff;
}

.license-tag.purple {
  background: rgba(175, 82, 222, 0.3);
  color: #d699ff;
}

.license-tag.green {
  background: rgba(52, 199, 89, 0.3);
  color: #8dffbf;
}

.license-tag.red {
  background: rgba(255, 59, 48, 0.3);
  color: #ff8c85;
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
          <!-- 开放使用许可 -->
          <div 
            class="license-card" 
            :class="{ selected: selectedLicense === 'open' }"
            @click="selectLicense('open')"
          >
            <div class="license-header">
              <span class="license-tag blue"><i class="license-icon">🔓</i> 限制最少</span>
            </div>
            <h2>开放使用</h2>
            <div class="license-content">
              <p class="license-description-zh">免费分发和混音，无限制、无收入要求、无归属要求</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'open'">✓</div>
            </div>
          </div>

          <!-- 非商业Remix -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'non-commercial' }"
            @click="selectLicense('non-commercial')"
          >
            <div class="license-header">
              <span class="license-tag purple"><i class="license-icon">🏆</i> 为您的作品获得认可</span>
            </div>
            <h2>非商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">任何人都可使用您的作品创建非商业项目</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'non-commercial'">✓</div>
            </div>
          </div>

          <!-- 商业使用 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial' }"
            @click="selectLicense('commercial')"
          >
            <div class="license-header">
              <span class="license-tag green"><i class="license-icon">💲</i> 为您的作品获得报酬</span>
            </div>
            <h2>商业使用</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人按照您设定的经济条款使用您的作品</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="限制混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial'">✓</div>
            </div>
          </div>

          <!-- 商业混音 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial-remix' }"
            @click="selectLicense('commercial-remix')"
          >
            <div class="license-header">
              <span class="license-tag red"><i class="license-icon">💰</i> 获得报酬与认可</span>
            </div>
            <h2>商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人混音您的作品，同时您获得认可和收益</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial-remix'">✓</div>
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
          <button class="next-btn" @click="submitAsset" :disabled="!selectedLicense && activeTabIndex === 0">
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
              <div class="preview-files-grid">
                <div 
                  v-for="(file, index) in uploadedFiles" 
                  :key="index" 
                  class="preview-file-item"
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
                      <AudioFileItem 
                        :name="file.name"
                        artist="Unknown Artist"
                        :duration="getDuration(file.url)"
                        :tags="['Music']"
                      />
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
    </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import AudioFileItem from './components/AudioFileItem.vue'

// 当前页面状态
const currentPage = ref('start') // 'start', 'workType', 'license', 'assetDetails', 或 'creators'

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

// 当前选择的作品类型
const selectedWorkType = ref('')

// 资产详情页面数据
const assetName = ref('')
const assetDescription = ref('')
const activeUploadMethod = ref('file')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const selectedAssetType = ref('')
const uploadedFiles = ref<Array<{name: string, type: string, url: string, file: File}>>([])

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
  selectedLicense.value = license
}

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
  const fileUrl = URL.createObjectURL(file)
  uploadedFiles.value.push({
    name: file.name,
    type: file.type,
    url: fileUrl,
    file: file
  })
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

// 提交资产
const submitAsset = () => {
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicense.value)
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

// 获取音频时长
const getDuration = (url: string) => {
  const audio = new Audio(url);
  return Math.floor(audio.duration);
}

// 获取随机高度
const getRandomHeight = () => {
  return Math.floor(Math.random() * 100) + 10;
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
  background: rgba(60, 60, 60, 0.15); /* Changed to match gray theme */
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
  overflow: hidden;
  background-color: #2c5464;
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
  border-bottom: 1px solid rgba(100, 100, 100, 0.35);
  margin-bottom: 20px;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
}

.tab {
  padding: 12px 20px;
  font-size: 15px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  position: relative;
  transition: all 0.3s;
}

.tab:hover {
  color: white;
  background-color: rgba(80, 80, 80, 0.3);
}

.tab.active {
  color: white;
}

.tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: white;
}

.license-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  flex: 1;
  overflow-y: auto;
  padding-right: 10px;
  padding-bottom: 10px;
  position: relative;
  z-index: 1;
  min-height: 0;
  margin-bottom: 20px;
}

.license-card {
  flex: 1;
  min-width: 220px;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  padding: 0;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(100, 100, 100, 0.35);
  cursor: pointer;
}

.license-card:hover {
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75));
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(150, 150, 150, 0.5);
}

.license-card.selected {
  border: 1px solid rgba(150, 150, 150, 0.7);
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8));
  transform: translateY(-8px);
  box-shadow: 0 30px 35px rgba(0, 0, 0, 0.4);
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
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 24px;
  background-color: rgba(0, 0, 0, 0.2);
}

.license-icons {
  display: flex;
  gap: 18px;
}

.icon {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.6;
}

.check-indicator {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(52, 199, 89, 0.3);
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
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: auto;
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
  }
  
  .license-container, .work-type-container {
    padding: 30px;
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
  align-items: center;
  justify-content: center;
  padding: 10px;
}

.audio-icon {
  font-size: 30px;
  margin-bottom: 10px;
  background-color: rgba(100, 100, 255, 0.2);
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-media-audio {
  width: 100%;
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
  background-color: rgba(60, 60, 65, 0.5); /* Changed to match the predefined license cards */
  border-radius: 14px;
  margin-bottom: 0;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  position: relative;
}

.license-filter-item.expanded {
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the hover state of predefined license cards */
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
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
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the expanded card background */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background-color: rgba(24, 24, 28, 0.8); /* Changed to match original style */
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: center;
}

.option-btn:hover {
  background-color: rgba(35, 35, 40, 0.9); /* Changed to match original style */
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.option-btn.selected {
  border-color: rgba(255, 255, 255, 0.4);
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.yes-btn.selected {
  background-color: rgba(52, 199, 89, 0.25); /* Changed to match original style */
  color: rgb(146, 237, 172);
}

.no-btn.selected {
  background-color: rgba(255, 59, 48, 0.25); /* Changed to match original style */
  color: rgb(255, 145, 140);
}

.expiration-btn.selected {
  background-color: rgba(175, 82, 222, 0.3); /* Changed to match original style */
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
  background-color: rgba(255, 59, 48, 0.8);
}

.license-filter-item:nth-child(2):before {
  background-color: rgba(0, 122, 255, 0.8);
}

.license-filter-item:nth-child(3):before {
  background-color: rgba(52, 199, 89, 0.8);
}

.license-filter-item:nth-child(4):before {
  background-color: rgba(175, 82, 222, 0.8);
}

.license-filter-item:nth-child(5):before {
  background-color: rgba(255, 149, 0, 0.8);
}

.license-filter-item:nth-child(6):before {
  background-color: rgba(88, 86, 214, 0.8);
}

.license-filter-item:hover:not(.expanded) {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match license card hover state */
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
  opacity: 0; /* Hide by default */
  visibility: hidden; /* Hide by default but keep space */
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
  background-color: #1b5e20;
  color: white;
}

.filter-status.required {
  background-color: #0d47a1;
  color: white;
}

.filter-status.never {
  background-color: #4a148c;
  color: white;
}

.filter-status.off {
  background-color: #8b0000;
  color: white;
}

.clear-btn-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.clear-all-btn {
  background-color: rgba(40, 40, 45, 0.6); /* Changed to match original style */
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
}

.fee-input-container {
  width: 100%;
  margin-bottom: 10px;
}

.fee-label {
  font-size: 14px;
  color: #bbb;
  margin-bottom: 6px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.6); /* Changed to match original style */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background: #3a3a3a; /* Changed from gradient to solid gray */
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
  background-color: rgba(80, 80, 80, 0.25); /* Slightly lighter gray with transparency */
  border-radius: 20px;
  padding: 50px;
  backdrop-filter: blur(5px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.menu-title {
  display: none; /* Hide this since we're now using data-text attribute */
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
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
}

.license-tag.blue {
  background: rgba(0, 122, 255, 0.3);
  color: #7abbff;
}

.license-tag.purple {
  background: rgba(175, 82, 222, 0.3);
  color: #d699ff;
}

.license-tag.green {
  background: rgba(52, 199, 89, 0.3);
  color: #8dffbf;
}

.license-tag.red {
  background: rgba(255, 59, 48, 0.3);
  color: #ff8c85;
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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

.asset-type-card.disabled .monitor-svg {
  opacity: 0.4;
}

.asset-type-card.disabled .asset-type-name {
  opacity: 0.5;
}

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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
          <!-- 开放使用许可 -->
          <div 
            class="license-card" 
            :class="{ selected: selectedLicense === 'open' }"
            @click="selectLicense('open')"
          >
            <div class="license-header">
              <span class="license-tag blue"><i class="license-icon">🔓</i> 限制最少</span>
            </div>
            <h2>开放使用</h2>
            <div class="license-content">
              <p class="license-description-zh">免费分发和混音，无限制、无收入要求、无归属要求</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'open'">✓</div>
            </div>
          </div>

          <!-- 非商业Remix -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'non-commercial' }"
            @click="selectLicense('non-commercial')"
          >
            <div class="license-header">
              <span class="license-tag purple"><i class="license-icon">🏆</i> 为您的作品获得认可</span>
            </div>
            <h2>非商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">任何人都可使用您的作品创建非商业项目</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'non-commercial'">✓</div>
            </div>
          </div>

          <!-- 商业使用 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial' }"
            @click="selectLicense('commercial')"
          >
            <div class="license-header">
              <span class="license-tag green"><i class="license-icon">💲</i> 为您的作品获得报酬</span>
            </div>
            <h2>商业使用</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人按照您设定的经济条款使用您的作品</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="限制混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial'">✓</div>
            </div>
          </div>

          <!-- 商业混音 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial-remix' }"
            @click="selectLicense('commercial-remix')"
          >
            <div class="license-header">
              <span class="license-tag red"><i class="license-icon">💰</i> 获得报酬与认可</span>
            </div>
            <h2>商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人混音您的作品，同时您获得认可和收益</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial-remix'">✓</div>
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
          <button class="next-btn" @click="submitAsset" :disabled="!selectedLicense && activeTabIndex === 0">
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
              <div class="preview-files-grid">
                <div 
                  v-for="(file, index) in uploadedFiles" 
                  :key="index" 
                  class="preview-file-item"
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
                      <AudioFileItem 
                        :name="file.name"
                        artist="Unknown Artist"
                        :duration="getDuration(file.url)"
                        :tags="['Music']"
                      />
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
    </div>
    
    <!-- Add error notification -->
    <div v-if="showFileTypeError" class="file-type-error">
      <div class="error-content">
        <span class="error-icon">⚠️</span>
        <span class="error-message">{{ fileTypeErrorMessage }}</span>
        <button class="error-close" @click="showFileTypeError = false">×</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import AudioFileItem from './components/AudioFileItem.vue'

// 当前页面状态
const currentPage = ref('start') // 'start', 'workType', 'license', 'assetDetails', 或 'creators'

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

// 当前选择的作品类型
const selectedWorkType = ref('')

// 资产详情页面数据
const assetName = ref('')
const assetDescription = ref('')
const activeUploadMethod = ref('file')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const selectedAssetType = ref('')
const uploadedFiles = ref<Array<{name: string, type: string, url: string, file: File}>>([])

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
  selectedLicense.value = license
}

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
  const fileUrl = URL.createObjectURL(file)
  uploadedFiles.value.push({
    name: file.name,
    type: file.type,
    url: fileUrl,
    file: file
  })
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

// 提交资产
const submitAsset = () => {
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicense.value)
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

// 获取音频时长
const getDuration = (url: string) => {
  const audio = new Audio(url);
  return Math.floor(audio.duration);
}

// 获取随机高度
const getRandomHeight = () => {
  return Math.floor(Math.random() * 100) + 10;
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
  background: rgba(60, 60, 60, 0.15); /* Changed to match gray theme */
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
  overflow: hidden;
  background-color: #2c5464;
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
  border-bottom: 1px solid rgba(100, 100, 100, 0.35);
  margin-bottom: 20px;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
}

.tab {
  padding: 12px 20px;
  font-size: 15px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  position: relative;
  transition: all 0.3s;
}

.tab:hover {
  color: white;
  background-color: rgba(80, 80, 80, 0.3);
}

.tab.active {
  color: white;
}

.tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: white;
}

.license-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  flex: 1;
  overflow-y: auto;
  padding-right: 10px;
  padding-bottom: 10px;
  position: relative;
  z-index: 1;
  min-height: 0;
  margin-bottom: 20px;
}

.license-card {
  flex: 1;
  min-width: 220px;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  padding: 0;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(100, 100, 100, 0.35);
  cursor: pointer;
}

.license-card:hover {
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75));
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(150, 150, 150, 0.5);
}

.license-card.selected {
  border: 1px solid rgba(150, 150, 150, 0.7);
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8));
  transform: translateY(-8px);
  box-shadow: 0 30px 35px rgba(0, 0, 0, 0.4);
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
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 24px;
  background-color: rgba(0, 0, 0, 0.2);
}

.license-icons {
  display: flex;
  gap: 18px;
}

.icon {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.6;
}

.check-indicator {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(52, 199, 89, 0.3);
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
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: auto;
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
  }
  
  .license-container, .work-type-container {
    padding: 30px;
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
  align-items: center;
  justify-content: center;
  padding: 10px;
}

.audio-icon {
  font-size: 30px;
  margin-bottom: 10px;
  background-color: rgba(100, 100, 255, 0.2);
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-media-audio {
  width: 100%;
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
  background-color: rgba(60, 60, 65, 0.5); /* Changed to match the predefined license cards */
  border-radius: 14px;
  margin-bottom: 0;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  position: relative;
}

.license-filter-item.expanded {
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the hover state of predefined license cards */
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
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
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the expanded card background */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background-color: rgba(24, 24, 28, 0.8); /* Changed to match original style */
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: center;
}

.option-btn:hover {
  background-color: rgba(35, 35, 40, 0.9); /* Changed to match original style */
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.option-btn.selected {
  border-color: rgba(255, 255, 255, 0.4);
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.yes-btn.selected {
  background-color: rgba(52, 199, 89, 0.25); /* Changed to match original style */
  color: rgb(146, 237, 172);
}

.no-btn.selected {
  background-color: rgba(255, 59, 48, 0.25); /* Changed to match original style */
  color: rgb(255, 145, 140);
}

.expiration-btn.selected {
  background-color: rgba(175, 82, 222, 0.3); /* Changed to match original style */
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
  background-color: rgba(255, 59, 48, 0.8);
}

.license-filter-item:nth-child(2):before {
  background-color: rgba(0, 122, 255, 0.8);
}

.license-filter-item:nth-child(3):before {
  background-color: rgba(52, 199, 89, 0.8);
}

.license-filter-item:nth-child(4):before {
  background-color: rgba(175, 82, 222, 0.8);
}

.license-filter-item:nth-child(5):before {
  background-color: rgba(255, 149, 0, 0.8);
}

.license-filter-item:nth-child(6):before {
  background-color: rgba(88, 86, 214, 0.8);
}

.license-filter-item:hover:not(.expanded) {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match license card hover state */
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
  opacity: 0; /* Hide by default */
  visibility: hidden; /* Hide by default but keep space */
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
  background-color: #1b5e20;
  color: white;
}

.filter-status.required {
  background-color: #0d47a1;
  color: white;
}

.filter-status.never {
  background-color: #4a148c;
  color: white;
}

.filter-status.off {
  background-color: #8b0000;
  color: white;
}

.clear-btn-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.clear-all-btn {
  background-color: rgba(40, 40, 45, 0.6); /* Changed to match original style */
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
}

.fee-input-container {
  width: 100%;
  margin-bottom: 10px;
}

.fee-label {
  font-size: 14px;
  color: #bbb;
  margin-bottom: 6px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.6); /* Changed to match original style */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background: #3a3a3a; /* Changed from gradient to solid gray */
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
  background-color: rgba(80, 80, 80, 0.25); /* Slightly lighter gray with transparency */
  border-radius: 20px;
  padding: 50px;
  backdrop-filter: blur(5px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.menu-title {
  display: none; /* Hide this since we're now using data-text attribute */
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
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
}

.license-tag.blue {
  background: rgba(0, 122, 255, 0.3);
  color: #7abbff;
}

.license-tag.purple {
  background: rgba(175, 82, 222, 0.3);
  color: #d699ff;
}

.license-tag.green {
  background: rgba(52, 199, 89, 0.3);
  color: #8dffbf;
}

.license-tag.red {
  background: rgba(255, 59, 48, 0.3);
  color: #ff8c85;
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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

.asset-type-card.disabled .monitor-svg {
  opacity: 0.4;
}

.asset-type-card.disabled .asset-type-name {
  opacity: 0.5;
}

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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
          <!-- 开放使用许可 -->
          <div 
            class="license-card" 
            :class="{ selected: selectedLicense === 'open' }"
            @click="selectLicense('open')"
          >
            <div class="license-header">
              <span class="license-tag blue"><i class="license-icon">🔓</i> 限制最少</span>
            </div>
            <h2>开放使用</h2>
            <div class="license-content">
              <p class="license-description-zh">免费分发和混音，无限制、无收入要求、无归属要求</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'open'">✓</div>
            </div>
          </div>

          <!-- 非商业Remix -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'non-commercial' }"
            @click="selectLicense('non-commercial')"
          >
            <div class="license-header">
              <span class="license-tag purple"><i class="license-icon">🏆</i> 为您的作品获得认可</span>
            </div>
            <h2>非商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">任何人都可使用您的作品创建非商业项目</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'non-commercial'">✓</div>
            </div>
          </div>

          <!-- 商业使用 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial' }"
            @click="selectLicense('commercial')"
          >
            <div class="license-header">
              <span class="license-tag green"><i class="license-icon">💲</i> 为您的作品获得报酬</span>
            </div>
            <h2>商业使用</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人按照您设定的经济条款使用您的作品</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="限制混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial'">✓</div>
            </div>
          </div>

          <!-- 商业混音 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial-remix' }"
            @click="selectLicense('commercial-remix')"
          >
            <div class="license-header">
              <span class="license-tag red"><i class="license-icon">💰</i> 获得报酬与认可</span>
            </div>
            <h2>商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人混音您的作品，同时您获得认可和收益</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial-remix'">✓</div>
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
          <button class="next-btn" @click="submitAsset" :disabled="!selectedLicense && activeTabIndex === 0">
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
              <div class="preview-files-grid">
                <div 
                  v-for="(file, index) in uploadedFiles" 
                  :key="index" 
                  class="preview-file-item"
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
                    <div v-else-if="file.type.startsWith('audio/')" class="preview-audio-player">
                      <AudioFileItem 
                        :name="file.name"
                        artist="Unknown Artist"
                        :duration="getDuration(file.url)"
                        :tags="['Music']"
                      />
                      <audio :src="file.url" ref="audioElement" style="display: none;"></audio>
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
    </div>
    
    <!-- Add error notification -->
    <div v-if="showFileTypeError" class="file-type-error">
      <div class="error-content">
        <span class="error-icon">⚠️</span>
        <span class="error-message">{{ fileTypeErrorMessage }}</span>
        <button class="error-close" @click="showFileTypeError = false">×</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import AudioFileItem from './components/AudioFileItem.vue'

// 当前页面状态
const currentPage = ref('start') // 'start', 'workType', 'license', 'assetDetails', 或 'creators'

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

// 当前选择的作品类型
const selectedWorkType = ref('')

// 资产详情页面数据
const assetName = ref('')
const assetDescription = ref('')
const activeUploadMethod = ref('file')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const selectedAssetType = ref('')
const uploadedFiles = ref<Array<{name: string, type: string, url: string, file: File}>>([])

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
  selectedLicense.value = license
}

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
  const fileUrl = URL.createObjectURL(file)
  uploadedFiles.value.push({
    name: file.name,
    type: file.type,
    url: fileUrl,
    file: file
  })
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

// 提交资产
const submitAsset = () => {
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicense.value)
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

// 获取音频时长
const getDuration = (url: string) => {
  const audio = new Audio(url);
  return Math.floor(audio.duration);
}

// 获取随机高度
const getRandomHeight = () => {
  return Math.floor(Math.random() * 100) + 10;
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
  background: rgba(60, 60, 60, 0.15); /* Changed to match gray theme */
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
  overflow: hidden;
  background-color: #2c5464;
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
  border-bottom: 1px solid rgba(100, 100, 100, 0.35);
  margin-bottom: 20px;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
}

.tab {
  padding: 12px 20px;
  font-size: 15px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  position: relative;
  transition: all 0.3s;
}

.tab:hover {
  color: white;
  background-color: rgba(80, 80, 80, 0.3);
}

.tab.active {
  color: white;
}

.tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: white;
}

.license-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  flex: 1;
  overflow-y: auto;
  padding-right: 10px;
  padding-bottom: 10px;
  position: relative;
  z-index: 1;
  min-height: 0;
  margin-bottom: 20px;
}

.license-card {
  flex: 1;
  min-width: 220px;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  padding: 0;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(100, 100, 100, 0.35);
  cursor: pointer;
}

.license-card:hover {
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75));
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(150, 150, 150, 0.5);
}

.license-card.selected {
  border: 1px solid rgba(150, 150, 150, 0.7);
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8));
  transform: translateY(-8px);
  box-shadow: 0 30px 35px rgba(0, 0, 0, 0.4);
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
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 24px;
  background-color: rgba(0, 0, 0, 0.2);
}

.license-icons {
  display: flex;
  gap: 18px;
}

.icon {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.6;
}

.check-indicator {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(52, 199, 89, 0.3);
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
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: auto;
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
  }
  
  .license-container, .work-type-container {
    padding: 30px;
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
  align-items: center;
  justify-content: center;
  padding: 10px;
}

.audio-icon {
  font-size: 30px;
  margin-bottom: 10px;
  background-color: rgba(100, 100, 255, 0.2);
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-media-audio {
  width: 100%;
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
  background-color: rgba(60, 60, 65, 0.5); /* Changed to match the predefined license cards */
  border-radius: 14px;
  margin-bottom: 0;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  position: relative;
}

.license-filter-item.expanded {
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the hover state of predefined license cards */
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
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
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the expanded card background */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background-color: rgba(24, 24, 28, 0.8); /* Changed to match original style */
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: center;
}

.option-btn:hover {
  background-color: rgba(35, 35, 40, 0.9); /* Changed to match original style */
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.option-btn.selected {
  border-color: rgba(255, 255, 255, 0.4);
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.yes-btn.selected {
  background-color: rgba(52, 199, 89, 0.25); /* Changed to match original style */
  color: rgb(146, 237, 172);
}

.no-btn.selected {
  background-color: rgba(255, 59, 48, 0.25); /* Changed to match original style */
  color: rgb(255, 145, 140);
}

.expiration-btn.selected {
  background-color: rgba(175, 82, 222, 0.3); /* Changed to match original style */
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
  background-color: rgba(255, 59, 48, 0.8);
}

.license-filter-item:nth-child(2):before {
  background-color: rgba(0, 122, 255, 0.8);
}

.license-filter-item:nth-child(3):before {
  background-color: rgba(52, 199, 89, 0.8);
}

.license-filter-item:nth-child(4):before {
  background-color: rgba(175, 82, 222, 0.8);
}

.license-filter-item:nth-child(5):before {
  background-color: rgba(255, 149, 0, 0.8);
}

.license-filter-item:nth-child(6):before {
  background-color: rgba(88, 86, 214, 0.8);
}

.license-filter-item:hover:not(.expanded) {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match license card hover state */
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
  opacity: 0; /* Hide by default */
  visibility: hidden; /* Hide by default but keep space */
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
  background-color: #1b5e20;
  color: white;
}

.filter-status.required {
  background-color: #0d47a1;
  color: white;
}

.filter-status.never {
  background-color: #4a148c;
  color: white;
}

.filter-status.off {
  background-color: #8b0000;
  color: white;
}

.clear-btn-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.clear-all-btn {
  background-color: rgba(40, 40, 45, 0.6); /* Changed to match original style */
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
}

.fee-input-container {
  width: 100%;
  margin-bottom: 10px;
}

.fee-label {
  font-size: 14px;
  color: #bbb;
  margin-bottom: 6px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.6); /* Changed to match original style */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background: #3a3a3a; /* Changed from gradient to solid gray */
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
  background-color: rgba(80, 80, 80, 0.25); /* Slightly lighter gray with transparency */
  border-radius: 20px;
  padding: 50px;
  backdrop-filter: blur(5px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.menu-title {
  display: none; /* Hide this since we're now using data-text attribute */
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
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
}

.license-tag.blue {
  background: rgba(0, 122, 255, 0.3);
  color: #7abbff;
}

.license-tag.purple {
  background: rgba(175, 82, 222, 0.3);
  color: #d699ff;
}

.license-tag.green {
  background: rgba(52, 199, 89, 0.3);
  color: #8dffbf;
}

.license-tag.red {
  background: rgba(255, 59, 48, 0.3);
  color: #ff8c85;
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
}

.info-icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

.info-icon svg {
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
          <!-- 开放使用许可 -->
          <div 
            class="license-card" 
            :class="{ selected: selectedLicense === 'open' }"
            @click="selectLicense('open')"
          >
            <div class="license-header">
              <span class="license-tag blue"><i class="license-icon">🔓</i> 限制最少</span>
            </div>
            <h2>开放使用</h2>
            <div class="license-content">
              <p class="license-description-zh">免费分发和混音，无限制、无收入要求、无归属要求</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'open'">✓</div>
            </div>
          </div>

          <!-- 非商业Remix -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'non-commercial' }"
            @click="selectLicense('non-commercial')"
          >
            <div class="license-header">
              <span class="license-tag purple"><i class="license-icon">🏆</i> 为您的作品获得认可</span>
            </div>
            <h2>非商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">任何人都可使用您的作品创建非商业项目</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="无需付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'non-commercial'">✓</div>
            </div>
          </div>

          <!-- 商业使用 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial' }"
            @click="selectLicense('commercial')"
          >
            <div class="license-header">
              <span class="license-tag green"><i class="license-icon">💲</i> 为您的作品获得报酬</span>
            </div>
            <h2>商业使用</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人按照您设定的经济条款使用您的作品</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="限制混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial'">✓</div>
            </div>
          </div>

          <!-- 商业混音 -->
          <div 
            class="license-card"
            :class="{ selected: selectedLicense === 'commercial-remix' }"
            @click="selectLicense('commercial-remix')"
          >
            <div class="license-header">
              <span class="license-tag red"><i class="license-icon">💰</i> 获得报酬与认可</span>
            </div>
            <h2>商业混音</h2>
            <div class="license-content">
              <p class="license-description-zh">允许他人混音您的作品，同时您获得认可和收益</p>
            </div>
            <div class="license-footer">
              <div class="license-icons">
                <span class="icon" title="提供文档">📄</span>
                <span class="icon" title="需要付费">$</span>
                <span class="icon" title="允许混音">↩️</span>
                <span class="icon" title="条款与条件">📋</span>
              </div>
              <div class="check-indicator" v-if="selectedLicense === 'commercial-remix'">✓</div>
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
          <button class="next-btn" @click="submitAsset" :disabled="!selectedLicense && activeTabIndex === 0">
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
              <div class="preview-files-grid">
                <div 
                  v-for="(file, index) in uploadedFiles" 
                  :key="index" 
                  class="preview-file-item"
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
                      <div class="audio-placeholder"></div>
                      <audio :src="file.url" controls class="preview-media-audio"></audio>
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
    </div>
    
    <!-- Add error notification -->
    <div v-if="showFileTypeError" class="file-type-error">
      <div class="error-content">
        <span class="error-icon">⚠️</span>
        <span class="error-message">{{ fileTypeErrorMessage }}</span>
        <button class="error-close" @click="showFileTypeError = false">×</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

// 当前页面状态
const currentPage = ref('start') // 'start', 'workType', 'license', 'assetDetails', 或 'creators'

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

// 当前选择的作品类型
const selectedWorkType = ref('')

// 资产详情页面数据
const assetName = ref('')
const assetDescription = ref('')
const activeUploadMethod = ref('file')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const selectedAssetType = ref('')
const uploadedFiles = ref<Array<{name: string, type: string, url: string, file: File}>>([])

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
  selectedLicense.value = license
}

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
  const fileUrl = URL.createObjectURL(file)
  uploadedFiles.value.push({
    name: file.name,
    type: file.type,
    url: fileUrl,
    file: file
  })
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

// 提交资产
const submitAsset = () => {
  console.log('资产提交完成')
  console.log('资产名称:', assetName.value)
  console.log('资产描述:', assetDescription.value)
  console.log('上传文件:', uploadedFiles.value)
  console.log('共同创作者:', coCreators.value)
  console.log('许可证类型:', selectedLicense.value)
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
  background: rgba(60, 60, 60, 0.15); /* Changed to match gray theme */
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
  overflow: hidden;
  background-color: #2c5464;
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
  border-bottom: 1px solid rgba(100, 100, 100, 0.35);
  margin-bottom: 20px;
  flex-shrink: 0;
  position: relative;
  z-index: 2;
}

.tab {
  padding: 12px 20px;
  font-size: 15px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  position: relative;
  transition: all 0.3s;
}

.tab:hover {
  color: white;
  background-color: rgba(80, 80, 80, 0.3);
}

.tab.active {
  color: white;
}

.tab.active:after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: white;
}

.license-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  flex: 1;
  overflow-y: auto;
  padding-right: 10px;
  padding-bottom: 10px;
  position: relative;
  z-index: 1;
  min-height: 0;
  margin-bottom: 20px;
}

.license-card {
  flex: 1;
  min-width: 220px;
  background: linear-gradient(rgba(60, 60, 60, 0.8), rgba(40, 40, 40, 0.7));
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  padding: 0;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(100, 100, 100, 0.35);
  cursor: pointer;
}

.license-card:hover {
  background: linear-gradient(rgba(70, 70, 70, 0.85), rgba(50, 50, 50, 0.75));
  transform: translateY(-8px);
  box-shadow: 0 30px 30px rgba(0, 0, 0, 0.4);
  border-color: rgba(150, 150, 150, 0.5);
}

.license-card.selected {
  border: 1px solid rgba(150, 150, 150, 0.7);
  background: linear-gradient(rgba(80, 80, 80, 0.9), rgba(60, 60, 60, 0.8));
  transform: translateY(-8px);
  box-shadow: 0 30px 35px rgba(0, 0, 0, 0.4);
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
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px 24px;
  background-color: rgba(0, 0, 0, 0.2);
}

.license-icons {
  display: flex;
  gap: 18px;
}

.icon {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.6;
}

.check-indicator {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(52, 199, 89, 0.3);
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
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: auto;
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
  }
  
  .license-container, .work-type-container {
    padding: 30px;
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
  align-items: center;
  justify-content: center;
  padding: 10px;
}

.audio-icon {
  font-size: 30px;
  margin-bottom: 10px;
  background-color: rgba(100, 100, 255, 0.2);
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-media-audio {
  width: 100%;
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
  background-color: rgba(60, 60, 65, 0.5); /* Changed to match the predefined license cards */
  border-radius: 14px;
  margin-bottom: 0;
  transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  position: relative;
}

.license-filter-item.expanded {
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the hover state of predefined license cards */
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
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
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match the expanded card background */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background-color: rgba(24, 24, 28, 0.8); /* Changed to match original style */
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: center;
}

.option-btn:hover {
  background-color: rgba(35, 35, 40, 0.9); /* Changed to match original style */
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.option-btn.selected {
  border-color: rgba(255, 255, 255, 0.4);
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.yes-btn.selected {
  background-color: rgba(52, 199, 89, 0.25); /* Changed to match original style */
  color: rgb(146, 237, 172);
}

.no-btn.selected {
  background-color: rgba(255, 59, 48, 0.25); /* Changed to match original style */
  color: rgb(255, 145, 140);
}

.expiration-btn.selected {
  background-color: rgba(175, 82, 222, 0.3); /* Changed to match original style */
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
  background-color: rgba(255, 59, 48, 0.8);
}

.license-filter-item:nth-child(2):before {
  background-color: rgba(0, 122, 255, 0.8);
}

.license-filter-item:nth-child(3):before {
  background-color: rgba(52, 199, 89, 0.8);
}

.license-filter-item:nth-child(4):before {
  background-color: rgba(175, 82, 222, 0.8);
}

.license-filter-item:nth-child(5):before {
  background-color: rgba(255, 149, 0, 0.8);
}

.license-filter-item:nth-child(6):before {
  background-color: rgba(88, 86, 214, 0.8);
}

.license-filter-item:hover:not(.expanded) {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
  background-color: rgba(70, 70, 75, 0.6); /* Changed to match license card hover state */
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
  opacity: 0; /* Hide by default */
  visibility: hidden; /* Hide by default but keep space */
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
  background-color: #1b5e20;
  color: white;
}

.filter-status.required {
  background-color: #0d47a1;
  color: white;
}

.filter-status.never {
  background-color: #4a148c;
  color: white;
}

.filter-status.off {
  background-color: #8b0000;
  color: white;
}

.clear-btn-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.clear-all-btn {
  background-color: rgba(40, 40, 45, 0.6); /* Changed to match original style */
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
}

.fee-input-container {
  width: 100%;
  margin-bottom: 10px;
}

.fee-label {
  font-size: 14px;
  color: #bbb;
  margin-bottom: 6px;
}

.fee-input-wrapper {
  display: flex;
  align-items: center;
  background-color: rgba(30, 30, 35, 0.6); /* Changed to match original style */
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
  background-color: rgba(0, 0, 0, 0.2); /* Changed to match original style */
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
  background: #3a3a3a; /* Changed from gradient to solid gray */
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
  background-color: rgba(80, 80, 80, 0.25); /* Slightly lighter gray with transparency */
  border-radius: 20px;
  padding: 50px;
  backdrop-filter: blur(5px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.menu-title {
  display: none; /* Hide this since we're now using data-text attribute */
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
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
}

.license-tag.blue {
  background: rgba(0, 122, 255, 0.3);
  color: #7abbff;
}

.license-tag.purple {
  background: rgba(175, 82, 222, 0.3);
  color: #d699ff;
}

.license-tag.green {
  background: rgba(52, 199, 89, 0.3);
  color: #8dffbf;
}

.license-tag.red {
  background: rgba(255, 59, 48, 0.3);
  color: #ff8c85;
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
  border-left: 3px solid rgba(100, 100, 100, 0.7);
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
</style>