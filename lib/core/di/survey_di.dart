import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/survey/data/datasources/local/survey_local_datasource.dart';
import '../../features/survey/data/datasources/remote/survey_remote_datasource.dart';
import '../../features/survey/survey_repository.dart';

part 'survey_di.g.dart';

/// ========================================
/// Survey Feature - Dependency Injection
/// ========================================
/// 
/// 依存関係:
/// LocalDataSource + RemoteDataSource → SurveyRepository

// DataSource層
@riverpod
SurveyLocalDataSource surveyLocalDataSource(Ref ref) {
  return SurveyLocalDataSource();
}

@riverpod
SurveyRemoteDataSource surveyRemoteDataSource(Ref ref) {
  return SurveyRemoteDataSource();
}

// Repository層
@riverpod
SurveyRepository surveyRepository(Ref ref) {
  final localDataSource = ref.watch(surveyLocalDataSourceProvider);
  final remoteDataSource = ref.watch(surveyRemoteDataSourceProvider);
  return SurveyRepository(localDataSource, remoteDataSource);
}
