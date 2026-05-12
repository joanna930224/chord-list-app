import 'package:chord_list_app/features/library/domain/models/save_chord_action_type.dart';
import 'package:chord_list_app/features/library/presentation/widgets/chord_bottom_sheet_widget.dart';
import 'package:chord_list_app/features/library/presentation/widgets/new_box_dialog.dart';
import 'package:chord_list_app/features/library/presentation/widgets/select_box_bottom_sheet_widget.dart';
import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/template/c_bottom_sheet.dart';
import 'package:chord_list_app/shared/template/c_toast.dart';
import 'package:flutter/material.dart';

/// 운지법 카드 탭 시 보관함 저장 바텀시트를 표시하는 공통 함수.
/// LibraryScreen, ChordDetailScreen에서 동일하게 사용한다.
Future<void> showChordSaveBottomSheet(
  BuildContext context,
  Chord chord,
  ChordPosition position,
) async {
  final action = await showCBottomSheet<SaveChordActionType>(
    context: context,
    builder: (_) => ChordBottomSheetWidget(chord: chord, position: position),
  );
  if (!context.mounted) return;

  switch (action) {
    case SaveChordActionType.createNew:
      _showNewBoxDialog(context, chord, position);
    case SaveChordActionType.addToExisting:
      _showSelectBoxSheet(context, chord, position);
    case null:
      break;
  }
}

void _showSelectBoxSheet(
  BuildContext context,
  Chord chord,
  ChordPosition position,
) {
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
        if (context.mounted) _showNewBoxDialog(context, chord, position);
      },
    ),
  );
}

void _showNewBoxDialog(
  BuildContext context,
  Chord chord,
  ChordPosition position,
) {
  showDialog<void>(
    context: context,
    builder: (dialogCtx) => NewBoxDialog(
      chordPositionId: position.id,
      onSuccess: (title) {
        Navigator.pop(dialogCtx);
        if (context.mounted) CToast.show(context, '$title에 저장되었습니다.');
      },
      onError: () {
        if (context.mounted) CToast.show(context, '오류가 발생하였습니다.');
      },
    ),
  );
}
