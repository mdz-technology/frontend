// drawer_builder.dart (Nuevo archivo o agrégalo a uno existente)
import 'package:flutter/material.dart';
import 'package:frontend/widget_factory.dart'; // Asegúrate que la ruta sea correcta
import 'package:frontend/widgets/utils.dart';   // Para parseColor

class DrawerBuilder {
  static void register() {
    WidgetFactory.registerBuilder('drawer', buildWithParams);
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    final childrenJson = (json['children'] as List<dynamic>?) ?? [];
    final styles = json['styles'] ?? {};
    final properties = json['properties'] ?? {};

    // Construye la lista de widgets hijos para el Drawer
    final List<Widget> childrenWidgets = childrenJson
        .map((childJson) => WidgetFactory.buildWidgetFromJson(
      context,
      childJson as Map<String, dynamic>,
      // Puedes pasar params aquí si los hijos del drawer los necesitan
    ))
        .toList();

    // Devuelve el widget Drawer estándar de Material
    return Drawer(
      key: json['id'] != null ? Key(json['id']) : null,
      backgroundColor: styles['backgroundColor'] != null
          ? parseColor(styles['backgroundColor'])
          : null, // Color de fondo opcional
      elevation: (properties['elevation'] as num?)?.toDouble(), // Elevación opcional
      width: (properties['width'] as num?)?.toDouble(), // Ancho opcional
      child: ListView( // Usualmente se usa un ListView dentro del Drawer
        padding: EdgeInsets.zero, // Importante para evitar padding superior por defecto
        children: childrenWidgets,
      ),
      // child: Column( // Alternativa si no necesitas scroll
      //   children: childrenWidgets,
      // ),
    );
  }
}