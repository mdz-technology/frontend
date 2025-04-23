import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/utils.dart';


class ContainerBuilder {
  static void register() {
    WidgetFactory.registerBuilder(
      'container', // El 'type' que usas en tu JSON para este widget
      buildWithParams,
    );
  }

  // Método estático para construir un widget Container desde JSON
  static Widget buildWithParams(
    BuildContext context,
    Map<String, dynamic> json, [
    Map<String, dynamic>? params,
  ]) {
// Primero, obtener el color
    Color? color = parseColor(json['color']);

    // Verificar si hay una decoración en el JSON
    BoxDecoration? decoration = json['decoration'] != null
        ? parseDecoration(json['decoration'])
        : null;

    return Container(
      key: json['key'] != null ? Key(json['key']) : null,
      alignment: parseAlignment(json['alignment']),
      padding: parseEdgeInsets(json['padding']),
      decoration: decoration ?? (color != null ? BoxDecoration(color: color) : null),
      foregroundDecoration: json['foregroundDecoration'] != null
          ? parseDecoration(json['foregroundDecoration'])
          : null,
      width: json['width']?.toDouble(),
      height: json['height']?.toDouble(),
      constraints: parseBoxConstraints(json['constraints']),
      margin: parseEdgeInsets(json['margin']),
      transform: parseTransform(json['transform']),
      transformAlignment: parseAlignment(json['transformAlignment']),
      child: json['child'] != null
          ? WidgetFactory.buildWidgetFromJson(context, json['child'] as Map<String, dynamic>)
          : null,
      clipBehavior: parseClipBehavior(json['clipBehavior']),
    );
  }


}




