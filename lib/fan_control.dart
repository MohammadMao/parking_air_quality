import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Icons
import 'functions.dart';

class FanControl extends StatefulWidget {
  const FanControl({super.key});

  @override
  State<FanControl> createState() => _FanControlState();
}

class _FanControlState extends State<FanControl> {
  bool fanAutoOn = true;
  bool fanOn = false; // will change depending on server info
  double co2 = 100; // will change depending on server info
  double tvoc = 525; // will change depending on server info

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.only(top: 20), children: [
      Column(
        children: [
          const Text(
            'Fan Control',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          SwitchT(
            // FanAutoMode Switch
            boolval: fanAutoOn,
            txt: 'Automatic Mode',
            ico: Icon(
              FontAwesomeIcons.robot,
              size: 40,
              color: Colors.grey[500],
            ),
            valueChanged: (val) {
              setState(() {
                fanAutoOn = val;
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
            valueChanged: fanAutoOn
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
    ]);
  }
}
