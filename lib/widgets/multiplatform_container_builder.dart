
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils.dart';
import '../widget_factory.dart';

class MultiplatformContainerBuilder {

  static late String id;
  static late Map<String, dynamic> styles;
  static late Map<String, dynamic> properties;
  static late Map<String, dynamic> events;
  static late List<dynamic> children;

  static const String typeName = 'multiplatform.container';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(BuildContext context,
      Map<String, dynamic> json,
      [Map<String, dynamic>? params]) {

    _loadFromJson(json);

    final Key? key = id != null ? Key(id) : null;

    final AlignmentGeometry? alignment = parseAlignment(styles['alignment']);
    final EdgeInsetsGeometry? padding = parseEdgeInsets(styles['padding']);
    final Color? color = parseColor(styles['backgroundColor']); // Mapeo de 'backgroundColor'
    final Decoration? decoration = parseDecoration(styles['decoration']);
    final double? width = parseDouble(styles['width']);
    final double? height = parseDouble(styles['height']);
    final EdgeInsetsGeometry? margin = parseEdgeInsets(styles['margin']);

    final BoxConstraints? constraints = parseBoxConstraints(properties['constraints']);
    final Matrix4? transform = parseTransform(properties['transform']);
    final AlignmentGeometry? transformAlignment = parseAlignment(properties['transformAlignment']);
    final Clip clipBehavior = parseClipBehavior(properties['clipBehavior']) ?? Clip.none; // Default de Flutter

    Widget? childWidget;
    if (children.isNotEmpty && children.first is Map<String, dynamic>) {
      childWidget = WidgetFactory.buildWidgetFromJson(
        context,
        children.first as Map<String, dynamic>,
        params,
      );
    }

    final container = Container(
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
    return container;
  }

  static _loadFromJson(Map<String, dynamic> json) {
    id = json['id'] as String? ?? '';
    styles = json['styles'] as Map<String, dynamic>? ?? {};
    properties = json['properties'] as Map<String, dynamic>? ?? {};
    events = json['events'] as Map<String, dynamic>? ?? {};
    children = json['children'] as List<dynamic>? ?? [];
  }

}