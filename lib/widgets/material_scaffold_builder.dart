import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/material_appbar_builder.dart';
import 'package:frontend/widgets/material_drawer_builder.dart';
import 'package:frontend/widgets/utils.dart';

// TODO: ButtonNavBar, FloatingActionButton, BottomSheet, PersistentFooterButtons, endDrawer, onDrawerChanged, onEndDrawerChanged
class MaterialScaffoldBuilder {

  static const String typeName = 'material.scaffold';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {

    final styles = Map<String, dynamic>.from(json['styles'] as Map? ?? {});
    final properties = Map<String, dynamic>.from(json['properties'] as Map? ?? {});
    final children = json['children'] as List<dynamic>? ?? [];
    final Key? key = json.containsKey('id') ? Key(json['id'] as String) : null;

    final Map<String, dynamic>? appBarJson = children
        .whereType<Map<String, dynamic>>()
        .firstWhereOrNull((child) => child['type'] == MaterialAppBarBuilder.typeName);
    final Map<String, dynamic>? bottomNavBarJson = children
        .whereType<Map<String, dynamic>>()
        .firstWhereOrNull((child) => child['type'] == 'BottomNavBar');

    final Map<String, dynamic>? bodyJson = children
        .whereType<Map<String, dynamic>>()
        .firstWhereOrNull((child) =>
    child['type'] != MaterialAppBarBuilder.typeName &&
        child['type'] != 'BottomNavBar' &&
        child['type'] != MaterialDrawerBuilder.typeName &&
        child['type'] != 'endDrawer' &&
        child['type'] != 'floatingActionButton');
    final Map<String, dynamic>? drawerJson = children
        .whereType<Map<String, dynamic>>()
        .firstWhereOrNull((child) => child['type'] == MaterialDrawerBuilder.typeName);
    final Map<String, dynamic>? endDrawerJson = children
        .whereType<Map<String, dynamic>>()
        .firstWhereOrNull((child) => child['type'] == 'endDrawer');
    final Map<String, dynamic>? fabJson = children
        .whereType<Map<String, dynamic>>()
        .firstWhereOrNull((child) => child['type'] == 'floatingActionButton');

    final PreferredSizeWidget? appBarWidget = appBarJson != null
        ? WidgetFactory.buildWidgetFromJson(context, appBarJson) as PreferredSizeWidget?
        : null;

    final Widget bodyWidget = bodyJson != null
        ? WidgetFactory.buildWidgetFromJson(context, bodyJson)
        : const SizedBox.shrink();

    Widget? drawerWidget;
    if (drawerJson != null) {
      try {
        drawerWidget = WidgetFactory.buildWidgetFromJson(context, drawerJson);
        print("[ScaffoldBuilder] Drawer widget construido: $drawerWidget");
      } catch (e) {
        print("[ScaffoldBuilder] ERROR construyendo Drawer: $e");
        drawerWidget = null;
      }
    } else {
      print("[ScaffoldBuilder] No se encontró JSON para drawer.");
    }

    final Widget? endDrawerWidget = endDrawerJson != null
        ? WidgetFactory.buildWidgetFromJson(context, endDrawerJson)
        : null;

    final Widget? bottomNavBarWidget = bottomNavBarJson != null
        ? _buildBottomNavigationBar(context, bottomNavBarJson)
        : null;

    final Widget? fabWidget = fabJson != null
        ? WidgetFactory.buildWidgetFromJson(context, fabJson)
        : null;

    final Color? backgroundColor = styles['backgroundColor'] != null ? parseColor(styles['backgroundColor']) : null;
    final String? restorationId = properties['restorationId'] as String?;
    final bool? resizeToAvoidBottomInset = properties['resizeToAvoidBottomInset'] as bool?;
    final bool primary = properties['primary'] as bool? ?? true;
    final bool extendBody = properties['extendBody'] as bool? ?? false;
    final bool extendBodyBehindAppBar = properties['extendBodyBehindAppBar'] as bool? ?? false;
    final Color? drawerScrimColor = styles['drawerScrimColor'] != null ? parseColor(styles['drawerScrimColor']) : null;
    final double? drawerEdgeDragWidth = (properties['drawerEdgeDragWidth'] as num?)?.toDouble();
    final bool drawerEnableOpenDragGesture = properties['drawerEnableOpenDragGesture'] as bool? ?? true;
    final bool endDrawerEnableOpenDragGesture = properties['endDrawerEnableOpenDragGesture'] as bool? ?? true;
    final DragStartBehavior drawerDragStartBehavior = parseDragStartBehavior(properties['drawerDragStartBehavior']) ?? DragStartBehavior.start; // Default start

    return Scaffold(
      key: key,
      appBar: appBarWidget,
      body: bodyWidget,
      drawer: drawerWidget,
      endDrawer: endDrawerWidget,
      bottomNavigationBar: bottomNavBarWidget,
      floatingActionButton: fabWidget,
      // floatingActionButtonLocation: ..., // Parse if needed
      // floatingActionButtonAnimator: ..., // Parse if needed
      // persistentFooterButtons: ..., // Parse if needed
      // bottomSheet: ..., // Parse if needed
      backgroundColor: backgroundColor,
      restorationId: restorationId,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      drawerDragStartBehavior: drawerDragStartBehavior,
      // onDrawerChanged: (isOpen) { ... }, // Add if callback needed via JSON event handling
      // onEndDrawerChanged: (isOpen) { ... }, // Add if callback needed via JSON event handling
    );
  }

  static Widget? _buildBottomNavigationBar(BuildContext context, Map<String, dynamic> json) {
    final List<BottomNavigationBarItem> items = (json['items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((itemJson) => _buildNavBarItem(context, itemJson))
        .toList();

    if (items.isEmpty) {
      print("[ScaffoldBuilder] Warn: No valid items found for BottomNavigationBar.");
      return null;
    }

    final Key? navBarKey = json.containsKey('id') ? Key(json['id'] as String) : null;
    final int currentIndex = json['currentIndex'] as int? ?? 0;
    final Color? backgroundColor = json['styles']?['backgroundColor'] != null ? parseColor(json['styles']['backgroundColor']) : null;
    final Color? selectedItemColor = json['styles']?['selectedItemColor'] != null ? parseColor(json['styles']['selectedItemColor']) : null;
    final Color? unselectedItemColor = json['styles']?['unselectedItemColor'] != null ? parseColor(json['styles']['unselectedItemColor']) : null;
    final double? elevation = (json['properties']?['elevation'] as num?)?.toDouble();
    final BottomNavigationBarType? type = parseBottomNavBarType(json['properties']?['type']);

    final ValueChanged<int>? onTap = (index) {
      print('BottomNavBar item tapped: $index');
    };

    return BottomNavigationBar(
      key: navBarKey,
      items: items,
      currentIndex: currentIndex,
      onTap: onTap, // Standard onTap callback
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      elevation: elevation,
      type: type,
    );
  }

  static BottomNavigationBarItem _buildNavBarItem(BuildContext context, Map<String, dynamic> json) {
    final iconJson = json['icon'] as Map<String, dynamic>?;
    final activeIconJson = json['activeIcon'] as Map<String, dynamic>?;
    final String? label = json['label'] as String?;
    final String? tooltip = json['tooltip'] as String?;
    final Color? itemBackgroundColor = json['styles']?['backgroundColor'] != null ? parseColor(json['styles']['backgroundColor']) : null; // Specific to shifting type usually

    Widget? iconWidget;
    if (iconJson != null) {
      try {
        iconWidget = WidgetFactory.buildWidgetFromJson(context, iconJson);
      } catch (e) {
        print("[ScaffoldBuilder] Error building icon for NavBarItem: $e");
        iconWidget = const Icon(Icons.error);
      }
    } else {
      iconWidget = const SizedBox.shrink();
    }

    Widget? activeIconWidget;
    if (activeIconJson != null) {
      try {
        activeIconWidget = WidgetFactory.buildWidgetFromJson(context, activeIconJson);
      } catch (e) {
        print("[ScaffoldBuilder] Error building activeIcon for NavBarItem: $e");
      }
    }

    return BottomNavigationBarItem(
      icon: iconWidget,
      label: label,
      activeIcon: activeIconWidget ?? iconWidget,
      tooltip: tooltip,
      backgroundColor: itemBackgroundColor,
    );
  }

  static DragStartBehavior? parseDragStartBehavior(String? value) {
    if (value == 'down') return DragStartBehavior.down;
    if (value == 'start') return DragStartBehavior.start;
    return null;
  }

  static BottomNavigationBarType? parseBottomNavBarType(String? value) {
    if (value == 'fixed') return BottomNavigationBarType.fixed;
    if (value == 'shifting') return BottomNavigationBarType.shifting;
    return null;
  }
}