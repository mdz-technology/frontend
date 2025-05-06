
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils.dart';
import '../../widget_factory.dart';

class MultiplatformContainerBuilder {


  static const String typeName = 'multiplatform.container';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(BuildContext context,
      Map<String, dynamic> json,
      [Map<String, dynamic>? params]) {

    final String? localId = json['id']?.toString();
    final Map<String, dynamic> localStyles = Map<String, dynamic>.from(json['styles'] as Map? ?? {});
    final Map<String, dynamic> localProperties = Map<String, dynamic>.from(json['properties'] as Map? ?? {});
    final List<dynamic> localChildren = json['children'] as List<dynamic>? ?? [];

    final Key? key = (localId != null && localId.isNotEmpty) ? Key(localId) : null;

    final AlignmentGeometry? alignment = parseAlignment(localStyles['alignment']?.toString());
    final EdgeInsetsGeometry? padding = parseEdgeInsets(localStyles['padding']);
    final Color? color = parseColor(localStyles['backgroundColor']?.toString());
    final Decoration? decoration = parseDecoration(localStyles['decoration'] as Map<String, dynamic>?);
    final double? width = parseDouble(localStyles['width']);
    final double? height = parseDouble(localStyles['height']);
    final EdgeInsetsGeometry? margin = parseEdgeInsets(localStyles['margin']);

    final BoxConstraints? constraints = parseBoxConstraints(localProperties['constraints']);
    final Matrix4? transform = parseTransform(localProperties['transform']);
    final AlignmentGeometry? transformAlignment = parseAlignment(localProperties['transformAlignment']?.toString());
    final Clip clipBehavior = parseClipBehavior(localProperties['clipBehavior']) ?? Clip.none;

    Widget? childWidget;
    if (localChildren.isNotEmpty) {
      final firstChildJson = localChildren.first;
      if (firstChildJson is Map<String, dynamic>) {
        try {
          childWidget = WidgetFactory.buildWidgetFromJson(
            context,
            firstChildJson,
            params,
          );
        } catch (e) {
          print("Error building child for Container (id: $localId): $e. Child JSON: $firstChildJson");
          childWidget = const SizedBox.shrink(key: ValueKey('error_child_container'));
        }
      } else if (firstChildJson != null) {
        print("Warning: Child for Container (id: $localId) is not a valid Map. Child: $firstChildJson");
      }
    }

    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: decoration == null ? color : null,
      decoration: decoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: childWidget,
    );
  }
}