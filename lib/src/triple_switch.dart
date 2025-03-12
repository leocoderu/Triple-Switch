import 'package:flutter/material.dart';

/// Import Modules
import 'switch_state.dart';
import 'decoration_switch.dart';

//enum SwitchPosition {on, wait, off}           /// rudimentary

class TripleSwitch extends StatelessWidget {

  final String? id;                             /// Unique ID of switch
  final bool? enabled;                          /// Enabled or Disabled switch
  final bool? value;                            /// Default value of switch, true - On / false - Off
  final bool? mirroring;                        /// Mirroring by horizontal functionality
  final int? timeoutOffOn;                      /// Timeout for wait switching Off -> On
  final int? timeoutOnOff;                      /// Timeout for wait switching On -> Off
  final Function? functionOffOn;                /// Calling a heavy function during switching Off -> On
  final Function? functionOnOff;                /// Calling a heavy function during switching On -> Off
  final List<dynamic>? argumentsOffOn;          /// Arguments of the called heavy function, Off -> On
  final List<dynamic>? argumentsOnOff;          /// Arguments of the called heavy function, On -> Off
  final ValueChanged<bool>? onChanged;          /// Event returns new position of switch, it may be old or new position

  final int? animateDuration;

  final Size? sizeTrack;
  final Size? sizeSlider;

  final BoxDecoration? decorationTrackOn;
  final BoxDecoration? decorationTrackOff;
  final BoxDecoration? decorationTrackWait;
  final BoxDecoration? decorationTrackDisabled;

  final BoxDecoration? decorationSliderOn;
  final BoxDecoration? decorationSliderOff;
  final BoxDecoration? decorationSliderWait;
  final BoxDecoration? decorationSliderDisabled;

  final Widget? on;
  final Widget? off;
  final Widget? wait;
  final Widget? disabled;
  final TextStyle? timerStyle;

  const TripleSwitch({
    super.key,
    this.id,
    this.value,
    this.enabled,
    this.mirroring,
    this.timeoutOffOn,
    this.timeoutOnOff,
    this.argumentsOffOn,
    this.functionOffOn,
    this.functionOnOff,
    this.argumentsOnOff,
    this.onChanged,
    this.animateDuration,
    this.sizeTrack,
    this.sizeSlider,
    this.decorationTrackOn,
    this.decorationTrackOff,
    this.decorationTrackWait,
    this.decorationTrackDisabled,
    this.decorationSliderOn,
    this.decorationSliderOff,
    this.decorationSliderWait,
    this.decorationSliderDisabled,
    this.on,
    this.off,
    this.wait,
    this.disabled,
    this.timerStyle,
  });

  @override
  Widget build(BuildContext context) {
    final SwitchState switches = SwitchState();
    return ListenableBuilder(
      listenable: switches,
      builder: (BuildContext ctx, child) {
        return GestureDetector(
          onTap: () {
            /// If id is null, switch will work like usual switch
            /// and return inverse of entrance value
            if (id == null) {
              if (onChanged != null) {return onChanged!(!(value ?? false));}
              return;
            }

            /// preventing a restart
            if(switches.data[id]!.timeout == null) {
              switches.start(id!,
                  switches.data[id]!.position ? timeoutOnOff : timeoutOffOn,
                  switches.data[id]!.position ? functionOnOff : functionOffOn,
                  switches.data[id]!.position ? argumentsOnOff : argumentsOffOn
              );
            }
            ///: null; //switches.stop(id);
            /// There is no point in stopping the request, as it must be processed!
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: animateDuration ?? 200),
            decoration: (enabled == false)
                ? defaultDecorationTrackDisabled
                : (switches.data[id]!.timeout != null)
                  ? decorationTrackWait ?? defaultDecorationTrackWait
                  : (switches.data[id]!.position ^ (mirroring ?? false))
                    ? decorationTrackOn ?? defaultDecorationTrackOn
                    : decorationTrackOff ?? defaultDecorationTrackOff,
            alignment: (enabled == false)
                ? Alignment.center
                : (switches.data[id]!.timeout != null)
                  ? Alignment.center
                  : (switches.data[id]!.position ^ (mirroring ?? false))
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            width: sizeTrack != null ? sizeTrack!.width : 200.0,
            height: sizeTrack != null ? sizeTrack!.height : 100.0,
            child: Container(
              decoration: (enabled == false)
                  ? defaultDecorationSliderDisabled
                  : (switches.data[id]!.timeout != null)
                    ? decorationSliderWait ?? defaultDecorationSliderWait
                    : (switches.data[id]!.position ^ (mirroring ?? false))
                      ? decorationSliderOn ?? defaultDecorationSliderOn
                      : decorationSliderOff ?? defaultDecorationSliderOff,
              alignment: Alignment.center,
              width:  sizeSlider != null ? sizeSlider!.width : 100.0,
              height: sizeSlider != null ? sizeSlider!.height : 100.0,
              child: (enabled == false)
                  ? disabled
                  : (switches.data[id]!.timeout != null)
                    ? wait ?? Text(switches.data[id]!.timeout.toString(), style: timerStyle)
                    : (switches.data[id]!.position ^ (mirroring ?? false))
                      ? on : off,
            ),
          ),
        );
      }
    );
  }
}
