
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextStateNotifier with ChangeNotifier {

  final Map<String, TextEditingController> _controllers = {};

  TextEditingController getOrCreateController(String widgetId, {String? initialValue}) {

    if (_controllers.containsKey(widgetId)) {
      return _controllers[widgetId]!;
    }
    final String textToUse = initialValue ?? '';
    final newController = TextEditingController(text: textToUse);
    _controllers[widgetId] = newController;
    return newController;
  }

  void updateControllerText(String widgetId, String newText) {
    if (_controllers.containsKey(widgetId)) {
      final controller = _controllers[widgetId]!;
      if (controller.text != newText) {
        controller.value = controller.value.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
            composing: TextRange.empty
        );
      }
    } else {
      print("[TextStateNotifier] Controller $widgetId not found during updateControllerText (value: '$newText'). Update ignored. Initial value will be set on creation.");
    }
  }

  void disposeController(String widgetId) {
    if (_controllers.containsKey(widgetId)) {
      try {
        _controllers[widgetId]?.dispose();
      } catch (e) {
        print("[TextStateNotifier] Error disposing controller for $widgetId: $e");
      }
      _controllers.remove(widgetId);
    }
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) {
      try {
        controller.dispose();
      } catch (e) {
        print("[TextStateNotifier] Error disposing controller during notifier dispose: $e");
      }
    });
    _controllers.clear();
    super.dispose();
  }
}