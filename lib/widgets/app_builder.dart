import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'; // Importa flutter_platform_widgets
import 'package:frontend/widget_factory.dart';

Widget buildApp(Map<String, dynamic> json) {
  String defaultInitialRoute = '/';
  Widget defaultHome = Container();
  Map<String, dynamic> defaultRoutesJson = {};
  GlobalKey<NavigatorState> defaultNavigatorKey = GlobalKey<NavigatorState>();

  String initialRoute = json['initialRoute'] ?? defaultInitialRoute;
  Widget? home = json['home'] != null && json['initialRoute'] == null
      ? WidgetFactory.buildWidgetFromJson(json['home'])
      : null;

  Map<String, dynamic>? routesJson = json['routes'] ?? defaultRoutesJson;
  GlobalKey<NavigatorState> navigatorKey = json['navigatorKey'] ?? defaultNavigatorKey;

  Map<String, WidgetBuilder> routes = {};

  routesJson?.forEach((key, value) {
    routes[key] = (context) => WidgetFactory.buildWidgetFromJson(value);
  });

  return PlatformApp(
    initialRoute: initialRoute,
    routes: routes,
    navigatorKey: navigatorKey,
    home: json['initialRoute'] == null ? home : null,
  );
}