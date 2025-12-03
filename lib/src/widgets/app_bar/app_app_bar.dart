import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String title;
  final TextStyle? titleTextStyle;
  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onLeadingTap;

  const AppAppBar({
    super.key,
    this.leading,
    required this.title,
    this.titleTextStyle,
    this.centerTitle = false,
    this.actions, this.onLeadingTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) InkWell(onTap: onLeadingTap, child: leading!),
            if (leading != null) const SizedBox(width: 12),
            Expanded(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                child: Text(
                  title,
                  style: titleTextStyle,
                  textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                ),
              ),
            ),
            if (actions != null) ...actions!,
            // if leading exists but actions do not, add empty space to balance
            if (leading != null && actions == null)
              ...[
                Opacity(opacity: 0, child: leading),
                const SizedBox(width: 12),
              ]
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
