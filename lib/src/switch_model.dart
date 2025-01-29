import '../triple_switch.dart';

class SwitchModel {
  SwitchPosition? position;
  int? timeout;

  SwitchModel({this.position, this.timeout});

  // SwitchModel copyWith({SwitchPosition? position, int? timeout}) =>
  //   SwitchModel(
  //     position: position ?? this.position,
  //     timeout: timeout ?? this.timeout,
  //   );
}