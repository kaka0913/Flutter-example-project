import 'package:work/features/survey/dto/survey_answer_model.dart';
import 'package:work/features/survey/entities/survey_answer.dart';
import 'package:work/features/survey/data/datasources/local/survey_local_datasource.dart';
import 'package:work/features/survey/data/datasources/remote/survey_remote_datasource.dart';

/// アンケートリポジトリ
/// 
/// データソースの抽象化とDTO→Entity変換を担当。
/// ViewModelには変換済みのEntityを返す。
class SurveyRepository {
  final SurveyLocalDataSource _localDataSource;
  final SurveyRemoteDataSource _remoteDataSource;

  SurveyRepository(
    this._localDataSource,
    this._remoteDataSource,
  );

  /// アンケート結果をローカルに保存（Entityを受け取る）
  Future<void> saveSurveyAnswer(SurveyAnswer answer) async {
    // EntityをDTOに変換してから保存
    final model = SurveyAnswerModel(
      favoriteType: answer.favoriteType,
      preferredSize: answer.preferredSize,
      personality: answer.personality,
      battleStyle: answer.battleStyle,
    );
    await _localDataSource.saveSurveyAnswer(model);
  }

  /// 保存されたアンケート結果を取得（Entityを返す）
  Future<SurveyAnswer?> getSavedSurveyAnswer() async {
    final model = await _localDataSource.getSavedSurveyAnswer();
    if (model == null) return null;
    
    // DTOをEntityに変換
    return SurveyAnswer(
      favoriteType: model.favoriteType,
      preferredSize: model.preferredSize,
      personality: model.personality,
      battleStyle: model.battleStyle,
    );
  }

  /// おすすめのポケモンIDを取得（Entityを受け取り、結果を返す）
  Future<int> getRecommendedPokemonId(SurveyAnswer answer) async {
    // EntityをDTOに変換
    final model = SurveyAnswerModel(
      favoriteType: answer.favoriteType,
      preferredSize: answer.preferredSize,
      personality: answer.personality,
      battleStyle: answer.battleStyle,
    );
    
    final response = await _remoteDataSource.getRecommendation(model);
    return response.pokemonId;
  }
}

