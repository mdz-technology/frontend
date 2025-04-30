import 'package:flutter/widgets.dart';
import 'package:frontend/widget_factory.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils.dart';
import 'package:flutter/material.dart';

class MaterialAppBuilder {

  static const String typeName = 'material.app';

  static void register() {
    WidgetFactory.registerBuilder(
      typeName,
      _buildWithParams,
    );
  }

  static Widget _buildWithParams(
    BuildContext context,
    Map<String, dynamic> json, [
    Map<String, dynamic>?
        params,
  ]) {
    final Key? key = json['id'] != null
        ? Key(json['id'])
        : null;
    final Map<String, dynamic> styles = json['styles'] ?? {};
    final Map<String, dynamic> properties = json['properties'] ?? {};

    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    final Map<String, WidgetBuilder> routes = _buildRoutes(context, json);

    final String initialRoute = properties['initialRoute'] ?? '/';
    final String title = properties['title'] ?? '';
    final Color? color =
        styles['color'] != null ? parseColor(styles['color']) : null;
    final Locale? locale = parseLocale(properties['locale']);
    final Iterable<Locale> supportedLocales =
        parseLocales(properties['supportedLocales']) ??
            const <Locale>[Locale('en', 'US')];
    final bool showPerformanceOverlay =
        properties['showPerformanceOverlay'] ?? false;
    final bool checkerboardRasterCacheImages =
        properties['checkerboardRasterCacheImages'] ?? false;
    final bool checkerboardOffscreenLayers =
        properties['checkerboardOffscreenLayers'] ?? false;
    final bool showSemanticsDebugger =
        properties['showSemanticsDebugger'] ?? false;
    final bool debugShowCheckedModeBanner =
        properties['debugShowCheckedModeBanner'] ?? true;
    final String? restorationScopeId = properties['restorationScopeId'];

    final ThemeData? theme = null;
    final ThemeData? darkTheme = null;
    final ThemeMode themeMode = ThemeMode.system;

    return MaterialApp(
      key: key,
      navigatorKey: navigatorKey,
      routes: routes,
      initialRoute: initialRoute,
      title: title,
      color: color,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      restorationScopeId: restorationScopeId,
    );
  }

  static Map<String, WidgetBuilder> _buildRoutes(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    final List<dynamic> childrenJson = json['children'] ?? [];
    final Map<String, WidgetBuilder> routes = {};
    for (var routeJson in childrenJson) {
      if (routeJson is Map<String, dynamic>) {
        final String? path = routeJson['route'];
        if (path != null) {
          routes[path] = (context) =>
              WidgetFactory.buildWidgetFromJson(context, routeJson);
        } else {
          print("Warning: Child in 'material.app' is missing a 'path' property: $routeJson");
        }
      } else {
        print("Warning: Invalid child format in 'material.app': $routeJson");
      }
    }
    return routes;
  }
}
