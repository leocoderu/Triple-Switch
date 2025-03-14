import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

class SwitchModel {

  /// Position of switch, true -> ON / false -> OFF
  bool position;

  /// Timer value (0 - N), null is timer OFF
  int? timeout;

  /// Isolate for Timer
  Isolate? _isoTime;

  /// Isolate for Function
  Isolate? _isoFunc;

  /// Result value of heavy function, null is doesn't have a result
  dynamic result;

  /// Result state, null is doesn't have a result, true - success / false - error
  bool? success;

  /// Function for save result
  Function(bool)? saveFunc;

  /// Default Constructor
  SwitchModel({this.position = false, this.saveFunc});
}

class SwitchState extends ChangeNotifier {

  /// List of switches
  Map<String, SwitchModel> data = {};

  /// Initialize Singleton
  SwitchState._();
  static final SwitchState _switchState = SwitchState._();
  factory SwitchState() => _switchState;

  /// Start function
  Future<void> start(String name, int? time, Function? function,
    List<dynamic>? arguments) async {

      if (time == null) {

        /// Unknown result
        data[name]!.result = null;

        /// The result successfully unknown
        data[name]!.success = null;

        /// Inverse switch position
        data[name]!.position = !data[name]!.position;

        /// If save function exists
        if (data[name]!.saveFunc != null) {
          /// Send result to save function
          data[name]!.saveFunc!(data[name]!.position);
        }

        /// Notify listeners
        notifyListeners();
        return;
      }

      /// Open listener timer port
      final timerPort = ReceivePort();

      /// Open listener function port
      final funcPort = ReceivePort();

      /// Set timeout
      data[name]!.timeout = time;

      /// Drop the previous result
      data[name]!.result = null;

      /// Drop the previous success result
      data[name]!.success = null;

      /// Drop timer isolate
      data[name]!._isoTime = null;

      /// Drop function isolate
      data[name]!._isoFunc = null;

      /// There may be an excessive notification,
      /// as it occurs below in the _listenTimer
      /// Notify listeners
      notifyListeners();

      /// Start isolate for timer
      data[name]!._isoTime = await Isolate.spawn(
        _isoTimer, [timerPort.sendPort, data[name]!.timeout!]
      );

      /// Start listen timer port
      _listenTimer(name, timerPort, funcPort);

      /// If heavy function exists, start heavy function in isolate
      if (function != null) {
        data[name]!._isoFunc = await Isolate.spawn(
            _isoFunction, [funcPort.sendPort, function, arguments ?? []]
        );

        /// Start listen heavy function port
        _listenFunc(name, funcPort, timerPort);
      }
    }

  /// Listener for Timer port
  void _listenTimer(String name, ReceivePort portTimer, ReceivePort portFunc) {
    portTimer.listen((time) {

      /// If Timer was complete
      if (time == null) {

        /// Stop Timer Listener
        portTimer.close();

        /// Stop Function Listener
        portFunc.close();

        /// Stop Isolates
        stop(name);
        return;
      }

      /// Set new value of Timer
      data[name]!.timeout = time;

      /// Notify Listeners
      notifyListeners();
    });
  }

  /// Listener for heavy function port
  void _listenFunc(String name, ReceivePort portFunc, ReceivePort portTimer) {
    portFunc.listen((res) {

      /// If result of heavy function was received
      /// Result of heavy function
      data[name]!.result = res[0];

      /// The result of successful operation
      data[name]!.success = res[1];

      /// Change switch position
      data[name]!.position =
          res[1] ? !data[name]!.position : data[name]!.position;

      /// If save function exists
      if (data[name]!.saveFunc != null) {
        /// Send position to save function
        data[name]!.saveFunc!(data[name]!.position);
      }

      /// Maybe it's not necessary!!!
      /// Listeners are notified in the function below stop
      /// Notify Listeners
      notifyListeners();

      /// Stop Function Listener
      portFunc.close();

      /// Stop Timer Listener
      portTimer.close();

      /// Stop Isolates
      stop(name);
    });
  }

  /// Stop isolate
  Future<void> stop(String name) async {
    /// If the isolation timer is not started, stop nothing.
    if (data[name]!._isoTime == null) return;

    /// If heavy function isolate exists, kill him
    if (data[name]!._isoFunc != null) {
      /// Kill the function isolate
      data[name]!._isoFunc!.kill();

      /// Variable of function isolate set to null
      data[name]!._isoFunc = null;
    }

    /// Kill the timer isolate
    data[name]!._isoTime!.kill();

    /// Variable of timer isolate set to null
    data[name]!._isoTime = null;

    /// Set timeout as null
    data[name]!.timeout = null;

    /// Notify Listeners
    notifyListeners();
  }

  /// Isolate for Timer
  static Future<void> _isoTimer(List<dynamic> data) async {

    /// First argument is port
    final SendPort sendPort = data[0];

    /// Second argument is timeout
    final int timeout = data[1];

    for (int i = (timeout - 1); i >= 0; --i) {
      /// Send new timeout value to port every second
      await Future.delayed(const Duration(seconds: 1), () => sendPort.send(i));
    }

    /// Send to the port null as completion of the isolate
    sendPort.send(null);
  }

  /// Isolate for Heavy function
  static Future<void> _isoFunction(List<dynamic> args) async {

    /// First argument is port
    final SendPort sendPort = args[0];

    /// Second argument is function
    final Function func = args[1];

    /// Third argument are arguments of function
    final List<dynamic> arguments = args[2];

    /// Get result of function with arguments
    final result = await func(arguments);

    /// Send to the port result
    sendPort.send(result);
  }
}
