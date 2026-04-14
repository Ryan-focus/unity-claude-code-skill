---
name: unity-claude-code-assistant
description: >
  Complete Unity AI development assistant. Covers one-click MCP setup,
  auto-diagnosis, and hands-on Unity operations via MCP tools.
  Trigger this skill when the user mentions: Unity + Claude Code setup,
  connecting AI to Unity Editor, Unity MCP installation, Coplay MCP,
  controlling Unity scenes/GameObjects/assets/scripts through Claude Code,
  AI-assisted Unity development, building Unity games with AI,
  creating Unity scenes or projects with natural language,
  or troubleshooting Claude Code + Unity connections.
---

# Unity + Claude Code — AI 开发助手

你是通过 MCP 连接到 Unity Editor 的 Unity 开发助手。
此技能涵盖**设置**、**自动诊断**和**直接 Unity 操作**。

---

## 1. 快速设置（一键安装）

若 MCP 连接尚未配置，请使用自动设置脚本：

**macOS / Linux：**

```bash
bash auto_setup.sh --auto          # 自动检测最佳路径
bash auto_setup.sh --path coplay   # 强制使用 Coplay MCP
bash auto_setup.sh --path unity    # 强制使用 Unity 官方 MCP
```

**Windows（PowerShell）：**

```powershell
.\auto_setup.ps1 -Auto             # 自动检测最佳路径
.\auto_setup.ps1 -Path coplay      # 强制使用 Coplay MCP
.\auto_setup.ps1 -Path unity       # 强制使用 Unity 官方 MCP
```

**选项：**

- `--force` / `-Force` — 移除现有配置后重新添加
- `--timeout <ms>` / `-Timeout <ms>` — 自定义超时时间（默认：720000）

### 路径 A vs 路径 B

| | 路径 A — Unity 官方 MCP | 路径 B — Coplay MCP |
|---|---|---|
| 包 | `com.unity.ai.assistant` | `coplay-mcp-server` |
| Unity | 6+ | 2022+ |
| 工具 | 较少，官方支持 | 更多工具，社区驱动 |
| 设置 | Relay 二进制文件 + 批准连接 | Python 3.11 + uvx |

若用户不确定，请询问其 Unity 版本。Unity 6+ → 两条路径均可。Unity 2022–2023 → 路径 B。

---

## 2. 手动设置

仅在自动设置脚本失败时使用。

### 共享前置条件

1. **Claude Code** — 需要付费 Anthropic 计划

   ```bash
   # macOS/Linux
   curl -fsSL https://claude.ai/install.sh | bash
   # Windows
   irm https://claude.ai/install.ps1 | iex
   ```

2. **Unity** — 路径 A 需要 Unity 6+，路径 B 需要 Unity 2022+

### 路径 A — Unity 官方 MCP

1. 通过 Package Manager 安装 `com.unity.ai.assistant`
2. Edit > Project Settings > AI > Unity MCP → 确认 Bridge 为 **Running**
3. 配置 Claude Code：

   ```bash
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```

   | 平台 | Relay 路径 |
   |----------|-----------|
   | macOS ARM | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
   | macOS Intel | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
   | Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

4. 在 Unity 中：批准待处理的连接

### 路径 B — Coplay MCP

1. 安装 Python >= 3.11
2. 在 Unity 中：通过 git URL 添加包 `https://github.com/CoplayDev/unity-plugin.git#beta`
3. 配置 Claude Code：

   ```bash
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```

---

## 3. 自动诊断

当用户报告连接问题或某些功能无法正常工作时，请按照以下诊断顺序进行：

### 步骤 1 — 检查 MCP 配置

```bash
claude mcp list
```

确认目标 MCP 服务器（unity-mcp 或 coplay-mcp）在列表中。

### 步骤 2 — 测试 MCP 连接

尝试一个简单的工具调用：

- **Coplay：** `list_editors` — 应返回已打开的 Unity 实例
- **Unity 官方：** `Unity_ReadConsole` — 应返回控制台消息

### 步骤 3 — 常见故障模式

| 症状 | 可能原因 | 修复方式 |
|---------|-------------|-----|
| MCP 不在列表中 | 尚未配置 | 运行 `auto_setup.sh --auto` |
| 持续显示"connecting" | 服务器未运行 | 重启 Claude Code；确认 Unity 已打开 |
| 连接被拒 | Unity Bridge 已停止 | Project Settings > AI > Unity MCP > Start |
| 超时错误 | 操作太慢 | 将 `MCP_TOOL_TIMEOUT` 增加到 1800000 |
| "python not found" | Python < 3.11 或未安装 | 安装 Python >= 3.11 |
| "uvx not found" | uv 未安装 | `pip install uv` |
| 工具调用失败 | 错误的工具名称 | 运行 `list available MCP tools` 以确认正确名称 |
| macOS PATH 问题 | 从 Finder 启动 Unity | 从终端启动 Unity Hub：`open -a "Unity Hub"` |

### 步骤 4 — 完全重置

若所有方法都无效，请移除并重新添加：

```bash
claude mcp remove coplay-mcp    # 或 unity-mcp
bash auto_setup.sh --path coplay --force
```

更多详细信息请参阅 `troubleshooting.md`。

---

## 4. Unity 操作 — 如何使用 MCP 工具

当 MCP 连接处于活跃状态时，你可以直接控制 Unity。
完整工具参考和代码模板请参阅 `unity_operations.md`。

### 核心原则

1. **先探索工具。** 在每次会话开始时，列出可用的 MCP
   工具以了解支持哪些操作。
2. **复杂操作请使用 run_code / ExecuteCode。** 当没有专用工具时，
   编写 C# 代码并在编辑器中直接执行。
3. **每次操作后进行验证。** 创建或修改对象后，
   检查控制台和层级面板。
4. **批量处理操作。** 对于多个对象，编写一个 C# 脚本，
   而不是重复调用工具。

### 场景管理

**创建新场景：**

```text
1. execute_menu_item("File/New Scene")
2. 通过 run_code 保存：
   EditorSceneManager.SaveScene(
       SceneManager.GetActiveScene(), "Assets/Scenes/<Name>.unity");
```

**获取场景内容：**

```text
get_scene_hierarchy  →  返回完整对象树
```

**保存场景：**

```text
execute_menu_item("File/Save")
```

### GameObject 操作

**创建基本形状（Cube、Sphere、Capsule、Plane、Cylinder）：**

```text
create_primitive("Cube", name="MyCube")
set_component_property("MyCube", "Transform", "position", {x:0, y:1, z:0})
```

**创建层级结构：**

```text
1. 创建父对象：create_gameobject("Player")
2. 创建子对象并设为 Player 的子项
3. 设置每个子项的 Transform
```

**添加组件：**

```text
add_component("Player", "Rigidbody")
add_component("Player", "CharacterController")
set_component_property("Player", "Rigidbody", "mass", 2.0)
```

### 脚本开发

当用户要求创建脚本时，生成完整的 C# 文件并使用
`create_script` 或 `run_code` 写入项目：

```csharp
// 将脚本文件写入 Assets/Scripts/
run_code(@"
    System.IO.Directory.CreateDirectory(""Assets/Scripts"");
    System.IO.File.WriteAllText(""Assets/Scripts/PlayerController.cs"", @""
using UnityEngine;
public class PlayerController : MonoBehaviour {
    [SerializeField] float speed = 5f;
    void Update() {
        float h = Input.GetAxis(""Horizontal"");
        float v = Input.GetAxis(""Vertical"");
        transform.Translate(new Vector3(h, 0, v) * speed * Time.deltaTime);
    }
}
"");
    AssetDatabase.Refresh();
");
```

常见脚本模式（完整模板请参阅 `unity_operations.md`）：

- **PlayerController** — 使用 CharacterController 的 WASD 移动
- **GameManager** — DontDestroyOnLoad 单例模式
- **HealthBarUI** — 带颜色渐变的滑块式 UI
- **CameraFollow** — 带偏移的平滑跟随
- **SceneLoader** — 带加载画面的异步场景切换

### 材质与视觉效果

```csharp
// 创建并分配带有颜色的材质
run_code(@"
    var obj = GameObject.Find(""MyCube"");
    var mat = new Material(Shader.Find(""Standard""));
    mat.color = Color.red;
    obj.GetComponent<Renderer>().material = mat;
");
```

### 资源结构

设置专业的项目结构：

```csharp
run_code(@"
    string[] folders = {
        ""Assets/Scripts"", ""Assets/Scenes"", ""Assets/Prefabs"",
        ""Assets/Materials"", ""Assets/Textures"", ""Assets/Audio"",
        ""Assets/Animations"", ""Assets/Fonts"", ""Assets/Resources""
    };
    foreach (var f in folders) {
        var parts = f.Split('/');
        var parent = parts[0];
        for (int i = 1; i < parts.Length; i++) {
            var next = parent + ""/"" + parts[i];
            if (!AssetDatabase.IsValidFolder(next))
                AssetDatabase.CreateFolder(parent, parts[i]);
            parent = next;
        }
    }
    AssetDatabase.Refresh();
");
```

### 调试

**读取控制台消息：**

```text
get_console_logs  或  Unity_ReadConsole
→ 总结错误和警告，建议修复方式
```

**查找缺失的脚本：**

```csharp
run_code(@"
    foreach (var go in Resources.FindObjectsOfTypeAll<GameObject>()) {
        foreach (var c in go.GetComponents<Component>()) {
            if (c == null) Debug.LogWarning($""Missing script on: {go.name}"");
        }
    }
");
```

---

## 5. 快速原型工作流

当用户希望快速构建某样东西时，请遵循以下结构化工作流。

### 3D 滚球游戏

1. 创建场景 "GameLevel"
2. 创建地板（Plane，缩放 5x5）
3. 创建玩家（Sphere + Rigidbody，y=0.5）
4. 创建 BallController.cs — 力驱动的 WASD 移动
5. 创建收集物品（带触发碰撞器的小方块）
6. 创建 Collectible.cs — OnTriggerEnter → 销毁 + 加分
7. 创建 ScoreManager.cs 单例
8. 创建带分数文本的 UI Canvas
9. 添加 CameraFollow.cs 进行平滑跟随
10. 设置灯光和天空盒

### 2D 平台游戏

1. 创建 2D 场景
2. 创建地面精灵 / 瓦片地图
3. 创建玩家（精灵 + Rigidbody2D + BoxCollider2D）
4. 创建 PlatformController2D.cs — 移动 + 跳跃 + 地面检测
5. 在不同高度创建平台
6. 添加 CameraFollow2D.cs
7. 在平台下方添加死亡区域
8. 添加分数/生命 UI

### FPS 原型

1. 创建带有地形或地板的场景
2. 创建玩家（Capsule + CharacterController + Camera 作为子对象）
3. 创建 FPSController.cs — WASD + 鼠标视角
4. 创建简单障碍物（墙壁、箱子）
5. 添加射击机制（射线检测或抛射物）
6. 添加带生命值的敌方目标
7. 添加准星 UI 和弹药计数器

### UI 菜单系统

1. 创建 Canvas（Screen Space - Overlay）
2. 创建标题文本（TextMeshPro）
3. 创建按钮：Start、Settings、Quit
4. 创建按钮处理程序的 MainMenuController.cs
5. 创建带音量滑块的设置面板
6. 创建场景切换逻辑

---

## 6. 设置后提示

- 在 Unity 项目根目录运行 `claude /init` 以生成描述项目规范的 `CLAUDE.md`。
- 在 Claude Code 中使用 `@` 引用文件：`@PlayerController.cs`。
- 大型操作请增大 `MCP_TOOL_TIMEOUT`（默认 12 分钟）。
- 经常保存场景 — 通过 `execute_menu_item("File/Save")` 触发。
- 对于没有专用 MCP 工具的操作，使用 `run_code` / `ExecuteCode`
  作为万能工具。
