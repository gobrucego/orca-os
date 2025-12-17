# Workshop CLI 快速开始指南

## 1. 安装

```bash
# 进入 orca-os 项目目录
cd /path/to/orca-os

# 安装 Workshop CLI
pip install -e mcp/workshop-cli

# 验证安装
claude-workshop --version
# 输出: claude-workshop 0.1.0
```

## 2. 在任意项目中使用

### 2.1 初始化项目记忆

```bash
# 进入你的项目目录
cd /path/to/your-project

# 初始化 Workshop 数据库
claude-workshop init
# 创建: .claude/memory/workshop.db
```

### 2.2 记录决策

```bash
# 记录架构决策（必须包含原因）
claude-workshop decision "使用 PostgreSQL 作为主数据库" -r "支持复杂查询，有良好的扩展性"

# 带域名和标签
claude-workshop decision "[backend] 使用 Redis 缓存" -r "高性能内存存储" -t cache -t performance
```

### 2.3 记录注意事项

```bash
# 记录坑/警告
claude-workshop gotcha "不要在循环中调用 API" -t performance

# 带域名前缀
claude-workshop gotcha "[security] JWT token 必须设置过期时间" -t auth
```

### 2.4 添加笔记

```bash
claude-workshop note "用户偏好使用 TypeScript"
```

### 2.5 查询决策（核心功能）

```bash
# 查询为什么做某个决策
claude-workshop why "数据库"
claude-workshop why "缓存"

# JSON 输出（用于程序集成）
claude-workshop why "认证" --json
```

### 2.6 搜索所有记录

```bash
claude-workshop search "性能"
claude-workshop search "api" --type gotcha
```

### 2.7 查看最近记录

```bash
claude-workshop recent
claude-workshop recent --limit 20
```

### 2.8 查看上下文摘要

```bash
claude-workshop context
```

## 3. 与 Claude Code 集成

### 3.1 自动集成（推荐）

如果你使用 orca-os 的配置，Session Hooks 会自动：
- **会话开始时**: 加载 Workshop 上下文
- **会话结束时**: 从 JSONL 日志导入决策

### 3.2 手动使用

在 Claude Code 会话中，可以让 Claude 执行：

```bash
# 查询之前的决策
claude-workshop why "路由"

# 记录新决策
claude-workshop decision "使用 App Router" -r "Next.js 推荐，性能更好"

# 查看上下文
claude-workshop context
```

## 4. 项目结构

```
your-project/
├── .claude/
│   └── memory/
│       └── workshop.db    # Workshop 数据库
├── src/
└── ...
```

## 5. 常用工作流

### 开始新会话
```bash
claude-workshop context     # 查看之前的上下文
claude-workshop recent      # 查看最近活动
```

### 做出决策时
```bash
claude-workshop why "相关主题"  # 先查询之前的决策
claude-workshop decision "新决策" -r "原因"  # 记录新决策
```

### 遇到问题时
```bash
claude-workshop gotcha "问题描述" -t 相关标签
```

### 结束会话前
```bash
claude-workshop context     # 确认记录完整
```

## 6. 数据库管理

```bash
# 查看统计
claude-workshop info

# 查看所有条目
claude-workshop read

# 按类型查看
claude-workshop read -t decision --full

# 删除条目
claude-workshop delete <id>
```

## 7. 导入历史记录

```bash
# 预览（不实际导入）
claude-workshop import

# 执行导入
claude-workshop import --execute
```
