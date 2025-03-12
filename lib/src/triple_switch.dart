import 'package:flutter/material.dart';

import 'switch_state.dart';
import 'decoration_switch.dart';

class TripleSwitch extends StatelessWidget {

  /// Unique ID of switch
  final String? id;

  /// Enabled or Disabled switch
  final bool? enabled;

  /// Default value of switch, true - On / false - Off
  final bool? value;

  /// Mirroring by horizontal functionality
  final bool? mirroring;

  /// Timeout for wait switching Off -> On
  final int? timeoutOffOn;

  /// Timeout for wait switching On -> Off
  final int? timeoutOnOff;

  /// Calling a heavy function during switching Off -> On
  final Function? functionOffOn;

  /// Calling a heavy function during switching On -> Off
  final Function? functionOnOff;

  /// Arguments of the called heavy function, Off -> On
  final List<dynamic>? argumentsOffOn;

  /// Arguments of the called heavy function, On -> Off
  final List<dynamic>? argumentsOnOff;

  /// Event returns new position of switch, it may be old or new position
  final ValueChanged<bool>? onChanged;

  /// Set duration of animation
  final int? animateDuration;

  /// Size of track of switch width and height
  final Size? sizeTrack;

  /// Size of slider of switch width and height
  final Size? sizeSlider;

  /// Decoration track in ON position
  final BoxDecoration? decorationTrackOn;

  /// Decoration track in OFF position
  final BoxDecoration? decorationTrackOff;

  /// Decoration track in WAIT position
  final BoxDecoration? decorationTrackWait;

  /// Decoration track if switch is disabled
  final BoxDecoration? decorationTrackDisabled;

  /// Decoration slider in ON position
  final BoxDecoration? decorationSliderOn;

  /// Decoration slider in OFF position
  final BoxDecoration? decorationSliderOff;

  /// Decoration slider in WAIT position
  final BoxDecoration? decorationSliderWait;

  /// Decoration slider if switch is disabled
  final BoxDecoration? decorationSliderDisabled;

  /// The widget inside the slider is in the "ON" position
  final Widget? on;

  /// The widget inside the slider is in the "OFF" position
  final Widget? off;

  /// The widget inside the slider is in the "WAIT" position
  final Widget? wait;

  /// The widget inside the slider if switch is disabled
  final Widget? disabled;

  /// Style of text for timer on the slider
  final TextStyle? timerStyle;

  /// Constructor
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

            /// If switch is disabled, we're not doing anything
            if (enabled == false) return;

            /// If id is null, switch will work like usual switch
            /// and return inverse of entrance value
            if (id == null) {
              if (onChanged != null) {return onChanged!(!(value ?? false));}
              return;
            }

            /// Preventing a restart
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
          child: Container(
            child: Stack(
              clipBehavior: Clip.none,

              /// if id is null, switch works like usual switch only two position ON/OFF
              children: (id == null)
                ? [
                    /// Displaying track animations
                    AnimatedContainer(
                      duration: Duration(milliseconds: animateDuration ?? 200),
                      decoration: (enabled == false)
                          ? decorationTrackDisabled ?? defaultDecorationTrackDisabled
                          : (value ?? false)
                            ? decorationTrackOn ?? defaultDecorationTrackOn
                            : decorationTrackOff ?? defaultDecorationTrackOff,
                      width: sizeTrack != null ? sizeTrack!.width : 100.0,
                      height: sizeTrack != null ? sizeTrack!.height : 50.0,
                    ),

                    /// Displaying slider animations and his position
                    AnimatedPositioned(
                      top: ((sizeTrack != null ? sizeTrack!.height : 50.0) - (sizeSlider != null ? sizeSlider!.height : 48.0)) / 2,
                      left: (enabled == false)
                        ? ((sizeTrack != null ? sizeTrack!.width : 100.0) - (sizeSlider != null ? sizeSlider!.width : 48.0)) / 2
                        : ((value ?? false) ^ (mirroring ?? false))
                          ? (sizeTrack != null ? sizeTrack!.width : 100.0) - (sizeSlider != null ? sizeSlider!.width : 48.0)
                          : 0,
                      duration: Duration(milliseconds: animateDuration ?? 200),
                      child: Container(
                        decoration: (enabled == false)
                            ? decorationSliderDisabled ?? defaultDecorationSliderDisabled
                            : (value ?? false)
                              ? decorationSliderOn ?? defaultDecorationSliderOn
                              : decorationSliderOff ?? defaultDecorationSliderOff,
                        alignment: Alignment.center,
                        width:  sizeSlider != null ? sizeSlider!.width : 48.0,
                        height: sizeSlider != null ? sizeSlider!.height : 48.0,
                        child: (enabled == false)
                            ? disabled
                            : (value ?? false)
                            ? on : off,
                      ),
                    ),
                  ]

                /// If id present, switch has full functionality with three positions ON/WAIT/OFF
                : [
                    /// Displaying track animations
                    AnimatedContainer(
                      duration: Duration(milliseconds: animateDuration ?? 200),
                      decoration: (enabled == false)
                          ? decorationTrackDisabled ?? defaultDecorationTrackDisabled
                          : (switches.data[id]!.timeout != null)
                            ? decorationTrackWait ?? defaultDecorationTrackWait
                            : (switches.data[id]!.position ^ (mirroring ?? false))
                              ? decorationTrackOn ?? defaultDecorationTrackOn
                              : decorationTrackOff ?? defaultDecorationTrackOff,
                      width: sizeTrack != null ? sizeTrack!.width : 100.0,
                      height: sizeTrack != null ? sizeTrack!.height : 50.0,
                    ),

                    /// Displaying slider animations and his position
                    AnimatedPositioned(
                      top: ((sizeTrack != null ? sizeTrack!.height : 50.0) - (sizeSlider != null ? sizeSlider!.height : 48.0)) / 2,
                      left: (enabled == false)
                          ? ((sizeTrack != null ? sizeTrack!.width : 100.0) - (sizeSlider != null ? sizeSlider!.width : 48.0)) / 2
                          : (switches.data[id]!.timeout != null)
                            ? ((sizeTrack != null ? sizeTrack!.width : 100.0) - (sizeSlider != null ? sizeSlider!.width : 48.0)) / 2
                            : (switches.data[id]!.position ^ (mirroring ?? false))
                              ? (sizeTrack != null ? sizeTrack!.width : 100.0) - (sizeSlider != null ? sizeSlider!.width : 48.0)
                              : 0,
                      duration: Duration(milliseconds: animateDuration ?? 200),
                      child: Container(
                        decoration: (enabled == false)
                            ? decorationSliderDisabled ?? defaultDecorationSliderDisabled
                            : (switches.data[id]!.timeout != null)
                              ? decorationSliderWait ?? defaultDecorationSliderWait
                              : (switches.data[id]!.position ^ (mirroring ?? false))
                                ? decorationSliderOn ?? defaultDecorationSliderOn
                                : decorationSliderOff ?? defaultDecorationSliderOff,
                        alignment: Alignment.center,
                        width:  sizeSlider != null ? sizeSlider!.width : 48.0,
                        height: sizeSlider != null ? sizeSlider!.height : 48.0,
                        child: (enabled == false)
                            ? disabled
                            : (switches.data[id]!.timeout != null)
                              ? wait ?? Text(switches.data[id]!.timeout.toString(), style: timerStyle)
                              : (switches.data[id]!.position ^ (mirroring ?? false))
                                ? on : off,
                      ),
                    ),
                ]
            )
          )
        );
      }
    );
  }
}
