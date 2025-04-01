<template>
  <div class="start-page">
    <div class="header">
      <h1>AETRIX开启您的IP发布</h1>
      <p class="subtitle-zh">选择您要进行的操作</p>
    </div>
    
    <div class="menu-options">
      <div class="menu-card" data-text="发布作品" @click="goToWorkType">
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
</template>

<script setup lang="ts">
const emit = defineEmits(['navigate', 'show-unavailable']);

const goToWorkType = () => {
  emit('navigate', 'workType');
}

const showUnavailable = (type: string) => {
  emit('show-unavailable', type);
}
</script>

<style scoped>
.start-page {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  text-align: center;
  margin-bottom: 60px;
}

.header h1 {
  font-size: 36px;
  margin-bottom: 8px;
  color: #ffffff;
}

.subtitle-zh {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
}

.menu-options {
  display: flex;
  justify-content: center;
  gap: 40px;
  flex-wrap: wrap;
}

.menu-card {
  width: 180px;
  height: 180px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  position: relative;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.menu-card:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
}

.menu-card::after {
  content: attr(data-text);
  position: absolute;
  bottom: -30px;
  font-size: 16px;
  color: white;
}

.menu-icon {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background-position: center;
  background-repeat: no-repeat;
  background-size: 50%;
}

.product-icon {
  background-color: rgba(64, 156, 255, 0.2);
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%23409cff' viewBox='0 0 24 24'%3E%3Cpath d='M14,2H6C4.9,2 4,2.9 4,4v16c0,1.1 0.9,2 2,2h12c1.1,0 2-0.9 2-2V8L14,2zM16,16H8v-2h8V16zM16,12H8v-2h8V12zM13,9V3.5L18.5,9H13z'/%3E%3C/svg%3E");
}

.task-icon {
  background-color: rgba(255, 138, 101, 0.2);
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%23ff8a65' viewBox='0 0 24 24'%3E%3Cpath d='M19,3h-4.18C14.4,1.84 13.3,1 12,1S9.6,1.84 9.18,3H5C3.9,3 3,3.9 3,5v14c0,1.1 0.9,2 2,2h14c1.1,0 2-0.9 2-2V5C21,3.9 20.1,3 19,3zM12,3c0.55,0 1,0.45 1,1s-0.45,1-1,1s-1-0.45-1-1S11.45,3 12,3zM14,17H7v-2h7V17zM17,13H7v-2h10V13zM17,9H7V7h10V9z'/%3E%3C/svg%3E");
}

.people-icon {
  background-color: rgba(156, 39, 176, 0.2);
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%239c27b0' viewBox='0 0 24 24'%3E%3Cpath d='M16,11c1.66,0 2.99,-1.34 2.99,-3S17.66,5 16,5s-3,1.34 -3,3 1.34,3 3,3zM8,11c1.66,0 2.99,-1.34 2.99,-3S9.66,5 8,5 5,6.34 5,8s1.34,3 3,3zM8,13c-2.33,0 -7,1.17 -7,3.5L1,19h14v-2.5c0,-2.33 -4.67,-3.5 -7,-3.5zM16,13c-0.29,0 -0.62,0.02 -0.97,0.05 1.16,0.84 1.97,1.97 1.97,3.45L17,19h6v-2.5c0,-2.33 -4.67,-3.5 -7,-3.5z'/%3E%3C/svg%3E");
}
</style> 