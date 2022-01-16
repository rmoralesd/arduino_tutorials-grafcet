import 'package:flutter/widgets.dart';
import 'package:grafcet/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'screen1': (_) => const Screen1(),
  'screen2': (_) => const Screen2(),
};
