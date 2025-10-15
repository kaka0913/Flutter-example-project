import 'package:work/features/pokemon/entities/pokemon.dart';
import 'package:work/features/pokemon/entities/pokemon_list_item.dart';
import 'package:work/features/pokemon/datasources/pokemon_api_client.dart';

/// ポケモンリポジトリ
/// 
/// データソースの抽象化とDTO→Entity変換を担当。
/// ViewModelには変換済みのEntityを返す。
class PokemonRepository {
  final PokemonApiClient apiClient;

  PokemonRepository(this.apiClient);

  /// ポケモン一覧を取得（Entityを返す）
  Future<List<PokemonListItem>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final response = await apiClient.getPokemonList(limit, offset);
    
    // DTOをEntityに変換（Repositoryの責務）
    return response.results.map((model) {
      return PokemonListItem(
        name: model.name,
        url: model.url,
      );
    }).toList();
  }

  /// ポケモン詳細を取得（Entityを返す）
  Future<Pokemon> getPokemonDetail(int id) async {
    final response = await apiClient.getPokemonDetail(id);
    
    // 複雑な変換処理もRepositoryで実施（Repositoryの責務）
    final imageUrl = response.sprites.other?.officialArtwork?.frontDefault ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    
    final types = response.types.map((typeSlot) => typeSlot.type.name).toList();
    
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

