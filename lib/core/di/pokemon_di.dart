import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/pokemon/data/datasources/remote/pokemon_api_client.dart';
import '../../features/pokemon/data/repositories/pokemon_repository_impl.dart';
import '../../features/pokemon/domain/repositories/pokemon_repository.dart';
import '../../features/pokemon/domain/usecases/get_pokemon_detail_usecase.dart';
import '../../features/pokemon/domain/usecases/get_pokemon_list_usecase.dart';
import '../network/dio_client.dart';

part 'pokemon_di.g.dart';

/// ========================================
/// Pokemon Feature - Dependency Injection
/// ========================================
/// 
/// 依存関係:
/// Dio → PokemonApiClient → PokemonRepository → UseCases

// DataSource層
@riverpod
Dio dio(Ref ref) {
  return createDio();
}

@riverpod
PokemonApiClient pokemonApiClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PokemonApiClient(dio);
}

// Repository層
@riverpod
PokemonRepository pokemonRepository(Ref ref) {
  final apiClient = ref.watch(pokemonApiClientProvider);
  return PokemonRepositoryImpl(apiClient);
}

// UseCase層
@riverpod
GetPokemonListUseCase getPokemonListUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonListUseCase(repository);
}

@riverpod
GetPokemonDetailUseCase getPokemonDetailUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonDetailUseCase(repository);
}
