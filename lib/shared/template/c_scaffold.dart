import 'package:chord_list_app/shared/template/c_scale_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CScaffold extends StatelessWidget {
  const CScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.drawer,
    this.backgroundColor,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.onWillPop,
    this.resizeToAvoidBottomInset,
  });

  final Widget? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Future<bool> Function()? onWillPop;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomSheet: bottomSheet,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: AppBar(
        centerTitle: true,
        title: title,
        leading: CScaleButton(
          child:
              leading ??
              IconButton(
                icon: const Icon(CupertinoIcons.chevron_left),
                onPressed: () async {
                  if (onWillPop != null) {
                    try {
                      final shouldPop = await onWillPop!();
                      if (shouldPop && context.mounted) {
                        context.pop();
                      }
                    } catch (e) {
                      debugPrint('❌ Error in onWillPop: $e');
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  } else {
                    if (context.mounted) {
                      context.pop();
                    }
                  }
                },
              ),
        ),
        actions: actions,
      ),
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
