import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Main screen'),
    centerTitle: true,
    ),
    body: Center(
      child:
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/todo');
        },
            style: ElevatedButton.styleFrom(fixedSize: const Size(150, 70), backgroundColor: Colors.deepPurpleAccent),
            child: const Text('START', style: TextStyle(
              fontSize: 30,
            ),),
        ),
    )
    );
  }
}
