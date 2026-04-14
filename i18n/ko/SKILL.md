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

# Unity + Claude Code — AI 개발 어시스턴트

당신은 MCP를 통해 Unity Editor에 연결된 Unity 개발 어시스턴트입니다.
이 스킬은 **설정**, **자동 진단**, 그리고 **직접적인 Unity 조작**을 다룹니다.

---

## 1. 빠른 설정 (원클릭)

MCP 연결이 아직 구성되지 않은 경우, 자동 설정 스크립트를 사용하세요:

**macOS / Linux:**

```bash
bash auto_setup.sh --auto          # 최적 경로 자동 감지
bash auto_setup.sh --path coplay   # Coplay MCP 강제 지정
bash auto_setup.sh --path unity    # Unity 공식 MCP 강제 지정
```

**Windows (PowerShell):**

```powershell
.\auto_setup.ps1 -Auto             # 최적 경로 자동 감지
.\auto_setup.ps1 -Path coplay      # Coplay MCP 강제 지정
.\auto_setup.ps1 -Path unity       # Unity 공식 MCP 강제 지정
```

**옵션:**

- `--force` / `-Force` — 기존 설정을 제거한 후 다시 추가
- `--timeout <ms>` / `-Timeout <ms>` — 커스텀 타임아웃 (기본값: 720000)

### 경로 A vs 경로 B

| | 경로 A — Unity 공식 MCP | 경로 B — Coplay MCP |
|---|---|---|
| 패키지 | `com.unity.ai.assistant` | `coplay-mcp-server` |
| Unity | 6+ | 2022+ |
| 도구 | 적지만 공식 지원 | 더 많은 도구, 커뮤니티 주도 |
| 설정 | Relay 바이너리 + 연결 승인 | Python 3.11 + uvx |

사용자가 확신이 없는 경우, Unity 버전을 확인하세요. Unity 6+ → 두 경로 모두 가능. Unity 2022–2023 → 경로 B.

---

## 2. 수동 설정

자동 설정 스크립트가 실패한 경우에만 사용하세요.

### 공통 사전 요구사항

1. **Claude Code** — 유료 Anthropic 플랜 필요

   ```bash
   # macOS/Linux
   curl -fsSL https://claude.ai/install.sh | bash
   # Windows
   irm https://claude.ai/install.ps1 | iex
   ```

2. **Unity** — 경로 A는 Unity 6+ 필요, 경로 B는 Unity 2022+ 필요

### 경로 A — Unity 공식 MCP

1. Package Manager에서 `com.unity.ai.assistant` 설치
2. Edit > Project Settings > AI > Unity MCP → Bridge가 **Running** 상태인지 확인
3. Claude Code 구성:

   ```bash
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```

   | 플랫폼 | Relay 경로 |
   |----------|-----------|
   | macOS ARM | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
   | macOS Intel | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
   | Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

4. Unity에서: 대기 중인 연결 승인

### 경로 B — Coplay MCP

1. Python >= 3.11 설치
2. Unity에서: git URL로 패키지 추가 `https://github.com/CoplayDev/unity-plugin.git#beta`
3. Claude Code 구성:

   ```bash
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```

---

## 3. 자동 진단

사용자가 연결 문제를 보고하거나 무언가 작동하지 않을 때, 다음 진단 순서를
따르세요:

### 1단계 — MCP 설정 확인

```bash
claude mcp list
```

대상 MCP 서버(unity-mcp 또는 coplay-mcp)가 목록에 있는지 확인합니다.

### 2단계 — MCP 연결 테스트

간단한 도구 호출을 시도합니다:

- **Coplay:** `list_editors` — 열린 Unity 인스턴스를 반환해야 함
- **Unity 공식:** `Unity_ReadConsole` — 콘솔 메시지를 반환해야 함

### 3단계 — 일반적인 오류 유형

| 증상 | 가능한 원인 | 해결 방법 |
|---------|-------------|-----|
| MCP가 목록에 없음 | 구성되지 않음 | `auto_setup.sh --auto` 실행 |
| "connecting" 상태 지속 | 서버가 실행 중이지 않음 | Claude Code 재시작; Unity가 열려 있는지 확인 |
| 연결 거부 | Unity Bridge 중단됨 | Project Settings > AI > Unity MCP > Start |
| 타임아웃 오류 | 작업이 너무 느림 | `MCP_TOOL_TIMEOUT`을 1800000으로 증가 |
| "python not found" | Python < 3.11 또는 미설치 | Python >= 3.11 설치 |
| "uvx not found" | uv 미설치 | `pip install uv` |
| 도구 호출 실패 | 잘못된 도구 이름 | `list available MCP tools`를 실행하여 정확한 이름 확인 |
| macOS PATH 문제 | Finder에서 Unity 실행 | 터미널에서 Unity Hub 실행: `open -a "Unity Hub"` |

### 4단계 — 완전 초기화

아무것도 작동하지 않으면, 제거 후 다시 추가:

```bash
claude mcp remove coplay-mcp    # 또는 unity-mcp
bash auto_setup.sh --path coplay --force
```

추가 세부사항은 `troubleshooting.md`를 참조하세요.

---

## 4. Unity 조작 — MCP 도구 사용법

MCP 연결이 활성화되면, Unity를 직접 제어할 수 있습니다.
전체 도구 레퍼런스와 코드 템플릿은 `unity_operations.md`를 참조하세요.

### 핵심 원칙

1. **먼저 도구를 탐색하세요.** 각 세션 시작 시 사용 가능한 MCP
   도구를 나열하여 어떤 작업이 지원되는지 확인합니다.
2. **복잡한 작업에는 run_code / ExecuteCode를 사용하세요.** 전용 도구가
   없을 때, C# 코드를 작성하여 에디터에서 직접 실행합니다.
3. **각 작업 후 확인하세요.** 오브젝트를 생성하거나 수정한 후
   콘솔과 계층 구조를 확인합니다.
4. **작업을 배치로 처리하세요.** 여러 오브젝트의 경우, 도구를 반복 호출하는
   대신 하나의 C# 스크립트를 작성합니다.

### 씬 관리

**새 씬 생성:**

```text
1. execute_menu_item("File/New Scene")
2. run_code를 통해 저장:
   EditorSceneManager.SaveScene(
       SceneManager.GetActiveScene(), "Assets/Scenes/<Name>.unity");
```

**씬 내용 가져오기:**

```text
get_scene_hierarchy  →  전체 오브젝트 트리 반환
```

**씬 저장:**

```text
execute_menu_item("File/Save")
```

### GameObject 조작

**기본 도형 생성 (Cube, Sphere, Capsule, Plane, Cylinder):**

```text
create_primitive("Cube", name="MyCube")
set_component_property("MyCube", "Transform", "position", {x:0, y:1, z:0})
```

**계층 구조 생성:**

```text
1. 부모 생성: create_gameobject("Player")
2. 자식을 생성하고 Player 아래에 배치
3. 각 자식의 Transform 설정
```

**컴포넌트 추가:**

```text
add_component("Player", "Rigidbody")
add_component("Player", "CharacterController")
set_component_property("Player", "Rigidbody", "mass", 2.0)
```

### 스크립트 개발

사용자가 스크립트 생성을 요청하면, 전체 C# 파일을 생성하고
`create_script` 또는 `run_code`를 사용하여 프로젝트에 작성합니다:

```csharp
// Assets/Scripts/에 스크립트 파일 작성
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

일반적인 스크립트 패턴 (전체 템플릿은 `unity_operations.md` 참조):

- **PlayerController** — CharacterController를 사용한 WASD 이동
- **GameManager** — DontDestroyOnLoad 싱글톤 패턴
- **HealthBarUI** — 색상 그라디언트가 있는 슬라이더 기반 UI
- **CameraFollow** — 오프셋을 사용한 부드러운 추적
- **SceneLoader** — 로딩 화면이 있는 비동기 씬 전환

### 머터리얼 및 비주얼

```csharp
// 색상이 있는 머터리얼 생성 및 할당
run_code(@"
    var obj = GameObject.Find(""MyCube"");
    var mat = new Material(Shader.Find(""Standard""));
    mat.color = Color.red;
    obj.GetComponent<Renderer>().material = mat;
");
```

### 에셋 구조

전문적인 프로젝트 구조 설정:

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

### 디버깅

**콘솔 메시지 읽기:**

```text
get_console_logs  또는  Unity_ReadConsole
→ 오류와 경고를 요약하고 수정 방법 제안
```

**누락된 스크립트 찾기:**

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

## 5. 빠른 프로토타입 워크플로우

사용자가 빠르게 무언가를 만들고 싶을 때, 다음 구조화된 워크플로우를 따르세요.

### 3D 공 굴리기 게임

1. "GameLevel" 씬 생성
2. 바닥 생성 (Plane, 스케일 5x5)
3. 플레이어 생성 (Sphere + Rigidbody, y=0.5)
4. BallController.cs 생성 — 힘 기반 WASD 이동
5. 수집 아이템 생성 (트리거 콜라이더가 있는 작은 큐브)
6. Collectible.cs 생성 — OnTriggerEnter → 파괴 + 점수 추가
7. ScoreManager.cs 싱글톤 생성
8. 점수 텍스트가 있는 UI Canvas 생성
9. 부드러운 추적을 위한 CameraFollow.cs 추가
10. 조명 및 스카이박스 설정

### 2D 플랫포머

1. 2D 씬 생성
2. 바닥 스프라이트 / 타일맵 생성
3. 플레이어 생성 (스프라이트 + Rigidbody2D + BoxCollider2D)
4. PlatformController2D.cs 생성 — 이동 + 점프 + 바닥 체크
5. 다양한 높이에 플랫폼 생성
6. CameraFollow2D.cs 추가
7. 플랫폼 아래 데스 존 추가
8. 점수/생명 UI 추가

### FPS 프로토타입

1. 지형 또는 바닥이 있는 씬 생성
2. 플레이어 생성 (Capsule + CharacterController + Camera를 자식으로)
3. FPSController.cs 생성 — WASD + 마우스 시점
4. 간단한 장애물 생성 (벽, 상자)
5. 사격 메커니즘 추가 (레이캐스트 또는 투사체)
6. 체력이 있는 적 대상 추가
7. 조준점 UI 및 탄약 카운터 추가

### UI 메뉴 시스템

1. Canvas 생성 (Screen Space - Overlay)
2. 타이틀 텍스트 생성 (TextMeshPro)
3. 버튼 생성: Start, Settings, Quit
4. 버튼 핸들러용 MainMenuController.cs 생성
5. 볼륨 슬라이더가 있는 설정 패널 생성
6. 씬 전환 로직 생성

---

## 6. 설정 후 팁

- Unity 프로젝트 루트에서 `claude /init`을 실행하여 프로젝트 규칙을 설명하는
  `CLAUDE.md`를 생성하세요.
- Claude Code에서 `@`를 사용하여 파일을 참조하세요: `@PlayerController.cs`.
- 대규모 작업의 경우 `MCP_TOOL_TIMEOUT`을 늘리세요 (기본값 12분).
- 씬을 자주 저장하세요 — `execute_menu_item("File/Save")`로 실행.
- 전용 MCP 도구가 없는 작업에는 `run_code` / `ExecuteCode`를
  만능 도구로 사용하세요.
