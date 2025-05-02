import 'package:flutter/widgets.dart';
import 'package:frontend/widgets/utils.dart';

import '../../widget_factory.dart';

class MultiplatformFlexibleBuilder {
  // Usamos 'material.' por consistencia, aunque Flexible es de layout general
  static const String typeName = 'multiplatform.flexible';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    // 1. Extracción Segura
    final String? id = json['id'] as String?; // ID opcional para Flexible
    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};
    final List<dynamic> childrenJson = json['children'] as List<dynamic>? ?? [];
    // styles y events no son directamente aplicables a Flexible

    // 2. Key (opcional)
    final Key? key = id != null ? Key(id) : null;

    // 3. Parseo de Propiedades
    // 'flex' determina cuánto espacio ocupa en relación a otros Flexible/Expanded. Default es 1.
    final int flex = parseInt(properties['flex']) ?? 1; // parseInt ya existe

    // 'fit' determina cómo el hijo llena el espacio (tight o loose). Default es loose.
    final FlexFit fit = parseFlexFit(properties['fit']) ?? FlexFit.loose; // Necesita parseFlexFit en utils

    // 4. Construcción del Hijo (child) - ¡Requerido!
    Widget? childWidget;
    if (childrenJson.isNotEmpty && childrenJson.first is Map<String, dynamic>) {
      // Flexible solo tiene UN hijo. Tomamos el primero de la lista 'children'.
      try {
        childWidget = WidgetFactory.buildWidgetFromJson(
          context,
          childrenJson.first as Map<String, dynamic>,
          params, // Pasa los params al hijo
        );
      } catch (e) {
        print("Error al construir el hijo para Flexible (id: $id): $e");
        childWidget = null;
      }
    }

    // Validar que el hijo se haya construido correctamente
    if (childWidget == null) {
      final String errorMsg = "Error: Flexible (id: $id) requiere exactamente un 'child' válido definido en la lista 'children'.";
      print(errorMsg);
      // Retornar un widget vacío para evitar crash
      return SizedBox.shrink(key: key);
    }

    // 5. Construcción del Widget Flexible
    return Flexible(
      key: key,
      flex: flex,
      fit: fit, // Usa el valor parseado (o el default loose)
      child: childWidget, // El hijo construido
    );
  }
}


// --- Parser Adicional NECESARIO en utils.dart ---

// TODO: Añadir esta función a tu archivo utils/utils.dart

/// Parsea un string ("tight", "loose") al enum FlexFit nullable.
FlexFit? parseFlexFit(dynamic value) {
  if (value == null || value is! String) {
    return null; // Devuelve null si no es un string válido
  }
  switch (value.toLowerCase()) {
    case 'tight':
      return FlexFit.tight;
    case 'loose':
      return FlexFit.loose;
    default:
      print("Warning: FlexFit no reconocido '$value'.");
      return null; // Devuelve null si el string no es válido
  }
}
