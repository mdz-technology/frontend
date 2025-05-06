// Crear archivo widgets/core/navigator_builder.dart (o material/navigator_builder.dart)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state_notifier/navigator_state_notifier.dart';
import '../../widget_factory.dart';

class MaterialNavigatorBuilder {

  static const String typeName = 'material.navigator';

  static void register() {
    WidgetFactory.registerBuilder(typeName, buildWithParams);
  }

  static Map<String, WidgetBuilder> _buildNestedRoutes(
      BuildContext context,
      List<dynamic>? routeDefinitions,
      Map<String, dynamic>? params,
      ) {
    final Map<String, WidgetBuilder> routes = {};
    if (routeDefinitions == null) return routes;

    for (var routeJson in routeDefinitions) {
      if (routeJson is Map<String, dynamic>) {
        final String? path = routeJson['nestedRoute'] as String?;
        final Map<String, dynamic>? screenJson = routeJson['screen'] as Map<String, dynamic>?;

        if (path != null && screenJson != null) {
          routes[path] = (nestedContext) =>
          WidgetFactory.buildWidgetFromJson(nestedContext, screenJson, params);
        } else {
          print("Warning: Child route in 'multiplatform.navigator' is missing 'nestedRoute' or 'screen' property: $routeJson");
        }
      } else {
        print("Warning: Invalid child format for route definition in 'multiplatform.navigator': $routeJson");
      }
    }
    if (routes.isEmpty) {
      print("Warning: No valid nested routes defined for 'core.navigator'. Adding a default '/' route.");
      routes['/'] = (ctx) => const Center(child: Text("No nested routes defined"));
    }
    return routes;
  }


  static Widget buildWithParams(
      BuildContext context,
      Map<String, dynamic> json, [
        Map<String, dynamic>? params,
      ]) {
    final String? id = json['id'] as String?;
    final Map<String, dynamic> properties = json['properties'] as Map<String, dynamic>? ?? {};
    final List<dynamic>? routeDefinitions = json['children'] as List<dynamic>?;

    if (id == null || id.isEmpty) {
      print("Error: Navigator widget requires a unique 'id'.");
      return const Center(child: Text("Navigator requires ID"));
    }

    final navigatorNotifier = context.read<NavigatorStateNotifier>();
    final GlobalKey<NavigatorState> navigatorKey = navigatorNotifier.getOrCreateNavigatorKey(id);

    final String initialRoute = properties['initialRoute'] as String? ?? '/';

    final Map<String, WidgetBuilder> nestedRoutes = _buildNestedRoutes(context, routeDefinitions, params);

    if (!nestedRoutes.containsKey(initialRoute)) {
      print("Error: Initial nested route '$initialRoute' not found in defined routes for Navigator '$id'. Using '/' if available.");
      if (!nestedRoutes.containsKey('/')) {
        return Center(child: Text("Error: No initial or '/' route found for Navigator '$id'"));
      }
    }

    print("[NavigatorBuilder] Building Navigator '$id' with initialRoute: '$initialRoute' and ${nestedRoutes.length} nested routes.");

    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        print("[Navigator '$id'] Generating route for: ${settings.name}");
        final builder = nestedRoutes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        }
        print("Error: Nested route '${settings.name}' not found in Navigator '$id'.");
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: const Text("Error de Ruta Interna")),
            body: Center(child: Text("Ruta interna no encontrada: ${settings.name}")),
          ),
        );
      },

      // Puedes añadir observers si necesitas escuchar cambios en este navigator específico
      // observers: <NavigatorObserver>[ ... ],

    );
  }
}