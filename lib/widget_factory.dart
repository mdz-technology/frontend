import 'package:flutter/cupertino.dart';

typedef WidgetBuilderFunction = Widget Function(BuildContext context, Map<String, dynamic> json);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

typedef WidgetBuilderWithParamsFunction = Widget Function(
    BuildContext context,
    Map<String, dynamic> json,
    [Map<String, dynamic>? params]
    );

class WidgetFactory {

  static final Map<String, TextEditingController> textControllers = {};
  static final Map<String, FocusNode> focusNodes = {};

  static final Map<String, WidgetBuilderWithParamsFunction> _widgetBuilders = {};


  static Map<String, WidgetBuilderWithParamsFunction> get widgetBuilders => _widgetBuilders;

  static void registerBuilder(String type, WidgetBuilderWithParamsFunction builder) {
    if (_widgetBuilders.containsKey(type)) {
      print('Advertencia: El builder para el tipo "$type" ya está registrado.');
    }
    _widgetBuilders[type] = builder;
  }

  static Widget buildWidgetFromJson(
      BuildContext context,
      Map<String, dynamic> json,
      [Map<String, dynamic>? params] // Acepta el mapa de parámetros
      ) {
    final widgetType = json['type'];
    final builderFunction = widgetBuilders[widgetType];
    if (builderFunction != null) {
      return builderFunction(context, json, params);
    } else {
      print('Tipo de widget no soportado: $widgetType');
      return Container();
    }
  }

  /*
  static final Map<String, WidgetBuilderFunction> widgetBuilders = {
    'App': (context, json) => buildApp(context, json),
    'Scaffold': (context, json) => buildScaffold(context, json),
    'AppBar': (context, json) => buildAppBar(context, json),
    'Text': (context, json) => buildText(context, json),
    'Container':  (context, json) => buildContainer(context, json),
    'Drawer': buildDrawer,
    'PreferredSizeWidget': (context, json) => buildPreferredSizeWidget(context, json) as PreferredSizeWidget,
    'Padding': buildPadding,
    'Column': buildColumn,
    'Row': buildRow,

    'ElevatedButton': buildElevatedButton,
    'TextField': buildTextField,
    'Center': buildCenter,
    'Icon': buildPlatformIcon,
    'ListView': buildListView,
    'Card': buildCard,
    'ListTitle': buildListTitle,
    'Expanded': buildExpanded,
    'SizedBox': buildSizedBox,
    'ResponsiveMasterDetail': buildResponsiveMasterDetail,
    'SingleChildScrollView': buildSingleChildScrollView,
    'IconButton': buildIconButton,
    'Checkbox': buildCheckbox,
    'Dropdown': buildDropdown,
    // Agrega aquí más tipos de widgets
  };

  static Widget buildWidgetFromJson(BuildContext context, Map<String, dynamic> json) {
    final widgetType = json['type'];
    final builderFunction = widgetBuilders[widgetType];
    if (builderFunction != null) {
      return builderFunction(context, json);
    } else {
      print('Tipo de widget no soportado: $widgetType');
      return Container(); // Retorna un widget vacío si el tipo no está definido
    }
  }*/

  static FocusNode getFocusNode(String key) {
    if (!focusNodes.containsKey(key)) {
      focusNodes[key] = FocusNode();
    }
    return focusNodes[key]!;
  }

  static Map<String, TextEditingController> getTextControllers() {
    return textControllers;
  }

}

