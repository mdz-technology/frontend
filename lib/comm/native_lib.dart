import 'dart:ffi';
import 'dart:io';

final DynamicLibrary nativeLib = _loadNativeLib();

DynamicLibrary _loadNativeLib() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libbackend.so'); // Android la busca en jniLibs automáticamente
  } else if (Platform.isLinux) {
    return DynamicLibrary.open('./native_libs/linux/libbackend.so');
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('./native_libs/macos/libbackend.dylib');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('native_libs/windows/backend.dll');
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}