import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/widget_factory.dart';


PlatformAppBar buildAppBar(Map<String, dynamic> json) {
  return PlatformAppBar(
    key: json.containsKey('key') ? Key(json['key']) : null,
    widgetKey: json.containsKey('widgetKey') ? Key(json['widgetKey']) : null,
    title: json['title'] != null
        ? WidgetFactory.buildWidgetFromJson(json['title'])
        : null,
    backgroundColor: json['backgroundColor'] != null
        ? Color(int.parse(json['backgroundColor']))
        : null,
    leading: json['leading'] != null
        ? WidgetFactory.buildWidgetFromJson(json['leading'])
        : null,
    trailingActions: json['trailingActions'] != null
        ? [
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: (json['trailingActions'] as List)
              .map((action) => WidgetFactory.buildWidgetFromJson(action))
              .toList(),
        ),
      ),
    ]
        : null,
    automaticallyImplyLeading: json['automaticallyImplyLeading'] ?? true,

    bottom: json['bottom'] != null
        ? WidgetFactory.buildWidgetFromJson(json['bottom']) as PreferredSizeWidget
        : null,
    // material: (_) => MaterialAppBarData(...),
    // cupertino: (_) => CupertinoNavigationBarData(...)

  );
}

