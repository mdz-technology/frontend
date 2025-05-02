import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:frontend/widgets/utils.dart';
import 'package:provider/provider.dart';

import '../../comm/sender.dart';
import '../../comm/sender_impl.dart';
import '../../state_notifier/text_state_notifier.dart';
import '../../widget_factory.dart';
import '../../state_notifier/focusnode_state_notifier.dart';

class MaterialTextFieldBuilder {

  static const String typeName = 'material.textfield';

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


    if (id == null || id.isEmpty) {
      print("Error: TextFieldBuilder requiere un 'id' válido en el JSON.");
      return const Placeholder(color: Colors.red, child: Text("TextField requiere ID"));
    }
    final Key? key = Key(id);

    final textStatenotifier = context.read<TextStateNotifier>();
    final String? initialValueFromJson = parseString(properties['initialValue']);
    final controller = textStatenotifier.getOrCreateController(id, initialValue: initialValueFromJson);

    final focusStatenotifier = context.read<FocusNodeStateNotifier>();

    final FocusNode focusNode = focusStatenotifier.getOrCreateNode(
      id,
      // skipTraversal: skipTraversal, // Ejemplo
      // canRequestFocus: canRequestFocus // Ejemplo
    );
    final UndoHistoryController? undoController = null; // TODO: Manejar desde estado si es necesario
    final TextInputType? keyboardType = parseTextInputType(properties['keyboardType']);
    final TextInputAction? textInputAction = parseTextInputAction(properties['textInputAction']);
    final TextCapitalization textCapitalization = parseTextCapitalization(properties['textCapitalization']) ?? TextCapitalization.none;
    final TextStyle? style = parseTextStyle(styles['style']);
    final StrutStyle? strutStyle = null;
    final TextAlign textAlign = parseTextAlign(properties['textAlign']) ?? TextAlign.start;
    final TextAlignVertical? textAlignVertical = parseTextAlignVertical(properties['textAlignVertical']);
    final TextDirection? textDirection = parseTextDirection(properties['textDirection']);
    final bool readOnly = parseBool(properties['readOnly']) ?? false;
    final bool? showCursor = parseBool(properties['showCursor']);
    final bool autofocus = parseBool(properties['autofocus']) ?? false;
    final String obscuringCharacter = parseString(properties['obscuringCharacter']) ?? '•';
    final bool obscureText = parseBool(properties['obscureText']) ?? false;
    final bool autocorrect = parseBool(properties['autocorrect']) ?? true;
    final SmartDashesType? smartDashesType = parseSmartDashesType(properties['smartDashesType']);
    final SmartQuotesType? smartQuotesType = parseSmartQuotesType(properties['smartQuotesType']);
    final bool enableSuggestions = parseBool(properties['enableSuggestions']) ?? true;
    final int? maxLines = obscureText ? 1 : parseInt(properties['maxLines']) ?? 1;
    final int? minLines = parseInt(properties['minLines']);
    final bool expands = parseBool(properties['expands']) ?? false;
    final int? maxLength = parseInt(properties['maxLength']);
    final MaxLengthEnforcement? maxLengthEnforcement = parseMaxLengthEnforcement(properties['maxLengthEnforcement']);
    final bool? enabled = parseBool(properties['enabled']);
    final bool? ignorePointers = parseBool(properties['ignorePointers']);
    final double cursorWidth = parseDouble(properties['cursorWidth']) ?? 2.0;
    final double? cursorHeight = parseDouble(properties['cursorHeight']);
    final Radius? cursorRadius = parseRadius(properties['cursorRadius']);
    final bool? cursorOpacityAnimates = parseBool(properties['cursorOpacityAnimates']);
    final Color? cursorColor = parseColor(styles['cursorColor']);
    final Color? cursorErrorColor = parseColor(styles['cursorErrorColor']);
    final ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight;
    final ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight;
    final Brightness? keyboardAppearance = parseKeyboardAppearance(styles['keyboardAppearance']);
    final EdgeInsets scrollPadding = parseEdgeInsets(styles['scrollPadding']) ?? const EdgeInsets.all(20.0);
    final DragStartBehavior dragStartBehavior = parseDragStartBehavior(properties['dragStartBehavior']) ?? DragStartBehavior.start;
    final bool? enableInteractiveSelection = parseBool(properties['enableInteractiveSelection']);
    final TextSelectionControls? selectionControls = null;
    final MouseCursor? mouseCursor = parseMouseCursor(properties['mouseCursor']);
    final InputCounterWidgetBuilder? buildCounter = null;
    final ScrollController? scrollController = null;
    final ScrollPhysics? scrollPhysics = parseScrollPhysics(styles['scrollPhysics']);
    final Iterable<String>? autofillHints = (properties['autofillHints'] as List<dynamic>?)?.map((e) => e.toString()).toList();
    final Clip clipBehavior = parseClipBehavior(styles['clipBehavior']) ?? Clip.hardEdge;
    final String? restorationId = properties['restorationId'] as String?;
    final bool stylusHandwritingEnabled = parseBool(properties['stylusHandwritingEnabled']) ?? EditableText.defaultStylusHandwritingEnabled;
    final bool enableIMEPersonalizedLearning = parseBool(properties['enableIMEPersonalizedLearning']) ?? true;
    final bool canRequestFocus = parseBool(properties['canRequestFocus']) ?? true;
    final List<TextInputFormatter>? inputFormatters = null; // TODO

    final InputDecoration decoration = parseInputDecoration(
        styles['decoration'] as Map<String, dynamic>?, context, params
    ) ?? const InputDecoration();

    final Sender sender = SenderImpl();

    ValueChanged<String>? onChangedCallback = events.containsKey('onChanged')
        ? (value) {
      final eventConfig = events['onChanged'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      // Opcional: Actualizar estado local inmediatamente si es necesario para otros widgets
      // notifier.updateState(id + '_lastValue', value); // Podría ser redundante si el controller ya lo hace
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id, // Usar el ID validado
          'value': value,
          'eventType': 'onChanged',
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
        };
        print('Sending event: $payload');
        sender.send(payload['value']);
      }
    }
        : null;

    VoidCallback? onEditingCompleteCallback = events.containsKey('onEditingComplete')
        ? () {
      final eventConfig = events['onEditingComplete'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id, // Usar el ID validado
          'value': controller.text, // Valor actual del controller
          'eventType': 'onEditingComplete',
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
        };
        print('Sending event: $payload');
        sender.send(payload['value']);
      }
    }
        : null;

    ValueChanged<String>? onSubmittedCallback = events.containsKey('onSubmitted')
        ? (value) {
      final eventConfig = events['onSubmitted'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id,
          'value': value,
          'eventType': 'onSubmitted',
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
        };
        print('Sending event: $payload');
        sender.send(payload['value']);
      }
    }
        : null;

    VoidCallback? onTapCallback = events.containsKey('onTap')
        ? () {
      final eventConfig = events['onTap'] as Map<String, dynamic>? ?? {};
      final String? action = eventConfig['action'] as String?;
      if (action != null) {
        final payload = {
          'action': action,
          'widgetId': id, // Usar el ID validado
          'eventType': 'onTap',
          if (eventConfig.containsKey('message')) 'message': eventConfig['message'],
        };
        print('Sending event: $payload');
        sender.send(payload['value']);
      }
    }
        : null;

    return TextField(
      key: key, // Usa la key con el ID
      controller: controller, // Usa el controller del Notifier
      focusNode: focusNode,
      undoController: undoController,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChangedCallback,
      onEditingComplete: onEditingCompleteCallback,
      onSubmitted: onSubmittedCallback,
      inputFormatters: inputFormatters,
      enabled: enabled,
      ignorePointers: ignorePointers,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorOpacityAnimates: cursorOpacityAnimates,
      cursorColor: cursorColor,
      cursorErrorColor: cursorErrorColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTap: onTapCallback,
      mouseCursor: mouseCursor,
      buildCounter: buildCounter,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      canRequestFocus: canRequestFocus,
    );
  }

}
