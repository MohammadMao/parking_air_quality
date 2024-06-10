import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // for Gauges/Meters

class SFG extends StatelessWidget {
  final double gas;

  const SFG({super.key, required this.gas});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(minimum: 0, maximum: 1000, ranges: <GaugeRange>[
        GaugeRange(startValue: 0, endValue: 333, color: Colors.green),
        GaugeRange(startValue: 334, endValue: 666, color: Colors.orange),
        GaugeRange(startValue: 667, endValue: 1000, color: Colors.red)
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
        activeColor: Colors.green,
        activeTrackColor: Colors.green[100],
      ),
    );
  }
}

class ParkingSlot extends StatelessWidget {
  final int x;
  final int carCount;
  const ParkingSlot({super.key, required this.carCount, required this.x});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 180,
      height: 120,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(20)),
      child: (carCount >= x)
          ? Image.asset("assets/car.png")
          : const Center(
              child: Text(
              'Parking Slot Available',
              style: TextStyle(color: Colors.green),
            )),
    );
  }
}
