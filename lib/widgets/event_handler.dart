import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../comm/sender.dart';
import '../comm/sender_impl.dart';
import '../state_notifier/navigator_state_notifier.dart';

class EventHandler {

  static void handleEvent({
    required BuildContext context,
    required String? widgetId,
    required String eventType,
    required Map<String, dynamic> eventConfig,
    dynamic eventValue,
  }) {
    final String? action = eventConfig['action'] as String?;

    print("⚡ [EventHandler] Handling event: type='$eventType', widgetId='$widgetId', action='$action', config='$eventConfig', value='$eventValue'");

    bool eventHandledByFlutter = _handleFlutterNavigationAction(
      context: context,
      action: action,
      eventConfig: eventConfig,
      widgetId: widgetId,
    );

    if (!eventHandledByFlutter) {
      _sendEventToRust(
        widgetId: widgetId,
        eventType: eventType,
        action: action,
        eventConfig: eventConfig,
        eventValue: eventValue,
      );
    }
  }

  static bool _handleFlutterNavigationAction({
    required BuildContext context,
    required String? action,
    required Map<String, dynamic> eventConfig,
    String? widgetId,
  }) {
    if (action == 'navigate') {
      final String? routeName = eventConfig['route'] as String?;
      if (routeName != null) {
        print(" FWD [EventHandler._nav] Navigating (main) to: $routeName");
        if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
          Navigator.pop(context); // Cierra el drawer
        }
        Navigator.pushReplacementNamed(context, routeName);
      } else {
        print("⚠️ [EventHandler._nav] Error: Action 'navigate' missing 'route' in config: $eventConfig (widget: $widgetId)");
      }
      return true;
    }

    if (action == 'nested_navigate') {
      final String? navigatorId = eventConfig['navigatorId'] as String?;
      final String? nestedRouteName = eventConfig['nestedRoute'] as String?;
      final dynamic arguments = eventConfig['arguments'];

      if (navigatorId != null && nestedRouteName != null) {
        try {
          final navigatorNotifier = context.read<NavigatorStateNotifier>();
          print(" FWD [EventHandler._nav] Navigating (nested): navigatorId='$navigatorId', route='$nestedRouteName'");
          navigatorNotifier.pushNamed(navigatorId, nestedRouteName, arguments: arguments);
        } catch (e) {
          print("[EventHandler._nav] Error during nested_navigate: $e. Config: $eventConfig (widget: $widgetId)");
        }
      } else {
        print("[EventHandler._nav] Error: Action 'nested_navigate' missing 'navigatorId' or 'nestedRoute'. Config: $eventConfig (widget: $widgetId)");
      }
      return true;
    }

    if (action == 'nested_pop') {
      final String? navigatorId = eventConfig['navigatorId'] as String?;
      if (navigatorId != null) {
        try {
          final navigatorNotifier = context.read<NavigatorStateNotifier>();
          print(" FWD [EventHandler._nav] Popping (nested): navigatorId='$navigatorId'");
          navigatorNotifier.pop(navigatorId);
        } catch (e) {
          print("[EventHandler._nav] Error during nested_pop: $e. Config: $eventConfig (widget: $widgetId)");
        }
      } else {
        print("[EventHandler._nav] Error: Action 'nested_pop' missing 'navigatorId'. Config: $eventConfig (widget: $widgetId)");
      }
      return true;
    }

    return false;
  }

  static void _sendEventToRust({
    required String? widgetId,
    required String eventType,
    required String? action,
    required Map<String, dynamic> eventConfig,
    dynamic eventValue,
  }) {

    if (action == null || action.isEmpty) {
      print("ℹ️ [EventHandler._rust] No 'action' defined for Rust for event type '$eventType' on widget '$widgetId'. Config: $eventConfig");
      if (eventType == 'onPressed' || eventType == 'onTap' || eventType == 'onSubmitted') {
        print("Warning: Interactive event '$eventType' for widget '$widgetId' has no 'action' defined for Rust communication.");
      }
      return;
    }

    final Map<String, dynamic> payloadToRust = {
      'action': action,
      'widgetId': widgetId,
      'eventType': eventType,
    };

    if (eventValue != null) {
      payloadToRust['value'] = eventValue;
    }

    eventConfig.forEach((key, value) {
      if (key != 'action' && key != 'route' && key != 'nestedRoute' && key != 'navigatorId' && key != 'arguments') {
        payloadToRust[key] = value;
      }
    });

    try {
      final String jsonStringToRust = jsonEncode(payloadToRust);
      final Sender sender = SenderImpl(); // Considera inyectar Sender si es posible
      print(" TO_RUST [EventHandler._rust] Sending JSON string: $jsonStringToRust");
      sender.send(jsonStringToRust);
    } catch (e) {
      print("[EventHandler._rust] Error encoding JSON or sending event to Rust: $e. Payload Map: $payloadToRust");
    }
  }
}
