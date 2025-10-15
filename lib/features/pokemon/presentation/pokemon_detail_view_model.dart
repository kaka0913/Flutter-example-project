import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:work/features/pokemon/entities/pokemon.dart';
import 'package:work/core/di/pokemon_di.dart';

part 'pokemon_detail_view_model.g.dart';

/// ポケモン詳細の状態
class PokemonDetailState {
  final Pokemon? pokemon;
  final bool isLoading;
  final String? errorMessage;

  const PokemonDetailState({
    this.pokemon,
    this.isLoading = false,
    this.errorMessage,
  });

  PokemonDetailState copyWith({
    Pokemon? pokemon,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PokemonDetailState(
      pokemon: pokemon ?? this.pokemon,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// ポケモン詳細ViewModel
@riverpod
class PokemonDetailViewModel extends _$PokemonDetailViewModel {
  @override
  PokemonDetailState build(int pokemonId) {
    Future.microtask(() => loadPokemon(pokemonId));
    return const PokemonDetailState(isLoading: true);
  }

  /// ポケモン詳細を読み込む
  Future<void> loadPokemon(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(pokemonRepositoryProvider);
      // Repositoryから変換済みのEntityが返ってくる
      final pokemon = await repository.getPokemonDetail(id);

      state = state.copyWith(
        pokemon: pokemon,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ポケモン詳細の読み込みに失敗しました: $e',
      );
    }
  }
}

