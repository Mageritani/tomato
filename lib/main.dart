import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/Theme/Theme_light.dart';
import 'package:tomato/Timer_service.dart';
import 'package:tomato/task.dart';

import 'clock.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TimerService(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: task(),
    );
  }
}

