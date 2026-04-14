---
name: unity-claude-code-setup
description: >
  Step-by-step guide to install Claude Code, connect it to Unity Editor via MCP
  (Model Context Protocol), and verify the integration works. Covers both the
  Unity official MCP (com.unity.ai.assistant) and the community Coplay MCP.
  Supports Windows and macOS. Use this skill whenever the user mentions setting
  up Claude Code with Unity, connecting an AI assistant to Unity Editor,
  Unity MCP installation, Coplay MCP setup, or wants to use natural-language
  commands to control Unity scenes, GameObjects, assets, or scripts through
  Claude Code. Also trigger when the user asks about prerequisites for
  AI-assisted Unity development, troubleshooting Claude Code + Unity connections,
  or comparing Unity MCP vs Coplay MCP.
---

# Unity + Claude Code + MCP 설정 가이드

이 Skill은 Claude Code를 MCP를 통해 Unity Editor에 연결하여 자연어로 씬, 에셋, 스크립트 등을 제어할 수 있도록 안내합니다.

**두 가지 주요 경로**가 있습니다. 사용자의 상황에 맞는 경로를 선택하세요:

| 경로 | 사용 시기 |
|------|----------|
| **경로 A – Unity 공식 MCP** | Unity 6 이상, `com.unity.ai.assistant` 패키지 사용. Unity에서 공식 지원합니다. |
| **경로 B – Coplay MCP (커뮤니티)** | Unity 2022 이상. 더 많은 도구, 빠른 업데이트, 커뮤니티 주도 방식입니다. |

사용자가 확신이 없는 경우, Unity 버전을 먼저 확인하세요. Unity 6 이상 사용자는 두 경로 모두 사용할 수 있으며, Unity 2022~2023 사용자는 경로 B를 사용해야 합니다.

---

## 공통 사전 요구사항

어느 경로든 시작하기 전에 다음 사항을 확인하세요:

### 1. Claude Code 설치

Claude Code는 유료 Anthropic 플랜(Pro, Max, Team 또는 Enterprise)이 필요합니다.

**macOS / Linux:**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows (PowerShell):**

```powershell
irm https://claude.ai/install.ps1 | iex
```
> Windows에서는 **Git for Windows**도 설치되어 있어야 합니다.

**확인:**

```bash
claude --version
```

최초 실행 시 `claude`를 실행하고 브라우저 안내에 따라 인증을 완료하세요.

### 2. Unity 설치 확인

- 경로 A는 **Unity 6 (6000.0)** 이상이 필요합니다.
- 경로 B는 **Unity 2022** 이상이 필요합니다.

---

## 경로 A – Unity 공식 MCP

### A1. AI Assistant 패키지 설치

Unity에서 **Window > Package Manager**로 이동하고, **+** 를 클릭한 후
**Add package by name**을 선택하여 다음을 입력합니다:

```text
com.unity.ai.assistant
```

### A2. Unity Bridge 시작

1. **Edit > Project Settings > AI > Unity MCP**로 이동합니다.
2. **Unity Bridge** 상태가 **Running**(녹색)으로 표시되는지 확인합니다.
3. **Stopped**로 표시되면 **Start**를 클릭합니다.

relay binary는 `~/.unity/relay/`에 자동으로 설치됩니다.

### A3. Claude Code 구성

**옵션 1 – 자동 구성 (권장):**
Unity의 **Project Settings > AI > Unity MCP > Integrations**에서
**Claude Code**를 찾아 **Configure**를 클릭합니다.

**옵션 2 – 수동 구성:**

터미널에서 실행합니다:

```bash
claude mcp add unity-mcp -- <RELAY_PATH> --mcp
```

`<RELAY_PATH>`를 해당 플랫폼에 맞는 경로로 교체하세요:

| 플랫폼 | Relay 경로 |
|--------|-----------|
| macOS (Apple Silicon) | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
| macOS (Intel) | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
| Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

### A4. 연결 승인

1. Unity로 돌아가서 **Edit > Project Settings > AI > Unity MCP**를 엽니다.
2. **Pending Connections** 아래에서 확인 후 **Accept**를 클릭합니다.

이전에 승인된 클라이언트는 자동으로 재연결됩니다.

### A5. 테스트

Claude Code에서 다음을 시도하세요:

```text
Read the Unity console messages and summarize any warnings or errors.
```

Claude가 `Unity_ReadConsole`를 호출할 수 있다면 설정이 완료된 것입니다.

---

## 경로 B – Coplay MCP (커뮤니티)

### B1. Python 3.11 이상 설치

Coplay의 MCP 서버는 Python 3.11 이상이 필요합니다.

**확인:**

```bash
python3 --version   # macOS/Linux
python --version    # Windows
```

설치되어 있지 않은 경우:
- macOS: `brew install python@3.11`
- Windows: <https://www.python.org/downloads/> 에서 다운로드

### B2. Coplay Unity 패키지 설치

1. Unity 프로젝트를 엽니다.
2. **Window > Package Manager > + > Add package from git URL**을 선택합니다.
3. 다음을 입력합니다:

   ```text
   https://github.com/CoplayDev/unity-plugin.git#beta
   ```
4. Coplay가 Editor에서 활성화되어 실행 중인지 확인합니다.

### B3. Claude Code에 Coplay MCP 추가

```bash
claude mcp add \
  --scope user \
  --transport stdio \
  coplay-mcp \
  --env MCP_TOOL_TIMEOUT=720000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```

> Windows에서는 PowerShell에서 실행하세요. `uvx`를 찾을 수 없는 경우,
> 먼저 `pip install uv`로 설치하세요.

### B4. 확인

```bash
claude mcp list
```

목록에 `coplay-mcp`가 표시되어야 합니다.

### B5. 테스트

Unity 프로젝트를 연 후, Claude Code에서 다음을 시도하세요:

```text
List all open Unity editors
```

그런 다음:

```text
Create a red cube at position (0, 1, 0) in the current Unity scene
```

---

## 문제 해결

일반적인 문제에 대해서는 `references/troubleshooting.md`를 참고하세요:

- `claude` 명령어를 찾을 수 없음
- MCP 서버가 "connecting" 상태에서 멈춤
- Unity에서 MCP 클라이언트를 감지하지 못함
- Finder에서 Unity를 실행할 때 macOS PATH 문제
- 대규모 작업에서의 타임아웃 오류
- Windows 전용 PowerShell 관련 문제

---

## 설정 후 팁

- Unity 프로젝트 루트에서 `claude /init`을 실행하여 프로젝트 규칙을 Claude Code에 알려주는 `CLAUDE.md`를 생성하세요.
- Claude Code에서 `@` 기호를 사용하여 특정 파일을 참조할 수 있습니다. 예: `@PlayerController.cs`
- Coplay MCP의 경우, 장시간 작업에서 타임아웃 오류가 발생하면 `MCP_TOOL_TIMEOUT` 값을 늘리세요 (기본값은 720000ms = 12분).
