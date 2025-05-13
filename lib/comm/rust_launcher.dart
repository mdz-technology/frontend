import 'dart:ffi';
import 'dart:isolate';

import 'isolate_receiver.dart';
import 'native_lib.dart';

typedef StartRustThreadC = Void Function(Int64);
typedef StartRustThreadDart = void Function(int);

void launchRust() {
  IsolateReceiver isolateReceiver = IsolateReceiver();
  isolateReceiver.initialize();
  Isolate.spawn(_startRustThread, isolateReceiver.getRustSendPort());
}

void _startRustThread(int sendPortNative) {
  final StartRustThreadDart startRustThread = nativeLib
      .lookup<NativeFunction<StartRustThreadC>>('start_rust_thread')
      .asFunction();

  startRustThread(sendPortNative);
}




