import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/comm/rust_launcher.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/appbar_builder.dart';
import 'package:frontend/widgets/container_builder.dart';
import 'package:frontend/widgets/drawer_state.dart';
import 'package:frontend/widgets/scaffold_builder.dart';
import 'package:frontend/widgets/text_builder.dart';
import 'package:frontend/widgets/widget_state_notifier.dart';
import 'package:frontend/widgets/done/app_builder.dart';
import 'package:provider/provider.dart';

import 'comm/sender.dart';
import 'comm/sender_impl.dart';
import 'drawer_builder.dart';

void main() {
  AppBuilder.register();
  ScaffoldBuilder.register();
  AppBarBuilder.register();
  TextBuilder.register();
  DrawerBuilder.register();
  ContainerBuilder.register();

  /*launchRust();

  Isolate.spawn((_) {
    int counter = 1;
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      String msg = "Mensaje $counter enviado";
      Sender sender = SenderImpl();
      sender.send(msg);
      counter++;
    });
  }, null);*/

  // JSON con la estructura de PlatformApp
  Map<String, dynamic> json = {
    "type": "app",
    "id": "app_01",
    "children": [
      {
        "path": "/",
        "type": "scaffold",
        "id": "scaffold_1",
        "styles": {
          "backgroundColor": "#FFFFFF",
        },
        "properties": {},
        "children": [
          {
            "type": "appBar",
            "title": {"type": "text", "data": "Mi AppBar Plataforma"},
          },
          /*{
            "type": "BottomNavBar",
          },
          {
            "type": "Container"
          },*/
          {
            "type": "drawer",
            "id": "mi_drawer",
            "styles": {"backgroundColor": "#FF0000"},
            "properties": {"width": 350}, // Ancho opcional
            "children": [
              {"type": "text", "data": "Opción Drawer 1"},
              {"type": "text", "data": "Opción Drawer 2"}
            ]
          },
        ]
      },
      /*{
        "path": "/inicio",
        "type": "Scaffold",
      }*/
    ],
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
      "material": false,
      "cupertino": true
    }
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
          ChangeNotifierProvider(
            // <-- Añade el proveedor para DrawerState
            create: (_) => DrawerState(),
          ),
        ],
        child: WidgetFactory.buildWidgetFromJson(context, json),
      ),
    ),
  );
}
