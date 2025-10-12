import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work/features/survey/data/models/survey_answer_model.dart';

/// ローカルデータソース（SharedPreferences使用）
class SurveyLocalDataSource {
  static const String _surveyKey = 'saved_survey_answer';

  /// アンケート結果をローカルに保存
  Future<void> saveSurveyAnswer(SurveyAnswerModel answer) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(answer.toJson());
    await prefs.setString(_surveyKey, jsonString);
  }

  /// 保存されたアンケート結果を取得
  Future<SurveyAnswerModel?> getSavedSurveyAnswer() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_surveyKey);

    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return SurveyAnswerModel.fromJson(json);
  }

  /// 保存されたアンケート結果を削除
  Future<void> clearSurveyAnswer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_surveyKey);
  }
}
