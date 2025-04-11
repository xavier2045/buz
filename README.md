# Blur Container Component

A Vue 3 component that creates a container with a blur effect background, adapting to its parent container's size.

## Features

- Automatically adapts to parent container size
- Customizable blur effect
- Adjustable background opacity
- Customizable border color and opacity
- Integrated with Pinia for state management

## Technology Stack

- Vue 3
- TypeScript
- Pinia for state management
- Vite for build tooling

## Component Props

| Prop           | Type   | Default        | Description                      |
|----------------|--------|----------------|----------------------------------|
| blurAmount     | number | 40             | Blur intensity in pixels         |
| bgOpacity      | number | 0.16           | Background opacity (0-1)         |
| borderColor    | string | "255, 255, 255"| Border color in RGB format       |
| borderOpacity  | number | 0.38           | Border opacity (0-1)             |

## Usage

```vue
<template>
  <div class="parent-container">
    <BlurContainer 
      :blurAmount="40" 
      :bgOpacity="0.16"
      borderColor="255, 255, 255"
      :borderOpacity="0.38"
    >
      <div>Your content here</div>
    </BlurContainer>
  </div>
</template>

<script setup lang="ts">
import BlurContainer from './path/to/BlurContainer.vue'
</script>

<style>
.parent-container {
  width: 500px;
  height: 300px;
}
</style>
```

## Using with Pinia Store

The component works seamlessly with Pinia state management:

```vue
<template>
  <BlurContainer
    :blurAmount="themeStore.blurAmount"
    :bgOpacity="themeStore.bgOpacity"
    :borderColor="themeStore.borderColor"
    :borderOpacity="themeStore.borderOpacity"
  >
    <div>Content with store-controlled styling</div>
  </BlurContainer>
</template>

<script setup lang="ts">
import BlurContainer from './path/to/BlurContainer.vue'
import { useThemeStore } from './path/to/store/theme'

const themeStore = useThemeStore()
</script>
```

## Installation

1. Clone the repository
2. Install dependencies: `npm install`
3. Run the development server: `npm run dev` 