<template>
  <div 
    class="glowing-type-card"
    :class="{ 
      selected: selected,
      disabled: disabled,
      [`type-${type}`]: true
    }"
    @click="!disabled && $emit('select')"
  >
    <!-- 发光边框效果 -->
    <div 
      ref="containerRef"
      :style="containerStyles"
      class="glowing-border"
    >
      <div class="glow-effect" />
    </div>
    
    <!-- 卡片内容 -->
    <div class="card-content">
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps<{
  type: 'video' | 'image' | 'audio' | 'text';
  selected: boolean;
  disabled: boolean;
}>();

defineEmits(['select']);

const containerRef = ref<HTMLElement | null>(null);
const lastPosition = ref({ x: 0, y: 0 });
const animationFrame = ref(0);

// 根据不同类型获取不同渐变
const getGradient = (type: string) => {
  switch(type) {
    case 'video':
      return `radial-gradient(circle, rgba(80, 80, 80, 1) 0%, rgba(0, 0, 0, 0.9) 100%)`;
    case 'image':
      return `radial-gradient(circle, rgba(255, 60, 60, 1) 0%, rgba(200, 0, 0, 0.9) 100%)`;
    case 'audio':
      return `radial-gradient(circle, rgba(254, 202, 37, 1) 0%, rgba(255, 153, 0, 0.9) 100%)`;
    case 'text':
      return `radial-gradient(circle, rgba(160, 70, 240, 1) 0%, rgba(120, 0, 200, 0.9) 100%)`;
    default:
      return ``;
  }
};

// 计算容器样式
const containerStyles = computed(() => {
  return {
    '--spread': 30,
    '--start': 0,
    '--active': props.selected ? 1 : 0,
    '--border-width': `4px`,
    '--gradient': getGradient(props.type),
    '--glow-size': props.selected ? '20px' : '10px',
  };
});

// 简单动画函数
function animate(start: number, end: number, duration: number, callback: (value: number) => void) {
  const startTime = performance.now();
  
  function update(currentTime: number) {
    const elapsed = currentTime - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const value = start + (end - start) * progress;
    
    callback(value);
    
    if (progress < 1) {
      requestAnimationFrame(update);
    }
  }
  
  requestAnimationFrame(update);
}

// 鼠标移动处理
function handleMove(e: MouseEvent) {
  if (!containerRef.value || props.disabled) return;
  
  if (animationFrame.value) {
    cancelAnimationFrame(animationFrame.value);
  }
  
  animationFrame.value = requestAnimationFrame(() => {
    const element = containerRef.value;
    if (!element) return;
    
    const { left, top, width, height } = element.getBoundingClientRect();
    const mouseX = e.clientX;
    const mouseY = e.clientY;
    
    // 更新最后位置
    lastPosition.value = { x: mouseX, y: mouseY };
    
    // 检查鼠标是否在元素内部或附近
    const isActive = 
      mouseX >= left - 80 && 
      mouseX <= left + width + 80 && 
      mouseY >= top - 80 && 
      mouseY <= top + height + 80;
    
    if (!isActive) {
      element.style.setProperty('--active', props.selected ? '1' : '0');
      return;
    }
    
    // 计算角度
    const centerX = left + width / 2;
    const centerY = top + height / 2;
    const angle = Math.atan2(mouseY - centerY, mouseX - centerX) * (180 / Math.PI) + 90;
    
    element.style.setProperty('--active', '1');
    
    // 设置新起始角度
    const currentAngle = element.style.getPropertyValue('--start') || '0';
    animate(parseFloat(currentAngle), angle, 1000, (value) => {
      element.style.setProperty('--start', `${value}`);
    });
  });
}

onMounted(() => {
  if (!props.disabled) {
    document.addEventListener('mousemove', handleMove);
  }
});

onUnmounted(() => {
  document.removeEventListener('mousemove', handleMove);
  
  if (animationFrame.value) {
    cancelAnimationFrame(animationFrame.value);
  }
});
</script>

<style scoped>
.glowing-type-card {
  position: relative;
  background: rgba(30, 30, 35, 0.6);
  border-radius: 10px;
  padding: 15px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  overflow: hidden;
  aspect-ratio: 1/1;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.glowing-type-card:hover {
  transform: translateY(-2px) scale(1.02);
  background: rgba(30, 30, 35, 0.6);
}

.glowing-type-card.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.glowing-border {
  position: absolute;
  inset: -1px;
  pointer-events: none;
  border-radius: inherit;
  overflow: hidden;
  z-index: 0;
}

.glow-effect {
  position: absolute;
  inset: 0;
  border-radius: inherit;
  z-index: 0;
}

.glow-effect::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border: var(--border-width) solid transparent;
  border-radius: inherit;
  background: var(--gradient);
  background-attachment: fixed;
  opacity: var(--active);
  transition: opacity 0.3s;
  mask-clip: padding-box, border-box;
  mask-composite: intersect;
  mask-image: linear-gradient(#0000, #0000), 
              conic-gradient(
                from calc((var(--start) - var(--spread)) * 1deg),
                #00000000 0deg,
                #fff,
                #00000000 calc(var(--spread) * 2deg)
              );
  box-shadow: 0 0 var(--glow-size) var(--gradient);
  filter: brightness(1.5) contrast(1.2);
}

.card-content {
  position: relative;
  z-index: 1;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

/* 选中状态样式 */
.glowing-type-card.selected {
  z-index: 1;
  box-shadow: 0 6px 25px rgba(0, 0, 0, 0.5);
}

.glowing-type-card.type-video.selected {
  background: transparent;
  box-shadow: 0 0 30px rgba(50, 50, 50, 0.8);
}

.glowing-type-card.type-image.selected {
  background: transparent;
  box-shadow: 0 0 30px rgba(255, 0, 0, 0.5);
}

.glowing-type-card.type-audio.selected {
  background: transparent;
  box-shadow: 0 0 30px rgba(255, 153, 0, 0.5);
}

.glowing-type-card.type-text.selected {
  background: transparent;
  box-shadow: 0 0 30px rgba(160, 70, 240, 0.5);
}

.glowing-type-card::before {
  display: none;
}

.glowing-type-card:hover::before {
  display: none;
}

.glowing-type-card.selected::before {
  display: none;
}
</style> 