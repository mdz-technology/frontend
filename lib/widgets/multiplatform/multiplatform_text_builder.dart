import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/utils.dart';
import 'package:provider/provider.dart';

import '../../state_notifier/widget_state_notifier.dart';

class MultiplatformTextBuilder {

  static const String typeName = 'multiplatform.text';
  
  static void register() {
    WidgetFactory.registerBuilder(
      typeName,
      buildWithParams,
    );
  }

  static Widget buildWithParams(BuildContext context,
      Map<String, dynamic> json,
      [ Map<String, dynamic>? params]) {
    final String? id = json['id']?.toString();

    final notifier = context.watch<WidgetStateNotifier>();

    final String dataFromJson = json['data']?.toString() ?? 'Texto por defecto';

    String? stateData;
    if (id != null && id.isNotEmpty) {
      try {
        final dynamic rawState = notifier.getState(id);
        if (rawState is String) {
          stateData = rawState;
        } else if (rawState != null) {
          print("[TextBuilder] State for widget '$id' exists but is not a String (${rawState.runtimeType}). Using JSON data.");
        }
      } catch (e) {
        print(" Error accessing state for Text widget '$id': $e. Using JSON data.");
      }
    }

    final String actualData = stateData ?? dataFromJson;

    final Map<String, dynamic> styleJson = Map<String, dynamic>.from(json['style'] as Map? ?? {});
    final TextStyle textStyle = _buildTextStyle(styleJson);

    final TextAlign textAlign = parseTextAlign(json['textAlign']?.toString());
    final TextOverflow textOverflow = parseTextOverflow(json['overflow']?.toString());
    final int? maxLines = parseInt(json['maxLines']);
    final bool? softWrap = json['softWrap'] as bool?;
    final String? semanticsLabel = json['semanticsLabel']?.toString();
    final TextDirection? textDirection = parseTextDirection(json['textDirection']?.toString());
    final Locale? locale = parseLocale(json['locale']?.toString());
    final double? textScaleFactor = parseDouble(json['textScaleFactor']);
    final TextWidthBasis? textWidthBasis = parseTextWidthBasis(json['textWidthBasis']?.toString());
    final TextHeightBehavior? textHeightBehavior = parseTextHeightBehavior(json['textHeightBehavior'] as Map?);
    final Color? selectionColor = parseColor(json['selectionColor']?.toString());

    return Text(
      actualData,
      key: id != null ? Key(id) : null,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLines,
      softWrap: softWrap,
      semanticsLabel: semanticsLabel,
      textDirection: textDirection,
      locale: locale,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      style: textStyle,
    );
  }


  static TextStyle _buildTextStyle(Map<String, dynamic> styleJson) {
    final Color defaultColor = Color(0xFF000000);

    final double? fontSize = parseDouble(styleJson['fontSize']);
    final Color color = parseColor(styleJson['color']?.toString()) ?? defaultColor;
    final FontWeight fontWeight = parseFontWeight(styleJson['fontWeight']?.toString());
    final FontStyle fontStyle = parseFontStyle(styleJson['fontStyle']?.toString());
    final double? letterSpacing = parseDouble(styleJson['letterSpacing']);
    final double? wordSpacing = parseDouble(styleJson['wordSpacing']);
    final TextDecoration? textDecoration = parseTextDecoration(styleJson['decoration']?.toString());
    final Color? decorationColor = parseColor(styleJson['decorationColor']?.toString());
    final double? decorationThickness = parseDouble(styleJson['decorationThickness']);
    final List<Shadow>? shadows = parseShadows(styleJson['shadows'] as List?);

    return TextStyle(
      fontSize: fontSize ?? 16.0,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: textDecoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      shadows: shadows,
    );
  }

}