import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Icons
import 'functions.dart';

class DoorControl extends StatefulWidget {
  const DoorControl({super.key});

  @override
  State<DoorControl> createState() => _DoorControlState();
}

class _DoorControlState extends State<DoorControl> {
  bool doorAutoOn = true;
  bool doorOpened = false; // will change depending on server info

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.only(top: 20), children: [
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
            // DoorAutoMode Switch
            boolval: doorAutoOn,
            txt: 'Automatic Mode',
            ico: Icon(
              FontAwesomeIcons.robot,
              size: 40,
              color: Colors.grey[500],
            ),
            valueChanged: (val) {
              setState(() {
                doorAutoOn = val;
              });
            },
            sub: const Text(
                'Enabling this option allows sensors to control the door automatically'),
          ),
          SwitchT(
              // Door Switch
              valueChanged: doorAutoOn
                  ? null
                  : (val) {
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
              )), //استدعاء عداد للغاز
        ],
      )
    ]);
  }
}
