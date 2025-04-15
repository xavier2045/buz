<template>
  <div class="revenue-header">
    <div class="header-text">
      <p>哈！接下来</p>
      <p>会有收入分成吗？</p>
    </div>
    <div class="assistant-avatar">
      <img src="/images/girl-pointing-up_1.png" alt="AE Assistant" />
    </div>
  </div>
</template>

<style scoped>
.revenue-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 80px;
}

.header-text {
  flex: 1;
  padding-left: 100px;
  max-width: 600px;
  margin: 0 auto;
}

.header-text p {
  margin: 8px 0;
}

.header-text p:first-child {
  font-size: 28px;
  font-weight: 500;
  margin-bottom: 12px;
}

.header-text p:nth-child(2),
.header-text p:nth-child(3) {
  font-size: 20px;
  color: rgba(255, 255, 255, 0.9);
  margin: 5px 0;
}

.assistant-avatar {
  width: 120px;
  height: 120px;
  overflow: visible;
  background: transparent;
  margin-left: 30px;
  margin-right: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.assistant-avatar img {
  width: 140px;
  height: 140px;
  object-fit: contain;
  filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
  background-color: transparent;
  transform: translateX(-120px);
}

@media (max-width: 767px) {
  .header-text {
    padding-left: 0;
  }
  
  .assistant-avatar {
    display: none;
  }
  
  .header-text p:first-child {
    font-size: 24px;
  }
  
  .header-text p:nth-child(2),
  .header-text p:nth-child(3) {
    font-size: 18px;
  }
}
</style> 