---
name: unity-claude-code-setup
description: >
  Claude Code のインストール、MCP（Model Context Protocol）経由での Unity Editor への接続、
  および統合の動作確認までをステップバイステップでガイドします。Unity Official MCP
  （com.unity.ai.assistant）とコミュニティの Coplay MCP の両方をカバーしています。
  Windows と macOS に対応しています。このスキルは、ユーザーが Claude Code と Unity の
  セットアップ、AI アシスタントと Unity Editor の接続、Unity MCP のインストール、
  Coplay MCP のセットアップ、または自然言語を使って Claude Code 経由で Unity のシーン、
  GameObject、アセット、スクリプトを操作したいと言及した場合にご利用ください。
  また、AI 支援による Unity 開発の前提条件、Claude Code + Unity 接続のトラブル
  シューティング、Unity MCP と Coplay MCP の比較についてユーザーが質問した場合にも
  トリガーされます。
---

# Unity + Claude Code + MCP セットアップガイド

このスキルは、Claude Code を MCP 経由で Unity Editor に接続し、自然言語でシーン、アセット、スクリプトなどを操作できるようにする手順を案内します。

**2つのメインパス** があります。ユーザーの状況に合ったものを選んでください：

| パス | 使用する場合 |
|------|-------------|
| **Path A – Unity Official MCP** | Unity 6+ で `com.unity.ai.assistant` パッケージを使用。Unity 公式サポート。 |
| **Path B – Coplay MCP（コミュニティ）** | Unity 2022+。より多くのツール、迅速なイテレーション、コミュニティ主導。 |

ユーザーが迷っている場合は、使用している Unity のバージョンを確認してください。Unity 6+ ユーザーはどちらのパスも使用可能です。Unity 2022〜2023 ユーザーは Path B を使用してください。

---

## 共通の前提条件

どちらのパスでも、以下が準備されていることを確認してください：

### 1. Claude Code のインストール

Claude Code には有料の Anthropic プラン（Pro、Max、Team、または Enterprise）が必要です。

**macOS / Linux:**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows (PowerShell):**

```powershell
irm https://claude.ai/install.ps1 | iex
```
> Windows では **Git for Windows** のインストールも必要です。

**確認：**

```bash
claude --version
```

初回起動後、`claude` を実行してブラウザのプロンプトに従い認証を行ってください。

### 2. Unity のインストール確認

- Path A には **Unity 6（6000.0）** 以降が必要です。
- Path B には **Unity 2022** 以降が必要です。

---

## Path A – Unity Official MCP

### A1. AI Assistant パッケージのインストール

Unity で **Window > Package Manager** を開き、**+** をクリックして **Add package by name** を選択し、以下を入力します：

```text
com.unity.ai.assistant
```

### A2. Unity Bridge の起動

1. **Edit > Project Settings > AI > Unity MCP** に移動します。
2. **Unity Bridge** のステータスが **Running**（緑色）であることを確認します。
3. **Stopped** と表示されている場合は、**Start** をクリックします。

relay binary は `~/.unity/relay/` に自動的にインストールされます。

### A3. Claude Code の設定

**オプション 1 – 自動設定（推奨）：**
Unity の **Project Settings > AI > Unity MCP > Integrations** で **Claude Code** を見つけて **Configure** をクリックします。

**オプション 2 – 手動設定：**

ターミナルで以下を実行します：

```bash
claude mcp add unity-mcp -- <RELAY_PATH> --mcp
```

`<RELAY_PATH>` をお使いのプラットフォームに応じた正しいパスに置き換えてください：

| プラットフォーム | relay パス |
|----------|-----------|
| macOS (Apple Silicon) | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
| macOS (Intel) | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
| Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

### A4. 接続の承認

1. Unity に戻り：**Edit > Project Settings > AI > Unity MCP** を開きます。
2. **Pending Connections** の項目を確認し、**Accept** をクリックします。

以前承認したクライアントは自動的に再接続されます。

### A5. テスト

Claude Code で以下を試してみてください：

```text
Read the Unity console messages and summarize any warnings or errors.
```

Claude が `Unity_ReadConsole` を呼び出せれば、セットアップは完了です。

---

## Path B – Coplay MCP（コミュニティ）

### B1. Python 3.11+ のインストール

Coplay の MCP サーバーには Python 3.11 以上が必要です。

**確認：**

```bash
python3 --version   # macOS/Linux
python --version    # Windows
```

インストールされていない場合：
- macOS: `brew install python@3.11`
- Windows: <https://www.python.org/downloads/> からダウンロード

### B2. Coplay Unity パッケージのインストール

1. Unity プロジェクトを開きます。
2. **Window > Package Manager > + > Add package from git URL** を選択します。
3. 以下を入力します：

   ```text
   https://github.com/CoplayDev/unity-plugin.git#beta
   ```
4. Coplay が有効になり、Editor で実行されていることを確認します。

### B3. Claude Code に Coplay MCP を追加

```bash
claude mcp add \
  --scope user \
  --transport stdio \
  coplay-mcp \
  --env MCP_TOOL_TIMEOUT=720000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```

> Windows では PowerShell で実行してください。`uvx` が見つからない場合は、先に
> `pip install uv` でインストールしてください。

### B4. 確認

```bash
claude mcp list
```

一覧に `coplay-mcp` が表示されるはずです。

### B5. テスト

Unity プロジェクトを開いた状態で、Claude Code で以下を試してください：

```text
List all open Unity editors
```

次に以下を試してください：

```text
Create a red cube at position (0, 1, 0) in the current Unity scene
```

---

## トラブルシューティング

よくある問題については `references/troubleshooting.md` を参照してください。以下の内容が含まれています：

- `claude` コマンドが見つからない
- MCP サーバーが「connecting」のまま停止する
- Unity が MCP クライアントを検出しない
- Finder から起動した場合の macOS PATH の問題
- 大規模な操作でのタイムアウトエラー
- Windows 固有の PowerShell の問題

---

## セットアップ後のヒント

- Unity プロジェクトのルートで `claude /init` を実行し、プロジェクトの規約を Claude Code に伝える `CLAUDE.md` を生成してください。
- Claude Code で `@` シンボルを使って特定のファイルを参照できます。例：`@PlayerController.cs`
- Coplay MCP で長時間の操作によるタイムアウトエラーが発生する場合は、`MCP_TOOL_TIMEOUT` の値を増やしてください（デフォルトは 720000ms = 12分）。
