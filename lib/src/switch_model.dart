import 'dart:isolate';

import '../triple_switch.dart';

class SwitchModel {
  SwitchPosition? position;       // Position of switcher
  SwitchPosition? prePosition;    // Previous position of switcher
  int  timeout = 0;     // Timer value (0 - N), if timer has positive value and zero, state Wait, or position
  bool active = false;  // State timer, true - On / false - Off
  Isolate? isolate;     // Isolate for switchers work

  SwitchModel();        // Default constructor of class
}