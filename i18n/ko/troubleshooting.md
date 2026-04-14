# 문제 해결 – Unity + Claude Code + MCP

## `claude` 명령어를 찾을 수 없음

**macOS/Linux:**
네이티브 설치 프로그램이 자동으로 `claude`를 PATH에 추가합니다. 설치 후에도
찾을 수 없는 경우, 터미널을 재시작하거나 다음을 실행하세요:

```bash
source ~/.bashrc   # or ~/.zshrc
```

**Windows:**
Git for Windows가 설치되어 있는지 확인하세요 (네이티브 설치 프로그램에 필요합니다).
설치 후 PowerShell을 재시작하세요. 여전히 찾을 수 없는 경우 다음을 시도하세요:

```powershell
irm https://claude.ai/install.ps1 | iex
```

npm으로 설치한 경우(지원 종료), 전역 npm bin이 PATH에 포함되어 있는지 확인하세요:

```bash
npm config get prefix
# <prefix>/bin을 PATH에 추가하세요
```

---

## MCP 서버가 연결되지 않음 / "connecting" 상태에서 멈춤

### 경로 A (Unity 공식 MCP)
1. Project Settings > AI > Unity MCP에서 Unity Bridge가 **Running** 상태인지 확인합니다.
2. relay binary가 `~/.unity/relay/`에 존재하는지 확인합니다.
3. Configure 단계를 다시 실행하거나 수동으로 재추가합니다:

   ```bash
   claude mcp remove unity-mcp
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```
4. Claude Code를 재시작합니다.

### 경로 B (Coplay MCP)
1. Python 3.11 이상인지 확인합니다: `python3 --version`
2. 제거 후 재추가합니다:

   ```bash
   claude mcp remove coplay-mcp
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```
3. Claude Code를 재시작합니다.

---

## Unity에서 MCP 클라이언트를 감지하지 못함

- Claude Code를 시작하기 **전에** Unity Editor가 열려 있는지 확인하세요.
- 경로 A의 경우, Project Settings에서 **Pending Connections**를 확인하고 Accept를 클릭하세요.
- 경로 B의 경우, Coplay 패키지가 Editor에 설치되어 활성화되어 있는지 확인하세요.

---

## macOS PATH 문제 – Finder/Hub에서 Unity를 실행한 경우

Finder 또는 Unity Hub(터미널이 아닌)에서 Unity를 실행하면, Editor가 셸의 PATH를 상속받지 못할 수 있습니다. 이 경우 Unity의 내부 프로세스에서 `claude`를 찾지 못할 수 있습니다.

**해결 방법:**
1. PATH가 전달되도록 터미널에서 Unity Hub를 실행합니다:

   ```bash
   open -a "Unity Hub"
   ```
2. Unity MCP 설정에서 "Choose Claude Install Location" 옵션을 사용하여
   `claude` 바이너리의 절대 경로를 설정합니다 (예: `/usr/local/bin/claude`
   또는 `which claude`로 확인한 경로).

---

## 대규모 작업에서의 타임아웃 오류

**Coplay MCP:** 제거 후 더 높은 값으로 재추가하여 타임아웃을 늘립니다:

```bash
claude mcp remove coplay-mcp
claude mcp add --scope user --transport stdio coplay-mcp \
  --env MCP_TOOL_TIMEOUT=1800000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```
(1800000ms = 30분)

**Unity 공식 MCP:** 타임아웃은 relay binary에서 관리됩니다. 문제가 발생하면 Unity 콘솔에서 오류를 확인하고 프로젝트가 과도한 컴파일 상태가 아닌지 확인하세요.

---

## Windows PowerShell 관련 문제

- `The token '&&' is not a valid statement separator` 오류가 표시되면 PowerShell을 사용 중인 것입니다. `&&` 대신 `;`를 사용하거나 명령어를 하나씩 실행하세요.
- `uvx`를 인식하지 못하는 경우, 먼저 설치합니다:

  ```powershell
  pip install uv
  ```
- Python 설치 시 시스템 PATH에 추가되었는지 확인하세요 (Python 설치 프로그램에서 해당 체크박스를 선택).

---

## HTTP와 stdio 전송 모드 간 전환

MCP for Unity 창에서 전송 모드를 변경한 경우(예: HTTP에서 stdio로), 변경 사항이 적용되려면 **Claude Code를 반드시 재시작**해야 합니다.

---

## 여전히 해결되지 않는 경우

- Unity 공식 MCP: <https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-troubleshooting.html>
- Coplay MCP: <https://docs.coplay.dev/essentials/troubleshooting>
- Claude Code: <https://code.claude.com/docs/en/troubleshooting>
- CoplayDev/unity-mcp GitHub Issues: <https://github.com/CoplayDev/unity-mcp/issues>
