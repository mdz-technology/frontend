import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'rust_bootstrap.dart';

typedef SendMessageToRustC = Void Function(Pointer<Utf8>);
typedef SendMessageToRustDart = void Function(Pointer<Utf8>);

final SendMessageToRustDart sendMessageToRust =
nativeLib.lookup<NativeFunction<SendMessageToRustC>>("send_message_to_rust")
    .asFunction();

// Función para enviar mensajes reales a Rust desde Dart
void sendMultipleMessagesToRust(String message) {
    //Future.delayed(Duration(seconds: 2), () {
      sendMessageToRust(message.toNativeUtf8());
      print("[Flutter] Flutter envio: $message");
    //});
}