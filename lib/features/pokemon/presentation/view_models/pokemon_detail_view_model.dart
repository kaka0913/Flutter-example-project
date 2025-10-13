import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:work/features/pokemon/domain/entities/pokemon.dart';
import 'package:work/features/pokemon/domain/usecases/get_pokemon_detail_usecase.dart';
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
  // UseCaseをプロパティとして保持
  late final GetPokemonDetailUseCase _useCase;

  @override
  PokemonDetailState build(int pokemonId) {
    // Providerから一度だけ取得
    _useCase = ref.watch(getPokemonDetailUseCaseProvider);
    Future.microtask(() => loadPokemon(pokemonId));
    return const PokemonDetailState(isLoading: true);
  }

  /// ポケモン詳細を読み込む
  Future<void> loadPokemon(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final pokemon = await _useCase(id);

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
