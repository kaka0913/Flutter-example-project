import 'package:json_annotation/json_annotation.dart';

part 'recommendation_response.g.dart';

/// おすすめポケモンレスポンス（DTO）
/// 
/// リモートAPIからのレスポンスを表現するDTO。
@JsonSerializable()
class RecommendationResponse {
  final int pokemonId;
  final String reason;
  final double matchScore;

  RecommendationResponse({
    required this.pokemonId,
    required this.reason,
    required this.matchScore,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationResponseToJson(this);
}
