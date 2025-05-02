import 'package:flutter/material.dart';

class ScrollStateNotifier with ChangeNotifier {

  final Map<String, ScrollController> _controllers = {};

  ScrollController getOrCreateController(
      String widgetId, {
        double initialScrollOffset = 0.0,
        bool keepScrollOffset = true,
        String? debugLabel,
      }) {
    if (_controllers.containsKey(widgetId)) {
      print("✔️ [ScrollNotifier] Reusing existing ScrollController for '$widgetId'");
      return _controllers[widgetId]!;
    }

    print("✨ [ScrollNotifier] Creating new ScrollController for '$widgetId' (initialOffset: $initialScrollOffset)");
    final newController = ScrollController(
      initialScrollOffset: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      debugLabel: debugLabel ?? widgetId, // Usa el ID como etiqueta por defecto
    );
    _controllers[widgetId] = newController;
    return newController;
  }

  Future<void> scrollTo(
      String widgetId,
      double offset, {
        Duration duration = const Duration(milliseconds: 300), // Duración por defecto de la animación
        Curve curve = Curves.easeOut, // Curva de animación por defecto
      }) async { // async para usar await si animateTo lo soporta en futuras versiones o por consistencia
    if (_controllers.containsKey(widgetId)) {
      final controller = _controllers[widgetId]!;
      // Es crucial verificar si el controller está actualmente "adjunto" a un ScrollView
      if (controller.hasClients) {
        print("✏️ [ScrollNotifier] Animating scroll for '$widgetId' to offset: $offset");
        try {
          await controller.animateTo( // await asegura que la animación se complete si es necesario esperar
            offset,
            duration: duration,
            curve: curve,
          );
        } catch (e) {
          print("Error during animateTo for '$widgetId': $e");
          // Podría ocurrir si el cliente se desadjunta durante la animación
        }
      } else {
        print("⚠️ [ScrollNotifier] Attempted to scroll '$widgetId', but ScrollController has no client attached.");
        // Opcional: Guardar el offset deseado para aplicarlo cuando se adjunte.
        // Esto añade complejidad (necesitarías un listener en el controller).
      }
    } else {
      print("⚠️ [ScrollNotifier] ScrollController '$widgetId' not found during scrollTo command.");
    }
  }

  void jumpTo(String widgetId, double offset) {
    if (_controllers.containsKey(widgetId)) {
      final controller = _controllers[widgetId]!;
      if (controller.hasClients) {
        print("✏️ [ScrollNotifier] Jumping '$widgetId' to offset: $offset");
        controller.jumpTo(offset);
      } else {
        print("⚠️ [ScrollNotifier] Attempted to jump '$widgetId', but ScrollController has no client attached.");
      }
    } else {
      print("⚠️ [ScrollNotifier] ScrollController '$widgetId' not found during jumpTo command.");
    }
  }

  void disposeController(String widgetId) {
    if (_controllers.containsKey(widgetId)) {
      print("🗑️ [ScrollNotifier] Disposing ScrollController for '$widgetId'");
      try {
        // Llama al dispose() del ScrollController para liberar sus recursos internos.
        _controllers[widgetId]?.dispose();
      } catch (e) {
        // Captura errores que podrían ocurrir si se llama a dispose múltiples veces, etc.
        print("Error disposing ScrollController for '$widgetId': $e");
      }
      _controllers.remove(widgetId); // Elimina la referencia del mapa.
    }
  }

  @override
  void dispose() {
    print("🗑️ [ScrollNotifier] Disposing ScrollStateNotifier - Cleaning up all ScrollControllers (${_controllers.length}).");
    _controllers.values.forEach((controller) {
      try {
        controller.dispose();
      } catch (e) {
        print("Error disposing ScrollController during notifier dispose: $e");
      }
    });
    _controllers.clear(); // Limpia el mapa después de disponerlos.
    super.dispose(); // Llama al dispose base de ChangeNotifier.
  }
}