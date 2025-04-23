import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/utils.dart';

import 'cupertino_drawer.dart';

Widget buildDrawer(BuildContext context, Map<String, dynamic> json) {
  final styles = json['styles'] ?? {};
  final properties = json['properties'] ?? {};
  final childrenJson = json['children'] as List<dynamic>? ?? [];

  if (Platform.isIOS) {
    return CustomCupertinoDrawer(json: json);
  }

  return Drawer(
    key: json.containsKey('id') ? Key(json['id']) : null,
    backgroundColor: styles['backgroundColor'] != null
        ? parseColor(styles['backgroundColor'])
        : null,
    elevation: (properties['elevation'] as num?)?.toDouble() ?? 16.0,
    shadowColor: styles['shadowColor'] != null
        ? parseColor(styles['shadowColor'])
        : null,
    surfaceTintColor: styles['surfaceTintColor'] != null
        ? parseColor(styles['surfaceTintColor'])
        : null,
    width: (properties['width'] as num?)?.toDouble(),
    clipBehavior: _parseClipBehavior(properties['clipBehavior']),
    semanticLabel: properties['semanticLabel'],
    child: ListView(
      padding: EdgeInsets.zero,
      children: childrenJson
          .map((childJson) => WidgetFactory.buildWidgetFromJson(context, childJson))
          .toList(),
    ),
  );
}



Clip? _parseClipBehavior(String? value) {
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
      return null;
  }
}

/*
{
  "type": "Drawer",
  "id": "gmail_style_drawer",
  "styles": {
    "backgroundColor": "#FFFFFF"
  },
  "properties": {
    "elevation": 8,
    "clipBehavior": "antiAlias",
    "semanticLabel": "Main menu"
  },
  "children": [
    {
      "type": "Text",
      "properties": {
        "text": "Inbox"
      }
    },
    {
      "type": "Text",
      "properties": {
        "text": "Sent"
      }
    }
  ]
}

* */