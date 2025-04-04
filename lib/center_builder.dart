import 'package:flutter/cupertino.dart';
import 'package:frontend/widget_factory.dart';

Widget buildCenter(Map<String, dynamic> json) {
  return Center(
    child: json['child'] != null
        ? WidgetFactory.buildWidgetFromJson(json['child'])
        : null,
  );
}