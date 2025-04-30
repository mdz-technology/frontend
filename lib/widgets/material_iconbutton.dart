import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils.dart';

import '../comm/sender.dart';
import '../comm/sender_impl.dart';
import '../widget_factory.dart';

class IconButtonBuilder {

  static const String typeName = 'material.iconbutton';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(BuildContext context,
      Map<String, dynamic> json,
      [Map<String, dynamic>? params]) {

    final String? id = json['id'] as String?;
    final Map<String, dynamic> styles = json['styles'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> events = json['events'] as Map<String, dynamic>? ?? {};
    final List<dynamic> children = json['children'] as List<dynamic>? ?? [];

    final Key? key = id != null ? Key(id) : null;

    final double? iconSize = parseDouble(properties['iconSize']);
    final VisualDensity? visualDensity = parseVisualDensity(styles['visualDensity']);
    final EdgeInsetsGeometry? padding = parseEdgeInsets(styles['padding']) ?? const EdgeInsets.all(8.0);
    final AlignmentGeometry alignment = parseAlignment(properties['alignment']) ?? Alignment.center;
    final double? splashRadius = parseDouble(properties['splashRadius']);
    final Color? color = parseColor(styles['color']);
    final Color? focusColor = parseColor(styles['focusColor']);
    final Color? hoverColor = parseColor(styles['hoverColor']);
    final Color? highlightColor = parseColor(styles['highlightColor']);
    final Color? splashColor = parseColor(styles['splashColor']);
    final Color? disabledColor = parseColor(styles['disabledColor']);
    final MouseCursor? mouseCursor = parseMouseCursor(properties['mouseCursor']);
    final bool autofocus = parseBool(properties['autofocus']) ?? false;
    final String? tooltip = parseString(properties['tooltip']);
    final bool? enableFeedback = parseBool(properties['enableFeedback']);
    final BoxConstraints? constraints = parseBoxConstraints(properties['constraints']);
    final ButtonStyle? style = parseButtonStyle(styles['style']);
    final bool? isSelected = parseBool(properties['isSelected']);
    final bool enabled = parseBool(properties['enabled']) ?? true;

    Widget? iconWidget;
    if (children.isNotEmpty && children.first is Map<String, dynamic>) {
      iconWidget = WidgetFactory.buildWidgetFromJson(
        context,
        children.first as Map<String, dynamic>,
        params,
      );
    } else {
      print("Error: IconButton con id '$id' requiere un 'icon' definido en 'children'.");
      iconWidget = const Icon(Icons.error, color: Colors.red, size: 24.0);
    }


    Widget? selectedIconWidget;
    final dynamic selectedIconJson = properties['selectedIconJson'];
    if (selectedIconJson != null && selectedIconJson is Map<String, dynamic>) {
      selectedIconWidget = WidgetFactory.buildWidgetFromJson(
        context,
        selectedIconJson,
        params,
      );
    }

    VoidCallback? onPressedCallback;
    final dynamic onPressedEventConfig = events['onPressed'];

    if (enabled) {
      if (onPressedEventConfig != null && onPressedEventConfig is Map<String, dynamic>) {

        onPressedCallback = () {
          final Sender sender = SenderImpl();
          final String? action = onPressedEventConfig['action'] as String?;
          String? message = onPressedEventConfig['message'] as String?;
          String? targetWidgetId = onPressedEventConfig['widgetId'] as String?;

          if (targetWidgetId == '{id}' && id != null) targetWidgetId = id;

          final Map<String, dynamic> payload = {
            if (action != null) 'action': action,
            if (message != null) 'message': message,
            if (targetWidgetId != null) 'widgetId': targetWidgetId,
            'eventType': 'onPressed',
            'sourceId': id,
          };
          if (payload.containsKey('action')) {
            print('Sending event: $payload');
            sender.send(payload['message']);
          } else {
            print('Warning: onPressed event for widget $id has no action defined.');
          }
        };
      } else {
        onPressedCallback = () {
          print("IconButton '$id' pressed, but no 'onPressed' action defined in JSON.");
        };
      }
    } else {
      onPressedCallback = null;
    }

    return IconButton(
      key: key,
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      disabledColor: disabledColor,
      onPressed: onPressedCallback,
      mouseCursor: mouseCursor ?? (enabled ? SystemMouseCursors.click : SystemMouseCursors.basic),
      focusNode: null,
      autofocus: autofocus,
      tooltip: tooltip,
      enableFeedback: enableFeedback ?? true,
      constraints: constraints,
      style: style,
      isSelected: isSelected,
      selectedIcon: selectedIconWidget,
      icon: iconWidget,
    );
  }
}