import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetStateNotifier with ChangeNotifier {
  // Estado centralizado donde cada widget puede tener su propio estado
  final Map<String, dynamic> _states = {};

  // Getter para obtener el estado de un widget dado
  dynamic getState(String widgetId) => _states[widgetId];

  // Setter para actualizar el estado de un widget específico
  void updateState(String widgetId, dynamic newState) {
    _states[widgetId] = newState;
    notifyListeners(); // Notificar a los oyentes de que el estado ha cambiado
  }

  /*List<Widget> getWidgetListState(String widgetId) {
    final state = _states[widgetId];
    return state is List<Widget> ? List<Widget>.from(state) : [];
  }

  bool getBoolState(String widgetId) {
    final state = _states[widgetId];
    return state is bool ? state : false;
  }

  int getIntState(String widgetId) {
    final state = _states[widgetId];
    return state is int ? state : 0;
  }*/

  // Si el estado es un mapa, se podría usar para manejar configuraciones complejas
  /*Map<String, dynamic> getMapState(String widgetId) {
    final state = _states[widgetId];
    return state is Map<String, dynamic> ? Map<String, dynamic>.from(state) : {};
  }*/

  // Método que genera datos de prueba para simular la actualización del estado


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


// Puedes agregar más funciones para manejar otros tipos de estado si es necesario
}