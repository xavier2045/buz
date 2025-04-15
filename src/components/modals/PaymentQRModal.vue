<template>
  <div class="payment-modal" v-if="show">
    <div class="modal-content">
      <div class="modal-header">
        <!-- 贝壳图标放在标题左边 -->
        <div class="sundial-icon">
          <div class="coin-image-container">
            <img src="/images/coin-money.png" alt="金币" class="coin-image">
            <svg xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 38 38" viewBox="0 0 38 38" id="sundial-shell" class="overlay-svg">
              <g>
                <path d="M10.8906298,16.6699638c0.1044922,0.0891113,0.2484741,0.1174316,0.380249,0.0791016 c1.2148581-0.3565998,2.4272718-0.338377,3.6473389-0.0578613c0.3364258,0.0773926,0.618042-0.2595215,0.4747314-0.5734863 c-1.5217752-3.3329363-0.9549208-6.7291822,0.967103-9.2373047c0.2365112-0.3083496-0.0452881-0.7451172-0.423768-0.65625 c-2.5698853,0.6018066-4.9645386,1.8105464-7.0070801,3.5317378C8.8629808,9.8115654,8.8145189,9.8867607,8.7926073,9.9707451 C8.117485,12.5485582,8.9994078,15.0564451,10.8906298,16.6699638z"></path>
                <path d="M17.4740658 17.6482353c.0305786.0388184.067749.0703125.1102295.095459.2692261.159668.5380859.3432617.8041382.5480957.2696533.2077637.65802.0136719.6634521-.3266602.0724888-4.5760145 3.2936726-8.7333832 8.2959595-9.4521484.3972778-.0571289.4992676-.5854487.1460571-.7758784-2.6187572-1.4128151-5.5223484-2.0963259-8.668335-1.9279785-.0040283.0029297-.0056763.0078125-.0098267.0109863C15.0416956 8.6533403 14.3923273 13.732192 17.4740658 17.6482353zM6.5830131 20.0559502c.1740112.0427246.3588257-.027832.4525757-.1806641.5979004-.9733887 1.4526362-1.7932129 2.4998164-2.3925781.2380981-.1362305.2859497-.4533691.0980835-.6530762-1.2042217-1.2815676-1.9572396-2.8977451-2.0384517-4.7595215-.0165405-.3781738-.4847412-.5437012-.7306519-.2561035-1.4429932 1.689455-2.5293946 3.5534029-3.2019043 5.7463379C3.6287894 17.670208 3.6405692 17.79179 3.699224 17.890667 4.3291068 18.9526787 5.3802543 19.76054 6.5830131 20.0559502z"></path>
                <path d="M20.2776546 20.1721611c.0118408.0500488.0338745.0976563.0629272.1398926.1676025.2446289.3169556.4902344.4506226.7348633.1626587.2980957.5968628.2880859.7386475-.0202637 2.1029701-4.5731773 7.2556992-7.5911942 12.2791119-5.0039063.3323364.1711426.7026367-.1420898.5875854-.4978027-.7705498-2.3839216-2.302639-4.4041262-4.208128-5.984375-.0635986-.0527344-.1416016-.0859375-.223877-.0935059C23.1897297 8.817318 18.9433079 14.5557308 20.2776546 20.1721611zM19.5623226 28.1628838c2.2815609-4.2698593-1.055624-10.1628418-6.2929697-10.1628418-2.3060303 0-4.3012085 1.215332-5.2072144 3.1723633-.8524165 1.842041-.6308589 3.5605469.6591797 5.107666 1.1400604 1.3683624 2.6582212 1.6436577 4.3421021 1.1838379 1.3158569-.3586426 2.3121338-1.5751953 2.4221802-2.9575195.1708412-2.1323795-1.414382-3.441925-2.913269-3.4472656-1.0592651-.003418-2.258728.6809082-2.5592651 1.7219238-.3285065 1.1389198.5915108 2.2198849 1.5200806 2.2922363.6315918.0490723 1.3112183-.3652344 1.6802368-1.0500488.199646-.3703613.7736206-.2263184.7763672.1945801.0079937 1.2274494-1.0769587 2.0522118-2.2731323 2.0698242-1.5994825.0228691-2.9553814-1.7104626-2.8018188-3.4108887.1702127-1.884552 2.1374989-3.4155102 3.9815674-3.3015137 2.6768084.1676846 4.9237471 3.0535049 3.8623056 6.1791992-.0637817.1877441.0142212.3925781.1863403.4912109.7918091.4523926 1.4506226 1.1289063 1.8969727 1.9248047C18.9988461 28.4499931 19.4111996 28.4455986 19.5623226 28.1628838z"></path>
                <path d="M16.476141 27.1145439c-.1760254-.1018066-.4006958-.0539551-.5267344.1057129-1.0825939 1.3713036-2.7613878 2.0420914-4.4307861 1.9448242-.2471924-.0148926-.4564819.1875-.4393311.4345703.0502758.7271233-.0706873 1.4263325-.2891235 1.973877-.1005859.2526855.0498047.5385742.3193359.574707 2.5927715.3490906 5.4074583-.6889896 7.1034555-2.2536621.1158447-.1069336.1561279-.2729492.1114502-.4240723C18.0348568 28.4900322 17.3607845 27.6260185 16.476141 27.1145439zM3.8426566 26.2341728c1.0951762.3810253 2.0773039-.19557 2.4609985-1.1015625.034668-.0817871.0346069-.1738281.0107422-.2595215-.2875366-1.032959-.3157349-2.1237793-.0485229-3.1875.0198364-.0791016.041687-.1569824.0651855-.234375.0678711-.2236328-.055603-.4560547-.2789307-.5246582-.8241577-.2531738-1.5825195-.6992188-2.2099609-1.2873535-.2443237-.2287598-.6464844-.0883789-.6936646.2431641-.2548187 1.790657-.2412791 4.2664165.4365234 6.1020508C3.6283622 26.1018486 3.7246146 26.1929131 3.8426566 26.2341728zM21.7349911 23.3972588c-.0306835.1199951-.0009212.1899109.0195923.2902832.1713867.840332 1.1107178 1.2514648 1.8389893.7983398 3.0013733-1.8665733 6.2998714-2.4595051 9.4412212-1.9619141.9255981.1462402 1.776123-.5209961 1.8812256-1.4521484.09552-.8461914.1307983-1.8642578.0162354-2.9753418-.0114746-.1113281-.0671997-.2141113-.1553955-.282959C29.5166397 13.7095585 23.2874775 17.3459473 21.7349911 23.3972588zM7.1031547 26.6370049c-.1395874-.2229004-.4462891-.2541504-.6378174-.0739746-.5475349.5147114-1.2106442.7888184-1.9627686.7888184-.0950928 0-.1886597-.0187988-.2832642-.0280762 1.0100098 1.7436523 2.7727661 3.4719238 4.9952998 4.3317871.1942139.0751953.4141235 0 .5177612-.1806641.3351393-.5832691.4812298-1.4987411.2772827-2.3879395-.0307007-.1337891-.1338501-.2373047-.2623291-.2856445-.8961182-.3371582-1.6834717-.8916016-2.2584834-1.6164551C7.3483939 27.0078545 7.2207694 26.824749 7.1031547 26.6370049z"></path>
              </g>
            </svg>
          </div>
        </div>
        <h2>{{ currentTab === 'alipay' ? '支付宝充值' : '微信充值' }}</h2>
        <button class="close-button" @click="onClose">×</button>
      </div>
      
      <!-- 支付方式选择 -->
      <div class="payment-tabs">
        <div 
          class="payment-tab" 
          :class="{ 'active': currentTab === 'alipay' }"
          @click="currentTab = 'alipay'"
        >
          <div class="tab-icon alipay-icon"></div>
          <span>支付宝</span>
        </div>
        <div 
          class="payment-tab" 
          :class="{ 'active': currentTab === 'wechat' }"
          @click="currentTab = 'wechat'"
        >
          <div class="tab-icon wechat-icon"></div>
          <span>微信支付</span>
        </div>
      </div>
      
      <!-- 付款金额 -->
      <div class="payment-amount">
        <div class="amount-label">支付金额</div>
        <div class="amount-value">{{ paymentAmount }} <span>元</span></div>
      </div>
      
      <!-- 支付信息和二维码 -->
      <div class="payment-content">
        <!-- 支付宝内容 -->
        <div v-if="currentTab === 'alipay'" class="qr-section">
          <div class="qr-container alipay">
            <div class="liquid-bubble bubble-1"></div>
            <div class="liquid-bubble bubble-2"></div>
            <div class="liquid-bubble bubble-3"></div>
            <div class="qr-header">
              <div class="alipay-logo">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="none" viewBox="0 0 256 256" id="alipay">
                  <rect width="224" height="224" x="16" y="16" fill="#EEE" rx="70"></rect>
                  <path fill="#1677FF" d="M91.3823 136.405C89.7398 137.662 88.0973 139.497 87.6142 141.913C86.9379 145.101 87.5176 149.159 90.5127 152.348C94.2808 156.116 99.9813 157.178 102.493 157.372C109.16 157.855 116.31 154.473 121.72 150.802C123.846 149.352 127.421 146.357 130.899 141.719C123.17 137.758 113.508 133.314 103.266 133.7C97.8557 133.893 94.0876 134.956 91.3823 136.405ZM189.353 154.087C192.735 146.067 194.667 137.275 194.667 128C194.667 91.2847 164.716 61.333 128.001 61.333C91.2857 61.333 61.334 91.2847 61.334 128C61.334 164.715 91.2857 194.666 128.001 194.666C150.223 194.666 169.836 183.748 182.01 167.033C170.513 161.43 151.672 151.961 139.981 146.357C134.474 152.734 126.262 159.014 116.986 161.719C111.189 163.459 105.875 164.135 100.464 162.976C94.9572 161.816 90.9958 159.304 88.677 156.792C87.5176 155.439 86.1649 153.893 85.1021 151.864C85.1987 151.961 85.1987 152.154 85.1987 152.251C85.1987 152.251 84.619 151.285 84.2325 149.739C84.0393 148.966 83.8461 148.193 83.7494 147.42C83.6528 146.84 83.6528 146.261 83.7494 145.777C83.6528 144.811 83.7494 143.748 83.9427 142.686C84.5224 139.98 85.5852 136.985 88.5804 134.183C94.9572 127.903 103.556 127.613 108.001 127.613C114.571 127.71 125.972 130.512 135.634 133.99C138.339 128.29 140.078 122.299 141.141 118.145H101.044V113.797H121.624V105.101H96.7929V100.657H121.624V91.961C121.624 90.8016 121.914 89.8354 123.749 89.8354H133.508V100.657H160.464V105.005H133.508V113.7H155.054C155.054 113.7 152.832 125.777 146.165 137.662C161.141 142.976 182.3 151.285 189.353 154.087Z"></path>
                </svg>
              </div>
              <div class="alipay-text">支付宝</div>
            </div>
            <div class="qr-code">
              <!-- 支付宝二维码 -->
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" id="qr-code-alipay" class="qr-svg" fill="#000000">
                <path d="M9 9H2V2H9zM3 8H8V3H3zM30 9H23V2h7zM24 8h5V3H24zM9 30H2V23H9zM3 29H8V24H3z"></path>
                <rect width="3" height="3" x="4" y="4"></rect>
                <rect width="3" height="3" x="25" y="4"></rect>
                <rect width="3" height="3" x="4" y="25"></rect>
                <rect width="1" height="1" x="10" y="4"></rect>
                <rect width="1" height="1" x="11" y="5"></rect>
                <rect width="1" height="1" x="12" y="6"></rect>
                <rect width="1" height="1" x="13" y="7"></rect>
                <rect width="1" height="1" x="12" y="7"></rect>
                <rect width="1" height="1" x="13" y="17"></rect>
                <rect width="1" height="1" x="24.71" y="18.32" transform="rotate(-45 25.214 18.816)"></rect>
                <rect width="1" height="1" x="27.54" y="18.32" transform="rotate(-45 28.043 18.814)"></rect>
                <rect width="1" height="1" x="28.95" y="18.32" transform="rotate(-45 29.455 18.82)"></rect>
                <rect width="1" height="1" x="23.71" y="28.32" transform="rotate(-45 24.209 28.822)"></rect>
                <rect width="1" height="1" x="25.12" y="28.32" transform="rotate(-45 25.626 28.815)"></rect>
                <rect width="1" height="1" x="26.54" y="28.32" transform="rotate(-45 27.038 28.82)"></rect>
                <rect width="1" height="1" x="27.95" y="28.32" transform="rotate(-45 28.455 28.814)"></rect>
                <rect width="1" height="1" x="8" y="10"></rect>
                <rect width="1" height="1" x="9" y="11"></rect>
                <rect width="1" height="1" x="10" y="12"></rect>
                <rect width="1" height="1" x="11" y="13"></rect>
                <rect width="1" height="1" x="10" y="14"></rect>
                <rect width="1" height="1" x="9" y="15"></rect>
                <rect width="1" height="1" x="8" y="16"></rect>
                <rect width="1" height="1" x="21" y="26" transform="rotate(90 21.5 26.5)"></rect>
                <rect width="1" height="1" x="20" y="27" transform="rotate(90 20.5 27.5)"></rect>
                <rect width="1" height="1" x="19" y="28" transform="rotate(90 19.5 28.5)"></rect>
                <rect width="1" height="1" x="18" y="29" transform="rotate(90 18.5 29.5)"></rect>
                <rect width="1" height="1" x="21" y="6" transform="rotate(90 21.5 6.5)"></rect>
                <rect width="1" height="1" x="19" y="14" transform="rotate(90 19.5 14.5)"></rect>
                <rect width="1" height="1" x="19" y="18" transform="rotate(90 19.5 18.5)"></rect>
                <rect width="1" height="1" x="21" y="24" transform="rotate(90 21.5 24.5)"></rect>
                <rect width="1" height="1" x="20" y="24" transform="rotate(90 20.5 24.5)"></rect>
                <rect width="1" height="1" x="20" y="7" transform="rotate(90 20.5 7.5)"></rect>
                <rect width="1.5" height="1" x="18.75" y="4.75" transform="rotate(90 19.5 5.25)"></rect>
                <rect width="1.5" height="1" x="17.75" y="6.25" transform="rotate(90 18.5 6.75)"></rect>
                <rect width="1.5" height="1" x="27" y="21" transform="rotate(-180 27.75 21.5)"></rect>
                <rect width="1.5" height="1" x="25.5" y="20" transform="rotate(-180 26.25 20.5)"></rect>
                <rect width="1" height="1" x="19" y="8" transform="rotate(90 19.5 8.5)"></rect>
                <rect width="1" height="1" x="18" y="9" transform="rotate(90 18.5 9.5)"></rect>
                <rect width="1" height="1" x="17" y="28" transform="rotate(90 17.5 28.5)"></rect>
                <rect width="1" height="1" x="16" y="27" transform="rotate(90 16.5 27.5)"></rect>
                <rect width="1" height="1" x="15" y="26" transform="rotate(90 15.5 26.5)"></rect>
                <rect width="1" height="1" x="11" y="19"></rect>
                <rect width="1" height="1" x="12" y="20"></rect>
                <rect width="1" height="1" x="11" y="21"></rect>
                <rect width="1" height="1" x="12" y="22"></rect>
                <rect width="1" height="1" x="11" y="23"></rect>
                <rect width="1" height="1" x="12" y="24"></rect>
                <rect width="1" height="1" x="13" y="25"></rect>
                <rect width="1" height="1" x="10" y="26"></rect>
                <rect width="1" height="1" x="11" y="25"></rect>
                <rect width="1" height="1" x="22" y="12" transform="rotate(-90 22.5 12.5)"></rect>
                <rect width="1" height="1" x="23" y="11" transform="rotate(-90 23.5 11.5)"></rect>
                <rect width="1" height="1" x="24" y="12" transform="rotate(-90 24.5 12.5)"></rect>
                <rect width="1" height="1" x="25" y="11" transform="rotate(-90 25.5 11.5)"></rect>
                <rect width="1" height="1" x="26" y="12" transform="rotate(-90 26.5 12.5)"></rect>
                <rect width="1" height="1" x="27" y="11" transform="rotate(-90 27.5 11.5)"></rect>
                <rect width="1" height="1" x="28" y="10" transform="rotate(-90 28.5 10.5)"></rect>
                <rect width="2" height="2" x="13" y="2"></rect>
                <rect width="2" height="2" x="12" y="15"></rect>
                <rect width="2" height="2" x="8" y="18"></rect>
                <rect width="1" height="1" x="10" y="23"></rect>
                <rect width="2" height="2" x="9" y="21"></rect>
                <rect width="2" height="2" x="23" y="15"></rect>
                <rect width="2" height="2" x="25" y="14"></rect>
                <rect width="2" height="2" x="22" y="16"></rect>
                <rect width="2" height="2" x="16" y="9"></rect>
                <rect width="2" height="2" x="18" y="8"></rect>
                <rect width="2" height="2" x="15" y="10"></rect>
                <rect width="1.2" height="1.2" x="20.6" y="9.4"></rect>
                <rect width="1.2" height="1.2" x="21.8" y="8.8"></rect>
                <rect width="1.2" height="1.2" x="20" y="10"></rect>
                <rect width="2" height="2" x="19" y="2"></rect>
                <rect width="1" height="2" x="29" y="12"></rect>
                <rect width="1" height="2" x="2" y="17"></rect>
                <rect width="2" height="2" x="22" y="19"></rect>
                <rect width="2" height="2" x="2" y="11"></rect>
                <rect width="2" height="2" x="3" y="12"></rect>
                <rect width="2" height="2" x="4" y="10"></rect>
                <rect width="2" height="2" x="6" y="11"></rect>
                <rect width="2" height="2" x="6" y="14"></rect>
                <rect width="2" height="2" x="10" y="28"></rect>
                <rect width="1" height="4" x="13" y="9"></rect>
                <rect width="1" height="4" x="10" y="6"></rect>
                <rect width="1" height="4" x="11" y="8"></rect>
                <rect width="1" height="4" x="15" y="13"></rect>
                <rect width="1" height="4" x="9" y="11"></rect>
                <rect width="1" height="1" x="26" y="12"></rect>
                <rect width="1" height="1" x="27" y="13"></rect>
                <rect width="1" height="1" x="28" y="14"></rect>
                <rect width="1" height="1" x="29" y="15"></rect>
                <rect width="1" height="1" x="29" y="24"></rect>
                <rect width="1" height="1" x="28" y="16"></rect>
                <rect width="1" height="1" x="27" y="17"></rect>
                <rect width="1" height="1" x="26" y="18"></rect>
                <rect width="1" height="4" x="27" y="13"></rect>
                <rect width="1" height="1" x="2" y="21" transform="rotate(-90 2.5 21.5)"></rect>
                <rect width="1" height="1" x="3" y="20" transform="rotate(-90 3.5 20.5)"></rect>
                <rect width="1" height="1" x="4" y="19" transform="rotate(-90 4.5 19.5)"></rect>
                <rect width="1" height="1" x="5" y="18" transform="rotate(-90 5.5 18.5)"></rect>
                <rect width="1" height="1" x="6" y="19" transform="rotate(-90 6.5 19.5)"></rect>
                <rect width="1" height="1" x="7" y="20" transform="rotate(-90 7.5 20.5)"></rect>
                <rect width="1" height="1" x="8" y="21" transform="rotate(-90 8.5 21.5)"></rect>
                <rect width="1" height="4" x="4.5" y="18.5" transform="rotate(-90 5 20.5)"></rect>
                <rect width="1" height="4" x="3.5" y="12.5" transform="rotate(90 4 14.5)"></rect>
                <rect width="1" height="4" x="4.5" y="15.5" transform="rotate(90 5 17.5)"></rect>
                <rect width="1" height="4" x="12.5" y="16.5" transform="rotate(90 13 18.5)"></rect>
                <rect width="1" height="4" x="15" y="18.5"></rect>
                <rect width="1" height="1" x="15" y="28"></rect>
                <rect width="2" height="2" x="14" y="26"></rect>
                <rect width="1" height="4" x="14.5" y="27.5" transform="rotate(90 15 29.5)"></rect>
                <rect width="1" height="1" x="23" y="27" transform="rotate(180 23.5 27.5)"></rect>
                <rect width="2" height="2" x="23" y="28" transform="rotate(180 24 29)"></rect>
                <rect width="1" height="4" x="23.5" y="24.5" transform="rotate(-90 24 26.5)"></rect>
                <rect width="1" height="4" x="15.5" y="12.5" transform="rotate(90 16 14.5)"></rect>
                <rect width="1" height="4" x="11.5" y=".5" transform="rotate(90 12 2.5)"></rect>
                <rect width="1" height="4" x="18.5" y=".5" transform="rotate(90 19 2.5)"></rect>
                <rect width="1" height="4" x="19.5" y="10.5" transform="rotate(90 20 12.5)"></rect>
                <rect width="1" height="1" x="14" y="5" transform="rotate(180 14.5 5.5)"></rect>
                <rect width="1" height="1" x="13" y="4" transform="rotate(180 13.5 4.5)"></rect>
                <rect width="1" height="4" x="14" y="6"></rect>
                <rect width="1" height="1" x="18" y="23" transform="rotate(180 18.5 23.5)"></rect>
                <rect width="1" height="1" x="17" y="22" transform="rotate(180 17.5 22.5)"></rect>
                <rect width="1" height="1" x="18" y="21" transform="rotate(180 18.5 21.5)"></rect>
                <rect width="1" height="1" x="17" y="20" transform="rotate(180 17.5 20.5)"></rect>
                <rect width="1" height="1" x="18" y="19" transform="rotate(180 18.5 19.5)"></rect>
                <rect width="1" height="1" x="17" y="18" transform="rotate(180 17.5 18.5)"></rect>
                <rect width="1" height="1" x="16" y="17" transform="rotate(180 16.5 17.5)"></rect>
                <rect width="1" height="4" x="18" y="24"></rect>
                <rect width="1" height="4" x="14.5" y="20.5" transform="rotate(90 15 22.5)"></rect>
                <rect width="1" height="4" x="15.5" y="22.5" transform="rotate(90 16 24.5)"></rect>
                <rect width="1" height="4" x="22.5" y="20.5" transform="rotate(90 23 22.5)"></rect>
                <rect width="1" height="4" x="18.5" y="14.5" transform="rotate(90 19 16.5)"></rect>
                <rect width="1" height="4" x="16" y="4"></rect>
                <rect width="1" height="4" x="29" y="19"></rect>
                <rect width="1" height="4" x="29" y="26"></rect>
                <rect width="1" height="4" x="21" y="14"></rect>
                <rect width="2" height="1.5" x="26" y="22.5"></rect>
                <rect width="1" height="3" x="25" y="21"></rect>
                <rect width="1" height="4" x="20" y="19"></rect>
                <rect width="1" height="4" x="24.5" y="22.5" transform="rotate(-90 25 24.5)"></rect>
                <rect width="1" height="4" x="27" y="24" transform="rotate(180 27.5 26)"></rect>
              </svg>
              <div class="qr-label">支付宝扫码支付</div>
            </div>
            <div class="qr-info">
              <div class="info-item">
                <svg class="info-icon" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>
                <span>充值手续费 3.5%</span>
              </div>
              <div class="info-item">
                <svg class="info-icon" viewBox="0 0 24 24"><path d="M12 22c5.52 0 10-4.48 10-10S17.52 2 12 2 2 6.48 2 12s4.48 10 10 10zm1-11v6h-2v-6h2zm0-4v2h-2V7h2z"/></svg>
                <span>单笔限额 $400</span>
              </div>
              <div class="info-item">
                <svg class="info-icon" viewBox="0 0 24 24"><path d="M11 17h2v-6h-2v6zm1-8c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
                <span>最低充值金额 $5</span>
              </div>
            </div>
          </div>
          <div class="payment-instructions">
            <h3>充值步骤</h3>
            <ol>
              <li>请使用支付宝扫描二维码</li>
              <li>输入充值金额并确认支付</li>
              <li>支付完成后充值金额将自动添加到您的账户</li>
            </ol>
          </div>
        </div>
        
        <!-- 微信支付内容 -->
        <div v-if="currentTab === 'wechat'" class="qr-section">
          <div class="qr-container wechat">
            <div class="liquid-bubble bubble-1"></div>
            <div class="liquid-bubble bubble-2"></div>
            <div class="liquid-bubble bubble-3"></div>
            <div class="qr-header">
              <div class="wechat-logo">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="none" viewBox="0 0 256 256" id="wechat">
                  <rect width="224" height="224" x="16" y="16" fill="#EEE" rx="70"></rect>
                  <path fill="#07C160" fill-rule="evenodd" d="M109.822 143.487C108.8 144.005 107.617 144.106 106.521 143.772C105.425 143.437 104.501 142.692 103.942 141.691L103.654 141.055L91.518 114.423C91.3078 113.975 91.2535 113.469 91.3637 112.987C91.4739 112.504 91.7422 112.072 92.1261 111.759C92.51 111.447 92.9874 111.272 93.4824 111.261C93.9774 111.251 94.4616 111.407 94.858 111.703L109.178 121.903C110.043 122.471 111.029 122.828 112.057 122.946C113.085 123.064 114.127 122.94 115.098 122.583L182.454 92.5994C170.382 78.3674 150.498 69.0674 127.998 69.0674C91.178 69.0674 61.334 93.9394 61.334 124.627C61.334 141.363 70.31 156.435 84.366 166.623C85.1428 167.175 85.7211 167.963 86.0151 168.869C86.309 169.776 86.3031 170.753 85.998 171.655C84.878 175.843 83.078 182.547 82.998 182.863C82.854 183.387 82.638 183.939 82.638 184.487C82.638 185.715 83.63 186.707 84.862 186.707C85.3185 186.691 85.7614 186.548 86.142 186.295L100.742 177.867C101.838 177.235 102.998 176.843 104.278 176.843C104.962 176.843 105.622 176.947 106.238 177.139C113.046 179.099 120.398 180.183 127.998 180.183C164.818 180.183 194.666 155.311 194.666 124.623C194.666 115.335 191.914 106.583 187.074 98.8834L109.822 143.487Z" clip-rule="evenodd"></path>
                </svg>
              </div>
              <div class="wechat-text">微信支付</div>
            </div>
            <div class="qr-code">
              <!-- 微信支付二维码 -->
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" id="qr-code-wechat" class="qr-svg" fill="#000000">
                <path d="M9 9H2V2H9zM3 8H8V3H3zM30 9H23V2h7zM24 8h5V3H24zM9 30H2V23H9zM3 29H8V24H3z"></path>
                <rect width="3" height="3" x="4" y="4"></rect>
                <rect width="3" height="3" x="25" y="4"></rect>
                <rect width="3" height="3" x="4" y="25"></rect>
                <rect width="1" height="1" x="10" y="4"></rect>
                <rect width="1" height="1" x="11" y="5"></rect>
                <rect width="1" height="1" x="12" y="6"></rect>
                <rect width="1" height="1" x="13" y="7"></rect>
                <rect width="1" height="1" x="12" y="7"></rect>
                <rect width="1" height="1" x="13" y="17"></rect>
                <rect width="1" height="1" x="24.71" y="18.32" transform="rotate(-45 25.214 18.816)"></rect>
                <rect width="1" height="1" x="27.54" y="18.32" transform="rotate(-45 28.043 18.814)"></rect>
                <rect width="1" height="1" x="28.95" y="18.32" transform="rotate(-45 29.455 18.82)"></rect>
                <rect width="1" height="1" x="23.71" y="28.32" transform="rotate(-45 24.209 28.822)"></rect>
                <rect width="1" height="1" x="25.12" y="28.32" transform="rotate(-45 25.626 28.815)"></rect>
                <rect width="1" height="1" x="26.54" y="28.32" transform="rotate(-45 27.038 28.82)"></rect>
                <rect width="1" height="1" x="27.95" y="28.32" transform="rotate(-45 28.455 28.814)"></rect>
                <rect width="1" height="1" x="8" y="10"></rect>
                <rect width="1" height="1" x="9" y="11"></rect>
                <rect width="1" height="1" x="10" y="12"></rect>
                <rect width="1" height="1" x="11" y="13"></rect>
                <rect width="1" height="1" x="10" y="14"></rect>
                <rect width="1" height="1" x="9" y="15"></rect>
                <rect width="1" height="1" x="8" y="16"></rect>
                <rect width="1" height="1" x="21" y="26" transform="rotate(90 21.5 26.5)"></rect>
                <rect width="1" height="1" x="20" y="27" transform="rotate(90 20.5 27.5)"></rect>
                <rect width="1" height="1" x="19" y="28" transform="rotate(90 19.5 28.5)"></rect>
                <rect width="1" height="1" x="18" y="29" transform="rotate(90 18.5 29.5)"></rect>
                <rect width="1" height="1" x="21" y="6" transform="rotate(90 21.5 6.5)"></rect>
                <rect width="1" height="1" x="19" y="14" transform="rotate(90 19.5 14.5)"></rect>
                <rect width="1" height="1" x="19" y="18" transform="rotate(90 19.5 18.5)"></rect>
                <rect width="1" height="1" x="21" y="24" transform="rotate(90 21.5 24.5)"></rect>
                <rect width="1" height="1" x="20" y="24" transform="rotate(90 20.5 24.5)"></rect>
                <rect width="1" height="1" x="20" y="7" transform="rotate(90 20.5 7.5)"></rect>
                <rect width="1.5" height="1" x="18.75" y="4.75" transform="rotate(90 19.5 5.25)"></rect>
                <rect width="1.5" height="1" x="17.75" y="6.25" transform="rotate(90 18.5 6.75)"></rect>
                <rect width="1.5" height="1" x="27" y="21" transform="rotate(-180 27.75 21.5)"></rect>
                <rect width="1.5" height="1" x="25.5" y="20" transform="rotate(-180 26.25 20.5)"></rect>
                <rect width="1" height="1" x="19" y="8" transform="rotate(90 19.5 8.5)"></rect>
                <rect width="1" height="1" x="18" y="9" transform="rotate(90 18.5 9.5)"></rect>
                <rect width="1" height="1" x="17" y="28" transform="rotate(90 17.5 28.5)"></rect>
                <rect width="1" height="1" x="16" y="27" transform="rotate(90 16.5 27.5)"></rect>
                <rect width="1" height="1" x="15" y="26" transform="rotate(90 15.5 26.5)"></rect>
                <rect width="1" height="1" x="11" y="19"></rect>
                <rect width="1" height="1" x="12" y="20"></rect>
                <rect width="1" height="1" x="11" y="21"></rect>
                <rect width="1" height="1" x="12" y="22"></rect>
                <rect width="1" height="1" x="11" y="23"></rect>
                <rect width="1" height="1" x="12" y="24"></rect>
                <rect width="1" height="1" x="13" y="25"></rect>
                <rect width="1" height="1" x="10" y="26"></rect>
                <rect width="1" height="1" x="11" y="25"></rect>
                <rect width="1" height="1" x="22" y="12" transform="rotate(-90 22.5 12.5)"></rect>
                <rect width="1" height="1" x="23" y="11" transform="rotate(-90 23.5 11.5)"></rect>
                <rect width="1" height="1" x="24" y="12" transform="rotate(-90 24.5 12.5)"></rect>
                <rect width="1" height="1" x="25" y="11" transform="rotate(-90 25.5 11.5)"></rect>
                <rect width="1" height="1" x="26" y="12" transform="rotate(-90 26.5 12.5)"></rect>
                <rect width="1" height="1" x="27" y="11" transform="rotate(-90 27.5 11.5)"></rect>
                <rect width="1" height="1" x="28" y="10" transform="rotate(-90 28.5 10.5)"></rect>
                <rect width="2" height="2" x="13" y="2"></rect>
                <rect width="2" height="2" x="12" y="15"></rect>
                <rect width="2" height="2" x="8" y="18"></rect>
                <rect width="1" height="1" x="10" y="23"></rect>
                <rect width="2" height="2" x="9" y="21"></rect>
                <rect width="2" height="2" x="23" y="15"></rect>
                <rect width="2" height="2" x="25" y="14"></rect>
                <rect width="2" height="2" x="22" y="16"></rect>
                <rect width="2" height="2" x="16" y="9"></rect>
                <rect width="2" height="2" x="18" y="8"></rect>
                <rect width="2" height="2" x="15" y="10"></rect>
                <rect width="1.2" height="1.2" x="20.6" y="9.4"></rect>
                <rect width="1.2" height="1.2" x="21.8" y="8.8"></rect>
                <rect width="1.2" height="1.2" x="20" y="10"></rect>
                <rect width="2" height="2" x="19" y="2"></rect>
                <rect width="1" height="2" x="29" y="12"></rect>
                <rect width="1" height="2" x="2" y="17"></rect>
                <rect width="2" height="2" x="22" y="19"></rect>
                <rect width="2" height="2" x="2" y="11"></rect>
                <rect width="2" height="2" x="3" y="12"></rect>
                <rect width="2" height="2" x="4" y="10"></rect>
                <rect width="2" height="2" x="6" y="11"></rect>
                <rect width="2" height="2" x="6" y="14"></rect>
                <rect width="2" height="2" x="10" y="28"></rect>
                <rect width="1" height="4" x="13" y="9"></rect>
                <rect width="1" height="4" x="10" y="6"></rect>
                <rect width="1" height="4" x="11" y="8"></rect>
                <rect width="1" height="4" x="15" y="13"></rect>
                <rect width="1" height="4" x="9" y="11"></rect>
                <rect width="1" height="1" x="26" y="12"></rect>
                <rect width="1" height="1" x="27" y="13"></rect>
                <rect width="1" height="1" x="28" y="14"></rect>
                <rect width="1" height="1" x="29" y="15"></rect>
                <rect width="1" height="1" x="29" y="24"></rect>
                <rect width="1" height="1" x="28" y="16"></rect>
                <rect width="1" height="1" x="27" y="17"></rect>
                <rect width="1" height="1" x="26" y="18"></rect>
                <rect width="1" height="4" x="27" y="13"></rect>
                <rect width="1" height="1" x="2" y="21" transform="rotate(-90 2.5 21.5)"></rect>
                <rect width="1" height="1" x="3" y="20" transform="rotate(-90 3.5 20.5)"></rect>
                <rect width="1" height="1" x="4" y="19" transform="rotate(-90 4.5 19.5)"></rect>
                <rect width="1" height="1" x="5" y="18" transform="rotate(-90 5.5 18.5)"></rect>
                <rect width="1" height="1" x="6" y="19" transform="rotate(-90 6.5 19.5)"></rect>
                <rect width="1" height="1" x="7" y="20" transform="rotate(-90 7.5 20.5)"></rect>
                <rect width="1" height="1" x="8" y="21" transform="rotate(-90 8.5 21.5)"></rect>
                <rect width="1" height="4" x="4.5" y="18.5" transform="rotate(-90 5 20.5)"></rect>
                <rect width="1" height="4" x="3.5" y="12.5" transform="rotate(90 4 14.5)"></rect>
                <rect width="1" height="4" x="4.5" y="15.5" transform="rotate(90 5 17.5)"></rect>
                <rect width="1" height="4" x="12.5" y="16.5" transform="rotate(90 13 18.5)"></rect>
                <rect width="1" height="4" x="15" y="18.5"></rect>
                <rect width="1" height="1" x="15" y="28"></rect>
                <rect width="2" height="2" x="14" y="26"></rect>
                <rect width="1" height="4" x="14.5" y="27.5" transform="rotate(90 15 29.5)"></rect>
                <rect width="1" height="1" x="23" y="27" transform="rotate(180 23.5 27.5)"></rect>
                <rect width="2" height="2" x="23" y="28" transform="rotate(180 24 29)"></rect>
                <rect width="1" height="4" x="23.5" y="24.5" transform="rotate(-90 24 26.5)"></rect>
                <rect width="1" height="4" x="15.5" y="12.5" transform="rotate(90 16 14.5)"></rect>
                <rect width="1" height="4" x="11.5" y=".5" transform="rotate(90 12 2.5)"></rect>
                <rect width="1" height="4" x="18.5" y=".5" transform="rotate(90 19 2.5)"></rect>
                <rect width="1" height="4" x="19.5" y="10.5" transform="rotate(90 20 12.5)"></rect>
                <rect width="1" height="1" x="14" y="5" transform="rotate(180 14.5 5.5)"></rect>
                <rect width="1" height="1" x="13" y="4" transform="rotate(180 13.5 4.5)"></rect>
                <rect width="1" height="4" x="14" y="6"></rect>
                <rect width="1" height="1" x="18" y="23" transform="rotate(180 18.5 23.5)"></rect>
                <rect width="1" height="1" x="17" y="22" transform="rotate(180 17.5 22.5)"></rect>
                <rect width="1" height="1" x="18" y="21" transform="rotate(180 18.5 21.5)"></rect>
                <rect width="1" height="1" x="17" y="20" transform="rotate(180 17.5 20.5)"></rect>
                <rect width="1" height="1" x="18" y="19" transform="rotate(180 18.5 19.5)"></rect>
                <rect width="1" height="1" x="17" y="18" transform="rotate(180 17.5 18.5)"></rect>
                <rect width="1" height="1" x="16" y="17" transform="rotate(180 16.5 17.5)"></rect>
                <rect width="1" height="4" x="18" y="24"></rect>
                <rect width="1" height="4" x="14.5" y="20.5" transform="rotate(90 15 22.5)"></rect>
                <rect width="1" height="4" x="15.5" y="22.5" transform="rotate(90 16 24.5)"></rect>
                <rect width="1" height="4" x="22.5" y="20.5" transform="rotate(90 23 22.5)"></rect>
                <rect width="1" height="4" x="18.5" y="14.5" transform="rotate(90 19 16.5)"></rect>
                <rect width="1" height="4" x="16" y="4"></rect>
                <rect width="1" height="4" x="29" y="19"></rect>
                <rect width="1" height="4" x="29" y="26"></rect>
                <rect width="1" height="4" x="21" y="14"></rect>
                <rect width="2" height="1.5" x="26" y="22.5"></rect>
                <rect width="1" height="3" x="25" y="21"></rect>
                <rect width="1" height="4" x="20" y="19"></rect>
                <rect width="1" height="4" x="24.5" y="22.5" transform="rotate(-90 25 24.5)"></rect>
                <rect width="1" height="4" x="27" y="24" transform="rotate(180 27.5 26)"></rect>
              </svg>
              <div class="qr-label">微信扫码支付</div>
            </div>
            <div class="qr-info">
              <div class="info-item">
                <svg class="info-icon" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>
                <span>充值手续费 3.5%</span>
              </div>
              <div class="info-item">
                <svg class="info-icon" viewBox="0 0 24 24"><path d="M12 22c5.52 0 10-4.48 10-10S17.52 2 12 2 2 6.48 2 12s4.48 10 10 10zm1-11v6h-2v-6h2zm0-4v2h-2V7h2z"/></svg>
                <span>单笔限额 $400</span>
              </div>
              <div class="info-item">
                <svg class="info-icon" viewBox="0 0 24 24"><path d="M11 17h2v-6h-2v6zm1-8c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
                <span>最低充值金额 $5</span>
              </div>
            </div>
          </div>
          <div class="payment-instructions">
            <h3>充值步骤</h3>
            <ol>
              <li>请使用微信扫描二维码</li>
              <li>输入充值金额并确认支付</li>
              <li>支付完成后充值金额将自动添加到您的账户</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits, computed } from 'vue';

const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  paymentOption: {
    type: Object,
    default: () => ({ amount: '7', price: '1' })
  }
});

const emit = defineEmits(['close']);

const currentTab = ref('alipay');

const paymentAmount = computed(() => {
  return props.paymentOption.price || '1';
});

const onClose = () => {
  emit('close');
};
</script>

<style scoped>
.payment-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  background-color: rgba(0, 0, 0, 0.75);
  backdrop-filter: blur(5px);
}

.modal-content {
  position: relative;
  width: 80%;
  max-width: 320px;
  background: linear-gradient(71deg, #080509, #1a171c, #080509);
  border-radius: 35px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
  animation: modalFadeIn 0.3s ease;
  padding: 25px 25px 30px 25px;
  color: white;
  border: 2px solid transparent;
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

.modal-header {
  display: flex;
  align-items: center;
  position: relative;
  margin-bottom: 20px;
}

.modal-header h2 {
  text-align: center;
  font-size: 22px;
  margin: 0;
  font-weight: 600;
  color: white;
  letter-spacing: -0.02em;
  line-height: 30px;
  width: 100%;
  position: absolute;
  left: 0;
  right: 0;
}

.sundial-icon {
  position: relative;
  width: 32px;
  height: 32px;
  z-index: 5;
  animation: pulse 3s ease-in-out infinite;
  background: rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3px;
  box-shadow: 0 0 8px rgba(255, 215, 0, 0.5);
  flex-shrink: 0;
  margin-right: auto;
}

.close-button {
  position: relative;
  background: transparent;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  font-size: 24px;
  cursor: pointer;
  padding: 0 5px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 5;
  margin-left: auto;
}

.close-button:hover {
  color: white;
}

.payment-tabs {
  display: flex;
  justify-content: space-between;
  background-color: rgba(0, 0, 0, 0.2);
  border-radius: 20px;
  padding: 4px;
  margin-bottom: 20px;
  width: 100%;
}

.payment-tab {
  flex: 1;
  text-align: center;
  padding: 10px;
  border-radius: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.6);
  transition: all 0.3s ease;
}

.payment-tab.active {
  background: rgba(175, 162, 32, 0.15);
  color: white;
  box-shadow: 0 2px 6px rgba(175, 162, 32, 0.3);
  border: 1px solid rgba(175, 162, 32, 0.3);
}

.tab-icon {
  width: 20px;
  height: 20px;
  margin-right: 8px;
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}

.alipay-icon {
  background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" fill="none" viewBox="0 0 256 256" id="alipay"><rect width="224" height="224" x="16" y="16" fill="%23EEE" rx="70"></rect><path fill="%231677FF" d="M91.3823 136.405C89.7398 137.662 88.0973 139.497 87.6142 141.913C86.9379 145.101 87.5176 149.159 90.5127 152.348C94.2808 156.116 99.9813 157.178 102.493 157.372C109.16 157.855 116.31 154.473 121.72 150.802C123.846 149.352 127.421 146.357 130.899 141.719C123.17 137.758 113.508 133.314 103.266 133.7C97.8557 133.893 94.0876 134.956 91.3823 136.405ZM189.353 154.087C192.735 146.067 194.667 137.275 194.667 128C194.667 91.2847 164.716 61.333 128.001 61.333C91.2857 61.333 61.334 91.2847 61.334 128C61.334 164.715 91.2857 194.666 128.001 194.666C150.223 194.666 169.836 183.748 182.01 167.033C170.513 161.43 151.672 151.961 139.981 146.357C134.474 152.734 126.262 159.014 116.986 161.719C111.189 163.459 105.875 164.135 100.464 162.976C94.9572 161.816 90.9958 159.304 88.677 156.792C87.5176 155.439 86.1649 153.893 85.1021 151.864C85.1987 151.961 85.1987 152.154 85.1987 152.251C85.1987 152.251 84.619 151.285 84.2325 149.739C84.0393 148.966 83.8461 148.193 83.7494 147.42C83.6528 146.84 83.6528 146.261 83.7494 145.777C83.6528 144.811 83.7494 143.748 83.9427 142.686C84.5224 139.98 85.5852 136.985 88.5804 134.183C94.9572 127.903 103.556 127.613 108.001 127.613C114.571 127.71 125.972 130.512 135.634 133.99C138.339 128.29 140.078 122.299 141.141 118.145H101.044V113.797H121.624V105.101H96.7929V100.657H121.624V91.961C121.624 90.8016 121.914 89.8354 123.749 89.8354H133.508V100.657H160.464V105.005H133.508V113.7H155.054C155.054 113.7 152.832 125.777 146.165 137.662C161.141 142.976 182.3 151.285 189.353 154.087Z"></path></svg>');
}

.wechat-icon {
  background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" fill="none" viewBox="0 0 256 256" id="wechat"><rect width="224" height="224" x="16" y="16" fill="%23EEE" rx="70"></rect><path fill="%2307C160" fill-rule="evenodd" d="M109.822 143.487C108.8 144.005 107.617 144.106 106.521 143.772C105.425 143.437 104.501 142.692 103.942 141.691L103.654 141.055L91.518 114.423C91.3078 113.975 91.2535 113.469 91.3637 112.987C91.4739 112.504 91.7422 112.072 92.1261 111.759C92.51 111.447 92.9874 111.272 93.4824 111.261C93.9774 111.251 94.4616 111.407 94.858 111.703L109.178 121.903C110.043 122.471 111.029 122.828 112.057 122.946C113.085 123.064 114.127 122.94 115.098 122.583L182.454 92.5994C170.382 78.3674 150.498 69.0674 127.998 69.0674C91.178 69.0674 61.334 93.9394 61.334 124.627C61.334 141.363 70.31 156.435 84.366 166.623C85.1428 167.175 85.7211 167.963 86.0151 168.869C86.309 169.776 86.3031 170.753 85.998 171.655C84.878 175.843 83.078 182.547 82.998 182.863C82.854 183.387 82.638 183.939 82.638 184.487C82.638 185.715 83.63 186.707 84.862 186.707C85.3185 186.691 85.7614 186.548 86.142 186.295L100.742 177.867C101.838 177.235 102.998 176.843 104.278 176.843C104.962 176.843 105.622 176.947 106.238 177.139C113.046 179.099 120.398 180.183 127.998 180.183C164.818 180.183 194.666 155.311 194.666 124.623C194.666 115.335 191.914 106.583 187.074 98.8834L109.822 143.487Z" clip-rule="evenodd"></path></svg>');
}

/* 二维码区域 */
.qr-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
}

.qr-container {
  width: 165px;
  padding: 8px;
  border-radius: 10px;
  color: white;
  margin-bottom: 12px;
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.qr-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: -1;
  opacity: 0.9;
  border-radius: 10px;
}

.qr-container.alipay::before {
  background: linear-gradient(45deg, #0954d8, #2ec3ff, #814cf5);
  background-size: 200% 200%;
  animation: gradientBG 15s ease infinite;
  filter: brightness(1.1) blur(0.5px);
}

.qr-container.wechat::before {
  background: linear-gradient(45deg, #ce46b3, #4f22cd, #4825d6);
  background-size: 200% 200%;
  animation: gradientBG 15s ease infinite;
  filter: brightness(1.1) blur(0.5px);
}

@keyframes gradientBG {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

.qr-code {
  background: rgba(255, 255, 255, 0.95);
  padding: 6px;
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  position: relative;
  z-index: 1;
}

.qr-svg {
  width: 120px;
  height: 120px;
  margin-bottom: 5px;
  fill: #000000;
}

.qr-container.alipay .qr-svg {
  fill: #000000;
}

.qr-container.wechat .qr-svg {
  fill: #000000;
}

.qr-container.wechat {
  margin-bottom: 10px;
}

.qr-header {
  display: flex;
  align-items: center;
  margin-bottom: 6px;
}

.alipay-logo, .wechat-logo {
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.alipay-text, .wechat-text {
  color: white;
  margin-left: 4px;
  font-weight: bold;
  font-size: 14px;
}

.qr-label {
  color: #333;
  font-size: 10px;
}

.qr-info {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 3px;
  font-size: 10px;
}

.info-icon {
  width: 11px;
  height: 11px;
  fill: #1677FF;
  flex-shrink: 0;
}

.qr-container.wechat .info-icon {
  fill: #07C160;
}

.qr-container.wechat .info-item {
  color: rgba(255, 255, 255, 0.9);
}

.qr-container.alipay .info-item {
  color: rgba(255, 255, 255, 0.9);
}

/* 支付步骤说明 */
.payment-instructions {
  width: 100%;
  max-width: 260px;
}

.payment-instructions h3 {
  margin-top: 0;
  margin-bottom: 4px;
  font-size: 13px;
}

.payment-instructions ol {
  margin: 0;
  padding-left: 16px;
}

.payment-instructions li {
  margin-bottom: 2px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 11px;
}

/* 响应式调整 */
@media (max-width: 500px) {
  .modal-content {
    width: 82%;
    padding: 10px;
  }
  
  .qr-container {
    width: 150px;
    padding: 7px;
  }
  
  .qr-svg {
    width: 110px;
    height: 110px;
  }
  
  .modal-header {
    margin-bottom: 15px;
  }
  
  .modal-header h2 {
    font-size: 15px;
  }
  
  .sundial-icon {
    width: 25px;
    height: 25px;
  }
  
  .payment-tab {
    padding: 5px 4px;
    font-size: 11px;
  }
  
  .tab-icon {
    width: 16px;
    height: 16px;
  }

  .payment-tabs-container {
    align-items: flex-start;
  }
  
  .payment-tabs {
    margin-right: 10px;
  }
  
  .sundial-icon {
    width: 25px;
    height: 25px;
    margin-right: 5px;
  }
  
  .coin-image {
    width: 70%;
  }
  
  .overlay-svg {
    width: 40%;
    height: 40%;
  }
}

.payment-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
}

.qr-container.wechat .qr-code {
  border: 1px solid rgba(7, 193, 96, 0.15);
}

.qr-container.alipay .qr-code {
  border: 1px solid rgba(22, 119, 255, 0.15);
}

.qr-container::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='0.08' fill-rule='evenodd'/%3E%3C/svg%3E");
  background-size: 300px 300px;
  pointer-events: none;
  z-index: -1;
  opacity: 0.3;
  mix-blend-mode: overlay;
}

/* Add liquid bubble effect */
.qr-container:before {
  border-radius: 10px;
  box-shadow: inset 0 0 15px rgba(255, 255, 255, 0.2);
}

.liquid-bubble {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  transform: translate(-50%, -50%);
  pointer-events: none;
  z-index: -1;
}

.bubble-1 {
  width: 60px;
  height: 60px;
  top: 20%;
  left: 15%;
  animation: float 8s ease-in-out infinite;
}

.bubble-2 {
  width: 40px;
  height: 40px;
  bottom: 20%;
  right: 15%;
  animation: float 6s ease-in-out infinite;
  animation-delay: 1s;
}

.bubble-3 {
  width: 25px;
  height: 25px;
  top: 70%;
  left: 20%;
  animation: float 7s ease-in-out infinite;
  animation-delay: 2s;
}

@keyframes float {
  0% {
    transform: translate(-50%, -50%);
  }
  50% {
    transform: translate(-50%, -60%);
  }
  100% {
    transform: translate(-50%, -50%);
  }
}

.qr-container.alipay .info-icon,
.qr-container.wechat .info-icon {
  fill: white;
}

.qr-container.wechat .qr-code {
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.qr-container.alipay .qr-code {
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.sundial-icon {
  position: relative;
  width: 32px;
  height: 32px;
  z-index: 2;
  animation: pulse 3s ease-in-out infinite;
  background: rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3px;
  box-shadow: 0 0 8px rgba(255, 215, 0, 0.5);
  flex-shrink: 0;
  margin-right: 10px;
}

@keyframes pulse {
  0% {
    transform: scale(1);
    box-shadow: 0 0 4px rgba(255, 215, 0, 0.3);
  }
  50% {
    transform: scale(1.05);
    box-shadow: 0 0 8px rgba(255, 165, 0, 0.4);
  }
  100% {
    transform: scale(1);
    box-shadow: 0 0 4px rgba(255, 215, 0, 0.3);
  }
}

.sundial-icon::before {
  content: '';
  position: absolute;
  width: 70px;
  height: 70px;
  border-radius: 50%;
  background: transparent;
  border: 1px solid rgba(255, 223, 0, 0.25);
  animation: ripple 2s linear infinite;
  z-index: -1;
}

.sundial-icon::after {
  content: '';
  position: absolute;
  width: 90%;
  height: 90%;
  border-radius: 50%;
  background: transparent;
  z-index: 0;
}

.coin-image {
  width: 75%;
  height: auto;
  position: relative;
  z-index: 2;
  filter: drop-shadow(0 0 8px rgba(255, 223, 0, 0.9));
}

.coin-text {
  color: #fff;
  font-size: 10px;
  margin-top: 2px;
  text-shadow: 0 0 5px rgba(255, 215, 0, 0.8);
  font-weight: bold;
  position: relative;
  z-index: 2;
}

@keyframes ripple {
  0% {
    transform: scale(0.8);
    opacity: 1;
  }
  100% {
    transform: scale(1.2);
    opacity: 0;
  }
}

@keyframes glow {
  from {
    filter: drop-shadow(0 0 2px rgba(255, 255, 255, 0.7));
  }
  to {
    filter: drop-shadow(0 0 8px rgba(145, 100, 255, 0.9));
  }
}

.coin-image-container {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.overlay-svg {
  position: absolute;
  width: 45%;
  height: 45%;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 3;
  fill: white;
  filter: drop-shadow(0 0 4px rgba(255, 223, 0, 0.9));
  animation: glow-svg 2s ease-in-out infinite alternate;
}

@keyframes glow-svg {
  from {
    filter: drop-shadow(0 0 2px rgba(255, 255, 255, 0.9));
  }
  to {
    filter: drop-shadow(0 0 6px rgba(255, 223, 0, 1));
  }
}

.aetrix-icon {
  position: relative;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  overflow: hidden;
  background: radial-gradient(circle, rgba(78, 41, 202, 0.9) 0%, rgba(51, 25, 128, 0.8) 65%, rgba(36, 8, 72, 0.7) 100%);
  box-shadow: 0 0 4px rgba(108, 99, 255, 0.4);
}

.aetrix-icon img {
  width: 75%;
  height: auto;
  position: relative;
  z-index: 2;
  filter: drop-shadow(0 0 4px rgba(255, 255, 255, 0.7));
}

/* 付款金额 */
.payment-amount {
  margin: 15px 0;
  text-align: center;
  padding: 15px 15px 25px 15px;
  background: linear-gradient(135deg, rgba(255, 204, 0, 0.05), rgba(255, 204, 0, 0.1));
  border-radius: 10px;
  border: 1px dashed rgba(255, 204, 0, 0.4);
  position: relative;
}

.amount-label {
  font-size: 14px;
  margin-bottom: 8px;
  color: rgba(255, 255, 255, 0.7);
}

.amount-value {
  font-size: 28px;
  font-weight: bold;
  color: #FFCC00;
}

.amount-value span {
  font-size: 16px;
  font-weight: normal;
  margin-left: 2px;
}
</style> 