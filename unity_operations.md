# Unity Operations Guide — MCP Tool Reference

This document is the operational playbook for Claude Code when connected to
Unity via MCP. It maps common user requests to specific MCP tool sequences.

Claude Code: read this file when the user wants to perform Unity operations
after the MCP connection is established.

---

## Tool Availability by MCP Path

| Operation | Coplay MCP | Unity Official MCP |
|-----------|-----------|-------------------|
| List editors | `list_editors` | — |
| Read console | `get_console_logs` | `Unity_ReadConsole` |
| Scene hierarchy | `get_scene_hierarchy` | `Unity_GetHierarchy` |
| Create GameObject | `create_gameobject` | `Unity_CreateGameObject` |
| Create primitive | `create_primitive` | `Unity_CreatePrimitive` |
| Add component | `add_component` | `Unity_AddComponent` |
| Set property | `set_component_property` | `Unity_SetProperty` |
| Execute menu item | `execute_menu_item` | `Unity_ExecuteMenuItem` |
| Create C# script | `create_script` | — |
| Run C# code | `run_code` / `execute_code` | `Unity_ExecuteCode` |
| Select object | `select_gameobject` | `Unity_SelectGameObject` |
| Delete object | `delete_gameobject` | `Unity_DeleteGameObject` |
| Get/set transform | `set_component_property` | `Unity_SetProperty` |
| Get project info | `get_project_info` | — |
| Import asset | `import_asset` | — |
| Create material | via `run_code` | via `Unity_ExecuteCode` |

> **Note:** Tool names may vary by version. Use `claude mcp list-tools` or
> ask Claude to list available MCP tools to discover the exact names.

---

## Scene Management

### Create a New Scene

```text
User: "Create a new scene called MainMenu"

Steps:
1. Execute menu item: File > New Scene
2. Save scene to Assets/Scenes/MainMenu.unity
3. Verify scene is active
```

**Coplay MCP approach:**

```text
execute_menu_item("File/New Scene")
run_code("
    UnityEditor.SceneManagement.EditorSceneManager.SaveScene(
        UnityEngine.SceneManagement.SceneManager.GetActiveScene(),
        \"Assets/Scenes/MainMenu.unity\"
    );
")
```

**Unity Official MCP approach:**

```text
Unity_ExecuteMenuItem("File/New Scene")
Unity_ExecuteCode("
    EditorSceneManager.SaveScene(
        SceneManager.GetActiveScene(),
        \"Assets/Scenes/MainMenu.unity\"
    );
")
```

### List All Objects in Scene

```text
User: "What's in the current scene?"

Steps:
1. Get scene hierarchy
2. Format and present the tree structure
```

### Save Current Scene

```text
execute_menu_item("File/Save") or Ctrl+S equivalent
```

---

## GameObject Operations

### Create Basic Objects

```text
User: "Create a red cube at (0, 2, 0)"

Steps:
1. Create a primitive cube
2. Set its position to (0, 2, 0)
3. Create a red material
4. Assign the material to the cube
```

**Coplay MCP approach:**

```text
create_primitive("Cube", name="RedCube")
set_component_property("RedCube", "Transform", "position", {"x":0, "y":2, "z":0})
run_code("
    var cube = GameObject.Find(\"RedCube\");
    var renderer = cube.GetComponent<Renderer>();
    var mat = new Material(Shader.Find(\"Standard\"));
    mat.color = Color.red;
    renderer.material = mat;
")
```

### Create Complex Hierarchies

```text
User: "Create a player character with a body, head, and two arms"

Steps:
1. Create empty parent: "Player"
2. Create child primitive Capsule: "Body" at (0, 1, 0)
3. Create child primitive Sphere: "Head" at (0, 2, 0)
4. Create child primitive Cube: "LeftArm" at (-0.7, 1.2, 0), scale (0.3, 0.8, 0.3)
5. Create child primitive Cube: "RightArm" at (0.7, 1.2, 0), scale (0.3, 0.8, 0.3)
6. Parent all children under "Player"
```

### Add Components

```text
User: "Add a Rigidbody to the Player"

Steps:
1. Find the target GameObject
2. Add Rigidbody component
3. Optionally configure mass, drag, constraints
```

---

## Script Development

### Create a MonoBehaviour Script

```text
User: "Create a PlayerController script that handles WASD movement"

Steps:
1. Generate the C# code
2. Create the script file at Assets/Scripts/PlayerController.cs
3. Attach it to the target GameObject
```

**Template — PlayerController.cs:**

```csharp
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 5f;
    [SerializeField] private float rotationSpeed = 120f;

    private CharacterController _controller;

    private void Awake()
    {
        _controller = GetComponent<CharacterController>();
    }

    private void Update()
    {
        float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");

        Vector3 move = transform.forward * v + transform.right * h;
        _controller.Move(move * (moveSpeed * Time.deltaTime));

        if (h != 0f)
        {
            transform.Rotate(0f, h * rotationSpeed * Time.deltaTime, 0f);
        }
    }
}
```

### Create a Singleton Manager

```text
User: "Create a GameManager singleton"
```

**Template — GameManager.cs:**

```csharp
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    [SerializeField] private int targetFrameRate = 60;

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);
        Application.targetFrameRate = targetFrameRate;
    }
}
```

### Create a UI Controller

```text
User: "Create a health bar UI script"
```

**Template — HealthBarUI.cs:**

```csharp
using UnityEngine;
using UnityEngine.UI;

public class HealthBarUI : MonoBehaviour
{
    [SerializeField] private Slider healthSlider;
    [SerializeField] private Image fillImage;
    [SerializeField] private Color fullHealthColor = Color.green;
    [SerializeField] private Color lowHealthColor = Color.red;

    public void SetHealth(float current, float max)
    {
        float ratio = Mathf.Clamp01(current / max);
        healthSlider.value = ratio;
        fillImage.color = Color.Lerp(lowHealthColor, fullHealthColor, ratio);
    }
}
```

---

## Materials and Visuals

### Create and Assign Materials

```text
User: "Make the floor a wooden texture"

Approach (via run_code / ExecuteCode):
1. Create a new Material with Standard shader
2. Set main texture if available, or set color
3. Assign to target renderer
```

**Code pattern:**

```csharp
var floor = GameObject.Find("Floor");
var renderer = floor.GetComponent<Renderer>();
var mat = new Material(Shader.Find("Standard"));
mat.color = new Color(0.55f, 0.35f, 0.17f); // wood-like brown
renderer.material = mat;
```

### Setup Basic Lighting

```text
User: "Set up a basic 3-point lighting"

Steps:
1. Create Directional Light "KeyLight" — rotation (50, -30, 0), intensity 1.0
2. Create Directional Light "FillLight" — rotation (30, 120, 0), intensity 0.5
3. Create Directional Light "BackLight" — rotation (-20, 180, 0), intensity 0.3
```

### Set Skybox

```csharp
// Via run_code
RenderSettings.skybox = Resources.Load<Material>("Skybox/DefaultSkybox");
```

---

## Asset Management

### Create Folder Structure

```text
User: "Set up a standard project folder structure"

Steps (via run_code / ExecuteCode):
```

```csharp
string[] folders = {
    "Assets/Scripts",
    "Assets/Scripts/Player",
    "Assets/Scripts/UI",
    "Assets/Scripts/Managers",
    "Assets/Scenes",
    "Assets/Prefabs",
    "Assets/Materials",
    "Assets/Textures",
    "Assets/Audio",
    "Assets/Audio/SFX",
    "Assets/Audio/Music",
    "Assets/Animations",
    "Assets/Fonts",
    "Assets/Resources"
};

foreach (var folder in folders)
{
    if (!AssetDatabase.IsValidFolder(folder))
    {
        var parts = folder.Split('/');
        var parent = parts[0];
        for (int i = 1; i < parts.Length; i++)
        {
            var next = parent + "/" + parts[i];
            if (!AssetDatabase.IsValidFolder(next))
                AssetDatabase.CreateFolder(parent, parts[i]);
            parent = next;
        }
    }
}
AssetDatabase.Refresh();
```

### Create Prefab from Scene Object

```csharp
var obj = GameObject.Find("Player");
PrefabUtility.SaveAsPrefabAsset(obj, "Assets/Prefabs/Player.prefab");
```

---

## Debugging and Diagnostics

### Read Console Logs

```text
User: "Are there any errors in Unity?"

Steps:
1. Read console logs
2. Filter by type (Error, Warning, Log)
3. Summarize findings and suggest fixes
```

### Clear Console

```text
execute_menu_item("Edit/Clear Console")
```

### Check Project for Common Issues

```text
User: "Check my project for problems"

Diagnostic checklist:
1. Read console for errors/warnings
2. Check for missing script references (run_code)
3. List scenes in build settings
4. Check for unassigned serialized fields
```

```csharp
// Find missing scripts
var allObjects = Resources.FindObjectsOfTypeAll<GameObject>();
foreach (var go in allObjects)
{
    var components = go.GetComponents<Component>();
    foreach (var c in components)
    {
        if (c == null)
            Debug.LogWarning($"Missing script on: {go.name}");
    }
}
```

---

## Build Operations

### Configure Build Settings

```csharp
// Switch platform
EditorUserBuildSettings.SwitchActiveBuildTarget(
    BuildTargetGroup.Standalone,
    BuildTarget.StandaloneWindows64
);

// Add scenes to build
var scenes = new[] {
    new EditorBuildSettingsScene("Assets/Scenes/MainMenu.unity", true),
    new EditorBuildSettingsScene("Assets/Scenes/GameLevel.unity", true)
};
EditorBuildSettings.scenes = scenes;
```

### Build the Project

```csharp
BuildPipeline.BuildPlayer(
    EditorBuildSettings.scenes,
    "Builds/MyGame.exe",
    BuildTarget.StandaloneWindows64,
    BuildOptions.None
);
```

---

## Common Workflow Templates

### Rapid Prototype: Simple 3D Game

```text
User: "Help me prototype a simple ball-rolling game"

Workflow:
1. Create scene "GameLevel"
2. Create Floor (scaled Plane at origin)
3. Create Player ball (Sphere at (0, 0.5, 0) with Rigidbody)
4. Create BallController.cs script for WASD force-based movement
5. Create collectible items (small cubes with trigger colliders)
6. Create Collectible.cs script (OnTriggerEnter → destroy + score)
7. Create ScoreManager.cs singleton
8. Create UI text for score display
9. Set up camera to follow ball
10. Add basic lighting
```

### Rapid Prototype: 2D Platformer

```text
User: "Create a basic 2D platformer"

Workflow:
1. Create 2D scene
2. Create ground tilemap or sprite
3. Create Player sprite with Rigidbody2D + BoxCollider2D
4. Create PlatformController2D.cs (horizontal movement + jump)
5. Create platforms at various heights
6. Add CameraFollow.cs for smooth camera tracking
7. Add simple death zone (trigger below platforms)
```

### UI Menu System

```text
User: "Create a main menu"

Workflow:
1. Create Canvas (Screen Space - Overlay)
2. Create Panel background
3. Create Title text (TextMeshPro)
4. Create "Start Game" button → loads game scene
5. Create "Settings" button → opens settings panel
6. Create "Quit" button → Application.Quit()
7. Create MainMenuController.cs to handle button events
8. Create SceneLoader.cs utility
```

---

## Tips for Claude Code

1. **Always check available tools first.** Run `list available MCP tools` at the
   start of a session to know what operations are supported.

2. **Use run_code / ExecuteCode for complex operations.** When a dedicated tool
   doesn't exist, write and execute C# code directly in the Unity editor.

3. **Verify after each step.** After creating objects or scripts, read the
   console and check the hierarchy to confirm success.

4. **Handle errors gracefully.** If a tool fails, read the error message,
   diagnose the issue, and try an alternative approach.

5. **Save frequently.** Remind the user to save scenes after major changes,
   or trigger save via menu item execution.

6. **Batch operations when possible.** For creating multiple objects, write
   a single C# script that creates them all rather than calling tools one by one.
