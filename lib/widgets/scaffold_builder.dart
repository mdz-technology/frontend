import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/widget_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildScaffold(Map<String, dynamic> json) {
  return PlatformScaffold(
    key: json.containsKey('key') ? Key(json['key']) : null,
    widgetKey: json.containsKey('widgetKey') ? Key(json['widgetKey']) : null,

    body: json['body'] != null
        ? WidgetFactory.buildWidgetFromJson(json['body'])
        : null,

    backgroundColor: json['backgroundColor'] != null
        ? Color(int.parse(json['backgroundColor']))
        : null,

    appBar: json['appBar'] != null
        ? WidgetFactory.buildWidgetFromJson(json['appBar']) as PlatformAppBar
        : null,

    bottomNavBar: json['bottomNavBar'] != null
        ? buildNavBar(json['bottomNavBar'])
        : null,

    iosContentPadding: json['iosContentPadding'] ?? false,
    iosContentBottomPadding: json['iosContentBottomPadding'] ?? false,

    // material: (_) => MaterialScaffoldData(...),
    // cupertino: (_) => CupertinoPageScaffoldData(...),

    // cupertinoTabChildBuilder: json['cupertinoTabChildBuilder'] != null
    //     ? (context, index) => buildWidgetFromJson(json['cupertinoTabChildBuilder'][index])
    //     : null,
  );
}

PlatformNavBar buildNavBar(Map<String, dynamic> json) {
  return PlatformNavBar(
    widgetKey: json.containsKey('widgetKey') ? Key(json['widgetKey']) : null,
    backgroundColor: json['backgroundColor'] != null
        ? Color(int.parse(json['backgroundColor']))
        : null,
    items: json['items'] != null
        ? (json['items'] as List)
        .map((itemJson) => buildNavBarItem(itemJson))
        .toList()
        : [],
    currentIndex: json['currentIndex'] ?? 0,
    itemChanged: (index) {
      // Lógica para manejar el cambio de índice si es necesario
    },
    height: json['height'] ?? 56.0, // Agregado un valor por defecto de 56.0
    // material: (_) => MaterialNavBarData(...),
    // cupertino: (_) => CupertinoNavBarData(...),
  );
}

BottomNavigationBarItem buildNavBarItem(Map<String, dynamic> json) {
  return BottomNavigationBarItem(
    key: json['key'] != null ? Key(json['key']) : null,
    icon: json['icon'] != null
        ? WidgetFactory.buildWidgetFromJson(json['icon'])
        : const SizedBox.shrink(), // ícono por defecto si falta
    activeIcon: json['activeIcon'] != null
        ? WidgetFactory.buildWidgetFromJson(json['activeIcon'])
        : null, // opcional
    label: json['label'] ?? '', // etiqueta por defecto vacía
    tooltip: json['tooltip'],
    backgroundColor: json['backgroundColor'] != null
        ? Color(int.parse(json['backgroundColor']))
        : null, // opcional
  );
}