import 'package:flutter/widgets.dart';

Widget buildContainer(Map<String, dynamic> json) {
  return Container(
    width: json['width']?.toDouble(),
    height: json['height']?.toDouble(),
    color: json['color'] != null ? Color(int.parse(json['color'])) : null,
    /*child: Consumer<DetailProvider>(
      builder: (context, detailProvider, child) {
        final detailData = detailProvider.detailData;

// Sincronizar todos los TextEditingControllers con el detailData
        if (detailData != null) {
          WidgetFactory.textControllers.forEach((key, controller) {
            final newValue = detailData[key];
            controller.text = newValue != null ? newValue.toString() : '';
          });
        } else {
// Si no hay datos, limpiamos todos los campos
          WidgetFactory.textControllers.forEach((key, controller) {
            controller.text = '';
          });
        }

// Si existe detailData y todos sus valores son cadenas vacías, enfocamos el primer campo
        if (detailData != null &&
            detailData.values.every((value) => value.toString().isEmpty)) {
          if (WidgetFactory.textControllers.isNotEmpty) {
            final firstKey = WidgetFactory.textControllers.keys.first;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              WidgetFactory.getFocusNode(firstKey).requestFocus();
            });
          }
        }

        final currentId = detailProvider.currentId;
        final combinedData = {...?detailData, "id": currentId};

        final detailJson = replacePlaceholders(json['child'], combinedData);

        return WidgetFactory.buildWidgetFromJson(detailJson);
      },
    ),*/
  );
}

Map<String, dynamic> replacePlaceholders(    Map<String, dynamic> template, Map<String, dynamic> data) {
  String replacePlaceholdersInString(String value) {
    data.forEach((key, val) {
      value = value.replaceAll("{{${key}}}", val.toString());
    });
    return value;
  }

  Map<String, dynamic> traverseAndReplace(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value is String) {
        json[key] = replacePlaceholdersInString(value);
      } else if (value is Map) {
        json[key] = traverseAndReplace(Map<String, dynamic>.from(value));
      } else if (value is List) {
        json[key] = value.map((item) {
          if (item is Map) {
            return traverseAndReplace(Map<String, dynamic>.from(item));
          }
          if (item is String) {
            return replacePlaceholdersInString(item);
          }
          return item;
        }).toList();
      }
    });
    return json;
  }

  return traverseAndReplace(Map<String, dynamic>.from(template));
}

