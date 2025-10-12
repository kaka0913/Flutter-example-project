import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:work/features/survey/data/datasources/local/survey_local_datasource.dart';
import 'package:work/features/survey/data/datasources/remote/survey_remote_datasource.dart';
import 'package:work/features/survey/data/repositories/survey_repository_impl.dart';
import 'package:work/features/survey/domain/repositories/survey_repository.dart';
import 'package:work/features/survey/domain/usecases/get_saved_survey_usecase.dart';
import 'package:work/features/survey/domain/usecases/submit_survey_usecase.dart';

part 'survey_providers.g.dart';

/// ローカルデータソースを提供
@riverpod
SurveyLocalDataSource surveyLocalDataSource(Ref ref) {
  return SurveyLocalDataSource();
}

/// リモートデータソースを提供
@riverpod
SurveyRemoteDataSource surveyRemoteDataSource(Ref ref) {
  return SurveyRemoteDataSource();
}

/// SurveyRepositoryを提供
@riverpod
SurveyRepository surveyRepository(Ref ref) {
  final localDataSource = ref.watch(surveyLocalDataSourceProvider);
  final remoteDataSource = ref.watch(surveyRemoteDataSourceProvider);
  return SurveyRepositoryImpl(localDataSource, remoteDataSource);
}

/// SubmitSurveyUseCaseを提供
@riverpod
SubmitSurveyUseCase submitSurveyUseCase(Ref ref) {
  final repository = ref.watch(surveyRepositoryProvider);
  return SubmitSurveyUseCase(repository);
}

/// GetSavedSurveyUseCaseを提供
@riverpod
GetSavedSurveyUseCase getSavedSurveyUseCase(Ref ref) {
  final repository = ref.watch(surveyRepositoryProvider);
  return GetSavedSurveyUseCase(repository);
}
