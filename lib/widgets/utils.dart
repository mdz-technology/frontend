import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../widget_factory.dart';

Color? parseColor(String? hexColor) {
  if (hexColor == null) {
    return null;
  }
  String hex = hexColor.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}

Locale? parseLocale(dynamic input) {
  if (input == null) return null;
  if (input is String) {
    final parts = input.split('_');
    return parts.length == 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
  }
  return null;
}

List<Locale>? parseLocales(dynamic input) {
  if (input is List) {
    return input.map((e) => parseLocale(e) ?? const Locale('en')).toList();
  }
  return null;
}

MaterialAppData defaultMaterialAppData(
    BuildContext context, PlatformTarget platform) {
  return MaterialAppData();
}

CupertinoAppData defaultCupertinoAppData(
    BuildContext context, PlatformTarget platform) {
  return CupertinoAppData();
}

BoxDecoration? parseDecoration(Map<String, dynamic>? value) {
  if (value == null) return null;
  try {
    return BoxDecoration(
      color: parseColor(value['color']),
      borderRadius: parseBorderRadius(value['borderRadius']),
      border: parseBorder(value['border']),
      boxShadow: parseBoxShadow(value['boxShadow']),
      image: parseDecorationImage(value['image']),
    );
  } catch (e) {
    print("Error al parsear la decoración: $e");
    return null;
  }
}

BorderRadius? parseBorderRadius(Map<String, dynamic>? value) {
  if (value == null) return null;
  return BorderRadius.only(
    topLeft: parseRadius(value['topLeft']),
    topRight: parseRadius(value['topRight']),
    bottomLeft: parseRadius(value['bottomLeft']),
    bottomRight: parseRadius(value['bottomRight']),
  );
}

Radius parseRadius(dynamic value) {
  if (value is num) {
    return Radius.circular(value.toDouble());
  }
  return Radius.zero;
}

Border? parseBorder(Map<String, dynamic>? value) {
  if (value == null) return null;
  return Border.all(
    color: parseColor(value['color']) ?? Color(0xFF000000),
    width: parseDouble(value['width']) ?? 1.0,
  );
}

List<BoxShadow>? parseBoxShadow(List<dynamic>? value) {
  if (value == null) return null;
  return value.map((dynamic item) {
    return BoxShadow(
      color: parseColor(item['color']) ?? Color(0x50000000),
      offset: Offset(
        parseDouble(item['dx']) ?? 0.0,
        parseDouble(item['dy']) ?? 0.0,
      ),
      blurRadius: parseDouble(item['blurRadius']) ?? 10.0,
    );
  }).toList();
}

double? parseDouble(dynamic value) {
  if (value == null) {
    return value;
  }
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is String) {
    String stringValue = value.trim();
    String lowerCaseValue = stringValue.toLowerCase();
    if (lowerCaseValue == 'fill') {
      return double.infinity;
    }
    return double.tryParse(stringValue);
  }
  print(
      'Advertencia: parseDouble recibió un tipo no soportado: ${value.runtimeType} ($value)');
  return null;
}

DecorationImage? parseDecorationImage(Map<String, dynamic>? value) {
  if (value == null) return null;
  return DecorationImage(
    image: NetworkImage(value['imageUrl'] ?? ''),
    fit: BoxFit.values.firstWhere(
      (e) => e.toString() == value['fit'],
      orElse: () => BoxFit.cover,
    ),
  );
}

Alignment? parseAlignment(String? value) {
  if (value == null) return null;
  switch (value) {
    case 'topLeft':
      return Alignment.topLeft;
    case 'topCenter':
      return Alignment.topCenter;
    case 'topRight':
      return Alignment.topRight;
    case 'centerLeft':
      return Alignment.centerLeft;
    case 'center':
      return Alignment.center;
    case 'centerRight':
      return Alignment.centerRight;
    case 'bottomLeft':
      return Alignment.bottomLeft;
    case 'bottomCenter':
      return Alignment.bottomCenter;
    case 'bottomRight':
      return Alignment.bottomRight;
    default:
      return null;
  }
}

EdgeInsets? parseEdgeInsets(dynamic value) {
  if (value == null) {
    return null; // Devuelve null si el valor es null
  }

  // 1. Soporte para un solo número (EdgeInsets.all)
  if (value is num) {
    return EdgeInsets.all(value.toDouble());
  }

  // 2. Soporte para la cadena "zero"
  if (value is String && value.toLowerCase() == 'zero') {
    return EdgeInsets.zero;
  }

  // 3. Soporte para Lista [Left, Top, Right, Bottom]
  if (value is List) {
    // Validar que la lista tenga 4 elementos y todos sean números
    if (value.length == 4 && value.every((item) => item is num)) {
      return EdgeInsets.fromLTRB(
        (value[0] as num).toDouble(), // Left
        (value[1] as num).toDouble(), // Top
        (value[2] as num).toDouble(), // Right
        (value[3] as num).toDouble(), // Bottom
      );
    } else {
      print('Advertencia: Lista para EdgeInsets no tiene 4 números: $value');
      return null; // Formato de lista inválido
    }
  }

  // 4. Soporte para Map (varios formatos)
  if (value is Map<String, dynamic>) {
    // 4a. Prioridad 1: Clave "all"
    if (value.containsKey('all')) {
      final allValue = value['all'];
      if (allValue is num) {
        return EdgeInsets.all(allValue.toDouble());
      } else {
        print('Advertencia: Valor "all" en EdgeInsets no es numérico: $value');
        return null; // Valor 'all' inválido
      }
    }

    // 4b. Prioridad 2: Claves "horizontal" o "vertical" (EdgeInsets.symmetric)
    if (value.containsKey('horizontal') || value.containsKey('vertical')) {
      final horizontalValue = value['horizontal'];
      final verticalValue = value['vertical'];

      // Validar que los valores presentes sean numéricos
      if (horizontalValue != null && !(horizontalValue is num)) {
        print(
            'Advertencia: Valor "horizontal" en EdgeInsets no es numérico: $value');
        return null;
      }
      if (verticalValue != null && !(verticalValue is num)) {
        print(
            'Advertencia: Valor "vertical" en EdgeInsets no es numérico: $value');
        return null;
      }

      return EdgeInsets.symmetric(
        horizontal: (horizontalValue as num?)?.toDouble() ?? 0.0,
        vertical: (verticalValue as num?)?.toDouble() ?? 0.0,
      );
    }

    // 4c. Prioridad 3: Claves "left", "top", "right", "bottom" (EdgeInsets.only - como estaba antes)
    // Verificamos si existe al menos una de estas claves para diferenciar de un mapa vacío {}
    if (value.containsKey('left') ||
        value.containsKey('top') ||
        value.containsKey('right') ||
        value.containsKey('bottom')) {
      // Validar que los valores presentes sean numéricos
      if (value['left'] != null && !(value['left'] is num)) {
        print('Advertencia: Valor "left" en EdgeInsets no es numérico: $value');
        return null;
      }
      if (value['top'] != null && !(value['top'] is num)) {
        print('Advertencia: Valor "top" en EdgeInsets no es numérico: $value');
        return null;
      }
      if (value['right'] != null && !(value['right'] is num)) {
        print(
            'Advertencia: Valor "right" en EdgeInsets no es numérico: $value');
        return null;
      }
      if (value['bottom'] != null && !(value['bottom'] is num)) {
        print(
            'Advertencia: Valor "bottom" en EdgeInsets no es numérico: $value');
        return null;
      }

      return EdgeInsets.only(
        left: (value['left'] as num?)?.toDouble() ?? 0.0,
        top: (value['top'] as num?)?.toDouble() ?? 0.0,
        right: (value['right'] as num?)?.toDouble() ?? 0.0,
        bottom: (value['bottom'] as num?)?.toDouble() ?? 0.0,
      );
    }

    // Si es un mapa pero no coincide con ninguno de los formatos conocidos (ej: mapa vacío {}),
    // se considera no válido para EdgeInsets. Podría devolver EdgeInsets.zero aquí si se desea
    // que un mapa vacío signifique cero padding/margin, pero devolver null es más seguro.
    // print('Advertencia: Mapa para EdgeInsets no coincide con formatos conocidos: $value');
    // return null; // Comentado para que caiga al return null general
  }

  // Si el tipo de 'value' no es ninguno de los soportados
  print(
      'Advertencia: Formato no soportado para EdgeInsets: ${value.runtimeType} - $value');
  return null;
}

BoxConstraints? parseBoxConstraints(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) {
    return BoxConstraints.tightFor(
      width: (value['width'] as num?)?.toDouble(),
      height: (value['height'] as num?)?.toDouble(),
    );
  }
  return null;
}

Matrix4? parseTransform(dynamic value) {
  if (value == null) return null;
  if (value is List<dynamic>) {
    try {
      List<double> doubleList = value.map<double>((item) {
        if (item is int) return item.toDouble();
        if (item is double) return item;
        throw FormatException("Item en la lista no es int ni double.");
      }).toList();
      return Matrix4.fromList(doubleList);
    } catch (e) {
      print('Error al parsear la transformación: $e');
      return null;
    }
  }
  return null;
}

Clip parseClipBehavior(dynamic value) {
  if (value == null) return Clip.none;
  switch (value) {
    case 'none':
      return Clip.none;
    case 'hardEdge':
      return Clip.hardEdge;
    case 'antiAlias':
      return Clip.antiAlias;
    case 'antiAliasWithSaveLayer':
      return Clip.antiAliasWithSaveLayer;
    default:
      return Clip.none;
  }
}

MainAxisAlignment? parseMainAxisAlignment(dynamic value) {
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spacebetween':
        return MainAxisAlignment.spaceBetween;
      case 'spacearound':
        return MainAxisAlignment.spaceAround;
      case 'spaceevenly':
        return MainAxisAlignment.spaceEvenly;
    }
  }
  return null;
}

MainAxisSize? parseMainAxisSize(dynamic value) {
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'min':
        return MainAxisSize.min;
      case 'max':
        return MainAxisSize.max;
    }
  }
  return null;
}

CrossAxisAlignment? parseCrossAxisAlignment(dynamic value) {
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
    }
  }
  return null;
}

TextDirection? parseTextDirection(String? direction) {
  switch (direction) {
    case 'ltr':
      return TextDirection.ltr;
    case 'rtl':
      return TextDirection.rtl;
    default:
      return null;
  }
}

VerticalDirection? parseVerticalDirection(dynamic value) {
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'up':
        return VerticalDirection.up;
      case 'down':
        return VerticalDirection.down;
    }
  }
  return null;
}

TextBaseline? parseTextBaseline(dynamic value) {
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'alphabetic':
        return TextBaseline.alphabetic;
      case 'ideographic':
        return TextBaseline.ideographic;
    }
  }
  return null;
}

int? parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt(); // Allow double like 10.0
  if (value is String) return int.tryParse(value);
  return null; // Invalid type
}

TextAlign parseTextAlign(String? align) {
  switch (align) {
    case "center":
      return TextAlign.center;
    case "right":
      return TextAlign.right;
    case "left":
      return TextAlign.left;
    case "justify":
      return TextAlign.justify;
    case "end":
      return TextAlign.end; // Added end
    case "start": // Fallthrough
    default:
      return TextAlign.start; // Default
  }
}

TextOverflow parseTextOverflow(String? overflow) {
  switch (overflow) {
    case "clip":
      return TextOverflow.clip;
    case "fade":
      return TextOverflow.fade;
    case "ellipsis":
      return TextOverflow.ellipsis;
    case "visible": // Fallthrough
    default:
      return TextOverflow.visible; // Default
  }
}

TextWidthBasis? parseTextWidthBasis(String? basis) {
  switch (basis) {
    case 'parent':
      return TextWidthBasis.parent;
    case 'longestLine':
      return TextWidthBasis.longestLine;
    default:
      return null; // Text widget handles null
  }
}

FontWeight parseFontWeight(String? weight) {
  switch (weight) {
    case "bold":
      return FontWeight.bold;
    case "normal":
      return FontWeight.normal; // Explicit normal
    case "w100":
      return FontWeight.w100;
    case "w200":
      return FontWeight.w200;
    case "w300":
      return FontWeight.w300;
    case "w400":
      return FontWeight.w400; // Same as normal
    case "w500":
      return FontWeight.w500;
    case "w600":
      return FontWeight.w600;
    case "w700":
      return FontWeight.w700; // Same as bold
    case "w800":
      return FontWeight.w800;
    case "w900":
      return FontWeight.w900;
    default:
      return FontWeight.normal; // Default
  }
}

FontStyle parseFontStyle(String? style) {
  switch (style) {
    case "italic":
      return FontStyle.italic;
    case "normal": // Fallthrough
    default:
      return FontStyle.normal; // Default
  }
}

TextDecoration? parseTextDecoration(String? decoration) {
  switch (decoration) {
    case "underline":
      return TextDecoration.underline;
    case "lineThrough":
      return TextDecoration.lineThrough;
    case "overline":
      return TextDecoration.overline;
    case "none": // Fallthrough
    default:
      return TextDecoration.none; // Default is none, but allow null if needed
  }
}

TextHeightBehavior? parseTextHeightBehavior(dynamic jsonValue) {
  if (jsonValue is! Map) return null; // Expect a Map
  final Map<String, dynamic> json = Map<String, dynamic>.from(jsonValue);

  final bool applyFirst = json['applyHeightToFirstAscent'] as bool? ?? true;
  final bool applyLast = json['applyHeightToLastDescent'] as bool? ?? true;

  return TextHeightBehavior(
    applyHeightToFirstAscent: applyFirst,
    applyHeightToLastDescent: applyLast,
  );
}

List<Shadow>? parseShadows(dynamic shadowsJsonValue) {
  if (shadowsJsonValue is! List) return null;

  final List<Shadow> shadows = [];
  for (final item in shadowsJsonValue) {
    if (item is! Map) continue;
    final Map<String, dynamic> shadowMap = Map<String, dynamic>.from(item);

    final Color color =
        parseColor(shadowMap['color']?.toString()) ?? Color(0xFF000000);
    final double dx = parseDouble(shadowMap['dx']) ?? 0.0;
    final double dy = parseDouble(shadowMap['dy']) ?? 0.0;
    final double blurRadius = parseDouble(shadowMap['blurRadius']) ?? 0.0;

    shadows.add(Shadow(
      color: color,
      offset: Offset(dx, dy),
      blurRadius: blurRadius,
    ));
  }
  return shadows.isNotEmpty ? shadows : null;
}

bool? parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) {
    if (value == 1) return true;
    if (value == 0) return false;
    return null;
  }
  if (value is String) {
    final lowerValue = value.toLowerCase();
    if (lowerValue == 'true' || lowerValue == '1' || lowerValue == 'yes' || lowerValue == 'on') {
      return true;
    }
    if (lowerValue == 'false' || lowerValue == '0' || lowerValue == 'no' || lowerValue == 'off') {
      return false;
    }
    return null;
  }
  return null;
}


String? parseString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return null;
}

MouseCursor? parseMouseCursor(dynamic value) {
  if (value == null || value is! String) return null;

  final lowerValue = value.toLowerCase();
  switch (lowerValue) {
    case 'basic': return SystemMouseCursors.basic;
    case 'click': return SystemMouseCursors.click;
    case 'text': return SystemMouseCursors.text;
    case 'wait': return SystemMouseCursors.wait;
    case 'progress': return SystemMouseCursors.progress;
    case 'forbidden': return SystemMouseCursors.forbidden;
    case 'help': return SystemMouseCursors.help;
    case 'move': return SystemMouseCursors.move;
    case 'grab': return SystemMouseCursors.grab;
    case 'grabbing': return SystemMouseCursors.grabbing;
    case 'alias': return SystemMouseCursors.alias;
    case 'cell': return SystemMouseCursors.cell;
    case 'context_menu': return SystemMouseCursors.contextMenu;
    case 'copy': return SystemMouseCursors.copy;
    case 'disappearing': return SystemMouseCursors.disappearing;
    case 'no_drop': return SystemMouseCursors.noDrop;
    case 'none': return SystemMouseCursors.none; // Oculta el cursor
    case 'precise': return SystemMouseCursors.precise;
    case 'resize_down': return SystemMouseCursors.resizeDown;
    case 'resize_down_left': return SystemMouseCursors.resizeDownLeft;
    case 'resize_down_right': return SystemMouseCursors.resizeDownRight;
    case 'resize_left': return SystemMouseCursors.resizeLeft;
    case 'resize_right': return SystemMouseCursors.resizeRight;
    case 'resize_up': return SystemMouseCursors.resizeUp;
    case 'resize_up_left': return SystemMouseCursors.resizeUpLeft;
    case 'resize_up_right': return SystemMouseCursors.resizeUpRight;
    case 'resize_up_down': return SystemMouseCursors.resizeUpDown;
    case 'resize_left_right': return SystemMouseCursors.resizeLeftRight;
    case 'all_scroll': return SystemMouseCursors.allScroll;
    case 'zoom_in': return SystemMouseCursors.zoomIn;
    case 'zoom_out': return SystemMouseCursors.zoomOut;
    default:
      print("Warning: Unrecognized MouseCursor string '$value'. Falling back to null.");
      return null;
  }
}

VisualDensity? parseVisualDensity(dynamic value) {
  if (value == null) return null;

  if (value is String) {
    final lowerValue = value.toLowerCase();
    switch (lowerValue) {
      case 'standard': return VisualDensity.standard;
      case 'compact': return VisualDensity.compact;
      case 'comfortable': return VisualDensity.comfortable;
      case 'adaptiveplatformdensity': return VisualDensity.adaptivePlatformDensity;
      default:
        print("Warning: Unrecognized VisualDensity string '$value'. Falling back to null.");
        return null;
    }
  }

  if (value is Map<String, dynamic>) {
    return VisualDensity(
      horizontal: parseDouble(value['horizontal']) ?? 0.0,
      vertical: parseDouble(value['vertical']) ?? 0.0,
    );
  }

  print("Warning: Unsupported type for VisualDensity parsing. Value: $value");
  return null;
}


ButtonStyle? parseButtonStyle(dynamic value) {
  if (value == null || value is! Map<String, dynamic>) {
    return null;
  }

  final map = value as Map<String, dynamic>;

  // --- Propiedades que usan MaterialStateProperty ---
  final MaterialStateProperty<TextStyle?>? textStyle = map.containsKey('textStyle')
      ? MaterialStateProperty.all(parseTextStyle(map['textStyle'])) // Necesita parseTextStyle
      : null;
  final MaterialStateProperty<Color?>? backgroundColor = map.containsKey('backgroundColor')
      ? MaterialStateProperty.all(parseColor(map['backgroundColor']))
      : null;
  final MaterialStateProperty<Color?>? foregroundColor = map.containsKey('foregroundColor')
      ? MaterialStateProperty.all(parseColor(map['foregroundColor']))
      : null;
  final MaterialStateProperty<Color?>? overlayColor = map.containsKey('overlayColor')
      ? MaterialStateProperty.all(parseColor(map['overlayColor']))
      : null;
  final MaterialStateProperty<Color?>? shadowColor = map.containsKey('shadowColor')
      ? MaterialStateProperty.all(parseColor(map['shadowColor']))
      : null;
  final MaterialStateProperty<Color?>? surfaceTintColor = map.containsKey('surfaceTintColor')
      ? MaterialStateProperty.all(parseColor(map['surfaceTintColor']))
      : null;
  final MaterialStateProperty<double?>? elevation = map.containsKey('elevation')
      ? MaterialStateProperty.all(parseDouble(map['elevation']))
      : null;
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding = map.containsKey('padding')
      ? MaterialStateProperty.all(parseEdgeInsets(map['padding']))
      : null;
  final MaterialStateProperty<Size?>? minimumSize = map.containsKey('minimumSize')
      ? MaterialStateProperty.all(parseSize(map['minimumSize'])) // Necesita parseSize
      : null;
  final MaterialStateProperty<Size?>? fixedSize = map.containsKey('fixedSize')
      ? MaterialStateProperty.all(parseSize(map['fixedSize'])) // Necesita parseSize
      : null;
  final MaterialStateProperty<Size?>? maximumSize = map.containsKey('maximumSize')
      ? MaterialStateProperty.all(parseSize(map['maximumSize'])) // Necesita parseSize
      : null;
  final MaterialStateProperty<BorderSide?>? side = map.containsKey('side')
      ? MaterialStateProperty.all(parseBorderSide(map['side'])) // Necesita parseBorderSide
      : null;
  final MaterialStateProperty<OutlinedBorder?>? shape = map.containsKey('shape')
      ? MaterialStateProperty.all(parseOutlinedBorder(map['shape'])) // Necesita parseOutlinedBorder
      : null;

  final AlignmentGeometry? alignment = parseAlignment(map['alignment']);
  final VisualDensity? visualDensity = parseVisualDensity(map['visualDensity']);
  final MaterialTapTargetSize? tapTargetSize = parseMaterialTapTargetSize(map['tapTargetSize']);
  final Duration? animationDuration = parseDuration(map['animationDuration']);
  final bool? enableFeedback = parseBool(map['enableFeedback']);

  return ButtonStyle(
    textStyle: textStyle,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    overlayColor: overlayColor,
    shadowColor: shadowColor,
    surfaceTintColor: surfaceTintColor,
    elevation: elevation,
    padding: padding,
    minimumSize: minimumSize,
    fixedSize: fixedSize,
    maximumSize: maximumSize,
    side: side,
    shape: shape,
    alignment: alignment,
    visualDensity: visualDensity,
    tapTargetSize: tapTargetSize,
    animationDuration: animationDuration,
    enableFeedback: enableFeedback,
  );
}


TextStyle? parseTextStyle(dynamic value) {
  print("TODO: Implement parseTextStyle");
  return null; // Placeholder
}

Size? parseSize(dynamic value) {
  print("TODO: Implement parseSize");
  if (value is Map<String, dynamic>) {
    final double? width = parseDouble(value['width']);
    final double? height = parseDouble(value['height']);
    if (width != null && height != null) {
      return Size(width, height);
    }
  }
  return null;
}

BorderSide? parseBorderSide(dynamic value) {
  if (value == null || value is! Map<String, dynamic>) {
    return null; // O BorderSide.none
  }
  final map = value as Map<String, dynamic>;
  final Color color = parseColor(map['color']) ?? const Color(0xFF000000); // Default negro
  final double width = parseDouble(map['width']) ?? 1.0; // Default 1.0
  // TODO: Parsear BorderStyle (solid, none) si es necesario
  // final BorderStyle style = parseBorderStyle(map['style']) ?? BorderStyle.solid;
  return BorderSide(
    color: color,
    width: width,
    // style: style,
  );
}

OutlinedBorder? parseOutlinedBorder(dynamic value) {
  print("TODO: Implement parseOutlinedBorder");
  return null;
}

MaterialTapTargetSize? parseMaterialTapTargetSize(dynamic value) {
  if (value is String) {
    if (value.toLowerCase() == 'padded') return MaterialTapTargetSize.padded;
    if (value.toLowerCase() == 'shrinkwrap') return MaterialTapTargetSize.shrinkWrap;
  }
  print("TODO: Implement parseMaterialTapTargetSize");
  return null;
}

Duration? parseDuration(dynamic value) {
  if (value is int) return Duration(milliseconds: value);
  if (value is Map<String, dynamic> && value.containsKey('milliseconds')) {
    final int? ms = parseInt(value['milliseconds']);
    if (ms != null) return Duration(milliseconds: ms);
  }
  print("TODO: Implement parseDuration");
  return null;
}

BlendMode? parseBlendMode(dynamic value) {
  if (value == null || value is! String) {
    // Si el valor es nulo o no es un string, no se puede parsear.
    return null;
  }

  final String lowerValue = value.toLowerCase();

  switch (lowerValue) {
    case 'clear': return BlendMode.clear;
    case 'src': return BlendMode.src;
    case 'dst': return BlendMode.dst;
  // Incluir variaciones comunes como con/sin underscore si se prefiere
    case 'srcover':
    case 'src_over': return BlendMode.srcOver;
    case 'dstover':
    case 'dst_over': return BlendMode.dstOver;
    case 'srcin':
    case 'src_in': return BlendMode.srcIn;
    case 'dstin':
    case 'dst_in': return BlendMode.dstIn;
    case 'srcout':
    case 'src_out': return BlendMode.srcOut;
    case 'dstout':
    case 'dst_out': return BlendMode.dstOut;
    case 'srcatop':
    case 'src_atop': return BlendMode.srcATop;
    case 'dstatop':
    case 'dst_atop': return BlendMode.dstATop;
    case 'xor': return BlendMode.xor;
    case 'plus': return BlendMode.plus;
    case 'modulate': return BlendMode.modulate;
    case 'screen': return BlendMode.screen;
    case 'overlay': return BlendMode.overlay;
    case 'darken': return BlendMode.darken;
    case 'lighten': return BlendMode.lighten;
    case 'colordodge':
    case 'color_dodge': return BlendMode.colorDodge;
    case 'colorburn':
    case 'color_burn': return BlendMode.colorBurn;
    case 'hardlight':
    case 'hard_light': return BlendMode.hardLight;
    case 'softlight':
    case 'soft_light': return BlendMode.softLight;
    case 'difference': return BlendMode.difference;
    case 'exclusion': return BlendMode.exclusion;
    case 'multiply': return BlendMode.multiply;
    case 'hue': return BlendMode.hue;
    case 'saturation': return BlendMode.saturation;
    case 'color': return BlendMode.color;
    case 'luminosity': return BlendMode.luminosity;

    default:
    // Si el string no coincide con ningún BlendMode conocido
      print("Warning: Unrecognized BlendMode string '$value'. Falling back to null.");
      return null;
  }
}

// --- Parsers para TextField y relacionados ---

/// Parsea un valor JSON a un InputBorder.
/// Acepta:
///   - null -> null
///   - String "none" -> InputBorder.none
///   - Map: { "type": "outline"|"underline", "color": "#...", "width": ..., "borderRadius": {...}, "gapPadding": ... }
InputBorder? parseInputBorder(dynamic value) {
  if (value == null) return null;
  if (value is String && value.toLowerCase() == 'none') {
    return InputBorder.none;
  }
  if (value is Map<String, dynamic>) {
    // Extraer tipo, default a 'underline' si no se especifica explícitamente 'outline' o 'none'
    String type = value['type'] as String? ?? 'underline';
    // Si se especificó 'none' como tipo en el mapa, también retorna none
    if (type.toLowerCase() == 'none') {
      return InputBorder.none;
    }

    // Parsear propiedades comunes de BorderSide
    // Usar un color por defecto más visible que el negro puro si no se especifica
    final Color color = parseColor(value['color']) ?? Colors.grey.shade600;
    final double width = parseDouble(value['width']) ?? 1.0;
    final BorderSide borderSide = BorderSide(color: color, width: width);

    // Parsear borderRadius (ya existe en tus utils)
    // Usar un default razonable para bordes si no se especifica
    final BorderRadius borderRadius = parseBorderRadius(value['borderRadius']) ??
        (type == 'outline' ? BorderRadius.circular(4.0) : BorderRadius.zero);

    // Parsear gapPadding específico de OutlineInputBorder
    final double gapPadding = parseDouble(value['gapPadding']) ?? 4.0;

    switch (type.toLowerCase()) {
      case 'outline':
        return OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
          gapPadding: gapPadding,
        );
      case 'underline':
        return UnderlineInputBorder(
          borderSide: borderSide,
          // UnderlineInputBorder también respeta borderRadius (para las esquinas superiores)
          borderRadius: borderRadius,
        );
      default:
        print("Warning: Tipo de InputBorder no reconocido '$type'. Usando Underline por defecto.");
        return UnderlineInputBorder(borderSide: borderSide, borderRadius: borderRadius);
    }
  }
  print("Warning: Formato no reconocido para InputBorder: ${value.runtimeType} - $value");
  return null; // Fallback si el formato no es String ni Map
}


/// Parsea un string al enum TextInputType nullable.
TextInputType? parseTextInputType(String? type) {
  if (type == null) return null;
  switch (type.toLowerCase()) {
    case 'text': return TextInputType.text;
    case 'multiline': return TextInputType.multiline;
    case 'number': return TextInputType.number;
    case 'phone': return TextInputType.phone;
    case 'datetime': return TextInputType.datetime;
    case 'emailaddress':
    case 'email': return TextInputType.emailAddress;
    case 'url': return TextInputType.url;
    case 'visiblepassword': return TextInputType.visiblePassword;
    case 'name': return TextInputType.name;
    case 'streetaddress': return TextInputType.streetAddress;
    case 'none': return TextInputType.none;
    default:
      print("Warning: TextInputType no reconocido '$type'.");
      return null;
  }
}

/// Parsea un string al enum TextInputAction nullable.
TextInputAction? parseTextInputAction(String? action) {
  if (action == null) return null;
  switch (action.toLowerCase()) {
    case 'none': return TextInputAction.none;
    case 'unspecified': return TextInputAction.unspecified;
    case 'done': return TextInputAction.done;
    case 'go': return TextInputAction.go;
    case 'search': return TextInputAction.search;
    case 'send': return TextInputAction.send;
    case 'next': return TextInputAction.next;
    case 'previous': return TextInputAction.previous;
    case 'continueaction': return TextInputAction.continueAction;
    case 'join': return TextInputAction.join;
    case 'route': return TextInputAction.route;
    case 'emergencycall': return TextInputAction.emergencyCall;
    case 'newline': return TextInputAction.newline;
    default:
      print("Warning: TextInputAction no reconocido '$action'.");
      return null;
  }
}

/// Parsea un string al enum TextCapitalization nullable.
TextCapitalization? parseTextCapitalization(String? capitalization) {
  if (capitalization == null) return null; // TextField usa 'none' como default si es null
  switch (capitalization.toLowerCase()) {
    case 'words': return TextCapitalization.words;
    case 'sentences': return TextCapitalization.sentences;
    case 'characters': return TextCapitalization.characters;
    case 'none': return TextCapitalization.none;
    default:
      print("Warning: TextCapitalization no reconocido '$capitalization'.");
      return null;
  }
}

/// Parsea un string ("top", "center", "bottom") o un número a TextAlignVertical nullable.
TextAlignVertical? parseTextAlignVertical(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'top': return TextAlignVertical.top;
      case 'center': return TextAlignVertical.center;
      case 'bottom': return TextAlignVertical.bottom;
      default:
        print("Warning: String para TextAlignVertical no reconocido '$value'.");
        return null;
    }
  }
  // Permite especificar el factor Y directamente como un número (ej: 0.0 para centro)
  if (value is num) {
    return TextAlignVertical(y: value.toDouble());
  }
  print("Warning: Tipo no soportado para TextAlignVertical: ${value.runtimeType}");
  return null;
}

/// Parsea un string ("enabled", "disabled") al enum SmartDashesType nullable.
SmartDashesType? parseSmartDashesType(String? type) {
  if (type == null) return null; // TextField usa un default interno si es null
  switch (type.toLowerCase()) {
    case 'disabled': return SmartDashesType.disabled;
    case 'enabled': return SmartDashesType.enabled;
    default:
      print("Warning: SmartDashesType no reconocido '$type'.");
      return null;
  }
}

/// Parsea un string ("enabled", "disabled") al enum SmartQuotesType nullable.
SmartQuotesType? parseSmartQuotesType(String? type) {
  if (type == null) return null; // TextField usa un default interno si es null
  switch (type.toLowerCase()) {
    case 'disabled': return SmartQuotesType.disabled;
    case 'enabled': return SmartQuotesType.enabled;
    default:
      print("Warning: SmartQuotesType no reconocido '$type'.");
      return null;
  }
}

/// Parsea un string al enum MaxLengthEnforcement nullable.
MaxLengthEnforcement? parseMaxLengthEnforcement(String? enforcement) {
  if (enforcement == null) return null; // TextField usa un default interno si es null
  switch (enforcement.toLowerCase()) {
    case 'none': return MaxLengthEnforcement.none;
    case 'enforced': return MaxLengthEnforcement.enforced;
    case 'truncateaftercompositionends': return MaxLengthEnforcement.truncateAfterCompositionEnds;
    default:
      print("Warning: MaxLengthEnforcement no reconocido '$enforcement'.");
      return null;
  }
}

/// Parsea un string ("light", "dark") al enum Brightness nullable.
Brightness? parseKeyboardAppearance(String? appearance) {
  if (appearance == null) return null; // Usa el default de la plataforma
  switch (appearance.toLowerCase()) {
    case 'light': return Brightness.light;
    case 'dark': return Brightness.dark;
    default:
      print("Warning: KeyboardAppearance no reconocido '$appearance'.");
      return null;
  }
}

/// Parsea un string ("start", "down") al enum DragStartBehavior.
/// Devuelve DragStartBehavior.start por defecto si el valor es nulo o inválido.
DragStartBehavior parseDragStartBehavior(String? behavior) {
  // Default definido en el constructor de TextField es 'start'
  if (behavior == null) return DragStartBehavior.start;
  switch (behavior.toLowerCase()) {
    case 'down': return DragStartBehavior.down;
    case 'start': return DragStartBehavior.start;
    default:
      print("Warning: DragStartBehavior no reconocido '$behavior'. Usando 'start'.");
      return DragStartBehavior.start;
  }
}

/// Parsea un string a una instancia de ScrollPhysics nullable.
ScrollPhysics? parseScrollPhysics(String? physics) {
  if (physics == null) return null; // Usa el default de la plataforma
  switch (physics.toLowerCase()) {
    case 'never':
    case 'neverscrollable': return const NeverScrollableScrollPhysics();
    case 'bouncing': return const BouncingScrollPhysics();
    case 'clamping': return const ClampingScrollPhysics();
    case 'fixed':
    case 'fixedextent': return const FixedExtentScrollPhysics();
    case 'page': return const PageScrollPhysics();
  // 'AlwaysScrollableScrollPhysics' es útil si quieres asegurar que se pueda
  // hacer scroll incluso si el contenido no excede el viewport (requiere un viewport)
    case 'always':
    case 'alwaysscrollable': return const AlwaysScrollableScrollPhysics();
    default:
      print("Warning: ScrollPhysics no reconocido '$physics'. Usando default de plataforma.");
      return null;
  }
}

InputDecoration? parseInputDecoration(
    Map<String, dynamic>? jsonDecoration,
    BuildContext context,
    Map<String, dynamic>? params,
    ) {
  if (jsonDecoration == null) return null;

  Widget? parseIcon(String key) {
    final iconJson = jsonDecoration[key];
    if (iconJson != null && iconJson is Map<String, dynamic>) {
      try {
        return WidgetFactory.buildWidgetFromJson(context, iconJson, params);
      } catch (e) {
        print("Error building icon '$key' for InputDecoration: $e");
        return null;
      }
    }
    return null;
  }

  return InputDecoration(
    icon: parseIcon('icon'),
    labelText: parseString(jsonDecoration['labelText']),
    labelStyle: parseTextStyle(jsonDecoration['labelStyle']),
    helperText: parseString(jsonDecoration['helperText']),
    helperStyle: parseTextStyle(jsonDecoration['helperStyle']),
    helperMaxLines: parseInt(jsonDecoration['helperMaxLines']),
    hintText: parseString(jsonDecoration['hintText']),
    hintStyle: parseTextStyle(jsonDecoration['hintStyle']),
    hintTextDirection: parseTextDirection(jsonDecoration['hintTextDirection']),
    hintMaxLines: parseInt(jsonDecoration['hintMaxLines']),
    errorText: parseString(jsonDecoration['errorText']),
    errorStyle: parseTextStyle(jsonDecoration['errorStyle']),
    errorMaxLines: parseInt(jsonDecoration['errorMaxLines']),
    floatingLabelStyle: parseTextStyle(jsonDecoration['floatingLabelStyle']),
    isCollapsed: parseBool(jsonDecoration['isCollapsed']) ?? false,
    isDense: parseBool(jsonDecoration['isDense']),
    contentPadding: parseEdgeInsets(jsonDecoration['contentPadding']),
    prefixIcon: parseIcon('prefixIcon'),
    prefixIconConstraints: parseBoxConstraints(jsonDecoration['prefixIconConstraints']),
    prefix: parseIcon('prefix'),
    prefixText: parseString(jsonDecoration['prefixText']),
    prefixStyle: parseTextStyle(jsonDecoration['prefixStyle']),
    prefixIconColor: parseColor(jsonDecoration['prefixIconColor']),
    suffixIcon: parseIcon('suffixIcon'),
    suffix: parseIcon('suffix'),
    suffixText: parseString(jsonDecoration['suffixText']),
    suffixStyle: parseTextStyle(jsonDecoration['suffixStyle']),
    suffixIconColor: parseColor(jsonDecoration['suffixIconColor']),
    suffixIconConstraints: parseBoxConstraints(jsonDecoration['suffixIconConstraints']),
    counter: parseIcon('counter'),
    counterText: parseString(jsonDecoration['counterText']),
    counterStyle: parseTextStyle(jsonDecoration['counterStyle']),
    filled: parseBool(jsonDecoration['filled']),
    fillColor: parseColor(jsonDecoration['fillColor']),
    focusColor: parseColor(jsonDecoration['focusColor']),
    hoverColor: parseColor(jsonDecoration['hoverColor']),
    errorBorder: parseInputBorder(jsonDecoration['errorBorder']),
    focusedBorder: parseInputBorder(jsonDecoration['focusedBorder']),
    focusedErrorBorder: parseInputBorder(jsonDecoration['focusedErrorBorder']),
    disabledBorder: parseInputBorder(jsonDecoration['disabledBorder']),
    enabledBorder: parseInputBorder(jsonDecoration['enabledBorder']),
    border: parseInputBorder(jsonDecoration['border']),
    enabled: parseBool(jsonDecoration['enabled']) ?? true,
    semanticCounterText: parseString(jsonDecoration['semanticCounterText']),
    alignLabelWithHint: parseBool(jsonDecoration['alignLabelWithHint']),
    constraints: parseBoxConstraints(jsonDecoration['constraints']),
  );
}

ListTileStyle? parseListTileStyle(String? style) {
  if (style == null) return null;
  switch (style.toLowerCase()) {
    case 'list': return ListTileStyle.list;
    case 'drawer': return ListTileStyle.drawer;
    default:
      print("Warning: ListTileStyle no reconocido '$style'.");
      return null; // O un default como ListTileStyle.list
  }
}

/// Parsea un string ("top", "center", "bottom") al enum ListTileTitleAlignment nullable.
ListTileTitleAlignment? parseListTileTitleAlignment(String? alignment) {
  if (alignment == null) return null;
  switch (alignment.toLowerCase()) {
    case 'top': return ListTileTitleAlignment.top;
    case 'center': return ListTileTitleAlignment.center;
    case 'bottom': return ListTileTitleAlignment.bottom;
  // case 'threeLine': return ListTileTitleAlignment.threeLine; // Si se necesita
  // case 'adaptive': return ListTileTitleAlignment.adaptive; // Si se necesita
    default:
      print("Warning: ListTileTitleAlignment no reconocido '$alignment'.");
      return null;
  }
}

ShapeBorder? parseShapeBorder(dynamic value) {
  if (value == null || value is! Map<String, dynamic>) {
    return null;
  }
  final Map<String, dynamic> map = value;
  final String? type = map['type'] as String?;
  // Parsear BorderSide si se proporciona (puede ser null)
  // Necesita parseBorderSide en utils.dart
  final BorderSide? side = parseBorderSide(map['side']);

  // Parsear BorderRadius si se proporciona (puede ser null)
  // parseBorderRadius ya debería existir en tus utils
  final BorderRadiusGeometry? borderRadius = parseBorderRadius(map['borderRadius']);


  switch (type?.toLowerCase()) {
    case 'roundedrectangle':
    case 'rounded': // Alias
      return RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero, // Default a zero si no se especifica
        side: side ?? BorderSide.none, // Default a none si no se especifica
      );
    case 'stadium':
      return StadiumBorder(
        side: side ?? BorderSide.none,
      );
    case 'circle':
    // TODO: CircleBorder tiene un parámetro 'eccentricity' que podría parsearse si es necesario
      return CircleBorder(
        side: side ?? BorderSide.none,
      );
    case 'beveledrectangle':
    case 'beveled': // Alias
      return BeveledRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
        side: side ?? BorderSide.none,
      );
    case 'continuousrectangle':
    case 'continuous': // Alias
      return ContinuousRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
        side: side ?? BorderSide.none,
      );
  // Podrías añadir 'linearBorder', 'starBorder' si fueran necesarios
    default:
      print("Warning: Tipo de ShapeBorder no reconocido '$type'.");
      return null; // O devolver un default como RoundedRectangleBorder()
  }
}

/// Parsea un string ("horizontal", "vertical") a un enum Axis.
Axis? parseAxis(String? axis) {
  if (axis == null) return null; // Default es vertical en ListView
  switch (axis.toLowerCase()) {
    case 'horizontal': return Axis.horizontal;
    case 'vertical': return Axis.vertical;
    default:
      print("Warning: Axis no reconocido '$axis'. Usando vertical.");
      return Axis.vertical;
  }
}

/// Parsea un string ("manual", "onDrag") a ScrollViewKeyboardDismissBehavior.
ScrollViewKeyboardDismissBehavior? parseScrollViewKeyboardDismissBehavior(String? behavior) {
  if (behavior == null) return null; // Default es manual
  switch (behavior.toLowerCase()) {
    case 'manual': return ScrollViewKeyboardDismissBehavior.manual;
    case 'ondrag': return ScrollViewKeyboardDismissBehavior.onDrag;
    default:
      print("Warning: ScrollViewKeyboardDismissBehavior no reconocido '$behavior'. Usando manual.");
      return ScrollViewKeyboardDismissBehavior.manual;
  }
}

/// Parsea un string ("opaque", "translucent", "deferToChild") a HitTestBehavior.
HitTestBehavior? parseHitTestBehavior(String? behavior) {
  if (behavior == null) return null; // Default suele ser opaque para áreas clickeables
  switch (behavior.toLowerCase()) {
    case 'opaque': return HitTestBehavior.opaque;
    case 'translucent': return HitTestBehavior.translucent;
    case 'defertochild':
    case 'defer': return HitTestBehavior.deferToChild;
    default:
      print("Warning: HitTestBehavior no reconocido '$behavior'.");
      return null;
  }
}

FlexFit? parseFlexFit(dynamic value) {
  if (value == null || value is! String) {
    return null; // Devuelve null si no es un string válido
  }
  switch (value.toLowerCase()) {
    case 'tight':
      return FlexFit.tight;
    case 'loose':
      return FlexFit.loose;
    default:
      print("Warning: FlexFit no reconocido '$value'.");
      return null; // Devuelve null si el string no es válido
  }
}