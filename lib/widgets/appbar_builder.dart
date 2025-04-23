// widgets/appbar_builder.dart (Versión Final con GlobalKey y Prints de Debug)

import 'package:flutter/material.dart'; // Necesario para Theme, Scaffold, Icons, GlobalKey, etc.
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/widget_factory.dart'; // Asegúrate que la ruta sea correcta
import 'package:frontend/widgets/utils.dart'; // Para parseColor

// Importa el archivo del drawer para poder referenciar el tipo público del State
// Asegúrate que la ruta y el nombre de la clase State (CustomCupertinoDrawerState) sean correctos.
import 'package:frontend/widgets/custom_cupertino_drawer.dart';

// Ya no necesitamos Provider para el toggle aquí
// import 'package:provider/provider.dart';
// import 'package:frontend/widgets/drawer_state.dart';


class AppBarBuilder {
  static void register() {
    WidgetFactory.registerBuilder(
      'appBar', // El 'type' que usas en tu JSON para este widget
      buildWithParams,
    );
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    // --- Obtener Parámetros y Parsear JSON ---
    // Flag que indica si hay un drawer (pasado desde ScaffoldBuilder)
    final bool hasDrawer = params?['hasDrawer'] ?? false;
    // GlobalKey para el estado del drawer personalizado (pasado desde ScaffoldBuilder)
    // Usa el nombre PÚBLICO del State: CustomCupertinoDrawerState
    final GlobalKey<CustomCupertinoDrawerState>? customDrawerKey = params?['customDrawerKey'];
    // *** PRINT de DEBUG: Confirma recepción de la clave ***
    print("[AppBarBuilder] Recibida customDrawerKey: ${customDrawerKey?.hashCode}");

    // Parsear propiedades específicas del AppBar desde el JSON
    final titleJson = json['title'] as Map<String, dynamic>?;
    final leadingJson = json['leading'] as Map<String, dynamic>?; // 'leading' explícito del JSON
    final trailingActionsJson = json['trailingActions'] as List<dynamic>?;
    final bottomJson = json['bottom'] as Map<String, dynamic>?;
    final styles = json['styles'] as Map<String, dynamic>? ?? {};
    final properties = json['properties'] as Map<String, dynamic>? ?? {};

    Widget? leadingWidget; // El widget 'leading' final que se construirá

    // --- Determinar el Widget 'Leading' ---
    // 1. ¿Se definió un 'leading' explícito en el JSON?
    if (leadingJson != null) {
      print("[AppBarBuilder] Usando 'leading' explícito desde JSON.");
      leadingWidget = WidgetFactory.buildWidgetFromJson(context, leadingJson);
    }
    // 2. Si no hay 'leading' explícito, y SÍ hay un drawer, crear botón de menú
    else {
      if (hasDrawer) {
        print("[AppBarBuilder] No hay 'leading' explícito, creando botón de drawer (hasDrawer=true).");
        // Usar Builder para obtener un contexto correcto para Scaffold.of (Android)
        leadingWidget = Builder(
          builder: (BuildContext buttonContext) { // Contexto específico del botón
            final TargetPlatform platform = Theme.of(buttonContext).platform;
            print("[AppBarBuilder] Construyendo botón 'leading' para plataforma: $platform");

            return PlatformIconButton(
              onPressed: () {
                // Acción depende de la plataforma
                if (platform == TargetPlatform.iOS) {
                  // --- Lógica iOS con GlobalKey ---
                  print("[AppBar Button iOS] Intentando toggle via GlobalKey (Key: ${customDrawerKey?.hashCode})");
                  // Verifica explícitamente si currentState es null ANTES de llamar a toggle
                  final state = customDrawerKey?.currentState;
                  if (state == null) {
                    print("[AppBar Button iOS] ERROR: customDrawerKey.currentState ES NULL!");
                  } else {
                    print("[AppBar Button iOS] currentState ENCONTRADO. Llamando toggle()...");
                    state.toggle(); // Llama al método público toggle del State
                  }
                } else {
                  // --- Lógica Android con Scaffold.of ---
                  print("[AppBar Button Android] Intentando toggle via Scaffold.of...");
                  // Usar maybeOf por seguridad, aunque el context del Builder debería funcionar
                  Scaffold.maybeOf(buttonContext)?.openDrawer();
                }
              },
              // Usar el icono de menú estándar de la librería
              icon: Icon(PlatformIcons(buttonContext).folder),
              // Configuraciones específicas de plataforma para el botón
              cupertino: (_, __) => CupertinoIconButtonData(padding: EdgeInsets.zero),
              material: (_, __) => MaterialIconButtonData(tooltip: 'Abrir menú'),
            );
          },
        );
      } else {
        // No hay leading explícito y no hay drawer, no ponemos nada
        print("[AppBarBuilder] No hay 'leading' explícito y hasDrawer=false, leading será null.");
      }
    }

    // --- Construir las otras partes del AppBar ---
    print("[AppBarBuilder] Construyendo title widget...");
    final Widget? titleWidget = titleJson != null
        ? WidgetFactory.buildWidgetFromJson(context, titleJson)
        : null;

    print("[AppBarBuilder] Construyendo trailing actions...");
    final List<Widget>? trailingActionsWidgets = trailingActionsJson != null
        ? trailingActionsJson
        .map((action) => WidgetFactory.buildWidgetFromJson(
        context, action as Map<String, dynamic>)) // Asegurar tipo
        .toList()
        : null;

    print("[AppBarBuilder] Construyendo bottom widget...");
    // El widget 'bottom' debe ser PreferredSizeWidget (ej. PlatformTabBar)
    final PreferredSizeWidget? bottomWidget = bottomJson != null
        ? WidgetFactory.buildWidgetFromJson(context, bottomJson) as PreferredSizeWidget? // Castear
        : null;

    // --- Construir el PlatformAppBar final ---
    print("[AppBarBuilder] Construyendo PlatformAppBar final...");
    return PlatformAppBar(
      key: json.containsKey('id') ? Key(json['id']) : null, // Key del JSON si existe
      title: titleWidget,
      backgroundColor: styles['backgroundColor'] != null
          ? parseColor(styles['backgroundColor']) // Tu utilidad parseColor
          : null,
      leading: leadingWidget, // Asignar el leading determinado
      trailingActions: trailingActionsWidgets,
      // Permitir que PlatformAppBar muestre botón 'atrás' si aplica
      automaticallyImplyLeading: properties['automaticallyImplyLeading'] as bool? ?? true,

      // Configuración específica de Material / Cupertino desde JSON si es necesario
      material: (_, __) => MaterialAppBarData(
        elevation: (properties['elevation'] as num?)?.toDouble(),
        bottom: bottomWidget,
      ),
      cupertino: (_, __) => CupertinoNavigationBarData(
        transitionBetweenRoutes: properties['transitionBetweenRoutes'] as bool? ?? true,
      ),
    );
  }
}