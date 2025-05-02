import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils.dart';
import 'package:provider/provider.dart';

import '../../state_notifier/scroll_state_notifier.dart';
import '../../widget_factory.dart';

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
    // 1. Extracción Segura
    final String? id = json['id'] as String?;
    final Map<String, dynamic> styles = json['styles'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};
    final List<dynamic> childrenJson = json['children'] as List<dynamic>? ?? [];
    // events no son comunes directamente en ListView

    // 2. Key
    final Key? key = id != null ? Key(id) : null;

    // 3. ScrollController (Manejo de Estado)
    ScrollController? controller;
    if (id != null) {
      // TODO: Asegúrate que ScrollStateNotifier implemente getOrCreateScrollController
      // y que lo estés proporcionando correctamente (ej: con Provider).
      try {
        final notifier = context.read<ScrollStateNotifier>();
        controller = notifier.getOrCreateController(id);
      } catch (e) {
        print("Advertencia: No se pudo obtener ScrollStateNotifier del contexto para ListView $id. ScrollController no se gestionará centralmente. Error: $e");
        // Considera crear un controller local si la gestión central falla y es necesario
        // controller = ScrollController();
      }
    }

    // 4. Parseo de Propiedades y Estilos
    final Axis scrollDirection = parseAxis(properties['scrollDirection']) ?? Axis.vertical; // Necesita parseAxis
    final bool reverse = parseBool(properties['reverse']) ?? false;
    final bool? primary = parseBool(properties['primary']); // Nullable, Flutter lo determina
    final ScrollPhysics? physics = parseScrollPhysics(styles['physics']); // Necesita parseScrollPhysics (ya lo tenías)
    final bool shrinkWrap = parseBool(properties['shrinkWrap']) ?? false;
    final EdgeInsetsGeometry? padding = parseEdgeInsets(styles['padding']);
    final double? itemExtent = parseDouble(properties['itemExtent']);
    // itemExtentBuilder y prototypeItem son más complejos, omitidos por ahora.
    final bool addAutomaticKeepAlives = parseBool(properties['addAutomaticKeepAlives']) ?? true;
    final bool addRepaintBoundaries = parseBool(properties['addRepaintBoundaries']) ?? true;
    final bool addSemanticIndexes = parseBool(properties['addSemanticIndexes']) ?? true;
    final double? cacheExtent = parseDouble(properties['cacheExtent']);
    final int? semanticChildCountFromJson = parseInt(properties['semanticChildCount']);
    final DragStartBehavior dragStartBehavior = parseDragStartBehavior(styles['dragStartBehavior']) ?? DragStartBehavior.start; // Necesita parseDragStartBehavior
    final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = parseScrollViewKeyboardDismissBehavior(styles['keyboardDismissBehavior']) ?? ScrollViewKeyboardDismissBehavior.manual; // Necesita parseScrollViewKeyboardDismissBehavior
    final String? restorationId = parseString(properties['restorationId']);
    final Clip clipBehavior = parseClipBehavior(styles['clipBehavior']) ?? Clip.hardEdge; // parseClipBehavior existe
    final HitTestBehavior hitTestBehavior = parseHitTestBehavior(styles['hitTestBehavior']) ?? HitTestBehavior.opaque; // Necesita parseHitTestBehavior


    // 5. Construcción de los Hijos (children)
    final List<Widget> builtChildren = childrenJson
        .map((childData) {
      if (childData is Map<String, dynamic>) {
        // Construye cada hijo usando WidgetFactory recursivamente
        return WidgetFactory.buildWidgetFromJson(context, childData, params);
      } else {
        print("Advertencia: Elemento no válido encontrado en 'children' de ListView $id. Se omitirá.");
        return const SizedBox.shrink(); // O un widget vacío
      }
    })
        .whereType<Widget>() // Asegura que solo tengamos Widgets (filtra SizedBox si se usó)
        .toList();

    // Determina el conteo semántico (si no se provee, usa la longitud de hijos)
    final int? effectiveSemanticChildCount = semanticChildCountFromJson ?? builtChildren.length;


    // 6. Construcción del Widget ListView
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
      // prototypeItem: prototypeItemWidget, // Si se implementara
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      children: builtChildren, // La lista de widgets hijos construidos
      semanticChildCount: effectiveSemanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      hitTestBehavior: hitTestBehavior, // Pasado al ScrollView subyacente
    );
  }
}

// --- Parsers Adicionales NECESARIOS en utils.dart ---

// TODO: Implementar estos parsers en utils.dart

/// Parsea un string ("horizontal", "vertical") a un enum Axis.
Axis? parseAxis(String? axis) {
  if (axis == null) return null; // Default es vertical en ListView
  switch (axis.toLowerCase()) {
    case 'horizontal': return Axis.horizontal;
    case 'vertical': return Axis.vertical;
    default:
      print("Warning: Axis no reconocido '$axis'. Usando vertical.");
      return Axis.vertical;
  }
}

/// Parsea un string ("manual", "onDrag") a ScrollViewKeyboardDismissBehavior.
ScrollViewKeyboardDismissBehavior? parseScrollViewKeyboardDismissBehavior(String? behavior) {
  if (behavior == null) return null; // Default es manual
  switch (behavior.toLowerCase()) {
    case 'manual': return ScrollViewKeyboardDismissBehavior.manual;
    case 'ondrag': return ScrollViewKeyboardDismissBehavior.onDrag;
    default:
      print("Warning: ScrollViewKeyboardDismissBehavior no reconocido '$behavior'. Usando manual.");
      return ScrollViewKeyboardDismissBehavior.manual;
  }
}

/// Parsea un string ("opaque", "translucent", "deferToChild") a HitTestBehavior.
HitTestBehavior? parseHitTestBehavior(String? behavior) {
  if (behavior == null) return null; // Default suele ser opaque para áreas clickeables
  switch (behavior.toLowerCase()) {
    case 'opaque': return HitTestBehavior.opaque;
    case 'translucent': return HitTestBehavior.translucent;
    case 'defertochild':
    case 'defer': return HitTestBehavior.deferToChild;
    default:
      print("Warning: HitTestBehavior no reconocido '$behavior'.");
      return null;
  }
}