import 'package:flutter/material.dart';
import 'package:hello_world/form-page.dart';
import 'package:hello_world/image_picker_page.dart';
import 'package:hello_world/json_serializable/test_json_serializable.dart';
import 'package:hello_world/layout/layout_page1.dart';
import 'package:hello_world/shopping.dart';
import 'package:hello_world/signature_page.dart';
import 'package:hello_world/test_httpclient_page.dart';
import 'package:hello_world/test_image_picker_page.dart';
import 'package:hello_world/test_isolate.dart';
import 'package:hello_world/test_network_page.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/test_shared_preferences.dart';
import 'package:hello_world/test_widget_state.dart';
import 'package:hello_world/widgets/widget_examples.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final List<Map<String, dynamic>> _list = [
    {'name': 'json_serializable', 'page': TestJsonSeriallizable()},
    {'name': 'Widgets示例', 'page': ZCWidgetExamplesPage()},
    {'name': '绘图', 'page': Signature()},
    {'name': '网络请求', 'page': TestNetworkPage()},
    {'name': 'Isolate的使用', 'page': TestIsonlate()},
    {'name': '表单', 'page': FormPage()},
    {'name': '音视频', 'page': ImagePickerPage(title: '音视频')},
    {'name': 'ImagePicker', 'page': TestImagePickerPage()},
    {'name': 'shared_preferences', 'page': TestSharedPreferences()},
    {'name': 'Widget-State分离', 'page': Counter()},
    {'name': '购物车', 'page': ShoppingList(products: [Product(name: '苹果'), Product(name: '橘子'), Product(name: '香蕉'), Product(name: '菠萝'), Product(name: '草莓')])},
    {'name': '页面布局一', 'page': LayoutPage1()},
    {'name': 'HttpClient的使用', 'page': TestHttpClientPage()}
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('HomePage initState');
    //异步返回的future，在future的then中才能真正得到可用数据
    getJSON().then((value) => print(value));
  }

  Future<String> getJSON() async {
    try {
      return await rootBundle.loadString('assets/lmAppUpdate_gongyouyun.json');
    } catch (e) {
      print(e);
      return null;
    }
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
