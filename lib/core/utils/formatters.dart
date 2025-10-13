import 'package:intl/intl.dart';

/// 日付フォーマットのヘルパークラス
class DateFormatter {
  // プライベートコンストラクタ
  DateFormatter._();

  /// 日付を「yyyy/MM/dd」形式でフォーマット
  static String toYYYYMMDD(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  /// 日付を「yyyy年MM月dd日」形式でフォーマット
  static String toJapaneseDate(DateTime date) {
    return DateFormat('yyyy年MM月dd日').format(date);
  }

  /// 日付を「MM/dd HH:mm」形式でフォーマット
  static String toMMDDHHmm(DateTime date) {
    return DateFormat('MM/dd HH:mm').format(date);
  }

  /// 日付を「HH:mm」形式でフォーマット
  static String toHHmm(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// 相対時間を取得（例: 「3分前」「2時間前」）
  static String toRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'たった今';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks週間前';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$monthsヶ月前';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years年前';
    }
  }

  /// 今日かどうか判定
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// 昨日かどうか判定
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}

/// 数値フォーマットのヘルパークラス
class NumberFormatter {
  // プライベートコンストラクタ
  NumberFormatter._();

  /// 数値をカンマ区切りでフォーマット（例: 1234567 → 1,234,567）
  static String toCommaSeparated(int number) {
    return NumberFormat('#,###').format(number);
  }

  /// 数値をK/M単位でフォーマット（例: 1500 → 1.5K）
  static String toCompact(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      final k = number / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    } else {
      final m = number / 1000000;
      return '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)}M';
    }
  }

  /// パーセンテージでフォーマット（例: 0.75 → 75%）
  static String toPercentage(double value, {int fractionDigits = 0}) {
    return '${(value * 100).toStringAsFixed(fractionDigits)}%';
  }

  /// 小数点以下を指定桁数でフォーマット
  static String toFixed(double value, int fractionDigits) {
    return value.toStringAsFixed(fractionDigits);
  }
}

/// ポケモン関連のヘルパークラス
class PokemonFormatter {
  // プライベートコンストラクタ
  PokemonFormatter._();

  /// ポケモンIDをフォーマット（例: 1 → #001）
  static String formatId(int id) {
    return '#${id.toString().padLeft(3, '0')}';
  }

  /// 身長をメートル単位でフォーマット（例: 7 → 0.7m）
  static String formatHeight(int decimeters) {
    final meters = decimeters / 10;
    return '${meters.toStringAsFixed(1)}m';
  }

  /// 体重をキログラム単位でフォーマット（例: 69 → 6.9kg）
  static String formatWeight(int hectograms) {
    final kilograms = hectograms / 10;
    return '${kilograms.toStringAsFixed(1)}kg';
  }

  /// タイプ名を日本語に変換
  static String translateType(String type) {
    const typeTranslations = {
      'normal': 'ノーマル',
      'fire': 'ほのお',
      'water': 'みず',
      'electric': 'でんき',
      'grass': 'くさ',
      'ice': 'こおり',
      'fighting': 'かくとう',
      'poison': 'どく',
      'ground': 'じめん',
      'flying': 'ひこう',
      'psychic': 'エスパー',
      'bug': 'むし',
      'rock': 'いわ',
      'ghost': 'ゴースト',
      'dragon': 'ドラゴン',
      'dark': 'あく',
      'steel': 'はがね',
      'fairy': 'フェアリー',
    };
    return typeTranslations[type.toLowerCase()] ?? type;
  }

  /// ステータス名を日本語に変換
  static String translateStat(String stat) {
    const statTranslations = {
      'hp': 'HP',
      'attack': '攻撃',
      'defense': '防御',
      'special-attack': '特攻',
      'special-defense': '特防',
      'speed': '素早さ',
    };
    return statTranslations[stat.toLowerCase()] ?? stat;
  }
}
