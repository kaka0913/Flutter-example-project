# ポケモン図鑑アプリ

Feature-First + Clean Architecture + MVVM パターンで実装された Flutter アプリケーションです。

## 📋 実装済み機能

### 1. ポケモン図鑑 (`features/pokemon/`)

- ポケモン一覧表示（無限スクロール対応）
- ポケモン詳細表示
- PokéAPI との連携（Retrofit + Dio）
- Clean Architecture（Domain / Data / Presentation 層分離）

### 2. ポケモン診断（アンケート機能）(`features/survey/`)

- 4 ページのアンケートフロー（PageView）
- 単一 ViewModel で複数ページを管理
- ローカル保存（SharedPreferences）
- モック API（推薦ロジック）
- 複数データソースの実装例（Local + Remote）

### 3. ユーザー管理（認証機能）(`core/auth/`)

- モックユーザー（A, B, C, D）
- ユーザー切り替え機能
- 全画面で共通表示（UserSwitcher ウィジェット）
- Core 層に配置（横断的関心事）

## 🏗 アーキテクチャ

### Feature-First

各機能を独立したディレクトリで管理：

- `features/pokemon/` - ポケモン図鑑機能
- `features/survey/` - アンケート機能

### Clean Architecture (3 層構造)

各 Feature 内で以下の層に分離：

1. **Domain 層** (`domain/`)

   - `entities/` - ビジネスロジックの中核データ
   - `repositories/` - データアクセスのインターフェース
   - `usecases/` - ビジネスユースケース

2. **Data 層** (`data/`)

   - `models/` - API レスポンス用モデル（json_serializable）
   - `datasources/` - API/ローカルストレージとの通信
   - `repositories/` - Repository の実装

3. **Presentation 層** (`presentation/`)
   - `view_models/` - UI ロジック（Riverpod Notifier）
   - `views/` - UI 画面
   - `providers/` - 依存性注入

### Core 層 (`core/`)

複数機能で共有される横断的関心事：

- `auth/` - ユーザー認証・管理
- `network/` - Dio クライアント設定
- `router/` - go_router ルーティング設定

## 🛠 技術スタック

### 状態管理・DI

- **Riverpod 3.0.3** - 状態管理と DI
- **flutter_hooks** - UI ロジックの簡素化

### ネットワーク

- **dio 5.9.0** + **retrofit 4.7.3** - HTTP クライアント
- **json_serializable 6.11.1** - JSON シリアライゼーション

### その他

- **go_router 16.2.4** - ナビゲーション
- **shared_preferences 2.5.3** - ローカルストレージ

## 🚀 実行方法

```bash
# 依存関係のインストール
fvm flutter pub get

# コード生成
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 実行
fvm flutter run -d chrome  # または -d macos
```

## 📚 ドキュメント

- [アーキテクチャ詳細](./docs/Feature-First%20＋%20Clean%20Architecture%20+%20MVVM.md)
- [パッケージ構成](./docs/パッケージ.md)
