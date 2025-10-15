import 'package:go_router/go_router.dart';
import 'package:work/features/pokemon/presentation/pokemon_detail_view.dart';
import 'package:work/features/pokemon/presentation/pokemon_list_view.dart';
import 'package:work/features/survey/presentation/survey_view.dart';

/// アプリのルーター設定
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PokemonListView(),
    ),
    GoRoute(
      path: '/pokemon/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return PokemonDetailView(pokemonId: id);
      },
    ),
    GoRoute(
      path: '/survey',
      builder: (context, state) => const SurveyView(),
    ),
  ],
);
