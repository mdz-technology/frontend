import 'package:flutter/cupertino.dart';
import 'package:frontend/widgets/utils.dart';

import '../widget_factory.dart';

class CustomCupertinoDrawer extends StatefulWidget {
  final Map<String, dynamic> json;

  const CustomCupertinoDrawer({required this.json, super.key});

  @override
  State<CustomCupertinoDrawer> createState() => _CustomCupertinoDrawerState();
}

class _CustomCupertinoDrawerState extends State<CustomCupertinoDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double maxSlide = 280.0;

  late Map<String, dynamic> styles;
  late Map<String, dynamic> properties;
  late List<dynamic> childrenJson;
  late Map<String, dynamic> bodyJson;

  @override
  void initState() {
    super.initState();
    styles = (widget.json['styles'] as Map<String, dynamic>?) ?? {};
    properties = (widget.json['properties'] as Map<String, dynamic>?) ?? {};
    childrenJson = (widget.json['children'] as List<dynamic>?) ?? [];
    bodyJson = (widget.json['body'] as Map<String, dynamic>?) ?? {};

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _toggleDrawer() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerWidth = (properties['width'] as num?)?.toDouble() ?? maxSlide;

    // Drawer panel
    final drawerContent = Container(
      width: drawerWidth,
      color: parseColor(styles['backgroundColor']) ?? CupertinoColors.systemBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: childrenJson
            .map((childJson) => WidgetFactory.buildWidgetFromJson(context, childJson))
            .toList(),
      ),
    );


    final bodyWidget = WidgetFactory.buildWidgetFromJson(context, bodyJson);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _controller.value += details.primaryDelta! / maxSlide;
      },
      onHorizontalDragEnd: (details) {
        if (_controller.value >= 0.5) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final slide = maxSlide * _controller.value;
          return Stack(
            children: [
              drawerContent,
              Transform.translate(
                  offset: Offset(slide, 0),
                  child: CupertinoPageScaffold(
                    backgroundColor: CupertinoColors.systemBackground,
                    child: Stack(
                      children: [
                        bodyWidget,
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          left: 8,
                          child: GestureDetector(
                            onTap: _toggleDrawer,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey.withOpacity(.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                CupertinoIcons.bars,
                                size: 28,
                                //color: parseColor(styles['shadowColor']) ?? CupertinoColors.label,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

