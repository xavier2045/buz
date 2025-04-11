import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useThemeStore = defineStore('theme', () => {
  const blurAmount = ref(40)
  const bgOpacity = ref(0.16)
  const borderColor = ref('255, 255, 255')
  const borderOpacity = ref(0.38)
  const borderRadius = ref(6)
  
  function setBorderColor(color: string) {
    borderColor.value = color
  }
  
  function setBgOpacity(opacity: number) {
    bgOpacity.value = opacity
  }
  
  function setBlurAmount(amount: number) {
    blurAmount.value = amount
  }
  
  function setBorderOpacity(opacity: number) {
    borderOpacity.value = opacity
  }
  
  function setBorderRadius(radius: number) {
    borderRadius.value = radius
  }
  
  function resetToDefaults() {
    blurAmount.value = 40
    bgOpacity.value = 0.16
    borderColor.value = '255, 255, 255'
    borderOpacity.value = 0.38
    borderRadius.value = 6
  }
  
  return {
    blurAmount,
    bgOpacity,
    borderColor,
    borderOpacity,
    borderRadius,
    setBorderColor,
    setBgOpacity,
    setBlurAmount,
    setBorderOpacity,
    setBorderRadius,
    resetToDefaults
  }
}) 