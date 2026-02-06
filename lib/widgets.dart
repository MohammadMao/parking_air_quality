import 'package:flutter/material.dart';

PreferredSizeWidget appbar() {
  return AppBar(
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
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ));
}
