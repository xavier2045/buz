<template>
  <div class="particle-whirlpool">
    <canvas ref="canvas" class="whirlpool-canvas"></canvas>
    
    <!-- 漂浮的IP标志 -->
    <div class="floating-ip">
      <div class="ip-badge">IP</div>
      <div class="glow-circle"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

const canvas = ref<HTMLCanvasElement | null>(null);
let ctx: CanvasRenderingContext2D | null = null;
let animationId: number | null = null;
let particles: Particle[] = [];
let mouseX = 0;
let mouseY = 0;
let lastTime = 0;
let delta = 0;
let lastMouseMoveTime = 0;
let isMouseIdle = false;
let activeCorner = 0;
let patternTransitionTime = 0;
let patternProgress = 0;
let currentPatternIndex = 0;
let patternCycleInterval: number | null = null;
let lastPatternChangeTime = 0;
let centerX = 0;
let centerY = 0;

// 预定义的生物形状模式
const bioPatterns = [
  // DNA 螺旋
  { name: 'dna', points: generateDNAPattern() },
  // 细胞分裂
  { name: 'cell', points: generateCellPattern() },
  // 花朵形状
  { name: 'flower', points: generateFlowerPattern() },
  // 星星形状
  { name: 'star', points: generateStarPattern() }
];

// 生成DNA螺旋模式的点
function generateDNAPattern() {
  const points = [];
  const turnCount = 3; // 螺旋转数
  const pointsPerTurn = 15; // 每转的点数
  const radius = 40; // 螺旋半径
  const totalPoints = turnCount * pointsPerTurn;
  
  for (let i = 0; i < totalPoints; i++) {
    const angle = (i / pointsPerTurn) * Math.PI * 2;
    const height = (i / totalPoints) * 120 - 60;
    const x = Math.cos(angle) * radius;
    const y = height;
    const z = Math.sin(angle) * radius;
    
    // 添加沿螺旋的点
    points.push({ 
      x, y, z, 
      pulseRate: 0.8 + Math.random() * 0.4, // 脉动速率
      pulseDepth: 0.2 + Math.random() * 0.2 // 脉动深度
    });
    
    // 添加螺旋的另一侧(DNA双螺旋)
    if (i % 3 === 0) {
      points.push({ 
        x: Math.cos(angle + Math.PI) * radius,
        y: height,
        z: Math.sin(angle + Math.PI) * radius,
        pulseRate: 0.8 + Math.random() * 0.4,
        pulseDepth: 0.2 + Math.random() * 0.2
      });
    }
  }
  
  return points;
}

// 生成细胞分裂模式的点
function generateCellPattern() {
  const points = [];
  const cellRadius = 50;
  const nucleusRadius = 20;
  
  // 添加外部细胞膜的点
  for (let angle = 0; angle < Math.PI * 2; angle += 0.2) {
    const variance = Math.random() * 10 - 5; // 添加一些随机性
    const radius = cellRadius + variance;
    const pulseRate = 0.5 + Math.random() * 0.3; // 膜的脉动较慢
    
    points.push({
      x: Math.cos(angle) * radius,
      y: Math.sin(angle) * radius,
      z: 0,
      pulseRate,
      pulseDepth: 0.15 + Math.random() * 0.15,
      isMembranePoint: true // 标记为膜点
    });
  }
  
  // 添加内部细胞核的点
  for (let angle = 0; angle < Math.PI * 2; angle += 0.4) {
    points.push({
      x: Math.cos(angle) * nucleusRadius,
      y: Math.sin(angle) * nucleusRadius,
      z: 0,
      pulseRate: 1.2 + Math.random() * 0.4, // 核的脉动较快
      pulseDepth: 0.1 + Math.random() * 0.1,
      isNucleusPoint: true // 标记为核点
    });
  }
  
  // 添加内部结构
  for (let i = 0; i < 8; i++) {
    const angle = i * (Math.PI / 4);
    const radius = nucleusRadius + (cellRadius - nucleusRadius) * 0.6;
    points.push({
      x: Math.cos(angle) * radius,
      y: Math.sin(angle) * radius,
      z: 0,
      pulseRate: 0.7 + Math.random() * 0.5,
      pulseDepth: 0.2 + Math.random() * 0.2
    });
  }
  
  return points;
}

// 生成花朵图案的点
function generateFlowerPattern() {
  const points = [];
  const petalCount = 6;
  const innerRadius = 10;
  const outerRadius = 60;
  
  // 花瓣
  for (let i = 0; i < petalCount; i++) {
    const baseAngle = (i / petalCount) * Math.PI * 2;
    
    // 每个花瓣的点
    for (let j = 0; j < 10; j++) {
      const angle = baseAngle + (j / 20 - 0.25) * (Math.PI / 2);
      const radius = innerRadius + (outerRadius - innerRadius) * (Math.sin(j / 10 * Math.PI));
      
      points.push({
        x: Math.cos(angle) * radius,
        y: Math.sin(angle) * radius,
        z: 0,
        pulseRate: 0.3 + Math.random() * 0.3, // 花瓣脉动缓慢
        pulseDepth: 0.2 + Math.random() * 0.2,
        petalIndex: i // 标记花瓣索引
      });
    }
  }
  
  // 花蕊
  for (let angle = 0; angle < Math.PI * 2; angle += 0.5) {
    points.push({
      x: Math.cos(angle) * innerRadius * 0.9,
      y: Math.sin(angle) * innerRadius * 0.9,
      z: 0,
      pulseRate: 1.0 + Math.random() * 0.5, // 花蕊脉动较快
      pulseDepth: 0.15 + Math.random() * 0.15,
      isCenter: true // 标记为中心点
    });
  }
  
  return points;
}

// 生成星形图案的点
function generateStarPattern() {
  const points = [];
  const starPoints = 5;
  const innerRadius = 25;
  const outerRadius = 60;
  
  // 星星的点
  for (let i = 0; i < starPoints * 2; i++) {
    const angle = (i / (starPoints * 2)) * Math.PI * 2;
    const radius = i % 2 === 0 ? outerRadius : innerRadius;
    
    points.push({
      x: Math.cos(angle) * radius,
      y: Math.sin(angle) * radius,
      z: 0,
      pulseRate: 0.6 + Math.random() * 0.4,
      pulseDepth: i % 2 === 0 ? 0.3 + Math.random() * 0.2 : 0.1 + Math.random() * 0.1,
      isOuter: i % 2 === 0 // 标记外部点
    });
  }
  
  // 添加中心点
  for (let angle = 0; angle < Math.PI * 2; angle += 0.6) {
    const radius = innerRadius * 0.4;
    points.push({
      x: Math.cos(angle) * radius,
      y: Math.sin(angle) * radius,
      z: 0,
      pulseRate: 1.2 + Math.random() * 0.3,
      pulseDepth: 0.2 + Math.random() * 0.1,
      isCenter: true // 标记为中心点
    });
  }
  
  return points;
}

// 获取角落位置
function getCornerPosition(canvasWidth: number, canvasHeight: number, cornerIndex: number) {
  const margin = 130; // 距离边缘的距离
  
  switch (cornerIndex) {
    case 0: // 左上角
      return { x: margin, y: margin };
    case 1: // 右上角
      return { x: canvasWidth - margin, y: margin };
    case 2: // 右下角
      return { x: canvasWidth - margin, y: canvasHeight - margin };
    case 3: // 左下角
      return { x: margin, y: canvasHeight - margin };
    default:
      return { x: canvasWidth / 2, y: canvasHeight / 2 };
  }
}

// 粒子类
class Particle {
  x: number;
  y: number;
  size: number;
  speedX: number;
  speedY: number;
  vx: number;
  vy: number;
  angle: number;
  spin: number;
  distance: number;
  color: string;
  alpha: number;
  maxDistance: number;
  glowing: boolean;
  
  // 形态变化相关属性
  targetX: number;
  targetY: number;
  homeX: number;
  homeY: number;
  inPattern: boolean;
  patternIndex: number;
  
  // 生物状态相关属性
  pulseRate: number;
  pulsePhase: number; 
  pulseDepth: number;
  patternRole: string;
  
  constructor(x: number, y: number, canvasWidth: number, canvasHeight: number) {
    this.x = x;
    this.y = y;
    this.size = Math.random() * 2.5 + 0.8;
    this.speedX = 0;
    this.speedY = 0;
    this.vx = 0;
    this.vy = 0;
    this.angle = Math.random() * Math.PI * 2;
    this.spin = (Math.random() > 0.5 ? 1 : -1) * (Math.random() * 0.001 + 0.001);
    this.distance = Math.random() * 80 + 50;
    
    // AETRIX品牌色彩 - 增加更多明亮的颜色
    const colors = [
      'rgba(74, 103, 207, 0.8)',  // 蓝色
      'rgba(114, 137, 218, 0.8)', // 亮蓝色
      'rgba(140, 232, 255, 0.8)', // 天蓝色
      'rgba(194, 159, 255, 0.8)', // 紫色
      'rgba(255, 213, 140, 0.8)',  // 金色
      'rgba(255, 255, 255, 0.7)',  // 白色
      'rgba(116, 215, 255, 0.8)',  // 浅蓝色
      'rgba(180, 190, 255, 0.8)',  // 淡紫色
    ];
    
    this.color = colors[Math.floor(Math.random() * colors.length)];
    this.alpha = Math.random() * 0.6 + 0.4; // 增加基础透明度
    this.maxDistance = Math.max(canvasWidth, canvasHeight) * 0.8;
    this.glowing = Math.random() > 0.85; // 增加发光粒子比例为15%
    
    // 形态变化初始化
    this.targetX = x;
    this.targetY = y;
    this.homeX = x;
    this.homeY = y;
    this.inPattern = false;
    this.patternIndex = -1;
    
    // 初始化生物脉动属性
    this.pulseRate = 0.5 + Math.random() * 1.0; // 脉动速率
    this.pulsePhase = Math.random() * Math.PI * 2; // 随机相位
    this.pulseDepth = 0.2; // 默认脉动深度
    this.patternRole = ''; // 用于额外的视觉效果
  }
  
  update(mouseX: number, mouseY: number, deltaTime: number, idle: boolean = false) {
    if (idle && this.patternIndex >= 0) {
      // 当鼠标闲置时，粒子向目标位置移动形成生物形状
      
      // 应用脉动效果
      const pulseOffset = Math.sin(Date.now() * 0.001 * this.pulseRate + this.pulsePhase) * this.pulseDepth;
      
      // 计算包含脉动的目标位置
      const pulsedTargetX = this.targetX + (this.targetX - centerX) * pulseOffset;
      const pulsedTargetY = this.targetY + (this.targetY - centerY) * pulseOffset;
      
      const dx = pulsedTargetX - this.x;
      const dy = pulsedTargetY - this.y;
      const dist = Math.sqrt(dx * dx + dy * dy);
      
      if (dist > 0.5) {
        // 平滑过渡到目标位置，根据距离调整速度
        const speed = Math.min(0.08, 0.03 + dist * 0.001); // 距离越远速度越快
        this.vx = dx * speed;
        this.vy = dy * speed;
      } else {
        // 到达目标位置后微小晃动，模拟生物运动
        const wiggleAmount = 0.06 + Math.sin(Date.now() * 0.001) * 0.04; // 有规律的微晃
        this.vx += (Math.random() - 0.5) * wiggleAmount;
        this.vy += (Math.random() - 0.5) * wiggleAmount;
        this.vx *= 0.92;
        this.vy *= 0.92;
      }
      
      // 根据粒子角色调整视觉效果
      if (this.glowing) {
        // 发光粒子基础效果增强
        this.alpha = Math.min(1, this.alpha + 0.002);
        
        // 角色特定的尺寸和发光效果
        if (this.patternRole === 'nucleus' || this.patternRole === 'center') {
          // 核心部分特别明亮
          this.size = Math.min(3.5, this.size * 1.001);
          this.alpha = Math.min(1, this.alpha + 0.003);
        } else if (this.patternRole === 'membrane' || this.patternRole === 'outer') {
          // 外围部分适度发光
          this.size = Math.min(2.8, this.size * 1.0005);
        } else {
          // 默认发光效果
          this.size = Math.min(3, this.size * 1.001);
        }
      } else if (this.inPattern) {
        // 非发光粒子在图案中也有特殊效果
        this.alpha = Math.min(0.9, this.alpha + 0.001);
        this.size = Math.min(2, this.size * 1.0003);
      }
    } else {
      // 正常的漩涡粒子行为
      // 降低旋转速度
      this.angle += this.spin * deltaTime * 0.6;
      
      // 更新基于漩涡的位置
      const cx = mouseX;
      const cy = mouseY;
      
      const dx = this.x - cx;
      const dy = this.y - cy;
      const distToCenter = Math.sqrt(dx * dx + dy * dy);
      
      if (distToCenter > 5) {
        // 降低力度系数，使运动更缓慢
        let force = (distToCenter < 300) ? 0.02 * deltaTime : 0.005 * deltaTime;
        
        // 稍微减弱旋转角度影响
        const angle = Math.atan2(dy, dx) + (Math.PI / 2) * (distToCenter < 200 ? -1.2 : 1.0);
        
        // 降低距离因子影响
        const distanceFactor = Math.max(0, 1 - distToCenter / 350);
        force *= (1 + distanceFactor * 2.5);
        
        // 减少随机扰动的幅度
        const turbulence = Math.sin(Date.now() * 0.0005 + this.angle * 8) * 0.003;
        
        // 减缓速度增量
        this.vx += (Math.cos(angle) * force) + turbulence;
        this.vy += (Math.sin(angle) * force) + turbulence;
        
        // 如果是发光粒子，减缓特效变化速度
        if (this.glowing && distToCenter < 150) {
          this.alpha = Math.min(1, this.alpha + 0.005); // 减慢不透明度变化
          this.size = Math.min(this.size * 1.002, this.size * 1.5); // 减慢尺寸增长
        } else {
          // 更平缓地恢复正常值
          this.alpha = this.alpha * 0.995 + (Math.random() * 0.5 + 0.3) * 0.005;
          this.size = this.size * 0.995 + (Math.random() * 1.5 + 0.5) * 0.005;
        }
      }
    }
    
    // 增加阻力，使粒子更快停下来
    this.vx *= 0.95;
    this.vy *= 0.95;
    
    // 降低位置变化速度
    this.x += this.vx * 0.8;
    this.y += this.vy * 0.8;
    
    // 粒子触边重置
    this.checkBounds();
  }
  
  // 设置粒子生物形状目标位置
  setPatternTarget(patternPoint: any, centerX: number, centerY: number, scale: number = 1) {
    this.targetX = centerX + patternPoint.x * scale;
    this.targetY = centerY + patternPoint.y * scale;
    this.inPattern = true;
    
    // 复制模式特定属性
    if (patternPoint.pulseRate !== undefined) {
      this.pulseRate = patternPoint.pulseRate;
    }
    if (patternPoint.pulseDepth !== undefined) {
      this.pulseDepth = patternPoint.pulseDepth;
    }
    
    // 设置粒子角色
    if (patternPoint.isMembranePoint) this.patternRole = 'membrane';
    else if (patternPoint.isNucleusPoint) this.patternRole = 'nucleus';
    else if (patternPoint.isCenter) this.patternRole = 'center';
    else if (patternPoint.isOuter) this.patternRole = 'outer';
    else if (patternPoint.petalIndex !== undefined) this.patternRole = 'petal-' + patternPoint.petalIndex;
    else this.patternRole = '';
  }
  
  // 重置为自由漂浮
  resetToFreedom() {
    this.inPattern = false;
    this.patternIndex = -1;
    
    // 稍微增加随机性，使解散看起来更自然
    this.vx += (Math.random() - 0.5) * 2;
    this.vy += (Math.random() - 0.5) * 2;
  }
  
  checkBounds() {
    const canvas = document.querySelector('.whirlpool-canvas') as HTMLCanvasElement;
    if (!canvas) return;
    
    const width = canvas.width;
    const height = canvas.height;
    
    // 边界检查
    if (this.x < -100) this.x = width + 100;
    if (this.x > width + 100) this.x = -100;
    if (this.y < -100) this.y = height + 100;
    if (this.y > height + 100) this.y = -100;
  }
  
  draw(ctx: CanvasRenderingContext2D) {
    if (!ctx) return;
    
    const now = Date.now() * 0.001;
    
    // 增强脉动效果
    const pulseSize = 1 + Math.sin(now * this.pulseRate + this.pulsePhase) * this.pulseDepth * 1.2;
    
    // 为发光粒子添加光晕效果
    if (this.glowing) {
      const colorMatch = this.color.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*[\d.]+)?\)/);
      if (colorMatch) {
        const r = colorMatch[1];
        const g = colorMatch[2];
        const b = colorMatch[3];
        
        // 创建径向渐变，增大光晕尺寸
        const glowRadius = this.size * pulseSize * 3; // 增加光晕大小
        const glow = ctx.createRadialGradient(
          this.x, this.y, 0,
          this.x, this.y, glowRadius
        );
        
        // 增强发光效果，调整透明度
        let glowIntensity = this.inPattern ? 0.7 : 0.6;
        let glowFade = this.inPattern ? 0.2 : 0.15;
        
        // 根据角色调整发光强度
        if (this.inPattern && this.patternRole) {
          if (this.patternRole === 'nucleus' || this.patternRole === 'center') {
            glowIntensity = 0.85; // 核心发光更强
            glowFade = 0.25;
          } else if (this.patternRole === 'membrane' || this.patternRole === 'outer') {
            glowIntensity = 0.75; // 边缘适度发光
            glowFade = 0.18;
          }
        }
        
        glow.addColorStop(0, `rgba(${r}, ${g}, ${b}, ${glowIntensity})`);
        glow.addColorStop(0.6, `rgba(${r}, ${g}, ${b}, ${glowFade})`);
        glow.addColorStop(1, `rgba(${r}, ${g}, ${b}, 0)`);
        
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size * pulseSize, 0, Math.PI * 2);
        ctx.fillStyle = glow;
        
        // 为生物形态中的粒子设置自定义闪烁
        if (this.inPattern) {
          // 根据角色和脉动给不同粒子不同的闪烁周期和强度
          const blinkOffset = this.patternRole === 'nucleus' || this.patternRole === 'center' 
            ? 0.08 : 0.05; // 核心闪烁更明显
          ctx.globalAlpha = 0.3 + Math.sin(Date.now() * 0.001 * this.pulseRate + this.pulsePhase) * blinkOffset;
        } else {
          // 默认闪烁
          ctx.globalAlpha = 0.3 + Math.sin(now * 1.8 + this.angle * 3) * 0.05;
        }
        
        ctx.fill();
      }
    }
    
    // 粒子本身
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
    
    // 在图案中时，为不同角色应用不同颜色效果
    if (this.inPattern && currentPatternIndex !== undefined) {
      // 获取当前图案名称
      const patternName = bioPatterns[currentPatternIndex].name;
      
      // 根据图案类型和角色确定特殊颜色
      if (patternName === 'dna') {
        // DNA螺旋可以有不同链的颜色
        if (this.patternIndex % 2 === 0) {
          this.color = 'rgba(74, 103, 207, 0.85)'; // 蓝色链
        } else {
          this.color = 'rgba(194, 159, 255, 0.85)'; // 紫色链
        }
      } else if (patternName === 'cell') {
        // 细胞不同部分的颜色
        if (this.patternRole === 'nucleus') {
          this.color = 'rgba(255, 213, 140, 0.85)'; // 金色核心
        } else if (this.patternRole === 'membrane') {
          this.color = 'rgba(114, 137, 218, 0.8)'; // 蓝色膜
        }
      } else if (patternName === 'flower') {
        // 花朵不同部分的颜色
        if (this.patternRole === 'center') {
          this.color = 'rgba(255, 213, 140, 0.85)'; // 金色花蕊
        } else if (this.patternRole.startsWith('petal')) {
          // 根据花瓣索引变化颜色
          const petalIndex = parseInt(this.patternRole.split('-')[1]);
          const colors = [
            'rgba(74, 103, 207, 0.8)',  // 蓝色
            'rgba(114, 137, 218, 0.8)', // 亮蓝色
            'rgba(140, 232, 255, 0.8)', // 天蓝色
            'rgba(194, 159, 255, 0.8)', // 紫色
            'rgba(255, 160, 190, 0.8)', // 粉色 (额外添加)
            'rgba(200, 230, 255, 0.8)'  // 浅蓝色 (额外添加)
          ];
          this.color = colors[petalIndex % colors.length];
        }
      } else if (patternName === 'star') {
        // 星星不同部分的颜色
        if (this.patternRole === 'center') {
          this.color = 'rgba(255, 213, 140, 0.85)'; // 金色中心
        } else if (this.patternRole === 'outer') {
          this.color = 'rgba(140, 232, 255, 0.8)'; // 天蓝色外围
        }
      }
    }
    
    ctx.fillStyle = this.color;
    ctx.globalAlpha = this.alpha;
    ctx.fill();
    
    // 增加小亮点效果
    if (this.size > 0.8) { // 只给较大粒子添加高光
      ctx.beginPath();
      const highlightSize = this.size * 0.35; // 增加高光尺寸
      const highlightOffsetX = this.size * 0.3 * Math.cos(this.angle);
      const highlightOffsetY = this.size * 0.3 * Math.sin(this.angle);
      ctx.arc(
        this.x - highlightOffsetX, 
        this.y - highlightOffsetY, 
        highlightSize, 
        0, Math.PI * 2
      );
      ctx.fillStyle = 'rgba(255, 255, 255, 0.7)'; // 增强高光强度
      ctx.fill();
    }
    
    ctx.globalAlpha = 1;
  }
}

// 初始化粒子
function initParticles() {
  if (!canvas.value) return;
  
  const width = canvas.value.width;
  const height = canvas.value.height;
  
  particles = [];
  
  // 大幅增加粒子数量
  const particleCount = Math.min(2000, (width * height) / 1500); // 显著增加粒子数量
  
  // 使用网格分布使粒子更均匀分布
  const gridSize = Math.sqrt(particleCount);
  const cellWidth = width / gridSize;
  const cellHeight = height / gridSize;
  
  let count = 0;
  // 使用网格方式分布部分粒子
  for (let i = 0; i < gridSize && count < particleCount * 0.6; i++) {
    for (let j = 0; j < gridSize && count < particleCount * 0.6; j++) {
      // 在每个网格单元内随机放置
      const x = (i + Math.random() * 0.7 + 0.15) * cellWidth;
      const y = (j + Math.random() * 0.7 + 0.15) * cellHeight;
      
      particles.push(new Particle(x, y, width, height));
      count++;
    }
  }
  
  // 其余粒子完全随机分布
  for (let i = count; i < particleCount; i++) {
    const x = Math.random() * width;
    const y = Math.random() * height;
    
    particles.push(new Particle(x, y, width, height));
  }
  
  // 添加一些大型特殊粒子
  const specialParticleCount = Math.floor(particleCount * 0.05); // 添加5%的特殊大粒子
  for (let i = 0; i < specialParticleCount; i++) {
    const x = Math.random() * width;
    const y = Math.random() * height;
    
    const specialParticle = new Particle(x, y, width, height);
    specialParticle.size = specialParticle.size * 2.5; // 特殊粒子尺寸是普通粒子的2.5倍
    specialParticle.glowing = true; // 特殊粒子一定会发光
    particles.push(specialParticle);
  }
}

// 更新粒子模式
function updateParticlePattern() {
  if (!canvas.value) return;
  
  const width = canvas.value.width;
  const height = canvas.value.height;
  
  // 检查鼠标是否闲置
  const currentTime = Date.now();
  if (currentTime - lastMouseMoveTime > 3000) { // 3秒无操作视为闲置
    if (!isMouseIdle) {
      // 刚变为闲置状态，开始形成图案
      isMouseIdle = true;
      startPatternFormation();
    }
    
    // 如果处于图案过渡中
    if (patternTransitionTime > 0) {
      const elapsedTime = currentTime - patternTransitionTime;
      const transitionDuration = 2000; // 过渡持续2秒
      
      if (elapsedTime < transitionDuration) {
        // 过渡进行中，更新进度
        patternProgress = elapsedTime / transitionDuration;
      } else {
        // 过渡完成
        patternProgress = 1;
        patternTransitionTime = 0;
      }
    }
  } else {
    // 鼠标活动，重置闲置状态
    if (isMouseIdle) {
      isMouseIdle = false;
      resetPatternFormation();
    }
  }
}

// 开始形成图案
function startPatternFormation() {
  if (!canvas.value) return;
  
  const width = canvas.value.width;
  const height = canvas.value.height;
  
  // 随机选择一个角落
  activeCorner = Math.floor(Math.random() * 4);
  
  // 随机选择一个生物图案，或使用下一个图案
  currentPatternIndex = Math.floor(Math.random() * bioPatterns.length);
  const pattern = bioPatterns[currentPatternIndex];
  
  // 获取选择的角落位置
  const corner = getCornerPosition(width, height, activeCorner);
  
  // 选择特定数量的粒子参与图案形成
  const patternSize = Math.min(pattern.points.length, Math.floor(particles.length * 0.25));
  
  // 随机选择粒子进入图案
  const patternParticles = [];
  const usedParticles = new Set();
  
  // 优先选择靠近角落的粒子
  particles.forEach((particle, i) => {
    const dx = particle.x - corner.x;
    const dy = particle.y - corner.y;
    const distance = Math.sqrt(dx * dx + dy * dy);
    
    particle.patternIndex = -1; // 重置
    
    // 计算距离评分，越近越有可能被选中
    particle.distance = distance;
  });
  
  // 按距离排序
  const sortedParticles = [...particles].sort((a, b) => a.distance - b.distance);
  
  // 选择最近的粒子
  for (let i = 0; i < Math.min(patternSize, sortedParticles.length); i++) {
    const particleIndex = particles.indexOf(sortedParticles[i]);
    if (particleIndex >= 0) {
      patternParticles.push({
        particleIndex,
        patternPointIndex: i % pattern.points.length
      });
      usedParticles.add(particleIndex);
    }
  }
  
  // 设置粒子目标
  let scale = 0.8 + Math.random() * 0.4; // 随机缩放使每次形成的图案大小略有不同
  
  patternParticles.forEach(({ particleIndex, patternPointIndex }) => {
    const particle = particles[particleIndex];
    const point = pattern.points[patternPointIndex];
    
    particle.patternIndex = patternPointIndex;
    particle.setPatternTarget(point, corner.x, corner.y, scale);
  });
  
  // 开始过渡时间
  patternTransitionTime = Date.now();
  patternProgress = 0;
  lastPatternChangeTime = Date.now();
  
  // 设置图案周期性变换
  if (patternCycleInterval === null) {
    patternCycleInterval = window.setInterval(() => {
      if (isMouseIdle && Date.now() - lastPatternChangeTime > 8000) { // 每8秒变换一次形状
        cycleToNextPattern();
      }
    }, 8000);
  }
}

// 切换到下一个图案
function cycleToNextPattern() {
  // 先让当前图案的粒子解散
  resetPatternFormation();
  
  // 短暂延迟后创建新图案
  setTimeout(() => {
    if (isMouseIdle) { // 确保鼠标仍处于闲置状态
      // 选择下一个图案
      currentPatternIndex = (currentPatternIndex + 1) % bioPatterns.length;
      
      // 重新随机选择角落
      const oldCorner = activeCorner;
      while (activeCorner === oldCorner) {
        activeCorner = Math.floor(Math.random() * 4);
      }
      
      // 开始新图案形成
      const width = canvas.value?.width || 0;
      const height = canvas.value?.height || 0;
      const pattern = bioPatterns[currentPatternIndex];
      const corner = getCornerPosition(width, height, activeCorner);
      
      // 选择粒子参与新图案形成
      const patternSize = Math.min(pattern.points.length, Math.floor(particles.length * 0.25));
      
      // 按照到新角落的距离重新排序粒子
      particles.forEach((particle) => {
        const dx = particle.x - corner.x;
        const dy = particle.y - corner.y;
        particle.distance = Math.sqrt(dx * dx + dy * dy);
      });
      
      const sortedParticles = [...particles].sort((a, b) => a.distance - b.distance);
      
      // 新比例尺，让每次形状略有不同
      const scale = 0.8 + Math.random() * 0.4;
      
      // 为最近的粒子分配新图案点
      for (let i = 0; i < Math.min(patternSize, sortedParticles.length); i++) {
        const particleIndex = particles.indexOf(sortedParticles[i]);
        if (particleIndex >= 0) {
          const particle = particles[particleIndex];
          const pointIndex = i % pattern.points.length;
          const point = pattern.points[pointIndex];
          
          particle.patternIndex = pointIndex;
          // 设置更平滑的过渡
          particle.vx *= 0.5; // 减缓当前运动以便更自然地转向新目标
          particle.vy *= 0.5;
          particle.setPatternTarget(point, corner.x, corner.y, scale);
        }
      }
      
      // 更新过渡状态
      patternTransitionTime = Date.now();
      patternProgress = 0;
      lastPatternChangeTime = Date.now();
    }
  }, 1000); // 1秒后形成新图案，给粒子时间散开
}

// 重置图案形成
function resetPatternFormation() {
  particles.forEach(particle => {
    if (particle.inPattern) {
      particle.resetToFreedom();
    }
  });
  
  // 如果有周期性变换定时器，清除它
  if (patternCycleInterval !== null) {
    clearInterval(patternCycleInterval);
    patternCycleInterval = null;
  }
}

// 动画循环
function animate(timestamp: number) {
  if (!canvas.value || !ctx) return;
  
  // 计算时间差
  if (!lastTime) lastTime = timestamp;
  delta = timestamp - lastTime;
  lastTime = timestamp;
  
  // 更新中心点位置，用于脉动计算
  centerX = canvas.value.width / 2;
  centerY = canvas.value.height / 2;
  
  // 更新粒子模式状态
  updateParticlePattern();
  
  ctx.clearRect(0, 0, canvas.value.width, canvas.value.height);
  
  // 创建离屏图层以提高渲染性能
  const canvasWidth = canvas.value.width;
  const canvasHeight = canvas.value.height;
  
  // 使用视口剪切，只渲染视口内的粒子
  const viewportMargin = 100; // 视口外边距
  
  // 更新和绘制粒子
  for (let i = 0; i < particles.length; i++) {
    // 更新所有粒子位置
    particles[i].update(mouseX, mouseY, delta, isMouseIdle);
    
    // 只绘制在视口内及附近的粒子，提高性能
    if (
      particles[i].x > -viewportMargin && 
      particles[i].x < canvasWidth + viewportMargin && 
      particles[i].y > -viewportMargin && 
      particles[i].y < canvasHeight + viewportMargin
    ) {
    particles[i].draw(ctx);
    }
  }
  
  // 绘制粒子连线
  drawLines();
  
  animationId = requestAnimationFrame(animate);
}

// 绘制粒子之间的连线
function drawLines() {
  if (!ctx || !canvas.value) return;
  
  const width = canvas.value.width;
  const height = canvas.value.height;
  
  // 增加最大连接距离
  const maxDistance = 140; // 增加连线距离
  const maxDistanceSq = maxDistance * maxDistance;
  
  // 使用空间分区来更高效地寻找附近粒子
  const cellSize = maxDistance;
  const gridWidth = Math.ceil(width / cellSize);
  const gridHeight = Math.ceil(height / cellSize);
  const grid: Particle[][] = new Array(gridWidth * gridHeight).fill(null).map(() => []);
  
  // 将粒子放入网格
  for (let i = 0; i < particles.length; i++) {
    const p = particles[i];
    if (p.x >= 0 && p.x < width && p.y >= 0 && p.y < height) {
      const cellX = Math.floor(p.x / cellSize);
      const cellY = Math.floor(p.y / cellSize);
      const cellIndex = cellY * gridWidth + cellX;
      if (grid[cellIndex]) {
        grid[cellIndex].push(p);
      }
    }
  }
  
  // 连接附近网格中的粒子
  for (let i = 0; i < particles.length; i++) {
    const p1 = particles[i];
      
    // 跳过视窗外的粒子
    if (p1.x < -100 || p1.x > width + 100 || p1.y < -100 || p1.y > height + 100) {
      continue;
    }
    
    const cellX = Math.floor(p1.x / cellSize);
    const cellY = Math.floor(p1.y / cellSize);
    
    // 检查周围的网格
    let connectionsCount = 0; // 限制每个粒子的连接数量
    const maxConnections = 3; // 每个粒子最多连接3个其他粒子
    
    for (let nx = Math.max(0, cellX - 1); nx <= Math.min(gridWidth - 1, cellX + 1); nx++) {
      for (let ny = Math.max(0, cellY - 1); ny <= Math.min(gridHeight - 1, cellY + 1); ny++) {
        const neighborIndex = ny * gridWidth + nx;
        if (!grid[neighborIndex]) continue;
        
        // 检查该网格中的所有粒子
        for (let j = 0; j < grid[neighborIndex].length; j++) {
          const p2 = grid[neighborIndex][j];
          if (p1 === p2) continue; // 不与自己连接
          
          if (connectionsCount < maxConnections) {
            // 只连接一部分粒子，减少密度
            if (drawLineIfClose(p1, p2, maxDistanceSq)) {
              connectionsCount++;
      }
          } else {
            break; // 达到最大连接数，停止寻找
        }
      }
        
        if (connectionsCount >= maxConnections) break;
      }
      
      if (connectionsCount >= maxConnections) break;
    }
  }
}

// 绘制粒子之间的连线
function drawLineIfClose(p1: Particle, p2: Particle, maxDistanceSq: number): boolean {
  if (!ctx) return false;
  
  const dx = p1.x - p2.x;
  const dy = p1.y - p2.y;
  const distSq = dx * dx + dy * dy;
  
  if (distSq < maxDistanceSq) {
    const distance = Math.sqrt(distSq);
    const maxDistance = Math.sqrt(maxDistanceSq);
    
    // 使用二次曲线，增强流动感
    const midX = (p1.x + p2.x) / 2;
    const midY = (p1.y + p2.y) / 2;
    
    // 适度的弯曲和动画效果
    const curveOffset = Math.sin(Date.now() * 0.0005 + p1.angle * 0.05) * 5;
    const ctrlX = midX + curveOffset * Math.sin(p1.angle);
    const ctrlY = midY + curveOffset * Math.cos(p2.angle);
    
    ctx.beginPath();
    ctx.moveTo(p1.x, p1.y);
    
    // 使用二次曲线增加流动感
    ctx.quadraticCurveTo(ctrlX, ctrlY, p2.x, p2.y);
    
    // 更美观的线条透明度和颜色过渡
    const opacity = (1 - distance / maxDistance) * 0.15;
    
    // 为特殊大粒子增强连线效果
    let specialBoost = 1.0;
    if ((p1.glowing && p1.size > 3) || (p2.glowing && p2.size > 3)) {
      specialBoost = 1.4; // 增强特殊粒子的连线效果
    }
    
    // 颜色渐变融合
    const gradient = ctx.createLinearGradient(
      p1.x, p1.y, 
      p2.x, p2.y
    );
    
    // 更丰富的渐变效果
    gradient.addColorStop(0, p1.color.replace(/[^,]+(?=\))/, (opacity * specialBoost).toString()));
    gradient.addColorStop(0.5, `rgba(180, 200, 255, ${opacity * 0.8 * specialBoost})`); // 中间点添加淡蓝色
    gradient.addColorStop(1, p2.color.replace(/[^,]+(?=\))/, (opacity * specialBoost).toString()));
    
    ctx.strokeStyle = gradient;
    // 调整线条宽度
    ctx.lineWidth = Math.max(0.1, 0.9 - distance / maxDistance) * specialBoost;
    ctx.stroke();
    
    return true;
  }
  
  return false;
}

// 处理鼠标移动
function handleMouseMove(e: MouseEvent) {
  if (!canvas.value) return;
  
  const rect = canvas.value.getBoundingClientRect();
  const containerX = e.clientX - rect.left;
  const containerY = e.clientY - rect.top;
  
  // 只有当鼠标在容器内时才更新鼠标位置
  if (containerX >= 0 && containerX <= rect.width && 
      containerY >= 0 && containerY <= rect.height) {
    mouseX = containerX;
    mouseY = containerY;
    lastMouseMoveTime = Date.now(); // 更新最后鼠标移动时间
  }
}

// 处理触摸移动（移动设备支持）
function handleTouchMove(e: TouchEvent) {
  if (!canvas.value || !e.touches[0]) return;
  
  const rect = canvas.value.getBoundingClientRect();
  mouseX = e.touches[0].clientX - rect.left;
  mouseY = e.touches[0].clientY - rect.top;
  
  // 阻止页面滚动
  e.preventDefault();
}

// 调整画布大小
function resizeCanvas() {
  if (!canvas.value || !ctx) return;
  
  // 获取容器大小而不是窗口大小
  const container = canvas.value.parentElement;
  if (container) {
    canvas.value.width = container.clientWidth;
    canvas.value.height = container.clientHeight;
    
    // 调整鼠标位置为容器中心
    mouseX = container.clientWidth / 2;
    mouseY = container.clientHeight / 2;
    
    initParticles();
  }
}

onMounted(() => {
  if (canvas.value) {
    ctx = canvas.value.getContext('2d');
    
    // 设置延迟以确保容器尺寸已经渲染
    setTimeout(() => {
      // 设置画布尺寸
      resizeCanvas();
      
      // 初始化最后鼠标移动时间
      lastMouseMoveTime = Date.now();
      
      // 添加事件监听器
      window.addEventListener('mousemove', handleMouseMove);
      window.addEventListener('touchmove', handleTouchMove, { passive: false });
      window.addEventListener('resize', resizeCanvas);
      
      // 开始动画
      animationId = requestAnimationFrame(animate);
    }, 100);
  }
});

onUnmounted(() => {
  if (animationId !== null) {
    cancelAnimationFrame(animationId);
  }
  
  // 清除周期性变换定时器
  if (patternCycleInterval !== null) {
    clearInterval(patternCycleInterval);
    patternCycleInterval = null;
  }
  
  window.removeEventListener('mousemove', handleMouseMove);
  window.removeEventListener('touchmove', handleTouchMove);
  window.removeEventListener('resize', resizeCanvas);
});
</script>

<style scoped>
.particle-whirlpool {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  border-radius: 20px; /* 匹配容器的圆角 */
}

.whirlpool-canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at center, #1e2456 0%, #121220 50%, #07070f 100%);
}

/* 漂浮的IP标志 */
.floating-ip {
  position: absolute;
  bottom: 30px;
  right: 30px;
  transform: scale(0.4);
  z-index: 1;
  animation: floatEffect 8s ease-in-out infinite;
  pointer-events: none; /* 确保不会阻止点击事件 */
}

.ip-badge {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #4a67cf 0%, #7289da 100%);
  border-radius: 50%;
  color: white;
  font-size: 24px;
  font-weight: bold;
  letter-spacing: -1px;
  text-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
  box-shadow: 
    0 5px 15px rgba(74, 103, 207, 0.6),
    0 0 30px rgba(114, 137, 218, 0.6),
    inset 0 1px 2px rgba(255, 255, 255, 0.4);
  position: relative;
  z-index: 2;
  animation: pulseEffect 5s ease-in-out infinite;
}

.glow-circle {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 90px;
  height: 90px;
  border-radius: 50%;
  background: transparent;
  z-index: 1;
  animation: glowPulse 5s ease-in-out infinite alternate;
  box-shadow: 
    0 0 40px rgba(140, 232, 255, 0.5),
    0 0 80px rgba(74, 103, 207, 0.6),
    0 0 120px rgba(114, 137, 218, 0.4);
}

@keyframes floatEffect {
  0%, 100% {
    transform: scale(0.4) translateY(0);
  }
  50% {
    transform: scale(0.4) translateY(-6px);
  }
}

@keyframes pulseEffect {
  0%, 100% {
    transform: scale(1);
    box-shadow: 
      0 5px 15px rgba(74, 103, 207, 0.5),
      0 0 25px rgba(114, 137, 218, 0.5),
      inset 0 1px 2px rgba(255, 255, 255, 0.4);
  }
  50% {
    transform: scale(1.05);
    box-shadow: 
      0 8px 20px rgba(74, 103, 207, 0.6),
      0 0 40px rgba(114, 137, 218, 0.6),
      inset 0 1px 3px rgba(255, 255, 255, 0.6);
  }
}

@keyframes glowPulse {
  0% {
    box-shadow: 
      0 0 40px rgba(140, 232, 255, 0.4),
      0 0 80px rgba(74, 103, 207, 0.5),
      0 0 120px rgba(114, 137, 218, 0.3);
  }
  100% {
    box-shadow: 
      0 0 60px rgba(140, 232, 255, 0.5),
      0 0 100px rgba(74, 103, 207, 0.6),
      0 0 140px rgba(114, 137, 218, 0.4);
  }
}
</style> 