import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/survey/data/datasources/local/survey_local_datasource.dart';
import '../../features/survey/data/datasources/remote/survey_remote_datasource.dart';
import '../../features/survey/data/repositories/survey_repository_impl.dart';
import '../../features/survey/domain/repositories/survey_repository.dart';
import '../../features/survey/domain/usecases/get_saved_survey_usecase.dart';
import '../../features/survey/domain/usecases/submit_survey_usecase.dart';

part 'survey_di.g.dart';

/// ========================================
/// Survey Feature - Dependency Injection
/// ========================================
/// 
/// 依存関係:
/// LocalDataSource + RemoteDataSource → SurveyRepository → UseCases

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
  return SurveyRepositoryImpl(localDataSource, remoteDataSource);
}

// UseCase層
@riverpod
SubmitSurveyUseCase submitSurveyUseCase(Ref ref) {
  final repository = ref.watch(surveyRepositoryProvider);
  return SubmitSurveyUseCase(repository);
}

@riverpod
GetSavedSurveyUseCase getSavedSurveyUseCase(Ref ref) {
  final repository = ref.watch(surveyRepositoryProvider);
  return GetSavedSurveyUseCase(repository);
}
