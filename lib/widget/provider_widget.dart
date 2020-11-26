import 'package:flutter/material.dart';
import 'package:flutter_wsa/services/auth_service.dart';

class Provider extends InheritedWidget {
  final AuthService auth;
  final db;
  final colors;

  Provider(
      {Key key,
      Widget child,
      this.auth,
      this.db,
      this.colors,
      bool debugShowCheckedModeBanner})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>());
}
