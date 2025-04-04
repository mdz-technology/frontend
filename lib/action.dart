import 'package:flutter/widgets.dart';

void handleAction(BuildContext context, Map<String, dynamic> action,
    [Map<String, dynamic>? params]) {
  final actionType = action['action'];

  switch (actionType) {
    case 'navigate':
// Manejo de navegación
      final route = action['data']?['route'];
      if (route != null) {
        Navigator.pushNamed(context, route);
      } else {
        print('Error: La acción de navegación no tiene ruta especificada.');
      }
      break;

    default:
// Enviar otras acciones al backend
      if (actionType != null) {
//webSocketService.sendMessage(actionType, action['data'] ?? {});
        print('Acción enviada al backend: $actionType');
      } else {
        print('Error: Acción no especificada.');
      }
      break;
  }
/*
    final provider = Provider.of<DetailProvider>(context, listen: false);

    switch (actionType) {
      case 'logChange':
        print('Cambio de texto: ${params?['text']}');
        break;
      case 'submitText':
        final controllerKey = action['target'];
        if (controllerKey != null && textControllers.containsKey(controllerKey)) {
          final text = textControllers[controllerKey]?.text ?? '';
          print('Texto enviado: $text');
        }
        break;
      case 'updateDetail':
        final id = action['data']['id'];
        provider.updateDetail(id);
        break;
      case 'addItem':
      // Añadir un nuevo elemento tomando directamente el mapa de data
        final newItem = Map<String, dynamic>.from(action['data'] ?? {});
        final newId = provider.add(newItem);
        // Seleccionar automáticamente el nuevo ítem
        provider.updateDetail(newId);
        break;
        break;
      case 'updateDetailField':
        final field = action['data']['field'];
        final newValue = action['data']['newValue'];

        // Si 'newValue' es nulo, significa que no es Checkbox/Dropdown, podría ser un TextField.
        // En ese caso, leer del controlador:
        final valueToUpdate = newValue ?? (WidgetFactory.textControllers[field]?.text ?? '');

        provider.updateField(field, valueToUpdate);
        break;
      case 'removeItem':
        final id = action['data']['id'];
        provider.remove(id);
        break;
      case 'saveDetail':
      // Recopilar todos los texto de los TextField
        final updatedData = {
          for (var entry in WidgetFactory.textControllers.entries)
            entry.key: entry.value.text
        };

        // Obtener la data actual del detalle para no perder campos
        final currentDetail = provider.detailData;
        if (currentDetail != null) {
          // Combinar el updatedData con el currentDetail, dando prioridad a los nuevos textos
          final finalData = {
            ...currentDetail,
            ...updatedData
          };
          provider.save(finalData);
        } else {
          // Si por alguna razón detailData es null, guardar lo que tengas
          provider.save(updatedData);
        }
        break;
      case 'cancelEdit':
        provider.cancelEdit();
        break;
      case 'navigate':
        final route = action['data']['route'];
        if (route != null) {
          // Ajustar la pantalla antes de navegar
          if (route == '/screenC') {
            provider.setScreen("C");
          } else if (route == '/screenD') {
            provider.setScreen("D");
          }
          Navigator.pushNamed(context, route);
        }
        break;
      default:
        print('Acción no soportada: $actionType');
    }*/
}
