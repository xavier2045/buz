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
  background-image: url('../../assets/images/working-on-virtual-screen.png');
  background-size: cover;
  background-position: center;
}

.people-icon {
  background-color: rgba(156, 39, 176, 0.2);
  background-image: url('../../assets/images/virtual-meeting.png');
  background-size: contain;
}
</style> 