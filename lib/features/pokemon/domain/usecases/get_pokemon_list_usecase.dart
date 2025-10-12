import 'package:work/features/pokemon/domain/entities/pokemon_list_item.dart';
import 'package:work/features/pokemon/domain/repositories/pokemon_repository.dart';

/// ポケモン一覧取得UseCase
class GetPokemonListUseCase {
  final PokemonRepository repository;

  GetPokemonListUseCase(this.repository);

  Future<List<PokemonListItem>> call({
    required int limit,
    required int offset,
  }) async {
    return await repository.getPokemonList(
      limit: limit,
      offset: offset,
    );
  }
}
