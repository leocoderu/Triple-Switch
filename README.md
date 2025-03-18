<p align="center"><img src="/screenshots/logo.png" height="100" alt="Triple Switch" /></p>

## Triple Switch

This widget has three states ON - WAIT - OFF. 
ON / OFF is a regular state of switch, WAIT is a state awaiting finish heavy operation. 

## Usage

In main setup, the initial state of switches and stateful functions
```dart
SwitchState().data = {
    'stringIdentifier1':  SwitchModel(
        /// Read state from same Storage
        position: await readData('switch1'),

        /// Save state to some Storage
        saveFunc: (val) => saveData('switch1', val),  
    ),
    'stringIdentifier2': SwitchModel(
        /// Read state from same Storage
        position: await readData('switch2'),

        /// Save state to some Storage
        saveFunc: (val) => saveData('switch2', val)   
    ),
    'stringIdentifier3': SwitchModel(
        /// Read state from same Storage
        position: await readData('switch3'),

        /// Save state to some Storage
        saveFunc: (val) => saveData('switch3', val)   
    ),

    /// You can use without usage statement
    'stringIdentifier4': SwitchModel(),               
};
```

Use the widget
```dart
TripleSwitch(
  /// String Unique Identifier of switch
  /// If the switch is used as a three-way switch, a unique ID must be specified.
  /// If the switch is used as a regular two-position switch, 
  /// you do not need to specify the id, but to work, 
  /// you must specify the original value in value and get a new value in the onChange() event.
  id: 'stringIdentifier1',
  
  /// Enabled or Disabled switch
  enabled: true,                                

  /// Default value of two-position switch, true -> ON / false -> OFF
  value: swState,

  /// Mirroring by horizontal functionality for slider
  mirroring: false,
  
  /// Timeout for waiting for the called function from OFF to ON
  timeoutOffOn: 50,

  /// Timeout for waiting for the called function from ON to OFF
  timeoutOnOff: 15,

  /// Function witch called when tap on widget for switching state from OFF to ON
  functionOffOn: heavyFunction1,

  /// Function witch called when tap on widget for switching state from ON to OFF
  functionOnOff: heavyFunction3,

  /// List of arguments for called function from OFF to ON
  argumentsOffOn: [923000000],

  /// List of arguments for called function from ON to OFF
  argumentsOnOff: [12, 12],

  /// The event returns the new position of the switch, 
  /// which is the opposite of the one passed in the Value parameter.
  onChanged: (v) => setState(() => swState = v);

  /// Speed of animation switch
  animateDuration: 200,

  /// Size of track
  sizeTrack: Size(100, 50),

  /// Size of slider
  sizeSlider: Size(50, 50),

  /// Custom decoration of track in ON position
  decorationTrackOn: BoxDecoration(...),

  /// Custom decoration of track in OFF position
  decorationTrackOff: BoxDecoration(...),

  /// Custom decoration of track in WAIT position
  decorationTrackWait: BoxDecoration(...),

  /// Custom decoration of track when switch is Disabled
  decorationTrackDisabled: BoxDecoration(...),

  /// Custom decoration of slider in ON position
  decorationSliderOn: BoxDecoration(...),

  /// Custom decoration of slider in OFF position
  decorationSliderOff: BoxDecoration(...),

  /// Custom decoration of slider in WAIT position
  decorationSliderWait: BoxDecoration(...),

  /// Custom decoration of slider when switch is Disabled
  decorationSliderDisabled: BoxDecoration(...),

  /// Widget on slider in ON Position
  on: Text('ON'),

  /// Widget on slider in OFF Position
  off: Text('OFF'),

  /// Widget on slider in WAIT Position
  wait: Text('WAIT'),

  /// Widget on slider when switch is Disabled
  disabled: Text('DIS'),                        
  
  timerStyle: TextStyle(...),                   /// Style of text for timeout
)
```

A heavy function should be of the following format,
it can gets a list of arguments of different types and returns a list in which the first element is the result of an operation of a different type,
and the second element is the result of the success of the operation - has a logical type (true or false).
```dart 
Future<List<dynamic>> heavyFunction1(List<dynamic> args) async {
  ///... Some heavy and long operations
  
  return [total, res];
}
```

## Additional information

    - if timeout isn't set this switch will be work like usually 2-position switcher.
    - When widget "wait" don't initialize, the countdown timer is showing
    - This switcher widget will gets different Design, assigned user. 

## Gallery

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_1.png" width="200" alt="img1"/> 
            </td>            
            <td style="text-align: center">
               <img src="/screenshots/puzzle_2.png" width="200" alt="img2"/> 
            </td>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_3.png" width="200" alt="img3"/>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_4.png" width="200" alt="img4"/>
            </td>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_5.png" width="200" alt="img5"/>
            </td>
            <td style="text-align: center">
               <img src="/screenshots/puzzle_6.gif" width="200" alt="img6"/>
            </td>
        </tr>
    </table>
</div>

## Thoughts out loud

    The widget gets a function as a class property, and when you click on the widget, 
    it creates an Isolate and executes the resulting function in it.

    Each time the application is restarted, the state of the Singleton class (S-class) should be restored.
    The S-class state can be loaded from: 
        1. Permanent memory
        2. The resource API
        3. ~~State Management (SM)~~ - it makes no sense to store in SM because this S-class is itself an SM.

## Planned future changes

    1. Add the option to disable visualization of slider
    2. Figure out what you can replace the isolate with for the web version
    