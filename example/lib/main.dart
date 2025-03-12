import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:triple_switch/triple_switch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize switches
  SwitchState().data = {
    'switch1':  SwitchModel(
      position: await readData('sw1'),        /// Read from Storage
      saveFunc: (val) => saveData('sw1', val),/// Save to Storage
    ),
    'switch2': SwitchModel(
      position: await readData('sw2'),        /// Read from Storage
      saveFunc: (val) => saveData('sw2', val),/// Save to Storage
    ),
    'switch3': SwitchModel(
      position: await readData('sw3'),        /// Read from Storage
      saveFunc: (val) => saveData('sw3', val),/// Save to Storage
    ),
    'switch4': SwitchModel(),                 /// Init switch without state
  };

  runApp(const MyApp());
}

/// Read data from persistent storage like SharedPreferences
Future<bool> readData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

/// Save data to persistent storage like SharedPreferences
void saveData(String key, bool data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, data);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SwitchState switches = SwitchState();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SettingsPage())),
          )
        ],
      ),
      body: Center(
        child: ListenableBuilder(
            listenable: switches,
            builder: (BuildContext ctx, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Function1 is running now: ${(switches.data['switch1']!.timeout != null) ? switches.data['switch1']!.timeout.toString() : '--'}', style: const TextStyle(fontSize: 20)),
                  Text('Function2 is running now: ${(switches.data['switch2']!.timeout != null) ? switches.data['switch2']!.timeout.toString() : '--'}', style: const TextStyle(fontSize: 20)),
                  Text('Function3 is running now: ${(switches.data['switch3']!.timeout != null) ? switches.data['switch3']!.timeout.toString() : '--'}', style: const TextStyle(fontSize: 20)),
                ],
              );
            }
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool sw = false;

  @override
  Widget build(BuildContext context) {
    final SwitchState switches = SwitchState();

    return Scaffold(
      appBar: AppBar(title: const Text('Switches')),
      body: Center(
        child: ListenableBuilder(
            listenable: switches,
            builder: (BuildContext ctx, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text((switches.data['switch1']!.result != null)
                      ? '${switches.data['switch1']!.result.toString()} ( ${switches.data['switch1']!.success.toString()} )'
                      : 'No result'
                  ),
                  const TripleSwitch(
                    id: 'switch1',
                    timeoutOffOn: 50,
                    timeoutOnOff: 15,
                    functionOffOn: heavyFunction1,
                    functionOnOff: heavyFunction3,
                    argumentsOffOn: [923000000],
                    argumentsOnOff: [12, 12],
                    on: Text('ON'),
                    off: Text('OFF'),
                  ),
                  const SizedBox(height: 30),
                  Text((switches.data['switch2']!.result != null)
                      ? '${switches.data['switch2']!.result.toString()} ( ${switches.data['switch2']!.success.toString()} )'
                      : 'No result'
                  ),
                  const TripleSwitch(
                      id: 'switch2',
                      timeoutOffOn: 50,
                      timeoutOnOff: null,
                      functionOffOn: heavyFunction2,
                      functionOnOff: null,
                      argumentsOffOn: [223000000, 'Second Func'],
                      argumentsOnOff: null,
                      on: Icon(Icons.play_arrow),
                      off: Icon(Icons.stop),
                  ),
                  const SizedBox(height: 30),
                  Text((switches.data['switch3']!.result != null)
                      ? '${switches.data['switch3']!.result.toString()} ( ${switches.data['switch3']!.success.toString()} )'
                      : 'No result'
                  ),
                  const TripleSwitch(
                    id: 'switch3',
                    timeoutOffOn: 15,
                    functionOffOn: heavyFunction3,
                    argumentsOffOn: [16, 2],
                    on: Text('STARTED'),
                    off: Text('STOPPED'),
                    sizeSlider: Size(70, 48),
                  ),
                  const SizedBox(height: 40),
                  TripleSwitch(
                    value: sw,
                    onChanged: (value) => setState(() => sw = value),
                    sizeTrack: Size(80, 20),
                    sizeSlider: Size(10, 40),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}

/// Example of Heavy Functions
Future<List<dynamic>> heavyFunction1(List<dynamic> args) async {
  double total = 0.0;
  int delta = Random().nextInt(200000000) - 100000000;
  bool res = Random().nextBool();

  for (int i = 0; i < (args[0] + delta); i++) {total += i;}

  return [total, res];
}

Future<List<dynamic>> heavyFunction2(List<dynamic> args) async {
  double total = 0.0;
  bool res = Random().nextBool();

  for (var i = 0; i < args[0]; i++) {total += Random().nextInt(200);}

  return ['${args[1]} = ${total.toString()}', res];
}

Future<List<dynamic>> heavyFunction3(List<dynamic> args) async {
  await Future<void>.delayed(const Duration(seconds: 7));
  bool res = Random().nextBool();

  return [args[0] * args[1], res];
}