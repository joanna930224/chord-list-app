import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/template/c_scale_button.dart';

class CElevatedButton extends StatelessWidget {
  const CElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.enabled = true,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.height = 56,
    this.borderRadius = 16,
  });

  final VoidCallback? onPressed;
  final String title;
  final bool enabled;
  final Color? backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onPressed != null;

    return CScaleButton(
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: height,
              child: ElevatedButton(
                onPressed: isEnabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor ?? AppColors.brandPurple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: context.colorScheme.tertiary,
                  disabledForegroundColor: context.colorScheme.onTertiary,
                  overlayColor: Color.lerp(
                    backgroundColor ?? AppColors.brandPurple,
                    Colors.black,
                    0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: Text(
                  title,
                  style: context.textTheme.semiBold16.copyWith(
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
