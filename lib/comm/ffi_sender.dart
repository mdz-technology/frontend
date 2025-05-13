import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'native_lib.dart';

typedef SendMessageToRustC = Void Function(Pointer<Utf8>);
typedef SendMessageToRustDart = void Function(Pointer<Utf8>);

final SendMessageToRustDart sendMessageToRust = nativeLib
    .lookup<NativeFunction<SendMessageToRustC>>("send_message_to_rust")
    .asFunction();

class FFISender {
  void send(String message) {
    sendMessageToRust(message.toNativeUtf8());
    print("[Flutter] envio: $message");
  }
}
