import "package:flutter/material.dart";
import 'package:hello_world/tabbar.dart';

// void main() {
//   runApp(MyApp());
// }
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hello world app',
        theme: ThemeData(primaryColor: Colors.blue),
        home: MyBottomNavigationBar());
  }
}
