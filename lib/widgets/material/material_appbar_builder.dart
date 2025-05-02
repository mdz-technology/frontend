import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/utils.dart';

// TODO: leading, flexibleSpace, bottom
class MaterialAppBarBuilder {

  static const String typeName = 'material.appBar';

  static void register() {
    WidgetFactory.registerBuilder(
      typeName,
      buildWithParams,
    );
  }

  static Widget buildWithParams(BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    print("[AppBarBuilder] Iniciando construcción para AppBar...");

    final styles = Map<String, dynamic>.from(json['styles'] as Map? ?? {});
    final properties = Map<String, dynamic>.from(json['properties'] as Map? ?? {});
    final Key? key = json.containsKey('id') ? Key(json['id'] as String) : null;
    final children = json['children'] as List<dynamic>? ?? [];

    final Map<String, dynamic>? titleJson = children
        .whereType<Map<String, dynamic>>()
        .firstWhereOrNull((child) => child['slot'] == 'material.appBar.title');

    final Widget? titleWidget = titleJson != null
        ? WidgetFactory.buildWidgetFromJson(context, titleJson)
        : null;
    if (titleJson != null) {
      children.remove(titleJson);
    }

    final List<Widget> actionsWidgets = children
        .whereType<Map<String, dynamic>>()
        .where((child) => child['slot'] == 'material.appBar.actions')
        .map((child) => WidgetFactory.buildWidgetFromJson(context, child))
        .toList();

    final bool automaticallyImplyLeading = properties['automaticallyImplyLeading'] as bool? ?? true; // Default true
    final double? elevation = (properties['elevation'] as num?)?.toDouble();
    final double? scrolledUnderElevation = (properties['scrolledUnderElevation'] as num?)?.toDouble();
    final Color? shadowColor = styles['shadowColor'] != null ? parseColor(styles['shadowColor']) : null;
    final Color? surfaceTintColor = styles['surfaceTintColor'] != null ? parseColor(styles['surfaceTintColor']) : null;
    final Color? backgroundColor = styles['backgroundColor'] != null ? parseColor(styles['backgroundColor']) : null;
    final Color? foregroundColor = styles['foregroundColor'] != null ? parseColor(styles['foregroundColor']) : null;
    final bool primary = properties['primary'] as bool? ?? true; // Default true
    final bool? centerTitle = properties['centerTitle'] as bool?;
    final double? titleSpacing = (properties['titleSpacing'] as num?)?.toDouble();
    final double? toolbarHeight = (properties['toolbarHeight'] as num?)?.toDouble();
    final double? leadingWidth = (properties['leadingWidth'] as num?)?.toDouble();

    return AppBar(
      key: key,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: titleWidget,
      actions: actionsWidgets,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      primary: primary,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
    );
  }
}