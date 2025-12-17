# Workshop CLI 功能验证文档

**版本:** 0.1.0
**日期:** 2025-12-17
**状态:** 实现完成

---

## 目录

1. [安装验证](#1-安装验证)
2. [CLI 命令验证](#2-cli-命令验证)
3. [集成验证](#3-集成验证)
4. [端到端工作流验证](#4-端到端工作流验证)
5. [验证检查清单](#5-验证检查清单)

---

## 1. 安装验证

### 1.1 安装 Workshop CLI

```bash
# 进入项目目录
cd /path/to/orca-os

# 开发模式安装
pip install -e mcp/workshop-cli

# 验证安装成功
claude-workshop --version
```

**预期输出:**
```
claude-workshop 0.1.0
```

### 1.2 验证依赖

```bash
# 检查依赖是否安装
pip show click rich
```

**预期:** 显示 click>=8.0 和 rich>=13.0 的包信息

### 1.3 验证命令可用

```bash
claude-workshop --help
```

**预期输出:**
```
Usage: claude-workshop [OPTIONS] COMMAND [ARGS]...

  claude-workshop: Persistent project memory for Claude Code sessions.

Options:
  -w, --workspace TEXT  Path to workshop workspace (default: .claude/memory)
  --version             Show version
  --help                Show this message and exit.

Commands:
  context   Get session context summary.
  decision  Record an architectural decision.
  delete    Delete an entry by ID.
  gotcha    Record a gotcha/warning/pitfall.
  import    Import from JSONL transcripts.
  info      Show database info and statistics.
  init      Initialize workshop database.
  note      Add a general note.
  read      Read entries with optional filters.
  recent    Show recent entries.
  search    Search all entries.
  why       Query past decisions (THE KILLER FEATURE).
```

---

## 2. CLI 命令验证

### 2.1 初始化数据库 (init)

```bash
# 确保在项目根目录
cd /path/to/your-project

# 初始化数据库
claude-workshop init
```

**预期输出:**
```
Created workshop database at /path/to/your-project/.claude/memory/workshop.db
```

**验证:**
```bash
ls -la .claude/memory/workshop.db
```

### 2.2 记录决策 (decision)

```bash
# 基本决策
claude-workshop decision "Use PostgreSQL for production database" -r "Better performance for complex queries, good ecosystem support"

# 带标签的决策
claude-workshop decision "[backend] Use Redis for caching" -r "Fast in-memory store, supports pub/sub" -t cache -t performance

# 带域名前缀的决策
claude-workshop decision "[frontend] Use React 18 with Server Components" -r "Better performance, streaming SSR support" -t react -t architecture
```

**预期输出:**
```
Decision recorded (ID: X)
```

### 2.3 记录注意事项 (gotcha)

```bash
# 基本 gotcha
claude-workshop gotcha "Never store passwords in plain text"

# 带标签的 gotcha
claude-workshop gotcha "API rate limits apply to all endpoints - max 100 req/min" -t api -t limits

# 带域名前缀
claude-workshop gotcha "[security] Always validate JWT tokens on every request" -t auth
```

**预期输出:**
```
Gotcha recorded (ID: X)
```

### 2.4 添加笔记 (note)

```bash
# 基本笔记
claude-workshop note "User prefers minimal dependencies in the project"

# 带标签的笔记
claude-workshop note "Deploy to staging every Friday for QA testing" --tags deployment --tags process
```

**预期输出:**
```
Note recorded (ID: X)
```

### 2.5 查询决策 (why) - 核心功能

```bash
# 基本查询
claude-workshop why "database"

# JSON 输出
claude-workshop why "caching" --json

# 限制结果数量
claude-workshop why "performance" --limit 5
```

**预期输出 (文本模式):**
```
Decisions matching 'database':

  [2025-12-17] [backend] Use PostgreSQL for production database
    Reason: Better performance for complex queries, good ecosystem support
```

**预期输出 (JSON 模式):**
```json
[
  {
    "id": 1,
    "type": "decision",
    "content": "Use PostgreSQL for production database",
    "reasoning": "Better performance for complex queries, good ecosystem support",
    "domain": "backend",
    "timestamp": "2025-12-17T10:00:00.000000Z",
    "tags": ["cache", "performance"]
  }
]
```

### 2.6 搜索所有条目 (search)

```bash
# 搜索所有类型
claude-workshop search "security"

# 按类型过滤
claude-workshop search "api" --type gotcha

# JSON 输出
claude-workshop search "performance" --json --limit 10
```

**预期输出:**
```
Results for 'security':

  [2025-12-17] gotcha [security] Always validate JWT tokens on every request
  [2025-12-17] gotcha Never store passwords in plain text
```

### 2.7 查看最近条目 (recent)

```bash
# 默认显示 10 条
claude-workshop recent

# 指定数量
claude-workshop recent --limit 20
```

**预期输出:**
```
Recent Entries:

Decisions:
  [2025-12-17] [backend] Use PostgreSQL for production database
  [2025-12-17] [frontend] Use React 18 with Server Components

Gotchas:
  [2025-12-17] [security] Always validate JWT tokens on every request
  [2025-12-17] Never store passwords in plain text

Notes:
  [2025-12-17] User prefers minimal dependencies in the project
```

### 2.8 获取上下文摘要 (context)

```bash
claude-workshop context
```

**预期输出:**
```
Workshop Context Summary

Total entries: X
  - decisions: X
  - gotchas: X
  - notes: X

Recent Decisions:
  - [backend] Use PostgreSQL for production database
  - [frontend] Use React 18 with Server Components

Active Gotchas:
  - [security] Always validate JWT tokens on every request
  - Never store passwords in plain text

Latest Activity:
  [2025-12-17 10:00] decision: Use PostgreSQL for production database
  [2025-12-17 10:01] gotcha: Never store passwords in plain text
```

### 2.9 数据库信息 (info)

```bash
claude-workshop info
```

**预期输出:**
```
Workshop Database Info

Database: /path/to/.claude/memory/workshop.db
Total entries: X

Entries by type:
  decision: X
  gotcha: X
  note: X

Recent imports:
  (none or list of imported files)
```

### 2.10 读取条目 (read)

```bash
# 读取所有条目
claude-workshop read

# 按类型过滤
claude-workshop read -t decision

# 显示完整内容
claude-workshop read -t gotcha --full --limit 20
```

**预期输出:**
```
                                  Entries (X)
┏━━━━━━━━┳━━━━━━━━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ID     ┃ Date         ┃ Type       ┃ Content                                 ┃
┡━━━━━━━━╇━━━━━━━━━━━━━━╇━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
│ 1      │ 2025-12-17   │ decision   │ Use PostgreSQL for production database  │
│ 2      │ 2025-12-17   │ gotcha     │ Never store passwords in plain text     │
└────────┴──────────────┴────────────┴─────────────────────────────────────────┘
```

### 2.11 删除条目 (delete)

```bash
# 删除指定 ID 的条目
claude-workshop delete 5
```

**预期输出:**
```
Entry to delete:
  ID: 5
  Type: note
  Content: Some test note

Delete this entry? [y/N]: y
Entry 5 deleted.
```

### 2.12 导入 JSONL (import)

```bash
# 预览模式（不实际导入）
claude-workshop import

# 执行导入
claude-workshop import --execute

# 从指定路径导入
claude-workshop import --path ~/.claude/projects/ --execute
```

**预期输出 (预览模式):**
```
Import preview (use --execute to import):
  Files found: X
  Files to skip: X
  Entries to import: X

  Details:
    /path/to/transcript.jsonl
      X entries ({'decision': X, 'gotcha': X, 'note': X})
```

---

## 3. 集成验证

### 3.1 Session Start Hook 验证

```bash
# 运行 session-start hook
bash hooks/session-start.sh
```

**预期输出包含:**
```
SessionStart:startup hook success: SessionStart context written: .claude/orchestration/temp/session-context.md

═══════════════════════════════════════════════════════════
PROJECT CONTEXT AUTO-LOAD
═══════════════════════════════════════════════════════════

Memory systems available:
  - Workshop: claude-workshop --workspace .claude/memory <command>
  ...

═══════════════════════════════════════════════════════════
RECENT WORKSHOP ENTRIES (last 5)
═══════════════════════════════════════════════════════════

Recent Entries:
  ...
```

**验证生成的文件:**
```bash
cat .claude/orchestration/temp/session-context.md
```

### 3.2 Session End Hook 验证

```bash
# 运行 session-end hook
bash hooks/session-end.sh
```

**预期输出:**
```
===============================================================
SESSION END
===============================================================

Workshop import: extracted content from JSONL transcripts (or skipped)
Branch: main
...

Review: claude-workshop recent
===============================================================
```

### 3.3 WorkshopClient TypeScript 验证

```bash
# 检查 TypeScript 文件是否使用正确的命令
grep "claude-workshop" mcp/project-context-server/src/workshop.ts
```

**预期输出:**
```
const cmd = `claude-workshop --workspace "${this.workspacePath}" ${args}`;
```

### 3.4 /project-memory 命令验证

```bash
# 检查命令定义是否使用正确的命令
grep "claude-workshop" commands/project-memory.md | head -5
```

**预期:** 所有引用应为 `claude-workshop` 而非 `workshop`

---

## 4. 端到端工作流验证

### 4.1 完整会话工作流

```bash
# 1. 初始化新项目
mkdir -p /tmp/test-project && cd /tmp/test-project
claude-workshop init

# 2. 模拟会话开始
echo "Session started at $(date)"

# 3. 记录决策过程
claude-workshop decision "Use TypeScript for type safety" -r "Catch errors at compile time, better IDE support" -t typescript -t dx
claude-workshop decision "[api] Use REST over GraphQL" -r "Simpler for this use case, team more familiar" -t api

# 4. 记录遇到的问题
claude-workshop gotcha "TypeScript strict mode breaks some legacy imports" -t typescript -t migration
claude-workshop gotcha "[api] Rate limiting not implemented yet - TODO" -t api -t todo

# 5. 添加笔记
claude-workshop note "User wants weekly progress reports"

# 6. 查询决策
claude-workshop why "typescript"
claude-workshop why "api" --json

# 7. 搜索所有相关条目
claude-workshop search "typescript"

# 8. 查看会话摘要
claude-workshop context

# 9. 查看数据库统计
claude-workshop info

# 10. 清理测试
cd - && rm -rf /tmp/test-project
```

### 4.2 跨会话验证

```bash
# 会话 1: 记录决策
claude-workshop decision "Use feature flags for gradual rollout" -r "Reduce risk, enable A/B testing"

# 关闭会话...

# 会话 2: 查询之前的决策
claude-workshop why "rollout"
claude-workshop why "feature flags"
```

**预期:** 会话 2 能够检索到会话 1 记录的决策

### 4.3 JSON 输出集成验证

```bash
# 验证 JSON 输出格式可被解析
claude-workshop why "database" --json | python3 -m json.tool

# 验证空结果返回空数组
claude-workshop why "nonexistent_query_xyz" --json
```

**预期:**
- 有结果时返回格式化的 JSON 数组
- 无结果时返回 `[]`

---

## 5. 验证检查清单

### 5.1 安装验证 ✅

| 检查项 | 命令 | 预期结果 | 状态 |
|--------|------|----------|------|
| 版本显示 | `claude-workshop --version` | `claude-workshop 0.1.0` | ☐ |
| 帮助显示 | `claude-workshop --help` | 显示所有命令 | ☐ |
| 依赖安装 | `pip show click rich` | 显示包信息 | ☐ |

### 5.2 核心命令验证 ✅

| 命令 | 测试用例 | 预期结果 | 状态 |
|------|----------|----------|------|
| init | `claude-workshop init` | 创建 workshop.db | ☐ |
| decision | `claude-workshop decision "test" -r "reason"` | 返回 ID | ☐ |
| gotcha | `claude-workshop gotcha "test"` | 返回 ID | ☐ |
| note | `claude-workshop note "test"` | 返回 ID | ☐ |
| why | `claude-workshop why "test"` | 返回匹配决策 | ☐ |
| why --json | `claude-workshop why "test" --json` | 返回 JSON 数组 | ☐ |
| search | `claude-workshop search "test"` | 返回匹配条目 | ☐ |
| recent | `claude-workshop recent` | 显示最近条目 | ☐ |
| context | `claude-workshop context` | 显示摘要 | ☐ |
| info | `claude-workshop info` | 显示统计 | ☐ |
| read | `claude-workshop read` | 显示表格 | ☐ |
| delete | `claude-workshop delete <id>` | 确认并删除 | ☐ |
| import | `claude-workshop import` | 显示预览 | ☐ |

### 5.3 集成验证 ✅

| 集成点 | 验证方法 | 预期结果 | 状态 |
|--------|----------|----------|------|
| session-start.sh | 运行 hook | 显示 Workshop 上下文 | ☐ |
| session-end.sh | 运行 hook | 执行导入/记录笔记 | ☐ |
| workshop.ts | grep 命令名 | 使用 claude-workshop | ☐ |
| project-memory.md | grep 命令名 | 使用 claude-workshop | ☐ |
| .claude/CLAUDE.md | 检查文档 | 正确的命令引用 | ☐ |
| .claude/README.md | 检查文档 | 正确的安装说明 | ☐ |

### 5.4 数据持久化验证 ✅

| 检查项 | 验证方法 | 预期结果 | 状态 |
|--------|----------|----------|------|
| 数据库创建 | `ls .claude/memory/workshop.db` | 文件存在 | ☐ |
| 数据写入 | 记录后查询 | 数据可检索 | ☐ |
| 跨会话持久 | 关闭后重新查询 | 数据仍存在 | ☐ |
| 标签存储 | 带标签记录后搜索 | 标签正确保存 | ☐ |

### 5.5 错误处理验证 ✅

| 场景 | 测试命令 | 预期结果 | 状态 |
|------|----------|----------|------|
| 未初始化 | 在空目录运行 `why` | 提示初始化 | ☐ |
| 无匹配结果 | `why "xyz123abc"` | 显示无结果消息 | ☐ |
| JSON 无结果 | `why "xyz" --json` | 返回 `[]` | ☐ |
| 删除不存在 | `delete 99999` | 显示未找到 | ☐ |

---

## 附录: 快速验证脚本

将以下内容保存为 `verify-workshop.sh` 并运行：

```bash
#!/bin/bash
# Workshop CLI 快速验证脚本

set -e

echo "=== Workshop CLI 验证开始 ==="
echo

# 1. 版本检查
echo "1. 检查版本..."
claude-workshop --version
echo "✓ 版本检查通过"
echo

# 2. 初始化
echo "2. 初始化数据库..."
claude-workshop init 2>/dev/null || true
echo "✓ 初始化完成"
echo

# 3. 记录决策
echo "3. 记录决策..."
claude-workshop decision "Test decision for verification" -r "Verification test" -t test
echo "✓ 决策记录成功"
echo

# 4. 记录 gotcha
echo "4. 记录 gotcha..."
claude-workshop gotcha "Test gotcha for verification" -t test
echo "✓ Gotcha 记录成功"
echo

# 5. 查询决策
echo "5. 查询决策..."
claude-workshop why "verification"
echo "✓ 决策查询成功"
echo

# 6. JSON 输出
echo "6. 验证 JSON 输出..."
claude-workshop why "verification" --json | python3 -c "import sys,json; json.load(sys.stdin)"
echo "✓ JSON 输出有效"
echo

# 7. 上下文摘要
echo "7. 获取上下文..."
claude-workshop context
echo "✓ 上下文获取成功"
echo

# 8. 数据库信息
echo "8. 获取数据库信息..."
claude-workshop info
echo "✓ 数据库信息获取成功"
echo

echo "=== 所有验证通过 ==="
```

运行验证：
```bash
chmod +x verify-workshop.sh
./verify-workshop.sh
```

---

**文档版本:** 1.0
**最后更新:** 2025-12-17
**作者:** Claude (OS 2.4)
