import 'package:work/features/pokemon/data/datasources/remote/pokemon_api_client.dart';
import 'package:work/features/pokemon/domain/entities/pokemon.dart';
import 'package:work/features/pokemon/domain/entities/pokemon_list_item.dart';
import 'package:work/features/pokemon/domain/repositories/pokemon_repository.dart';

/// ポケモンリポジトリ実装
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonApiClient apiClient;

  PokemonRepositoryImpl(this.apiClient);

  @override
  Future<List<PokemonListItem>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final response = await apiClient.getPokemonList(limit, offset);
    return response.results.map((model) {
      return PokemonListItem(
        name: model.name,
        url: model.url,
      );
    }).toList();
  }

  @override
  Future<Pokemon> getPokemonDetail(int id) async {
    final response = await apiClient.getPokemonDetail(id);
    
    // 画像URLを取得
    final imageUrl = response.sprites.other?.officialArtwork?.frontDefault ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    
    // タイプをリストに変換
    final types = response.types.map((typeSlot) => typeSlot.type.name).toList();
    
    // ステータスを変換
    final stats = response.stats.map((statSlot) {
      return PokemonStat(
        name: statSlot.stat.name,
        value: statSlot.baseStat,
      );
    }).toList();

    return Pokemon(
      id: response.id,
      name: response.name,
      imageUrl: imageUrl,
      types: types,
      height: response.height,
      weight: response.weight,
      stats: stats,
    );
  }
}
