import 'package:json_annotation/json_annotation.dart';

part 'survey_answer_model.g.dart';

/// アンケート回答モデル（DTO）
/// 
/// ローカル保存やAPI通信で使用されるDTO。
/// json_serializableでJSON変換をサポート。
@JsonSerializable()
class SurveyAnswerModel {
  final String favoriteType;
  final String preferredSize;
  final String personality;
  final String battleStyle;

  SurveyAnswerModel({
    required this.favoriteType,
    required this.preferredSize,
    required this.personality,
    required this.battleStyle,
  });

  factory SurveyAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyAnswerModelToJson(this);
}
