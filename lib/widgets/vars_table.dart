import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafcet/blocs/timer_bloc/timer_bloc.dart';
import 'package:grafcet/models/models.dart';

class VarsTable extends StatelessWidget {
  const VarsTable({Key? key}) : super(key: key);

  Icon getIcon(String type) {
    switch (type) {
      case 'byte':
        return const Icon(
          Icons.circle,
          size: 10,
        );
      case 'int':
        return const Icon(
          Icons.looks_one_outlined,
          size: 20,
        );
      case 'bool':
        return const Icon(Icons.check_circle);
      default:
        return const Icon(Icons.all_inclusive_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.select((TimerBloc bloc) => bloc.state.currentMilliseconds);
    final vars = context.read<Variables>();
    final List<Widget> listVars = [];
    for (var element in vars.list.keys) {
      listVars.add(ListTile(
        leading: getIcon(vars.getType(element)),
        tileColor: Colors.grey,
        title: Row(
          children: [
            Text(vars.getType(element), style: const TextStyle(fontSize: 22)),
            Text(' $element', style: const TextStyle(fontSize: 22))
          ],
        ),
        trailing: Text(vars.getValue(element).toString(),
            style: const TextStyle(fontSize: 22)),
        dense: true,
      ));
    }

    return SizedBox(
      width: 400,
      height: 200,
      child: ListView(
        children: listVars,
      ),
    );
  }
}
