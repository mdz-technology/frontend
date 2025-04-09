import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';

// Construcción del widget Container desde JSON
Widget buildContainer(Map<String, dynamic> json) {
  // Primero, obtener el color
  Color? color = _parseColor(json['color']);

  // Verificar si hay una decoración en el JSON
  BoxDecoration? decoration = json['decoration'] != null
      ? _parseDecoration(json['decoration'])
      : null;

  return Container(
    key: json['key'] != null ? Key(json['key']) : null,
    alignment: _parseAlignment(json['alignment']),
    padding: _parseEdgeInsets(json['padding']),
    decoration: decoration ?? (color != null ? BoxDecoration(color: color) : null),
    foregroundDecoration: json['foregroundDecoration'] != null
        ? _parseDecoration(json['foregroundDecoration'])
        : null,
    width: json['width']?.toDouble(),
    height: json['height']?.toDouble(),
    constraints: _parseBoxConstraints(json['constraints']),
    margin: _parseEdgeInsets(json['margin']),
    transform: _parseTransform(json['transform']),
    transformAlignment: _parseAlignment(json['transformAlignment']),
    child: json['child'] != null
        ? WidgetFactory.buildWidgetFromJson(json['child'] as Map<String, dynamic>)
        : null,
    clipBehavior: _parseClipBehavior(json['clipBehavior']),
  );
}

// Parse Decoration function (newly added)
BoxDecoration? _parseDecoration(Map<String, dynamic>? value) {
  if (value == null) return null;
  try {
    return BoxDecoration(
      color: _parseColor(value['color']),
      borderRadius: _parseBorderRadius(value['borderRadius']),
      border: _parseBorder(value['border']),
      boxShadow: _parseBoxShadow(value['boxShadow']),
      image: _parseDecorationImage(value['image']),
    );
  } catch (e) {
    print("Error al parsear la decoración: $e");
    return null;
  }
}

BorderRadius? _parseBorderRadius(Map<String, dynamic>? value) {
  if (value == null) return null;
  return BorderRadius.only(
    topLeft: _parseRadius(value['topLeft']),
    topRight: _parseRadius(value['topRight']),
    bottomLeft: _parseRadius(value['bottomLeft']),
    bottomRight: _parseRadius(value['bottomRight']),
  );
}

Radius _parseRadius(dynamic value) {
  if (value is num) {
    return Radius.circular(value.toDouble());
  }
  return Radius.zero;
}

Border? _parseBorder(Map<String, dynamic>? value) {
  if (value == null) return null;
  return Border.all(
    color: _parseColor(value['color']) ?? Color(0xFF000000),
    width: _parseDouble(value['width']) ?? 1.0,
  );
}

List<BoxShadow>? _parseBoxShadow(List<dynamic>? value) {
  if (value == null) return null;
  return value.map((dynamic item) {
    return BoxShadow(
      color: _parseColor(item['color']) ?? Color(0x50000000),
      offset: Offset(
        _parseDouble(item['dx']) ?? 0.0,
        _parseDouble(item['dy']) ?? 0.0,
      ),
      blurRadius: _parseDouble(item['blurRadius']) ?? 10.0,
    );
  }).toList();
}

double _parseDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();  // Convierte int a double
  }
  return value ?? 0.0;  // Valor por defecto
}

DecorationImage? _parseDecorationImage(Map<String, dynamic>? value) {
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
Alignment? _parseAlignment(String? value) {
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
EdgeInsets? _parseEdgeInsets(dynamic value) {
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

// Parsear color
Color? _parseColor(dynamic value) {
  if (value == null) return null;

  if (value is String) {
    // Eliminar el símbolo '#' si está presente al principio del valor
    value = value.replaceFirst('#', '');

    // Si el color tiene 6 caracteres, agregamos 'FF' al inicio para la opacidad
    if (value.length == 6) {
      value = 'FF' + value;  // Ejemplo: 'FF5733' se convierte en 'FF5733'
    }

    // Verificamos que el valor ahora tiene 8 caracteres
    if (value.length != 8) {
      print('El valor del color no tiene la longitud esperada. Recibido: $value');
      return null;  // El valor no es un color hexadecimal válido
    }

    // Intentar convertir el valor hexadecimal a int
    try {
      // Eliminar el prefijo '0x' de la cadena antes de pasar a 'int.parse'
      return Color(int.parse('0x' + value));
    } catch (e) {
      // Si no se puede parsear el color, imprimir el error
      print('Error al parsear el color: $e');
      return null;
    }
  }

  // Si el valor no es una cadena de texto válida, devolvemos null
  print('El valor proporcionado no es una cadena de texto: $value');
  return null;
}

// Parsear BoxConstraints
BoxConstraints? _parseBoxConstraints(dynamic value) {
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

Matrix4? _parseTransform(dynamic value) {
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
Clip _parseClipBehavior(dynamic value) {
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
