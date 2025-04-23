import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';

Widget buildColumn(BuildContext context, Map<String, dynamic> json) {
  return Column(
    mainAxisAlignment: _parseMainAxisAlignment(json['mainAxisAlignment']),
    mainAxisSize: _parseMainAxisSize(json['mainAxisSize']),
    crossAxisAlignment: _parseCrossAxisAlignment(json['crossAxisAlignment']),
    textDirection: _parseTextDirection(json['textDirection']),
    verticalDirection: _parseVerticalDirection(json['verticalDirection']),
    textBaseline: _parseTextBaseline(json['textBaseline']),
    children: _buildChildren(context, json['children']),
  );
}

List<Widget> _buildChildren(BuildContext context, List<dynamic>? childrenJson) {
  if (childrenJson == null) return [];

  return childrenJson.map<Widget>((childJson) {
    if (childJson is Map<String, dynamic>) {
      return WidgetFactory.buildWidgetFromJson(context, childJson);
    } else {
      return SizedBox.shrink(); // fallback si el elemento no es válido
    }
  }).toList();
}

MainAxisAlignment _parseMainAxisAlignment(String? value) {
  switch (value) {
    case 'start':
      return MainAxisAlignment.start;
    case 'center':
      return MainAxisAlignment.center;
    case 'end':
      return MainAxisAlignment.end;
    case 'spaceBetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceAround':
      return MainAxisAlignment.spaceAround;
    case 'spaceEvenly':
      return MainAxisAlignment.spaceEvenly;
    default:
      return MainAxisAlignment.start;
  }
}

MainAxisSize _parseMainAxisSize(String? value) {
  switch (value) {
    case 'max':
      return MainAxisSize.max;
    case 'min':
      return MainAxisSize.min;
    default:
      return MainAxisSize.max;
  }
}

CrossAxisAlignment _parseCrossAxisAlignment(String? value) {
  switch (value) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'center':
      return CrossAxisAlignment.center;
    case 'end':
      return CrossAxisAlignment.end;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    case 'baseline':
      return CrossAxisAlignment.baseline;
    default:
      return CrossAxisAlignment.center;
  }
}

TextDirection? _parseTextDirection(String? value) {
  switch (value) {
    case 'ltr':
      return TextDirection.ltr;
    case 'rtl':
      return TextDirection.rtl;
    default:
      return null;
  }
}

VerticalDirection _parseVerticalDirection(String? value) {
  switch (value) {
    case 'up':
      return VerticalDirection.up;
    case 'down':
      return VerticalDirection.down;
    default:
      return VerticalDirection.down;
  }
}

TextBaseline? _parseTextBaseline(String? value) {
  switch (value) {
    case 'alphabetic':
      return TextBaseline.alphabetic;
    case 'ideographic':
      return TextBaseline.ideographic;
    default:
      return null;
  }
}