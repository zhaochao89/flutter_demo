import 'package:flutter/material.dart';
import 'package:hello_world/form-page.dart';
import 'package:hello_world/signature_page.dart';
import 'package:hello_world/test_isolate.dart';
import 'package:hello_world/test_network_page.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final List<Map<String, dynamic>> _list = [
    {'name': '绘图', 'page': Signature()},
    {'name': '网络请求', 'page': TestNetworkPage()},
    {'name': 'Isolate的使用', 'page': TestIsonlate()},
    {'name': '表单', 'page': FormPage()}
  ];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('HomePage initState');
    //异步返回的future，在future的then中才能真正得到可用数据
    getJSON().then((value) => print(value));
  }

  Future<String> getJSON() async {
    return await rootBundle.loadString('asserts/lmAppUpdate_gongyouyun.json');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(title: Text('home page')),
        body: ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(_list[index]['name']),
                    contentPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    onTap: () {
                      var page = _list[index]['page'];
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => page));
                    },
                  ),
                  Divider()
                ],
              );
            },
            itemCount: _list.length));
  }
}
