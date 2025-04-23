// widgets/scaffold_builder.dart (Construir Contenido Drawer Correctamente para iOS)

import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/utils.dart';
import 'package:frontend/widgets/custom_cupertino_drawer.dart'; // Importar CustomCupertinoDrawer y su Key


class ScaffoldBuilder {
  static void register() {
    WidgetFactory.registerBuilder('scaffold', buildWithParams);
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    print("[ScaffoldBuilder] Iniciando construcción...");
    // --- Parsear JSON ---
    final styles = Map<String, dynamic>.from(json['styles'] as Map? ?? {});
    final properties = Map<String, dynamic>.from(json['properties'] as Map? ?? {});
    final children = json['children'] as List<dynamic>? ?? [];
    print("[ScaffoldBuilder] JSON inicial parseado.");

    Key? platformScaffoldWidgetKey = json.containsKey('id') ? Key(json['id'] as String) : null;
    print("[ScaffoldBuilder] Key para PlatformScaffold: $platformScaffoldWidgetKey");

    // --- Encontrar componentes ---
    final Map<String, dynamic>? appBarJson = children.whereType<Map<String, dynamic>>().firstWhereOrNull((child) => child['type'] == 'appBar');
    final Map<String, dynamic>? bottomNavBarJson = children.whereType<Map<String, dynamic>>().firstWhereOrNull((child) => child['type'] == 'BottomNavBar');
    final Map<String, dynamic>? bodyJson = children.whereType<Map<String, dynamic>>().firstWhereOrNull((child) => child['type'] != 'appBar' && child['type'] != 'BottomNavBar' && child['type'] != 'drawer');
    final Map<String, dynamic>? drawerJson = children.whereType<Map<String, dynamic>>().firstWhereOrNull((child) => child['type'] == 'drawer');
    print("[ScaffoldBuilder] Componentes identificados (Drawer: ${drawerJson != null})");


    // --- Construir Drawer Widget (para Material) y Drawer CONTENT (para Cupertino) ---
    Widget? drawerWidgetForMaterial; // Widget Drawer completo para Android
    Widget? drawerContentForCupertino; // Solo el contenido (ListView/Column) para iOS

    if (drawerJson != null) {
      print("[ScaffoldBuilder] Procesando drawer JSON...");

      // 1. Construir el widget Drawer completo para Android (usando DrawerBuilder)
      try {
        // Asume que tienes un builder registrado para "drawer" que devuelve un widget Drawer
        drawerWidgetForMaterial = WidgetFactory.buildWidgetFromJson(context, Map<String, dynamic>.from(drawerJson));
        print("[ScaffoldBuilder] Construido 'drawerWidgetForMaterial' para Android.");
      } catch (e) {
        print("[ScaffoldBuilder] ERROR construyendo drawerWidgetForMaterial: $e");
        drawerWidgetForMaterial = const Drawer(child: Center(child: Text("Error Drawer")));
      }

      // 2. Construir SOLO el CONTENIDO para Cupertino
      final drawerChildrenJson = drawerJson['children'] as List<dynamic>? ?? [];
      print("[ScaffoldBuilder] Hijos JSON del drawer: ${drawerChildrenJson.length}");
      try {
        List<Widget> drawerItems = drawerChildrenJson
            .whereType<Map<String, dynamic>>() // Solo procesar Maps
            .map((itemJson) => WidgetFactory.buildWidgetFromJson(context, itemJson)) // Construir cada item
            .toList();
        print("[ScaffoldBuilder] Construidos ${drawerItems.length} widgets para contenido drawer.");

        // Envolver los items en un layout adecuado. ListView es común.
        // Añadir Material y SafeArea puede ser útil.
        drawerContentForCupertino = Material(
          color: Colors.transparent, // Hacer Material transparente si el drawer ya tiene color
          child: SafeArea( // Evitar que el contenido se solape con notch/barra de estado
            child: ListView(
              padding: EdgeInsets.zero, // Controlar padding manualmente si es necesario
              children: drawerItems,
            ),
            // Alternativa: Column si no necesitas scroll
            // child: Column(children: drawerItems),
          ),
        );
        print("[ScaffoldBuilder] Creado 'drawerContentForCupertino'.");

      } catch(e) {
        print("[ScaffoldBuilder] ERROR construyendo contenido del drawer para Cupertino: $e");
        drawerContentForCupertino = const Center(child: Text("Error Contenido Drawer"));
      }

    } else {
      print("[ScaffoldBuilder] No se encontró JSON para drawer.");
    }

    // --- Determinar Plataforma y Crear GlobalKey ---
    final platform = PlatformProvider.of(context)?.platform ?? Theme.of(context).platform;
    print("[ScaffoldBuilder] Plataforma Objetivo Detectada: $platform");

    GlobalKey<CustomCupertinoDrawerState>? customDrawerKey;
    // Crear clave SOLO si es iOS y tenemos el CONTENIDO del drawer
    if (platform == TargetPlatform.iOS && drawerContentForCupertino != null) {
      customDrawerKey = GlobalKey<CustomCupertinoDrawerState>();
      print("[ScaffoldBuilder] >>> Creada GlobalKey: ${customDrawerKey.hashCode}");
    } else { /* No se crea clave */ }

    // --- Construir AppBar ---
    print("[ScaffoldBuilder] Construyendo AppBar...");
    final PlatformAppBar? appBar = appBarJson != null
        ? WidgetFactory.buildWidgetFromJson(context, Map<String, dynamic>.from(appBarJson), {
      'hasDrawer': drawerWidgetForMaterial != null, // Basado en si existe definicion de drawer
      'customDrawerKey': customDrawerKey,
    }) as PlatformAppBar?
        : null;
    print("[ScaffoldBuilder] AppBar construido.");


    // --- Construir Body ---
    print("[ScaffoldBuilder] Construyendo Body Widget...");
    final Widget bodyWidget = bodyJson != null
        ? WidgetFactory.buildWidgetFromJson(context, Map<String, dynamic>.from(bodyJson))
        : const SizedBox.shrink();
    print("[ScaffoldBuilder] Body construido.");

    // --- Construir BottomNavBar ---
    // ... (como antes) ...
    final PlatformNavBar? bottomNavBar = bottomNavBarJson != null ? _buildNavBar(context, Map<String, dynamic>.from(bottomNavBarJson)) : null;


    // --- Determinar Body Final ---
    Widget finalBodyContent;
    // Usar CustomCupertinoDrawer si es iOS y tenemos CONTENIDO y CLAVE
    if (customDrawerKey != null && drawerContentForCupertino != null && platform == TargetPlatform.iOS) {
      print("[ScaffoldBuilder] Usando CustomCupertinoDrawer como body con key: ${customDrawerKey.hashCode}");
      finalBodyContent = CustomCupertinoDrawer(
        key: customDrawerKey,
        drawerContent: drawerContentForCupertino!, // Pasar el CONTENIDO
        child: bodyWidget,
        drawerWidth: (drawerJson?['properties']?['width'] as num?)?.toDouble() ?? 280.0, // Obtener ancho
      );
    } else {
      // Android o iOS sin drawer
      finalBodyContent = bodyWidget;
    }

    // --- Construir PlatformScaffold ---
    print("[ScaffoldBuilder] Construyendo PlatformScaffold final...");
    return PlatformScaffold(
      widgetKey: platformScaffoldWidgetKey,
      appBar: appBar,
      body: finalBodyContent,
      backgroundColor: styles['backgroundColor'] != null ? parseColor(styles['backgroundColor']) : null,
      bottomNavBar: bottomNavBar,
      material: (_, __) => MaterialScaffoldData(
        drawer: drawerWidgetForMaterial, // Usar el Drawer completo para Material/Android
      ),
      cupertino: (_, __) => CupertinoPageScaffoldData(),
      iosContentPadding: properties['iosContentPadding'] as bool? ?? false,
      iosContentBottomPadding: properties['iosContentBottomPadding'] as bool? ?? false,
    );
  }

  // --- Funciones Auxiliares (_buildNavBar, _buildNavBarItem sin cambios) ---
  static PlatformNavBar _buildNavBar(BuildContext context, Map<String, dynamic> json) { /* ... */
    return PlatformNavBar(
      widgetKey: json.containsKey('id') ? Key(json['id'] as String) : null,
      backgroundColor: json['backgroundColor'] != null ? parseColor(json['backgroundColor'] as String) : null,
      items: json['items'] is List
          ? (json['items'] as List).map((itemJson) { if (itemJson is Map<String, dynamic>) { return _buildNavBarItem(context, itemJson); } else { print("Warn: NavBar item not map"); return null; } }).whereType<BottomNavigationBarItem>().toList()
          : [],
      currentIndex: json['currentIndex'] as int? ?? 0,
      itemChanged: (index) => print('Navbar item changed: $index'),
      material: (_, __) => MaterialNavBarData(height: (json['material']?['height'] as num?)?.toDouble() ?? kBottomNavigationBarHeight),
      cupertino: (_, __) => CupertinoTabBarData(height: (json['cupertino']?['height'] as num?)?.toDouble() ?? kMinInteractiveDimensionCupertino),
    );
  }
  static BottomNavigationBarItem _buildNavBarItem(BuildContext context, Map<String, dynamic> json) { /* ... */
    final iconJson = json['icon'] as Map<String, dynamic>?;
    final activeIconJson = json['activeIcon'] as Map<String, dynamic>?;
    return BottomNavigationBarItem(
      key: json['key'] != null ? Key(json['key'] as String) : null,
      icon: iconJson != null ? WidgetFactory.buildWidgetFromJson(context, iconJson) : const SizedBox.shrink(),
      activeIcon: activeIconJson != null ? WidgetFactory.buildWidgetFromJson(context, activeIconJson) : null,
      label: json['label'] as String? ?? '',
      tooltip: json['tooltip'] as String?,
      backgroundColor: json['backgroundColor'] != null ? parseColor(json['backgroundColor'] as String) : null,
    );
  }
}