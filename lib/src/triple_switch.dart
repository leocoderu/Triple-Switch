// Import Dart and Flutter
import 'package:flutter/material.dart';

// Import Modules
import 'switch_model.dart';
import 'switch_notifier.dart';
import 'triple_switch_ui.dart';

enum SwitchPosition {on, wait, off}

class TripleSwitch extends StatelessWidget {
  final String id;
  final SwitchPosition? value;
  final bool? result;
  final int? timeoutOffOn;
  final int? timeoutOnOff;
  final ValueChanged<SwitchPosition?>? onChanged;

  const TripleSwitch({super.key, required this.id, this.value, this.result, this.timeoutOffOn, this.timeoutOnOff, this.onChanged});

  //Get Timeout by dependence from direction Off->On / On->Off
  int timeoutByDirection(SwitchPosition? swp) =>
      ((swp == SwitchPosition.on) ? timeoutOnOff : timeoutOffOn) ?? 0;

  SwitchPosition? non(SwitchPosition? value) {
    if (value == null) return null;
    return (value == SwitchPosition.on) ? SwitchPosition.off : SwitchPosition.on;
  }

  @override
  Widget build(BuildContext context) {

    //final SwitchState switchers = SwitchState()..data.addAll({id : SwitchModel()});
    final SwitchState switchers = SwitchState();
    //print('Keys: ${switchers.data.keys}');

    return ListenableBuilder(
          listenable: switchers,
          builder: (context, child) {
            print('Switch notifier position: ${switchers.data[id]!.position}');
            print('Switch notifier timout:   ${switchers.data[id]!.timeout}');
            return TripleSwitchUI(
              position: (result == null) ? (switchers.data[id]!.position ?? value) : (result! ? non(value) : value),
              //position: switchers.data[id]!.position,
              timeout: switchers.data[id]!.timeout == 0 ? timeoutByDirection(switchers.data[id]!.position ?? value) : switchers.data[id]!.timeout,
              //timeout: switchers.data[id]!.timeout,
              onChanged: () {
                if (onChanged != null) {
                  if (timeoutByDirection(switchers.data[id]!.position ?? value) != 0) {
                    switchers.setPosition(id, SwitchPosition.wait);
                    switchers.start(id, timeoutByDirection(switchers.data[id]!.position ?? value));
                  } else {

                    // Set Switcher to new position
                    switchers.setPosition(id, (value == SwitchPosition.on) ? SwitchPosition.off : SwitchPosition.on);
                  }
                  onChanged!(switchers.data[id]!.position);
                } else {
                  onChanged;
                }
              },


              // onChanged: (onChanged != null) ? (value) {
              //   if (value == SwitchPosition.wait) {
              //     switchers.start(id, timeoutByDirection(switchers.data[id]!.position ?? value));
              //   }
              //   // Set Switcher to new position
              //   switchers.setPosition(id, value);
              //
              //   // TODO: Запуск Изолята с конкретной операцией вероятно выше по дереву ?!?
              //   onChanged!(value);
              // } : null,
            );
          }
      );
  }
}

// void startTimer(({int timeout, SendPort sendPort}) data) async {
//   for (int i = (data.timeout - 1); i >= 0; --i) {
//     await Future.delayed(const Duration(seconds: 1), () => data.sendPort.send(i));
//   }
//   data.sendPort.send(null);
//   //print('isolate finished');
// }

// Если Таймер еще идет и получен результат с Изолята, если результат положительный
// Переключаем тумблер дальше, иначе возвращаем в исходную позицию
// if ((timeOut != null) && (resData.exist)) {
//   swPos = resData ? iPos(prePos) : prePos;
// }