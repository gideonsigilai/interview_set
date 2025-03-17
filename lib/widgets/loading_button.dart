import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? loadingColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final bool isOutlined;
  final IconData? icon;
  final TextStyle? textStyle;

  const LoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.loadingColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.elevation = 2.0,
    this.isOutlined = false,
    this.icon,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor ?? theme.colorScheme.primary,
            disabledBackgroundColor: backgroundColor?.withOpacity(0.5),
            elevation: elevation,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            side: BorderSide(color: textColor ?? theme.colorScheme.primary),
          )
        : FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primary,
            foregroundColor: textColor ?? theme.colorScheme.onPrimary,
            disabledBackgroundColor: 
                (backgroundColor ?? theme.colorScheme.primary).withOpacity(0.5),
            elevation: elevation,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          );

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined ? OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: _buildContent(theme),
      ) : FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: _buildContent(theme),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final contentColor = loadingColor ?? 
      (isOutlined ? textColor ?? theme.colorScheme.primary : theme.colorScheme.onPrimary);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(contentColor),
              ))
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: textColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: textStyle?.copyWith(color: textColor) ?? 
                    theme.textTheme.labelLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                ),
              ],
            ),
    );
  }
}