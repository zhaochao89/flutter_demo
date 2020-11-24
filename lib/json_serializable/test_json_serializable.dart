import 'package:flutter/material.dart';
import 'package:hello_world/json_serializable/joke.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestJsonSeriallizable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestJsonSeriallizableState();
  }
}

class _TestJsonSeriallizableState extends State<TestJsonSeriallizable> {
  List<Joke> jokes = List<Joke>();

  bool isloading = true;
  int page = 0;
  final int pageSize = 20;

  Widget loadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildRow(int index) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 12.0),
              child: SizedBox(
                child: Text('【$index】'),
                width: 50.0,
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(right: 12.0, bottom: 24.0),
                    child: Text('${jokes[index].content}',
                        style: TextStyle(fontSize: 16.0, color: Colors.black87, letterSpacing: 1.0),
                        softWrap: true)),
                Text('更新时间：${jokes[index].updatetime}',
                    style: TextStyle(fontSize: 14.0, color: Colors.black38))
              ],
            ))
          ],
        ),
        Divider()
      ],
    );
  }

  Widget contentWidget() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildRow(index);
      },
      itemCount: jokes.length,
    );
  }

  loadData() async {
    //获取时间戳
    var date = DateTime.now();
    int time = (date.millisecondsSinceEpoch ~/ 1000).toInt();
    print('时间戳： $time');

    String url =
        'http://v.juhe.cn/joke/content/list.php?sort=desc&key=71e2bbccc7b86be5770111e4c36bd243&page=${page}&pagesize=${pageSize}&time=${time}';
    print('url: $url');
    try {
      http.Response response = await http.get(url);
      Map<String, dynamic> dict = json.decode(response.body);
      Map<String, dynamic> result = dict['result'];
      List<dynamic> data = result['data'];

      List<Joke> list = List<Joke>();
      for (int i = 0; i < data.length; i++) {
        Joke joke = Joke.fromJson(data[i]);
        list.add(joke);
      }
      setState(() {
        jokes = list;
        isloading = false;
      });
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('json_serializable'),
      ),
      body: isloading ? loadingWidget() : contentWidget(),
    );
  }
}
