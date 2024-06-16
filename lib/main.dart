import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Icons
import 'functions.dart';
import 'mqtt/mqtt_manager.dart';
import 'mqtt/mqtt_state.dart';
import 'package:provider/provider.dart';
import 'widgets.dart';
import 'mqtt/setters.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChangeNotifierProvider<MQTTAppState>(
      create: (_) => MQTTAppState(),
      child: const MyHomePage(title: 'Parking Air Quality'),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MQTTAppState currentAppState;
  late MqttManager manager;

  @override
  void initState() {
    initConn();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initConn() {
    final MQTTAppState appState =
        Provider.of<MQTTAppState>(context, listen: false);
    // Keep a reference to the app state.
    currentAppState = appState;
    currentAppState.getAppConnectionState == MQTTAppConnectionState.disconnected
        ? _configureAndConnect()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    bool autoOn = true;
    bool doorOpened = doorval; // depending on server info
    bool fanOn = fanval; // depending on server info
    double co = coval; // depending on server info
    double smoke = smokeval; // depending on server info

    return Scaffold(
      appBar: appbar(),
      body: ListView(padding: const EdgeInsets.only(top: 10), children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              color: const Color.fromARGB(255, 238, 255, 251),
              child: Column(
                children: [
                  const Text(
                    'DOOR CONTROL',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text('$co and $smoke, $fanOn, $doorOpened'),
                  const SizedBox(height: 15), //مساحة بين العناصر
                  SwitchT(
                      // Door Switch
                      valueChanged: (val) {
                        setState(() {
                          doorOpened = val;
                          (doorOpened)
                              ? manager.publish('open', 'door/status')
                              : manager.publish('close', 'door/status');
                        });
                      },
                      boolval: doorOpened,
                      txt: (doorOpened) ? 'Opened' : 'Closed',
                      ico: Icon(
                        FontAwesomeIcons.doorOpen,
                        size: 40,
                        color:
                            (doorOpened) ? Colors.green[400] : Colors.grey[500],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 30), //مساحة بين العناصر
            const Text(
              'FAN CONTROL',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchT(
              // AutoMode Switch
              boolval: autoOn,
              txt: 'Automatic Mode',
              ico: Icon(
                FontAwesomeIcons.robot,
                size: 40,
                color: Colors.grey[500],
              ),
              valueChanged: (val) {
                setState(() {
                  autoOn = val;
                });
              },
              sub: const Text(
                  'Enabling this option allows sensors to control the fan automatically'),
            ),
            SwitchT(
              // Fan Switch
              boolval: fanOn,
              txt: (fanOn) ? 'Opened' : 'Closed',
              ico: Icon(
                FontAwesomeIcons.fan,
                size: 40,
                color: (fanOn) ? Colors.green[400] : Colors.grey[500],
              ),
              valueChanged: autoOn
                  ? null
                  : (val) {
                      setState(() {
                        fanOn = val;
                        (fanOn)
                            ? manager.publish('working', 'fan/status')
                            : manager.publish('not working', 'fan/status');
                      });
                    },
            ),
            const SizedBox(height: 20), //مساحة بين العناصر
            Container(
              color: const Color.fromARGB(255, 238, 255, 251),
              child: Column(
                children: [
                  const SizedBox(height: 25), //مساحة بين العناصر
                  const Text(
                    'CO',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SFG(
                    gas: co,
                    max: 66,
                  ), //استدعاء عداد للغاز
                ],
              ),
            ),

            Container(
              color: const Color.fromARGB(255, 231, 255, 250),
              child: Column(
                children: [
                  const SizedBox(height: 25), //مساحة بين العناصر
                  const Text(
                    'SMOKE',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SFG(
                    gas: smoke,
                    max: 33,
                  ), //استدعاء عداد للغاز
                ],
              ),
            )
          ],
        )
      ]),
    );
  }

  void _configureAndConnect() {
    manager = MqttManager(state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  // void _disconnect() {
  //   manager.disconnect();
  // }
}
