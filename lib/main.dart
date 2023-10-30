import 'dart:async';

import 'package:flutter/material.dart';
import 'package:MobileAppNew/app/mobile_no_screen.dart';

import 'app/mobile_no_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return MobileScreen(); // Replace NextPage with the actual page you want to navigate to
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          height: 200,
          width: 500,
          child: Center(
              child: Image.asset('assets/KJ-store-image.jpg',height: 200,width: 500,)),
        ),
    ),
      ),
    );
  }
}
