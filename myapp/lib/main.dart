import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myapp/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 187, 174, 27)),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}//Color.fromARGB(255, 27, 187, 112)),
