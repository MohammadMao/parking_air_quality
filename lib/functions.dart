import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // for Gauges/Meters

class SFG extends StatelessWidget {
  final double gas;
  final double max;

  const SFG({super.key, required this.gas, required this.max});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(minimum: 0, maximum: max, ranges: <GaugeRange>[
        GaugeRange(startValue: 0, endValue: max / 3, color: Colors.green),
        GaugeRange(
            startValue: max / 3, endValue: max * 2 / 3, color: Colors.orange),
        GaugeRange(startValue: max * 2 / 3, endValue: max, color: Colors.red)
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
