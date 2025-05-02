import 'package:flutter/material.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/utils.dart';

class MaterialDrawerBuilder {

  static const String typeName = 'material.drawer';

  static void register() {
    WidgetFactory.registerBuilder(
      typeName,
      _buildWithParams,
    );
  }

  static Widget _buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    final Map<String, dynamic> styles = Map<String, dynamic>.from(json['styles'] as Map? ?? {});
    final Map<String, dynamic> properties = Map<String, dynamic>.from(json['properties'] as Map? ?? {});
    final List<dynamic> childrenJson = json['children'] as List<dynamic>? ?? [];
    final Key? key = json.containsKey('id') ? Key(json['id'].toString()) : null;

    final String? backgroundColorString = styles['backgroundColor']?.toString();
    final Color? backgroundColor = backgroundColorString != null ? parseColor(backgroundColorString) : null;

    final String? shadowColorString = styles['shadowColor']?.toString();
    final Color? shadowColor = shadowColorString != null ? parseColor(shadowColorString) : null;

    final String? surfaceTintColorString = styles['surfaceTintColor']?.toString();
    final Color? surfaceTintColor = surfaceTintColorString != null ? parseColor(surfaceTintColorString) : null;

    final double? elevation = _parseDouble(properties['elevation']);
    final double? width = _parseDouble(properties['width']);

    final Clip? clipBehavior = _parseClipBehavior(properties['clipBehavior']?.toString());
    final String? semanticLabel = properties['semanticLabel']?.toString();

    final List<Widget> childrenWidgets = childrenJson
        .whereType<Map<String, dynamic>>()
        .map((childJson) {
      try {
        return WidgetFactory.buildWidgetFromJson(context, childJson);
      } catch (e) {
        print("Error building drawer child widget: $e - JSON: $childJson");
        return const SizedBox.shrink(key: ValueKey('error_drawer_child'));
      }
    }).toList();

    return Drawer(
      key: key,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      width: width,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      semanticLabel: semanticLabel,
      child: ListView(
        padding: EdgeInsets.zero,
        children: childrenWidgets,
      ),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static Clip? _parseClipBehavior(String? value) {
    switch (value) {
      case 'none': return Clip.none;
      case 'hardEdge': return Clip.hardEdge;
      case 'antiAlias': return Clip.antiAlias;
      case 'antiAliasWithSaveLayer': return Clip.antiAliasWithSaveLayer;
      default: return null; // Drawer usará su valor por defecto
    }
  }

}