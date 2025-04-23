import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/widget_factory.dart';

Widget buildElevatedButton(BuildContext context, Map<String, dynamic> json) {
  return PlatformElevatedButton(
    key: json.containsKey('key') ? Key(json['key']) : null,
    widgetKey: json.containsKey('widgetKey') ? Key(json['widgetKey']) : null,
    onPressed: json['onPressed'] == false ? null : () => print('ElevatedButton pressed'),
    onLongPress: json['onLongPress'] == true ? () => print('Long press') : null,
    child: json['child'] != null
        ? WidgetFactory.buildWidgetFromJson(context, json['child'])
        : const Text('Botón'),

    padding: json['padding'] != null
        ? EdgeInsets.all((json['padding'] as num).toDouble())
        : null,

    alignment: _parseAlignment(json['alignment']),

    color: json['color'] != null
        ? Color(int.parse(json['color'].replaceAll("#", "0xFF")))
        : null,

    material: (_, __) => MaterialElevatedButtonData(
      style: ElevatedButton.styleFrom(
        elevation: (json['elevation'] ?? 2).toDouble(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            (json['borderRadius'] ?? 8).toDouble(),
          ),
        ),
      ),
    ),

    cupertino: (_, __) => CupertinoElevatedButtonData(
      borderRadius: BorderRadius.circular(
        (json['borderRadius'] ?? 8).toDouble(),
      ),
    ),
  );
}

Alignment? _parseAlignment(String? align) {
  switch (align) {
    case 'center':
      return Alignment.center;
    case 'topLeft':
      return Alignment.topLeft;
    case 'topRight':
      return Alignment.topRight;
    case 'bottomLeft':
      return Alignment.bottomLeft;
    case 'bottomRight':
      return Alignment.bottomRight;
    default:
      return null;
  }
}
