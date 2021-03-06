class Variables {
  final Map<String, dynamic> list = {};

  void appendVar({
    required String name,
    required dynamic currentValue,
    required dynamic resetValue,
    String type = 'unkown',
  }) {
    list[name] = {
      'currentValue': currentValue,
      'resetValue': resetValue,
      'type': type
    };
  }

  String getType(String name) {
    return list[name]['type'];
  }

  dynamic getValue(String name) {
    return list[name]['currentValue'];
  }

  void setValue(String name, dynamic value) {
    list[name]['currentValue'] = value;
  }

  void resetVars() {
    for (var variable in list.keys) {
      list[variable]['currentValue'] = list[variable]['resetValue'];
    }
  }
}
