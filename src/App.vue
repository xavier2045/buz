<template>
  <div class="app-container">
    <BlurContainer />
  </div>
</template>

<script setup lang="ts">
import BlurContainer from './components/layout/BlurContainer.vue';
import { ref } from 'vue';

// 添加AI训练设置状态
const aiTrainingEnabled = ref(true); // 默认允许AI训练，但不再强制
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  height: 100%;
  overflow: hidden;
}

body {
  font-family: Inter, Avenir, Helvetica, Arial, sans-serif;
  color: white;
  background: linear-gradient(to bottom, #07070f, #0a0a1e);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.app-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
  width: 100vw;
  overflow: hidden;
  position: relative;
  perspective: 1000px;
}

button {
  font-family: inherit;
}

/* 通用样式可以在这里添加 */
</style>