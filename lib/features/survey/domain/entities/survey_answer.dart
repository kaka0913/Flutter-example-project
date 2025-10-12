/// アンケート回答
class SurveyAnswer {
  final String favoriteType; // 好きなタイプ
  final String preferredSize; // 好みのサイズ
  final String personality; // 性格
  final String battleStyle; // バトルスタイル

  const SurveyAnswer({
    required this.favoriteType,
    required this.preferredSize,
    required this.personality,
    required this.battleStyle,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyAnswer &&
          runtimeType == other.runtimeType &&
          favoriteType == other.favoriteType &&
          preferredSize == other.preferredSize &&
          personality == other.personality &&
          battleStyle == other.battleStyle;

  @override
  int get hashCode =>
      favoriteType.hashCode ^
      preferredSize.hashCode ^
      personality.hashCode ^
      battleStyle.hashCode;
}
