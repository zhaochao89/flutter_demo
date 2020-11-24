import 'package:flutter/material.dart';
import 'package:hello_world/json_serializable/joke.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum LoadingStatus {
  STATUS_LOADING,//加载中
  STATUS_COMPLETE,//加载完成
  STATUS_IDEL//空闲状态
}

class TestJsonSeriallizable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestJsonSeriallizableState();
  }
}

class _TestJsonSeriallizableState extends State<TestJsonSeriallizable> {
  List<Joke> jokes = List<Joke>();
  ScrollController _scrollController = ScrollController();
  bool isloading = true;
  int page = 0;
  final int pageSize = 20;
  int time = 0;
  LoadingStatus _loadingStatus = LoadingStatus.STATUS_IDEL;
  String _loadingText = '上拉加载更多';
  bool _loadMoreCancel = false;

  @override
  void initState() {
    super.initState();
    loadData();
    _scrollController.addListener(() {
      //拉到最大位置时，开始加载更多
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _loadingStatus == LoadingStatus.STATUS_IDEL) {
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget loadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget loadMoreWidget() {
    var loadingText = Container(
      padding: EdgeInsets.only(left: 10.0),
      child: Text(_loadingText, style: TextStyle(fontSize: 13.0, color: Colors.blue)),
    );
    var loadingIndicator = Visibility(
        visible: _loadingStatus == LoadingStatus.STATUS_LOADING,
        child: SizedBox(
          width: 10.0,
          height: 10.0,
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue), strokeWidth: 1.5),
        )
    );
    return Row(
      children: [
        loadingIndicator,
        loadingText
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
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
                        softWrap: true,)),
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
        if (index == jokes.length - 1 && jokes.length >= pageSize) {
          return loadMoreWidget();
        } else {
          return _buildRow(index);
        }
      },
      itemCount: jokes.length,
      controller: _scrollController,
    );
  }

  Future<void> loadData() async {
    page = 0;
    _loadMoreCancel = true;
    setState(() {
      _loadingStatus = LoadingStatus.STATUS_IDEL;
      _loadingText = '上拉加载更多';
    });
    //获取时间戳
    var date = DateTime.now();
    time = (date.millisecondsSinceEpoch ~/ 1000).toInt();
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

  loadMoreData() async {
    if (_loadingStatus == LoadingStatus.STATUS_LOADING) {
      return;
    }
    _loadMoreCancel = false;
    setState(() {
      _loadingStatus = LoadingStatus.STATUS_LOADING;
      _loadingText = '加载中...';
    });
    page++;
    String url = 'http://v.juhe.cn/joke/content/list.php?sort=desc&key=71e2bbccc7b86be5770111e4c36bd243&page=${page}&pagesize=${pageSize}&time=${time}';
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
      if (_loadMoreCancel) {
        return;
      }
      setState(() {
        if (list.length > 0) {
          jokes.addAll(list);
          _loadingStatus = LoadingStatus.STATUS_IDEL;
          _loadingText = '上拉加载更多';
        } else {
          _loadingStatus = LoadingStatus.STATUS_COMPLETE;
          _loadingText = '已加载全部数据';
        }
      });
    } catch (e) {
      setState(() {
        _loadingStatus = LoadingStatus.STATUS_IDEL;
        _loadingText = '上拉加载更多';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('json_serializable'),
      ),
      body: RefreshIndicator(
        displacement: 20.0,
        onRefresh: loadData,
        child: isloading ? loadingWidget() : contentWidget(),
      )
    );
  }
}
