import 'dart:ffi';
import 'dart:isolate';
import 'dart:ui';
import 'rust_bootstrap.dart';

// Tipo de función para `Dart_PostCObject_DL`
typedef DartPostCObjectFn = Bool Function(Int64, Pointer<Void>);

// Función nativa para registrar `Dart_PostCObject_DL`
typedef RegisterDartPostCObjectC = Void Function(Pointer<NativeFunction<DartPostCObjectFn>>);
typedef RegisterDartPostCObjectDart = void Function(Pointer<NativeFunction<DartPostCObjectFn>>);

// Obtenemos las funciones de Rust
final RegisterDartPostCObjectDart registerDartPostCObject = nativeLib
    .lookup<NativeFunction<RegisterDartPostCObjectC>>('register_dart_post_cobject')
    .asFunction();

int setupRustCommunication() {
  final receivePortRust = ReceivePort();
  final sendPortRust = receivePortRust.sendPort;

  IsolateNameServer.registerPortWithName(sendPortRust, 'rust_port');

  receivePortRust.listen((mensaje) {
    print("[Flutter] Flutter recibio: $mensaje");
  });

  // ✅ Registramos `Dart_PostCObject_DL` en Rust correctamente
  final Pointer<NativeFunction<DartPostCObjectFn>> dartPostCObjectPtr =
  NativeApi.postCObject.cast();
  registerDartPostCObject(dartPostCObjectPtr);

  // Obtener el SendPort y pasarlo a Rust
  final int sendPortNative = receivePortRust.sendPort.nativePort;
  return sendPortNative;
}