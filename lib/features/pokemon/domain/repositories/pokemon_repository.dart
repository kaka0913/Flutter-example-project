import 'package:work/features/pokemon/domain/entities/pokemon.dart';
import 'package:work/features/pokemon/domain/entities/pokemon_list_item.dart';

/// ポケモンリポジトリインターフェース
abstract class PokemonRepository {
  /// ポケモン一覧を取得
  Future<List<PokemonListItem>> getPokemonList({
    required int limit,
    required int offset,
  });

  /// ポケモン詳細を取得
  Future<Pokemon> getPokemonDetail(int id);
}
