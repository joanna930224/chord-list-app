import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/haptic_provider.dart';
import 'package:chord_list_app/shared/template/c_scale_button.dart';
import 'package:flutter/cupertino.dart';

/// ListTile Factory
///
/// - CListTile.arrow(): 화살표 아이콘
/// - CListTile.switchToggle(): 스위치
/// - CListTile.custom(): 커스텀 trailing 위젯
class CListTile extends StatelessWidget {
  const CListTile({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.hapticType = HapticType.light,
  });

  /// 화살표 아이콘이 있는 ListTile 팩토리
  ///
  /// 페이지 이동이나 액션 실행에 사용
  factory CListTile.arrow({
    Key? key,
    required String title,
    required VoidCallback onTap,
    HapticType hapticType = HapticType.light,
  }) {
    return CListTile(
      key: key,
      title: title,
      trailing: Builder(
        builder: (context) => Icon(
          CupertinoIcons.chevron_right,
          size: 16,
          color: context.colorScheme.tertiary,
        ),
      ),
      onTap: onTap,
      hapticType: hapticType,
    );
  }

  /// 스위치가 있는 ListTile 팩토리
  ///
  /// 설정 토글에 사용
  factory CListTile.switchToggle({
    Key? key,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    HapticType hapticType = HapticType.selection,
  }) {
    return CListTile(
      key: key,
      title: title,
      trailing: Switch(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
      hapticType: hapticType,
    );
  }

  /// 커스텀 위젯이 있는 ListTile 팩토리
  ///
  /// 자유로운 trailing 위젯 사용
  factory CListTile.custom({
    Key? key,
    required String title,
    Widget? leading,
    required Widget trailing,
    VoidCallback? onTap,
    HapticType hapticType = HapticType.light,
  }) {
    return CListTile(
      key: key,
      title: title,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      hapticType: hapticType,
    );
  }

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final HapticType hapticType;

  @override
  Widget build(BuildContext context) {
    final listTile = Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(title),
        leading: leading,
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        horizontalTitleGap: 8,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        visualDensity: VisualDensity.compact,
      ),
    );

    if (onTap != null) {
      return CScaleButton(hapticType: hapticType, child: listTile);
    }

    return listTile;
  }
}
