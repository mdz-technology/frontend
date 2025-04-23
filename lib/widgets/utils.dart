import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Color parseColor(String hexColor) {
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

MaterialAppData defaultMaterialAppData(BuildContext context, PlatformTarget platform) {
  return MaterialAppData();
}

CupertinoAppData defaultCupertinoAppData(BuildContext context, PlatformTarget platform) {
  return CupertinoAppData();
}

// Parse Decoration function (newly added)
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

double parseDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();  // Convierte int a double
  }
  return value ?? 0.0;  // Valor por defecto
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

// Parsear valores de Alignment
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

// Parsear valores de EdgeInsets
EdgeInsets? parseEdgeInsets(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) {
    return EdgeInsets.only(
      left: (value['left'] as num?)?.toDouble() ?? 0.0,
      top: (value['top'] as num?)?.toDouble() ?? 0.0,
      right: (value['right'] as num?)?.toDouble() ?? 0.0,
      bottom: (value['bottom'] as num?)?.toDouble() ?? 0.0,
    );
  }
  return null;
}


// Parsear BoxConstraints
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

// Parsear transform
// Parsear transform

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

// Parsear ClipBehavior
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