// Import Dart and Flutter
import 'package:flutter/material.dart';

// Import Modules
import 'switch_state.dart';
import 'default_decoration_switch.dart';

//enum SwitchPosition {on, wait, off}

class TripleSwitch extends StatelessWidget {

  final String id;                              /// Unique ID of switch
  final bool? enabled;                          /// Enabled or Disabled switch
  //final bool value;                             /// Default value of switch, true - On / false - Off
  final int? timeoutOffOn;                      /// Timeout for wait switching Off -> On
  final int? timeoutOnOff;                      /// Timeout for wait switching On -> Off
  final Function? functionOffOn;                /// Calling a heavy function during switching Off -> On
  final Function? functionOnOff;                /// Calling a heavy function during switching On -> Off
  final List<dynamic>? argumentsOffOn;          /// Arguments of the called heavy function, Off -> On
  final List<dynamic>? argumentsOnOff;          /// Arguments of the called heavy function, On -> Off
  //final ValueChanged<bool>? onChanged;          /// Event returns new position of switch, it may be old or new position

  final BoxDecoration? decorationTrackOn;
  final BoxDecoration? decorationTrackOff;
  final BoxDecoration? decorationTrackWait;
  final BoxDecoration? decorationTrackDisabled;

  final BoxDecoration? decorationSliderOn;
  final BoxDecoration? decorationSliderOff;
  final BoxDecoration? decorationSliderWait;
  final BoxDecoration? decorationSliderDisabled;

  final Size? sizeTrack;
  final Size? sizeSlider;

  final int?  timeout;
  final String? textOn;
  final String? textOff;
  final String? textWait;
  final String? textDisabled;
  final TextStyle? textStyleEnabled;
  final TextStyle? textStyleDisabled;

  const TripleSwitch({
    super.key,
    required this.id,
    //required this.value,
    this.enabled,
    this.timeoutOffOn,
    this.timeoutOnOff,
    this.argumentsOffOn,
    this.functionOffOn,
    this.functionOnOff,
    this.argumentsOnOff,
    //this.onChanged,
    this.decorationTrackOn,
    this.decorationTrackOff,
    this.decorationTrackWait,
    this.decorationTrackDisabled,
    this.decorationSliderOn,
    this.decorationSliderOff,
    this.decorationSliderWait,
    this.decorationSliderDisabled,
    this.sizeTrack,
    this.sizeSlider,
    this.timeout,
    this.textOn,
    this.textOff,
    this.textWait,
    this.textDisabled,
    this.textStyleEnabled = defaultTextStyleEnabled,
    this.textStyleDisabled = defaultTextStyleDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final SwitchState switches = SwitchState();

    BoxDecoration? trackDecor;
    BoxDecoration? sliderDecor;
    Alignment? pos;
    String? text;

    if (switches.data[id]!.timeout != null) {
      trackDecor = decorationTrackWait ?? defaultDecorationTrackWait;
      sliderDecor = decorationSliderWait ?? defaultDecorationSliderWait;
      pos = Alignment.center;
      text = textWait ?? timeout.toString();
    } else {
      if (switches.data[id]!.position) {
        trackDecor = decorationTrackOn ?? defaultDecorationTrackOn;
        sliderDecor = decorationSliderOn ?? defaultDecorationSliderOn;
        pos = Alignment.centerRight;
        text = textOn;
      } else  {
        trackDecor = decorationTrackOff ?? defaultDecorationTrackOff;
        sliderDecor = decorationSliderOff ?? defaultDecorationSliderOff;
        pos = Alignment.centerLeft;
        text = textOff;
      }
    }

    return ListenableBuilder(
      listenable: switches,
      builder: (BuildContext ctx, child) {
        return GestureDetector(
          onTap: () {
            if(switches.data[id]!.timeout == null) { // preventing a restart
              switches.start(id,
                  switches.data[id]!.position ? timeoutOnOff : timeoutOffOn,
                  switches.data[id]!.position ? functionOnOff : functionOffOn,
                  switches.data[id]!.position ? argumentsOnOff : argumentsOffOn
              );
            }
            ///: null; //switches.stop(id); Нет смысла останавливать запрос, т.к. он д/б отработан
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: (enabled == false) ? defaultDecorationTrackDisabled : trackDecor,
            alignment: (enabled == false) ? Alignment.center : pos,
            width: sizeTrack != null ? sizeTrack!.width : 60.0,
            height: sizeTrack != null ? sizeTrack!.height : 30.0,
            child: Container(
              decoration: (enabled == false) ? defaultDecorationSliderDisabled : sliderDecor,
              alignment: Alignment.center,
              width:  sizeSlider != null ? sizeSlider!.width : 30.0,
              height: sizeSlider != null ? sizeSlider!.height : 30.0,
              child: Text((enabled == false) ? (textDisabled ?? '') : (text ?? ''),
                style: (enabled == false) ? textStyleDisabled : textStyleEnabled,
              ),
            ),
          ),
        );
      }
    );
  }
}
