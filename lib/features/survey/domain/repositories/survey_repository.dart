import 'package:work/features/survey/domain/entities/survey_answer.dart';

/// アンケートリポジトリのインターフェース
abstract class SurveyRepository {
  /// アンケート結果をローカルに保存
  Future<void> saveSurveyAnswer(SurveyAnswer answer);

  /// 保存されたアンケート結果を取得
  Future<SurveyAnswer?> getSavedSurveyAnswer();

  /// おすすめのポケモンIDを取得（リモートAPI経由）
  Future<int> getRecommendedPokemonId(SurveyAnswer answer);
}
