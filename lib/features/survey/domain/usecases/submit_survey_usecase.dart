import 'package:work/features/survey/domain/entities/survey_answer.dart';
import 'package:work/features/survey/domain/repositories/survey_repository.dart';

/// アンケートを送信してポケモンをおすすめするUseCase
class SubmitSurveyUseCase {
  final SurveyRepository _repository;

  SubmitSurveyUseCase(this._repository);

  Future<int> call(SurveyAnswer answer) async {
    // 1. ローカルに保存
    await _repository.saveSurveyAnswer(answer);

    // 2. リモートAPIでおすすめポケモンを取得
    final recommendedId = await _repository.getRecommendedPokemonId(answer);

    return recommendedId;
  }
}
