> **Language / 言語:** [English](../../README.md) | [한국어](../ko/README.md) | **日本語** | [繁體中文](../zh-TW/README.md) | [简体中文](../zh-CN/README.md)

# unity-claude-code-skill

Unity Editor を MCP（Model Context Protocol）経由で Claude Code に接続するための **Claude Code カスタムスキル** です。

> **Claude Code スキルとは？**
> スキルとは、関連するタスクが発生した際に Claude Code が自動的に読み込む、ファイルシステムベースの指示セットです。`SKILL.md` ファイルと、オプションのスクリプトや参照資料を含むフォルダとして構成されます。詳細は
> [Claude Code Custom Skills ドキュメント](https://code.claude.com/docs/en/skills)
> をご覧ください。

## このスキルの機能

ユーザーが Claude Code と Unity の接続に関する質問をすると、このスキルが以下の手順をステップバイステップでガイドします：

- **Path A – Unity Official MCP**（`com.unity.ai.assistant`）— Unity 6+ 向け
- **Path B – Coplay MCP**（コミュニティ）— Unity 2022+ 向け

**Windows** と **macOS** の両方について、インストール、設定、接続の承認、動作確認、トラブルシューティングをカバーしています。

## リポジトリ構成

```text
unity-claude-code-skill/
├── SKILL.md                        # コアスキル指示（Claude Code が自動読み込み）
├── README.md                       # このファイル
├── LICENSE                         # MIT
├── scripts/
│   ├── verify_setup.sh             # macOS/Linux 前提条件チェッカー
│   └── verify_setup.ps1            # Windows 前提条件チェッカー
└── references/
    └── troubleshooting.md          # よくある問題と解決策
```

## クイックインストール

### オプション 1: Claude Code スキルディレクトリにクローン

```bash
# ユーザーレベルのスキル（すべてのプロジェクトで利用可能）
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# またはプロジェクトレベルのスキル（このプロジェクトのみで利用可能）
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### オプション 2: SKILL.md のみコピー

スクリプトなしでコア指示のみが必要な場合：

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/<your-username>/unity-claude-code-skill/main/SKILL.md
```

## 使い方

インストール後は、Claude Code に自然に話しかけるだけです：

- *「Claude Code と Unity の連携を設定して」*
- *「Unity プロジェクトを MCP 経由で Claude Code に接続したい」*
- *「Unity 用の Coplay MCP をインストールするには？」*
- *「Windows で Unity MCP をセットアップして」*

Claude Code がこのスキルを自動的に読み込み、手順を案内します。

### 検証スクリプトの実行

セットアップ後、すべてが正しく配置されているか確認できます：

**macOS/Linux:**

```bash
bash ~/.claude/skills/unity-claude-code-setup/scripts/verify_setup.sh
```

**Windows (PowerShell):**

```powershell
. "$env:USERPROFILE\.claude\skills\unity-claude-code-setup\scripts\verify_setup.ps1"
```

## 前提条件

| ツール | 必要なパス | インストール |
|------|-------------|---------|
| Claude Code | 両方のパス | `curl -fsSL https://claude.ai/install.sh \| bash`（macOS/Linux）または `irm https://claude.ai/install.ps1 \| iex`（Windows） |
| Unity 6+ | Path A | [unity.com](https://unity.com/download) |
| Unity 2022+ | Path B | [unity.com](https://unity.com/download) |
| Python ≥ 3.11 | Path B のみ | [python.org](https://www.python.org/downloads/) |
| Git for Windows | Windows のみ | [git-scm.com](https://git-scm.com/download/win) |

## 主要リソース

- [Unity Official MCP ドキュメント](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code ガイド](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP ドキュメント](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp（GitHub）](https://github.com/CoplayDev/unity-mcp)

## コントリビューション

プルリクエスト歓迎です！ 手順が古くなっている箇所を見つけたり、Linux や他の MCP クライアント（Cursor、Windsurf など）のサポートを追加したい場合は、Issue を作成するかプルリクエストを送ってください。

## ライセンス

MIT — [LICENSE](../../LICENSE) を参照してください。
