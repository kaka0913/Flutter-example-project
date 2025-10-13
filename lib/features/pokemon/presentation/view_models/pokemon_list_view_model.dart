import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:work/features/pokemon/domain/entities/pokemon_list_item.dart';
import 'package:work/features/pokemon/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:work/core/di/pokemon_di.dart';

part 'pokemon_list_view_model.g.dart';

/// ポケモン一覧の状態
class PokemonListState {
  final List<PokemonListItem> pokemons;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const PokemonListState({
    this.pokemons = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  PokemonListState copyWith({
    List<PokemonListItem>? pokemons,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
  }) {
    return PokemonListState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// ポケモン一覧ViewModel
@riverpod
class PokemonListViewModel extends _$PokemonListViewModel {
  static const int _pageSize = 20;
  int _currentOffset = 0;

  // UseCaseをプロパティとして保持
  late final GetPokemonListUseCase _useCase;

  @override
  PokemonListState build() {
    // Providerから一度だけ取得
    _useCase = ref.watch(getPokemonListUseCaseProvider);
    Future.microtask(() => loadInitialPokemons());
    return const PokemonListState(hasMore: true);
  }

  /// 初回ロード
  Future<void> loadInitialPokemons() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _currentOffset = 0;

    try {
      final pokemons = await _useCase(
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

    state = state.copyWith(isLoadingMore: true);

    try {
      final newPokemons = await _useCase(
        limit: _pageSize,
        offset: _currentOffset,
      );

      state = state.copyWith(
        pokemons: [...state.pokemons, ...newPokemons],
        isLoadingMore: false,
        hasMore: newPokemons.length == _pageSize,
      );
      _currentOffset += _pageSize;
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'ポケモンの追加読み込みに失敗しました: $e',
      );
    }
  }

  /// リフレッシュ
  Future<void> refresh() async {
    await loadInitialPokemons();
  }
}
