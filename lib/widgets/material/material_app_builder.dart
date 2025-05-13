import 'package:frontend/widget_factory.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../../state_notifier/navigator_state_notifier.dart';
import '../utils.dart';
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
    Map<String, dynamic>? params,
  ]) {
    final String? id = json['id']?.toString();
    final Map<String, dynamic> styles = json['styles'] ?? {};
    final Map<String, dynamic> properties = json['properties'] ?? {};

    if (id == null || id.isEmpty) {
      print("Error: Navigator widget requires a unique 'id'.");
      return const Center(child: Text("Navigator requires ID"));
    }

    final navigatorNotifier = context.read<NavigatorStateNotifier>();
    final GlobalKey<NavigatorState> appNavigatorKey = navigatorNotifier.getOrCreateNavigatorKey(id);

    final Map<String, WidgetBuilder> staticRoutes = _buildStaticRoutes(context, json, params);

    final Key? key = parseKey(id);

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
      navigatorKey: appNavigatorKey,
      routes: staticRoutes,
      initialRoute: initialRoute,
      title: title,
      color: color,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      restorationScopeId: restorationScopeId,
      onGenerateRoute: (RouteSettings settings) {
        print("[MaterialAppBuilder onGenerateRoute] Attempting to generate route for: '${settings.name}' with arguments: ${settings.arguments}");

        final Map<String, dynamic>? pendingScreenJson = navigatorNotifier.getPendingScreenJson(settings.name!);

        if (pendingScreenJson != null) {
          print("[MaterialAppBuilder onGenerateRoute] Found pending screen JSON for '${settings.name}'. Building...");
          navigatorNotifier.clearPendingScreenJson(settings.name!);
          return MaterialPageRoute(
            builder: (context) => WidgetFactory.buildWidgetFromJson(
              context,
              pendingScreenJson,
              settings.arguments as Map<String, dynamic>?,
            ),
            settings: settings,
          );
        }

        if (settings.name != null && settings.name!.startsWith('/resource/')) {
          final parts = settings.name!.split('/');
          if (parts.length == 3) {
            final resourceId = parts[2];
            print("[MaterialAppBuilder onGenerateRoute] Matched dynamic route /resource/:id with ID: $resourceId");
          }
        }

        print("Error: Route '${settings.name}' not found in static routes or pending screens.");
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text("Ruta no encontrada")),
            body: Center(child: Text("No se encontró la ruta: ${settings.name}")),
          ),
        );
      },
    );
  }

  static Map<String, WidgetBuilder> _buildStaticRoutes(
    BuildContext context,
    Map<String, dynamic> json,
    Map<String, dynamic>? params,
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
    if (routes.isEmpty || (routes.isNotEmpty && !routes.containsKey('/'))) {
      if (json['properties']?['initialRoute'] == '/' || routes.isEmpty) {
        print("Warning: No explicit route defined for '/'. Adding a default placeholder screen.");
        routes['/'] = (ctx) => Scaffold(
          appBar: AppBar(title: const Text("Inicio (Default)")),
          body: const Center(child: Text("Pantalla de inicio por defecto.")),
        );
      }
    }
    return routes;
  }
}
