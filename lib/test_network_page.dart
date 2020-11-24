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
  Map<String, dynamic> widgets = Map<String, dynamic>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoading() {
    //widgets要初始化，否则.length会报错。
    if (widgets.length == 0) {
      return true;
    }
    return false;
  }

  Widget getBody() {
    if (showLoading()) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return getRow(index);
        },
        itemCount: 5,
      );
    }
  }

  loadData() async {
    String dataURL = "https://httpbin.org/ip";
    try {
      http.Response response = await http.get(dataURL);
      setState(() {
        // Utf8Decoder decode = Utf8Decoder();
        // widgets = json.decode(decode.convert(response.bodyBytes));
        widgets = json.decode(response.body);
      });
    } catch (error) {
      print("请求出错 $error");
    }
  }

  Widget getRow(int i) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Text('序号$i: ${widgets['origin']}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('网络请求')),
      body: getBody()
    );
  }
}
