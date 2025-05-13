import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../state_notifier/widget_state_notifier.dart';
import '../../widget_factory.dart';
import '../utils.dart';

class MultiplatformTextBuilder {
  static const String typeName = 'multiplatform.text';

  static void register() {
    WidgetFactory.registerBuilder(
      typeName,
      buildWithParams,
    );
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {

    final String? id = json['id']?.toString();
    final Map<String, dynamic> jsonProperties = Map<String, dynamic>.from(json['properties'] as Map? ?? {});
    final Map<String, dynamic> jsonStyles = Map<String, dynamic>.from(json['styles'] as Map? ?? {});

    final Key? key = parseKey(id);

    final notifier = context.watch<WidgetStateNotifier>();
    Map<String, dynamic>? stateOverrides;

    if (id != null && id.isNotEmpty) {
        final dynamic rawState = notifier.getState(id);
        if (rawState is Map<String, dynamic>) {
          stateOverrides = rawState;
        } else if (rawState is String) { // Compatibilidad hacia atrás
          stateOverrides = {'data': rawState};
        }
    }
    stateOverrides ??= {};

    final String actualData = getResolvedProperty<String>(
      stateMap: stateOverrides, stateKey: 'data',
      jsonMap: jsonProperties, jsonKey: 'data',
      parser: (raw) => parseString(raw),
      defaultValue: 'Texto por defecto',
    )!;

    final TextAlign? textAlign = getResolvedProperty<TextAlign>(
      stateMap: stateOverrides, stateKey: 'textAlign',
      jsonMap: jsonProperties, jsonKey: 'textAlign',
      parser: (raw) => parseTextAlign(raw?.toString()),
    );

    final TextOverflow? textOverflow = getResolvedProperty<TextOverflow>(
      stateMap: stateOverrides, stateKey: 'overflow',
      jsonMap: jsonProperties, jsonKey: 'overflow',
      parser: (raw) => parseTextOverflow(raw?.toString()),
    );

    final int? maxLines = getResolvedProperty<int>(
      stateMap: stateOverrides, stateKey: 'maxLines',
      jsonMap: jsonProperties, jsonKey: 'maxLines',
      parser: (raw) => parseInt(raw),
    );

    final bool? softWrap = getResolvedProperty<bool>(
      stateMap: stateOverrides, stateKey: 'softWrap',
      jsonMap: jsonProperties, jsonKey: 'softWrap',
      parser: (raw) => parseBool(raw),
    );

    final String? semanticsLabel = getResolvedProperty<String>(
      stateMap: stateOverrides, stateKey: 'semanticsLabel',
      jsonMap: jsonProperties, jsonKey: 'semanticsLabel',
      parser: (raw) => parseString(raw),
    );

    final TextDirection? textDirection =  getResolvedProperty<TextDirection>(
      stateMap: stateOverrides, stateKey: 'textDirection',
      jsonMap: jsonProperties, jsonKey: 'textDirection',
      parser: (raw) => parseTextDirection(raw?.toString()),
    );

    final Locale? locale = getResolvedProperty<Locale>(
      stateMap: stateOverrides, stateKey: 'locale',
      jsonMap: jsonProperties, jsonKey: 'locale',
      parser: (raw) => parseLocale(raw),
    );

    final double? textScaleFactor = getResolvedProperty<double>(
      stateMap: stateOverrides, stateKey: 'textScaleFactor',
      jsonMap: jsonProperties, jsonKey: 'textScaleFactor',
      parser: (raw) => parseDouble(raw),
    );

    final TextWidthBasis? textWidthBasis = getResolvedProperty<TextWidthBasis>(
      stateMap: stateOverrides, stateKey: 'textWidthBasis',
      jsonMap: jsonProperties, jsonKey: 'textWidthBasis',
      parser: (raw) => parseTextWidthBasis(raw?.toString()),
    );

    final TextHeightBehavior? textHeightBehavior = getResolvedProperty<TextHeightBehavior>(
      stateMap: stateOverrides, stateKey: 'textHeightBehavior',
      jsonMap: jsonProperties, jsonKey: 'textHeightBehavior',
      parser: (raw) => parseTextHeightBehavior(raw),
    );

    final Color? selectionColor = getResolvedProperty<Color>(
      stateMap: stateOverrides, stateKey: 'selectionColor',
      jsonMap: jsonStyles, jsonKey: 'selectionColor',
      parser: (raw) => parseColor(raw?.toString()),
    );

    final TextStyle textStyle = _buildTextStyle(jsonStyles, stateOverrides);

    return Text(
      actualData,
      key: key,
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

  static TextStyle _buildTextStyle(Map<String, dynamic> jsonStyles, Map<String, dynamic> stateOverrides) {
    final Color defaultTextColor = Color(0xFF000000);

    final double? fontSize = getResolvedProperty<double>(
      stateMap: stateOverrides, stateKey: 'style_fontSize',
      jsonMap: jsonStyles, jsonKey: 'fontSize',
      parser: (raw) => parseDouble(raw),
    );
    final Color? color = getResolvedProperty<Color>(
      stateMap: stateOverrides, stateKey: 'style_color',
      jsonMap: jsonStyles, jsonKey: 'color',
      parser: (raw) => parseColor(raw?.toString()),
      defaultValue: defaultTextColor,
    );
    final FontWeight? fontWeight = getResolvedProperty<FontWeight>(
      stateMap: stateOverrides, stateKey: 'style_fontWeight',
      jsonMap: jsonStyles, jsonKey: 'fontWeight',
      parser: (raw) => parseFontWeight(raw?.toString()),
    );
    final FontStyle? fontStyle = getResolvedProperty<FontStyle>(
      stateMap: stateOverrides, stateKey: 'style_fontStyle',
      jsonMap: jsonStyles, jsonKey: 'fontStyle',
      parser: (raw) => parseFontStyle(raw?.toString()),
    );
    final double? letterSpacing = getResolvedProperty<double>(
      stateMap: stateOverrides, stateKey: 'style_letterSpacing',
      jsonMap: jsonStyles, jsonKey: 'letterSpacing',
      parser: (raw) => parseDouble(raw),
    );
    final double? wordSpacing = getResolvedProperty<double>(
      stateMap: stateOverrides, stateKey: 'style_wordSpacing',
      jsonMap: jsonStyles, jsonKey: 'wordSpacing',
      parser: (raw) => parseDouble(raw),
    );
    final TextDecoration? textDecoration = getResolvedProperty<TextDecoration>(
      stateMap: stateOverrides, stateKey: 'style_decoration',
      jsonMap: jsonStyles, jsonKey: 'decoration',
      parser: (raw) => parseTextDecoration(raw?.toString()),
    );
    final Color? decorationColor = getResolvedProperty<Color>(
      stateMap: stateOverrides, stateKey: 'style_decorationColor',
      jsonMap: jsonStyles, jsonKey: 'decorationColor',
      parser: (raw) => parseColor(raw?.toString()),
    );
    // final TextDecorationStyle? decorationStyle = parseTextDecorationStyle(styles['decorationStyle']); // Necesitarías este parser
    final double? decorationThickness = getResolvedProperty<double>(
      stateMap: stateOverrides, stateKey: 'style_decorationThickness',
      jsonMap: jsonStyles, jsonKey: 'decorationThickness',
      parser: (raw) => parseDouble(raw),
    );
    final List<Shadow>? shadows = getResolvedProperty<List<Shadow>>(
      stateMap: stateOverrides, stateKey: 'style_shadows',
      jsonMap: jsonStyles, jsonKey: 'shadows',
      parser: (raw) => parseShadows(raw as List?),
    );
    final String? fontFamily = getResolvedProperty<String>(
      stateMap: stateOverrides, stateKey: 'style_fontFamily',
      jsonMap: jsonStyles, jsonKey: 'fontFamily',
      parser: (raw) => parseString(raw),
    );
    final double? height = getResolvedProperty<double>(
      stateMap: stateOverrides, stateKey: 'style_height',
      jsonMap: jsonStyles, jsonKey: 'height',
      parser: (raw) => parseDouble(raw),
    );

    return TextStyle(
      fontSize: fontSize,
      color: color ?? defaultTextColor,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: textDecoration,
      decorationColor: decorationColor,
      // decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      shadows: shadows,
      fontFamily: fontFamily,
      height: height,
      // background: ..., (Paint)
      // foreground: ..., (Paint)
    );
  }
}