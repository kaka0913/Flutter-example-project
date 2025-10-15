import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:work/features/pokemon/dto/pokemon_detail_response.dart';
import 'package:work/features/pokemon/dto/pokemon_list_response.dart';

part 'pokemon_api_client.g.dart';

/// PokeAPI クライアント
@RestApi(baseUrl: 'https://pokeapi.co/api/v2/')
abstract class PokemonApiClient {
  factory PokemonApiClient(Dio dio, {String baseUrl}) = _PokemonApiClient;

  /// ポケモン一覧取得
  @GET('/pokemon')
  Future<PokemonListResponse> getPokemonList(
    @Query('limit') int limit,
    @Query('offset') int offset,
  );

  /// ポケモン詳細取得
  @GET('/pokemon/{id}')
  Future<PokemonDetailResponse> getPokemonDetail(
    @Path('id') int id,
  );
}

