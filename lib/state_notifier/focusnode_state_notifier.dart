

import 'package:flutter/widgets.dart';

class FocusNodeStateNotifier with ChangeNotifier {

  final Map<String, FocusNode> _nodes = {};

  FocusNode getOrCreateNode(
      String widgetId, {
        String? debugLabel,
        FocusOnKeyEventCallback? onKeyEvent,
        bool skipTraversal = false,
        bool canRequestFocus = true,
        bool descendantsAreFocusable = true,
      }) {
    if (_nodes.containsKey(widgetId)) {
      return _nodes[widgetId]!;
    }

    final newNode = FocusNode(
      debugLabel: debugLabel ?? widgetId,
      onKeyEvent: onKeyEvent,
      skipTraversal: skipTraversal,
      canRequestFocus: canRequestFocus,
      descendantsAreFocusable: descendantsAreFocusable,
    );
    _nodes[widgetId] = newNode;
    return newNode;
  }

  bool requestFocus(String widgetId) {
    if (_nodes.containsKey(widgetId)) {
      final node = _nodes[widgetId]!;
      if (node.canRequestFocus) {
        print("[FocusNotifier] Requesting focus for '$widgetId'");
        node.requestFocus();
        return true;
      } else {
        print("[FocusNotifier] Cannot request focus for '$widgetId' (canRequestFocus is false).");
        return false;
      }
    } else {
      print("[FocusNotifier] FocusNode '$widgetId' not found during requestFocus.");
      return false;
    }
  }

  void unfocus(String widgetId, {UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    if (_nodes.containsKey(widgetId)) {
      final node = _nodes[widgetId]!;
      if (node.hasFocus) {
        print("️[FocusNotifier] Unfocusing '$widgetId'");
        node.unfocus(disposition: disposition);
      } else {
        print("[FocusNotifier] Attempted to unfocus '$widgetId', but it did not have focus.");
      }
    } else {
      print(" [FocusNotifier] FocusNode '$widgetId' not found during unfocus.");
    }
  }


  bool hasFocus(String widgetId) {
    return _nodes[widgetId]?.hasFocus ?? false;
  }

  void disposeNode(String widgetId) {
    if (_nodes.containsKey(widgetId)) {
      print("[FocusNotifier] Disposing FocusNode for '$widgetId'");
      try {
        _nodes[widgetId]?.dispose();
      } catch (e) {
        print("Error disposing FocusNode for '$widgetId': $e");
      }
      _nodes.remove(widgetId);
    }
  }

  @override
  void dispose() {
    print("[FocusNotifier] Disposing FocusNodeStateNotifier - Cleaning up all FocusNodes (${_nodes.length}).");
    _nodes.values.forEach((node) {
      try {
        node.dispose();
      } catch (e) {
        print("Error disposing FocusNode during notifier dispose: $e");
      }
    });
    _nodes.clear();
    super.dispose();
  }
}