import 'package:frontend/comm/ffi_sender.dart';
import 'package:frontend/comm/sender.dart';

class SenderImpl implements Sender {

  @override
  void send(String message) {
    FFISender().send(message);
  }

}