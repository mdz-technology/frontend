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

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    final String? id = json['id'] as String?;
    final Map<String, dynamic> styles = json['styles'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> events = json['events'] as Map<String, dynamic>? ?? {};

    final Key? key = id != null ? Key(id) : null;

    final Widget? leadingWidget = _buildWidgetSlot(context, properties['leading'], params);
    final Widget? titleWidget = _buildWidgetSlot(context, properties['title'], params);
    final Widget? subtitleWidget = _buildWidgetSlot(context, properties['subtitle'], params);
    final Widget? trailingWidget = _buildWidgetSlot(context, properties['trailing'], params);

    final bool isThreeLine = parseBool(properties['isThreeLine']) ?? false;
    final bool? dense = parseBool(properties['dense']);
    final VisualDensity? visualDensity = parseVisualDensity(styles['visualDensity']);
    final ShapeBorder? shape = parseShapeBorder(styles['shape']);
    final ListTileStyle? style = parseListTileStyle(styles['style']);
    final Color? selectedColor = parseColor(styles['selectedColor']);
    final Color? iconColor = parseColor(styles['iconColor']);
    final Color? textColor = parseColor(styles['textColor']);
    final TextStyle? titleTextStyle = parseTextStyle(styles['titleTextStyle']);
    final TextStyle? subtitleTextStyle = parseTextStyle(styles['subtitleTextStyle']);
    final TextStyle? leadingAndTrailingTextStyle = parseTextStyle(styles['leadingAndTrailingTextStyle']);
    final EdgeInsetsGeometry? contentPadding = parseEdgeInsets(styles['contentPadding']);
    final bool enabled = parseBool(properties['enabled']) ?? true;
    final MouseCursor? mouseCursor = parseMouseCursor(properties['mouseCursor']);
    final bool selected = parseBool(properties['selected']) ?? false;
    final Color? focusColor = parseColor(styles['focusColor']);
    final Color? hoverColor = parseColor(styles['hoverColor']);
    final Color? splashColor = parseColor(styles['splashColor']);
    final focusStatenotifier = context.read<FocusNodeStateNotifier>();
    final FocusNode? focusNode = focusStatenotifier.getOrCreateNode(id!);
    final bool autofocus = parseBool(properties['autofocus']) ?? false;
    final Color? tileColor = parseColor(styles['tileColor']);
    final Color? selectedTileColor = parseColor(styles['selectedTileColor']);
    final bool? enableFeedback = parseBool(properties['enableFeedback']);
    final double? horizontalTitleGap = parseDouble(properties['horizontalTitleGap']);
    final double? minVerticalPadding = parseDouble(properties['minVerticalPadding']);
    final double? minLeadingWidth = parseDouble(properties['minLeadingWidth']);
    final double? minTileHeight = parseDouble(properties['minTileHeight']);
    final ListTileTitleAlignment? titleAlignment = parseListTileTitleAlignment(properties['titleAlignment']);

    final Sender sender = SenderImpl();

    VoidCallback? onTapCallback = events.containsKey('onTap') ? () {
      final eventConfig = events['onTap'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id,
          'eventType': 'onTap',
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
        };
        print('Sending event: $payload');
        sender.send(payload['action']);
      }
    } : null;

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
    } : null;

    ValueChanged<bool>? onFocusChangeCallback = events.containsKey('onFocusChange')
        ? (hasFocus) {
      final eventConfig = events['onFocusChange'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id,
          'eventType': 'onFocusChange',
          'hasFocus': hasFocus,
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
        };
        print('Sending event: $payload');
        sender.send(payload['action']);
      }
    } : null;

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
    );
  }

  static Widget? _buildWidgetSlot(
      BuildContext context,
      dynamic jsonValue,
      Map<String, dynamic>? params) {

    if (jsonValue != null && jsonValue is Map<String, dynamic>) {
      try {
        return WidgetFactory.buildWidgetFromJson(context, jsonValue, params);
      } catch (e) {
        print("Error building widget slot for ListTile: $e. JSON: $jsonValue");
        return null;
      }
    }
    return null;
  }
}

