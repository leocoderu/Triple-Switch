// Import Dart and Flutter
import 'dart:isolate';
import 'package:flutter/material.dart';

// Import Modules
import 'switch_notifier.dart';
import 'triple_switch_ui.dart';

enum SwitchPosition {on, wait, off}

class TripleSwitch extends StatelessWidget {
  final SwitchPosition? position;
  final int? timeoutOffOn;
  final int? timeoutOnOff;
  final ValueChanged<SwitchPosition>? onChanged;

  const TripleSwitch({super.key, this.position, this.timeoutOffOn, this.timeoutOnOff, this.onChanged});

  //Get Timeout by dependence from direction Off->On / On->Off
  int? timeoutByDirection(SwitchPosition? swp) =>
      (swp == SwitchPosition.on) ? timeoutOnOff : timeoutOffOn;

  @override
  Widget build(BuildContext context) {
    final timerPort = ReceivePort();
    final SwitchNotifier switchNotifier = SwitchNotifier();

    return ListenableBuilder(
          listenable: switchNotifier,
          builder: (context, child) {
            print('Switch notifier position: ${switchNotifier.position}');
            print('Switch notifier timout:   ${switchNotifier.timeout}');
            return TripleSwitchUI(
              position: switchNotifier.position ?? position,
              timeout: switchNotifier.timeout ?? timeoutByDirection(switchNotifier.position ?? position),
              onChanged: (onChanged != null) ? (value) {
                if (value == SwitchPosition.wait) {
                  switchNotifier.setTimeout(timeoutByDirection(switchNotifier.position ?? position));

                  // Run timer with descending value
                  Isolate.spawn(startTimer, (timeout: switchNotifier.timeout ?? (timeoutByDirection(position) ?? 0), sendPort: timerPort.sendPort));

                  timerPort.listen((time){
                    print('I have been listen some thing, like: $time');

                    // Send Data to state
                    if (time != null) { switchNotifier.setTimeout(time);}
                      else { switchNotifier.setPosition(position);}

                    if (time == null) timerPort.close();
                  });

                }
                // Set Switcher to new position
                switchNotifier.setPosition(value);

                // TODO: Запуск Изолята с конкретной операцией вероятно выше по дереву ?!?
                onChanged!(value);
              } : null,
            );
          }
      );
  }
}

void startTimer(({int timeout, SendPort sendPort}) data) async {
  for (int i = (data.timeout - 1); i >= 0; --i) {
    await Future.delayed(const Duration(seconds: 1), () => data.sendPort.send(i));
  }
  data.sendPort.send(null);
  //print('isolate finished');
}

// Инверсия позиции тумблера
// switchPosition iPos(switchPosition swPos) =>
//     (swPos == switchPosition.on) ? switchPosition.off : switchPosition.on;
//
// Если Таймер еще идет и получен результат с Изолята, если результат положительный
// Переключаем тумблер дальше, иначе возвращаем в исходную позицию
// if ((timeOut != null) && (resData.exist)) {
//   swPos = resData ? iPos(prePos) : prePos;
// }