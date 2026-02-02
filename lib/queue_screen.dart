import 'package:flutter/material.dart';
class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin : EdgeInsets.only(top: 70.0, left : 20),
        child: Column(children:[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
          children: [
          Icon(Icons.menu_open, size : 30.0),
          const Text(
                    'Turnly',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
          ),
          Icon(Icons.person_4_rounded, size : 30.0),
        ]),
      ]),
      ),
    );
  }
}

