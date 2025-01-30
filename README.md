Three-position switcher with Wait state and timeout for operation complete.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

Install package in pubspec.yaml file:
```yaml
dependencies:
  triple_switch:
    git: https://github.com/leocoderu/triple_switch
```

Add package to dart module: 
```dart
import 'package:triple_switch/triple_switch.dart';
```

## Usage

```dart
/// Widget state
SwitchPosition swPosState = SwitchPosition.off;

/// In builder
TripleSwitch(
  position: swPosState, /// Set position of switcher
  timeoutOffOn: 20,     /// Timeout from Off to On
  timeoutOnOff: 0,      /// Timeout from On to Off
  onChanged: (value) => setState(() => swPosState = value), /// Get states value of switcher
),
```

if timeout isn't set this switcher will be work like usually 2-position switcher.
if widget doesn't use onChange(), it will displayed like disable switcher. 
This switcher widget will gets different Design, assigned user. 

## Additional information


### This widget is under construction yet and work not correctly!!!

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
