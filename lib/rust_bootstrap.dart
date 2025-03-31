import 'dart:ffi';
import 'dart:isolate';
import 'receive_port.dart';
import 'ffi_sender.dart';
import 'dart:async';

// Función nativa para iniciar el hilo en Rust
typedef StartRustThreadC = Void Function(Int64);
typedef StartRustThreadDart = void Function(int);

// Cargamos la librería Rust
final DynamicLibrary nativeLib = DynamicLibrary.open('../backend/target/debug/libbackend.so');

void startRustIsolate(int sendPortNative) {
  final StartRustThreadDart startRustThread = nativeLib
      .lookup<NativeFunction<StartRustThreadC>>('start_rust_thread')
      .asFunction();

  startRustThread(sendPortNative);
}


void launchRust() {
  final int sendPortNative = setupRustCommunication();
  Isolate.spawn(startRustIsolate, sendPortNative);

  Isolate.spawn((_) {
    int counter = 1;
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      String msg = "Mensaje $counter enviado";
      sendMultipleMessagesToRust(msg); // 🔹 Envía el mensaje a Rust
      counter++;
    });
  }, null);


}


