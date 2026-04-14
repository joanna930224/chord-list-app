import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_scaffold.dart';

class BoxDetailScreen extends StatelessWidget {
  static String get routeName => '5f521d4b-5fa2-480d-8d43-d1726b013ba3';

  const BoxDetailScreen({super.key, required this.boxId});

  final int boxId;

  @override
  Widget build(BuildContext context) {
    return CScaffold(body: const SizedBox.shrink());
  }
}
