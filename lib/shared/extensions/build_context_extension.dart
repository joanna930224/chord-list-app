import 'package:chord_list_app/shared/exports.dart';

extension BuildContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  double get getWidth => MediaQuery.of(this).size.width;

  double get getHeight => MediaQuery.of(this).size.height;
}
