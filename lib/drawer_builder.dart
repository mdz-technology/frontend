import 'package:flutter/material.dart';
import 'package:frontend/widget_factory.dart';

Widget buildDrawer(Map<String, dynamic> json) {
  return Drawer(
    child: json['child'] != null
        ? WidgetFactory.buildWidgetFromJson(json['child'])
        : null,
  );
}
