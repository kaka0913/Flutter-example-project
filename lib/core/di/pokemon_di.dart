import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/pokemon/datasources/pokemon_api_client.dart';
import '../../features/pokemon/pokemon_repository.dart';
import '../network/dio_client.dart';

part 'pokemon_di.g.dart';

/// ========================================
/// Pokemon Feature - Dependency Injection
/// ========================================
/// 
/// 依存関係:
/// Dio → PokemonApiClient → PokemonRepository

// DataSource層
@riverpod
PokemonApiClient pokemonApiClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PokemonApiClient(dio);
}

// Repository層
@riverpod
PokemonRepository pokemonRepository(Ref ref) {
  final apiClient = ref.watch(pokemonApiClientProvider);
  return PokemonRepository(apiClient);
}
