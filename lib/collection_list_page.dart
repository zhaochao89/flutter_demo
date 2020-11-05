import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';

class CollectionListPage extends StatefulWidget {
  final Set<WordPair> suggestions;

  CollectionListPage({Key key, this.suggestions}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print('CollectionListPage createState');
    return _CollectionListPageState();
  }
}

class _CollectionListPageState extends State<CollectionListPage> {
  var _collections = List<WordPair>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('_CollectionListPageState initState');
    widget.suggestions.forEach((element) {
      _collections.add(element);
    });
    print(_collections);
  }

  Widget _createListTile(int index) {
    print('_createListTile');
    if (_collections.length == 0) {
      return ListTile();
    } else {
      return ListTile(
        title: Text(_collections[index].asPascalCase,
            style: TextStyle(fontSize: 24.0)),
        trailing: Icon(Icons.favorite, color: Colors.red),
        onTap: () {
          _onItemTapped(index);
        },
      );
    }
  }

  Widget _createSeparator(int index) {
    print('_createSeparator');
    if (_collections.length > 0) {
      return Divider();
    } else {
      return ListTile();
    }
  }

  _onItemTapped(int index) {
    setState(() {
      _collections.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _tiles = _collections.map((e) {
      return ListTile(
          title: Text(e.asPascalCase, style: TextStyle(fontSize: 24.0)));
    });
    final _divides =
        ListTile.divideTiles(tiles: _tiles, context: context).toList();
    return WillPopScope (
        child: Scaffold(
          appBar: AppBar(title: Text('我的收藏')),
          // body: ListView(children: _divides),
          body: ListView.separated(
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              return _createListTile(index);
            },
            separatorBuilder: (context, index) {
              return _createSeparator(index);
            },
            itemCount: _collections.length,
          ),
        ),
        onWillPop: () async {
          return showDialog(context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text('确定要退出'),
                actions: [
                  RaisedButton(onPressed: () {
                    // return Future.value(true);
                    Navigator.of(context).pop(true);
                  },
                    child: Text('退出'),
                  ),
                  RaisedButton(onPressed: () {
                    // return Future.value(false);
                    Navigator.of(context).pop(false);
                  },
                  child: Text('取消'),
                  )
                ],
              ));
        });
  }
}
