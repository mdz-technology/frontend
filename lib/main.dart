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

  void testino(BuildContext context) {
    print("Test function called");
    final notifier = context.read<WidgetStateNotifier>();
    notifier.updateState('abc123', DateTime.now().toString());
  }

  Map<String, dynamic> json = {
    "id": "mi_aplicacion_principal",
    "type": "material.app",
    "properties": {
      "title": "App con Navegación Completa v2",
      "initialRoute": "/",
      "debugShowCheckedModeBanner": false,
      "locale": "es_ES",
      "supportedLocales": ["es_ES", "en_US"]
    },
    "styles": {
      "color": "#4A148C"
    },
    "children": [ // RUTAS PRINCIPALES

      // --- RUTA 1: Home ("/") ---
      {
        "route": "/",
        "id": "home_screen_scaffold",
        "type": "material.scaffold",
        "styles": {"backgroundColor": "#FFFFFF"},
        "children": [
          // AppBar para Home
          {
            "id": "home_app_bar",
            "type": "material.appBar",
            "properties": { "elevation": 1.0 },
            "styles": { "backgroundColor": "#EDE7F6" },
            "children": [
              { // Título
                "slot": "material.appBar.title",
                "id": "home_title",
                "type": "multiplatform.text",
                "properties": { "data": "Inicio" } // <-- AJUSTADO
              },
              { // Acción 1
                "slot": "material.appBar.actions",
                "id": "home_action_1",
                "type": "material.iconbutton",
                "properties": {"tooltip": "Buscar"},
                "events": {"onPressed": {"action":"search_home"}},
                "children": [{"type":"multiplatform.icon", "properties": {"icon":"search"}}]
              }
            ]
          },
          // Drawer para Home
          {
            "type": "material.drawer",
            "id": "app_drawer_home",
            "children": [
              { "id": "drawer_header_1", "type": "material.listtile", "properties": {"title": { "type": "multiplatform.text", "properties": {"data": "MENÚ"}, "styles": {"fontWeight": "bold"} }}}, // <-- AJUSTADO
              { "id": "drawer_nav_home_1", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"home"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Inicio"}}}, "events": {"onTap": {"action":"navigate", "route":"/"}}}, // <-- AJUSTADO
              { "id": "drawer_nav_screen2_1", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"view_agenda"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Pantalla Anidada"}}}, "events": {"onTap": {"action":"navigate", "route":"/screen2"}}}, // <-- AJUSTADO
              { "id": "drawer_nav_screen3_1", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"settings"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Configuración"}}}, "events": {"onTap": {"action":"navigate", "route":"/screen3"}}} // <-- AJUSTADO
            ]
          },
          // Body de Home
          {
            "type": "multiplatform.container",
            "id": "home_body_container",
            "properties": {"alignment": "center"},
            "children": [
              { "id": "home_body_text", "type": "multiplatform.text", "properties": { "data": "¡Bienvenido!" } } // <-- AJUSTADO
            ]
          }
        ]
      }, // --- FIN RUTA 1 ---

      // --- RUTA 2: Screen 2 ("/screen2") con Navigator Anidado ---
      {
        "route": "/screen2",
        "id": "screen2_scaffold",
        "type": "material.scaffold",
        "styles": {"backgroundColor": "#F3E5F5"},
        "children": [
          // AppBar para Screen 2
          {
            "id": "screen2_app_bar",
            "type": "material.appBar",
            "properties": {"elevation": 0.0},
            "styles": {"backgroundColor": "#E1BEE7"},
            "children": [
              {
                "slot": "material.appBar.title",
                "id": "screen2_title",
                "type": "multiplatform.text",
                "properties": { "data": "Pantalla Anidada" } // <-- AJUSTADO
              }
            ]
          },
          // Drawer para Screen 2
          {
            "type": "material.drawer",
            "id": "app_drawer_screen2",
            "children": [
              { "id": "drawer_header_2", "type": "material.listtile", "properties": {"title": { "type": "multiplatform.text", "properties": {"data": "MENÚ"}, "styles": {"fontWeight": "bold"} }}}, // <-- AJUSTADO
              { "id": "drawer_nav_home_2", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"home"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Inicio"}}}, "events": {"onTap": {"action":"navigate", "route":"/"}}}, // <-- AJUSTADO
              { "id": "drawer_nav_screen2_2", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"view_agenda"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Pantalla Anidada"}}}, "events": {"onTap": {"action":"navigate", "route":"/screen2"}}}, // <-- AJUSTADO
              { "id": "drawer_nav_screen3_2", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"settings"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Configuración"}}}, "events": {"onTap": {"action":"navigate", "route":"/screen3"}}} // <-- AJUSTADO
            ]
          },
          // Body de Screen 2 es el Navigator Anidado
          {
            "id": "screen2_nested_navigator",
            "type": "material.navigator",
            "properties": { "initialRoute": "/" },
            "children": [ // RUTAS INTERNAS
              // --- Pantalla Interna 2A (Nivel 1) ---
              {
                "nestedRoute": "/",
                "screen": {
                  "id": "screen_2a",
                  "type": "multiplatform.column",
                  "styles": {"padding": {"all": 16.0}},
                  "properties": {"mainAxisAlignment": "start", "crossAxisAlignment": "stretch"},
                  "children": [
                    { "id": "s2a_title", "type": "multiplatform.text", "properties": {"data": "Vista A"}, "styles": {"fontSize": 18.0, "fontWeight":"bold"} }, // <-- AJUSTADO
                    { "type": "multiplatform.container", "properties": {"height": 15.0}},
                    {
                      "type": "material.card",
                      "children": [{
                        "id": "goto_2B_link", "type": "material.listtile",
                        "properties": {"title": {"type":"multiplatform.text", "properties": {"data":"Entrar a Vista B"}}, "trailing": {"type":"multiplatform.icon", "properties":{"icon":"arrow_forward_ios", "size": 16.0}}}, // <-- AJUSTADO title
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
                  "id": "screen_2b",
                  "type": "multiplatform.column",
                  "styles": {"padding": {"all": 16.0}},
                  "properties": {"mainAxisAlignment": "start", "crossAxisAlignment": "stretch"},
                  "children": [
                    { "id": "s2b_title", "type": "multiplatform.text", "properties": {"data": "Vista B"}, "styles": {"fontSize": 18.0, "fontWeight":"bold"} }, // <-- AJUSTADO
                    { "type": "multiplatform.container", "properties": {"height": 15.0}},
                    {
                      "type": "material.card",
                      "children": [{
                        "id": "goto_2C_link", "type": "material.listtile",
                        "properties": {"title": {"type":"multiplatform.text", "properties": {"data":"Entrar a Vista C"}}, "trailing": {"type":"multiplatform.icon", "properties":{"icon":"arrow_forward_ios", "size": 16.0}}}, // <-- AJUSTADO title
                        "events": {"onTap": {"action":"nested_navigate", "navigatorId":"screen2_nested_navigator", "nestedRoute":"/view_c"}}
                      }]
                    },
                    { "type": "multiplatform.container", "properties": {"height": 10.0}},
                    {
                      "type": "material.card",
                      "children": [{
                        "id": "back_to_2A_link", "type": "material.listtile",
                        "properties": {"title": {"type":"multiplatform.text", "properties": {"data":"Volver a Vista A"}}, "leading": {"type":"multiplatform.icon", "properties":{"icon":"arrow_back"}}}, // <-- AJUSTADO title
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
                  "id": "screen_2c",
                  "type": "multiplatform.column",
                  "styles": {"padding": {"all": 16.0}},
                  "properties": {"mainAxisAlignment": "start", "crossAxisAlignment": "stretch"},
                  "children": [
                    { "id": "s2c_title", "type": "multiplatform.text", "properties": {"data": "Vista C (Último Nivel)"}, "styles": {"fontSize": 18.0, "fontWeight":"bold"} }, // <-- AJUSTADO
                    { "type": "multiplatform.container", "properties": {"height": 15.0}},
                    {
                      "type":"material.card",
                      "children": [
                        {"type":"material.listtile", "properties":{"title":{"type":"multiplatform.text", "properties": {"data":"Detalle final 1"}}}} // <-- AJUSTADO title
                      ]
                    },
                    { "type": "multiplatform.container", "properties": {"height": 10.0}},
                    {
                      "type": "material.card",
                      "children": [{
                        "id": "back_to_2B_link", "type": "material.listtile",
                        "properties": {"title": {"type":"multiplatform.text", "properties": {"data":"Volver a Vista B"}}, "leading": {"type":"multiplatform.icon", "properties":{"icon":"arrow_back"}}}, // <-- AJUSTADO title
                        "events": {"onTap": {"action":"nested_pop", "navigatorId":"screen2_nested_navigator"}}
                      }]
                    }
                  ]
                }
              }
            ] // Fin children (rutas internas) del Navigator
          } // Fin del body (Navigator anidado)
        ]
      }, // --- FIN RUTA 2 ---

      // --- RUTA 3: Screen 3 ("/screen3") ---
      {
        "route": "/screen3",
        "id": "screen3_scaffold",
        "type": "material.scaffold",
        "styles": {"backgroundColor": "#E8F5E9"},
        "children": [
          // AppBar para Screen 3
          {
            "id": "screen3_app_bar",
            "type": "material.appBar",
            "styles": {"backgroundColor": "#A5D6A7"},
            "children": [
              {
                "slot": "material.appBar.title",
                "id": "screen3_title",
                "type": "multiplatform.text",
                "properties": { "data": "Configuración" } // <-- AJUSTADO
              }
            ]
          },
          // Drawer para Screen 3
          {
            "type": "material.drawer",
            "id": "app_drawer_screen3",
            "children": [
              { "id": "drawer_header_3", "type": "material.listtile", "properties": {"title": { "type": "multiplatform.text", "properties": {"data": "MENÚ"}, "styles": {"fontWeight": "bold"} }}}, // <-- AJUSTADO
              { "id": "drawer_nav_home_3", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"home"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Inicio"}}}, "events": {"onTap": {"action":"navigate", "route":"/"}}}, // <-- AJUSTADO
              { "id": "drawer_nav_screen2_3", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"view_agenda"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Pantalla Anidada"}}}, "events": {"onTap": {"action":"navigate", "route":"/screen2"}}}, // <-- AJUSTADO
              { "id": "drawer_nav_screen3_3", "type": "material.listtile", "properties": {"leading": {"type":"multiplatform.icon", "properties":{"icon":"settings"}}, "title": {"type":"multiplatform.text", "properties": {"data":"Configuración"}}}, "events": {"onTap": {"action":"navigate", "route":"/screen3"}}} // <-- AJUSTADO
            ]
          },
          // Body de Screen 3
          {
            "type": "multiplatform.container",
            "id": "screen3_body_container",
            "properties": {"alignment": "center"},
            "children": [
              { "id": "screen3_body_text", "type": "multiplatform.text", "properties": { "data": "Opciones de configuración..." } } // <-- AJUSTADO
            ]
          }
        ]
      } // --- FIN RUTA 3 ---
    ] // Fin children (rutas principales) de MaterialApp
  };

  runApp(
    PlatformProvider(
      initialPlatform: TargetPlatform.linux,
      builder: (builderContext) => MultiProvider(
        providers: [
          ChangeNotifierProvider<TextStateNotifier>(
            create: (textStateContext) {
              final textStateNotifier = TextStateNotifier();
              return textStateNotifier;
            },
          ),
          ChangeNotifierProvider<WidgetStateNotifier>(
            create: (widgetStateContext) {
              final widgetStateNotifier = WidgetStateNotifier();
              return widgetStateNotifier;
            },
          ),
          ChangeNotifierProvider<ScrollStateNotifier>(
            create: (scrollStateContext) {
              final scrollStateNotifier = ScrollStateNotifier();
              return scrollStateNotifier;
            },
          ),
          ChangeNotifierProvider<FocusNodeStateNotifier>(
            create: (focusNodeStatecontext) {
              final focusNodeStateNotifier = FocusNodeStateNotifier();
              return focusNodeStateNotifier;
            },
          ),
          ChangeNotifierProvider<NavigatorStateNotifier>(
            create: (navigatorStateContext) {
              final navigatorStateNotifier = NavigatorStateNotifier();
              return navigatorStateNotifier;
            },
          ),
        ],
        child: Builder(
            builder: (childContext) {
              return WidgetFactory.buildWidgetFromJson(childContext, json);
            }
        )
      ),
    ),
  );
}
