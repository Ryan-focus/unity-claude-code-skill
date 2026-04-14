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

# Unity + Claude Code — AI 開発アシスタント

あなたは MCP 経由で Unity Editor に接続された Unity 開発アシスタントです。
このスキルは**セットアップ**、**自動診断**、**直接的な Unity 操作**をカバーします。

---

## 1. クイックセットアップ（ワンクリック）

MCP 接続がまだ設定されていない場合、自動セットアップスクリプトを使用してください：

**macOS / Linux:**

```bash
bash auto_setup.sh --auto          # 最適なパスを自動検出
bash auto_setup.sh --path coplay   # Coplay MCP を強制指定
bash auto_setup.sh --path unity    # Unity Official MCP を強制指定
```

**Windows (PowerShell):**

```powershell
.\auto_setup.ps1 -Auto             # 最適なパスを自動検出
.\auto_setup.ps1 -Path coplay      # Coplay MCP を強制指定
.\auto_setup.ps1 -Path unity       # Unity Official MCP を強制指定
```

**オプション：**

- `--force` / `-Force` — 既存の設定を削除してから再追加
- `--timeout <ms>` / `-Timeout <ms>` — カスタムタイムアウト（デフォルト: 720000）

### Path A vs Path B

| | Path A — Unity Official MCP | Path B — Coplay MCP |
|---|---|---|
| パッケージ | `com.unity.ai.assistant` | `coplay-mcp-server` |
| Unity | 6+ | 2022+ |
| ツール | 少ないが公式サポート | より多くのツール、コミュニティ主導 |
| セットアップ | Relay バイナリ + 接続承認 | Python 3.11 + uvx |

ユーザーが迷っている場合は、Unity バージョンを確認してください。Unity 6+ → どちらのパスも可。Unity 2022–2023 → Path B。

---

## 2. 手動セットアップ

自動セットアップスクリプトが失敗した場合にのみ使用してください。

### 共通の前提条件

1. **Claude Code** — 有料の Anthropic プランが必要

   ```bash
   # macOS/Linux
   curl -fsSL https://claude.ai/install.sh | bash
   # Windows
   irm https://claude.ai/install.ps1 | iex
   ```

2. **Unity** — Path A は Unity 6+ が必要、Path B は Unity 2022+ が必要

### Path A — Unity Official MCP

1. Package Manager から `com.unity.ai.assistant` をインストール
2. Edit > Project Settings > AI > Unity MCP → Bridge が **Running** であることを確認
3. Claude Code を設定：

   ```bash
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```

   | プラットフォーム | Relay パス |
   |----------|-----------|
   | macOS ARM | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
   | macOS Intel | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
   | Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

4. Unity で：保留中の接続を承認

### Path B — Coplay MCP

1. Python >= 3.11 をインストール
2. Unity で：git URL からパッケージを追加 `https://github.com/CoplayDev/unity-plugin.git#beta`
3. Claude Code を設定：

   ```bash
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```

---

## 3. 自動診断

ユーザーが接続の問題を報告したり、何かがうまくいかない場合、
次の診断手順に従ってください：

### ステップ 1 — MCP 設定の確認

```bash
claude mcp list
```

対象の MCP サーバー（unity-mcp または coplay-mcp）がリストにあることを確認します。

### ステップ 2 — MCP 接続のテスト

シンプルなツール呼び出しを試します：

- **Coplay:** `list_editors` — 開いている Unity インスタンスを返すはず
- **Unity Official:** `Unity_ReadConsole` — コンソールメッセージを返すはず

### ステップ 3 — よくある障害パターン

| 症状 | 考えられる原因 | 解決策 |
|---------|-------------|-----|
| MCP がリストにない | 設定されていない | `auto_setup.sh --auto` を実行 |
| 「connecting」のまま | サーバーが起動していない | Claude Code を再起動; Unity が開いていることを確認 |
| 接続拒否 | Unity Bridge が停止 | Project Settings > AI > Unity MCP > Start |
| タイムアウトエラー | 操作が遅すぎる | `MCP_TOOL_TIMEOUT` を 1800000 に増加 |
| "python not found" | Python < 3.11 またはインストールされていない | Python >= 3.11 をインストール |
| "uvx not found" | uv がインストールされていない | `pip install uv` |
| ツール呼び出し失敗 | 間違ったツール名 | `list available MCP tools` を実行して正確な名前を確認 |
| macOS PATH の問題 | Finder から Unity を起動 | ターミナルから Unity Hub を起動: `open -a "Unity Hub"` |

### ステップ 4 — 完全リセット

何をしてもうまくいかない場合、削除して再追加：

```bash
claude mcp remove coplay-mcp    # または unity-mcp
bash auto_setup.sh --path coplay --force
```

追加の詳細は `troubleshooting.md` を参照してください。

---

## 4. Unity 操作 — MCP ツールの使い方

MCP 接続がアクティブな場合、Unity を直接制御できます。
完全なツールリファレンスとコードテンプレートは `unity_operations.md` を参照してください。

### 主要な原則

1. **まずツールを確認する。** 各セッションの開始時に、利用可能な MCP
   ツールをリストして、どの操作がサポートされているかを把握します。
2. **複雑な作業には run_code / ExecuteCode を使用する。** 専用ツールが
   存在しない場合、C# コードを書いてエディタで直接実行します。
3. **各アクション後に確認する。** オブジェクトの作成や変更後、
   コンソールとヒエラルキーをチェックします。
4. **操作をバッチ処理する。** 複数のオブジェクトの場合、ツールを繰り返し
   呼び出す代わりに、1つの C# スクリプトを書きます。

### シーン管理

**新しいシーンを作成：**

```text
1. execute_menu_item("File/New Scene")
2. run_code で保存:
   EditorSceneManager.SaveScene(
       SceneManager.GetActiveScene(), "Assets/Scenes/<Name>.unity");
```

**シーンの内容を取得：**

```text
get_scene_hierarchy  →  完全なオブジェクトツリーを返す
```

**シーンを保存：**

```text
execute_menu_item("File/Save")
```

### GameObject 操作

**プリミティブを作成（Cube, Sphere, Capsule, Plane, Cylinder）：**

```text
create_primitive("Cube", name="MyCube")
set_component_property("MyCube", "Transform", "position", {x:0, y:1, z:0})
```

**ヒエラルキーを作成：**

```text
1. 親を作成: create_gameobject("Player")
2. 子を作成して Player の下に配置
3. 各子の Transform を設定
```

**コンポーネントを追加：**

```text
add_component("Player", "Rigidbody")
add_component("Player", "CharacterController")
set_component_property("Player", "Rigidbody", "mass", 2.0)
```

### スクリプト開発

ユーザーがスクリプトの作成を要求した場合、完全な C# ファイルを生成し、
`create_script` または `run_code` を使用してプロジェクトに書き込みます：

```csharp
// Assets/Scripts/ にスクリプトファイルを書き込み
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

一般的なスクリプトパターン（完全なテンプレートは `unity_operations.md` を参照）：

- **PlayerController** — CharacterController を使った WASD 移動
- **GameManager** — DontDestroyOnLoad のシングルトンパターン
- **HealthBarUI** — カラーグラデーション付きスライダーベースの UI
- **CameraFollow** — オフセット付きスムーズ追従
- **SceneLoader** — ローディング画面付き非同期シーン遷移

### マテリアルとビジュアル

```csharp
// 色付きマテリアルを作成して割り当て
run_code(@"
    var obj = GameObject.Find(""MyCube"");
    var mat = new Material(Shader.Find(""Standard""));
    mat.color = Color.red;
    obj.GetComponent<Renderer>().material = mat;
");
```

### アセット構成

プロフェッショナルなプロジェクト構成をセットアップ：

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

### デバッグ

**コンソールメッセージを読む：**

```text
get_console_logs  または  Unity_ReadConsole
→ エラーと警告を要約し、修正を提案
```

**不足しているスクリプトを見つける：**

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

## 5. ラピッドプロトタイプワークフロー

ユーザーが素早く何かを作りたい場合、以下の構造化されたワークフローに従ってください。

### 3D ボール転がしゲーム

1. シーン "GameLevel" を作成
2. 床を作成（Plane、スケール 5x5）
3. プレイヤーを作成（Sphere + Rigidbody、y=0.5）
4. BallController.cs を作成 — 力ベースの WASD 移動
5. 収集アイテムを作成（トリガーコライダー付きの小さなキューブ）
6. Collectible.cs を作成 — OnTriggerEnter → 破棄 + スコア追加
7. ScoreManager.cs シングルトンを作成
8. スコアテキスト付き UI Canvas を作成
9. スムーズ追従用の CameraFollow.cs を追加
10. ライティングとスカイボックスをセットアップ

### 2D プラットフォーマー

1. 2D シーンを作成
2. 地面スプライト / タイルマップを作成
3. プレイヤーを作成（スプライト + Rigidbody2D + BoxCollider2D）
4. PlatformController2D.cs を作成 — 移動 + ジャンプ + 地面チェック
5. さまざまな高さにプラットフォームを作成
6. CameraFollow2D.cs を追加
7. プラットフォームの下にデスゾーンを追加
8. スコア/ライフ UI を追加

### FPS プロトタイプ

1. 地形または床のあるシーンを作成
2. プレイヤーを作成（Capsule + CharacterController + 子として Camera）
3. FPSController.cs を作成 — WASD + マウスルック
4. シンプルな障害物を作成（壁、木箱）
5. 射撃メカニクスを追加（レイキャストまたはプロジェクタイル）
6. 体力を持つ敵ターゲットを追加
7. クロスヘア UI と弾薬カウンターを追加

### UI メニューシステム

1. Canvas を作成（Screen Space - Overlay）
2. タイトルテキストを作成（TextMeshPro）
3. ボタンを作成：Start、Settings、Quit
4. ボタンハンドラー用の MainMenuController.cs を作成
5. ボリュームスライダー付き設定パネルを作成
6. シーン遷移ロジックを作成

---

## 6. セットアップ後のヒント

- Unity プロジェクトのルートで `claude /init` を実行して、プロジェクトの規約を
  記述する `CLAUDE.md` を生成してください。
- Claude Code で `@` を使ってファイルを参照: `@PlayerController.cs`
- 大規模な操作では `MCP_TOOL_TIMEOUT` を増やしてください（デフォルト 12 分）。
- シーンを頻繁に保存 — `execute_menu_item("File/Save")` で実行。
- 専用の MCP ツールがない操作には、`run_code` / `ExecuteCode` を
  万能ツールとして使用してください。
