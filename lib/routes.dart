import 'package:flutter/widgets.dart';
import 'package:grafcet/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'screen1': (_) => const Screen1Bloc(),
  'screen2': (_) => const Screen2Bloc(),
  'screen3': (_) => const Screen3(),
  'screen4': (_) => const Screen4(),
};
