# Flutter プロジェクトサンプルアプリ

**シンプルな Feature-First + Repository** アーキテクチャで実装された Flutter アプリケーションです。

UseCaseを省略し、ViewModelがビジネスロジックを担当する実用的でスピーディな構成です。

## 📋 実装済み機能

### 1. ポケモン図鑑 (`features/pokemon/`)

- ポケモン一覧表示（無限スクロール対応）
- ポケモン詳細表示
- PokéAPI との連携（Retrofit + Dio）
- Repository パターン（DTO → Entity 変換）
- 層構成: DataSource → Repository → ViewModel → View

### 2. アンケート機能(`features/survey/`)

- 4 ページのアンケートフロー（PageView）
- 単一 ViewModel で複数ページを管理
- ローカル保存（SharedPreferences）
- モック API（推薦ロジック）
- 複数データソースの実装例（Local + Remote）
- Entity/DTO 分離による保守性の向上

### 3. ユーザー管理（認証機能）(`shared/auth/`)

- モックユーザー（A, B, C, D）
- ユーザー切り替え機能
- 全画面で共通表示（UserSwitcher ウィジェット）
- Shared 層に配置（共有ビジネスロジック）

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

### 📖 アーキテクチャガイド（必読）

- [**シンプルな Feature-First + Repository アーキテクチャ**](./docs/シンプルなFeature-First%20+%20Repository%20アーキテクチャ.md) ⭐️
  - 全体構成図とディレクトリ構造
  - 各層の役割と責務（DataSource / DTO / Entity / Repository / Presentation）
  - DTO と Entity の使い分け
  - Repository の重要な役割（DTO → Entity 変換）
  - 依存関係の方向とデータフロー
  - Core vs Shared の使い分け
  - 命名規則まとめ
  - よくある質問（FAQ）
  - 他のプロジェクトへの応用方法

### 🛠️ 実装ガイド

- [**実装ルール・ガイドライン**](./docs/実装ルール.md)
  - ディレクトリ構成ルール
  - 層ごとの実装ルール（DataSource / DTO / Entity / Repository / Presentation）
  - 依存性注入（DI）のルール
  - 命名規則（ファイル名・クラス名）
  - コーディング規約（Import順序・コメント・コード生成）
  - 禁止事項
  - チェックリスト（新機能実装時）
  - よくある実装パターン（ページネーション・キャッシング・フォーム送信）


