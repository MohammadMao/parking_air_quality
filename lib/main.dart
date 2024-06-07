import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Icons
import 'functions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Parking Air Quality'),
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
  bool autoOn = true;
  bool doorOpened = false; // will change depending on server info
  bool fanOn = false; // will change depending on server info
  double co2 = 100; // will change depending on server info
  double tvoc = 525; // will change depending on server info

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.car_repair,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 5),
              Text(
                'Parking Air Quality',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
      body: ListView(padding: const EdgeInsets.only(top: 20), children: [
        Column(
          children: [
            const Text(
              'Door Control',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15), //مساحة بين العناصر
            SwitchT(
                // Door Switch
                valueChanged: (val) {
                  setState(() {
                    doorOpened = val;
                  });
                },
                boolval: doorOpened,
                txt: 'Open / Closed',
                ico: Icon(
                  FontAwesomeIcons.doorOpen,
                  size: 40,
                  color: Colors.grey[500],
                )),
            const SizedBox(height: 30), //مساحة بين العناصر
            const Text(
              'Fan Control',
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
              txt: 'Open / Close',
              ico: Icon(
                FontAwesomeIcons.fan,
                size: 40,
                color: Colors.grey[500],
              ),
              valueChanged: autoOn
                  ? null
                  : (val) {
                      setState(() {
                        fanOn = val;
                      });
                    },
            ),
            const SizedBox(height: 25), //مساحة بين العناصر
            const Text(
              'CO2',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SFG(gas: co2), //استدعاء عداد للغاز
            const SizedBox(height: 25), //مساحة بين العناصر
            const Text(
              'TVOC',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SFG(gas: tvoc), //استدعاء عداد للغاز
          ],
        )
      ]),
    );
  }
}
