import 'package:flutter/foundation.dart'; // Para ChangeNotifier

class WidgetStateNotifier with ChangeNotifier {

  final Map<String, dynamic> _states = {};

  dynamic getState(String widgetId) {
    return _states[widgetId];
  }

  void updateState(String widgetId, dynamic newState) {
    print("[Notifier] Update State for '$widgetId': $newState");
    _states[widgetId] = newState;
    notifyListeners();
  }

  void removeState(String widgetId) {
    print("[Notifier] Remove State for '$widgetId'");
    if (_states.containsKey(widgetId)) {
      _states.remove(widgetId);
    }
  }

  void clearAllStates() {
    print("[Notifier] Clear All States");
    _states.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    print("[Notifier] Dispose WidgetStateNotifier (Simple Version)");
    _states.clear(); // Simplemente limpia el mapa
    super.dispose(); // Llama al dispose de ChangeNotifier
  }
}