import 'package:flutter/material.dart';
import 'package:hello_world/widgets/animatedList.dart';
import 'package:hello_world/widgets/common_examples.dart';

class ZCWidgetExamplesPage extends StatelessWidget {
  final List<Map<String, dynamic>> _dataSource = [
    {'name': 'Placeholder', 'page': CommonExamplePage()},
    {'name': 'AnimatedList', 'page': AnimatedListSample()}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Widgets的使用')),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  title: Text(_dataSource[index]['name']),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => _dataSource[index]['page']));
                  },
                ),
                Divider()
              ],
            );
          },
          itemCount: _dataSource.length,
        ));
  }
}
