import 'package:flutter/material.dart';
import 'package:grafcet/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutorial Grafcet',
      initialRoute: 'screen1',
      routes: appRoutes,
    );
  }
}
