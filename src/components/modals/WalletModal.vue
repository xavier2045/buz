<template>
  <div class="wallet-modal-wrapper" :class="{ 'is-visible': show }">
    <div class="wallet-modal-backdrop" @click="close"></div>
    <div class="wallet-modal">
      <div class="wallet-modal-header">
        <button class="back-button" @click="close">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M19 12H5"></path>
            <path d="M12 19l-7-7 7-7"></path>
          </svg>
        </button>
        <h2 class="wallet-title">我的A貝</h2>
      </div>

      <div class="wallet-content">
        <div class="wallet-balance-card">
          <div class="coin-icon">
            <img src="/images/coin-money.png" alt="A貝" class="coin-image">
            <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 38 38" viewBox="0 0 38 38" class="overlay-svg">
              <g>
                <path d="M10.8906298,16.6699638c0.1044922,0.0891113,0.2484741,0.1174316,0.380249,0.0791016 c1.2148581-0.3565998,2.4272718-0.338377,3.6473389-0.0578613c0.3364258,0.0773926,0.618042-0.2595215,0.4747314-0.5734863 c-1.5217752-3.3329363-0.9549208-6.7291822,0.967103-9.2373047c0.2365112-0.3083496-0.0452881-0.7451172-0.423768-0.65625 c-2.5698853,0.6018066-4.9645386,1.8105464-7.0070801,3.5317378C8.8629808,9.8115654,8.8145189,9.8867607,8.7926073,9.9707451 C8.117485,12.5485582,8.9994078,15.0564451,10.8906298,16.6699638z"></path>
                <path d="M17.4740658 17.6482353c.0305786.0388184.067749.0703125.1102295.095459.2692261.159668.5380859.3432617.8041382.5480957.2696533.2077637.65802.0136719.6634521-.3266602.0724888-4.5760145 3.2936726-8.7333832 8.2959595-9.4521484.3972778-.0571289.4992676-.5854487.1460571-.7758784-2.6187572-1.4128151-5.5223484-2.0963259-8.668335-1.9279785-.0040283.0029297-.0056763.0078125-.0098267.0109863C15.0416956 8.6533403 14.3923273 13.732192 17.4740658 17.6482353zM6.5830131 20.0559502c.1740112.0427246.3588257-.027832.4525757-.1806641.5979004-.9733887 1.4526362-1.7932129 2.4998164-2.3925781.2380981-.1362305.2859497-.4533691.0980835-.6530762-1.2042217-1.2815676-1.9572396-2.8977451-2.0384517-4.7595215-.0165405-.3781738-.4847412-.5437012-.7306519-.2561035-1.4429932 1.689455-2.5293946 3.5534029-3.2019043 5.7463379C3.6287894 17.670208 3.6405692 17.79179 3.699224 17.890667 4.3291068 18.9526787 5.3802543 19.76054 6.5830131 20.0559502z"></path>
                <path d="M20.2776546 20.1721611c.0118408.0500488.0338745.0976563.0629272.1398926.1676025.2446289.3169556.4902344.4506226.7348633.1626587.2980957.5968628.2880859.7386475-.0202637 2.1029701-4.5731773 7.2556992-7.5911942 12.2791119-5.0039063.3323364.1711426.7026367-.1420898.5875854-.4978027-.7705498-2.3839216-2.302639-4.4041262-4.208128-5.984375-.0635986-.0527344-.1416016-.0859375-.223877-.0935059C23.1897297 8.817318 18.9433079 14.5557308 20.2776546 20.1721611zM19.5623226 28.1628838c2.2815609-4.2698593-1.055624-10.1628418-6.2929697-10.1628418-2.3060303 0-4.3012085 1.215332-5.2072144 3.1723633-.8524165 1.842041-.6308589 3.5605469.6591797 5.107666 1.1400604 1.3683624 2.6582212 1.6436577 4.3421021 1.1838379 1.3158569-.3586426 2.3121338-1.5751953 2.4221802-2.9575195.1708412-2.1323795-1.414382-3.441925-2.913269-3.4472656-1.0592651-.003418-2.258728.6809082-2.5592651 1.7219238-.3285065 1.1389198.5915108 2.2198849 1.5200806 2.2922363.6315918.0490723 1.3112183-.3652344 1.6802368-1.0500488.199646-.3703613.7736206-.2263184.7763672.1945801.0079937 1.2274494-1.0769587 2.0522118-2.2731323 2.0698242-1.5994825.0228691-2.9553814-1.7104626-2.8018188-3.4108887.1702127-1.884552 2.1374989-3.4155102 3.9815674-3.3015137 2.6768084.1676846 4.9237471 3.0535049 3.8623056 6.1791992-.0637817.1877441.0142212.3925781.1863403.4912109.7918091.4523926 1.4506226 1.1289063 1.8969727 1.9248047C18.9988461 28.4499931 19.4111996 28.4455986 19.5623226 28.1628838z"></path>
                <path d="M16.476141 27.1145439c-.1760254-.1018066-.4006958-.0539551-.5267344.1057129-1.0825939 1.3713036-2.7613878 2.0420914-4.4307861 1.9448242-.2471924-.0148926-.4564819.1875-.4393311.4345703.0502758.7271233-.0706873 1.4263325-.2891235 1.973877-.1005859.2526855.0498047.5385742.3193359.574707 2.5927715.3490906 5.4074583-.6889896 7.1034555-2.2536621.1158447-.1069336.1561279-.2729492.1114502-.4240723C18.0348568 28.4900322 17.3607845 27.6260185 16.476141 27.1145439zM3.8426566 26.2341728c1.0951762.3810253 2.0773039-.19557 2.4609985-1.1015625.034668-.0817871.0346069-.1738281.0107422-.2595215-.2875366-1.032959-.3157349-2.1237793-.0485229-3.1875.0198364-.0791016.041687-.1569824.0651855-.234375.0678711-.2236328-.055603-.4560547-.2789307-.5246582-.8241577-.2531738-1.5825195-.6992188-2.2099609-1.2873535-.2443237-.2287598-.6464844-.0883789-.6936646.2431641-.2548187 1.790657-.2412791 4.2664165.4365234 6.1020508C3.6283622 26.1018486 3.7246146 26.1929131 3.8426566 26.2341728zM21.7349911 23.3972588c-.0306835.1199951-.0009212.1899109.0195923.2902832.1713867.840332 1.1107178 1.2514648 1.8389893.7983398 3.0013733-1.8665733 6.2998714-2.4595051 9.4412212-1.9619141.9255981.1462402 1.776123-.5209961 1.8812256-1.4521484.09552-.8461914.1307983-1.8642578.0162354-2.9753418-.0114746-.1113281-.0671997-.2141113-.1553955-.282959C29.5166397 13.7095585 23.2874775 17.3459473 21.7349911 23.3972588zM7.1031547 26.6370049c-.1395874-.2229004-.4462891-.2541504-.6378174-.0739746-.5475349-.5147114-1.2106442.7888184-1.9627686.7888184-.0950928 0-.1886597-.0187988-.2832642-.0280762 1.0100098 1.7436523 2.7727661 3.4719238 4.9952998 4.3317871.1942139.0751953.4141235 0 .5177612-.1806641.3351393-.5832691.4812298-1.4987411.2772827-2.3879395-.0307007-.1337891-.1338501-.2373047-.2623291-.2856445-.8961182-.3371582-1.6834717-.8916016-2.2584834-1.6164551C7.3483939 27.0078545 7.2207694 26.824749 7.1031547 26.6370049z"></path>
              </g>
            </svg>
          </div>
          <div class="balance-display">
            <div class="balance-label">当前余额</div>
            <div class="balance-value">0</div>
          </div>
        </div>

        <div class="wallet-section">
          <div class="section-header">
            <div class="section-title">
              <h3>A貝充值</h3>
              <div class="section-subtitle">充值比例：1A貝 = 1元人民币</div>
            </div>
            <div class="recharge-history">
              充值记录
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 18l6-6-6-6"></path>
              </svg>
            </div>
          </div>

          <div class="recharge-options">
            <div class="recharge-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === '1' }"
                 @click="selectOption('1', '1')">
              <div class="amount">1<span>A貝</span></div>
              <div class="price">￥1</div>
            </div>
            <div class="recharge-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === '5' }"
                 @click="selectOption('5', '5')">
              <div class="amount">5<span>A貝</span></div>
              <div class="price">￥5</div>
            </div>
            <div class="recharge-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === '10' }"
                 @click="selectOption('10', '10')">
              <div class="amount">10<span>A貝</span></div>
              <div class="price">￥10</div>
            </div>
            <div class="recharge-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === '30' }"
                 @click="selectOption('30', '30')">
              <div class="amount">30<span>A貝</span></div>
              <div class="price">￥30</div>
            </div>
            <div class="recharge-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === '50' }"
                 @click="selectOption('50', '50')">
              <div class="amount">50<span>A貝</span></div>
              <div class="price">￥50</div>
            </div>
            <div class="recharge-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === '100' }"
                 @click="selectOption('100', '100')">
              <div class="amount">100<span>A貝</span></div>
              <div class="price">￥100</div>
            </div>
            <div class="recharge-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === '300' }"
                 @click="selectOption('300', '300')">
              <div class="amount">300<span>A貝</span></div>
              <div class="price">￥300</div>
            </div>
            <div class="recharge-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === '500' }"
                 @click="selectOption('500', '500')">
              <div class="amount">500<span>A貝</span></div>
              <div class="price">￥500</div>
            </div>
            <div class="recharge-option custom-option" 
                 :class="{ 'active': selectedOption && selectedOption.amount === 'custom' }"
                 @click="selectOption('custom', 'custom')">
              <div class="custom-content">
                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="custom-icon">
                  <path d="M12 20h9"></path>
                  <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                </svg>
                <span class="custom-label">自定义</span>
              </div>
            </div>
          </div>
        </div>

        <div class="agreement-section">
          <label class="agreement-checkbox">
            <input type="checkbox" v-model="agreedToTerms">
            <span class="checkmark"></span>
            <span class="agreement-text">充值则表示您同意
              <a href="javascript:void(0);" @click.prevent="showAgreementModal = true" class="agreement-link">《A貝服务协议》</a>
              <a href="javascript:void(0);" @click.prevent="showRefundModal = true" class="agreement-link">《未成年人退款申请》</a>
            </span>
          </label>
        </div>

        <button 
          class="recharge-button" 
          :class="{ disabled: !selectedOption || !agreedToTerms }"
          @click="openPaymentModal"
          :disabled="!selectedOption || !agreedToTerms"
        >
          立即充值 ￥{{ selectedOption ? selectedOption.price : '1' }}
        </button>
      </div>

      <!-- Custom Amount Dialog -->
      <div class="custom-amount-dialog" v-if="showCustomAmountDialog">
        <div class="dialog-backdrop" @click="cancelCustomAmount"></div>
        <div class="dialog-content">
          <div class="dialog-header">
            <h3>自定义充值金额</h3>
            <button class="close-button" @click="cancelCustomAmount">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
          <div class="dialog-body">
            <div class="input-group">
              <label for="customAmountInput">充值金额（元）</label>
              <div class="amount-input-wrapper">
                <span class="currency-symbol">￥</span>
                <input 
                  type="number" 
                  id="customAmountInput" 
                  v-model="customAmountInput"
                  placeholder="1-10000"
                  min="1"
                  max="10000"
                  @keyup.enter="confirmCustomAmount"
                />
              </div>
              <div class="input-hint">充值金额范围：1-10000元</div>
              <div class="error-message" v-if="customAmountError">{{ customAmountError }}</div>
            </div>
          </div>
          <div class="dialog-footer">
            <button class="cancel-button" @click="cancelCustomAmount">取消</button>
            <button class="confirm-button" @click="confirmCustomAmount">确认</button>
          </div>
        </div>
      </div>

      <!-- A贝服务协议弹框 -->
      <div class="agreement-modal" v-if="showAgreementModal">
        <div class="modal-backdrop" @click="showAgreementModal = false"></div>
        <div class="agreement-content compact-modal glow-effect">
          <div class="agreement-header">
            <button class="back-button" @click="showAgreementModal = false">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 12H5"></path>
                <path d="M12 19l-7-7 7-7"></path>
              </svg>
            </button>
            <h3>A贝服务协议</h3>
            <div style="width: 16px;"></div> <!-- 占位以保持标题居中 -->
          </div>
          <div class="agreement-body no-padding custom-scrollbar">
            <div class="iframe-wrapper dark-scrollbar">
              <iframe src="/pdf/A贝服务协议2.pdf#zoom=page-fit&scrollbar=0&toolbar=0&navpanes=0&pagemode=none" width="100%" height="100%" frameborder="0" style="background-color: #222;"></iframe>
              <div class="scrollbar-mask"></div>
              <div class="scrollbar-mask-left"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- 未成年人退款申请弹框 -->
      <div class="agreement-modal" v-if="showRefundModal">
        <div class="modal-backdrop" @click="showRefundModal = false"></div>
        <div class="agreement-content compact-modal glow-effect">
          <div class="agreement-header">
            <button class="back-button" @click="showRefundModal = false">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 12H5"></path>
                <path d="M12 19l-7-7 7-7"></path>
              </svg>
            </button>
            <h3>未成年人退款申请</h3>
            <div style="width: 16px;"></div> <!-- 占位以保持标题居中 -->
          </div>
          <div class="agreement-body no-padding custom-scrollbar">
            <div class="iframe-wrapper dark-scrollbar">
              <iframe src="/pdf/未成年人退款申请.pdf#zoom=page-fit&scrollbar=0&toolbar=0&navpanes=0&pagemode=none" width="100%" height="100%" frameborder="0" style="background-color: #222;"></iframe>
              <div class="scrollbar-mask"></div>
              <div class="scrollbar-mask-left"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits } from 'vue';

interface RechargeOption {
  amount: string;
  price: string;
}

const props = defineProps({
  show: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['close', 'open-payment']);

const selectedOption = ref<RechargeOption | null>({
  amount: '1',
  price: '1'
});
const agreedToTerms = ref(false);

// 协议弹框状态
const showAgreementModal = ref(false);
const showRefundModal = ref(false);

// Custom amount dialog state
const showCustomAmountDialog = ref(false);
const customAmountInput = ref('');
const customAmountError = ref('');

const selectOption = (amount: string, price: string) => {
  if (amount === 'custom' && price === 'custom') {
    promptCustomAmount();
    return;
  }
  
  selectedOption.value = {
    amount,
    price
  };
};

const promptCustomAmount = () => {
  // Reset state
  customAmountInput.value = '';
  customAmountError.value = '';
  // Show dialog
  showCustomAmountDialog.value = true;
};

const cancelCustomAmount = () => {
  showCustomAmountDialog.value = false;
};

const confirmCustomAmount = () => {
  const amount = parseInt(customAmountInput.value);
  
  if (!customAmountInput.value.trim()) {
    customAmountError.value = '请输入充值金额';
    return;
  }
  
  if (isNaN(amount)) {
    customAmountError.value = '请输入有效的数字金额';
    return;
  }
  
  if (amount < 1) {
    customAmountError.value = '充值金额不能小于1元';
    return;
  }
  
  if (amount > 10000) {
    customAmountError.value = '充值金额不能超过10000元';
    return;
  }
  
  selectedOption.value = {
    amount: amount.toString(),
    price: amount.toString()
  };
  
  // Close dialog
  showCustomAmountDialog.value = false;
};

const close = () => {
  emit('close');
};

const openPaymentModal = () => {
  if (selectedOption.value && agreedToTerms.value) {
    emit('open-payment', selectedOption.value);
  }
};
</script>

<style scoped>
.wallet-modal-wrapper {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.3s ease, visibility 0.3s ease;
}

.wallet-modal-wrapper.is-visible {
  opacity: 1;
  visibility: visible;
}

.wallet-modal-backdrop {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.75);
  backdrop-filter: blur(5px);
}

.wallet-modal {
  position: relative;
  width: 80%;
  max-width: 300px;
  max-height: 90vh;
  overflow-y: auto;
  background: linear-gradient(71deg, #080509, #1a171c, #080509);
  border-radius: 24px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
  animation: modalFadeIn 0.3s ease;
  display: flex;
  flex-direction: column;
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.05);
  background-clip: padding-box;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.wallet-modal-header {
  display: flex;
  align-items: center;
  padding: 16px 20px 12px 20px;
  position: relative;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  margin-bottom: 5px;
}

.back-button {
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 5px;
  border-radius: 50%;
  position: absolute;
  left: 20px;
  z-index: 10;
}

.back-button:hover {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}

.wallet-title {
  flex: 1;
  text-align: center;
  font-size: 18px;
  margin: 0;
  font-weight: 600;
  color: white;
  letter-spacing: -0.02em;
  line-height: 24px;
}

.wallet-content {
  padding: 0 20px 20px 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.wallet-balance-card {
  background-color: rgba(30, 30, 30, 0.3);
  border-radius: 18px;
  padding: 16px;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  gap: 14px;
  position: relative;
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  overflow: hidden;
}

.wallet-balance-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom right, rgba(255, 215, 0, 0.1), transparent);
  z-index: 0;
  pointer-events: none;
}

.coin-icon {
  position: relative;
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 5;
}

.coin-image {
  width: 100%;
  height: auto;
  filter: drop-shadow(0 0 15px rgba(255, 215, 0, 0.4));
}

.overlay-svg {
  position: absolute;
  width: 45%;
  height: 45%;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  fill: white;
  filter: drop-shadow(0 0 4px rgba(255, 215, 0, 0.7));
  animation: glow-svg 2s ease-in-out infinite alternate;
}

@keyframes glow-svg {
  from {
    filter: drop-shadow(0 0 2px rgba(255, 255, 255, 0.7));
  }
  to {
    filter: drop-shadow(0 0 6px rgba(255, 215, 0, 0.9));
  }
}

.balance-display {
  display: flex;
  flex-direction: column;
  z-index: 5;
}

.balance-label {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 2px;
  font-weight: 500;
}

.balance-value {
  font-size: 28px;
  font-weight: 700;
  color: white;
  line-height: 1;
}

.wallet-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 5px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 2px;
}

.section-title {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.section-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: white;
  letter-spacing: -0.02em;
}

.section-subtitle {
  font-size: 11px;
  color: rgba(255, 215, 0, 0.8);
  font-weight: 500;
}

.recharge-history {
  display: flex;
  align-items: center;
  gap: 2px;
  font-size: 12px;
  color: hsla(0, 0%, 100%, 0.6);
  cursor: pointer;
  font-weight: 500;
  padding: 3px 6px;
  border-radius: 10px;
  transition: all 0.2s ease;
}

.recharge-history:hover {
  color: white;
  background-color: rgba(255, 255, 255, 0.1);
}

.recharge-options {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  margin-top: -2px;
}

.recharge-option {
  background-color: rgba(30, 30, 30, 0.5);
  border-radius: 12px;
  padding: 10px 6px 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.25s ease;
  border: 1px solid rgba(255, 255, 255, 0.08);
  min-height: 60px;
  position: relative;
  overflow: hidden;
}

.recharge-option::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(to right, transparent, rgba(255, 215, 0, 0.5), transparent);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.recharge-option:hover {
  background-color: rgba(50, 50, 50, 0.5);
  transform: translateY(-2px);
  border-color: rgba(255, 255, 255, 0.15);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.recharge-option:hover::after {
  opacity: 1;
}

.recharge-option.active {
  background-color: rgba(175, 162, 32, 0.15);
  border: 1px solid rgba(255, 215, 0, 0.5);
  box-shadow: 0 0 15px rgba(255, 215, 0, 0.25);
  transform: translateY(-1px);
}

.recharge-option.active::after {
  opacity: 1;
  background: linear-gradient(to right, transparent, rgba(255, 215, 0, 0.8), transparent);
  height: 3px;
}

.recharge-option.active .amount {
  color: #ffcd00;
}

.recharge-option.active .price {
  color: rgba(255, 255, 255, 0.9);
}

.amount {
  font-size: 16px;
  font-weight: 700;
  color: white;
  display: flex;
  align-items: center;
  gap: 1px;
  margin-bottom: 4px;
}

.amount span {
  font-size: 11px;
  font-weight: 500;
  margin-left: 1px;
  opacity: 0.8;
}

.price {
  font-size: 13px;
  color: rgba(255, 215, 0, 0.8);
  font-weight: 600;
}

.agreement-section {
  margin-top: 8px;
}

.agreement-checkbox {
  display: flex;
  align-items: flex-start;
  position: relative;
  cursor: pointer;
  font-size: 11px;
  user-select: none;
  padding: 2px 0;
}

.agreement-checkbox input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  height: 0;
  width: 0;
}

.checkmark {
  position: relative;
  height: 16px;
  width: 16px;
  background-color: rgba(30, 30, 30, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  margin-right: 8px;
  flex-shrink: 0;
  margin-top: 1px;
  transition: all 0.2s ease;
}

.agreement-checkbox input:checked ~ .checkmark {
  background-color: #ffcd00;
  border-color: #ffcd00;
}

.agreement-checkbox input:checked ~ .checkmark:after {
  content: "";
  position: absolute;
  display: block;
  left: 5px;
  top: 2px;
  width: 3px;
  height: 7px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.agreement-text {
  color: hsla(0, 0%, 100%, 0.6);
  font-size: 11px;
  font-weight: 500;
  line-height: 16px;
}

.agreement-link {
  color: #ffcd00;
  text-decoration: none;
  transition: all 0.2s ease;
}

.agreement-link:hover {
  text-decoration: underline;
}

.recharge-button {
  margin-top: 14px;
  width: 100%;
  padding: 12px;
  background: linear-gradient(to right, #d4af37, #ffcc33, #d4af37);
  border: none;
  border-radius: 16px;
  color: #000;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s ease;
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.3);
  letter-spacing: 0.5px;
}

.recharge-button:hover:not(.disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(212, 175, 55, 0.5);
  filter: brightness(1.05);
}

.recharge-button.disabled {
  background: linear-gradient(to right, #333, #444, #333);
  color: rgba(255, 255, 255, 0.5);
  cursor: not-allowed;
  box-shadow: none;
}

.custom-option {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.1));
  border: 1px dashed rgba(255, 255, 255, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
}

.custom-option.active {
  border-style: solid;
}

.custom-content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 3px;
}

.custom-icon {
  color: rgba(255, 215, 0, 0.8);
  flex-shrink: 0;
  margin-top: 1px;
}

.custom-label {
  font-size: 14px;
  font-weight: 600;
  color: white;
  letter-spacing: 0.5px;
}

.custom-price {
  display: none;
}

@media (max-width: 480px) {
  .wallet-modal {
    width: 92%;
    max-width: 340px;
    border-radius: 24px;
  }
  
  .wallet-modal-header {
    padding: 20px 20px 10px 20px;
  }
  
  .wallet-content {
    padding: 0 20px 24px 20px;
    gap: 18px;
  }
  
  .back-button {
    left: 15px;
  }

  .wallet-title {
    font-size: 20px;
    line-height: 28px;
  }
  
  .recharge-options {
    grid-template-columns: repeat(3, 1fr);
    gap: 6px;
  }
  
  .section-header h3 {
    font-size: 17px;
  }
  
  .balance-value {
    font-size: 32px;
  }
  
  .amount {
    font-size: 16px;
  }
}

/* Custom Amount Dialog Styles */
.custom-amount-dialog {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1100;
}

.dialog-backdrop {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.75);
  backdrop-filter: blur(5px);
}

.dialog-content {
  position: relative;
  width: 85%;
  max-width: 320px;
  background: linear-gradient(71deg, #080509, #1a171c, #080509);
  border-radius: 18px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.6);
  display: flex;
  flex-direction: column;
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.1);
  animation: dialogFadeIn 0.25s ease;
  z-index: 1101;
}

@keyframes dialogFadeIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.dialog-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 16px 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.dialog-header h3 {
  margin: 0;
  font-size: 17px;
  font-weight: 600;
  color: white;
}

.close-button {
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 5px;
  border-radius: 50%;
}

.close-button:hover {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}

.dialog-body {
  padding: 20px 16px;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.input-group label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
}

.amount-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.currency-symbol {
  position: absolute;
  left: 12px;
  font-size: 16px;
  color: #ffcd00;
  font-weight: 600;
}

.input-group input {
  width: 100%;
  padding: 12px 12px 12px 30px;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  background-color: rgba(30, 30, 30, 0.5);
  color: white;
  font-size: 16px;
  outline: none;
  transition: all 0.2s ease;
  font-weight: 600;
}

.input-group input:focus {
  border-color: rgba(255, 215, 0, 0.6);
  box-shadow: 0 0 0 2px rgba(255, 215, 0, 0.1);
}

.input-hint {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin-top: 2px;
}

.error-message {
  font-size: 13px;
  color: #ff6b6b;
  margin-top: 6px;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 12px 16px 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.cancel-button {
  padding: 10px 16px;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  background-color: rgba(30, 30, 30, 0.5);
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.cancel-button:hover {
  background-color: rgba(50, 50, 50, 0.5);
}

.confirm-button {
  padding: 10px 20px;
  border-radius: 12px;
  border: none;
  background: linear-gradient(to right, #d4af37, #ffcc33, #d4af37);
  color: #000;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.confirm-button:hover {
  filter: brightness(1.05);
  transform: translateY(-1px);
}

/* 协议弹框样式 */
.agreement-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1200;
  padding: 20px;
}

.compact-modal {
  width: 8%;
  max-width: 60px;
  height: 80vh;
  max-height: 700px;
  border-radius: 12px;
  margin: 0 auto;
}

.modal-backdrop {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(5px);
}

.fullscreen-modal .agreement-content {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  max-width: 100%;
  border-radius: 0;
  animation: fullscreenFadeIn 0.2s ease;
}

@keyframes fullscreenFadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.glow-effect {
  position: relative;
  border: 1px solid rgba(255, 215, 0, 0.8);
  box-shadow: 0 0 30px rgba(255, 215, 0, 0.4), 
              0 0 50px rgba(255, 215, 0, 0.3),
              inset 0 0 10px rgba(255, 215, 0, 0.2);
  overflow: hidden;
  background-color: #222;
  animation: pulse-glow 3s ease-in-out infinite alternate;
  z-index: 1202;
}

.glow-effect::before {
  content: "";
  position: absolute;
  top: -3px;
  left: -3px;
  right: -3px;
  bottom: -3px;
  z-index: -1;
  background: linear-gradient(45deg, 
    rgba(255, 215, 0, 0.1) 0%,
    rgba(255, 215, 0, 0.4) 50%, 
    rgba(255, 215, 0, 0.1) 100%);
  background-size: 200% 200%;
  animation: shimmer 3s linear infinite;
  pointer-events: none;
  border-radius: 15px;
}

@keyframes shimmer {
  0% {
    background-position: 0% 0%;
  }
  100% {
    background-position: 200% 200%;
  }
}

@keyframes pulse-glow {
  0% {
    box-shadow: 0 0 30px rgba(255, 215, 0, 0.4), 
                0 0 50px rgba(255, 215, 0, 0.3),
                inset 0 0 10px rgba(255, 215, 0, 0.2);
  }
  50% {
    box-shadow: 0 0 40px rgba(255, 215, 0, 0.6), 
                0 0 70px rgba(255, 215, 0, 0.5),
                inset 0 0 20px rgba(255, 215, 0, 0.3);
  }
  100% {
    box-shadow: 0 0 30px rgba(255, 215, 0, 0.4), 
                0 0 50px rgba(255, 215, 0, 0.3),
                inset 0 0 10px rgba(255, 215, 0, 0.2);
  }
}

.agreement-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 8px;
  background: linear-gradient(to right, #1a171c, #282830, #1a171c);
  border-bottom: 1px solid rgba(255, 215, 0, 0.25);
  position: relative;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.15);
}

.agreement-header h3 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: rgba(255, 215, 0, 0.9);
  text-align: center;
  flex: 1;
  text-shadow: 0 0 8px rgba(255, 215, 0, 0.4), 0 1px 2px rgba(0, 0, 0, 0.5);
  letter-spacing: 0.5px;
}

.agreement-header .back-button {
  padding: 3px;
}

.agreement-header .back-button svg {
  width: 16px;
  height: 16px;
}

.agreement-body {
  flex: 1;
  overflow: hidden;
  background-color: #222;
  position: relative;
  padding: 0;
  margin: 0;
}

.iframe-wrapper {
  width: 100%;
  height: 100%;
  overflow: auto;
  background-color: #222;
  position: relative;
  scrollbar-width: thin;
  scrollbar-color: rgba(70, 70, 75, 0.6) rgba(40, 40, 45, 0.3);
}

.dark-scrollbar::-webkit-scrollbar {
  width: 5px;
  height: 5px;
}

.dark-scrollbar::-webkit-scrollbar-track {
  background: rgba(40, 40, 45, 0.3);
  border-radius: 10px;
}

.dark-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(70, 70, 75, 0.6);
  border-radius: 10px;
}

.dark-scrollbar::-webkit-scrollbar-thumb:hover {
  background: rgba(90, 90, 95, 0.8);
}

.iframe-wrapper iframe {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
  background-color: #222;
}

.scrollbar-mask {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 20px;
  background-color: #222;
  opacity: 1;
  z-index: 100;
  pointer-events: none;
}

.agreement-body.no-padding {
  padding: 0;
  margin: 0;
  background-color: #222;
  border-top: none;
  overflow: hidden;
}

.agreement-content {
  position: relative;
  width: 80%;
  max-width: 780px;
  height: 85vh;
  max-height: 800px;
  background: #222;
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.6);
  display: flex;
  flex-direction: column;
  z-index: 1201;
  animation: agreementFadeIn 0.25s ease;
  overflow: hidden;
  margin: 0 auto;
}

@keyframes agreementFadeIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.scrollbar-mask-left {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  width: 20px;
  background-color: #222;
  opacity: 1;
  z-index: 100;
  pointer-events: none;
}

.agreement-content.glow-effect {
  position: relative;
}

.agreement-content.glow-effect::after {
  content: "";
  position: absolute;
  top: -5px;
  left: -5px;
  right: -5px;
  bottom: -5px;
  border-radius: 16px;
  background: transparent;
  border: 2px solid rgba(255, 215, 0, 0.3);
  box-shadow: 0 0 50px rgba(255, 215, 0, 0.6), 
              0 0 100px rgba(255, 215, 0, 0.4);
  z-index: -2;
  animation: outer-glow 4s ease-in-out infinite alternate;
  pointer-events: none;
}

@keyframes outer-glow {
  0% {
    border-color: rgba(255, 215, 0, 0.3);
    box-shadow: 0 0 50px rgba(255, 215, 0, 0.6), 
                0 0 100px rgba(255, 215, 0, 0.4);
  }
  100% {
    border-color: rgba(255, 215, 0, 0.5);
    box-shadow: 0 0 70px rgba(255, 215, 0, 0.8), 
                0 0 130px rgba(255, 215, 0, 0.6);
  }
}
</style> 