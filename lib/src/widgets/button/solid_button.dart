import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_colors.dart';

class SolidButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BoxBorder? border;
  final EdgeInsets? padding;

  const SolidButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: padding??EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: border,
            color: backgroundColor ?? AppColors.primaryColor,
          ),
          child: child,
        ),
      ),
    );
  }
}
