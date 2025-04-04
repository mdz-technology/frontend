import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';

Widget buildListView(Map<String, dynamic> json) {
  final children = (json['children'] as List<dynamic>? ?? [])
      .map((child) => WidgetFactory.buildWidgetFromJson(child))
      .toList();

  final itemExtent = (json['itemExtent'] as num?)?.toDouble();
  final prototypeItem = json['prototypeItem'] != null
      ? WidgetFactory.buildWidgetFromJson(json['prototypeItem'])
      : null;

  // Validación de exclusividad (solo uno permitido)
  if ([itemExtent, prototypeItem].where((e) => e != null).length > 1) {
    throw FlutterError(
        'Solo se puede definir uno entre itemExtent, prototypeItem (o itemExtentBuilder, si se agrega luego).');
  }

  return ListView(
    scrollDirection: _parseAxis(json['scrollDirection']) ?? Axis.vertical,
    reverse: json['reverse'] ?? false,
    controller: null, // No se soporta aún desde JSON
    primary: json['primary'],
    physics: _parseScrollPhysics(json['physics']),
    shrinkWrap: json['shrinkWrap'] ?? false,
    padding: _parseEdgeInsets(json['padding']),
    itemExtent: itemExtent,
    prototypeItem: prototypeItem,
    addAutomaticKeepAlives: json['addAutomaticKeepAlives'] ?? true,
    addRepaintBoundaries: json['addRepaintBoundaries'] ?? true,
    addSemanticIndexes: json['addSemanticIndexes'] ?? true,
    cacheExtent: (json['cacheExtent'] as num?)?.toDouble(),
    semanticChildCount: json['semanticChildCount'],
    dragStartBehavior: _parseDragStartBehavior(json['dragStartBehavior']) ?? DragStartBehavior.start,
    keyboardDismissBehavior: _parseKeyboardDismissBehavior(json['keyboardDismissBehavior']) ?? ScrollViewKeyboardDismissBehavior.manual,
    restorationId: json['restorationId'],
    clipBehavior: _parseClip(json['clipBehavior']) ?? Clip.hardEdge,
    hitTestBehavior: _parseHitTestBehavior(json['hitTestBehavior']) ?? HitTestBehavior.deferToChild,
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


///****************************************************************
/*
enum TypeListView { static, dynamic }

Widget buildListView(Map<String, dynamic> json) {
// Verificar si los hijos están definidos directamente en el JSON
  final childrenJson = json['children'] as List<dynamic>?;

  TypeListView typeList;
  if (childrenJson != null && childrenJson.isNotEmpty) {
    typeList = TypeListView.static;

    final staticItems = <Map<String, dynamic>>[];

    childrenJson?.forEach((element) {
      staticItems.add(element);
    });

    return ListView.builder(
      itemCount: staticItems.length,
      itemBuilder: (context, index) {
        return WidgetFactory.buildWidgetFromJson(staticItems[index]);
      },
    );
  }

//cada elemento un identificador
//vincularlo con la data

  return Consumer<GlobalStateProvider>(
    builder: (context, stateProvider, child) {
      print("Consumer rebuild triggered");

// Obtener datos del estado global
      final globalState = stateProvider.globalState;
      final dynamicItems = globalState['items'] as List<dynamic>? ?? [];

// Combinar listas estática y dinámica
      final allItems = <Map<String, dynamic>>[];

      dynamicItems.forEach((item) {
        if (item is Map<String, dynamic>) {
          final processedItem = replacePlaceholders(json['template'], item);
          allItems.add(processedItem);
        }
      });

      if (allItems.isEmpty) {
        return Center(
          child: Text("No hay elementos para mostrar"),
        );
      }

// Renderizar la lista con widgets desacoplados
      return ListView.builder(
        itemCount: allItems.length,
        itemBuilder: (context, index) {
          return buildWidgetFromJson(allItems[index]);
        },
      );
    },
  );
}
*/