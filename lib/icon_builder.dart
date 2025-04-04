import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget buildPlatformIcon(Map<String, dynamic> json) {
  String iconName = json['icon'] ?? '';

  IconData? getMaterialIcon(String name) {
    switch (name) {
      case 'Icons.home':
        return Icons.home;
      case 'Icons.search':
        return Icons.search;
      case 'Icons.menu':
        return Icons.menu;
      case 'Icons.settings':
        return Icons.settings;
      case 'Icons.home_filled':
        return Icons.home_filled;
      default:
        return null;
    }
  }

  IconData? getCupertinoIcon(String name) {
    switch (name) {
      case 'Icons.home':
        return CupertinoIcons.home;
      case 'Icons.home_filled':
        return CupertinoIcons.home;
      case 'Icons.search':
        return CupertinoIcons.search;
      case 'Icons.menu':
        return CupertinoIcons.app;
      case 'Icons.settings':
        return CupertinoIcons.settings;
      default:
        return null;
    }
  }

  IconData? materialIcon = getMaterialIcon(iconName);
  IconData? cupertinoIcon = getCupertinoIcon(iconName);

  // Opcionales desde el JSON
  double? size = json['size']?.toDouble();
  Color? color = json['color'] != null ? Color(int.parse(json['color'])) : null;
  String? semanticLabel = json['semanticLabel'];
  TextDirection? textDirection;
  if (json['textDirection'] == 'rtl') {
    textDirection = TextDirection.rtl;
  } else if (json['textDirection'] == 'ltr') {
    textDirection = TextDirection.ltr;
  }

  // Si no hay íconos válidos, devolvemos vacío
  if (materialIcon == null && cupertinoIcon == null) {
    return const SizedBox.shrink();
  }

  return PlatformWidget(
    material: (_, __) => Icon(
      materialIcon ?? Icons.help_outline,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    ),
    cupertino: (_, __) => Icon(
      cupertinoIcon ?? CupertinoIcons.question,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    ),
  );
}
