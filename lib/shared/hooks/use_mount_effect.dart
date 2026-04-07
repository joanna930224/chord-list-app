import 'package:flutter_hooks/flutter_hooks.dart';

void useMountEffect(Dispose? Function() effect, [List<Object?>? keys]) {
  useEffect(effect, keys);
}
