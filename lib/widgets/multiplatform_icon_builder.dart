import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils.dart';
import '../widget_factory.dart';

class MultiplatformIconBuilder {

  static const String typeName = 'multiplatform.icon';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    final String? id = json['id'] as String?;
    final Map<String, dynamic> styles = json['styles'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};

    final Key? key = id != null ? Key(id) : null;

    final String? iconName = parseString(properties['icon']);
    final IconData? iconData = _parseIconData(iconName);

    if (iconData == null) {
      print("Error: No se pudo encontrar IconData para '$iconName' (id: '$id'). Usando placeholder.");
      return Icon(Icons.broken_image, key: key, size: parseDouble(styles['size']) ?? 24.0, color: Colors.red);
    }

    final double? size = parseDouble(styles['size']);
    final double? fill = parseDouble(styles['fill']); // 0.0 to 1.0
    final double? weight = parseDouble(styles['weight']); // > 0.0
    final double? grade = parseDouble(styles['grade']);
    final double? opticalSize = parseDouble(styles['opticalSize']); // > 0.0
    final Color? color = parseColor(styles['color']);
    final List<Shadow>? shadows = parseShadows(styles['shadows']);
    final TextDirection? textDirection = parseTextDirection(styles['textDirection']);
    final BlendMode? blendMode = parseBlendMode(styles['blendMode']);

    final String? semanticLabel = parseString(properties['semanticLabel']);
    final bool? applyTextScaling = parseBool(properties['applyTextScaling']);


    return Icon(
      iconData,
      key: key,
      size: size,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      color: color,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      blendMode: blendMode,
    );
  }

  static IconData? _parseIconData(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return null;
    }

    switch (iconName) {
      case 'add': return Icons.add;
      case 'add_circle': return Icons.add_circle;
      case 'add_circle_outline': return Icons.add_circle_outline;
      case 'edit': return Icons.edit;
      case 'check': return Icons.check;
      case 'check_circle': return Icons.check_circle;
      case 'check_circle_outline': return Icons.check_circle_outline;
      case 'close': return Icons.close;
      case 'cancel': return Icons.cancel;
      case 'delete': return Icons.delete;
      case 'delete_outline': return Icons.delete_outline;
      case 'search': return Icons.search;
      case 'settings': return Icons.settings;
      case 'home': return Icons.home;
      case 'menu': return Icons.menu;
      case 'star': return Icons.star;
      case 'star_border': return Icons.star_border;
      case 'favorite': return Icons.favorite;
      case 'favorite_border': return Icons.favorite_border;
      case 'info': return Icons.info;
      case 'info_outline': return Icons.info_outline;
      case 'warning': return Icons.warning;
      case 'warning_amber': return Icons.warning_amber;
      case 'error': return Icons.error;
      case 'error_outline': return Icons.error_outline;
      case 'visibility': return Icons.visibility;
      case 'visibility_off': return Icons.visibility_off;
      case 'arrow_back': return Icons.arrow_back;
      case 'arrow_forward': return Icons.arrow_forward;
      case 'arrow_upward': return Icons.arrow_upward;
      case 'arrow_downward': return Icons.arrow_downward;
      case 'more_vert': return Icons.more_vert;
      case 'more_horiz': return Icons.more_horiz;
      case 'refresh': return Icons.refresh;
      case 'person': return Icons.person;
      case 'account_circle': return Icons.account_circle;
      case 'email': return Icons.email;
      case 'phone': return Icons.phone;
      case 'place': return Icons.place;
      case 'map': return Icons.map;
      case 'list': return Icons.list;
      case 'grid_view': return Icons.grid_view;
      case 'apps': return Icons.apps;
      case 'logout': return Icons.logout;


      default:
        print("Warning: IconData para '$iconName' no mapeado en _parseIconData.");
        return Icons.broken_image;
    }
  }
}