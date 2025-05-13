import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widget_factory.dart';
import '../../state_notifier/navigator_state_notifier.dart';

class MaterialNavigatorBuilder {
  static const String typeName = 'material.navigator';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    final String? id = json['id'] as String?;
    final Map<String, dynamic> properties = Map<String, dynamic>.from(json['properties'] as Map? ?? {});
    final List<dynamic>? routeDefinitions = json['children'] as List<dynamic>?;

    if (id == null || id.isEmpty) {
      print("Error: Navigator widget ('${json['type']}') requires a unique 'id'.");
      return const Center(child: Text("Navigator requiere un ID"));
    }

    final navigatorNotifier = context.read<NavigatorStateNotifier>();
    final GlobalKey<NavigatorState> navigatorKey = navigatorNotifier.getOrCreateNavigatorKey(id);

    final String initialRoute = properties['initialRoute'] as String? ?? '/';

    final Map<String, WidgetBuilder> staticNestedRoutes = _buildStaticNestedRoutes(routeDefinitions, params);

    if (!staticNestedRoutes.containsKey(initialRoute) && navigatorNotifier.getPendingScreenJson(initialRoute) == null) {
      print("Warning: Initial nested route '$initialRoute' not found in defined static routes for Navigator '$id' and no pending JSON. Using '/' if available or showing error.");
    }

    print("[MaterialNavigatorBuilder] Building Navigator '$id' with initialRoute: '$initialRoute' and ${staticNestedRoutes.length} static nested routes.");

    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: (RouteSettings settings) {
        return _onGenerateNestedRoute(context, settings, id, staticNestedRoutes, params);
      },
    );
  }

  static Map<String, WidgetBuilder> _buildStaticNestedRoutes(
      List<dynamic>? routeDefinitions,
      Map<String, dynamic>? params,
      ) {
    final Map<String, WidgetBuilder> routes = {};
    if (routeDefinitions == null) return routes;

    for (var routeJson in routeDefinitions) {
      if (routeJson is Map<String, dynamic>) {
        final String? path = routeJson['nestedRoute'] as String?;
        final Map<String, dynamic>? screenJson = routeJson['screen'] as Map<String, dynamic>?;

        if (path != null && path.isNotEmpty && screenJson != null) {
          routes[path] = (nestedContext) =>
          WidgetFactory.buildWidgetFromJson(nestedContext, screenJson, params);
        } else {
          print("Warning: Child route in '${MaterialNavigatorBuilder.typeName}' is missing 'nestedRoute' or 'screen' property, or path is empty: $routeJson");
        }
      } else {
        print("Warning: Invalid child format for route definition in '${MaterialNavigatorBuilder.typeName}': $routeJson");
      }
    }
    if (routes.isEmpty || (routes.isNotEmpty && !routes.containsKey('/') && (routeDefinitions?.any((r) => r is Map && r['nestedRoute'] == '/') ?? false) == false )) {
      final bool initialRouteIsRoot = (routeDefinitions?.any((r) => r is Map && r['nestedRoute'] == '/' && r['screen'] != null) ?? false) == false;
      if(routes.isEmpty || initialRouteIsRoot) {
        print("Warning: No valid static nested routes defined for '${MaterialNavigatorBuilder.typeName}'. Adding a default '/' route placeholder.");
        routes['/'] = (ctx) => const Center(child: Text("Ruta anidada '/' por defecto"));
      }
    }
    return routes;
  }

  static Route<dynamic>? _onGenerateNestedRoute(
      BuildContext context,
      RouteSettings settings,
      String navigatorId,
      Map<String, WidgetBuilder> staticNestedRoutes,
      Map<String, dynamic>? pageParams,
      ) {
    print("[Navigator '$navigatorId' onGenerateRoute] Attempting to generate route for: '${settings.name}' with arguments: ${settings.arguments}");

    final navigatorNotifier = context.read<NavigatorStateNotifier>();

    final Map<String, dynamic>? pendingScreenJson = navigatorNotifier.getPendingScreenJson(settings.name!);

    if (pendingScreenJson != null) {
      print("[Navigator '$navigatorId' onGenerateRoute] Found pending screen JSON for '${settings.name}'. Building...");
      navigatorNotifier.clearPendingScreenJson(settings.name!);
      return MaterialPageRoute(
        builder: (nestedContext) => WidgetFactory.buildWidgetFromJson(
          nestedContext,
          pendingScreenJson,
          pageParams,
        ),
        settings: settings,
      );
    }

    final WidgetBuilder? staticBuilder = staticNestedRoutes[settings.name];
    if (staticBuilder != null) {
      print("[Navigator '$navigatorId' onGenerateRoute] Using static route builder for '${settings.name}'.");
      return MaterialPageRoute(
        builder: staticBuilder,
        settings: settings,
      );
    }

    if (settings.name != null && settings.name!.startsWith('/resource/')) {
      final parts = settings.name!.split('/');
      if (parts.length == 3) {
        final resourceId = parts[2];
        print("[Navigator '$navigatorId' onGenerateRoute] Matched dynamic route /resource/:id with ID: $resourceId");
      }
    }

    print("Error: Nested route '${settings.name}' not found in Navigator '$navigatorId'.");
    return MaterialPageRoute(
      builder: (ctx) => Scaffold(
        appBar: AppBar(title: Text("Error en Ruta Interna ($navigatorId)")),
        body: Center(child: Text("Ruta interna no encontrada: ${settings.name}")),
      ),
    );
  }
}
