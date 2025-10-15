import 'package:json_annotation/json_annotation.dart';

part 'pokemon_list_response.g.dart';

/// ポケモンリストレスポンス
@JsonSerializable()
class PokemonListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItemModel> results;

  PokemonListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonListResponseToJson(this);
}

/// ポケモンリストアイテム
@JsonSerializable()
class PokemonListItemModel {
  final String name;
  final String url;

  PokemonListItemModel({
    required this.name,
    required this.url,
  });

  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonListItemModelToJson(this);
}
