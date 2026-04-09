import 'package:chord_list_app/core/app.dart';
import 'package:chord_list_app/core/initialization.dart';
import 'package:chord_list_app/shared/exports.dart';

void main() async {
  final container = await initialization();
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
