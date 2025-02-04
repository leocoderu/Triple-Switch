import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

import 'switch_model.dart';
import 'triple_switch.dart';


class SwitchState extends ChangeNotifier{

  Map<String, SwitchModel> data = {};

  // Initialize Singleton
  SwitchState._();
  static final SwitchState _switchState = SwitchState._();
  factory SwitchState() => _switchState;

  Future<void> start(String name, int time) async {
    final timerPort = ReceivePort();
    if (data[name]!.active) return;   // preventing a restart

    stop(name, data[name]!.position ?? SwitchPosition.off);                       // stop isolated

    data[name]!.prePosition = data[name]!.position;
    data[name]!.timeout = time;
    data[name]!.active = true;
    notifyListeners();

    // start isolate
    data[name]!.isolate = await Isolate.spawn(startTimer, (timeout: data[name]!.timeout, sendPort: timerPort.sendPort));
    _listener(name, timerPort);
  }

  void _listener(String name, ReceivePort port) {
    port.listen((time) {
      if (time < 0) {
        // data[name]!.timeout = 0;
        // data[name]!.active = false;
        // data[name]!.position = data[name]!.prePosition;
        // notifyListeners();

        _stopByTimeout(name); return;
      }

      data[name]!.timeout = time;
      notifyListeners();
    });
  }

  Future<void> stop(String name, SwitchPosition position) async {
    if (data[name]!.isolate == null) return;

    data[name]!.isolate!.kill();
    data[name]!.isolate = null;
    data[name]!.timeout = 0;
    data[name]!.active = false;
    data[name]!.position = position;
    notifyListeners();
  }

  Future<void> _stopByTimeout(String name) async {
    if (data[name]!.isolate == null) return;

    data[name]!.isolate!.kill();
    data[name]!.isolate = null;
    data[name]!.timeout = 0;
    data[name]!.active = false;
    data[name]!.position = data[name]!.prePosition;
    notifyListeners();
  }


  // SwitchPosition? getPosition() => position;
  void setPosition(String name, SwitchPosition? swp) {
    data[name]!.position = swp;
    notifyListeners();
  }
  //
  // int? getTimeout() => timeout;
  // void setTimeout(int? time) {
  //   timeout = time;
  //   notifyListeners();
  // }
}

void startTimer(({int? timeout, SendPort sendPort}) data) async {
  for (int i = ((data.timeout ?? 0) - 1); i >= -1; --i) {
    await Future.delayed(const Duration(seconds: 1), () => data.sendPort.send(i));
  }
}