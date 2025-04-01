import 'dart:ffi';
import 'rust_launcher.dart';

typedef DartPostCObjectFn = Bool Function(Int64, Pointer<Void>);

typedef RegisterDartPostCObjectC = Void Function(
    Pointer<NativeFunction<DartPostCObjectFn>>);

typedef RegisterDartPostCObjectDart = void Function(
    Pointer<NativeFunction<DartPostCObjectFn>>);

final RegisterDartPostCObjectDart registerDartPostCObject = nativeLib
    .lookup<NativeFunction<RegisterDartPostCObjectC>>(
        'register_dart_post_cobject')
    .asFunction();

final Pointer<NativeFunction<DartPostCObjectFn>> dartPostCObjectPtr =
    NativeApi.postCObject.cast();

void registerDartPostCObjectReceiver() {
  registerDartPostCObject(dartPostCObjectPtr);
}
