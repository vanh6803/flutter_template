import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_colors.dart';

class CircleButton extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Function() onTap;
  final EdgeInsets padding;
  final List<BoxShadow>? boxShadow;

  const CircleButton({
    super.key,
    required this.child,
    this.backgroundColor,
    required this.onTap,
    this.padding = const EdgeInsets.all(10),
    this.boxShadow,
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
            color: backgroundColor ?? AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}
