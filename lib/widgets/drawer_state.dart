import 'package:flutter/foundation.dart';

class DrawerState extends ChangeNotifier {
  bool _isOpen = false;
  bool get isOpen => _isOpen;

  void toggleDrawer() {
    _isOpen = !_isOpen;
    print('[DrawerState] Estado cambiado a: isOpen = $_isOpen');
    notifyListeners();
  }
// Puedes añadir openDrawer y closeDrawer si los necesitas
}