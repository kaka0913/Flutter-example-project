import 'package:flutter/material.dart';

/// BuildContext型の拡張メソッド
extension BuildContextExtension on BuildContext {
  /// MediaQueryのサイズを取得
  Size get screenSize => MediaQuery.of(this).size;

  /// 画面の幅を取得
  double get screenWidth => screenSize.width;

  /// 画面の高さを取得
  double get screenHeight => screenSize.height;

  /// 画面の向きを取得
  Orientation get orientation => MediaQuery.of(this).orientation;

  /// 横向きかチェック
  bool get isLandscape => orientation == Orientation.landscape;

  /// 縦向きかチェック
  bool get isPortrait => orientation == Orientation.portrait;

  /// テーマを取得
  ThemeData get theme => Theme.of(this);

  /// テキストテーマを取得
  TextTheme get textTheme => theme.textTheme;

  /// カラースキームを取得
  ColorScheme get colorScheme => theme.colorScheme;

  /// プライマリカラーを取得
  Color get primaryColor => colorScheme.primary;

  /// ダークモードかチェック
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// ライトモードかチェック
  bool get isLightMode => !isDarkMode;

  /// 画面の下部の安全領域を取得
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  /// 画面の上部の安全領域を取得
  double get topPadding => MediaQuery.of(this).padding.top;

  /// キーボードの高さを取得
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  /// キーボードが表示されているかチェック
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// スナックバーを表示
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  /// エラースナックバーを表示
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 成功スナックバーを表示
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// フォーカスを外す（キーボードを閉じる）
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// 画面遷移
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// 画面遷移（置き換え）
  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(this).pushReplacement<T, void>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// 戻る
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
