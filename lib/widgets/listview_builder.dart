import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/widget_state_notifier.dart';
import 'package:provider/provider.dart';

Widget buildListView(Map<String, dynamic> json) {
  final widgetId = json['id'];
  final properties = json['properties'] as Map<String, dynamic>? ?? {};
  final childrenJson = json['children'] as List<dynamic>? ?? [];

  final children = childrenJson
      .map((child) => WidgetFactory.buildWidgetFromJson(child))
      .toList();

  final itemExtent = (properties['itemExtent'] as num?)?.toDouble();
  final prototypeItem = properties['prototypeItem'] != null
      ? WidgetFactory.buildWidgetFromJson(properties['prototypeItem'])
      : null;

  if ([itemExtent, prototypeItem].where((e) => e != null).length > 1) {
    throw FlutterError('Solo se puede definir uno entre itemExtent o prototypeItem.');
  }

  if (widgetId != null) {
    return ListViewWidget(
      widgetId: widgetId,
      itemExtent: itemExtent,
      prototypeItem: prototypeItem,
      scrollDirection: _parseAxis(properties['direction']) ?? Axis.vertical,
      reverse: properties['reverse'] ?? false,
      primary: properties['primary'],
      physics: _parseScrollPhysics(properties['physics']),
      shrinkWrap: properties['shrinkWrap'] ?? false,
      padding: _parseEdgeInsets(properties['padding']),
      cacheExtent: (properties['cacheExtent'] as num?)?.toDouble(),
      semanticChildCount: properties['semanticChildCount'],
      dragStartBehavior: _parseDragStartBehavior(properties['dragStartBehavior']) ?? DragStartBehavior.start,
      keyboardDismissBehavior: _parseKeyboardDismissBehavior(properties['keyboardDismissBehavior']) ?? ScrollViewKeyboardDismissBehavior.manual,
      restorationId: properties['restorationId'],
      clipBehavior: _parseClip(properties['clipBehavior']) ?? Clip.hardEdge,
      hitTestBehavior: _parseHitTestBehavior(properties['hitTestBehavior']) ?? HitTestBehavior.deferToChild,
      children: children,
    );
  }

  return ListView(
    scrollDirection: _parseAxis(properties['direction']) ?? Axis.vertical,
    reverse: properties['reverse'] ?? false,
    controller: null,
    primary: properties['primary'],
    physics: _parseScrollPhysics(properties['physics']),
    shrinkWrap: properties['shrinkWrap'] ?? false,
    padding: _parseEdgeInsets(properties['padding']),
    itemExtent: itemExtent,
    prototypeItem: prototypeItem,
    addAutomaticKeepAlives: properties['addAutomaticKeepAlives'] ?? true,
    addRepaintBoundaries: properties['addRepaintBoundaries'] ?? true,
    addSemanticIndexes: properties['addSemanticIndexes'] ?? true,
    cacheExtent: (properties['cacheExtent'] as num?)?.toDouble(),
    semanticChildCount: properties['semanticChildCount'],
    dragStartBehavior: _parseDragStartBehavior(properties['dragStartBehavior']) ?? DragStartBehavior.start,
    keyboardDismissBehavior: _parseKeyboardDismissBehavior(properties['keyboardDismissBehavior']) ?? ScrollViewKeyboardDismissBehavior.manual,
    restorationId: properties['restorationId'],
    clipBehavior: _parseClip(properties['clipBehavior']) ?? Clip.hardEdge,
    hitTestBehavior: _parseHitTestBehavior(properties['hitTestBehavior']) ?? HitTestBehavior.deferToChild,
    children: children,
  );
}


Axis? _parseAxis(String? value) {
  switch (value) {
    case 'horizontal': return Axis.horizontal;
    case 'vertical': return Axis.vertical;
    default: return null;
  }
}

EdgeInsets? _parseEdgeInsets(dynamic value) {
  if (value is Map<String, dynamic>) {
    return EdgeInsets.only(
      left: (value['left'] ?? 0.0).toDouble(),
      top: (value['top'] ?? 0.0).toDouble(),
      right: (value['right'] ?? 0.0).toDouble(),
      bottom: (value['bottom'] ?? 0.0).toDouble(),
    );
  }
  return null;
}

ScrollPhysics? _parseScrollPhysics(String? value) {
  switch (value) {
    case 'always': return const AlwaysScrollableScrollPhysics();
    case 'never': return const NeverScrollableScrollPhysics();
    case 'bouncing': return const BouncingScrollPhysics();
    case 'clamping': return const ClampingScrollPhysics();
    default: return null;
  }
}

DragStartBehavior? _parseDragStartBehavior(String? value) {
  switch (value) {
    case 'start': return DragStartBehavior.start;
    case 'down': return DragStartBehavior.down;
    default: return null;
  }
}

ScrollViewKeyboardDismissBehavior? _parseKeyboardDismissBehavior(String? value) {
  switch (value) {
    case 'manual': return ScrollViewKeyboardDismissBehavior.manual;
    case 'onDrag': return ScrollViewKeyboardDismissBehavior.onDrag;
    default: return null;
  }
}

Clip? _parseClip(String? value) {
  switch (value) {
    case 'none': return Clip.none;
    case 'hardEdge': return Clip.hardEdge;
    case 'antiAlias': return Clip.antiAlias;
    case 'antiAliasWithSaveLayer': return Clip.antiAliasWithSaveLayer;
    default: return null;
  }
}

HitTestBehavior? _parseHitTestBehavior(String? value) {
  switch (value) {
    case 'opaque': return HitTestBehavior.opaque;
    case 'deferToChild': return HitTestBehavior.deferToChild;
    case 'translucent': return HitTestBehavior.translucent;
    default: return null;
  }
}

class ListViewWidget extends StatelessWidget {
  final String widgetId;
  final List<Widget> children;
  final double? itemExtent;
  final Widget? prototypeItem;
  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final HitTestBehavior hitTestBehavior;

  const ListViewWidget({
    super.key,
    required this.widgetId,
    required this.children,
    this.itemExtent,
    this.prototypeItem,
    required this.scrollDirection,
    required this.reverse,
    this.primary,
    this.physics,
    required this.shrinkWrap,
    this.padding,
    this.cacheExtent,
    this.semanticChildCount,
    required this.dragStartBehavior,
    required this.keyboardDismissBehavior,
    this.restorationId,
    required this.clipBehavior,
    required this.hitTestBehavior,
  });

  @override
  Widget build(BuildContext context) {
    // Escuchar el estado de este widget en particular
    final state = Provider.of<WidgetStateNotifier>(context);
    final childrenFromState = state.getState(widgetId); // Obtener los widgets del estado

    // Si no hay datos aún, los generamos luego del frame
    if (childrenFromState == null || childrenFromState.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('[Flutter] Generating test data for: $widgetId');
        //final testData = generateTestData(widgetId);
        //state.updateState(widgetId, testData);
      });

      // Retornamos algo seguro por mientras
      return const Center(child: CircularProgressIndicator());
    }

    // Si hay datos, mostramos el ListView con los widgets del estado
    return ListView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      prototypeItem: prototypeItem,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      hitTestBehavior: hitTestBehavior,
      children: childrenFromState ?? children,
    );
  }
}
