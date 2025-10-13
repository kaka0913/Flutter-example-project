### Feature-First ＋ Clean Architecture + MVVM

機能ごとの独立性を保ち、テストしやすくメンテナンス性の高いコードベースを目指します。

---

### **全体構成図**

```
lib/
├── core/                    # 技術的インフラ（ビジネスロジックなし）
│   ├── network/             # Dioインスタンスなどのネットワーク設定
│   │   └── dio_client.dart
│   ├── router/              # go_routerの設定
│   │   └── app_router.dart
│   ├── theme/               # アプリのテーマ設定
│   └── utils/               # 汎用的な便利ツール
│
├── shared/                  # 共有ドメイン（ビジネスロジックあり）
│   └── auth/                # 認証・ユーザー管理（Clean Architecture準拠）
│       ├── domain/          # ドメイン層
│       │   ├── entities/    # User
│       │   ├── repositories/# UserRepository (interface)
│       │   └── usecases/    # GetCurrentUser, SwitchUser
│       ├── data/            # データ層
│       │   ├── datasources/ # UserLocalDataSource (モック)
│       │   └── repositories/# UserRepositoryImpl
│       └── presentation/    # プレゼンテーション層
│           ├── providers/   # Riverpodプロバイダー（DI）
│           └── widgets/     # UserSwitcher
│
├── features/                # 機能層 (Feature-First)
│   ├── pokemon/             # ポケモン図鑑機能
│   │   ├── domain/          # ドメイン層
│   │   │   ├── entities/    # Pokemon, PokemonListItem
│   │   │   ├── repositories/# RepositoryインターフェースI/F
│   │   │   └── usecases/    # GetPokemonList, GetPokemonDetail
│   │   ├── data/            # データ層
│   │   │   ├── models/      # APIレスポンスモデル (json_serializable)
│   │   │   ├── datasources/ # PokemonApiClient (Retrofit)
│   │   │   └── repositories/# Repository実装
│   │   └── presentation/    # プレゼンテーション層
│   │       ├── providers/   # Riverpodプロバイダー（DI）
│   │       ├── view_models/ # PokemonListViewModel, PokemonDetailViewModel
│   │       └── views/       # PokemonListView, PokemonDetailView
│   │
│   └── survey/              # アンケート機能
│       ├── domain/          # ドメイン層
│       │   ├── entities/    # SurveyAnswer
│       │   ├── repositories/# SurveyRepositoryインターフェース
│       │   └── usecases/    # SubmitSurveyUseCase
│       ├── data/            # データ層
│       │   ├── models/      # SurveyAnswerModel (json_serializable)
│       │   ├── datasources/ # Local (SharedPreferences) + Remote (Mock)
│       │   └── repositories/# Repository実装
│       └── presentation/    # プレゼンテーション層
│           ├── providers/   # Riverpodプロバイダー（DI）
│           ├── view_models/ # SurveyViewModel
│           └── views/       # SurveyView (4ページのPageView)
│
└── main.dart                # アプリケーションのエントリーポイント
```

---

### **各ディレクトリの役割**

#### **`features` (機能層)** 🎨

- **役割**: アプリの各機能を配置します。「オンボーディング」「動画編集」のように、ユーザーに見える機能単位でディレクトリを分割します。
- **特徴**: 各機能は原則として他の機能から独立しています。これにより、担当機能に集中でき、並行開発がしやすくなります。
- **内部構成**: `presentation`ディレクトリを持ち、UI に関連する`screens` (View) と `view_models` (ViewModel) を配置します。

#### **`domain` (ドメイン層)** 🧠

- **役割**: **「このアプリが何をするか」** というビジネスルールを定義します。ここはプロジェクトの心臓部であり、フレームワークや UI から完全に独立した純粋な Dart コードで記述します。
- **`entities`**: アプリケーションの核となるデータ構造です。（例: `User`, `VideoTemplate`）
- **`repositories`**: データがどこから来るか（API or DB）を隠蔽するためのインターフェース（設計図）を定義します。（例: `abstract class UserRepository { ... }`）
- **`usecases`**: 「オンボーディングの回答を送信する」といった、特定のビジネスフローを実現するクラスです。`ViewModel`からの指示を受け、`Repository`を介して処理を実行します。

#### **`data` (データ層)** 🔌

- **役割**: **「どうやってデータを取得・保存するか」** を具体的に実装します。`domain`層で定義された`Repository`インターフェースを実装する場所です。
- **`datasources`**: API との通信、ローカルデータベースへのアクセスなど、データの源泉となる処理を記述します。バックエンドとのやり取りはここが担当します。
- **`models`**: API のレスポンス（JSON）を Dart オブジェクトに変換するためのクラスなど、データソース固有のデータ構造を定義します。
- **`repositories`**: `domain`層の`Repository`インターフェースを実装した具象クラスを配置します。

#### **`shared` (共有ドメイン層)** ♻️

- **役割**: 複数の`feature`で共有されるビジネスロジックを配置します。Clean Architecture の 3 層構造（domain/data/presentation）を持ちます。
- **特徴**:
  - Repository/UseCase パターンを使用
  - 複数のデータソースの統合が可能
  - テスタビリティが高い
- **例**:
  - **`auth/`**: 認証・ユーザー管理
    - `domain/entities/User`: ユーザーエンティティ
    - `domain/repositories/UserRepository`: ユーザーリポジトリインターフェース
    - `domain/usecases/`: GetCurrentUser, SwitchUser など
    - `data/datasources/`: ローカル/リモートデータソース
    - `data/repositories/`: Repository 実装
    - `presentation/providers/`: Riverpod プロバイダー（DI）
    - `presentation/widgets/`: UserSwitcher（共通ウィジェット）

#### **`core` (コア層)** ⚙️

- **役割**: アプリケーション全体の技術的基盤を配置します。ビジネスロジックを持たない、横断的な技術設定を扱います。
- **特徴**:
  - ビジネスロジックなし
  - 技術的な設定・ユーティリティのみ
  - Clean Architecture の 3 層構造は不要
- **例**:
  - **`network/`**: Dio インスタンスなどのネットワーク設定
  - **`router/`**: go_router のルーティング設定
  - **`theme/`**: アプリのテーマ設定
  - **`utils/`**: ヘルパー関数、拡張メソッド
  - **`constants/`**: 定数定義

---

### **Core vs Shared の使い分け**

#### `core/` に配置すべきもの（技術的インフラ）

- ✅ ネットワーク設定（Dio）
- ✅ ルーティング設定（go_router）
- ✅ テーマ設定
- ✅ ユーティリティ関数
- ✅ 定数

**判断基準**: ビジネスロジックを持たない技術的な設定か？

#### `shared/` に配置すべきもの（共有ドメイン）

- ✅ 認証・ユーザー管理
- ✅ 決済処理
- ✅ 通知管理
- ✅ 複数 Feature で使われるビジネスロジック

**判断基準**: Repository/UseCase が必要なビジネスロジックか？

---

### **共通機能の切り出し方針**

- **複数の Feature で使われる機能** → `core/`に配置
  - 例: 認証（`core/auth/`）、ネットワーク設定、テーマ
- **Feature 固有の機能** → 各`features/`内に配置
  - 例: ポケモン図鑑の API、アンケートのロジック
- **UI の共通コンポーネント** → `core/`配下に widgets ディレクトリを作成
  - 例: UserSwitcher（複数画面で使用）

---

### **データの流れ**

**`View` → `ViewModel` → `UseCase` → `Repository(I/F)`** `...` **`Repository(Impl)` → `DataSource` → `Backend API`**
