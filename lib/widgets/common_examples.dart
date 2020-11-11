import 'package:flutter/material.dart';

class CommonExamplePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CommonExampleState();
  }
}
/*
 * Placeholder 占位符控价，默认会填充父控件。在一个无限空间的时候可以通过fallbackHeight，fallbackWidth来指定高宽。
 * 指定宽高的时候，宽一般是不生效，会和父控件一样宽。
 * */
class _CommonExampleState extends State<CommonExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('示例')),
      body: Column(
        children: [
          Placeholder(
            fallbackHeight: 100.0,
            fallbackWidth: 100.0,
            color: Colors.black12,
            strokeWidth: 1.0,
          )
        ],
      ),
    );
  }
}