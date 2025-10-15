import 'package:json_annotation/json_annotation.dart';

part 'pokemon_detail_response.g.dart';

/// ポケモン詳細レスポンス
@JsonSerializable()
class PokemonDetailResponse {
  final int id;
  final String name;
  final int height;
  final int weight;
  final PokemonSprites sprites;
  final List<PokemonTypeSlot> types;
  final List<PokemonStatSlot> stats;

  PokemonDetailResponse({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.sprites,
    required this.types,
    required this.stats,
  });

  factory PokemonDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonDetailResponseToJson(this);
}

/// ポケモンスプライト
@JsonSerializable()
class PokemonSprites {
  final PokemonOtherSprites? other;

  PokemonSprites({this.other});

  factory PokemonSprites.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpritesFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonSpritesToJson(this);
}

/// ポケモンその他スプライト
@JsonSerializable()
class PokemonOtherSprites {
  @JsonKey(name: 'official-artwork')
  final PokemonOfficialArtwork? officialArtwork;

  PokemonOtherSprites({this.officialArtwork});

  factory PokemonOtherSprites.fromJson(Map<String, dynamic> json) =>
      _$PokemonOtherSpritesFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonOtherSpritesToJson(this);
}

/// ポケモン公式アートワーク
@JsonSerializable()
class PokemonOfficialArtwork {
  @JsonKey(name: 'front_default')
  final String? frontDefault;

  PokemonOfficialArtwork({this.frontDefault});

  factory PokemonOfficialArtwork.fromJson(Map<String, dynamic> json) =>
      _$PokemonOfficialArtworkFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonOfficialArtworkToJson(this);
}

/// ポケモンタイプスロット
@JsonSerializable()
class PokemonTypeSlot {
  final int slot;
  final PokemonType type;

  PokemonTypeSlot({
    required this.slot,
    required this.type,
  });

  factory PokemonTypeSlot.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeSlotToJson(this);
}

/// ポケモンタイプ
@JsonSerializable()
class PokemonType {
  final String name;
  final String url;

  PokemonType({
    required this.name,
    required this.url,
  });

  factory PokemonType.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeToJson(this);
}

/// ポケモンステータススロット
@JsonSerializable()
class PokemonStatSlot {
  @JsonKey(name: 'base_stat')
  final int baseStat;
  final int effort;
  final PokemonStatInfo stat;

  PokemonStatSlot({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory PokemonStatSlot.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatSlotFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonStatSlotToJson(this);
}

/// ポケモンステータス情報
@JsonSerializable()
class PokemonStatInfo {
  final String name;
  final String url;

  PokemonStatInfo({
    required this.name,
    required this.url,
  });

  factory PokemonStatInfo.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonStatInfoToJson(this);
}
