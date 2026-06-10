import 'package:chord_list_app/features/library/domain/models/save_chord_action_type.dart';
import 'package:chord_list_app/features/library/presentation/widgets/chord_bottom_sheet_widget.dart';
import 'package:chord_list_app/features/library/presentation/widgets/new_box_dialog.dart';
import 'package:chord_list_app/features/library/presentation/widgets/select_box_bottom_sheet_widget.dart';
import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/providers/analytics_provider.dart';
import 'package:chord_list_app/shared/template/c_bottom_sheet.dart';
import 'package:chord_list_app/shared/template/c_toast.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 운지법 카드 탭 시 보관함 저장 바텀시트를 표시하는 공통 함수.
/// LibraryScreen, ChordDetailScreen에서 동일하게 사용한다.
Future<void> showChordSaveBottomSheet(
  BuildContext context,
  Chord chord,
  ChordPosition position, {
  String? analyticsSource,
}) async {
  final action = await showCBottomSheet<SaveChordActionType>(
    context: context,
    builder: (_) => ChordBottomSheetWidget(chord: chord, position: position),
  );
  if (!context.mounted) return;

  switch (action) {
    case SaveChordActionType.createNew:
      _showNewBoxDialog(context, chord, position, analyticsSource: analyticsSource);
    case SaveChordActionType.addToExisting:
      _showSelectBoxSheet(context, chord, position, analyticsSource: analyticsSource);
    case null:
      break;
  }
}

void _showSelectBoxSheet(
  BuildContext context,
  Chord chord,
  ChordPosition position, {
  String? analyticsSource,
}) {
  showCBottomSheet<void>(
    context: context,
    builder: (_) => SelectBoxBottomSheetWidget(
      chordPositionId: position.id,
      onSuccess: (title) {
        if (context.mounted) CToast.show(context, '$title에 저장되었습니다.');
      },
      onError: () {
        if (context.mounted) CToast.show(context, '오류가 발생하였습니다.');
      },
      onCreateNew: () {
        if (context.mounted) {
          _showNewBoxDialog(context, chord, position, analyticsSource: analyticsSource);
        }
      },
    ),
  );
}

void _showNewBoxDialog(
  BuildContext context,
  Chord chord,
  ChordPosition position, {
  String? analyticsSource,
}) {
  showDialog<void>(
    context: context,
    builder: (dialogCtx) => NewBoxDialog(
      chordPositionId: position.id,
      onSuccess: (title) {
        Navigator.pop(dialogCtx);
        if (context.mounted) {
          CToast.show(context, '$title에 저장되었습니다.');
          if (analyticsSource != null) {
            ProviderScope.containerOf(context)
                .read(analyticsProvider)
                .logBoxCreated(analyticsSource);
          }
        }
      },
      onError: () {
        if (context.mounted) CToast.show(context, '오류가 발생하였습니다.');
      },
    ),
  );
}
