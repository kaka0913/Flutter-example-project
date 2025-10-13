import 'package:flutter/material.dart';

/// アプリケーション全体で使用するカラーパレット
class AppColors {
  // プライベートコンストラクタ（インスタンス化を防ぐ）
  AppColors._();

  /// プライマリカラー（ポケモン図鑑のテーマカラー）
  static const Color primary = Color(0xFFEF5350); // ポケモンレッド

  /// セカンダリカラー
  static const Color secondary = Color(0xFF42A5F5); // ポケモンブルー

  /// アクセントカラー
  static const Color accent = Color(0xFFFFA726); // ポケモンオレンジ

  /// 背景色
  static const Color background = Color(0xFFF5F5F5);

  /// サーフェスカラー
  static const Color surface = Colors.white;

  /// エラーカラー
  static const Color error = Color(0xFFE53935);

  /// 成功カラー
  static const Color success = Color(0xFF66BB6A);

  /// 警告カラー
  static const Color warning = Color(0xFFFFA726);

  /// 情報カラー
  static const Color info = Color(0xFF42A5F5);

  /// テキストカラー
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  /// ディバイダーカラー
  static const Color divider = Color(0xFFE0E0E0);

  /// Chipの背景色
  static const Color chipBackground = Color(0xFFE3F2FD);

  /// ポケモンタイプカラー
  static const Map<String, Color> pokemonTypes = {
    'normal': Color(0xFFA8A878),
    'fire': Color(0xFFF08030),
    'water': Color(0xFF6890F0),
    'electric': Color(0xFFF8D030),
    'grass': Color(0xFF78C850),
    'ice': Color(0xFF98D8D8),
    'fighting': Color(0xFFC03028),
    'poison': Color(0xFFA040A0),
    'ground': Color(0xFFE0C068),
    'flying': Color(0xFFA890F0),
    'psychic': Color(0xFFF85888),
    'bug': Color(0xFFA8B820),
    'rock': Color(0xFFB8A038),
    'ghost': Color(0xFF705898),
    'dragon': Color(0xFF7038F8),
    'dark': Color(0xFF705848),
    'steel': Color(0xFFB8B8D0),
    'fairy': Color(0xFFEE99AC),
  };

  /// ポケモンタイプの色を取得
  static Color getPokemonTypeColor(String type) {
    return pokemonTypes[type.toLowerCase()] ?? textSecondary;
  }
}
