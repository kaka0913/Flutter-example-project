import 'package:work/features/pokemon/domain/entities/pokemon.dart';
import 'package:work/features/pokemon/domain/repositories/pokemon_repository.dart';

/// ポケモン詳細取得UseCase
class GetPokemonDetailUseCase {
  final PokemonRepository repository;

  GetPokemonDetailUseCase(this.repository);

  Future<Pokemon> call(int id) async {
    return await repository.getPokemonDetail(id);
  }
}
