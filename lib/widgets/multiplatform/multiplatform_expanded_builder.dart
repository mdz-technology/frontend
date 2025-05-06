import 'package:flutter/widgets.dart';
import 'package:frontend/widgets/utils.dart';

import '../../widget_factory.dart';

class MultiplatformExpandedBuilder {

  static const String typeName = 'multiplatform.expanded';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {

    final String? id = json['id'] as String?;

    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};
    final List<dynamic> childrenJson = json['children'] as List<dynamic>? ?? [];

    final Key? key = id != null ? Key(id) : null;

    final int flex = parseInt(properties['flex']) ?? 1;

    Widget? childWidget;
    if (childrenJson.isNotEmpty && childrenJson.first is Map<String, dynamic>) {
      try {
        childWidget = WidgetFactory.buildWidgetFromJson(
          context,
          childrenJson.first as Map<String, dynamic>,
          params,
        );
      } catch (e) {
        print("Error al construir el hijo para Expanded (id: $id): $e");
        childWidget = null;
      }
    }

    if (childWidget == null) {
      final String errorMsg = "Error: Expanded (id: $id) requiere exactamente un 'child' válido definido en la lista 'children'.";
      print(errorMsg);

      return SizedBox.shrink(key: key);
    }

    return Expanded(
      key: key,
      flex: flex,
      child: childWidget,
    );
  }
}