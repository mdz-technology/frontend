import 'package:flutter/widgets.dart';
import 'package:frontend/widgets/utils.dart';

import '../../widget_factory.dart';

class MultiplatformExpandedBuilder {
  // Usamos 'material.' por consistencia, aunque Expanded es de layout general
  static const String typeName = 'multiplatform.expanded';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    // 1. Extracción Segura
    final String? id = json['id'] as String?; // ID es opcional para Expanded
    // styles y events no son directamente aplicables a Expanded
    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};
    final List<dynamic> childrenJson = json['children'] as List<dynamic>? ?? [];

    // 2. Key (opcional)
    final Key? key = id != null ? Key(id) : null;

    // 3. Parseo de Propiedades
    // 'flex' determina cuánto espacio ocupa en relación a otros Expanded. Default es 1.
    final int flex = parseInt(properties['flex']) ?? 1; // parseInt ya existe en tus utils

    // 4. Construcción del Hijo (child) - ¡Requerido!
    Widget? childWidget;
    if (childrenJson.isNotEmpty && childrenJson.first is Map<String, dynamic>) {
      // Expanded solo tiene UN hijo. Tomamos el primero de la lista 'children'.
      try {
        childWidget = WidgetFactory.buildWidgetFromJson(
          context,
          childrenJson.first as Map<String, dynamic>,
          params, // Pasa los params al hijo
        );
      } catch (e) {
        print("Error al construir el hijo para Expanded (id: $id): $e");
        childWidget = null; // Marcar como nulo si la construcción falla
      }
    }

    // Validar que el hijo se haya construido correctamente
    if (childWidget == null) {
      final String errorMsg = "Error: Expanded (id: $id) requiere exactamente un 'child' válido definido en la lista 'children'.";
      print(errorMsg);
      // Retornar un widget vacío o un placeholder para indicar el error en la UI
      return SizedBox.shrink(key: key);
      // O un placeholder más visible:
      // return Placeholder(
      //   key: key,
      //   fallbackHeight: 50,
      //   fallbackWidth: 100,
      //   color: Colors.red,
      //   child: Center(child: Text("Expanded sin hijo", style: TextStyle(color: Colors.white, fontSize: 10))),
      // );
    }

    // 5. Construcción del Widget Expanded
    // El constructor de Expanded establece automáticamente fit: FlexFit.tight
    return Expanded(
      key: key,
      flex: flex,
      child: childWidget, // El hijo construido
    );
  }
}