<template>
  <div class="work-type-container">
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
            <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="512" height="512" viewBox="0 0 512 512" id="shape">
  <linearGradient id="a" x1="326.734" x2="638.355" y1="440.959" y2="620.873" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#a)" d="M302.238 92.404c-88.402-44.56-180.924 36.402-225.484 124.803-44.561 88.404-24.287 150.768 64.116 195.33 88.4 44.56 261.78 11.203 306.343-77.201 44.559-88.4-56.577-198.374-144.975-242.932zM426.12 328.247c-39.45 78.262-192.938 107.791-271.2 68.342-78.262-39.447-96.209-94.66-56.761-172.92 39.45-78.261 121.358-149.935 199.621-110.485 78.257 39.448 167.788 136.803 128.34 215.063z" opacity=".1"></path>
  <linearGradient id="b" x1="327.577" x2="639.198" y1="439.496" y2="619.41" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#b)" d="M297.781 113.183C219.518 73.734 137.61 145.408 98.16 223.669c-39.449 78.26-21.501 133.473 56.761 172.92 78.262 39.449 231.75 9.92 271.2-68.342 39.447-78.26-50.084-175.615-128.34-215.064zM415.94 325.789c-35.591 70.611-174.07 97.252-244.678 61.66-70.607-35.591-86.798-85.4-51.207-156.011 35.591-70.607 109.484-135.273 180.095-99.68 70.606 35.59 151.379 123.425 115.79 194.031z" opacity=".2"></path>
  <linearGradient id="c" x1="346.503" x2="622.375" y1="450.423" y2="609.697" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#c)" d="M297.781 113.183C219.518 73.734 137.61 145.408 98.16 223.669c-39.449 78.26-21.501 133.473 56.761 172.92 78.262 39.449 231.75 9.92 271.2-68.342 39.447-78.26-50.084-175.615-128.34-215.064zM415.94 325.789c-35.591 70.611-174.07 97.252-244.678 61.66-70.607-35.591-86.798-85.4-51.207-156.011 35.591-70.607 109.484-135.273 180.095-99.68 70.606 35.59 151.379 123.425 115.79 194.031z" opacity=".2"></path>
  <linearGradient id="d" x1="329.82" x2="641.441" y1="435.612" y2="615.527" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#d)" d="M300.15 131.759c-70.61-35.593-144.504 29.072-180.095 99.68-35.591 70.61-19.4 120.42 51.207 156.011 70.607 35.592 209.087 8.951 244.678-61.66 35.589-70.607-45.184-158.442-115.79-194.031zm101.882 183.988c-31.66 62.808-154.842 86.509-217.651 54.849-62.809-31.659-77.212-75.967-45.551-138.778 31.659-62.808 97.392-120.329 160.2-88.67 62.807 31.659 134.663 109.793 103.002 172.599z" opacity=".1"></path>
  <linearGradient id="e" x1="348.745" x2="624.618" y1="446.538" y2="605.813" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#e)" d="M300.15 131.759c-70.61-35.593-144.504 29.072-180.095 99.68-35.591 70.61-19.4 120.42 51.207 156.011 70.607 35.592 209.087 8.951 244.678-61.66 35.589-70.607-45.184-158.442-115.79-194.031zm101.882 183.988c-31.66 62.808-154.842 86.509-217.651 54.849-62.809-31.659-77.212-75.967-45.551-138.778 31.659-62.808 97.392-120.329 160.2-88.67 62.807 31.659 134.663 109.793 103.002 172.599z" opacity=".2"></path>
  <linearGradient id="f" x1="367.849" x2="616.743" y1="457.567" y2="601.266" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#f)" d="M300.15 131.759c-70.61-35.593-144.504 29.072-180.095 99.68-35.591 70.61-19.4 120.42 51.207 156.011 70.607 35.592 209.087 8.951 244.678-61.66 35.589-70.607-45.184-158.442-115.79-194.031zm101.882 183.988c-31.66 62.808-154.842 86.509-217.651 54.849-62.809-31.659-77.212-75.967-45.551-138.778 31.659-62.808 97.392-120.329 160.2-88.67 62.807 31.659 134.663 109.793 103.002 172.599z" opacity=".3"></path>
  <linearGradient id="g" x1="332.694" x2="644.315" y1="430.634" y2="610.548" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#g)" d="M299.031 143.148c-62.808-31.659-128.541 25.862-160.2 88.67-31.661 62.811-17.258 107.119 45.551 138.778 62.809 31.66 185.991 7.959 217.651-54.849 31.66-62.806-40.196-140.94-103.002-172.599zm72.1 161.009c-25.909 51.401-126.712 70.793-178.111 44.885-51.402-25.91-63.188-62.169-37.278-113.569 25.908-51.397 79.698-98.472 131.101-72.563 51.398 25.908 110.195 89.847 84.288 141.247z" opacity=".1"></path>
  <linearGradient id="h" x1="351.619" x2="627.492" y1="441.559" y2="600.834" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#h)" d="M299.031 143.148c-62.808-31.659-128.541 25.862-160.2 88.67-31.661 62.811-17.258 107.119 45.551 138.778 62.809 31.66 185.991 7.959 217.651-54.849 31.66-62.806-40.196-140.94-103.002-172.599zm72.1 161.009c-25.909 51.401-126.712 70.793-178.111 44.885-51.402-25.91-63.188-62.169-37.278-113.569 25.908-51.397 79.698-98.472 131.101-72.563 51.398 25.908 110.195 89.847 84.288 141.247z" opacity=".2"></path>
  <linearGradient id="i" x1="370.724" x2="619.618" y1="452.589" y2="596.288" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#i)" d="M299.031 143.148c-62.808-31.659-128.541 25.862-160.2 88.67-31.661 62.811-17.258 107.119 45.551 138.778 62.809 31.66 185.991 7.959 217.651-54.849 31.66-62.806-40.196-140.94-103.002-172.599zm72.1 161.009c-25.909 51.401-126.712 70.793-178.111 44.885-51.402-25.91-63.188-62.169-37.278-113.569 25.908-51.397 79.698-98.472 131.101-72.563 51.398 25.908 110.195 89.847 84.288 141.247z" opacity=".3"></path>
  <linearGradient id="j" x1="383.053" x2="604.454" y1="459.707" y2="587.533" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#j)" d="M299.031 143.148c-62.808-31.659-128.541 25.862-160.2 88.67-31.661 62.811-17.258 107.119 45.551 138.778 62.809 31.66 185.991 7.959 217.651-54.849 31.66-62.806-40.196-140.94-103.002-172.599zm72.1 161.009c-25.909 51.401-126.712 70.793-178.111 44.885-51.402-25.91-63.188-62.169-37.278-113.569 25.908-51.397 79.698-98.472 131.101-72.563 51.398 25.908 110.195 89.847 84.288 141.247z" opacity=".4"></path>
  <linearGradient id="k" x1="397.264" x2="578.448" y1="470.356" y2="574.963" gradientTransform="rotate(26.747 906.814 -97.155)" gradientUnits="userSpaceOnUse">
    <stop offset="0" stop-color="#86177B"></stop>
    <stop offset=".151" stop-color="#782682"></stop>
    <stop offset=".44" stop-color="#544D93"></stop>
    <stop offset=".834" stop-color="#1A8BAE"></stop>
    <stop offset="1" stop-color="#00A7BB"></stop>
  </linearGradient>
  <path fill="url(#k)" d="M286.843 162.909c-51.403-25.908-105.193 21.166-131.101 72.563-25.911 51.4-14.124 87.659 37.278 113.569 51.399 25.908 152.202 6.517 178.111-44.885 25.907-51.399-32.89-115.338-84.288-141.247z" opacity=".5"></path>
</svg>
          </div>
          <h2>新IP <span class="type-label">新作品</span></h2>
          <p class="work-description">注册原创图片、视频或文字作品</p>
        </div>
      </div>
    </div>

    <!-- 提示信息区域 -->
    <div class="aetrix-shell-card">
      <div class="shell-card-content">
        <div class="icon-container">
          <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 38 38" viewBox="0 0 38 38" id="sundial-shell" class="shell-icon">
            <g>
              <path d="M10.8906298,16.6699638c0.1044922,0.0891113,0.2484741,0.1174316,0.380249,0.0791016
              c1.2148581-0.3565998,2.4272718-0.338377,3.6473389-0.0578613c0.3364258,0.0773926,0.618042-0.2595215,0.4747314-0.5734863
              c-1.5217752-3.3329363-0.9549208-6.7291822,0.967103-9.2373047c0.2365112-0.3083496-0.0452881-0.7451172-0.423768-0.65625
              c-2.5698853,0.6018066-4.9645386,1.8105464-7.0070801,3.5317378C8.8629808,9.8115654,8.8145189,9.8867607,8.7926073,9.9707451
              C8.117485,12.5485582,8.9994078,15.0564451,10.8906298,16.6699638z"></path>
              <path d="M17.4740658 17.6482353c.0305786.0388184.067749.0703125.1102295.095459.2692261.159668.5380859.3432617.8041382.5480957.2696533.2077637.65802.0136719.6634521-.3266602.0724888-4.5760145 3.2936726-8.7333832 8.2959595-9.4521484.3972778-.0571289.4992676-.5854487.1460571-.7758784-2.6187572-1.4128151-5.5223484-2.0963259-8.668335-1.9279785-.0040283.0029297-.0056763.0078125-.0098267.0109863C15.0416956 8.6533403 14.3923273 13.732192 17.4740658 17.6482353zM6.5830131 20.0559502c.1740112.0427246.3588257-.027832.4525757-.1806641.5979004-.9733887 1.4526362-1.7932129 2.4998164-2.3925781.2380981-.1362305.2859497-.4533691.0980835-.6530762-1.2042217-1.2815676-1.9572396-2.8977451-2.0384517-4.7595215-.0165405-.3781738-.4847412-.5437012-.7306519-.2561035-1.4429932 1.689455-2.5293946 3.5534029-3.2019043 5.7463379C3.6287894 17.670208 3.6405692 17.79179 3.699224 17.890667 4.3291068 18.9526787 5.3802543 19.76054 6.5830131 20.0559502z"></path>
              <path d="M20.2776546 20.1721611c.0118408.0500488.0338745.0976563.0629272.1398926.1676025.2446289.3169556.4902344.4506226.7348633.1626587.2980957.5968628.2880859.7386475-.0202637 2.1029701-4.5731773 7.2556992-7.5911942 12.2791119-5.0039063.3323364.1711426.7026367-.1420898.5875854-.4978027-.7705498-2.3839216-2.302639-4.4041262-4.208128-5.984375-.0635986-.0527344-.1416016-.0859375-.223877-.0935059C23.1897297 8.817318 18.9433079 14.5557308 20.2776546 20.1721611zM19.5623226 28.1628838c2.2815609-4.2698593-1.055624-10.1628418-6.2929697-10.1628418-2.3060303 0-4.3012085 1.215332-5.2072144 3.1723633-.8524165 1.842041-.6308589 3.5605469.6591797 5.107666 1.1400604 1.3683624 2.6582212 1.6436577 4.3421021 1.1838379 1.3158569-.3586426 2.3121338-1.5751953 2.4221802-2.9575195.1708412-2.1323795-1.414382-3.441925-2.913269-3.4472656-1.0592651-.003418-2.258728.6809082-2.5592651 1.7219238-.3285065 1.1389198.5915108 2.2198849 1.5200806 2.2922363.6315918.0490723 1.3112183-.3652344 1.6802368-1.0500488.199646-.3703613.7736206-.2263184.7763672.1945801.0079937 1.2274494-1.0769587 2.0522118-2.2731323 2.0698242-1.5994825.0228691-2.9553814-1.7104626-2.8018188-3.4108887.1702127-1.884552 2.1374989-3.4155102 3.9815674-3.3015137 2.6768084.1676846 4.9237471 3.0535049 3.8623056 6.1791992-.0637817.1877441.0142212.3925781.1863403.4912109.7918091.4523926 1.4506226 1.1289063 1.8969727 1.9248047C18.9988461 28.4499931 19.4111996 28.4455986 19.5623226 28.1628838z"></path>
              <path d="M16.476141 27.1145439c-.1760254-.1018066-.4006958-.0539551-.5267344.1057129-1.0825939 1.3713036-2.7613878 2.0420914-4.4307861 1.9448242-.2471924-.0148926-.4564819.1875-.4393311.4345703.0502758.7271233-.0706873 1.4263325-.2891235 1.973877-.1005859.2526855.0498047.5385742.3193359.574707 2.5927715.3490906 5.4074583-.6889896 7.1034555-2.2536621.1158447-.1069336.1561279-.2729492.1114502-.4240723C18.0348568 28.4900322 17.3607845 27.6260185 16.476141 27.1145439zM3.8426566 26.2341728c1.0951762.3810253 2.0773039-.19557 2.4609985-1.1015625.034668-.0817871.0346069-.1738281.0107422-.2595215-.2875366-1.032959-.3157349-2.1237793-.0485229-3.1875.0198364-.0791016.041687-.1569824.0651855-.234375.0678711-.2236328-.055603-.4560547-.2789307-.5246582-.8241577-.2531738-1.5825195-.6992188-2.2099609-1.2873535-.2443237-.2287598-.6464844-.0883789-.6936646.2431641-.2548187 1.790657-.2412791 4.2664165.4365234 6.1020508C3.6283622 26.1018486 3.7246146 26.1929131 3.8426566 26.2341728zM21.7349911 23.3972588c-.0306835.1199951-.0009212.1899109.0195923.2902832.1713867.840332 1.1107178 1.2514648 1.8389893.7983398 3.0013733-1.8665733 6.2998714-2.4595051 9.4412212-1.9619141.9255981.1462402 1.776123-.5209961 1.8812256-1.4521484.09552-.8461914.1307983-1.8642578.0162354-2.9753418-.0114746-.1113281-.0671997-.2141113-.1553955-.282959C29.5166397 13.7095585 23.2874775 17.3459473 21.7349911 23.3972588zM7.1031547 26.6370049c-.1395874-.2229004-.4462891-.2541504-.6378174-.0739746-.5475349.5147114-1.2106442.7888184-1.9627686.7888184-.0950928 0-.1886597-.0187988-.2832642-.0280762 1.0100098 1.7436523 2.7727661 3.4719238 4.9952998 4.3317871.1942139.0751953.4141235 0 .5177612-.1806641.3351393-.5832691.4812298-1.4987411.2772827-2.3879395-.0307007-.1337891-.1338501-.2373047-.2623291-.2856445-.8961182-.3371582-1.6834717-.8916016-2.2584834-1.6164551C7.3483939 27.0078545 7.2207694 26.824749 7.1031547 26.6370049z"></path>
            </g>
          </svg>
        </div>
        <div class="content">
          <h3 class="title">获取AETRIX贝</h3>
          <p class="description">需要一定数量的A贝用于存储您珍贵的记录与价值的信息</p>
      </div>
        <div class="action-button" @click="openPaymentModal">
          <span class="button-text">立即获取</span>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="arrow-icon">
            <path d="M5 12h14"></path>
            <path d="m12 5 7 7-7 7"></path>
          </svg>
      </div>
      </div>
    </div>

    <!-- 底部导航按钮 -->
    <NavigationButtons 
      :next-disabled="!selectedWorkType" 
      @back="goBack" 
      @next="goNext" 
    />
    
    <!-- 支付二维码弹窗 -->
    <PaymentQRModal 
      :show="showPaymentModal" 
      @close="showPaymentModal = false"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import NavigationButtons from '../common/NavigationButtons.vue';
import PaymentQRModal from '../modals/PaymentQRModal.vue';

const emit = defineEmits(['navigate-back', 'navigate-next']);

// 支付弹窗状态
const showPaymentModal = ref(false);

const selectedWorkType = ref('');

const selectWorkType = (type: string) => {
  selectedWorkType.value = type;
};

// 打开支付二维码弹窗
const openPaymentModal = () => {
  showPaymentModal.value = true;
};

const goBack = () => {
  emit('navigate-back');
};

const goNext = () => {
  if (selectedWorkType.value) {
    emit('navigate-next', selectedWorkType.value);
  }
};
</script>

<style scoped>
.work-type-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
}

.header {
  text-align: center;
  margin-bottom: 40px;
}

.title-with-subtitle {
  font-size: 32px;
  margin-bottom: 8px;
  color: #ffffff;
}

.subtitle-zh {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
}

.work-type-options {
  display: flex;
  justify-content: center;
  gap: 30px;
  margin-bottom: 40px;
  width: 100%;
}

.work-type-card {
  flex: 1;
  max-width: 400px;
  min-width: 280px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 24px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.work-type-card:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-5px);
}

.work-type-card.selected {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
}

.work-type-content {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.work-type-icon {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
  font-size: 24px;
}

.new-icon {
  background: transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 120px;
  height: 120px;
  border-radius: 0;
  overflow: visible;
}

.new-icon svg {
  width: 100%;
  height: 100%;
  color: transparent;
}

.remix-icon {
  background: transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 120px;
  height: 120px;
  border-radius: 0;
  overflow: visible;
}

.remix-icon svg {
  width: 100%;
  height: 100%;
  color: transparent;
}

.icon-symbol {
  color: white;
}

.work-type-card h2 {
  font-size: 24px;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  color: white;
}

.type-label {
  font-size: 12px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 4px 8px;
  margin-left: 8px;
  color: rgba(255, 255, 255, 0.9);
}

.work-description {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.5;
}

.aetrix-shell-card {
  position: relative;
  width: 100%;
  max-width: 600px;
  margin-bottom: 40px;
  border-radius: 16px;
  background: rgba(15, 15, 30, 0.6);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  transition: all 0.3s ease;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.aetrix-shell-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.3), 
              0 0 20px rgba(156, 39, 176, 0.2),
              0 0 30px rgba(63, 81, 181, 0.1);
  border-color: rgba(156, 39, 176, 0.3);
}

.aetrix-shell-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent, #9c27b0, #673ab7, #3f51b5, #2196f3, #03a9f4, transparent);
  background-size: 200% 100%;
  animation: glowingBorder 2s linear infinite;
  transform: translateX(-100%);
  transition: transform 0.8s ease;
}

@keyframes glowingBorder {
  0% { background-position: 200% 0; }
  100% { background-position: 0 0; }
}

.aetrix-shell-card:hover::before {
  transform: translateX(0);
  animation: glowingBorderHover 1.5s linear infinite;
}

@keyframes glowingBorderHover {
  0% { background-position: 0 0; }
  100% { background-position: 200% 0; }
}

.shell-card-content {
  display: flex;
  align-items: center;
  padding: 20px 24px;
}

.icon-container {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #9c27b0, #673ab7, #3f51b5, #2196f3, #03a9f4);
  background-size: 300% 300%;
  animation: gradientFlow 8s ease infinite;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20px;
  box-shadow: 0 0 15px rgba(156, 39, 176, 0.4);
}

@keyframes gradientFlow {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.shell-icon {
  width: 28px;
  height: 28px;
  fill: #000000;
}

.content {
  flex: 1;
}

.title {
  font-size: 20px;
  font-weight: 600;
  margin-bottom: 6px;
  color: white;
  letter-spacing: 0.02em;
}

.description {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.5;
}

.action-button {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #9c27b0, #673ab7, #3f51b5, #2196f3, #03a9f4);
  background-size: 300% 300%;
  animation: gradientFlow 8s ease infinite;
  padding: 12px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #fff;
  font-weight: 500;
  margin-left: 16px;
  box-shadow: 0 4px 12px rgba(156, 39, 176, 0.3);
}

.action-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(156, 39, 176, 0.4),
              0 0 20px rgba(63, 81, 181, 0.2);
  background-size: 200% 200%;
}

.button-text {
  margin-right: 8px;
  font-size: 15px;
}

.arrow-icon {
  width: 20px;
  height: 20px;
  transition: transform 0.2s ease;
}

.action-button:hover .arrow-icon {
  transform: translateX(3px);
}

.info-icon {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #ffcc33, #ffaa00);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
}

.info-icon svg {
  width: 24px;
  height: 24px;
  fill: #ffffff;
}

.info-text {
  flex: 1;
}

.info-text h3 {
  font-size: 18px;
  margin-bottom: 4px;
  color: white;
}

.info-text p {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.info-arrow {
  margin-left: 16px;
  color: rgba(255, 255, 255, 0.5);
}
</style> 