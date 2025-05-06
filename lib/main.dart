import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/comm/rust_launcher.dart';
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
                "properties": {"tooltip": "Añadir elemento", "iconSize": 28.0},
                "events": {
                  "onPressed": {
                    "action": "addItem",
                    "message": "user_wants_to_add"
                  }
                },
                "children": [
                  {
                    "type": "multiplatform.icon",
                    "properties": {"icon": "add"}
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
                    "properties": {"icon": "delete"}
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
            //"styles": {
            //"backgroundColor": "#008000",
            //},
            "children": [
              {
                "id": "login_email_field",
                "type": "material.textfield",
                "properties": {
                  "initialValue": "",
                  "keyboardType": "emailAddress",
                  "textInputAction": "next",
                  "autocorrect": false,
                  "enableSuggestions": false,
                  "autofillHints": ["email", "username"],
                  "enabled": true,
                  "maxLines": 1,
                  "maxLength": 100
                },
                "styles": {
                  "cursorColor": "#1976D2",
                  "decoration": {
                    "labelText": "Correo Electrónico",
                    "hintText": "tu.correo@ejemplo.com",
                    "helperText": "Ingresa tu correo para iniciar sesión",
                    "filled": true,
                    "fillColor": "#F5F5F5",
                    "prefixIcon": {
                      "type": "multiplatform.icon",
                      "properties": {"icon": "email"},
                      "styles": {"color": "#616161"}
                    },
                    "suffixIcon": {
                      "id": "email_clear_button",
                      "type": "material.iconbutton",
                      "properties": {
                        "tooltip": "Limpiar campo",
                        "enabled": true
                      },
                      "styles": {"padding": 0},
                      "events": {
                        "onPressed": {
                          "action": "clear_field",
                          "targetWidgetId": "login_email_field"
                        }
                      },
                      "children": [
                        {
                          "type": "multiplatform.icon",
                          "properties": {"icon": "clear"},
                          "styles": {"size": 20.0, "color": "#9E9E9E"}
                        }
                      ]
                    },
                    "border": {
                      "type": "outline",
                      "color": "#BDBDBD",
                      "width": 1.0,
                      "borderRadius": {"all": 8.0}
                    },
                    "focusedBorder": {
                      "type": "outline",
                      "color": "#1976D2",
                      "width": 2.0,
                      "borderRadius": {"all": 8.0}
                    },
                    "enabledBorder": {
                      "type": "outline",
                      "color": "#BDBDBD",
                      "width": 1.0,
                      "borderRadius": {"all": 8.0}
                    },
                    "errorBorder": {
                      "type": "outline",
                      "color": "#D32F2F",
                      "width": 1.5,
                      "borderRadius": {"all": 8.0}
                    },
                    "focusedErrorBorder": {
                      "type": "outline",
                      "color": "#D32F2F",
                      "width": 2.0,
                      "borderRadius": {"all": 8.0}
                    },
                    "contentPadding": {"horizontal": 12.0, "vertical": 16.0},
                    "labelStyle": {"color": "#616161"},
                    "hintStyle": {"color": "#9E9E9E"}
                  }
                },
                "events": {
                  "onChanged": {"action": "update_login_email"},
                  "onSubmitted": {"action": "attempt_login"}
                }
              }
            ]
          },
          {
            "type": "material.drawer",
            "id": "mi_drawer",
            "styles": {"backgroundColor": "#FF0000"},
            "children": [
              {"id":"abc123","type": "multiplatform.text", "data": "Opción Drawer 1"},
              {"type": "multiplatform.text", "data": "Opción Drawer 2"},
              {
                "type": "multiplatform.container", // O multiplatform.column
                "properties": {"height": 300.0},
                "styles": {"backgroundColor": "#FFFF00"},
                "children": [
                  {
                    "id": "my_product_list",
                    "type": "material.listview",
                    "properties": {
                      "shrinkWrap": true
                    },
                    "styles": {
                      "padding": {"vertical": 10.0, "horizontal": 8.0},
                      "physics": "bouncing" // Usa BouncingScrollPhysics
                    },
                    "children": [
                      {
                        "id": "item_1",
                        "type": "material.card",
                        "children": [
                          {
                            "id": "item_1_content",
                            "type": "material.listtile",
                            "properties": {
                              "leading": {
                                "type": "multiplatform.icon",
                                "properties": {"icon": "shopping_bag"}
                              },
                              "title": {
                                "type": "multiplatform.text",
                                "data": "Producto Increíble 1"
                              },
                              "subtitle": {
                                "type": "multiplatform.text",
                                "data": "19.99"
                              }
                            },
                            "events": {
                              "onTap": {
                                "action": "view_product",
                                "productId": "prod_123"
                              }
                            }
                          }
                        ]
                      },
                      {
                        "id": "item_2",
                        "type": "material.card",
                        "children": [
                          {
                            "id": "item_2_content",
                            "type": "material.listtile",
                            "properties": {
                              "leading": {
                                "type": "multiplatform.icon",
                                "properties": {"icon": "star"}
                              },
                              "title": {
                                "type": "multiplatform.text",
                                "data": "Oferta Especial 2"
                              },
                              "subtitle": {
                                "type": "multiplatform.text",
                                "data": "9.99 - ¡Solo hoy!"
                              }
                            },
                            "events": {
                              "onTap": {
                                "action": "view_product",
                                "productId": "prod_456"
                              }
                            }
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          },
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
        ],
        child: WidgetFactory.buildWidgetFromJson(context, json),
      ),
    ),
  );
}
