import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:isolate/isolate.dart';

class TestHttpClientPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestHttpClientPage();
  }
}

class _TestHttpClientPage extends State<TestHttpClientPage> {

  final Future<LoadBalancer> loadBalancer = LoadBalancer.create(2, IsolateRunner.spawn);


  get() async {
    print('async');
    final ReceivePort receivePort = ReceivePort();
    final LoadBalancer lb = await loadBalancer;
    //开启一个线程
    await lb.run<dynamic, SendPort>(dataLoader, receivePort.sendPort);
    final SendPort sendPort = await receivePort.first;
    final ReceivePort resultPort = ReceivePort();
    sendPort.send([resultPort.sendPort]);
    //返回的是JOSN字符串
    String response = await resultPort.first;
    print(response);
  }

  // isolate的绑定方法
  static dataLoader(SendPort sendPort) async {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((msg) async {
      SendPort callbackPort = msg[0];
      try {
        var httpClient = HttpClient();
        var uri = Uri.parse('https://pub.dev/packages/isolate');
        var request = await httpClient.getUrl(uri);
        var response = await request.close();
        var value = await response.transform(utf8.decoder).join();
        // print(value);
        // print(res);
        callbackPort.send(value);
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HttpClient')),
      body: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          title: Text('序号$index'),
        );
      }),
      floatingActionButton: RaisedButton(
        child: Icon(Icons.add_circle),
        onPressed: get,
      ),
    );
  }
}