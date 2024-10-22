import 'package:flutter/material.dart';
import 'package:todo_app/My%20folders/start_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartPage(),
    );
  }
}
