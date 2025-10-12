import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:work/core/network/dio_client.dart';
import 'package:work/features/pokemon/data/datasources/remote/pokemon_api_client.dart';
import 'package:work/features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:work/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:work/features/pokemon/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:work/features/pokemon/domain/usecases/get_pokemon_list_usecase.dart';

part 'pokemon_providers.g.dart';

/// Dioインスタンスを提供
@riverpod
Dio dio(Ref ref) {
  return createDio();
}

/// PokemonApiClientを提供
@riverpod
PokemonApiClient pokemonApiClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PokemonApiClient(dio);
}

/// PokemonRepositoryを提供
@riverpod
PokemonRepository pokemonRepository(Ref ref) {
  final apiClient = ref.watch(pokemonApiClientProvider);
  return PokemonRepositoryImpl(apiClient);
}

/// GetPokemonListUseCaseを提供
@riverpod
GetPokemonListUseCase getPokemonListUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonListUseCase(repository);
}

/// GetPokemonDetailUseCaseを提供
@riverpod
GetPokemonDetailUseCase getPokemonDetailUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonDetailUseCase(repository);
}
