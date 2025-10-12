import 'package:work/features/survey/data/datasources/local/survey_local_datasource.dart';
import 'package:work/features/survey/data/datasources/remote/survey_remote_datasource.dart';
import 'package:work/features/survey/data/models/survey_answer_model.dart';
import 'package:work/features/survey/domain/entities/survey_answer.dart';
import 'package:work/features/survey/domain/repositories/survey_repository.dart';

/// アンケートリポジトリの実装
/// ローカルとリモートの両方のデータソースを扱う
class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyLocalDataSource _localDataSource;
  final SurveyRemoteDataSource _remoteDataSource;

  SurveyRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

  @override
  Future<void> saveSurveyAnswer(SurveyAnswer answer) async {
    // Domain EntityをData Modelに変換
    final model = _toModel(answer);
    await _localDataSource.saveSurveyAnswer(model);
  }

  @override
  Future<SurveyAnswer?> getSavedSurveyAnswer() async {
    final model = await _localDataSource.getSavedSurveyAnswer();
    if (model == null) return null;

    // Data ModelをDomain Entityに変換
    return _toEntity(model);
  }

  @override
  Future<int> getRecommendedPokemonId(SurveyAnswer answer) async {
    // Domain EntityをData Modelに変換
    final model = _toModel(answer);

    // リモートAPIから取得
    final response = await _remoteDataSource.getRecommendation(model);

    return response.pokemonId;
  }

  /// Domain Entity → Data Model変換
  SurveyAnswerModel _toModel(SurveyAnswer entity) {
    return SurveyAnswerModel(
      favoriteType: entity.favoriteType,
      preferredSize: entity.preferredSize,
      personality: entity.personality,
      battleStyle: entity.battleStyle,
    );
  }

  /// Data Model → Domain Entity変換
  SurveyAnswer _toEntity(SurveyAnswerModel model) {
    return SurveyAnswer(
      favoriteType: model.favoriteType,
      preferredSize: model.preferredSize,
      personality: model.personality,
      battleStyle: model.battleStyle,
    );
  }
}
