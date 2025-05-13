import 'package:flutter/material.dart';

import 'package:frontend/widgets/utils.dart';

import '../../widget_factory.dart';

class MaterialCardBuilder {
  static const String typeName = 'material.card';

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
    final List<dynamic> childrenJson = json['children'] as List<dynamic>? ?? [];

    final Key? key = id != null ? Key(id) : null;

    final Color? color = parseColor(styles['color']);
    final Color? shadowColor = parseColor(styles['shadowColor']);
    final Color? surfaceTintColor = parseColor(styles['surfaceTintColor']);
    final double? elevation = parseDouble(styles['elevation']); // Card valida >= 0.0
    final ShapeBorder? shape = parseShapeBorder(styles['shape']);
    final bool borderOnForeground = parseBool(properties['borderOnForeground']) ?? true;
    final EdgeInsetsGeometry? margin = parseEdgeInsets(styles['margin']);
    final Clip? clipBehavior = parseClipBehavior(styles['clipBehavior']);
    final bool semanticContainer = parseBool(properties['semanticContainer']) ?? true;

    Widget? childWidget;
    if (childrenJson.isNotEmpty && childrenJson.first is Map<String, dynamic>) {
      try {
        childWidget = WidgetFactory.buildWidgetFromJson(
          context,
          childrenJson.first as Map<String, dynamic>,
          params,
        );
      } catch (e) {
        print("Error al construir el hijo para Card (id: $id): $e");
        childWidget = null;
      }
    } else if (childrenJson.isNotEmpty) {
      print("Advertencia: El primer elemento en 'children' para Card (id: $id) no es un mapa válido.");
    }

    return Card(
      key: key,
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      shape: shape,
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: childWidget,
    );
  }
}

