import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';

Widget buildPadding(BuildContext context, Map<String, dynamic> json) {
  final padding = json['padding'];
  EdgeInsets edgeInsets = EdgeInsets.all(0);

  if (padding != null) {
    edgeInsets = EdgeInsets.all(padding['all']?.toDouble() ?? 0);
  }

  return Padding(
    padding: edgeInsets,
    child: json['child'] != null
        ? WidgetFactory.buildWidgetFromJson(context, json['child'])
        : null,
  );
}
