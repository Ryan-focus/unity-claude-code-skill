# トラブルシューティング – Unity + Claude Code + MCP

## `claude` コマンドが見つからない

**macOS/Linux:**
ネイティブインストーラーは `claude` を自動的に PATH に追加します。インストール後もコマンドが見つからない場合は、ターミナルを再起動するか、以下を実行してください：
```bash
source ~/.bashrc   # または ~/.zshrc
```

**Windows:**
Git for Windows がインストールされていることを確認してください（ネイティブインストーラーに必要です）。インストール後に PowerShell を再起動してください。それでも見つからない場合は、以下を試してください：
```powershell
irm https://claude.ai/install.ps1 | iex
```

npm 経由でインストールした場合（非推奨）、グローバル npm bin が PATH に含まれていることを確認してください：
```bash
npm config get prefix
# <prefix>/bin を PATH に追加してください
```

---

## MCP サーバーが接続できない / 「connecting」のまま停止する

### Path A（Unity Official MCP）
1. Project Settings > AI > Unity MCP で Unity Bridge が **Running** になっていることを確認します。
2. relay binary が `~/.unity/relay/` に存在することを確認します。
3. Configure の手順を再実行するか、手動で再追加します：
   ```bash
   claude mcp remove unity-mcp
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```
4. Claude Code を再起動します。

### Path B（Coplay MCP）
1. Python 3.11 以上であることを確認します：`python3 --version`
2. 削除して再追加します：
   ```bash
   claude mcp remove coplay-mcp
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```
3. Claude Code を再起動します。

---

## Unity が MCP クライアントを検出しない

- Claude Code を起動する **前に** Unity Editor が開いていることを確認してください。
- Path A の場合、Project Settings の **Pending Connections** を確認し、Accept をクリックしてください。
- Path B の場合、Coplay パッケージが Editor にインストールされ、有効になっていることを確認してください。

---

## macOS PATH の問題 – Finder/Hub から Unity を起動した場合

Finder や Unity Hub から（ターミナルからではなく）Unity を起動した場合、Editor がシェルの PATH を引き継がないことがあります。これにより、Unity の内部プロセスが `claude` を見つけられない場合があります。

**解決策：**
1. ターミナルから Unity Hub を起動して PATH を引き継がせます：
   ```bash
   open -a "Unity Hub"
   ```
2. Unity MCP の設定で「Choose Claude Install Location」オプションを使用して、`claude` バイナリの絶対パスを設定します（例：`/usr/local/bin/claude` または `which claude` で表示されるパス）。

---

## 大規模な操作でのタイムアウトエラー

**Coplay MCP：** タイムアウト値を増やすために、削除して再追加します：
```bash
claude mcp remove coplay-mcp
claude mcp add --scope user --transport stdio coplay-mcp \
  --env MCP_TOOL_TIMEOUT=1800000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```
（1800000ms = 30分）

**Unity Official MCP：** タイムアウトは relay binary によって管理されます。問題が発生した場合は、Unity のコンソールでエラーを確認し、プロジェクトが重いコンパイル状態にないことを確認してください。

---

## Windows PowerShell 固有の問題

- `The token '&&' is not a valid statement separator` というエラーが表示される場合、PowerShell を使用しています。`&&` の代わりに `;` を使用するか、コマンドを1つずつ実行してください。
- `uvx` が認識されない場合は、先にインストールしてください：
  ```powershell
  pip install uv
  ```
- Python のインストール時にシステム PATH に追加するチェックボックスをオンにしてください。

---

## HTTP と stdio トランスポートの切り替え

MCP for Unity ウィンドウでトランスポートモードを変更した場合（例：HTTP から stdio へ）、変更を反映するには **Claude Code を再起動する必要があります**。

---

## それでも解決しない場合

- Unity Official MCP: https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-troubleshooting.html
- Coplay MCP: https://docs.coplay.dev/essentials/troubleshooting
- Claude Code: https://code.claude.com/docs/en/troubleshooting
- CoplayDev/unity-mcp GitHub Issues: https://github.com/CoplayDev/unity-mcp/issues
