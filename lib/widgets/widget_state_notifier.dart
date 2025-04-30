import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetStateNotifier with ChangeNotifier {
  final Map<String, dynamic> _states = {};

  dynamic getState(String widgetId) => _states[widgetId];

  void updateState(String widgetId, dynamic newState) {
    _states[widgetId] = newState;
    notifyListeners();
  }

  void generateTestData(String widgetId) {
    int counter = 1;

    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (widgetId == "lista_dinamica_1") {

        // Obtener el estado actual
        final currentList = _states[widgetId] as List<Widget>? ?? [];
        // Alternate between Text and Card
        Widget newItem;
        final Random random = Random();
        if (random.nextBool()) {
          newItem = Text("Texto simple ${counter++}");
        } else {
          newItem = Card(
            elevation: 3,
            color: Colors.blue[100],
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Tarjeta ${counter++}", style: TextStyle(fontSize: 16)),
            ),
          );
        }

        final updatedList = List<Widget>.from(currentList)..add(newItem);
        updateState(widgetId, updatedList);

      } else if (widgetId == "textWidget") {
        String newText = "Texto actualizado en ${DateTime.now()}";
        updateState(widgetId, newText);
      }
    });
  }

}