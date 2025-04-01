import 'package:frontend/comm/receiver.dart';

class ReceiverImpl implements Receiver {

  @override
  void receive(String mensaje) {
    print("[Flutter] recibio: $mensaje");
  }

}