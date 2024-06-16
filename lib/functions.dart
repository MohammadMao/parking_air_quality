import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // for Gauges/Meters
import 'package:flutter_switch/flutter_switch.dart'; // for costumized switches

class SFG extends StatelessWidget {
  final double gas;
  final double max;

  const SFG({super.key, required this.gas, required this.max});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
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
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            angle: 90,
            positionFactor: 0.5)
      ])
    ]);
  }
}

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

class FSwitch extends StatelessWidget {
  final bool boolval;
  final ValueChanged<bool>? valueChanged;
  final String txt;
  final Widget ico;
  final Widget? sub;
  const FSwitch(
      {super.key,
      this.sub,
      this.valueChanged,
      required this.txt,
      required this.ico,
      required this.boolval});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        leading: ico,
        title: Text(
          txt,
          style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        subtitle: sub,
        trailing: FlutterSwitch(
          value: boolval,
          onToggle: (value) {
            boolval;
          },
          height: 10,
          width: 20,
        ),
      ),
    );
  }
}
