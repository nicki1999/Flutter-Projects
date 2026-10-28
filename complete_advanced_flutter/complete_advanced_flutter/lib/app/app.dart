import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  MyApp._internal(); //private named constructor

  static final MyApp instance = MyApp._internal(); //singleton instance
  int appState = 0; //state variable
  
  factory MyApp() => instance; //factory constructor

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}