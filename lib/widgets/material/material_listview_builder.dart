import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils.dart';
import 'package:provider/provider.dart';

import '../../state_notifier/scroll_state_notifier.dart';
import '../../widget_factory.dart';

//TODO: itemExtentBuilder and prototypeItem
class MaterialListViewBuilder {
  static const String typeName = 'material.listview';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(
    BuildContext context,
    Map<String, dynamic> json, [
    Map<String, dynamic>? params,
  ]) {
    final String? id = json['id'] as String?;
    final Map<String, dynamic> styles =
        json['styles'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> properties =
        json['properties'] as Map<String, dynamic>? ?? {};
    final List<dynamic> childrenJson = json['children'] as List<dynamic>? ?? [];

    final Key? key = id != null ? Key(id) : null;

    ScrollController? controller;
    if (id != null) {
      try {
        final notifier = context.read<ScrollStateNotifier>();
        controller = notifier.getOrCreateController(id);
      } catch (e) {
        print(
            "Advertencia: No se pudo obtener ScrollStateNotifier del contexto para ListView $id. ScrollController no se gestionará centralmente. Error: $e");
      }
    }

    final Axis scrollDirection =
        parseAxis(properties['scrollDirection']) ?? Axis.vertical;
    final bool reverse = parseBool(properties['reverse']) ?? false;
    final bool? primary = parseBool(properties['primary']);
    final ScrollPhysics? physics = parseScrollPhysics(styles['physics']);
    final bool shrinkWrap = parseBool(properties['shrinkWrap']) ?? false;
    final EdgeInsetsGeometry? padding = parseEdgeInsets(styles['padding']);
    final double? itemExtent = parseDouble(properties['itemExtent']);
    final bool addAutomaticKeepAlives =
        parseBool(properties['addAutomaticKeepAlives']) ?? true;
    final bool addRepaintBoundaries =
        parseBool(properties['addRepaintBoundaries']) ?? true;
    final bool addSemanticIndexes =
        parseBool(properties['addSemanticIndexes']) ?? true;
    final double? cacheExtent = parseDouble(properties['cacheExtent']);
    final int? semanticChildCountFromJson =
        parseInt(properties['semanticChildCount']);
    final DragStartBehavior dragStartBehavior =
        parseDragStartBehavior(styles['dragStartBehavior']) ??
            DragStartBehavior.start;
    final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        parseScrollViewKeyboardDismissBehavior(
                styles['keyboardDismissBehavior']) ??
            ScrollViewKeyboardDismissBehavior.manual;
    final String? restorationId = parseString(properties['restorationId']);
    final Clip clipBehavior =
        parseClipBehavior(styles['clipBehavior']) ?? Clip.hardEdge;
    final HitTestBehavior hitTestBehavior =
        parseHitTestBehavior(styles['hitTestBehavior']) ??
            HitTestBehavior.opaque;

    final List<Widget> builtChildren = childrenJson
        .map((childData) {
          if (childData is Map<String, dynamic>) {
            return WidgetFactory.buildWidgetFromJson(
                context, childData, params);
          } else {
            print(
                "Advertencia: Elemento no válido encontrado en 'children' de ListView $id. Se omitirá.");
            return const SizedBox.shrink();
          }
        })
        .whereType<Widget>()
        .toList();

    final int? effectiveSemanticChildCount =
        semanticChildCountFromJson ?? builtChildren.length;

    return ListView(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      children: builtChildren,
      semanticChildCount: effectiveSemanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      hitTestBehavior: hitTestBehavior,
    );
  }
}
