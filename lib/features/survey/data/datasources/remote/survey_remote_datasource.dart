import 'dart:math';
import 'package:work/features/survey/data/models/recommendation_response.dart';
import 'package:work/features/survey/data/models/survey_answer_model.dart';

/// リモートデータソース（モック実装）
/// 実際のプロジェクトではRetrofitで実装
class SurveyRemoteDataSource {
  /// アンケート結果に基づいておすすめポケモンを取得（モック）
  Future<RecommendationResponse> getRecommendation(
      SurveyAnswerModel answer) async {
    // APIコールをシミュレート
    await Future.delayed(const Duration(seconds: 1));

    // アンケート結果に基づいてポケモンを選択（簡易ロジック）
    final pokemonId = _calculateRecommendedPokemon(answer);

    return RecommendationResponse(
      pokemonId: pokemonId,
      reason: _getRecommendationReason(answer),
      matchScore: 0.85 + Random().nextDouble() * 0.15,
    );
  }

  /// アンケート結果からポケモンIDを計算（モックロジック）
  int _calculateRecommendedPokemon(SurveyAnswerModel answer) {
    // タイプベースの選択
    final typeMap = {
      'fire': [4, 5, 6], // ヒトカゲ、リザード、リザードン
      'water': [7, 8, 9], // ゼニガメ、カメール、カメックス
      'grass': [1, 2, 3], // フシギダネ、フシギソウ、フシギバナ
      'electric': [25, 26], // ピカチュウ、ライチュウ
      'psychic': [63, 64, 65], // ケーシィ、ユンゲラー、フーディン
      'dragon': [147, 148, 149], // ミニリュウ、ハクリュー、カイリュー
    };

    final sizeMap = {
      'small': [25, 39, 133], // ピカチュウ、プリン、イーブイ
      'medium': [1, 4, 7], // 御三家の初期形態
      'large': [143, 131, 130], // カビゴン、ラプラス、ギャラドス
    };

    final personalityMap = {
      'friendly': [39, 35, 25], // プリン、ピッピ、ピカチュウ
      'brave': [6, 9, 149], // リザードン、カメックス、カイリュー
      'calm': [2, 3, 131], // フシギソウ、フシギバナ、ラプラス
      'energetic': [25, 78, 58], // ピカチュウ、ポニータ、ガーディ
    };

    // 優先順位: タイプ > サイズ > 性格
    List<int>? candidates = typeMap[answer.favoriteType.toLowerCase()];
    candidates ??= sizeMap[answer.preferredSize.toLowerCase()];
    candidates ??= personalityMap[answer.personality.toLowerCase()];
    candidates ??= [25]; // デフォルトはピカチュウ

    return candidates[Random().nextInt(candidates.length)];
  }

  /// おすすめ理由を生成
  String _getRecommendationReason(SurveyAnswerModel answer) {
    return 'あなたの好きな${answer.favoriteType}タイプで、'
        '${answer.preferredSize}サイズ、'
        '${answer.personality}な性格にぴったりのポケモンです！';
  }
}
