import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Icons
import 'classes.dart';
import 'mqtt/mqtt_manager.dart';
import 'mqtt/mqtt_state.dart';
import 'package:provider/provider.dart';
import 'widgets.dart';
import 'models.dart';
import 'config.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D7377)),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<MQTTAppState>(
            create: (_) => MQTTAppState(),
          ),
          ChangeNotifierProvider<Inputs>(
            create: (_) => Inputs(),
          ),
        ],
        child: const MyHomePage(title: 'Parking Air Quality'),
      ),
    );
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
    // Load environment config before initializing connection
    EnvConfig.load().then((_) {
      initConn();
    });
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
    final Inputs provider = Provider.of<Inputs>(context);

    // takes values from provider
    bool autoOn = provider.fanMode;
    bool doorOpened = provider.doorval;
    bool fanOn = provider.fanval;
    double co = provider.coval;
    double smoke = provider.smokeval;
    bool airQuality = (co > 35 || smoke > 12);

    return Scaffold(
        appBar: appbar(),
        body: ListView(padding: const EdgeInsets.only(top: 10), children: [
          Column(
            children: [
              Container(
                // Door Status
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                color: const Color.fromARGB(255, 248, 255, 253),
                child: Column(
                  children: [
                    const Text(
                      'DOOR STATUS',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
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
                          color: (doorOpened)
                              ? Colors.green[400]
                              : Colors.grey[500],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 30),
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
                    (autoOn)
                        ? manager.publish('1', 'control/fan')
                        : manager.publish('0', 'control/fan');
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
                              ? manager.publish('1', 'control/fan/manual')
                              : manager.publish('0', 'control/fan/manual');
                        });
                      },
              ),
              const SizedBox(height: 20),

              // AirQuality Status Card
              AirStatusCard(airQuality: airQuality),
              const SizedBox(height: 20),

              // Gas Meters
              SFG(gas: co, max: 66, name: 'CO'),
              SFG(gas: smoke, max: 33, name: 'SMOKE'),
            ],
          )
        ]));
  }

  void _configureAndConnect() {
    manager = MqttManager(state: currentAppState);
    manager.initializeMQTTClient(context);
    manager.connect();
    manager.client!.onConnected = () => manager.onConnected(context);
  }
}
