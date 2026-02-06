import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}

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
=======
>>>>>>> new_branch
