import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:frontend/comm/rust_launcher.dart';
import 'package:frontend/widgets/widget_state_notifier.dart';
import 'package:frontend/widgets/app_builder.dart';
import 'package:provider/provider.dart';

import 'comm/sender.dart';
import 'comm/sender_impl.dart';

void main() {

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

  // JSON con la estructura de PlatformApp
  Map<String, dynamic> json = {
    "type": "App",
    "backgroundColor": "0xFFFFFFFF",
    "initialRoute": "/",
    "routes": {
      "/": {
        "type": "Scaffold",
        "backgroundColor": "0xFFFFFFFF",
        "iosContentPadding": true,
        "appBar": {
          "type": "AppBar",
          "title": {
            "type": "Text",
            "data": "Mi AppBar Plataforma",
            "style": {
                "color": "0xFFFFFFFF"
            }
          },
          "backgroundColor": "0xFF2196F3",
          "automaticallyImplyLeading": true,
          "titleCentered": true,
          "leading": {
            "type": "Icon",
            "icon": "Icons.menu"
          },
          "trailingActions": [
            {
              "type": "Icon",
              "icon": "Icons.search"
            },
            {
              "type": "Icon",
              "icon": "Icons.more_vert"
            }
          ]
        },
        "body": {
          "type": "Center",
          "child": {
            "type": "Column",
            "mainAxisAlignment": "center",
            "children": [
              {
                "type": "Text",
                "data": "Hola mundo",
                "textAlign": "center",
                "textScaleFactor": 1.2,
                "textDirection": "ltr",
                "locale": "es",
                "style": {
                  "fontSize": 20,
                  "fontWeight": "w600",
                  "color": "#FF0000"
                }
              },
              {
                "type": "ElevatedButton",
                "child": {
                  "type": "Text",
                  "data": "Presióname"
                },
                "color": "#4CAF50",
                "padding": 12,
                "borderRadius": 12
              },



              {
                "type": "Container",
                "key": "containerKey123",
                "alignment": "center",
                "padding": {
                  "left": 10,
                  "top": 20,
                  "right": 10,
                  "bottom": 20
                },
                "color": "#FF5733",  // Color naranja
                "decoration": {
                  "color": "#FF5733",  // Color de fondo para la decoración
                  "borderRadius": {
                    "topLeft": 10,
                    "topRight": 10,
                    "bottomLeft": 10,
                    "bottomRight": 10
                  },
                  "border": {
                    "color": "#000000",  // Color del borde
                    "width": 2
                  },
                  "boxShadow": [
                    {
                      "color": "#000000",
                      "dx": 5,
                      "dy": 5,
                      "blurRadius": 10
                    }
                  ]
                },
                /*"foregroundDecoration": {
                  "color": "#B0B0B0"
                },*/
                "width": 500,
                "height": 200,
                "constraints": {
                  "maxWidth": 500,
                  "maxHeight": 200
                },
                "margin": {
                  "left": 20,
                  "top": 20,
                  "right": 20,
                  "bottom": 20
                },
                /*"transform": [1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],*/
                "transformAlignment": "center",
                "child":
                {
                  "id": "lista_dinamica_1",
                  "type": "ListView",
                  "styles": {},
                  "events": {},
                  "properties": {
                    "direction": "vertical",
                    "reverse": false,
                    "shrinkWrap": true,
                    "padding": {
                      "left": 16,
                      "top": 8,
                      "right": 16,
                      "bottom": 8
                    },
                    "addAutomaticKeepAlives": true,
                    "addRepaintBoundaries": true,
                    "addSemanticIndexes": true,
                    "cacheExtent": 200,
                    "semanticChildCount": 2,
                    "dragStartBehavior": "start",
                    "keyboardDismissBehavior": "onDrag",
                    "clipBehavior": "hardEdge",
                    "hitTestBehavior": "deferToChild"
                  },
                  "children": []
                },
                "clipBehavior": "antiAlias"
              },

              {
                "type": "Card",
                "id": "card1",
                "properties": {
                  "padding": {
                    "left": 12,
                    "right": 12,
                    "top": 8,
                    "bottom": 8
                  }
                },
                "children": [
                  {
                    "type": "Text",
                    "properties": {
                      "text": "Bienvenido al Card"
                    }
                  },
                  {
                    "type": "Text",
                    "properties": {
                      "text": "Otro contenido dentro del card"
                    }
                  }
                ]
              }


              /*{
                "type": "ListView",
                "scrollDirection": "vertical",
                "reverse": false,
                "shrinkWrap": true,
                "padding": {
                  "left": 16,
                  "top": 8,
                  "right": 16,
                  "bottom": 8
                },
                "addAutomaticKeepAlives": true,
                "addRepaintBoundaries": true,
                "addSemanticIndexes": true,
                "cacheExtent": 200,
                "semanticChildCount": 2,
                "dragStartBehavior": "start",
                "keyboardDismissBehavior": "onDrag",
                "clipBehavior": "hardEdge",
                "hitTestBehavior": "deferToChild",
                "children": [
                  {
                    "type": "Text",
                    "data": "Item 1"
                  },
                  {
                    "type": "Text",
                    "data": "Item 2"
                  }
                ]
              }*/
            ]
          }
        },
        "bottomNavBar": {
          "type": "PlatformNavBar",
          "items": [
            {
              "icon": {
                "type": "Icon",
                "icon": "Icons.home"
              },
              "activeIcon": {
                "type": "Icon",
                "icon": "Icons.home_filled"
              },
              "label": "Home",
              "tooltip": "Ir a Inicio",
              "backgroundColor": "0xFF2196F3",
              "key": "home_nav_item"
            },
            {
              "icon": {
                "type": "Icon",
                "icon": "Icons.search"
              },
              "label": "Search"
            }
          ]
        }
      }
    }
  };

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final widgetStateNotifier = WidgetStateNotifier();
        // Iniciar generación de datos para los widgets
        widgetStateNotifier.generateTestData("lista_dinamica_1");
        return widgetStateNotifier;
      },
      child: buildApp(json),
    ),
  );


}
