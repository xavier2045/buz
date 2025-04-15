<template>
  <div class="option-conflict-modal">
    <div class="modal-content">
      <header class="modal-header">
        <h2>选项冲突</h2>
        <span class="close-btn" @click="$emit('close')">×</span>
      </header>
      <div class="modal-body">
        <div class="conflict-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="8" x2="12" y2="12"></line>
            <line x1="12" y1="16" x2="12.01" y2="16"></line>
          </svg>
        </div>
        <div class="conflict-info">
          <p class="conflict-message">{{ conflictData.message }}</p>
          
          <div class="conflict-details">
            <p class="details-title">当前选择：</p>
            <div class="option-value">
              <span class="filter-id">{{ getFilterName(conflictData.filterId) }}</span>
              <span class="filter-value">{{ getReadableValue(conflictData.filterId, conflictData.value) }}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="modal-btn ok-btn" @click="$emit('close')">我知道了</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  conflictData: {
    type: Object,
    required: true,
    default: () => ({
      message: '',
      filterId: '',
      value: ''
    })
  }
});

defineEmits(['close']);

// 将过滤器ID转换为易读名称
const getFilterName = (filterId: string): string => {
  const filterNames: Record<string, string> = {
    'ai-training': 'AI训练',
    'commercial-use': '商业使用',
    'attribution': '标明来源',
    'remixing': '混音',
    'licensing-fee': '许可费用',
    'expiration': '许可期限'
  };
  
  return filterNames[filterId] || filterId;
};

// 将值转换为易读格式
const getReadableValue = (filterId: string, value: string): string => {
  if (filterId === 'ai-training') {
    return value === 'yes' ? '允许' : '不允许';
  } else if (filterId === 'commercial-use') {
    return value === 'yes' ? '允许' : '不允许';
  } else if (filterId === 'attribution') {
    return value === 'required' ? '必须' : '不需要';
  } else if (filterId === 'remixing') {
    return value === 'yes' ? '允许' : '不允许';
  } else if (filterId === 'licensing-fee') {
    return value;
  } else if (filterId === 'expiration') {
    if (value === 'never') return '永久';
    if (value === '1year') return '1年';
    if (value === '6month') return '6个月';
    return value;
  }
  
  return value;
};
</script>

<style scoped>
.option-conflict-modal {
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
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header {
  padding: 20px;
  background: #2c2c2e;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header h2 {
  margin: 0;
  font-size: 20px;
  color: white;
}

.close-btn {
  font-size: 24px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.7);
  transition: all 0.2s;
}

.close-btn:hover {
  color: white;
}

.modal-body {
  padding: 25px;
  overflow-y: auto;
}

.conflict-icon {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.conflict-icon svg {
  width: 60px;
  height: 60px;
  color: #ff9800;
  background: rgba(255, 152, 0, 0.1);
  border-radius: 50%;
  padding: 15px;
}

.conflict-info {
  text-align: center;
}

.conflict-message {
  font-size: 16px;
  color: white;
  margin-bottom: 20px;
  line-height: 1.5;
}

.conflict-details {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  padding: 15px;
  margin-top: 15px;
}

.details-title {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 0;
  margin-bottom: 10px;
}

.option-value {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
}

.filter-id {
  font-weight: 500;
  color: white;
}

.filter-value {
  color: #06D6A0;
  font-weight: 500;
}

.modal-footer {
  padding: 15px 20px;
  display: flex;
  justify-content: center;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-btn {
  padding: 10px 20px;
  border-radius: 8px;
  border: none;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.2s;
}

.ok-btn {
  background: linear-gradient(90deg, #06D6A0, #00C692);
  color: white;
}

.ok-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(6, 214, 160, 0.3);
}

.expand-arrow span {
  font-size: 10px;
  transition: transform 0.3s;
}

.expand-arrow span.rotated {
  transform: rotate(180deg);
}

.circle-arrow {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.circle-arrow svg {
  width: 18px;
  height: 18px;
  fill: currentColor;
}
</style> 