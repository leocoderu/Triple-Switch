<p align="center"><img src="/screenshots/logo.png" height="100" alt="Triple Switch" /></p>

## Triple Switch

Three-position switch has three states ON - WAIT - OFF.
WAIT state is a state awaiting finish heavy operation like getting information from net.
ON / OFF is a usual state of switch 

## Usage

In main setup, the initial state of switches and stateful functions
```dart
SwitchState().data = {
    'stringIdentifier1':  SwitchModel(
        position: await readData('switch1'),          /// Read state from same Storage
        saveFunc: (val) => saveData('switch1', val),  /// Save state to some Storage
    ),
    'stringIdentifier2': SwitchModel(
        position: await readData('switch2'),          /// Read state from same Storage
        saveFunc: (val) => saveData('switch2', val)   /// Save state to some Storage
    ),
    'stringIdentifier3': SwitchModel(
        position: await readData('switch3'),          /// Read state from same Storage
        saveFunc: (val) => saveData('switch3', val)   /// Save state to some Storage
    ),
    'stringIdentifier4': SwitchModel(),               /// Can use without usage statement
};
```

Use the widget
```dart
TripleSwitch(
  id: 'stringIdentifier1',                      /// String Unique Identifier of switch  
  enabled: true,                                /// Enabled or Disabled switch
  timeoutOffOn: 50,                             /// Timeout for waiting for the called function from OFF to ON
  timeoutOnOff: 15,                             /// Timeout for waiting for the called function from ON to OFF
  functionOffOn: heavyFunction1,                /// Function witch called when tap on widget for switching state from OFF to ON
  functionOnOff: heavyFunction3,                /// Function witch called when tap on widget for switching state from ON to OFF
  argumentsOffOn: [923000000],                  /// List of arguments for called function from OFF to ON 
  argumentsOnOff: [12, 12],                     /// List of arguments for called function from ON to OFF
  
  animateDuration: 200,                         /// Speed of animation switch

  sizeTrack: Size(100, 50),                     /// Size of track
  sizeSlider: Size(50, 50),                     /// Size of slider

  decorationTrackOn: BoxDecoration(...),        /// Custom decoration of track in ON position
  decorationTrackOff: BoxDecoration(...),       /// Custom decoration of track in OFF position
  decorationTrackWait: BoxDecoration(...),      /// Custom decoration of track in WAIT position
  decorationTrackDisabled: BoxDecoration(...),  /// Custom decoration of track when switch is Disabled

  decorationSliderOn: BoxDecoration(...),       /// Custom decoration of slider in ON position
  decorationSliderOff: BoxDecoration(...),      /// Custom decoration of slider in OFF position
  decorationSliderWait: BoxDecoration(...),     /// Custom decoration of slider in WAIT position
  decorationSliderDisabled: BoxDecoration(...), /// Custom decoration of slider when switch is Disabled

  on: Text('ON'),                               /// Widget on slider in ON Position
  off: Text('OFF'),                             /// Widget on slider in OFF Position
  wait: Text('WAIT'),                           /// Widget on slider in WAIT Position
  disabled: Text('DIS'),                        /// Widget on slider when switch is Disabled
  
  timerStyle: TextStyle(...),                   /// Style of text for timeout
)
```

A heavy function should be of the following format, 
it gets a list of arguments of different types and returns a list in which the first element is the result of an operation of a different type, 
and the second element is the result of the success of the operation - has a logical type.
```dart 
Future<List<dynamic>> heavyFunction1(List<dynamic> args) async {
  ///... Some heavy and long operations
  
  return [total, res];
}
```

## Additional information

    - if timeout isn't set this switcher will be work like usually 2-position switcher.
    - When widget "wait" don't initialize, the countdown timer is showing
    - This switcher widget will gets different Design, assigned user. 

## Gallery

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_1.png" width="200"/> 
            </td>            
            <td style="text-align: center">
               <img src="/screenshots/puzzle_2.png" width="200"/> 
            </td>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_3.png" width="200" />
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_4.png" width="200"/>
            </td>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_5.png" width="200"/>
            </td>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_6.gif" width="200"/>
            </td>
        </tr>
    </table>
</div>
