import 'package:flutter/cupertino.dart';
import 'package:frontend/widget_factory.dart';

Widget buildCenter(BuildContext context, Map<String, dynamic> json) {
  return Center(
    child: json['child'] != null
        ? WidgetFactory.buildWidgetFromJson(context, json['child'])
        : null,
  );
}