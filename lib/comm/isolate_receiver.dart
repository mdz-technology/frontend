import 'dart:ffi';
import 'dart:isolate';
import 'dart:ui';
import 'package:frontend/comm/receiver.dart';
import 'package:frontend/comm/receiver_impl.dart';
import 'dart_post_c_object_receiver.dart';

class IsolateReceiver {

  late final ReceivePort receivePort = ReceivePort();

  void initialize() {
    _startMessageListener(receivePort);
    registerDartPostCObjectReceiver();
  }

  void _startMessageListener(ReceivePort receivePort) {
    Receiver receiver = ReceiverImpl();
    receivePort.listen((mensaje) {
      receiver.receive(mensaje);
    });
  }

  int getRustSendPort() {
    final sendPortRust = receivePort.sendPort;
    IsolateNameServer.registerPortWithName(sendPortRust, 'rust_port');
    final int sendPortNative = receivePort.sendPort.nativePort;
    return sendPortNative;
  }
  
}





