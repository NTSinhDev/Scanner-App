import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUIOverlayWidget extends StatelessWidget {
  final Widget child;
  final bool? isLight;
  final Color? statusBarColor;
  final Brightness? statusBarIconBrightness;
  final Color? systemNavigationBarColor;
  const SystemUIOverlayWidget({
    super.key,
    required this.child,
    this.isLight,
    this.statusBarColor,
    this.statusBarIconBrightness,
    this.systemNavigationBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUi ??
          SystemUiOverlayStyle(
            statusBarColor: statusBarColor,
            statusBarIconBrightness: statusBarIconBrightness,
            systemNavigationBarColor: systemNavigationBarColor,
          ),
      child: child,
    );
  }

  SystemUiOverlayStyle? get systemUi {
    if (isLight == null) return null;
    if (isLight!) {
      return _Theme.systemLight;
    }
    return _Theme.systemDark;
  }
}

class _Theme {
  static SystemUiOverlayStyle get systemLight => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor:  Colors.transparent,
      );
  static SystemUiOverlayStyle get systemDark => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      );
}
