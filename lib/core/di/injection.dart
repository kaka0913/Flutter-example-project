import 'package:get_it/get_it.dart';
import 'package:work/core/network/dio_client.dart';
import 'package:work/features/pokemon/data/datasources/remote/pokemon_api_client.dart';
import 'package:work/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:work/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:work/features/pokemon/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:work/features/pokemon/domain/usecases/get_pokemon_list_usecase.dart';

final getIt = GetIt.instance;

/// 依存性注入のセットアップ
void setupDI() {
  // Core
  getIt.registerLazySingleton(() => createDio());

  // Pokemon Feature
  getIt.registerLazySingleton<PokemonApiClient>(
    () => PokemonApiClient(getIt()),
  );

  getIt.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(
    () => GetPokemonListUseCase(getIt()),
  );

  getIt.registerLazySingleton(
    () => GetPokemonDetailUseCase(getIt()),
  );
}
