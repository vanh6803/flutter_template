import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_colors.dart';

class OutlineButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final VoidCallback onTap;
  final BoxBorder border;
  final EdgeInsets padding;

  const OutlineButton({
    super.key,
    required this.child,
    this.backgroundColor = Colors.transparent,
    required this.onTap,
    this.border = const Border.fromBorderSide(
      BorderSide(width: 1.5, color: AppColors.primaryColor),
    ),
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: border,
            color: backgroundColor,
          ),
          child: child,
        ),
      ),
    );
  }
}
