import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Icons
import 'functions.dart';

class DoorControl extends StatefulWidget {
  const DoorControl({super.key});

  @override
  State<DoorControl> createState() => _DoorControlState();
}

class _DoorControlState extends State<DoorControl> {
  bool doorOpenedOut = false;
  bool doorOpenedIn = false;
  int carCount = 4; // will change depending on server info

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(padding: const EdgeInsets.only(top: 20), children: [
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
            const Text(
              'Get Car IN',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchT(
                txt: doorOpenedIn ? 'Opened' : 'Closed',
                ico: Icon(
                  FontAwesomeIcons.doorOpen,
                  size: 40,
                  color: Colors.grey[500],
                ),
                boolval: doorOpenedIn,
                valueChanged: (carCount < 4)
                    ? (val) {
                        setState(() {
                          doorOpenedIn = val;
                        });
                      }
                    : null),
            const SizedBox(height: 15), //مساحة بين العناصر
            const Text(
              'Get Car OUT',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchT(
                // Door Switch (out)
                valueChanged: (carCount < 1)
                    ? (val) {
                        setState(() {
                          doorOpenedOut = false;
                        });
                      }
                    : (val) {
                        setState(() {
                          doorOpenedOut = val;
                        });
                      },
                boolval: doorOpenedOut,
                txt: doorOpenedOut ? 'Opened' : 'Closed',
                ico: Icon(
                  FontAwesomeIcons.doorOpen,
                  size: 40,
                  color: Colors.grey[500],
                )), //استدعاء عداد للغاز
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ParkingSlot(carCount: carCount, x: 1),
                ParkingSlot(carCount: carCount, x: 2)
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ParkingSlot(carCount: carCount, x: 3),
                ParkingSlot(carCount: carCount, x: 4)
              ],
            ),
          ],
        )
      ]),
    );
  }
}
