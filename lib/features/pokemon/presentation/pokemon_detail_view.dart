import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work/features/pokemon/presentation/pokemon_detail_view_model.dart';

/// ポケモン詳細画面
class PokemonDetailView extends ConsumerWidget {
  final int pokemonId;

  const PokemonDetailView({
    super.key,
    required this.pokemonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonDetailViewModelProvider(pokemonId));

    return Scaffold(
      appBar: AppBar(
        title: state.pokemon != null
            ? Text(state.pokemon!.name.toUpperCase())
            : const Text('ポケモン詳細'),
        elevation: 2,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(pokemonDetailViewModelProvider(pokemonId).notifier)
                              .loadPokemon(pokemonId);
                        },
                        child: const Text('再試行'),
                      ),
                    ],
                  ),
                )
              : state.pokemon != null
                  ? _buildPokemonDetail(context, state.pokemon!)
                  : const SizedBox.shrink(),
    );
  }

  Widget _buildPokemonDetail(BuildContext context, pokemon) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ポケモン画像
          Container(
            height: 300,
            color: Colors.grey[100],
            child: Hero(
              tag: 'pokemon_${pokemon.id}',
              child: Image.network(
                pokemon.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 100);
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID と名前
                Row(
                  children: [
                    Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // タイプ
                const Text(
                  'タイプ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: pokemon.types.map<Widget>((type) {
                    return Chip(
                      label: Text(
                        type.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: _getTypeColor(type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // 身長・体重
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        label: '身長',
                        value: '${(pokemon.height / 10).toStringAsFixed(1)} m',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(
                        label: '体重',
                        value: '${(pokemon.weight / 10).toStringAsFixed(1)} kg',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ステータス
                const Text(
                  'ステータス',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...pokemon.stats.map<Widget>((stat) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _StatBar(
                      name: _getStatName(stat.name),
                      value: stat.value,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    final colors = {
      'normal': Colors.grey,
      'fire': Colors.orange,
      'water': Colors.blue,
      'electric': Colors.yellow[700]!,
      'grass': Colors.green,
      'ice': Colors.lightBlue,
      'fighting': Colors.red[900]!,
      'poison': Colors.purple,
      'ground': Colors.brown,
      'flying': Colors.indigo[200]!,
      'psychic': Colors.pink,
      'bug': Colors.lightGreen,
      'rock': Colors.grey[700]!,
      'ghost': Colors.deepPurple,
      'dragon': Colors.indigo,
      'dark': Colors.grey[900]!,
      'steel': Colors.blueGrey,
      'fairy': Colors.pinkAccent,
    };
    return colors[type] ?? Colors.grey;
  }

  String _getStatName(String stat) {
    final names = {
      'hp': 'HP',
      'attack': '攻撃',
      'defense': '防御',
      'special-attack': '特攻',
      'special-defense': '特防',
      'speed': '素早さ',
    };
    return names[stat] ?? stat;
  }
}

/// 情報カード
class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ステータスバー
class _StatBar extends StatelessWidget {
  final String name;
  final int value;

  const _StatBar({
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / 255).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStatColor(percentage),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatColor(double percentage) {
    if (percentage < 0.33) return Colors.red;
    if (percentage < 0.66) return Colors.orange;
    return Colors.green;
  }
}

