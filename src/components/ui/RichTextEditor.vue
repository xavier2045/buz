<template>
  <div class="rich-text-editor">
    <!-- 编辑器工具栏 -->
    <div class="editor-toolbar">
      <!-- 文本样式按钮 -->
      <button 
        v-for="(btn, index) in toolbarButtons" 
        :key="index"
        class="toolbar-btn"
        :class="{ active: btn.isActive }"
        :title="btn.title"
        @click="executeCommand(btn.command, btn.value)"
      >
        <span v-html="btn.icon"></span>
      </button>
    </div>
    
    <!-- 编辑区域 -->
    <div 
      class="editor-content"
      :class="{ 'focused': isFocused }"
      ref="editorContent"
      contenteditable="true"
      @input="updateContent"
      @focus="isFocused = true"
      @blur="isFocused = false"
      v-html="modelValue"
    ></div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';

// 从父组件获取model值
const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  placeholder: {
    type: String,
    default: '添加描述...'
  }
});

// 定义emit事件
const emit = defineEmits(['update:modelValue']);

// 编辑器状态
const isFocused = ref(false);
const editorContent = ref<HTMLDivElement | null>(null);

// 工具栏按钮定义
const toolbarButtons = ref([
  {
    title: '粗体',
    command: 'bold',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path><path d="M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path></svg>',
    isActive: false,
    value: null
  },
  {
    title: '斜体',
    command: 'italic',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="4" x2="10" y2="4"></line><line x1="14" y1="20" x2="5" y2="20"></line><line x1="15" y1="4" x2="9" y2="20"></line></svg>',
    isActive: false,
    value: null
  },
  {
    title: '下划线',
    command: 'underline',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 3v7a6 6 0 0 0 6 6 6 6 0 0 0 6-6V3"></path><line x1="4" y1="21" x2="20" y2="21"></line></svg>',
    isActive: false,
    value: null
  },
  {
    title: '标题',
    command: 'formatBlock',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 12h12"></path><path d="M6 6h12"></path><path d="M6 18h12"></path></svg>',
    isActive: false,
    value: 'h2'
  },
  {
    title: '引用',
    command: 'formatBlock',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 6H3"></path><path d="M21 12H8"></path><path d="M21 18H8"></path><path d="M3 12v6"></path></svg>',
    isActive: false,
    value: 'blockquote'
  },
  {
    title: '列表',
    command: 'insertUnorderedList',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>',
    isActive: false,
    value: null
  },
  {
    title: '链接',
    command: 'createLink',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path></svg>',
    isActive: false,
    value: null
  },
  {
    title: '清除格式',
    command: 'removeFormat',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M15 12H3"></path><path d="M9 18H3"></path><path d="M11 3L8 21"></path></svg>',
    isActive: false,
    value: null
  }
]);

// 监听props.modelValue的变化，更新编辑器内容
watch(() => props.modelValue, (newValue) => {
  if (editorContent.value && editorContent.value.innerHTML !== newValue) {
    editorContent.value.innerHTML = newValue;
  }
});

// 组件挂载后的操作
onMounted(() => {
  if (editorContent.value) {
    // 如果没有内容，添加placeholder
    if (!props.modelValue && props.placeholder) {
      editorContent.value.innerHTML = `<div class="placeholder">${props.placeholder}</div>`;
    }
    
    // 监听编辑器区域的点击事件
    editorContent.value.addEventListener('click', () => {
      // 如果内容只有placeholder，则清空
      if (editorContent.value && editorContent.value.querySelector('.placeholder')) {
        editorContent.value.innerHTML = '';
      }
    });
  }
});

// 执行命令
const executeCommand = (command: string, value: any = null) => {
  // 确保编辑器获得焦点
  if (editorContent.value) {
    editorContent.value.focus();
  }
  
  // 特殊命令处理
  if (command === 'createLink') {
    const url = prompt('请输入链接URL:', 'https://');
    if (url) {
      document.execCommand(command, false, url);
    }
  } else {
    // 普通命令执行
    document.execCommand(command, false, value);
  }
  
  // 更新内容
  updateContent();
};

// 更新内容
const updateContent = () => {
  if (editorContent.value) {
    // 移除可能存在的placeholder
    const placeholder = editorContent.value.querySelector('.placeholder');
    if (placeholder) {
      placeholder.remove();
    }
    
    // 更新父组件的值
    emit('update:modelValue', editorContent.value.innerHTML);
  }
};

// 插入水平线
const insertHorizontalRule = () => {
  if (editorContent.value) {
    editorContent.value.focus();
    document.execCommand('insertHorizontalRule');
    updateContent();
  }
};
</script>

<style scoped>
.rich-text-editor {
  width: 100%;
  border-radius: 8px;
  overflow: hidden;
  background: rgba(30, 30, 35, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s;
}

.rich-text-editor:hover {
  border-color: rgba(255, 255, 255, 0.2);
}

.editor-toolbar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px;
  background: rgba(20, 20, 25, 0.4);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  flex-wrap: wrap;
}

.toolbar-btn {
  width: 32px;
  height: 32px;
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.7);
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.toolbar-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.toolbar-btn.active {
  background: rgba(74, 144, 226, 0.3);
  color: rgb(74, 144, 226);
}

.editor-content {
  min-height: 150px;
  padding: 15px;
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.6;
  outline: none;
  overflow-y: auto;
  max-height: 400px;
}

.editor-content.focused {
  border-color: rgba(74, 144, 226, 0.5);
}

.editor-content .placeholder {
  color: rgba(255, 255, 255, 0.4);
  pointer-events: none;
}

/* 富文本内容的样式 */
.editor-content :deep(h1),
.editor-content :deep(h2),
.editor-content :deep(h3) {
  margin-top: 1em;
  margin-bottom: 0.5em;
  font-weight: 600;
}

.editor-content :deep(h1) {
  font-size: 1.5em;
}

.editor-content :deep(h2) {
  font-size: 1.3em;
}

.editor-content :deep(h3) {
  font-size: 1.1em;
}

.editor-content :deep(blockquote) {
  border-left: 3px solid rgba(74, 144, 226, 0.7);
  margin: 1em 0;
  padding-left: 1em;
  color: rgba(255, 255, 255, 0.7);
  font-style: italic;
}

.editor-content :deep(a) {
  color: rgb(74, 144, 226);
  text-decoration: none;
}

.editor-content :deep(a:hover) {
  text-decoration: underline;
}

.editor-content :deep(ul),
.editor-content :deep(ol) {
  margin: 1em 0;
  padding-left: 2em;
}

.editor-content :deep(li) {
  margin-bottom: 0.5em;
}

.editor-content :deep(p) {
  margin: 0.8em 0;
}
</style> 