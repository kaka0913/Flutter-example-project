import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work/shared/auth/presentation/widgets/user_switcher.dart';
import 'package:work/features/survey/presentation/survey_view_model.dart';

/// アンケート画面
class SurveyView extends HookConsumerWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(surveyViewModelProvider.notifier);
    final state = ref.watch(surveyViewModelProvider);
    
    // PageControllerを作成
    final pageController = usePageController(initialPage: 0);

    // 状態のcurrentPageが変化したらPageViewを更新
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
      return null;
    }, [state.currentPage]);

    // おすすめポケモンが決定したらダイアログを表示
    useEffect(() {
      if (state.recommendedPokemonId != null) {
        Future.microtask(() {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('診断結果'),
                content: Text('あなたにおすすめのポケモンはID: ${state.recommendedPokemonId}です！'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      viewModel.reset();
                    },
                    child: const Text('もう一度'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/pokemon/${state.recommendedPokemonId}');
                      viewModel.reset();
                    },
                    child: const Text('詳細を見る'),
                  ),
                ],
              ),
            );
          }
        });
      }
      return null;
    }, [state.recommendedPokemonId]);

    return Scaffold(
      appBar: AppBar(
        title: Text('ポケモン診断 (${state.currentPage + 1}/4)'),
        actions: [
          const UserSwitcher(),
          if (state.currentPage > 0)
            TextButton.icon(
              onPressed: viewModel.reset,
              icon: const Icon(Icons.refresh),
              label: const Text('最初から'),
            ),
        ],
      ),
      body: Column(
        children: [
          // プログレスインジケーター
          LinearProgressIndicator(
            value: (state.currentPage + 1) / 4,
            backgroundColor: Colors.grey[300],
          ),
          
          // デバッグ情報（開発用）
          if (kDebugMode)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.yellow[100],
              child: Text(
                'Page: ${state.currentPage} | Type: ${state.favoriteType} | '
                'Size: ${state.preferredSize} | Personality: ${state.personality} | '
                'Battle: ${state.battleStyle} | Can Proceed: ${state.canProceed}',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Page1FavoriteType(viewModel: viewModel, state: state),
                _Page2PreferredSize(viewModel: viewModel, state: state),
                _Page3Personality(viewModel: viewModel, state: state),
                _Page4BattleStyle(viewModel: viewModel, state: state),
              ],
            ),
          ),

          // ナビゲーションボタン
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (state.currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: viewModel.previousPage,
                      child: const Text('戻る'),
                    ),
                  ),
                if (state.currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  child: state.currentPage < 3
                      ? ElevatedButton(
                          onPressed: state.canProceed ? viewModel.nextPage : null,
                          child: const Text('次へ'),
                        )
                      : ElevatedButton(
                          onPressed: state.canProceed
                              ? viewModel.submitSurvey
                              : null,
                          child: const Text('診断する'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ページ1: 好きなタイプ
class _Page1FavoriteType extends StatelessWidget {
  final SurveyViewModel viewModel;
  final SurveyState state;

  const _Page1FavoriteType({
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final types = ['fire', 'water', 'grass', 'electric', 'psychic', 'dragon'];

    return _QuestionPage(
      question: '好きなポケモンのタイプは？',
      options: types,
      selectedValue: state.favoriteType,
      onSelect: viewModel.setFavoriteType,
    );
  }
}

/// ページ2: 好みのサイズ
class _Page2PreferredSize extends StatelessWidget {
  final SurveyViewModel viewModel;
  final SurveyState state;

  const _Page2PreferredSize({
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = ['small', 'medium', 'large'];

    return _QuestionPage(
      question: '好みのポケモンのサイズは？',
      options: sizes,
      selectedValue: state.preferredSize,
      onSelect: viewModel.setPreferredSize,
    );
  }
}

/// ページ3: 性格
class _Page3Personality extends StatelessWidget {
  final SurveyViewModel viewModel;
  final SurveyState state;

  const _Page3Personality({
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final personalities = ['friendly', 'brave', 'calm', 'energetic'];

    return _QuestionPage(
      question: 'どんな性格のポケモンが好き？',
      options: personalities,
      selectedValue: state.personality,
      onSelect: viewModel.setPersonality,
    );
  }
}

/// ページ4: バトルスタイル
class _Page4BattleStyle extends StatelessWidget {
  final SurveyViewModel viewModel;
  final SurveyState state;

  const _Page4BattleStyle({
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final styles = ['攻撃的', '防御的', 'バランス型', 'サポート型'];

    return _QuestionPage(
      question: '好きなバトルスタイルは？',
      options: styles,
      selectedValue: state.battleStyle,
      onSelect: viewModel.setBattleStyle,
    );
  }
}

/// 質問ページの共通レイアウト
class _QuestionPage extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? selectedValue;
  final void Function(String) onSelect;

  const _QuestionPage({
    required this.question,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ...options.map((option) {
            final isSelected = selectedValue == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onSelect(option),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
