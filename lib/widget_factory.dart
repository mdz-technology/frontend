import 'package:flutter/cupertino.dart';
import 'package:frontend/padding_builder.dart';
import 'package:frontend/row_builder.dart';
import 'package:frontend/widgets/navbar_builder.dart';
import 'package:frontend/widgets/scaffold_builder.dart';
import 'package:frontend/widgets/text_builder.dart';
import 'package:frontend/textfield_builder.dart';

import 'listview_builder.dart';
import 'widgets/appbar_builder.dart';
import 'widgets/elevatedbutton_builder.dart';
import 'center_builder.dart';
import 'widgets/column_builder.dart';
import 'container_builder.dart';
import 'drawer_builder.dart';
import 'widgets/app_builder.dart';
import 'icon_builder.dart';

typedef WidgetBuilderFunction = Widget Function(Map<String, dynamic> json);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class WidgetFactory {

  static final Map<String, TextEditingController> textControllers = {};
  static final Map<String, FocusNode> focusNodes = {};

  static final Map<String, WidgetBuilderFunction> widgetBuilders = {
    'App': buildApp,
    'Scaffold': buildScaffold,
    'AppBar': buildAppBar,
    'Padding': buildPadding,
    'Column': buildColumn,
    'Row': buildRow,
    'Drawer': buildDrawer,
    'Container': buildContainer,
    'Text': buildText,
    'ElevatedButton': buildElevatedButton,
    'TextField': buildTextField,
    'Center': buildCenter,
    'Icon': buildPlatformIcon,
    'ListView': buildListView,
    /*'ListTitle': buildListTitle,
    'Expanded': buildExpanded,
    'SizedBox': buildSizedBox,
    'ResponsiveMasterDetail': buildResponsiveMasterDetail,
    'SingleChildScrollView': buildSingleChildScrollView,
    'IconButton': buildIconButton,
    'Checkbox': buildCheckbox,
    'Dropdown': buildDropdown,*/
    // Agrega aquí más tipos de widgets
  };

  static Widget buildWidgetFromJson(Map<String, dynamic> json) {
    final widgetType = json['type'];
    final builderFunction = widgetBuilders[widgetType];
    if (builderFunction != null) {
      return builderFunction(json);
    } else {
      print('Tipo de widget no soportado: $widgetType');
      return Container(); // Retorna un widget vacío si el tipo no está definido
    }
  }

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

