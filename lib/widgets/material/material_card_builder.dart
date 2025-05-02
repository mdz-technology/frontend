import 'package:flutter/material.dart';

import 'package:frontend/widgets/utils.dart';

import '../../widget_factory.dart';

class MaterialCardBuilder {
  static const String typeName = 'material.card';

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
    // events no son aplicables directamente a Card

    // 2. Key
    final Key? key = id != null ? Key(id) : null;

    // 3. Parseo de Propiedades y Estilos
    final Color? color = parseColor(styles['color']);
    final Color? shadowColor = parseColor(styles['shadowColor']);
    final Color? surfaceTintColor = parseColor(styles['surfaceTintColor']);
    final double? elevation = parseDouble(styles['elevation']); // Card valida >= 0.0
    final ShapeBorder? shape = parseShapeBorder(styles['shape']); // Necesita parseShapeBorder en utils
    final bool borderOnForeground = parseBool(properties['borderOnForeground']) ?? true; // Default de Card
    final EdgeInsetsGeometry? margin = parseEdgeInsets(styles['margin']);
    final Clip? clipBehavior = parseClipBehavior(styles['clipBehavior']); // parseClipBehavior existe
    final bool semanticContainer = parseBool(properties['semanticContainer']) ?? true; // Default de Card

    // 4. Construcción del Hijo (child) - Opcional
    Widget? childWidget;
    if (childrenJson.isNotEmpty && childrenJson.first is Map<String, dynamic>) {
      // Card solo tiene UN hijo. Tomamos el primero de la lista 'children'.
      try {
        childWidget = WidgetFactory.buildWidgetFromJson(
          context,
          childrenJson.first as Map<String, dynamic>,
          params, // Pasa los params al hijo
        );
      } catch (e) {
        print("Error al construir el hijo para Card (id: $id): $e");
        childWidget = null; // No asignar hijo si la construcción falla
      }
    } else if (childrenJson.isNotEmpty) {
      print("Advertencia: El primer elemento en 'children' para Card (id: $id) no es un mapa válido.");
    }

    // 5. Construcción del Widget Card
    return Card(
      key: key,
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      shape: shape,
      borderOnForeground: borderOnForeground,
      margin: margin,
      // Si parseClipBehavior devuelve null, Card usa su propio default interno
      // que suele depender de si tiene forma (shape) o no.
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: childWidget, // Puede ser null si no se define o falla la construcción
    );
  }
}

