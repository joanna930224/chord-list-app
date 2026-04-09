import 'package:chord_list_app/shared/exports.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: const Center(
        child: Text('Library'),
      ),
    );
  }
}
