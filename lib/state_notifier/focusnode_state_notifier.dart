import 'package:flutter/material.dart'; // FocusNode y ChangeNotifier están aquí

/// Notificador enfocado exclusivamente en la gestión de FocusNodes
/// asociados a widgets mediante un [widgetId], manejando su ciclo de vida (creación y dispose).
/// Proporciona métodos para controlar el foco programáticamente desde la lógica
/// de la aplicación o en respuesta a acciones (por ejemplo, desde Rust).
class FocusNodeStateNotifier with ChangeNotifier {
  /// Almacena específicamente los FocusNodes, asociados por widgetId.
  final Map<String, FocusNode> _nodes = {};

  /// Obtiene un FocusNode existente para el [widgetId] dado,
  /// o crea uno nuevo si no existe.
  ///
  /// Se pueden pasar parámetros opcionales del constructor de FocusNode.
  FocusNode getOrCreateNode(
      String widgetId, {
        String? debugLabel,
        FocusOnKeyEventCallback? onKeyEvent, // Callback para eventos de teclado
        bool skipTraversal = false,        // Omitir en navegación por Tab
        bool canRequestFocus = true,       // Si puede recibir foco programáticamente
        bool descendantsAreFocusable = true, // Si los hijos pueden tener foco
      }) {
    // 1. Verificar si ya existe un nodo para este ID.
    if (_nodes.containsKey(widgetId)) {
      print("✔️ [FocusNotifier] Reusing existing FocusNode for '$widgetId'");
      return _nodes[widgetId]!;
    }

    // 2. Si no existe, crear uno nuevo con los parámetros proporcionados.
    print("✨ [FocusNotifier] Creating new FocusNode for '$widgetId'");
    final newNode = FocusNode(
      debugLabel: debugLabel ?? widgetId, // Usa ID como etiqueta por defecto
      onKeyEvent: onKeyEvent,
      skipTraversal: skipTraversal,
      canRequestFocus: canRequestFocus,
      descendantsAreFocusable: descendantsAreFocusable,
    );
    _nodes[widgetId] = newNode;

    // Opcional: Escuchar cambios de foco si el notifier necesita reaccionar
    // newNode.addListener(() {
    //   print("[FocusNotifier] Focus changed for '$widgetId': ${newNode.hasFocus}");
    //   // Podrías llamar a notifyListeners() si otros widgets dependen de este estado *a través del notifier*
    //   // aunque generalmente los widgets escuchan directamente al FocusNode.
    // });

    return newNode;
  }

  /// Solicita que el widget asociado al [widgetId] obtenga el foco.
  ///
  /// Devuelve `true` si se pudo solicitar el foco (no garantiza que lo reciba),
  /// `false` si el nodo no existe o tiene `canRequestFocus` en false.
  /// Útil para ser llamado desde la lógica de recepción de Rust o eventos de UI.
  bool requestFocus(String widgetId) {
    if (_nodes.containsKey(widgetId)) {
      final node = _nodes[widgetId]!;
      // Verifica si el nodo está configurado para poder solicitar foco
      if (node.canRequestFocus) {
        print("✏️ [FocusNotifier] Requesting focus for '$widgetId'");
        node.requestFocus();
        return true; // Indica que la solicitud se hizo
      } else {
        print("⚠️ [FocusNotifier] Cannot request focus for '$widgetId' (canRequestFocus is false).");
        return false;
      }
    } else {
      print("⚠️ [FocusNotifier] FocusNode '$widgetId' not found during requestFocus.");
      return false;
    }
  }

  /// Quita el foco del widget asociado al [widgetId], si lo tiene.
  void unfocus(String widgetId, {UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    if (_nodes.containsKey(widgetId)) {
      final node = _nodes[widgetId]!;
      // Solo tiene sentido quitar el foco si actualmente lo tiene
      if (node.hasFocus) {
        print("✏️ [FocusNotifier] Unfocusing '$widgetId'");
        node.unfocus(disposition: disposition);
      } else {
        print("ℹ️ [FocusNotifier] Attempted to unfocus '$widgetId', but it did not have focus.");
      }
    } else {
      print("⚠️ [FocusNotifier] FocusNode '$widgetId' not found during unfocus.");
    }
  }

  /// Devuelve `true` si el nodo asociado a [widgetId] existe y tiene el foco,
  /// `false` en caso contrario.
  bool hasFocus(String widgetId) {
    // El operador '?.' accede a 'hasFocus' solo si _nodes[widgetId] no es null,
    // y '?? false' devuelve false si el resultado es null (nodo no existe).
    return _nodes[widgetId]?.hasFocus ?? false;
  }

  /// Libera los recursos de un FocusNode específico y lo elimina del mapa.
  /// Es crucial llamar a esto cuando el widget asociado se elimina de la UI
  /// para prevenir fugas de memoria.
  void disposeNode(String widgetId) {
    if (_nodes.containsKey(widgetId)) {
      print("🗑️ [FocusNotifier] Disposing FocusNode for '$widgetId'");
      try {
        // Llama al dispose() del FocusNode para liberar sus listeners y recursos.
        _nodes[widgetId]?.dispose();
      } catch (e) {
        print("Error disposing FocusNode for '$widgetId': $e");
      }
      _nodes.remove(widgetId); // Elimina la referencia del mapa.
    }
  }

  /// Libera todos los recursos, llamando a dispose() en todos los
  /// FocusNodes gestionados. Se invoca cuando el notifier se elimina.
  @override
  void dispose() {
    print("🗑️ [FocusNotifier] Disposing FocusNodeStateNotifier - Cleaning up all FocusNodes (${_nodes.length}).");
    _nodes.values.forEach((node) {
      try {
        node.dispose();
      } catch (e) {
        print("Error disposing FocusNode during notifier dispose: $e");
      }
    });
    _nodes.clear(); // Limpia el mapa.
    super.dispose(); // Llama al dispose base de ChangeNotifier.
  }
}