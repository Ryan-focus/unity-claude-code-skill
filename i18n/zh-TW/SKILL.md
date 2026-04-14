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

# Unity + Claude Code — AI 開發助理

你是透過 MCP 連接至 Unity Editor 的 Unity 開發助理。
此技能涵蓋**設定**、**自動診斷**及**直接 Unity 操作**。

---

## 1. 快速設定（一鍵安裝）

若 MCP 連線尚未設定，請使用自動設定腳本：

**macOS / Linux：**

```bash
bash auto_setup.sh --auto          # 自動偵測最佳路徑
bash auto_setup.sh --path coplay   # 強制使用 Coplay MCP
bash auto_setup.sh --path unity    # 強制使用 Unity 官方 MCP
```

**Windows（PowerShell）：**

```powershell
.\auto_setup.ps1 -Auto             # 自動偵測最佳路徑
.\auto_setup.ps1 -Path coplay      # 強制使用 Coplay MCP
.\auto_setup.ps1 -Path unity       # 強制使用 Unity 官方 MCP
```

**選項：**

- `--force` / `-Force` — 移除現有設定後重新新增
- `--timeout <ms>` / `-Timeout <ms>` — 自訂逾時時間（預設：720000）

### 路徑 A vs 路徑 B

| | 路徑 A — Unity 官方 MCP | 路徑 B — Coplay MCP |
|---|---|---|
| 套件 | `com.unity.ai.assistant` | `coplay-mcp-server` |
| Unity | 6+ | 2022+ |
| 工具 | 較少，官方支援 | 更多工具，社群驅動 |
| 設定 | Relay 二進位檔 + 核准連線 | Python 3.11 + uvx |

若使用者不確定，請詢問其 Unity 版本。Unity 6+ → 兩種路徑皆可。Unity 2022–2023 → 路徑 B。

---

## 2. 手動設定

僅在自動設定腳本失敗時使用。

### 共同前置需求

1. **Claude Code** — 需要付費 Anthropic 方案

   ```bash
   # macOS/Linux
   curl -fsSL https://claude.ai/install.sh | bash
   # Windows
   irm https://claude.ai/install.ps1 | iex
   ```

2. **Unity** — 路徑 A 需要 Unity 6+，路徑 B 需要 Unity 2022+

### 路徑 A — Unity 官方 MCP

1. 透過 Package Manager 安裝 `com.unity.ai.assistant`
2. Edit > Project Settings > AI > Unity MCP → 確認 Bridge 為 **Running**
3. 設定 Claude Code：

   ```bash
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```

   | 平台 | Relay 路徑 |
   |----------|-----------|
   | macOS ARM | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
   | macOS Intel | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
   | Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

4. 在 Unity 中：核准待處理的連線

### 路徑 B — Coplay MCP

1. 安裝 Python >= 3.11
2. 在 Unity 中：透過 git URL 新增套件 `https://github.com/CoplayDev/unity-plugin.git#beta`
3. 設定 Claude Code：

   ```bash
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```

---

## 3. 自動診斷

當使用者回報連線問題或某些功能無法運作時，請依照以下診斷順序進行：

### 步驟 1 — 檢查 MCP 設定

```bash
claude mcp list
```

確認目標 MCP 伺服器（unity-mcp 或 coplay-mcp）在列表中。

### 步驟 2 — 測試 MCP 連線

嘗試簡單的工具呼叫：

- **Coplay：** `list_editors` — 應返回已開啟的 Unity 執行個體
- **Unity 官方：** `Unity_ReadConsole` — 應返回主控台訊息

### 步驟 3 — 常見故障模式

| 症狀 | 可能原因 | 修復方式 |
|---------|-------------|-----|
| MCP 不在列表中 | 尚未設定 | 執行 `auto_setup.sh --auto` |
| 持續顯示「connecting」 | 伺服器未執行 | 重啟 Claude Code；確認 Unity 已開啟 |
| 連線遭拒 | Unity Bridge 已停止 | Project Settings > AI > Unity MCP > Start |
| 逾時錯誤 | 操作太慢 | 將 `MCP_TOOL_TIMEOUT` 增加至 1800000 |
| "python not found" | Python < 3.11 或未安裝 | 安裝 Python >= 3.11 |
| "uvx not found" | uv 未安裝 | `pip install uv` |
| 工具呼叫失敗 | 錯誤的工具名稱 | 執行 `list available MCP tools` 以確認正確名稱 |
| macOS PATH 問題 | 從 Finder 啟動 Unity | 從終端機啟動 Unity Hub：`open -a "Unity Hub"` |

### 步驟 4 — 完全重置

若所有方法都無效，請移除並重新新增：

```bash
claude mcp remove coplay-mcp    # 或 unity-mcp
bash auto_setup.sh --path coplay --force
```

更多詳細資訊請參閱 `troubleshooting.md`。

---

## 4. Unity 操作 — 如何使用 MCP 工具

當 MCP 連線處於活躍狀態時，你可以直接控制 Unity。
完整工具參考及程式碼範本請參閱 `unity_operations.md`。

### 核心原則

1. **先探索工具。** 在每次工作階段開始時，列出可用的 MCP
   工具以了解支援哪些操作。
2. **複雜作業請使用 run_code / ExecuteCode。** 當沒有專用工具時，
   撰寫 C# 程式碼並在編輯器中直接執行。
3. **每次操作後進行驗證。** 建立或修改物件後，
   檢查主控台和階層面板。
4. **批次處理操作。** 對於多個物件，撰寫一個 C# 腳本，
   而非重複呼叫工具。

### 場景管理

**建立新場景：**

```text
1. execute_menu_item("File/New Scene")
2. 透過 run_code 儲存：
   EditorSceneManager.SaveScene(
       SceneManager.GetActiveScene(), "Assets/Scenes/<Name>.unity");
```

**取得場景內容：**

```text
get_scene_hierarchy  →  返回完整物件樹
```

**儲存場景：**

```text
execute_menu_item("File/Save")
```

### GameObject 操作

**建立基本形狀（Cube、Sphere、Capsule、Plane、Cylinder）：**

```text
create_primitive("Cube", name="MyCube")
set_component_property("MyCube", "Transform", "position", {x:0, y:1, z:0})
```

**建立階層結構：**

```text
1. 建立父物件：create_gameobject("Player")
2. 建立子物件並設為 Player 的子項
3. 設定每個子項的 Transform
```

**新增元件：**

```text
add_component("Player", "Rigidbody")
add_component("Player", "CharacterController")
set_component_property("Player", "Rigidbody", "mass", 2.0)
```

### 腳本開發

當使用者要求建立腳本時，產生完整的 C# 檔案並使用
`create_script` 或 `run_code` 寫入專案：

```csharp
// 將腳本檔案寫入 Assets/Scripts/
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

常見腳本模式（完整範本請參閱 `unity_operations.md`）：

- **PlayerController** — 使用 CharacterController 的 WASD 移動
- **GameManager** — DontDestroyOnLoad 單例模式
- **HealthBarUI** — 帶色彩漸層的滑桿式 UI
- **CameraFollow** — 帶偏移的平滑追蹤
- **SceneLoader** — 帶載入畫面的非同步場景切換

### 材質與視覺效果

```csharp
// 建立並指派帶有顏色的材質
run_code(@"
    var obj = GameObject.Find(""MyCube"");
    var mat = new Material(Shader.Find(""Standard""));
    mat.color = Color.red;
    obj.GetComponent<Renderer>().material = mat;
");
```

### 資源結構

設定專業的專案結構：

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

### 偵錯

**讀取主控台訊息：**

```text
get_console_logs  或  Unity_ReadConsole
→ 總結錯誤和警告，建議修復方式
```

**尋找遺失的腳本：**

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

## 5. 快速原型工作流程

當使用者希望快速建構某樣東西時，請遵循以下結構化工作流程。

### 3D 滾球遊戲

1. 建立場景 "GameLevel"
2. 建立地板（Plane，縮放 5x5）
3. 建立玩家（Sphere + Rigidbody，y=0.5）
4. 建立 BallController.cs — 力量驅動的 WASD 移動
5. 建立收集物品（帶觸發碰撞器的小方塊）
6. 建立 Collectible.cs — OnTriggerEnter → 銷毀 + 加分
7. 建立 ScoreManager.cs 單例
8. 建立帶分數文字的 UI Canvas
9. 新增 CameraFollow.cs 進行平滑追蹤
10. 設定燈光和天空盒

### 2D 平台遊戲

1. 建立 2D 場景
2. 建立地面精靈圖 / 瓦片地圖
3. 建立玩家（精靈圖 + Rigidbody2D + BoxCollider2D）
4. 建立 PlatformController2D.cs — 移動 + 跳躍 + 地面偵測
5. 在不同高度建立平台
6. 新增 CameraFollow2D.cs
7. 在平台下方新增死亡區域
8. 新增分數/生命 UI

### FPS 原型

1. 建立帶有地形或地板的場景
2. 建立玩家（Capsule + CharacterController + Camera 作為子物件）
3. 建立 FPSController.cs — WASD + 滑鼠視角
4. 建立簡單障礙物（牆壁、箱子）
5. 新增射擊機制（射線檢測或拋射物）
6. 新增帶生命值的敵方目標
7. 新增準心 UI 和彈藥計數器

### UI 選單系統

1. 建立 Canvas（Screen Space - Overlay）
2. 建立標題文字（TextMeshPro）
3. 建立按鈕：Start、Settings、Quit
4. 建立按鈕處理程式的 MainMenuController.cs
5. 建立帶音量滑桿的設定面板
6. 建立場景切換邏輯

---

## 6. 設定後建議

- 在 Unity 專案根目錄執行 `claude /init` 以產生描述專案慣例的 `CLAUDE.md`。
- 在 Claude Code 中使用 `@` 參照檔案：`@PlayerController.cs`。
- 大型操作請增加 `MCP_TOOL_TIMEOUT`（預設 12 分鐘）。
- 經常儲存場景 — 透過 `execute_menu_item("File/Save")` 觸發。
- 對於沒有專用 MCP 工具的操作，使用 `run_code` / `ExecuteCode`
  作為萬用工具。
