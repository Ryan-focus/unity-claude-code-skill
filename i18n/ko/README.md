> **Language / 언어:** [English](../../README.md) | **한국어** | [日本語](../ja/README.md) | [繁體中文](../zh-TW/README.md) | [简体中文](../zh-CN/README.md)

# unity-claude-code-skill

Unity Editor를 MCP(Model Context Protocol)를 통해 Claude Code와 연동하는 과정을 안내하는 **Claude Code 커스텀 Skill**입니다.

> **Claude Code Skill이란?**  
> Skill은 파일 시스템 기반의 명령어 집합으로, Claude Code가 관련 상황에서
> 자동으로 불러옵니다. `SKILL.md` 파일과 선택적 스크립트/참조 자료가 포함된
> 폴더에 위치합니다. 자세한 내용은
> [Claude Code 커스텀 Skill 문서](https://code.claude.com/docs/en/skills)를
> 참고하세요.

## 이 Skill이 하는 일

사용자가 Claude Code와 Unity 연동에 관해 질문하면, 이 Skill이 다음 두 가지 경로에 대한 단계별 가이드를 제공합니다:

- **경로 A – Unity 공식 MCP** (`com.unity.ai.assistant`) — Unity 6 이상용
- **경로 B – Coplay MCP** (커뮤니티) — Unity 2022 이상용

Windows와 macOS 모두에서 설치, 구성, 연결 승인, 검증 및 문제 해결을 다룹니다.

## 저장소 구조

```
unity-claude-code-skill/
├── SKILL.md                        # 핵심 Skill 명령어 (Claude Code가 자동으로 로드)
├── README.md                       # 이 파일
├── LICENSE                         # MIT
├── scripts/
│   ├── verify_setup.sh             # macOS/Linux 사전 요구사항 검사기
│   └── verify_setup.ps1            # Windows 사전 요구사항 검사기
└── references/
    └── troubleshooting.md          # 일반적인 문제 및 해결 방법
```

## 빠른 설치

### 옵션 1: Claude Code skills 디렉토리에 클론

```bash
# 사용자 레벨 Skill (모든 프로젝트에서 사용 가능)
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# 또는 프로젝트 레벨 Skill (현재 프로젝트에서만 사용 가능)
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### 옵션 2: SKILL.md만 복사

스크립트 없이 핵심 명령어만 필요한 경우:

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/<your-username>/unity-claude-code-skill/main/SKILL.md
```

## 사용법

설치가 완료되면 Claude Code에 자연스럽게 말하면 됩니다:

- *"Claude Code와 Unity 연동을 도와줘"*
- *"내 Unity 프로젝트를 MCP를 통해 Claude Code에 연결하고 싶어"*
- *"Unity용 Coplay MCP는 어떻게 설치해?"*
- *"Windows에서 Unity MCP 설정해줘"*

Claude Code가 자동으로 이 Skill을 로드하여 전체 과정을 안내합니다.

### 검증 스크립트 실행

설정 후 모든 것이 올바르게 구성되었는지 확인할 수 있습니다:

**macOS/Linux:**
```bash
bash ~/.claude/skills/unity-claude-code-setup/scripts/verify_setup.sh
```

**Windows (PowerShell):**
```powershell
. "$env:USERPROFILE\.claude\skills\unity-claude-code-setup\scripts\verify_setup.ps1"
```

## 사전 요구사항

| 도구 | 필요한 경로 | 설치 방법 |
|------|------------|----------|
| Claude Code | 두 경로 모두 | `curl -fsSL https://claude.ai/install.sh \| bash` (macOS/Linux) 또는 `irm https://claude.ai/install.ps1 \| iex` (Windows) |
| Unity 6+ | 경로 A | [unity.com](https://unity.com/download) |
| Unity 2022+ | 경로 B | [unity.com](https://unity.com/download) |
| Python ≥ 3.11 | 경로 B만 | [python.org](https://www.python.org/downloads/) |
| Git for Windows | Windows만 | [git-scm.com](https://git-scm.com/download/win) |

## 주요 참고 자료

- [Unity 공식 MCP 문서](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code 가이드](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP 문서](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp GitHub](https://github.com/CoplayDev/unity-mcp)

## 기여하기

PR을 환영합니다! 오래된 단계를 발견하거나 Linux 또는 다른 MCP 클라이언트(Cursor, Windsurf 등) 지원을 추가하고 싶다면, 이슈를 등록하거나 풀 리퀘스트를 제출해 주세요.

## 라이선스

MIT — [LICENSE](../../LICENSE)를 참고하세요.
