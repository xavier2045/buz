<template>
  <div class="start-page">
    <div class="header fade-in-down">
      <TextGenerateEffect 
        text="AETRIX开启您的IP发布" 
        class="main-title"
        :withUnderline="true"
        :autoStart="true"
      />
      <TextGenerateEffect 
        text="选择您要进行的操作" 
        class="subtitle-zh" 
        :autoStart="false"
        :withUnderline="false"
        ref="subtitleEffect"
      />
    </div>
    
    <div class="menu-options">
      <div class="menu-card scale-on-hover fade-in-up" 
           data-text="发布作品" 
           @click="goToWorkType"
           style="animation-delay: 0.1s">
        <div class="icon-wrapper">
          <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="none" viewBox="0 0 64 64" id="content-creation">
            <g>
              <g>
                <path fill="url(#paint0_linear_4229_1803)" fill-rule="evenodd" d="M18.5547 13.168C18.2478 12.9634 17.8533 12.9443 17.5281 13.1183C17.203 13.2923 17 13.6312 17 14V22C17 22.3688 17.203 22.7077 17.5281 22.8817C17.8533 23.0557 18.2478 23.0366 18.5547 22.8321L24.5547 18.8321C24.8329 18.6466 25 18.3344 25 18C25 17.6656 24.8329 17.3534 24.5547 17.168L18.5547 13.168ZM22.1972 18L19 20.1315V15.8685L22.1972 18Z" clip-rule="evenodd"></path>
                <path fill="url(#paint1_linear_4229_1803)" fill-rule="evenodd" d="M12 10C10.8954 10 10 10.8954 10 12V24C10 25.1046 10.8954 26 12 26H30C31.1046 26 32 25.1046 32 24V12C32 10.8954 31.1046 10 30 10H12ZM30 12H12L12 24H30V12Z" clip-rule="evenodd"></path>
                <path fill="url(#paint2_linear_4229_1803)" fill-rule="evenodd" d="M46 30V42C46 43.1046 45.1046 44 44 44H38.0157C38.0098 44.0001 38.0038 44.0001 37.9979 44.0001C37.994 44.0001 37.99 44.0001 37.9861 44H26C24.8954 44 24 43.1046 24 42V30C24 28.8954 24.8954 28 26 28H44C45.1046 28 46 28.8954 46 30ZM26 30H44V37.5858L41.7071 35.2929C41.3468 34.9326 40.7732 34.9008 40.3753 35.2191L36.227 38.5378L32.8321 33.4453C32.6594 33.1863 32.376 33.0225 32.0654 33.0021C31.7548 32.9818 31.4524 33.1072 31.2474 33.3415L26 39.3386V30ZM40.9258 37.34L44 40.4142V42H38.5352L37.3406 40.2081L40.9258 37.34ZM31.8925 35.6415L36.1315 42H26.3288L31.8925 35.6415Z" clip-rule="evenodd"></path>
                <path fill="url(#paint3_linear_4229_1803)" fill-rule="evenodd" d="M33.477 48H46C48.2091 48 50 46.2091 50 44V34.618L53.6584 36.4472C55.6531 37.4445 58 35.9941 58 33.7639V20.236C58 18.0059 55.6531 16.5554 53.6584 17.5528L50 19.3819V10C50 7.79086 48.2091 6 46 6H10C7.79086 6 6 7.79086 6 10V44C6 46.2091 7.79086 48 10 48H22.523L21.323 51H16.7081C14.6636 51 12.8251 52.2448 12.0658 54.143L11.0715 56.6286C10.9483 56.9367 10.9859 57.2859 11.1719 57.5606C11.358 57.8354 11.6682 58 12 58H44C44.3318 58 44.642 57.8354 44.8281 57.5606C45.0141 57.2859 45.0517 56.9367 44.9285 56.6286L43.9343 54.143C43.1749 52.2448 41.3364 51 39.2919 51H34.677L33.477 48ZM46 8H10C8.89543 8 8 8.89543 8 10V44C8 45.1046 8.89543 46 10 46H46C47.1046 46 48 45.1046 48 44V10C48 8.89543 47.1046 8 46 8ZM31.323 48H24.677L23.477 51H32.523L31.323 48ZM54.5528 34.6583L50 32.3819V21.618L54.5528 19.3416C55.2177 19.0092 56 19.4927 56 20.236V33.7639C56 34.5073 55.2177 34.9908 54.5528 34.6583ZM13.9227 54.8858C14.3783 53.7469 15.4814 53 16.7081 53H39.2919C40.5186 53 41.6217 53.7469 42.0773 54.8858L42.523 56H13.477L13.9227 54.8858Z" clip-rule="evenodd"></path>
              </g>
            </g>
            <defs>
              <linearGradient id="paint0_linear_4229_1803" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint1_linear_4229_1803" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint2_linear_4229_1803" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint3_linear_4229_1803" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
            </defs>
          </svg>
        </div>
      </div>
      
      <div class="menu-card scale-on-hover fade-in-up" 
           data-text="发布任务" 
           @click="showUnavailable('task')"
           style="animation-delay: 0.2s">
        <div class="icon-wrapper">
          <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="none" viewBox="0 0 64 64" id="competitor-analysis">
            <g>
              <g>
                <path fill="url(#paint0_linear_4229_2234)" d="M12 11C12 11.5523 11.5523 12 11 12C10.4477 12 10 11.5523 10 11C10 10.4477 10.4477 10 11 10C11.5523 10 12 10.4477 12 11Z"></path>
                <path fill="url(#paint1_linear_4229_2234)" d="M15 12C15.5523 12 16 11.5523 16 11C16 10.4477 15.5523 10 15 10C14.4477 10 14 10.4477 14 11C14 11.5523 14.4477 12 15 12Z"></path>
                <path fill="url(#paint2_linear_4229_2234)" d="M20 11C20 11.5523 19.5523 12 19 12C18.4477 12 18 11.5523 18 11C18 10.4477 18.4477 10 19 10C19.5523 10 20 10.4477 20 11Z"></path>
                <path fill="url(#paint3_linear_4229_2234)" fill-rule="evenodd" d="M22 23C22 23.9064 21.7588 24.7564 21.3372 25.4895C22.9568 26.4004 24 28.1282 24 30.0438V36C24 36.5523 23.5523 37 23 37H11C10.4477 37 10 36.5523 10 36V30.0438C10 28.1282 11.0432 26.4004 12.6628 25.4895C12.2412 24.7564 12 23.9064 12 23C12 20.2386 14.2386 18 17 18C19.7614 18 22 20.2386 22 23ZM20 23C20 24.6569 18.6569 26 17 26C15.3431 26 14 24.6569 14 23C14 21.3431 15.3431 20 17 20C18.6569 20 20 21.3431 20 23ZM17 28C18.1022 28 19.1211 27.6434 19.9476 27.0392C21.1771 27.5186 22 28.7071 22 30.0438V35H12V30.0438C12 28.7072 12.8229 27.5186 14.0524 27.0392C14.8789 27.6434 15.8978 28 17 28Z" clip-rule="evenodd"></path>
                <path fill="url(#paint4_linear_4229_2234)" fill-rule="evenodd" d="M37 18C31.4772 18 27 22.4772 27 28C27 33.5228 31.4772 38 37 38C39.4013 38 41.6049 37.1536 43.3287 35.7429L44.3536 36.7678L44 37.1214C43.2189 37.9025 43.2189 39.1688 44 39.9499L48.2426 44.1925C49.0237 44.9735 50.29 44.9735 51.0711 44.1925L53.1924 42.0712C53.9734 41.2901 53.9734 40.0238 53.1924 39.2428L48.9497 35.0001C48.1687 34.2191 46.9024 34.2191 46.1213 35.0001L45.7678 35.3536L44.7429 34.3287C46.1536 32.6049 47 30.4013 47 28C47 22.4772 42.5228 18 37 18ZM29 28C29 23.5817 32.5817 20 37 20C41.4183 20 45 23.5817 45 28C45 32.4183 41.4183 36 37 36C32.5817 36 29 32.4183 29 28ZM45.4142 38.5356L47.5355 36.4143L51.7782 40.657L49.6569 42.7783L45.4142 38.5356Z" clip-rule="evenodd"></path>
                <path fill="url(#paint5_linear_4229_2234)" fill-rule="evenodd" d="M12 47C12 46.4477 12.4477 46 13 46H16C16.5523 46 17 46.4477 17 47V51H18V42C18 41.4477 18.4477 41 19 41H22C22.5523 41 23 41.4477 23 42V51H24V44C24 43.4477 24.4477 43 25 43H28C28.5523 43 29 43.4477 29 44V51H30V41C30 40.4477 30.4477 40 31 40H34C34.5523 40 35 40.4477 35 41V51H36V43C36 42.4477 36.4477 42 37 42H40C40.5523 42 41 42.4477 41 43V51H42C42.5523 51 43 51.4477 43 52C43 52.5523 42.5523 53 42 53H11C10.4477 53 10 52.5523 10 52C10 51.4477 10.4477 51 11 51H12V47ZM14 51H15V48H14V51ZM20 51H21V43H20V51ZM26 51H27V45H26V51ZM32 51H33V42H32V51ZM38 51H39V44H38V51Z" clip-rule="evenodd"></path>
                <path fill="url(#paint6_linear_4229_2234)" fill-rule="evenodd" d="M11 6C8.23858 6 6 8.23857 6 11V53C6 55.7614 8.23857 58 11 58H53C55.7614 58 58 55.7614 58 53V11C58 8.23858 55.7614 6 53 6H11ZM56 14V11C56 9.34315 54.6569 8 53 8H11C9.34315 8 8 9.34314 8 11V14H56ZM8 16H56V53C56 54.6569 54.6569 56 53 56H11C9.34314 56 8 54.6569 8 53V16Z" clip-rule="evenodd"></path>
              </g>
            </g>
            <defs>
              <linearGradient id="paint0_linear_4229_2234" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint1_linear_4229_2234" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint2_linear_4229_2234" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint3_linear_4229_2234" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint4_linear_4229_2234" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint5_linear_4229_2234" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint6_linear_4229_2234" x1="-6" x2="68" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
            </defs>
          </svg>
        </div>
      </div>
      
      <div class="menu-card scale-on-hover fade-in-up" 
           data-text="发布活动" 
           @click="showUnavailable('activity')"
           style="animation-delay: 0.3s">
        <div class="icon-wrapper">
          <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="none" viewBox="0 0 64 64" id="customer-segmentation">
            <g>
              <g>
                <path fill="url(#paint0_linear_4229_1994)" fill-rule="evenodd" d="M22 21C22 21.3561 21.9379 21.6977 21.8241 22.0147C23.1847 22.9459 24 24.4893 24 26.1408V27C24 28.6569 22.6569 30 21 30H17C15.3431 30 14 28.6569 14 27V26.1408C14 24.4893 14.8153 22.9459 16.1759 22.0147C16.0621 21.6977 16 21.3561 16 21C16 19.3431 17.3431 18 19 18C20.6569 18 22 19.3431 22 21ZM19 22C19.5523 22 20 21.5523 20 21C20 20.4477 19.5523 20 19 20C18.4477 20 18 20.4477 18 21C18 21.5523 18.4477 22 19 22ZM19 24C19.5674 24 20.098 23.8425 20.5504 23.5688L20.6641 23.6446C21.4987 24.201 22 25.1377 22 26.1408V27C22 27.5523 21.5523 28 21 28H17C16.4477 28 16 27.5523 16 27V26.1408C16 25.1377 16.5013 24.201 17.3359 23.6446L17.4496 23.5688C17.902 23.8425 18.4326 24 19 24Z" clip-rule="evenodd"></path>
                <path fill="url(#paint1_linear_4229_1994)" fill-rule="evenodd" d="M22 37C22 37.3561 21.9379 37.6978 21.8241 38.0147C23.1847 38.9459 24 40.4893 24 42.1408V43C24 44.6569 22.6569 46 21 46H17C15.3431 46 14 44.6569 14 43V42.1408C14 40.4893 14.8153 38.9459 16.1759 38.0147C16.0621 37.6978 16 37.3561 16 37C16 35.3431 17.3431 34 19 34C20.6569 34 22 35.3431 22 37ZM19 38C19.5523 38 20 37.5523 20 37C20 36.4477 19.5523 36 19 36C18.4477 36 18 36.4477 18 37C18 37.5523 18.4477 38 19 38ZM19 40C19.5674 40 20.098 39.8425 20.5504 39.5688L20.6641 39.6446C21.4987 40.201 22 41.1377 22 42.1408V43C22 43.5523 21.5523 44 21 44H17C16.4477 44 16 43.5523 16 43V42.1408C16 41.1377 16.5013 40.201 17.3359 39.6446L17.4496 39.5688C17.902 39.8425 18.4326 40 19 40Z" clip-rule="evenodd"></path>
                <path fill="url(#paint2_linear_4229_1994)" fill-rule="evenodd" d="M29.6638 6.43019C29.8776 6.61997 30 6.8922 30 7.17811V56.8218C30 57.1077 29.8776 57.3799 29.6638 57.5697C29.45 57.7595 29.1651 57.8487 28.8813 57.8147C15.9918 56.2733 6 45.3042 6 32C6 18.6957 15.9918 7.72666 28.8813 6.18518C29.1651 6.15123 29.45 6.24041 29.6638 6.43019ZM28 8.33164C16.6495 10.2354 8 20.1083 8 32C8 43.8916 16.6495 53.7645 28 55.6683V8.33164Z" clip-rule="evenodd"></path>
                <path fill="url(#paint3_linear_4229_1994)" fill-rule="evenodd" d="M45.8241 18.0147C45.938 17.6977 46 17.3561 46 17C46 15.3431 44.6569 14 43 14C41.3431 14 40 15.3431 40 17C40 17.3561 40.062 17.6977 40.1759 18.0147C38.8153 18.9459 38 20.4893 38 22.1408V23C38 24.6569 39.3431 26 41 26H45C46.6569 26 48 24.6569 48 23V22.1408C48 20.4893 47.1847 18.9459 45.8241 18.0147ZM44 17C44 17.5523 43.5523 18 43 18C42.4477 18 42 17.5523 42 17C42 16.4477 42.4477 16 43 16C43.5523 16 44 16.4477 44 17ZM44.5504 19.5688C44.098 19.8425 43.5674 20 43 20C42.4326 20 41.902 19.8425 41.4496 19.5688L41.3359 19.6446C40.5013 20.201 40 21.1377 40 22.1408V23C40 23.5523 40.4477 24 41 24H45C45.5523 24 46 23.5523 46 23V22.1408C46 21.1377 45.4987 20.201 44.6641 19.6446L44.5504 19.5688Z" clip-rule="evenodd"></path>
                <path fill="url(#paint4_linear_4229_1994)" fill-rule="evenodd" d="M34.3362 6.43019C34.55 6.24041 34.8349 6.15123 35.1187 6.18518C46.986 7.60441 56.3955 17.0139 57.8148 28.8812C57.8487 29.1651 57.7595 29.4499 57.5698 29.6638C57.38 29.8776 57.1077 30 56.8218 30H35C34.4477 30 34 29.5522 34 29V7.17811C34 6.8922 34.1224 6.61997 34.3362 6.43019ZM36 8.33164V28H55.6683C53.9827 17.9506 46.0494 10.0172 36 8.33164Z" clip-rule="evenodd"></path>
                <path fill="url(#paint5_linear_4229_1994)" fill-rule="evenodd" d="M45.8241 42.0147C45.938 41.6978 46 41.3561 46 41C46 39.3431 44.6569 38 43 38C41.3431 38 40 39.3431 40 41C40 41.3561 40.062 41.6978 40.1759 42.0147C38.8153 42.9459 38 44.4893 38 46.1408V47C38 48.6569 39.3431 50 41 50H45C46.6569 50 48 48.6569 48 47V46.1408C48 44.4893 47.1847 42.9459 45.8241 42.0147ZM44 41C44 41.5523 43.5523 42 43 42C42.4477 42 42 41.5523 42 41C42 40.4477 42.4477 40 43 40C43.5523 40 44 40.4477 44 41ZM44.5504 43.5688C44.098 43.8425 43.5674 44 43 44C42.4326 44 41.902 43.8425 41.4496 43.5688L41.3359 43.6446C40.5013 44.201 40 45.1377 40 46.1408V47C40 47.5523 40.4477 48 41 48H45C45.5523 48 46 47.5523 46 47V46.1408C46 45.1377 45.4987 44.201 44.6641 43.6446L44.5504 43.5688Z" clip-rule="evenodd"></path>
                <path fill="url(#paint6_linear_4229_1994)" fill-rule="evenodd" d="M34.2929 34.2928C34.4804 34.1053 34.7348 34 35 34H56.8218C57.1077 34 57.38 34.1223 57.5698 34.3362C57.7595 34.55 57.8487 34.8348 57.8148 35.1187C56.3955 46.986 46.986 56.3955 35.1187 57.8147C34.8349 57.8487 34.55 57.7595 34.3362 57.5697C34.1224 57.3799 34 57.1077 34 56.8218L34 35C34 34.7347 34.1054 34.4804 34.2929 34.2928ZM36 36L36 55.6683C46.0494 53.9827 53.9827 46.0493 55.6683 36H36Z" clip-rule="evenodd"></path>
              </g>
            </g>
            <defs>
              <linearGradient id="paint0_linear_4229_1994" x1="-5.959" x2="67.788" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint1_linear_4229_1994" x1="-5.959" x2="67.788" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint2_linear_4229_1994" x1="-5.959" x2="67.788" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint3_linear_4229_1994" x1="-5.959" x2="67.788" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint4_linear_4229_1994" x1="-5.959" x2="67.788" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint5_linear_4229_1994" x1="-5.959" x2="67.788" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
              <linearGradient id="paint6_linear_4229_1994" x1="-5.959" x2="67.788" y1="32" y2="32" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FFCC70"></stop>
                <stop offset=".5" stop-color="#C850C0"></stop>
                <stop offset="1" stop-color="#4138D0"></stop>
              </linearGradient>
            </defs>
          </svg>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import TextGenerateEffect from '../../common/TextGenerateEffect.vue';

const emit = defineEmits(['navigate', 'show-unavailable']);
const subtitleEffect = ref<InstanceType<typeof TextGenerateEffect> | null>(null);

const goToWorkType = () => {
  emit('navigate', 'workType');
}

const showUnavailable = (type: string) => {
  emit('show-unavailable', type);
}

onMounted(() => {
  // Start subtitle animation after main title (with shorter delay)
  setTimeout(() => {
    if (subtitleEffect.value) {
      subtitleEffect.value.startAnimation();
    }
  }, 800);
});
</script>

<style scoped>
.start-page {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px 20px 40px;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.header {
  text-align: center;
  margin-bottom: 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

.main-title {
  font-size: 36px;
  margin-bottom: 8px;
  color: #ffffff;
  text-shadow: 0 0 20px rgba(140, 232, 255, 0.6);
  display: inline-block;
  font-weight: bold;
  line-height: 1.2;
}

.subtitle-zh {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
  margin-top: 2px;
  line-height: 1.2;
}

.menu-options {
  display: flex;
  justify-content: center;
  gap: 40px;
  flex-wrap: wrap;
  margin-top: 80px;
}

.menu-card {
  width: 200px;
  height: 200px;
  background: rgba(20, 25, 45, 0.7);
  border-radius: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  position: relative;
  backdrop-filter: blur(10px);
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
}

.menu-card:hover {
  transform: translateY(-5px) scale(1.05);
  background: rgba(41, 50, 81, 0.8);
  box-shadow: 
    0 15px 35px rgba(0, 0, 0, 0.4),
    0 0 25px rgba(114, 137, 218, 0.4);
  border-color: rgba(114, 137, 218, 0.4);
}

.menu-card::after {
  content: attr(data-text);
  position: absolute;
  bottom: -35px;
  font-size: 18px;
  color: white;
  font-weight: 500;
  text-shadow: 0 2px 5px rgba(0, 0, 0, 0.5);
  transition: all 0.3s ease;
}

.menu-card:hover::after {
  transform: translateY(-5px);
  color: rgba(140, 232, 255, 1);
  text-shadow: 0 0 10px rgba(114, 137, 218, 0.8);
}

.icon-wrapper {
  width: 140px;
  height: 140px;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  transition: all 0.3s ease;
}

.icon-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  transition: transform 0.3s ease;
  filter: drop-shadow(0 0 5px rgba(140, 232, 255, 0.2));
}

.menu-card:hover .icon-wrapper {
  filter: drop-shadow(0 0 15px rgba(140, 232, 255, 0.5));
}

.menu-card:hover .icon-image {
  transform: scale(1.1);
}

@media (max-width: 768px) {
  .menu-options {
    flex-direction: column;
    align-items: center;
  }
  
  .menu-card {
    width: 180px;
    height: 180px;
  }
  
  .icon-wrapper {
    width: 120px;
    height: 120px;
  }
}
</style> 