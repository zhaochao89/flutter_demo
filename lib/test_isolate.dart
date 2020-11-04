import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestIsonlate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestIsolate();
  }
}

class _TestIsolate extends State<StatefulWidget> {

  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    ReceivePort receivePort = ReceivePort();
    //创建一个共享代码的隔离区
    await Isolate.spawn(dataLoader, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;
    List msg = await sendReceive(sendPort, 'https://jsonplaceholder.typicode.com/posts');
    setState(() {
      widgets = msg;
    });
  }

  //隔离区的入口
  static dataLoader(SendPort sendPort) async {
    //打开ReceivePort以接收传入消息
    ReceivePort port = ReceivePort();
    //通知其他隔离区该隔离区监听的接口
    sendPort.send(port.sendPort);
    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];
      String dataURL = data;
      http.Response response = await http.get(dataURL);
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

  Widget getRow(int i) {
    return Padding(padding: EdgeInsets.all(10.0), child: Text('Row ${widgets[i]['title']}'));
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }

  ListView getListView() {
    return ListView.builder(itemBuilder: (context, index) {
      return getRow(index);
    },
    itemCount: widgets.length
    );
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  getBody() {
    print('getBody');
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Isolate的使用')),
      body: getBody(),
    );
  }
}