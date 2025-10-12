import 'package:work/features/survey/domain/repositories/survey_repository.dart';

/// 保存されたアンケート結果を取得するUseCase
class GetSavedSurveyUseCase {
  final SurveyRepository _repository;

  GetSavedSurveyUseCase(this._repository);

  Future<dynamic> call() async {
    return await _repository.getSavedSurveyAnswer();
  }
}
