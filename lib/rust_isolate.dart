
//'../backend/target/debug/libbackend.so'

import 'dart:ffi';
import 'dart:isolate';
import 'dart:io';
import 'dart:ui';
import 'package:ffi/ffi.dart';

import 'dart:ffi';
import 'dart:isolate';
import 'dart:io';

// Tipo de función para `Dart_PostCObject_DL`
typedef DartPostCObjectFn = Bool Function(Int64, Pointer<Void>);

// Función nativa para registrar `Dart_PostCObject_DL`
typedef RegisterDartPostCObjectC = Void Function(Pointer<NativeFunction<DartPostCObjectFn>>);
typedef RegisterDartPostCObjectDart = void Function(Pointer<NativeFunction<DartPostCObjectFn>>);

// Función nativa para iniciar el hilo en Rust
typedef StartRustThreadC = Void Function(Int64);
typedef StartRustThreadDart = void Function(int);

// Cargamos la librería Rust
final DynamicLibrary nativeLib = DynamicLibrary.open('../backend/target/debug/libbackend.so');

// Obtenemos las funciones de Rust
final RegisterDartPostCObjectDart registerDartPostCObject = nativeLib
    .lookup<NativeFunction<RegisterDartPostCObjectC>>('register_dart_post_cobject')
    .asFunction();

final StartRustThreadDart startRustThread = nativeLib
    .lookup<NativeFunction<StartRustThreadC>>('start_rust_thread')
    .asFunction();

void starta() {
  final receivePort = ReceivePort();
  final sendPort = receivePort.sendPort;

  IsolateNameServer.registerPortWithName(sendPort, 'rust_port');

  receivePort.listen((mensaje) {
    print("Mensaje recibido desde Rust: $mensaje");
  });

  // ✅ Registramos `Dart_PostCObject_DL` en Rust correctamente
  final Pointer<NativeFunction<DartPostCObjectFn>> dartPostCObjectPtr =
  NativeApi.postCObject.cast();
  registerDartPostCObject(dartPostCObjectPtr);

  // ✅ Iniciamos el hilo en Rust con el puerto correcto
  startRustThread(sendPort.nativePort);

  print("Hilo Rust iniciado...");
}

