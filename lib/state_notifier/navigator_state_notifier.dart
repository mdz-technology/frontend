import 'package:flutter/material.dart';

class NavigatorStateNotifier with ChangeNotifier {
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {};

  GlobalKey<NavigatorState> getOrCreateNavigatorKey(String navigatorId) {
    if (!_navigatorKeys.containsKey(navigatorId)) {
      _navigatorKeys[navigatorId] = GlobalKey<NavigatorState>();
    } else {
      print("[NavigatorNotifier] Reusing existing GlobalKey<NavigatorState> for '$navigatorId'");
    }
    return _navigatorKeys[navigatorId]!;
  }

  void pushNamed(String navigatorId, String routeName, {Object? arguments}) {
    final key = _navigatorKeys[navigatorId];
    if (key != null && key.currentState != null) {
      key.currentState!.pushNamed(routeName, arguments: arguments);
    } else {
      print("[NavigatorNotifier] Navigator '$navigatorId' not found or has no state during pushNamed.");
    }
  }

  void pop(String navigatorId, [dynamic result]) {
    final key = _navigatorKeys[navigatorId];
    if (key != null && key.currentState != null) {
      if (key.currentState!.canPop()) {
        key.currentState!.pop(result);
      } else {
        print("[NavigatorNotifier] Navigator '$navigatorId' cannot pop.");
      }
    } else {
      print("[NavigatorNotifier] Navigator '$navigatorId' not found or has no state during pop.");
    }
  }

  void disposeNavigatorKey(String navigatorId) {
    if (_navigatorKeys.containsKey(navigatorId)) {
      print("[NavigatorNotifier] Disposing GlobalKey for '$navigatorId'");
      _navigatorKeys.remove(navigatorId);
    }
  }

  @override
  void dispose() {
    print("[NavigatorNotifier] Disposing NavigatorStateNotifier.");
    _navigatorKeys.clear();
    super.dispose();
  }

}