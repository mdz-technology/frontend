import 'package:flutter/material.dart';
import 'package:frontend/widgets/utils.dart';
import 'package:provider/provider.dart';
import '../../comm/sender.dart';
import '../../comm/sender_impl.dart';
import '../../widget_factory.dart';
import '../../state_notifier/focusnode_state_notifier.dart';

class MaterialListTileBuilder {
  static const String typeName = 'material.listtile';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  // Helper para construir los slots de widget (leading, title, etc.)
  static Widget? _buildWidgetSlot(
      BuildContext context, dynamic jsonValue, Map<String, dynamic>? params) {
    if (jsonValue != null && jsonValue is Map<String, dynamic>) {
      try {
        return WidgetFactory.buildWidgetFromJson(context, jsonValue, params);
      } catch (e) {
        print("Error building widget slot for ListTile: $e. JSON: $jsonValue");
        return null; // Retorna null si la construcción del slot falla
      }
    }
    return null; // Retorna null si el JSON no es un mapa válido
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    // 1. Extracción Segura
    final String? id = json['id'] as String?;
    final Map<String, dynamic> styles = json['styles'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> events = json['events'] as Map<String, dynamic>? ?? {};
    // children no se usa directamente, los slots se leen de properties

    // 2. Key
    final Key? key = id != null ? Key(id) : null;

    // 3. Construcción de Slots (Widgets anidados)
    final Widget? leadingWidget = _buildWidgetSlot(context, properties['leading'], params);
    final Widget? titleWidget = _buildWidgetSlot(context, properties['title'], params);
    final Widget? subtitleWidget = _buildWidgetSlot(context, properties['subtitle'], params);
    final Widget? trailingWidget = _buildWidgetSlot(context, properties['trailing'], params);

    // 4. Parseo de Propiedades y Estilos
    final bool isThreeLine = parseBool(properties['isThreeLine']) ?? false;
    final bool? dense = parseBool(properties['dense']); // Nullable
    final VisualDensity? visualDensity = parseVisualDensity(styles['visualDensity']); // parseVisualDensity existe
    final ShapeBorder? shape = parseShapeBorder(styles['shape']); // Necesita parseShapeBorder
    final ListTileStyle? style = parseListTileStyle(styles['style']); // Necesita parseListTileStyle
    final Color? selectedColor = parseColor(styles['selectedColor']);
    final Color? iconColor = parseColor(styles['iconColor']);
    final Color? textColor = parseColor(styles['textColor']);
    final TextStyle? titleTextStyle = parseTextStyle(styles['titleTextStyle']); // Necesita parseTextStyle
    final TextStyle? subtitleTextStyle = parseTextStyle(styles['subtitleTextStyle']);
    final TextStyle? leadingAndTrailingTextStyle = parseTextStyle(styles['leadingAndTrailingTextStyle']);
    final EdgeInsetsGeometry? contentPadding = parseEdgeInsets(styles['contentPadding']);
    final bool enabled = parseBool(properties['enabled']) ?? true;
    final MouseCursor? mouseCursor = parseMouseCursor(properties['mouseCursor']); // parseMouseCursor existe
    final bool selected = parseBool(properties['selected']) ?? false;
    final Color? focusColor = parseColor(styles['focusColor']);
    final Color? hoverColor = parseColor(styles['hoverColor']);
    final Color? splashColor = parseColor(styles['splashColor']);
    final focusStatenotifier = context.read<FocusNodeStateNotifier>();

    final FocusNode? focusNode = focusStatenotifier.getOrCreateNode(
      id!,
      // skipTraversal: skipTraversal, // Ejemplo
      // canRequestFocus: canRequestFocus // Ejemplo
    );
    final bool autofocus = parseBool(properties['autofocus']) ?? false;
    final Color? tileColor = parseColor(styles['tileColor']);
    final Color? selectedTileColor = parseColor(styles['selectedTileColor']);
    final bool? enableFeedback = parseBool(properties['enableFeedback']);
    final double? horizontalTitleGap = parseDouble(properties['horizontalTitleGap']);
    final double? minVerticalPadding = parseDouble(properties['minVerticalPadding']);
    final double? minLeadingWidth = parseDouble(properties['minLeadingWidth']);
    final double? minTileHeight = parseDouble(properties['minTileHeight']);
    final ListTileTitleAlignment? titleAlignment = parseListTileTitleAlignment(properties['titleAlignment']); // Necesita parser

    // 5. Manejo de Eventos
    final Sender sender = SenderImpl(); // O get via Provider

    VoidCallback? onTapCallback = events.containsKey('onTap')
        ? () {
      final eventConfig = events['onTap'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id,
          'eventType': 'onTap',
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
          // Puedes añadir más datos relevantes del ListTile si es necesario
        };
        print('Sending event: $payload');
        sender.send(payload['action']);
      }
    }
        : null;

    VoidCallback? onLongPressCallback = events.containsKey('onLongPress')
        ? () {
      final eventConfig = events['onLongPress'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id,
          'eventType': 'onLongPress',
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
        };
        print('Sending event: $payload');
        sender.send(payload['action']);
      }
    }
        : null;

    ValueChanged<bool>? onFocusChangeCallback = events.containsKey('onFocusChange')
        ? (hasFocus) {
      final eventConfig = events['onFocusChange'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id,
          'eventType': 'onFocusChange',
          'hasFocus': hasFocus, // Incluye el estado del foco
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
        };
        print('Sending event: $payload');
        sender.send(payload['action']);
      }
    }
        : null;


    // 6. Construcción del Widget ListTile
    return ListTile(
      key: key,
      leading: leadingWidget,
      title: titleWidget,
      subtitle: subtitleWidget,
      trailing: trailingWidget,
      isThreeLine: isThreeLine,
      dense: dense,
      visualDensity: visualDensity,
      shape: shape,
      style: style,
      selectedColor: selectedColor,
      iconColor: iconColor,
      textColor: textColor,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      leadingAndTrailingTextStyle: leadingAndTrailingTextStyle,
      contentPadding: contentPadding,
      enabled: enabled,
      onTap: onTapCallback,
      onLongPress: onLongPressCallback,
      onFocusChange: onFocusChangeCallback,
      mouseCursor: mouseCursor,
      selected: selected,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      focusNode: focusNode,
      autofocus: autofocus,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      enableFeedback: enableFeedback,
      horizontalTitleGap: horizontalTitleGap,
      minVerticalPadding: minVerticalPadding,
      minLeadingWidth: minLeadingWidth,
      minTileHeight: minTileHeight,
      titleAlignment: titleAlignment,
      // internalAddSemanticForOnTap: true, // Dejar el default de Flutter
    );
  }
}

