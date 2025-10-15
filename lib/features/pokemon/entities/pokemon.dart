/// ポケモンエンティティ（ビュー用モデル）
/// 
/// APIレスポンス（PokemonDetailResponse）から変換された、
/// UIで使いやすい形式のモデル。
class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<PokemonStat> stats;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pokemon &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}

/// ポケモンのステータス
class PokemonStat {
  final String name;
  final int value;

  const PokemonStat({
    required this.name,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonStat &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}

