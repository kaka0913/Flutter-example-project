import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'survey_view_model.g.dart';

/// アンケートの状態
class SurveyState {
  final int currentPage; // 現在のページ (0-3)
  final String? favoriteType;
  final String? preferredSize;
  final String? personality;
  final String? battleStyle;
  final int? recommendedPokemonId;
  final bool isSubmitting;
  final String? errorMessage;

  const SurveyState({
    this.currentPage = 0,
    this.favoriteType,
    this.preferredSize,
    this.personality,
    this.battleStyle,
    this.recommendedPokemonId,
    this.isSubmitting = false,
    this.errorMessage,
  });

  SurveyState copyWith({
    int? currentPage,
    String? favoriteType,
    String? preferredSize,
    String? personality,
    String? battleStyle,
    int? recommendedPokemonId,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return SurveyState(
      currentPage: currentPage ?? this.currentPage,
      favoriteType: favoriteType ?? this.favoriteType,
      preferredSize: preferredSize ?? this.preferredSize,
      personality: personality ?? this.personality,
      battleStyle: battleStyle ?? this.battleStyle,
      recommendedPokemonId: recommendedPokemonId ?? this.recommendedPokemonId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// すべての回答が完了しているか
  bool get isComplete =>
      favoriteType != null &&
      preferredSize != null &&
      personality != null &&
      battleStyle != null;

  /// 現在のページの回答が完了しているか
  bool get canProceed {
    switch (currentPage) {
      case 0:
        return favoriteType != null;
      case 1:
        return preferredSize != null;
      case 2:
        return personality != null;
      case 3:
        return battleStyle != null;
      default:
        return false;
    }
  }
}

/// アンケートViewModel（4ページを1つで管理）
@riverpod
class SurveyViewModel extends _$SurveyViewModel {
  @override
  SurveyState build() {
    return const SurveyState();
  }

  /// 次のページへ
  void nextPage() {
    if (state.currentPage < 3 && state.canProceed) {
      debugPrint('Moving to page ${state.currentPage + 1}');
      state = state.copyWith(currentPage: state.currentPage + 1);
      debugPrint('Current page is now: ${state.currentPage}');
    } else {
      debugPrint('Cannot proceed: currentPage=${state.currentPage}, canProceed=${state.canProceed}');
    }
  }

  /// 前のページへ
  void previousPage() {
    if (state.currentPage > 0) {
      debugPrint('Moving back to page ${state.currentPage - 1}');
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  /// ページ1: 好きなタイプを設定
  void setFavoriteType(String type) {
    debugPrint('Setting favorite type: $type');
    state = state.copyWith(favoriteType: type, errorMessage: null);
    debugPrint('canProceed: ${state.canProceed}');
  }

  /// ページ2: 好みのサイズを設定
  void setPreferredSize(String size) {
    debugPrint('Setting preferred size: $size');
    state = state.copyWith(preferredSize: size, errorMessage: null);
  }

  /// ページ3: 性格を設定
  void setPersonality(String personality) {
    debugPrint('Setting personality: $personality');
    state = state.copyWith(personality: personality, errorMessage: null);
  }

  /// ページ4: バトルスタイルを設定
  void setBattleStyle(String style) {
    debugPrint('Setting battle style: $style');
    state = state.copyWith(battleStyle: style, errorMessage: null);
  }

  /// アンケートを送信（簡易版：即座に結果を表示）
  void submitSurvey() {
    if (!state.isComplete) {
      debugPrint('Survey is not complete');
      return;
    }

    debugPrint('Submitting survey...');

    // タイプに基づいて即座にポケモンを選択
    final typeMap = {
      'fire': 6, // リザードン
      'water': 9, // カメックス
      'grass': 3, // フシギバナ
      'electric': 25, // ピカチュウ
      'psychic': 65, // フーディン
      'dragon': 149, // カイリュー
    };

    final recommendedId = typeMap[state.favoriteType] ?? 25; // デフォルトはピカチュウ

    debugPrint('Recommended Pokemon ID: $recommendedId');

    state = state.copyWith(
      recommendedPokemonId: recommendedId,
      isSubmitting: false,
    );

    debugPrint('Survey submitted successfully');
  }

  /// アンケートをリセット
  void reset() {
    state = const SurveyState();
  }
}
