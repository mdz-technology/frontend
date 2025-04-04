import 'package:flutter/widgets.dart';

Widget buildText(Map<String, dynamic> json) {
  return Text(
    json['data'] ?? 'Texto por defecto',
    textAlign: _parseTextAlign(json['textAlign']),
    overflow: _parseTextOverflow(json['overflow']),
    maxLines: json['maxLines'] ?? 2, // Máximo de líneas permitidas
    softWrap: json['softWrap'],
    semanticsLabel: json['semanticsLabel'],
    textDirection: _parseTextDirection(json['textDirection']),
    locale: json['locale'] != null ? Locale(json['locale']) : null,
    textScaleFactor: (json['textScaleFactor'] ?? 1.0).toDouble(),
    textWidthBasis: _parseTextWidthBasis(json['textWidthBasis']),
    textHeightBehavior: _parseTextHeightBehavior(json['textHeightBehavior']),
    selectionColor: json['selectionColor'] != null
        ? Color(int.parse(json['selectionColor'].replaceAll("#", "0xFF")))
        : null,
    style: TextStyle(
      fontSize: (json['style']?['fontSize'] ?? 16).toDouble(),
      color: json['style']?['color'] != null
          ? Color(int.parse(json['style']['color'].replaceAll("#", "0xFF")))
          : Color(0xFF000000), // Color negro por defecto
      fontWeight: _parseFontWeight(json['style']?['fontWeight']),
      fontStyle: _parseFontStyle(json['style']?['fontStyle']),
      letterSpacing: (json['style']?['letterSpacing'] ?? 0).toDouble(),
      wordSpacing: (json['style']?['wordSpacing'] ?? 0).toDouble(),
      decoration: _parseTextDecoration(json['style']?['decoration']),
      decorationColor: json['style']?['decorationColor'] != null
          ? Color(int.parse(json['style']['decorationColor'].replaceAll("#", "0xFF")))
          : null,
      decorationThickness: (json['style']?['decorationThickness'] ?? 1).toDouble(),
      shadows: _parseShadows(json['style']?['shadows']),
    ),
  );
}

TextDirection? _parseTextDirection(String? direction) {
  switch (direction) {
    case 'ltr':
      return TextDirection.ltr;
    case 'rtl':
      return TextDirection.rtl;
    default:
      return null;
  }
}

TextWidthBasis? _parseTextWidthBasis(String? basis) {
  switch (basis) {
    case 'parent':
      return TextWidthBasis.parent;
    case 'longestLine':
      return TextWidthBasis.longestLine;
    default:
      return null;
  }
}

TextHeightBehavior? _parseTextHeightBehavior(Map<String, dynamic>? json) {
  if (json == null) return null;
  return TextHeightBehavior(
    applyHeightToFirstAscent: json['applyHeightToFirstAscent'] ?? true,
    applyHeightToLastDescent: json['applyHeightToLastDescent'] ?? true,
  );
}

// Función para convertir el `textAlign` de JSON a TextAlign en Flutter
TextAlign _parseTextAlign(String? align) {
  switch (align) {
    case "center":
      return TextAlign.center;
    case "right":
      return TextAlign.right;
    case "left":
      return TextAlign.left;
    case "justify":
      return TextAlign.justify;
    default:
      return TextAlign.start; // Valor por defecto
  }
}

// Función para convertir `fontWeight` de JSON a FontWeight
FontWeight _parseFontWeight(String? weight) {
  switch (weight) {
    case "bold":
      return FontWeight.bold;
    case "w100":
      return FontWeight.w100;
    case "w200":
      return FontWeight.w200;
    case "w300":
      return FontWeight.w300;
    case "w400":
      return FontWeight.w400;
    case "w500":
      return FontWeight.w500;
    case "w600":
      return FontWeight.w600;
    case "w700":
      return FontWeight.w700;
    case "w800":
      return FontWeight.w800;
    case "w900":
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}

// Función para convertir `fontStyle` de JSON a FontStyle
FontStyle _parseFontStyle(String? style) {
  return style == "italic" ? FontStyle.italic : FontStyle.normal;
}

// Función para convertir `textDecoration` de JSON a TextDecoration
TextDecoration _parseTextDecoration(String? decoration) {
  switch (decoration) {
    case "underline":
      return TextDecoration.underline;
    case "lineThrough":
      return TextDecoration.lineThrough;
    case "overline":
      return TextDecoration.overline;
    default:
      return TextDecoration.none;
  }
}

// Función para convertir `textOverflow` de JSON a TextOverflow
TextOverflow _parseTextOverflow(String? overflow) {
  switch (overflow) {
    case "clip":
      return TextOverflow.clip;
    case "fade":
      return TextOverflow.fade;
    case "ellipsis":
      return TextOverflow.ellipsis;
    default:
      return TextOverflow.visible;
  }
}

// Función para parsear sombras desde JSON
List<Shadow>? _parseShadows(List<dynamic>? shadowsJson) {
  if (shadowsJson == null) return null;

  return shadowsJson.map((shadow) {
    return Shadow(
      color: shadow['color'] != null
          ? Color(int.parse(shadow['color'].replaceAll("#", "0xFF")))
          : Color(0xFF000000), // Negro por defecto
      offset: Offset(
        (shadow['dx'] ?? 0).toDouble(),
        (shadow['dy'] ?? 0).toDouble(),
      ),
      blurRadius: (shadow['blurRadius'] ?? 0).toDouble(),
    );
  }).toList();
}
