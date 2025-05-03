import 'package:flutter/material.dart';

class ScrollStateNotifier with ChangeNotifier {

  final Map<String, ScrollController> _controllers = {};

  ScrollController getOrCreateController(String widgetId, {
        double initialScrollOffset = 0.0,
        bool keepScrollOffset = true,
        String? debugLabel,
      }) {

    if (_controllers.containsKey(widgetId)) {
      return _controllers[widgetId]!;
    }

    final newController = ScrollController(
      initialScrollOffset: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      debugLabel: debugLabel ?? widgetId,
    );
    _controllers[widgetId] = newController;
    return newController;
  }

  Future<void> scrollTo(String widgetId, double offset, {
        Duration duration = const Duration(milliseconds: 300),
        Curve curve = Curves.easeOut,
      }) async {

    if (_controllers.containsKey(widgetId)) {
      final controller = _controllers[widgetId]!;
      if (controller.hasClients) {
        try {
          await controller.animateTo(
            offset,
            duration: duration,
            curve: curve,
          );
        } catch (e) {
          print("[ScrollStateNotifier] Error during animateTo for '$widgetId': $e");
        }
      } else {
        print("[ScrollStateNotifier] Attempted to scroll '$widgetId', but ScrollController has no client attached.");
      }
    } else {
      print("[ScrollStateNotifier] ScrollController '$widgetId' not found during scrollTo command.");
    }
  }

  void jumpTo(String widgetId, double offset) {
    if (_controllers.containsKey(widgetId)) {
      final controller = _controllers[widgetId]!;
      if (controller.hasClients) {
        controller.jumpTo(offset);
      } else {
        print("[ScrollStateNotifier] Attempted to jump '$widgetId', but ScrollController has no client attached.");
      }
    } else {
      print("[ScrollStateNotifier] ScrollController '$widgetId' not found during jumpTo command.");
    }
  }

  void disposeController(String widgetId) {
    if (_controllers.containsKey(widgetId)) {
      try {
        _controllers[widgetId]?.dispose();
      } catch (e) {
        print("[ScrollStateNotifier] Error disposing ScrollController for '$widgetId': $e");
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
        print("[ScrollStateNotifier] Error disposing ScrollController during notifier dispose: $e");
      }
    });
    _controllers.clear();
    super.dispose();
  }
}