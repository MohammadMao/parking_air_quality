import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // for Gauges/Meters
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Icons

// Gas Meters
class SFG extends StatelessWidget {
  final double gas;
  final double max;
  final String name;

  const SFG(
      {super.key, required this.gas, required this.max, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 231, 255, 250),
      child: Column(
        children: [
          const SizedBox(height: 25), //مساحة بين العناصر
          Text(
            name,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SfRadialGauge(axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: max, ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: max / 3,
                gradient: const SweepGradient(colors: <Color>[
                  Color.fromARGB(255, 62, 153, 74),
                  Color.fromARGB(255, 106, 201, 52),
                  Color.fromARGB(255, 190, 223, 45)
                ]),
              ),
              GaugeRange(
                  startValue: max / 3,
                  endValue: max * 2 / 3,
                  gradient: const SweepGradient(colors: <Color>[
                    Color.fromARGB(255, 190, 223, 45),
                    Color.fromARGB(255, 218, 206, 43),
                    Color.fromARGB(255, 240, 170, 40),
                    Color.fromARGB(255, 255, 133, 18)
                  ])),
              GaugeRange(
                  startValue: max * 2 / 3,
                  endValue: max,
                  gradient: const SweepGradient(colors: <Color>[
                    Color.fromARGB(255, 255, 133, 18),
                    Color.fromARGB(255, 247, 108, 27),
                    Color.fromARGB(255, 253, 64, 16),
                  ]))
            ], pointers: <GaugePointer>[
              NeedlePointer(value: gas)
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text('$gas',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  angle: 90,
                  positionFactor: 0.5)
            ])
          ])
        ],
      ),
    );
  }
}

// Switches
class SwitchT extends StatelessWidget {
  final bool boolval;
  final ValueChanged<bool>? valueChanged;
  final String txt;
  final Widget ico;
  final Widget? sub;
  const SwitchT(
      {super.key,
      this.sub,
      this.valueChanged,
      required this.txt,
      required this.ico,
      required this.boolval});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SwitchListTile(
        subtitle: sub,
        title: Text(
          txt,
          style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        value: boolval,
        onChanged: valueChanged,
        secondary: ico,
        activeColor: Colors.green[600],
        inactiveThumbColor: Colors.green[300],
      ),
    );
  }
}

// Door Status Card
class StatusCard extends StatelessWidget {
  final bool doorStatus;
  const StatusCard({super.key, required this.doorStatus});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (doorStatus)
          ? SizedBox(
              height: 100,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      FontAwesomeIcons.doorOpen,
                      size: 60,
                      color: Colors.green[400],
                    ),
                    Text(
                      'OPENED',
                      style: TextStyle(
                          color: Colors.green[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(
              height: 100,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      FontAwesomeIcons.doorClosed,
                      size: 60,
                      color: Color.fromARGB(255, 255, 76, 76),
                    ),
                    Text(
                      'CLOSED',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 76, 76),
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
