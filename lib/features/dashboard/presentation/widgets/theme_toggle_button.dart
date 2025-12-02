import 'package:flutter/cupertino.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/theme/theme_extensions.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    super.key,
    this.size = 20,
    this.color,
    this.padding = EdgeInsets.zero,
  });
  
  final double size;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, child) {
        return CupertinoButton(
          padding: padding,
          onPressed: () => ThemeManager.instance.toggleTheme(),
          child: Icon(
            ThemeManager.instance.isDarkMode 
                ? CupertinoIcons.moon_stars 
                : CupertinoIcons.sun_max_fill,
            color: context.textColor,
            size: size,
          ),
        );
      },
    );
  }
}
