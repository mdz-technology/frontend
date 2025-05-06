import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/comm/rust_launcher.dart';
import 'package:frontend/state_notifier/navigator_state_notifier.dart';
import 'package:frontend/state_notifier/scroll_state_notifier.dart';
import 'package:frontend/state_notifier/text_state_notifier.dart';
import 'package:frontend/state_notifier/widget_state_notifier.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/state_notifier/focusnode_state_notifier.dart';
import 'package:frontend/widgets/material/material_app_builder.dart';
import 'package:frontend/widgets/material/material_appbar_builder.dart';
import 'package:frontend/widgets/material/material_card_builder.dart';
import 'package:frontend/widgets/material/material_drawer_builder.dart';
import 'package:frontend/widgets/material/material_iconbutton.dart';
import 'package:frontend/widgets/material/material_listtitle_builder.dart';
import 'package:frontend/widgets/material/material_listview_builder.dart';
import 'package:frontend/widgets/material/material_scaffold_builder.dart';
import 'package:frontend/widgets/material/material_textfield_builder.dart';
import 'package:frontend/widgets/multiplatform/multiplatform_column_builder.dart';
import 'package:frontend/widgets/multiplatform/multiplatform_container_builder.dart';
import 'package:frontend/widgets/multiplatform/multiplatform_expanded_builder.dart';
import 'package:frontend/widgets/multiplatform/multiplatform_flexible_builder.dart';
import 'package:frontend/widgets/multiplatform/multiplatform_icon_builder.dart';
import 'package:frontend/widgets/material/material_navigator_builder.dart';
import 'package:frontend/widgets/multiplatform/multiplatform_row_builder.dart';
import 'package:frontend/widgets/multiplatform/multiplatform_text_builder.dart';
import 'package:provider/provider.dart';

import 'comm/sender.dart';
import 'comm/sender_impl.dart';

void testino(BuildContext context) {
  print("Test function called");
  final notifier = context.read<WidgetStateNotifier>();
  notifier.updateState('abc123', DateTime.now().toString());
}

void main() {
  MaterialAppBuilder.register();
  MaterialScaffoldBuilder.register();
  MaterialAppBarBuilder.register();
  MaterialDrawerBuilder.register();
  MaterialTextFieldBuilder.register();

  MultiplatformTextBuilder.register();
  MultiplatformContainerBuilder.register();
  MultiplatformRowBuilder.register();
  MultiplatformColumnBuilder.register();
  IconButtonBuilder.register();
  MultiplatformIconBuilder.register();
  MaterialListViewBuilder.register();
  MultiplatformExpandedBuilder.register();
  MultiplatformFlexibleBuilder.register();
  MaterialCardBuilder.register();
  MaterialListTileBuilder.register();
  MaterialNavigatorBuilder.register();
  
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
    "id": "mi_aplicacion_principal",
    "type": "material.app",
    "properties": {
      "title": "App con Navegación Compleja",
      "initialRoute": "/",
      "debugShowCheckedModeBanner": false
    },
    "styles": {
      "color": "#6200EE" // Color primario de la app
    },
    "children": [ // RUTAS PRINCIPALES
      // --- PANTALLA 1 (Home) ---
      {
        "route": "/",
        "id": "home_screen_scaffold",
        "type": "material.scaffold",
        "children": [
          {
            "type": "material.appBar",
            "properties": {
              "title": { "type": "multiplatform.text", "data": "Pantalla Principal" }
            }
          },
          {
            "type": "material.drawer",
            "id": "app_drawer_home",
            "children": [
              { "type": "material.listtile", "properties": {"title": { "type": "multiplatform.text", "data": "MENÚ"}}},
              { "id": "drawer_to_home_1", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"home"}}, "title": {"type":"multiplatform.text", "data":"Inicio"}}, "events": {"onTap": {"action":"navigate", "route":"/"}}},
              { "id": "drawer_to_screen2_1", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"view_agenda"}}, "title": {"type":"multiplatform.text", "data":"Pantalla 2 (Anidada)"}}, "events": {"onTap": {"action":"navigate", "route":"/screen2"}}},
              { "id": "drawer_to_screen3_1", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"settings"}}, "title": {"type":"multiplatform.text", "data":"Pantalla 3"}}, "events": {"onTap": {"action":"navigate", "route":"/screen3"}}}
            ]
          },
          { // Body de la pantalla Home
            "type": "multiplatform.container",
            "properties": {"alignment": "center"}, // Para centrar el texto
            "children": [
              { "type": "multiplatform.text", "data": "Bienvenido a la Pantalla Principal" }
            ]
          }
        ]
      },
      // --- PANTALLA 2 (Con Navegación Interna) ---
      {
        "route": "/screen2",
        "id": "screen2_scaffold",
        "type": "material.scaffold",
        "children": [
          {
            "type": "material.appBar",
            "properties": {
              "title": { "type": "multiplatform.text", "data": "Pantalla 2" }
              // El botón de "atrás" aquí será manejado por el Navigator anidado o el principal
            }
          },
          {
            "type": "material.drawer",
            "id": "app_drawer_screen2", // Mismos items para consistencia
            "children": [
              { "type": "material.listtile", "properties": {"title": { "type": "multiplatform.text", "data": "MENÚ"}}},
              { "id": "drawer_to_home_2", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"home"}}, "title": {"type":"multiplatform.text", "data":"Inicio"}}, "events": {"onTap": {"action":"navigate", "route":"/"}}},
              { "id": "drawer_to_screen2_2", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"view_agenda"}}, "title": {"type":"multiplatform.text", "data":"Pantalla 2 (Anidada)"}}, "events": {"onTap": {"action":"navigate", "route":"/screen2"}}},
              { "id": "drawer_to_screen3_2", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"settings"}}, "title": {"type":"multiplatform.text", "data":"Pantalla 3"}}, "events": {"onTap": {"action":"navigate", "route":"/screen3"}}}
            ]
          },
          { // Body de Screen 2 es el Navigator Anidado
            "id": "screen2_nested_navigator", // ID único para este navigator
            "type": "material.navigator",    // Usa tu MaterialNavigatorBuilder
            "properties": {
              "initialRoute": "/"           // Ruta inicial DENTRO de este navigator anidado
            },
            "children": [ // Hijos del Navigator: Definiciones de RUTAS INTERNAS
              // --- Pantalla Interna 2A (Nivel 1) ---
              {
                "nestedRoute": "/", // Ruta relativa al navigator anidado
                "screen": {         // Definición de la pantalla para esta ruta interna
                  "id": "screen2_view_A",
                  "type": "multiplatform.column",
                  "styles": {"padding": {"all": 16.0}},
                  "properties": {"mainAxisAlignment": "start", "crossAxisAlignment":"stretch"},
                  "children": [
                    { "type": "multiplatform.text", "data": "Pantalla 2 - Vista A", "style": {"fontSize": 20.0, "fontWeight": "bold"} },
                    { "type": "multiplatform.container", "properties": {"height": 20.0}},
                    {
                      "type": "material.card", // Usamos Card + ListTile como botón
                      "children": [{
                        "id": "goto_2B_button",
                        "type": "material.listtile",
                        "properties": {"title": {"type":"multiplatform.text", "data":"Ir a Vista Interna B"}, "leading": {"type":"multiplatform.icon", "properties":{"icon":"arrow_forward"}}},
                        "events": {"onTap": {"action":"nested_navigate", "navigatorId":"screen2_nested_navigator", "nestedRoute":"/view_b"}}
                      }]
                    }
                  ]
                }
              },
              // --- Pantalla Interna 2B (Nivel 2) ---
              {
                "nestedRoute": "/view_b",
                "screen": {
                  "id": "screen2_view_B",
                  "type": "multiplatform.column",
                  "styles": {"padding": {"all": 16.0}, "backgroundColor": "#FFFDE7"},
                  "properties": {"mainAxisAlignment": "start", "crossAxisAlignment":"stretch"},
                  "children": [
                    { "id": "s2b_title", "type": "multiplatform.text", "data": "Pantalla 2 - Vista B", "style": {"fontSize": 20.0, "fontWeight": "bold"} },
                    { "type": "multiplatform.container", "properties": {"height": 20.0}},
                    {
                      "id": "action_card_1",
                      "type": "material.card",
                      "children": [{
                        "id": "goto_2C_button",
                        "type": "material.listtile",
                        "properties": {"title": {"type":"multiplatform.text", "data":"Ir a Vista Interna C"}, "leading": {"type":"multiplatform.icon", "properties":{"icon":"arrow_forward"}}},
                        "events": {"onTap": {"action":"nested_navigate", "navigatorId":"screen2_nested_navigator", "nestedRoute":"/view_c"}}
                      }]
                    },
                    { "type": "multiplatform.container", "properties": {"height": 10.0}},
                    {
                      "id": "action_card_2",
                      "type": "material.card",
                      "children": [{
                        "id": "back_to_2A_button",
                        "type": "material.listtile",
                        "properties": {"title": {"type":"multiplatform.text", "data":"Volver a Vista A"}, "leading": {"type":"multiplatform.icon", "properties":{"icon":"arrow_back"}}},
                        "events": {"onTap": {"action":"nested_pop", "navigatorId":"screen2_nested_navigator"}}
                      }]
                    }
                  ]
                }
              },
              // --- Pantalla Interna 2C (Nivel 3) ---
              {
                "nestedRoute": "/view_c",
                "screen": {
                  "id": "screen2_view_C",
                  "type": "multiplatform.column",
                  "styles": {"padding": {"all": 16.0}, "backgroundColor": "#E0F7FA"},
                  "properties": {"mainAxisAlignment": "start", "crossAxisAlignment":"stretch"},
                  "children": [
                    { "type": "multiplatform.text", "data": "Pantalla 2 - Vista C (Final Interna)", "style": {"fontSize": 20.0, "fontWeight": "bold"} },
                    { "type": "multiplatform.container", "properties": {"height": 20.0}},
                    {
                      "type": "material.card",
                      "children": [{
                        "id": "back_to_2B_button",
                        "type": "material.listtile",
                        "properties": {"title": {"type":"multiplatform.text", "data":"Volver a Vista B"}, "leading": {"type":"multiplatform.icon", "properties":{"icon":"arrow_back"}}},
                        "events": {"onTap": {"action":"nested_pop", "navigatorId":"screen2_nested_navigator"}}
                      }]
                    }
                  ]
                }
              }
            ] // Fin de children (rutas internas) del Navigator
          } // Fin del body (Navigator anidado)
        ]
      },
      // --- PANTALLA 3 (Settings) ---
      {
        "route": "/screen3",
        "id": "screen3_scaffold",
        "type": "material.scaffold",
        "children": [
          {
            "type": "material.appBar",
            "properties": {
              "title": { "type": "multiplatform.text", "data": "Pantalla 3 (Config)" }
            }
          },
          {
            "type": "material.drawer",
            "id": "app_drawer_screen3",
            "children": [
              { "type": "material.listtile", "properties": {"title": { "type": "multiplatform.text", "data": "MENÚ"}}},
              { "id": "drawer_to_home_3", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"home"}}, "title": {"type":"multiplatform.text", "data":"Inicio"}}, "events": {"onTap": {"action":"navigate", "route":"/"}}},
              { "id": "drawer_to_screen2_3", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"view_agenda"}}, "title": {"type":"multiplatform.text", "data":"Pantalla 2 (Anidada)"}}, "events": {"onTap": {"action":"navigate", "route":"/screen2"}}},
              { "id": "drawer_to_screen3_3", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"settings"}}, "title": {"type":"multiplatform.text", "data":"Pantalla 3"}}, "events": {"onTap": {"action":"navigate", "route":"/screen3"}}}
            ]
          },
          { // Body de la pantalla Settings
            "type": "multiplatform.container",
            "properties": {"alignment": "center"},
            "children": [
              { "type": "multiplatform.text", "data": "Contenido de la Pantalla 3 (Configuración)" }
            ]
          }
        ]
      }
    ]
  };

  runApp(
    PlatformProvider(
      initialPlatform: TargetPlatform.linux,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<TextStateNotifier>(
            create: (context) {
              final textStateNotifier = TextStateNotifier();
              return textStateNotifier;
            },
          ),
          ChangeNotifierProvider<WidgetStateNotifier>(
            create: (context) {
              final widgetStateNotifier = WidgetStateNotifier();
              return widgetStateNotifier;
            },
          ),
          ChangeNotifierProvider<ScrollStateNotifier>(
            create: (context) {
              print("Creating ScrollStateNotifier...");
              return ScrollStateNotifier();
            },
          ),
          ChangeNotifierProvider<FocusNodeStateNotifier>(
            create: (context) {
              print("Creating FocusNodeStateNotifier...");
              return FocusNodeStateNotifier();
            },
          ),
          ChangeNotifierProvider<NavigatorStateNotifier>(
            create: (context) {
              print("Creating NavigatorStateNotifier...");
              return NavigatorStateNotifier();
            },
          ),
        ],
        child: WidgetFactory.buildWidgetFromJson(context, json),
      ),
    ),
  );
}
