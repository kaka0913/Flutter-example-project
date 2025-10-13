/// String型の拡張メソッド
extension StringExtension on String {
  /// 最初の文字を大文字にする
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// 各単語の最初の文字を大文字にする
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// 文字列が空または空白のみかチェック
  bool get isBlank => trim().isEmpty;

  /// 文字列が空でないかチェック
  bool get isNotBlank => !isBlank;

  /// 数字のみかチェック
  bool get isNumeric => double.tryParse(this) != null;

  /// メールアドレスの形式かチェック
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// URLの形式かチェック
  bool get isUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// 指定文字数で切り詰める（省略記号付き）
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// ポケモンIDをフォーマット（例: 1 → #001）
  String toPokemonId() {
    final id = int.tryParse(this);
    if (id == null) return this;
    return '#${id.toString().padLeft(3, '0')}';
  }
}
