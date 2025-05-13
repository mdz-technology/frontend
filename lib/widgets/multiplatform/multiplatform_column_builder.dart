import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils.dart';
import '../../widget_factory.dart';

class MultiplatformColumnBuilder {

  static const String typeName = 'multiplatform.column';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(BuildContext context, Map<String, dynamic> json, [Map<String, dynamic>? params]) {

    final Map<String, dynamic> properties = json['properties'] ?? {};
    final List<dynamic> childrenJson = json['children'] ?? [];
    final String? id = json['id'] as String?;

    final Key? key = parseKey(id);

    final MainAxisAlignment mainAxisAlignment = parseMainAxisAlignment(properties['mainAxisAlignment']) ?? MainAxisAlignment.start;
    final MainAxisSize mainAxisSize = parseMainAxisSize(properties['mainAxisSize']) ?? MainAxisSize.max;
    final CrossAxisAlignment crossAxisAlignment = parseCrossAxisAlignment(properties['crossAxisAlignment']) ?? CrossAxisAlignment.center;
    final TextDirection? textDirection = parseTextDirection(properties['textDirection']);
    final VerticalDirection verticalDirection = parseVerticalDirection(properties['verticalDirection']) ?? VerticalDirection.down;
    final TextBaseline? textBaseline = parseTextBaseline(properties['textBaseline']);
    final double spacing = parseDouble(properties['spacing']) ?? 0.0;

    final List<Widget> childrenWidgets = childrenJson
        .where((childJson) => childJson is Map<String, dynamic>)
        .map((childJson) {
      try {
        return WidgetFactory.buildWidgetFromJson(
            context, childJson as Map<String, dynamic>, params);
      } catch (e) {
        print('Error building child for Column (id: $id): $e');
        return const SizedBox.shrink();
      }
    }).toList();

    return Column(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: spacing,
      children: childrenWidgets,
    );

  }

}