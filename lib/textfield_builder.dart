import 'package:flutter/material.dart';
import 'package:frontend/widget_factory.dart';

import 'action.dart';

Widget buildTextField(Map<String, dynamic> json) {
  final controllerKey = json['controller'];
  final placeholder = json['placeholder'] ?? '';
  final focusNode =
      WidgetFactory.getFocusNode(controllerKey); // Obtiene el focusNode

  return Builder(
    builder: (context) {
      return TextField(
        controller: controllerKey != null
            ? getTextController(controllerKey)
            : TextEditingController(),
        focusNode: focusNode,
        decoration: InputDecoration(hintText: placeholder),
        onChanged: (text) {
          if (json['onChanged'] != null) {
            handleAction(context, json['onChanged']);
          }
        },
        onSubmitted: (text) {
          if (json['onSubmitted'] != null) {
            handleAction(context, json['onSubmitted']);
          }
        },
      );
    },
  );
}

TextEditingController getTextController(String key) {
  Map<String, TextEditingController> textEditiongControlllers =
      WidgetFactory.getTextControllers();
  if (!textEditiongControlllers.containsKey(key)) {
    textEditiongControlllers[key] = TextEditingController();
  }
  return textEditiongControlllers[key]!;
}
