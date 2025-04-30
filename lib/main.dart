import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/comm/rust_launcher.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/material_app_builder.dart';
import 'package:frontend/widgets/material_appbar_builder.dart';
import 'package:frontend/widgets/material_drawer_builder.dart';
import 'package:frontend/widgets/material_iconbutton.dart';
import 'package:frontend/widgets/material_scaffold_builder.dart';
import 'package:frontend/widgets/multiplatform_container_builder.dart';
import 'package:frontend/widgets/multiplatform_icon_builder.dart';
import 'package:frontend/widgets/multiplatform_row_builder.dart';
import 'package:frontend/widgets/multiplatform_text_builder.dart';
import 'package:frontend/widgets/widget_state_notifier.dart';
import 'package:provider/provider.dart';

import 'comm/sender.dart';
import 'comm/sender_impl.dart';

void main() {
  MaterialAppBuilder.register();
  MaterialScaffoldBuilder.register();
  MaterialAppBarBuilder.register();
  MaterialDrawerBuilder.register();

  MultiplatformTextBuilder.register();
  MultiplatformContainerBuilder.register();
  MultiplatformRowBuilder.register();

  IconButtonBuilder.register();
  MultiplatformIconBuilder.register();

  launchRust();
  Isolate.spawn((_) {
    int counter = 1;
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      String msg = "Mensaje $counter enviado";
      Sender sender = SenderImpl();
      sender.send(msg);
      counter++;
    });
  }, null);

  Map<String, dynamic> json = {
    "id": "app_01",
    "type": "material.app",
    "styles": {"color": "#FF0000"},
    "properties": {
      "title": "Mi Super App",
      "initialRoute": "/",
      "locale": "es_ES",
      "supportedLocales": ["es_ES", "en_US"],
      "debugShowCheckedModeBanner": false,
      "showPerformanceOverlay": false,
      "checkerboardRasterCacheImages": false,
      "checkerboardOffscreenLayers": false,
      "showSemanticsDebugger": false,
      "restorationScopeId": "restoScope123",
    },
    "children": [
      {
        "id": "scaffold_1",
        "route": "/",
        "type": "material.scaffold",
        "styles": {
          "backgroundColor": "#FFFFFF",
        },
        "properties": {},
        "children": [
          {
            "type": "material.appBar",
            "children": [
              {
                "id": "appbar.title.id",
                "type": "multiplatform.text",
                "slot": "material.appBar.title",
                "data": "Opción Drawer 1",
              },
              {
                "slot": "material.appBar.actions",
                "id": "add_button",
                "type": "material.iconbutton",
                "properties": {
                  "tooltip": "Añadir elemento",
                  "iconSize": 28.0
                },
                "events": {
                  "onPressed": {
                    "action": "addItem",
                    "message": "user_wants_to_add"
                  }
                },
                "children": [
                  {
                    "type": "multiplatform.icon",
                    "properties": {
                      "icon": "add"
                    }
                  }
                ]
              },
              {
                "slot": "material.appBar.actions",
                "id": "delete_button",
                "type": "material.iconbutton",
                "properties": {
                  "tooltip": "Eliminar elemento",
                  "iconSize": 28.0
                },
                "events": {
                  "onPressed": {
                    "action": "deleteItem",
                    "message": "user_wants_to_delete"
                  }
                },
                "children": [
                  {
                    "type": "multiplatform.icon",
                    "properties": {
                      "icon": "delete"
                    }
                  }
                ]
              }
            ]
          },
          /*{
            "type": "BottomNavBar",
          },*/
          {
            "type": "multiplatform.container",
            "styles": {
              "backgroundColor": "#008000",
            },
          },
          {
            "type": "material.drawer",
            "id": "mi_drawer",
            "styles": {"backgroundColor": "#FF0000"},
            "children": [
              {"type": "multiplatform.text", "data": "Opción Drawer 1"},
              {"type": "multiplatform.text", "data": "Opción Drawer 2"}
            ]
          },
        ]
      }
    ]
  };

  runApp(
    PlatformProvider(
      initialPlatform: TargetPlatform.iOS,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              final widgetStateNotifier = WidgetStateNotifier();
              widgetStateNotifier.generateTestData("lista_dinamica_1");
              return widgetStateNotifier;
            },
          ),
        ],
        child: WidgetFactory.buildWidgetFromJson(context, json),
      ),
    ),
  );
}
