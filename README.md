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

### 3. ユーザー管理（認証機能）(`shared/auth/`)

- モックユーザー（A, B, C, D）
- ユーザー切り替え機能
- 全画面で共通表示（UserSwitcher ウィジェット）
- Shared 層に配置（共有ドメインロジック）

## 🚀 実行方法

```bash
# 依存関係のインストール
fvm flutter pub get

# コード生成
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 実行
fvm flutter run -d chrome
```

## 📚 ドキュメント

### アーキテクチャ

- [アーキテクチャ詳細（Feature-First + Clean Architecture + MVVM）](./docs/Feature-First%20＋%20Clean%20Architecture%20+%20MVVM.md)
  - 全体構成図
  - 各層の役割
  - Clean Architecture との対応関係
  - Core vs Shared の使い分け
  - 依存関係の方向

### 実装ガイド

- [実装ルール・ガイドライン](./docs/実装ルール.md)
  - 層ごとの実装ルール
  - 依存性注入（DI）のルール
  - 命名規則
  - コーディング規約
  - 禁止事項とチェックリスト

### その他

- [パッケージ構成](./docs/パッケージ.md)
  - 使用パッケージの詳細
