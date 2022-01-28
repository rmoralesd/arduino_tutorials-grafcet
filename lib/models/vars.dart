class Variables {
  final Map<String, dynamic> list = {};

  void appendVar(String name, dynamic value) {
    list[name] = value;
  }
}
