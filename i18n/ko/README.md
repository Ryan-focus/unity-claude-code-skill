> **Language / 언어:** [English](../../README.md) | **한국어** | [日本語](../ja/README.md) | [繁體中文](../zh-TW/README.md) | [简体中文](../zh-CN/README.md)

# unity-claude-code-skill

Claude Code를 Unity AI 개발 어시스턴트로 변환하는 **Claude Code 커스텀 Skill**입니다
— 원클릭 MCP 설정, 자동 진단, 자연어를 통한 직접적인
Unity Editor 조작을 지원합니다.

> **Claude Code Skill이란?**
> Skill은 파일 시스템 기반의 명령어 집합으로, Claude Code가 관련 상황에서
> 자동으로 불러옵니다. `SKILL.md` 파일과 선택적 스크립트/참조 자료가 포함된
> 폴더에 위치합니다. 자세한 내용은
> [Claude Code Custom Skills 문서](https://code.claude.com/docs/en/skills)를
> 참고하세요.

## 이 Skill이 하는 일

| 기능 | 설명 |
|---------|-------------|
| **원클릭 설정** | 자동 설정 스크립트가 단일 명령으로 MCP를 구성 |
| **자동 진단** | 연결 문제를 감지하고 해결 방법 제안 |
| **Unity 조작** | MCP 도구를 통한 Unity 제어 템플릿 및 워크플로우 |
| **빠른 프로토타이핑** | 일반적인 게임 유형을 위한 단계별 워크플로우 |
| **스크립트 생성** | PlayerController, GameManager, UI 등의 C# 템플릿 |

### 지원하는 MCP 경로

- **경로 A — Unity 공식 MCP** (`com.unity.ai.assistant`) — Unity 6+ 용
- **경로 B — Coplay MCP** (커뮤니티) — Unity 2022+ 용

## 저장소 구조

```text
unity-claude-code-skill/
├── SKILL.md                        # 핵심 Skill: 설정 + 조작 + 워크플로우
├── README.md                       # 이 파일
├── LICENSE                         # MIT
├── auto_setup.sh                   # 원클릭 MCP 설정 (macOS/Linux)
├── auto_setup.ps1                  # 원클릭 MCP 설정 (Windows)
├── unity_operations.md             # 상세 MCP 도구 레퍼런스 & 코드 템플릿
├── verify_setup.sh                 # 사전 요구사항 검사기 (macOS/Linux)
├── verify_setup.ps1                # 사전 요구사항 검사기 (Windows)
├── troubleshooting.md              # 일반적인 문제 & 해결 방법
├── .github/workflows/ci.yml        # CI: 마크다운 린트, shellcheck, 링크 검사
└── i18n/                           # 번역
    ├── ko/                         # 한국어 (Korean)
    ├── ja/                         # 日本語 (Japanese)
    ├── zh-TW/                      # 繁體中文 (Traditional Chinese)
    └── zh-CN/                      # 简体中文 (Simplified Chinese)
```

## 빠른 설치

### 옵션 1: Claude Code skills 디렉토리에 클론

```bash
# 사용자 레벨 Skill (모든 프로젝트에서 사용 가능)
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# 또는 프로젝트 레벨 Skill (현재 프로젝트에서만 사용 가능)
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### 옵션 2: SKILL.md만 복사

스크립트 없이 핵심 명령어만 필요한 경우:

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/ryan-focus/unity-claude-code-skill/main/SKILL.md
```

## 원클릭 MCP 설정

Skill 설치 후, 자동 설정 스크립트를 실행하여 MCP 연결을 구성하세요:

**macOS / Linux:**

```bash
cd ~/.claude/skills/unity-claude-code-setup
bash auto_setup.sh --auto          # 최적 경로 자동 감지
bash auto_setup.sh --path coplay   # Coplay MCP 강제 지정
bash auto_setup.sh --path unity    # Unity 공식 MCP 강제 지정
```

**Windows (PowerShell):**

```powershell
cd "$env:USERPROFILE\.claude\skills\unity-claude-code-setup"
.\auto_setup.ps1 -Auto             # 최적 경로 자동 감지
.\auto_setup.ps1 -Path coplay      # Coplay MCP 강제 지정
.\auto_setup.ps1 -Path unity       # Unity 공식 MCP 강제 지정
```

**옵션:**

- `--force` / `-Force` — 기존 MCP 설정을 제거한 후 다시 추가
- `--timeout <ms>` / `-Timeout <ms>` — 커스텀 타임아웃 (기본값: 720000ms)
- `--coplay-version <ver>` / `-CoplayVersion <ver>` — Coplay 서버 버전

## 사용법

설치 및 연결이 완료되면, Claude Code에 자연스럽게 말하면 됩니다:

**설정:**

- *"Claude Code와 Unity 연동을 도와줘"*
- *"내 Unity 프로젝트를 MCP를 통해 Claude Code에 연결하고 싶어"*

**조작:**

- *"GameLevel이라는 새 씬을 만들어줘"*
- *"위치 (0, 2, 0)에 빨간 큐브를 추가해줘"*
- *"WASD 이동이 가능한 PlayerController 스크립트를 만들어줘"*
- *"표준 프로젝트 폴더 구조를 설정해줘"*
- *"Unity 콘솔에서 오류를 확인해줘"*

**빠른 프로토타이핑:**

- *"공 굴리기 게임 프로토타입을 만들어줘"*
- *"기본 2D 플랫포머를 만들어줘"*
- *"메인 메뉴 UI 시스템을 만들어줘"*

**진단:**

- *"MCP 연결이 안 돼, 수리 좀 해줘"*
- *"Unity 설정에 대해 진단을 실행해줘"*

## 사전 요구사항

| 도구 | 필요한 경로 | 설치 방법 |
|------|-------------|---------|
| Claude Code | 두 경로 모두 | `curl -fsSL https://claude.ai/install.sh \| bash` (macOS/Linux) 또는 `irm https://claude.ai/install.ps1 \| iex` (Windows) |
| Unity 6+ | 경로 A | [unity.com](https://unity.com/download) |
| Unity 2022+ | 경로 B | [unity.com](https://unity.com/download) |
| Python >= 3.11 | 경로 B만 | [python.org](https://www.python.org/downloads/) |
| Git for Windows | Windows만 | [git-scm.com](https://git-scm.com/download/win) |

## 주요 참고 자료

- [Unity 공식 MCP 문서](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code 가이드](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP 문서](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp GitHub](https://github.com/CoplayDev/unity-mcp)

## 기여하기

PR을 환영합니다! 오래된 단계를 발견하거나 Linux 또는 다른 MCP 클라이언트
(Cursor, Windsurf 등) 지원을 추가하고 싶다면, 이슈를 등록하거나
풀 리퀘스트를 제출해 주세요.

## 라이선스

MIT — [LICENSE](../../LICENSE)를 참고하세요.
