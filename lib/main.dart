import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // for Icons
import 'package:parking_air_quality/door_control.dart';
import 'package:parking_air_quality/fan_control.dart';
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  bool fanAutoOn = true;
  bool doorAutoOn = true;
  bool doorOpened = false; // will change depending on server info
  bool fanOn = false; // will change depending on server info
  double co2 = 100; // will change depending on server info
  double tvoc = 525; // will change depending on server info

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            bottom: TabBar(
                indicatorColor: Colors.amber,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[350],
                controller: tabController,
                tabs: const [
                  Tab(
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.doorClosed,
                        ),
                        SizedBox(width: 7),
                        Text('Door Control')
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.fan,
                        ),
                        SizedBox(width: 7),
                        Text('Fan Control')
                      ],
                    ),
                  ),
                ]),
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
        body: TabBarView(
          controller: tabController,
          children: const [DoorControl(), FanControl()],
        ));
  }
}
