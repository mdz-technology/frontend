import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';

Widget? buildPreferredSizeWidget(BuildContext context, Map<String, dynamic> json) {
  final widget = WidgetFactory.buildWidgetFromJson(context, json);
  if (widget is PreferredSizeWidget) {
    return widget;
  } else {
    throw Exception('El widget generado no es un PreferredSizeWidget.');
  }
}
