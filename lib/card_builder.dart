import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend/widget_factory.dart';
import 'package:frontend/widgets/widget_state_notifier.dart';
import 'package:provider/provider.dart';

Widget buildCard(BuildContext context, Map<String, dynamic> json) {
  final widgetId = json['id'];
  final padding = _parseEdgeInsets(json['properties']?['padding']);
  final childrenJson = json['children'] as List<dynamic>? ?? [];

  // Generación dinámica de widgets a partir del JSON
  final childWidgets = childrenJson
      .map((child) => WidgetFactory.buildWidgetFromJson(context, child))
      .toList();

  return CardWidget(
    padding: padding,
    widgetId: widgetId,
    children: childWidgets,
  );
}

EdgeInsets? _parseEdgeInsets(dynamic value) {
  if (value is Map<String, dynamic>) {
    if (value.containsKey('all')) {
      return EdgeInsets.all((value['all'] ?? 0.0).toDouble());
    }
    return EdgeInsets.only(
      left: (value['left'] ?? 0.0).toDouble(),
      top: (value['top'] ?? 0.0).toDouble(),
      right: (value['right'] ?? 0.0).toDouble(),
      bottom: (value['bottom'] ?? 0.0).toDouble(),
    );
  }
  return null;
}

class CardWidget extends StatelessWidget {
  final String widgetId;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const CardWidget({
    Key? key,
    required this.widgetId,
    required this.children,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Aquí pasamos directamente los widgets generados
                ...children, // Se agregan todos los widgets en la lista `children`
              ],
            ),
          ),
        ),
      ),
      cupertino: (_, __) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: padding ?? const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.resolveFrom(context).withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Aquí también pasamos directamente los widgets generados
              ...children,
            ],
          ),
        ),
      ),
    );
  }

}