import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TestNetworkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextNetworkPageState();
  }
}

class _TextNetworkPageState extends State<TestNetworkPage> {
  List widgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    String dataURL = "http://192.168.4.10/lmAppPlatform_v2.json";
    try {
      http.Response response = await http.get(dataURL);
      setState(() {
        Utf8Decoder decode = Utf8Decoder();
        widgets = json.decode(decode.convert(response.bodyBytes));
      });
    } catch (error) {
      print("请求出错 $error");
    }
  }

  Widget getRow(int i) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('序号$i: ${widgets[i]['platformName']}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('网络请求')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return getRow(index);
        },
        itemCount: widgets.length,
      ),
    );
  }
}
