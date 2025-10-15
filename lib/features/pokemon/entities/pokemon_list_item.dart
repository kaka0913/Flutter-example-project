/// ポケモンリスト項目（ビュー用モデル）
/// 
/// 一覧表示用の軽量データ。
/// APIレスポンス（PokemonListItemModel）から変換される。
class PokemonListItem {
  final String name;
  final String url;

  const PokemonListItem({
    required this.name,
    required this.url,
  });

  /// URLからポケモンIDを抽出
  int get id {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]);
  }

  /// ポケモン画像URL
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonListItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          url == other.url;

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}

