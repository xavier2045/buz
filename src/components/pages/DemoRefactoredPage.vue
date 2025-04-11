<template>
  <div class="demo-page">
    <h1 class="demo-title">重构演示页面</h1>
    
    <div class="demo-section">
      <h2>1. StartPage 组件</h2>
      <div class="component-preview">
        <StartPage @navigate="handleNavigate" @show-unavailable="handleUnavailable" />
      </div>
    </div>
    
    <div class="demo-section">
      <h2>2. WorkTypePage 组件</h2>
      <div class="component-preview">
        <WorkTypePage @navigate-back="handleNavigateBack" @navigate-next="handleNavigateNext" />
      </div>
    </div>
    
    <div class="demo-section">
      <h2>3. 通用组件演示</h2>
      
      <h3>3.1 导航按钮</h3>
      <div class="common-component-preview">
        <NavigationButtons 
          :back-text="'上一步'" 
          :next-text="'下一步'"
          :next-disabled="demoNextDisabled"
          @back="handleNavBack"
          @next="handleNavNext"
        />
      </div>
      
      <h3>3.2 模态框组件</h3>
      <div class="common-component-preview">
        <button class="demo-button" @click="showModal = true">打开模态框</button>
        <Modal 
          :show="showModal"
          title="模态框演示"
          message="这是一个可复用的模态框组件"
          button-text="我知道了"
          @close="showModal = false"
        />
      </div>
      
      <h3>3.3 选项卡组件</h3>
      <div class="common-component-preview">
        <TabsContainer 
          :tabs="demoTabs"
          :active-index="activeTabIndex"
          @tab-change="activeTabIndex = $event"
        >
          <div v-if="activeTabIndex === 0" class="tab-content-demo">
            标签页 1 的内容
          </div>
          <div v-else-if="activeTabIndex === 1" class="tab-content-demo">
            标签页 2 的内容
          </div>
          <div v-else class="tab-content-demo">
            标签页 3 的内容
          </div>
        </TabsContainer>
      </div>
    </div>
    
    <div class="demo-section">
      <h2>4. 工具函数演示</h2>
      
      <h3>4.1 防抖与节流</h3>
      <div class="tools-preview">
        <div class="tool-demo">
          <p>快速点击按钮，只有停止点击后 1 秒才会触发（防抖）：<span class="counter">{{ debounceCounter }}</span></p>
          <button class="demo-button" @click="handleDebounceClick">点击（防抖）</button>
        </div>
        
        <div class="tool-demo">
          <p>快速点击按钮，每 1 秒最多只触发一次（节流）：<span class="counter">{{ throttleCounter }}</span></p>
          <button class="demo-button" @click="handleThrottleClick">点击（节流）</button>
        </div>
      </div>
      
      <h3>4.2 格式化工具</h3>
      <div class="tools-preview">
        <div class="tool-demo">
          <p>日期格式化：{{ formattedDate }}</p>
          <p>日期时间格式化：{{ formattedDateTime }}</p>
          <p>货币格式化：{{ formattedCurrency }}</p>
          <p>相对时间：{{ formattedRelativeTime }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import StartPage from './StartPage.vue';
import WorkTypePage from './WorkTypePage.vue';
import NavigationButtons from '../common/NavigationButtons.vue';
import Modal from '../common/Modal.vue';
import TabsContainer from '../common/TabsContainer.vue';
import { debounce, throttle } from '../../utils/helpers/debounce';
import { formatDate, formatDateTime, formatCurrency, formatRelativeTime } from '../../utils/helpers/formatters';

// 导航处理器
const handleNavigate = (page: string) => {
  console.log('导航到页面:', page);
};

const handleUnavailable = (type: string) => {
  console.log('功能尚未开放:', type);
};

const handleNavigateBack = () => {
  console.log('返回上一页');
};

const handleNavigateNext = (type: string) => {
  console.log('下一页，选择类型:', type);
};

// 导航按钮演示
const demoNextDisabled = ref(false);

const handleNavBack = () => {
  console.log('点击了返回按钮');
};

const handleNavNext = () => {
  console.log('点击了下一步按钮');
};

// 模态框演示
const showModal = ref(false);

// 选项卡演示
const demoTabs = [
  { id: 'tab1', label: '标签页 1' },
  { id: 'tab2', label: '标签页 2' },
  { id: 'tab3', label: '标签页 3' }
];
const activeTabIndex = ref(0);

// 防抖与节流演示
const debounceCounter = ref(0);
const throttleCounter = ref(0);

const handleDebounceClick = debounce(() => {
  debounceCounter.value++;
}, 1000);

const handleThrottleClick = throttle(() => {
  throttleCounter.value++;
}, 1000);

// 格式化工具演示
const now = new Date();
const fiveDaysAgo = new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000);

const formattedDate = formatDate(now);
const formattedDateTime = formatDateTime(now);
const formattedCurrency = formatCurrency(1999.99);
const formattedRelativeTime = formatRelativeTime(fiveDaysAgo);
</script>

<style scoped>
.demo-page {
  padding: 30px;
  max-width: 1200px;
  margin: 0 auto;
  color: #fff;
}

.demo-title {
  text-align: center;
  font-size: 28px;
  margin-bottom: 30px;
  color: #fff;
}

.demo-section {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 30px;
}

.demo-section h2 {
  margin-top: 0;
  font-size: 22px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  padding-bottom: 10px;
  margin-bottom: 20px;
}

.demo-section h3 {
  font-size: 18px;
  margin-top: 20px;
  color: rgba(255, 255, 255, 0.9);
}

.component-preview {
  margin-top: 20px;
  margin-bottom: 20px;
  border: 1px dashed rgba(255, 255, 255, 0.3);
  padding: 20px;
  border-radius: 8px;
  background: rgba(0, 0, 0, 0.2);
}

.common-component-preview {
  margin-top: 10px;
  margin-bottom: 20px;
  padding: 15px;
  border-radius: 8px;
  background: rgba(0, 0, 0, 0.1);
}

.demo-button {
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 24px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.demo-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(0, 114, 255, 0.4);
}

.tab-content-demo {
  min-height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  font-size: 18px;
}

.tools-preview {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-top: 10px;
}

.tool-demo {
  flex: 1;
  min-width: 300px;
  padding: 15px;
  background: rgba(0, 0, 0, 0.1);
  border-radius: 8px;
}

.counter {
  font-weight: bold;
  font-size: 18px;
  margin-left: 10px;
  color: #00c6ff;
}

/* 在小屏幕上调整布局 */
@media (max-width: 768px) {
  .demo-page {
    padding: 15px;
  }
  
  .component-preview, 
  .common-component-preview, 
  .tool-demo {
    padding: 10px;
  }
  
  .tools-preview {
    flex-direction: column;
  }
}
</style> 