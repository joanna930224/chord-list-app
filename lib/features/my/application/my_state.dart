import 'package:copy_with_extension/copy_with_extension.dart';

part 'my_state.g.dart';

@CopyWith()
class MyState {
  const MyState({required this.isHaptic});

  final bool isHaptic;
}
