> **Language / 言語:** [English](../../README.md) | [한국어](../ko/README.md) | **日本語** | [繁體中文](../zh-TW/README.md) | [简体中文](../zh-CN/README.md)

# unity-claude-code-skill

Claude Code を Unity AI 開発アシスタントに変える **Claude Code カスタムスキル** です
— ワンクリック MCP セットアップ、自動診断、自然言語による直接的な
Unity Editor 操作をサポートします。

> **Claude Code スキルとは？**
> スキルとは、関連するタスクが発生した際に Claude Code が自動的に読み込む、
> ファイルシステムベースの指示セットです。`SKILL.md` ファイルと、オプションの
> スクリプトや参照資料を含むフォルダとして構成されます。詳細は
> [Claude Code Custom Skills ドキュメント](https://code.claude.com/docs/en/skills)
> をご覧ください。

## このスキルの機能

| 機能 | 説明 |
|---------|-------------|
| **ワンクリックセットアップ** | 自動セットアップスクリプトが1つのコマンドで MCP を設定 |
| **自動診断** | 接続の問題を検出し、修正を提案 |
| **Unity 操作** | MCP ツールを使った Unity 制御のテンプレートとワークフロー |
| **ラピッドプロトタイピング** | 一般的なゲームタイプのステップバイステップワークフロー |
| **スクリプト生成** | PlayerController、GameManager、UI などの C# テンプレート |

### サポートされる MCP パス

- **Path A — Unity Official MCP**（`com.unity.ai.assistant`）— Unity 6+ 向け
- **Path B — Coplay MCP**（コミュニティ）— Unity 2022+ 向け

## リポジトリ構成

```text
unity-claude-code-skill/
├── SKILL.md                        # コアスキル: セットアップ + 操作 + ワークフロー
├── README.md                       # このファイル
├── LICENSE                         # MIT
├── auto_setup.sh                   # ワンクリック MCP セットアップ (macOS/Linux)
├── auto_setup.ps1                  # ワンクリック MCP セットアップ (Windows)
├── unity_operations.md             # 詳細な MCP ツールリファレンス & コードテンプレート
├── verify_setup.sh                 # 前提条件チェッカー (macOS/Linux)
├── verify_setup.ps1                # 前提条件チェッカー (Windows)
├── troubleshooting.md              # よくある問題と解決策
├── .github/workflows/ci.yml        # CI: マークダウンリント、shellcheck、リンクチェック
└── i18n/                           # 翻訳
    ├── ko/                         # 한국어 (Korean)
    ├── ja/                         # 日本語 (Japanese)
    ├── zh-TW/                      # 繁體中文 (Traditional Chinese)
    └── zh-CN/                      # 简体中文 (Simplified Chinese)
```

## クイックインストール

### オプション 1: Claude Code スキルディレクトリにクローン

```bash
# ユーザーレベルのスキル（すべてのプロジェクトで利用可能）
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# またはプロジェクトレベルのスキル（このプロジェクトのみで利用可能）
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### オプション 2: SKILL.md のみコピー

スクリプトなしでコア指示のみが必要な場合：

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/ryan-focus/unity-claude-code-skill/main/SKILL.md
```

## ワンクリック MCP セットアップ

スキルのインストール後、自動セットアップスクリプトを実行して MCP
接続を設定します：

**macOS / Linux:**

```bash
cd ~/.claude/skills/unity-claude-code-setup
bash auto_setup.sh --auto          # 最適なパスを自動検出
bash auto_setup.sh --path coplay   # Coplay MCP を強制指定
bash auto_setup.sh --path unity    # Unity Official MCP を強制指定
```

**Windows (PowerShell):**

```powershell
cd "$env:USERPROFILE\.claude\skills\unity-claude-code-setup"
.\auto_setup.ps1 -Auto             # 最適なパスを自動検出
.\auto_setup.ps1 -Path coplay      # Coplay MCP を強制指定
.\auto_setup.ps1 -Path unity       # Unity Official MCP を強制指定
```

**オプション：**

- `--force` / `-Force` — 既存の MCP 設定を削除してから再追加
- `--timeout <ms>` / `-Timeout <ms>` — カスタムタイムアウト（デフォルト: 720000ms）
- `--coplay-version <ver>` / `-CoplayVersion <ver>` — Coplay サーバーバージョン

## 使い方

インストールして接続が完了したら、Claude Code に自然に話しかけるだけです：

**セットアップ：**

- *「Claude Code と Unity の連携を設定して」*
- *「Unity プロジェクトを MCP 経由で Claude Code に接続したい」*

**操作：**

- *「GameLevel という新しいシーンを作って」*
- *「位置 (0, 2, 0) に赤いキューブを追加して」*
- *「WASD 移動の PlayerController スクリプトを作成して」*
- *「標準的なプロジェクトフォルダ構成をセットアップして」*
- *「Unity コンソールのエラーを確認して」*

**ラピッドプロトタイピング：**

- *「ボール転がしゲームのプロトタイプを作って」*
- *「基本的な 2D プラットフォーマーを作って」*
- *「メインメニュー UI システムを構築して」*

**診断：**

- *「MCP 接続がうまくいかない、修正して」*
- *「Unity のセットアップを診断して」*

## 前提条件

| ツール | 必要なパス | インストール |
|------|-------------|---------|
| Claude Code | 両方のパス | `curl -fsSL https://claude.ai/install.sh \| bash`（macOS/Linux）または `irm https://claude.ai/install.ps1 \| iex`（Windows） |
| Unity 6+ | Path A | [unity.com](https://unity.com/download) |
| Unity 2022+ | Path B | [unity.com](https://unity.com/download) |
| Python >= 3.11 | Path B のみ | [python.org](https://www.python.org/downloads/) |
| Git for Windows | Windows のみ | [git-scm.com](https://git-scm.com/download/win) |

## 主要リソース

- [Unity Official MCP ドキュメント](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code ガイド](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP ドキュメント](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp（GitHub）](https://github.com/CoplayDev/unity-mcp)

## コントリビューション

プルリクエスト歓迎です！手順が古くなっている箇所を見つけたり、Linux や
他の MCP クライアント（Cursor、Windsurf など）のサポートを追加したい場合は、
Issue を作成するかプルリクエストを送ってください。

## ライセンス

MIT — [LICENSE](../../LICENSE) を参照してください。
