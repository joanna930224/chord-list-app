import 'package:flutter/material.dart';

extension PaddingExtension on Widget {
  Widget get ph16 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: this);
  Widget get ph20 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: this);
}

extension SliverExtension on Widget {
  Widget get sb => SliverToBoxAdapter(child: this);
}
