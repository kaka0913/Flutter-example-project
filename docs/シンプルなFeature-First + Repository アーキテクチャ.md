### シンプルな Feature-First + Repository アーキテクチャ

実用的でスピーディな開発を可能にする、シンプルで保守性の高いアーキテクチャです。
Clean Architecture から UseCase を省略し、ViewModel がビジネスロジックを担当します。

---

## **全体構成図**

```
lib/
├── core/                             # 技術的インフラ（ビジネスロジックなし）
│   ├── di/                           # 依存性注入（DI）の中央管理
│   │   ├── pokemon_di.dart           # Pokemon機能のDI
│   │   ├── survey_di.dart            # Survey機能のDI
│   │   └── auth_di.dart              # Auth機能のDI
│   ├── network/                      # Dioインスタンスなどのネットワーク設定
│   │   └── dio_client.dart
│   ├── router/                       # go_routerの設定
│   │   └── app_router.dart
│   ├── theme/                        # アプリのテーマ設定
│   │   ├── app_theme.dart            # Light/Darkテーマ定義
│   │   ├── app_colors.dart           # カラーパレット
│   │   └── app_text_styles.dart      # テキストスタイル
│   └── utils/                        # 汎用的な便利ツール
│       ├── string_extensions.dart    # String拡張メソッド
│       ├── context_extensions.dart   # BuildContext拡張メソッド
│       └── formatters.dart           # 日付・数値フォーマッター
│
├── shared/                           # 共有ドメイン（ビジネスロジックあり）
│   └── auth/                         # 認証・ユーザー管理（Repository パターン）
│       ├── datasources/              # データソース層
│       │   └── user_data_source.dart # ユーザーデータソース（local/remoteを統合）
│       ├── entities/                 # エンティティ（ビュー用モデル）
│       │   └── user_entity.dart      # Userエンティティ
│       ├── presentation/             # プレゼンテーション層
│       │   └── widgets/              # 共通ウィジェット
│       └── user_repository.dart      # ユーザーリポジトリ
│
├── features/                         # 機能層 (Feature-First)
│   ├── pokemon/                      # ポケモン図鑑機能
│   │   ├── datasources/              # データソース層
│   │   │   └── pokemon_data_source.dart # PokemonApiClient (Retrofit)
│   │   ├── dto/                      # データ転送オブジェクト（API通信用）
│   │   │   ├── pokemon_detail_dto.dart
│   │   │   └── pokemon_list_dto.dart
│   │   ├── entities/                 # エンティティ（ビュー用モデル）
│   │   │   ├── pokemon_entity.dart
│   │   │   └── pokemon_list_item_entity.dart
│   │   ├── presentation/             # プレゼンテーション層
│   │   │   ├── pokemon_list_view.dart
│   │   │   ├── pokemon_list_view_model.dart
│   │   │   ├── pokemon_detail_view.dart
│   │   │   └── pokemon_detail_view_model.dart
│   │   └── pokemon_repository.dart   # ポケモンリポジトリ
│   │
│   └── survey/                       # アンケート機能
│       ├── datasources/              # データソース層
│       │   ├── survey_local_data_source.dart  # ローカルストレージ
│       │   └── survey_remote_data_source.dart # リモートAPI
│       ├── dto/                      # データ転送オブジェクト
│       │   ├── survey_answer_dto.dart
│       │   └── recommendation_dto.dart
│       ├── entities/                 # エンティティ（ビュー用モデル）
│       │   └── survey_answer_entity.dart
│       ├── presentation/             # プレゼンテーション層
│       │   ├── survey_view.dart
│       │   └── survey_view_model.dart
│       └── survey_repository.dart    # アンケートリポジトリ
│
└── main.dart                         # アプリケーションのエントリーポイント
```

---

## **各ディレクトリの役割**

### **`features/` (機能層)** 🎨

**役割**: アプリの各機能を配置します。「ポケモン図鑑」「アンケート」のように、ユーザーに見える機能単位でディレクトリを分割します。

**特徴**:
- 各機能は原則として他の機能から独立
- 並行開発がしやすい
- 責務が明確で保守性が高い

**内部構成**:
```
features/<feature_name>/
├── datasources/              # データソース（API/DB/SharedPreferences）
├── dto/                      # データ転送オブジェクト（API通信用）
├── entities/                 # エンティティ（ビュー用モデル）
├── presentation/             # UI層（View & ViewModel）
│   ├── <feature>_view.dart
│   └── <feature>_view_model.dart
└── <feature>_repository.dart # リポジトリ（データ変換とビジネスロジックの一部）
```

---

### **`datasources/` (データソース層)** 🔌

**役割**: 外部データとのやり取りを担当します。API通信、ローカルDB、SharedPreferencesなどのデータ取得・保存処理を実装します。

**特徴**:
- **基本的にはremote/localで分けない** - 1つのデータソースファイルにまとめる
- ただし、明確に責務が分かれている場合（例: Survey機能）は分けても良い
- DTOの生成・パースを担当
- ビジネスロジックは持たない

**命名規則**:
- ファイル名: `<feature>_data_source.dart`
- クラス名: `<Feature>DataSource`

**例**:
```dart
// pokemon_data_source.dart
@RestApi(baseUrl: 'https://pokeapi.co/api/v2/')
abstract class PokemonDataSource {
  factory PokemonDataSource(Dio dio) = _PokemonDataSource;

  @GET('/pokemon')
  Future<PokemonListDto> getPokemonList(
    @Query('limit') int limit,
    @Query('offset') int offset,
  );

  @GET('/pokemon/{id}')
  Future<PokemonDetailDto> getPokemonDetail(@Path('id') int id);
}
```

---

### **`dto/` (データ転送オブジェクト)** 📦

**役割**: API通信やローカルストレージとのデータ転送に使用するオブジェクトです。JSONとDartオブジェクトの相互変換を担当します。

**特徴**:
- APIレスポンス/リクエストの構造をそのまま表現
- `json_serializable`でシリアライズ処理を自動生成
- **ビュー層には渡さない**（Repositoryで変換）
- DTOは外部データ構造の変更に対して脆弱であることを許容

**命名規則**:
- ファイル名: `<model_name>_dto.dart`
- クラス名: `<ModelName>Dto` または `<ModelName>Response` / `<ModelName>Request`

**例**:
```dart
// pokemon_detail_dto.dart
@JsonSerializable()
class PokemonDetailDto {
  final int id;
  final String name;
  final int height;
  final int weight;
  final SpritesDto sprites;
  final List<TypeSlotDto> types;
  final List<StatSlotDto> stats;

  PokemonDetailDto({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.sprites,
    required this.types,
    required this.stats,
  });

  factory PokemonDetailDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonDetailDtoToJson(this);
}
```

---

### **`entities/` (エンティティ - ビュー用モデル)** 🎭

**役割**: UIで使用するためのドメインモデルです。ビューの要件に最適化されたデータ構造を持ちます。

**特徴**:
- **ViewModelとViewが使用する**
- アプリケーション内部のビジネスルールを表現
- DTOから変換されて生成される（Repository内で変換）
- UIの要件に合わせて設計（不要な情報は含めない）
- イミュータブル（不変）であることが望ましい

**命名規則**:
- ファイル名: `<model_name>_entity.dart`
- クラス名: `<ModelName>` または `<ModelName>Entity`

**例**:
```dart
// pokemon_entity.dart
/// ポケモン詳細エンティティ（ビュー用モデル）
/// 
/// DTOから変換されて生成され、UIに最適化されたデータ構造を持つ。
class Pokemon {
  final int id;
  final String name;
  final String imageUrl;       // DTOから抽出・整形済み
  final List<String> types;    // DTOから抽出・整形済み
  final int height;
  final int weight;
  final List<PokemonStat> stats; // DTOから抽出・整形済み

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
  });
}

class PokemonStat {
  final String name;
  final int value;

  const PokemonStat({
    required this.name,
    required this.value,
  });
}
```

---

### **`<feature>_repository.dart` (リポジトリ)** 🏦

**役割**: データソースの抽象化と、**DTO→Entity変換**を担当します。ViewModelにはEntityのみを返します。

**特徴**:
- データソースの詳細を隠蔽
- **DTO→Entity変換を実施（Repository の重要な責務）**
- 複数のデータソースを統合できる（例: ローカルキャッシュ + リモートAPI）
- ビジネスロジックの一部を担当（データ整形、バリデーション、キャッシング戦略など）
- ViewModelから見たデータアクセスの窓口

**命名規則**:
- ファイル名: `<feature>_repository.dart`
- クラス名: `<Feature>Repository`

**例**:
```dart
// pokemon_repository.dart
/// ポケモンリポジトリ
///
/// データソースの抽象化とDTO→Entity変換を担当。
/// ViewModelには変換済みのEntityを返す。
class PokemonRepository {
  final PokemonDataSource dataSource;

  PokemonRepository(this.dataSource);

  /// ポケモン一覧を取得（Entityを返す）
  Future<List<PokemonListItem>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final dto = await dataSource.getPokemonList(limit, offset);

    // DTO→Entity変換（Repositoryの責務）
    return dto.results.map((item) {
      return PokemonListItem(
        name: item.name,
        url: item.url,
      );
    }).toList();
  }

  /// ポケモン詳細を取得（Entityを返す）
  Future<Pokemon> getPokemonDetail(int id) async {
    final dto = await dataSource.getPokemonDetail(id);

    // 複雑な変換処理もRepositoryで実施（Repositoryの責務）
    final imageUrl = dto.sprites.other?.officialArtwork?.frontDefault ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    final types = dto.types.map((typeSlot) => typeSlot.type.name).toList();

    final stats = dto.stats.map((statSlot) {
      return PokemonStat(
        name: statSlot.stat.name,
        value: statSlot.baseStat,
      );
    }).toList();

    return Pokemon(
      id: dto.id,
      name: dto.name,
      imageUrl: imageUrl,
      types: types,
      height: dto.height,
      weight: dto.weight,
      stats: stats,
    );
  }
}
```

---

### **`presentation/` (プレゼンテーション層)** 📱

**役割**: UIに関連するコードを配置します。View（画面）とViewModel（状態管理・ビジネスロジック）を含みます。

**特徴**:
- **View**: UIの描画のみを担当（ビジネスロジックなし）
- **ViewModel**: 状態管理とビジネスロジックを担当（UseCaseの代わり）
- ViewModelはRepositoryを介してデータを取得・更新
- Riverpodを使用した状態管理

**命名規則**:
- View: `<feature>_view.dart` / `<Feature>View`
- ViewModel: `<feature>_view_model.dart` / `<Feature>ViewModel`

**ViewModel例**:
```dart
// pokemon_list_view_model.dart
@riverpod
class PokemonListViewModel extends _$PokemonListViewModel {
  static const int _pageSize = 20;
  int _currentOffset = 0;

  @override
  PokemonListState build() {
    Future.microtask(() => loadInitialPokemons());
    return const PokemonListState(hasMore: true);
  }

  /// 初回ロード
  Future<void> loadInitialPokemons() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _currentOffset = 0;

    try {
      final repository = ref.read(pokemonRepositoryProvider);
      
      // Repositoryから変換済みのEntityが返ってくる
      final pokemons = await repository.getPokemonList(
        limit: _pageSize,
        offset: _currentOffset,
      );

      state = state.copyWith(
        pokemons: pokemons,
        isLoading: false,
        hasMore: pokemons.length == _pageSize,
      );
      _currentOffset += _pageSize;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ポケモンの読み込みに失敗しました: $e',
      );
    }
  }

  /// 追加読み込み
  Future<void> loadMorePokemons() async {
    if (state.isLoadingMore || !state.hasMore) return;
    // ...
  }
}
```

---

## **`shared/` vs `core/` の使い分け**

### **`core/` に配置すべきもの（技術的インフラ）** ⚙️

**判断基準**: ビジネスロジックを持たない技術的な設定か？

- ✅ 依存性注入（DI）の設定
- ✅ ネットワーク設定（Dio）
- ✅ ルーティング設定（go_router）
- ✅ テーマ設定
- ✅ ユーティリティ関数
- ✅ 定数

**特徴**:
- ビジネスロジックなし
- 技術的な設定・ユーティリティのみ
- Repository/Entity を持たない

---

### **`shared/` に配置すべきもの（共有ドメイン）** ♻️

**判断基準**: Repository/Entity が必要なビジネスロジックか？

- ✅ 認証・ユーザー管理
- ✅ 決済処理
- ✅ 通知管理
- ✅ 複数 Feature で使われるビジネスロジック

**特徴**:
- Repository パターンを使用
- 複数のデータソースの統合が可能
- テスタビリティが高い
- UI コンポーネントも含む（例: `shared/auth/presentation/widgets/`）

---

## **依存関係の方向**

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                    │
│  ┌────────────┐              ┌──────────────┐          │
│  │    View    │─────────────▶│  ViewModel   │          │
│  └────────────┘              └──────────────┘          │
└─────────────────────────────────────│────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────┐
│                    Repository Layer                     │
│              ┌───────────────────────────┐              │
│              │   <Feature>Repository     │              │
│              │                           │              │
│              │  • DTO → Entity変換       │              │
│              │  • データ整形              │              │
│              │  • キャッシング戦略        │              │
│              └───────────────────────────┘              │
└─────────────────────────────────────│────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────┐
│                   DataSource Layer                      │
│              ┌───────────────────────────┐              │
│              │   <Feature>DataSource     │              │
│              │                           │              │
│              │  • API通信                │              │
│              │  • ローカルDB             │              │
│              │  • DTO生成・パース        │              │
│              └───────────────────────────┘              │
└─────────────────────────────────────────────────────────┘

                         DTO ◀─────▶ DataSource
                       Entity ◀─────▶ Repository ◀─────▶ ViewModel ◀─────▶ View
```

**重要な原則**:
- **View → ViewModel**: ViewはViewModelを通じてのみデータにアクセス
- **ViewModel → Repository**: ViewModelはRepositoryを通じてのみデータを取得
- **Repository → DataSource**: Repositoryはデータソースの詳細を隠蔽
- **DTOはRepository内のみ**: ViewModelやViewにはEntityのみを公開
- **依存関係は内側に向かう**: Presentation → Repository → DataSource

---

## **命名規則まとめ**

### **ファイル名**

| 種類 | 命名規則 | 例 |
|------|---------|-----|
| DataSource | `<feature>_data_source.dart` | `pokemon_data_source.dart` |
| DTO | `<model_name>_dto.dart` | `pokemon_detail_dto.dart` |
| Entity | `<model_name>_entity.dart` | `pokemon_entity.dart` |
| Repository | `<feature>_repository.dart` | `pokemon_repository.dart` |
| View | `<feature>_view.dart` | `pokemon_list_view.dart` |
| ViewModel | `<feature>_view_model.dart` | `pokemon_list_view_model.dart` |

### **クラス名**

| 種類 | 命名規則 | 例 |
|------|---------|-----|
| DataSource | `<Feature>DataSource` | `PokemonDataSource` |
| DTO | `<ModelName>Dto` | `PokemonDetailDto` |
| Entity | `<ModelName>` | `Pokemon`, `PokemonListItem` |
| Repository | `<Feature>Repository` | `PokemonRepository` |
| View | `<Feature>View` | `PokemonListView` |
| ViewModel | `<Feature>ViewModel` | `PokemonListViewModel` |

---

## **責務の明確化**

### **各層の責務マトリックス**

| 責務 | DataSource | Repository | ViewModel | View |
|------|-----------|-----------|-----------|------|
| API通信 | ✅ | ❌ | ❌ | ❌ |
| DTO生成・パース | ✅ | ❌ | ❌ | ❌ |
| DTO→Entity変換 | ❌ | ✅ | ❌ | ❌ |
| データ整形 | ❌ | ✅ | ❌ | ❌ |
| ビジネスロジック | ❌ | △ | ✅ | ❌ |
| 状態管理 | ❌ | ❌ | ✅ | ❌ |
| UI描画 | ❌ | ❌ | ❌ | ✅ |

△: 一部担当（データ整形、バリデーション、キャッシング戦略など）

---

## **よくある質問**

### **Q1: UseCaseがないとViewModelが肥大化しませんか？**

**A**: 以下の戦略で対処します:
- **Repository に責務を移譲**: データ整形やバリデーションはRepositoryで実施
- **複数の小さなViewModel**: 機能を細分化して複数のViewModelに分割
- **ユーティリティクラス**: 共通ロジックはutilsに抽出
- **肥大化したらUseCaseを追加**: 必要に応じてUseCaseパターンに移行可能

### **Q2: DTOとEntityの両方を作るのは冗長では？**

**A**: 分離することで以下のメリットがあります:
- **API変更の影響を局所化**: DTOのみ修正、Entityは不変
- **UIに最適化**: Entityは不要な情報を削ぎ落とせる
- **テスタビリティ向上**: Entity単体でテスト可能
- **保守性向上**: 責務が明確で変更しやすい

小規模なプロジェクトではDTOをそのまま使うことも可能ですが、中規模以上では分離を推奨します。

### **Q3: remote/localでDataSourceを分けないのはなぜ？**

**A**: 
- **シンプルさ優先**: 小規模プロジェクトでは過度な分割は不要
- **責務が明確な場合は分けてもOK**: Survey機能のように明確に分かれている場合は分割可能
- **柔軟に判断**: プロジェクトの規模や要件に応じて決定

### **Q4: いつClean Architecture（UseCase あり）に移行すべき？**

**A**: 以下の兆候が見られたら検討:
- ViewModelが500行を超えてきた
- 複数のViewModelで同じロジックを重複実装している
- ビジネスルールのテストが困難になってきた
- チーム規模が大きくなり、責務の明確化が必要

---

## **まとめ**

このアーキテクチャは以下の特徴を持ちます:

### **メリット** ✅
- **シンプル**: UseCaseがないため学習コストが低い
- **スピーディ**: 少ないボイラープレートで素早く実装
- **保守性**: 責務が明確で変更しやすい
- **テスタビリティ**: Repository・ViewModel単体でテスト可能
- **スケーラブル**: 必要に応じてUseCaseを追加可能

### **推奨プロジェクト規模** 📏
- 小〜中規模のアプリ（画面数: 〜50画面程度）
- スタートアップやMVP開発
- 素早いプロトタイピングが必要なプロジェクト

### **次のステップ** 🚀
プロジェクトが成長し、以下の課題が顕在化したら、Clean Architecture（UseCase あり）への移行を検討してください:
- ViewModelの肥大化
- ビジネスロジックの重複
- テストの複雑化
- チーム規模の拡大

---

**Happy Coding!** 🎉

