# 提交 PR 的步骤

以下是将代码改动提交 PR 并同步到远端的步骤：

## 1. 确认远程仓库设置

确保你的 Git 仓库已经正确设置了远程仓库。如果没有，请运行以下命令：

```bash
# 设置远程仓库（请替换为您的实际仓库地址）
git remote add origin https://github.com/your-username/your-repo.git

# 验证远程仓库设置
git remote -v
```

## 2. 推送代码到远程分支

将代码推送到远程仓库：

```bash
# 推送代码优化分支到远程
git push -u origin code-optimization
```

## 3. 创建 Pull Request

1. 打开您的远程仓库网页（例如 GitHub）
2. 点击 "Compare & pull request" 按钮
3. 填写 PR 标题和说明，推荐的标题："优化 WeChat 风格聊天界面的代码结构"
4. 在 PR 描述中包含以下内容：

```
本次 PR 主要对 WeChat 风格的聊天界面进行代码优化，主要改进如下：

- 将 App.vue 拆分为多个专注于特定功能的组件
- 创建可复用的通用组件，如 NavigationButtons、Modal 和 TabsContainer
- 添加实用工具函数，如 debounce/throttle 和格式化函数
- 优化代码结构以提高可维护性和可读性

详细的更改说明请参见 REFACTOR_README.md 文件。
```

5. 点击 "Create pull request" 按钮

## 4. 后续跟进

- 回复 PR 中的任何评论和反馈
- 根据需要进行必要的调整
- 待 PR 被批准后，它将被合并到主分支中

## 注意事项

- 确保代码已经经过测试，并且所有功能正常运行
- 将 `.bak` 和临时文件排除在 PR 之外
- 如果有冲突，请在本地解决后再次推送 