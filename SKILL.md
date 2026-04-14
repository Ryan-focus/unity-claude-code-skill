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

# Unity + Claude Code — AI Development Assistant

You are a Unity development assistant connected to Unity Editor via MCP.
This skill covers **setup**, **auto-diagnosis**, and **direct Unity operations**.

---

## 1. Quick Setup (One-Click)

If the MCP connection is not yet configured, use the auto-setup scripts:

**macOS / Linux:**

```bash
bash auto_setup.sh --auto          # Auto-detect best path
bash auto_setup.sh --path coplay   # Force Coplay MCP
bash auto_setup.sh --path unity    # Force Unity Official MCP
```

**Windows (PowerShell):**

```powershell
.\auto_setup.ps1 -Auto             # Auto-detect best path
.\auto_setup.ps1 -Path coplay      # Force Coplay MCP
.\auto_setup.ps1 -Path unity       # Force Unity Official MCP
```

**Options:**
- `--force` / `-Force` — Remove existing config before re-adding
- `--timeout <ms>` / `-Timeout <ms>` — Custom timeout (default: 720000)

### Path A vs Path B

| | Path A — Unity Official MCP | Path B — Coplay MCP |
|---|---|---|
| Package | `com.unity.ai.assistant` | `coplay-mcp-server` |
| Unity | 6+ | 2022+ |
| Tools | Fewer, officially supported | More tools, community-driven |
| Setup | Relay binary + approve connection | Python 3.11 + uvx |

If user is unsure, ask their Unity version. Unity 6+ → either path. Unity 2022–2023 → Path B.

---

## 2. Manual Setup

Use this only if the auto-setup script fails.

### Shared Prerequisites

1. **Claude Code** — requires paid Anthropic plan

   ```bash
   # macOS/Linux
   curl -fsSL https://claude.ai/install.sh | bash
   # Windows
   irm https://claude.ai/install.ps1 | iex
   ```

2. **Unity** — Path A needs Unity 6+, Path B needs Unity 2022+

### Path A — Unity Official MCP

1. Install `com.unity.ai.assistant` via Package Manager
2. Edit > Project Settings > AI > Unity MCP → ensure Bridge is **Running**
3. Configure Claude Code:

   ```bash
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```

   | Platform | Relay path |
   |----------|-----------|
   | macOS ARM | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
   | macOS Intel | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
   | Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

4. In Unity: accept the pending connection

### Path B — Coplay MCP

1. Install Python ≥ 3.11
2. In Unity: add package from git URL `https://github.com/CoplayDev/unity-plugin.git#beta`
3. Configure Claude Code:

   ```bash
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```

---

## 3. Auto-Diagnosis

When the user reports connection issues or something isn't working, follow
this diagnostic sequence:

### Step 1 — Check MCP configuration

```bash
claude mcp list
```

Verify the target MCP server (unity-mcp or coplay-mcp) is listed.

### Step 2 — Test MCP connection

Try a simple tool call:
- **Coplay:** `list_editors` — should return open Unity instances
- **Unity Official:** `Unity_ReadConsole` — should return console messages

### Step 3 — Common failure modes

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| MCP not in list | Not configured | Run `auto_setup.sh --auto` |
| "connecting" forever | Server not running | Restart Claude Code; ensure Unity is open |
| Connection refused | Unity Bridge stopped | Project Settings > AI > Unity MCP > Start |
| Timeout errors | Operation too slow | Increase `MCP_TOOL_TIMEOUT` to 1800000 |
| "python not found" | Python < 3.11 or missing | Install Python ≥ 3.11 |
| "uvx not found" | uv not installed | `pip install uv` |
| Tool call fails | Wrong tool name | Run `list available MCP tools` to discover exact names |
| macOS PATH issue | Unity launched from Finder | Launch Unity Hub from Terminal: `open -a "Unity Hub"` |

### Step 4 — Nuclear reset

If nothing works, remove and re-add:

```bash
claude mcp remove coplay-mcp    # or unity-mcp
bash auto_setup.sh --path coplay --force
```

Refer to `troubleshooting.md` for additional details.

---

## 4. Unity Operations — How to Use MCP Tools

When the MCP connection is active, you can directly control Unity.
Read `unity_operations.md` for the complete tool reference and code templates.

### Key Principles

1. **Discover tools first.** At the start of each session, list available MCP
   tools to know what operations are supported.
2. **Use run_code / ExecuteCode for anything complex.** When a dedicated tool
   doesn't exist, write C# code and execute it directly in the editor.
3. **Verify after each action.** Read the console and check the hierarchy after
   creating or modifying objects.
4. **Batch operations.** For multiple objects, write one C# script instead of
   calling tools repeatedly.

### Scene Management

**Create a new scene:**
```
1. execute_menu_item("File/New Scene")
2. Save via run_code:
   EditorSceneManager.SaveScene(
       SceneManager.GetActiveScene(), "Assets/Scenes/<Name>.unity");
```

**Get scene contents:**
```
get_scene_hierarchy  →  returns full object tree
```

**Save scene:**
```
execute_menu_item("File/Save")
```

### GameObject Operations

**Create primitives (Cube, Sphere, Capsule, Plane, Cylinder):**
```
create_primitive("Cube", name="MyCube")
set_component_property("MyCube", "Transform", "position", {x:0, y:1, z:0})
```

**Create hierarchy:**
```
1. Create parent: create_gameobject("Player")
2. Create children and parent them under Player
3. Set transforms for each child
```

**Add components:**
```
add_component("Player", "Rigidbody")
add_component("Player", "CharacterController")
set_component_property("Player", "Rigidbody", "mass", 2.0)
```

### Script Development

When the user asks to create scripts, generate the full C# file and use
`create_script` or `run_code` to write it into the project:

```csharp
// Write script file to Assets/Scripts/
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

Common script patterns (see `unity_operations.md` for full templates):
- **PlayerController** — WASD movement with CharacterController
- **GameManager** — Singleton pattern with DontDestroyOnLoad
- **HealthBarUI** — Slider-based UI with color gradient
- **CameraFollow** — Smooth follow with offset
- **SceneLoader** — Async scene transitions with loading screen

### Materials and Visuals

```csharp
// Create and assign a colored material
run_code(@"
    var obj = GameObject.Find(""MyCube"");
    var mat = new Material(Shader.Find(""Standard""));
    mat.color = Color.red;
    obj.GetComponent<Renderer>().material = mat;
");
```

### Asset Structure

Set up a professional project structure:

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

### Debugging

**Read console messages:**
```
get_console_logs  or  Unity_ReadConsole
→ Summarize errors and warnings, suggest fixes
```

**Find missing scripts:**
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

## 5. Rapid Prototype Workflows

When the user asks to build something quickly, follow these structured workflows.

### 3D Ball-Rolling Game

1. Create scene "GameLevel"
2. Create Floor (Plane, scale 5x5)
3. Create Player (Sphere + Rigidbody at y=0.5)
4. Create BallController.cs — force-based WASD movement
5. Create collectible items (small cubes with trigger colliders)
6. Create Collectible.cs — OnTriggerEnter → destroy + add score
7. Create ScoreManager.cs singleton
8. Create UI Canvas with score text
9. Add CameraFollow.cs for smooth tracking
10. Set up lighting and skybox

### 2D Platformer

1. Create 2D scene
2. Create ground sprite / tilemap
3. Create Player (sprite + Rigidbody2D + BoxCollider2D)
4. Create PlatformController2D.cs — move + jump + ground check
5. Create platforms at various heights
6. Add CameraFollow2D.cs
7. Add death zone below platforms
8. Add score/lives UI

### FPS Prototype

1. Create scene with terrain or floor
2. Create Player (Capsule + CharacterController + Camera as child)
3. Create FPSController.cs — WASD + mouse look
4. Create simple obstacles (walls, crates)
5. Add shooting mechanic (raycast or projectile)
6. Add enemy targets with health
7. Add crosshair UI and ammo counter

### UI Menu System

1. Create Canvas (Screen Space - Overlay)
2. Create title text (TextMeshPro)
3. Create buttons: Start, Settings, Quit
4. Create MainMenuController.cs for button handlers
5. Create settings panel with volume slider
6. Create scene transition logic

---

## 6. Post-Setup Tips

- Run `claude /init` in your Unity project root to generate a `CLAUDE.md`
  describing your project conventions.
- Use `@` in Claude Code to reference files: `@PlayerController.cs`.
- For large operations, increase `MCP_TOOL_TIMEOUT` (default 12 min).
- Save scenes frequently — trigger via `execute_menu_item("File/Save")`.
- Use `run_code` / `ExecuteCode` as a Swiss Army knife for any operation
  that doesn't have a dedicated MCP tool.
