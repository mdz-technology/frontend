import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/widget_factory.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../utils.dart';

class AppBuilder  {

  static void register() {
    WidgetFactory.registerBuilder(
      'app',
      _buildWithParams,
    );
  }

  static Widget _buildWithParams(
      BuildContext context,
      Map<String, dynamic> json,
      [Map<String, dynamic>? params]) {
    final Key? id = json['id'] != null ? Key(json['id']) : null;
    final Map<String, dynamic> styles = json['styles'] ?? {};
    final Map<String, dynamic> properties = json['properties'] ?? {};

    final GlobalKey<NavigatorState> defaultNavigatorKey =
        GlobalKey<NavigatorState>();

    const String defaultInitialRoute = '/';
    final String initialRoute =
        properties['initialRoute'] ?? defaultInitialRoute;

    final Map<String, WidgetBuilder> routes = _buildRoutes(context, json);

    final title = properties['title'] ?? '';
    final color = styles['color'] != null ? parseColor(styles['color']) : null;

    return PlatformApp(
      widgetKey: id,
      navigatorKey: defaultNavigatorKey,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: null,
      onUnknownRoute: null,
      navigatorObservers: const <NavigatorObserver>[],
      builder: null,
      title: title,
      onGenerateTitle: null,
      color: color,
      locale: parseLocale(properties['locale']) ?? const Locale('en'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      localeListResolutionCallback: null,
      localeResolutionCallback: null,
      supportedLocales:
          parseLocales(properties['supportedLocales']) ?? const [Locale('en')],
      showPerformanceOverlay: properties['showPerformanceOverlay'] ?? false,
      checkerboardRasterCacheImages:
          properties['checkerboardRasterCacheImages'] ?? false,
      checkerboardOffscreenLayers:
          properties['checkerboardOffscreenLayers'] ?? false,
      showSemanticsDebugger: properties['showSemanticsDebugger'] ?? false,
      debugShowCheckedModeBanner:
          properties['debugShowCheckedModeBanner'] ?? true,
      shortcuts: const <LogicalKeySet, Intent>{},
      actions: const <Type, Action<Intent>>{},
      onGenerateInitialRoutes: null,
      restorationScopeId: properties['restorationScopeId'],
      scrollBehavior: null,
      onNavigationNotification: null,
      material: properties['material'] == true ? defaultMaterialAppData : null,
      cupertino:
          properties['cupertino'] == true ? defaultCupertinoAppData : null,
    );
  }

  static Map<String, WidgetBuilder> _buildRoutes(
      BuildContext context,
      Map<String, dynamic> json) {
    final List<dynamic> childrenJson = json['children'] ?? [];
    final Map<String, WidgetBuilder> routes = {};
    for (var routeJson in childrenJson) {
      final String? path = routeJson['path'];
      if (path != null) {
        routes[path] =
            (context) => WidgetFactory.buildWidgetFromJson(context, routeJson);
      }
    }
    return routes;
  }

}
