import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';

Widget buildRow(BuildContext context, Map<String, dynamic> json) {
  return Row(
    mainAxisAlignment: parseMainAxisAlignment(json['mainAxisAlignment']),
    crossAxisAlignment: parseCrossAxisAlignment(json['crossAxisAlignment']),
    children: (json['children'] as List)
        .map((child) => WidgetFactory.buildWidgetFromJson(context, child))
        .toList(),
  );
}

MainAxisAlignment parseMainAxisAlignment(String? alignment) {
  switch (alignment) {
    case 'start':
      return MainAxisAlignment.start;
    case 'end':
      return MainAxisAlignment.end;
    case 'center':
      return MainAxisAlignment.center;
    case 'spaceBetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceAround':
      return MainAxisAlignment.spaceAround;
    case 'spaceEvenly':
      return MainAxisAlignment.spaceEvenly;
    default:
      return MainAxisAlignment.start; // Valor predeterminado
  }
}

CrossAxisAlignment parseCrossAxisAlignment(String? alignment) {
  switch (alignment) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'end':
      return CrossAxisAlignment.end;
    case 'center':
      return CrossAxisAlignment.center;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    case 'baseline':
      return CrossAxisAlignment.baseline;
    default:
      return CrossAxisAlignment.center; // Valor predeterminado
  }
}
