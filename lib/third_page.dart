import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

/*
* Widget和Element是紧密关联着的并且提供给Element某些信息。
* Widget本身是无状态的，所有属性字段都必须是final的。
* Widget并不会直接管理状态及渲染，而是通过State这个对象来管理状态。
* 实际界面开发当中，一个视图树可能包含有多个TextWidget(widget可能被使用多次)，但是这些都叫作TextWidget的widget却被填充进一个个独立的Element中。
* Widget通过Key和runtimeType来决定自身在Element tree中，是更新，插入，还是删除等操作。
* 开发者不用手动去操纵Element，多数情况是框架的内部逻辑在操作。
* */
class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RandomWordsState();
  }
}

class _RandomWordsState extends State<RandomWords> with AutomaticKeepAliveClientMixin {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 24.0);
  final _saved = Set<WordPair>();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('RandomWords initState');
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider();
          }
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  _pushSaved() {
    // Navigator.push(context, MaterialPageRoute(builder: (context){
    //   return SavedPage(savedSuggestions: _saved);
    // }));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SavedPage(savedSuggestions: _saved)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

class SavedPage extends StatelessWidget {

  final Set<WordPair> savedSuggestions;

  SavedPage({Key key, @required this.savedSuggestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tiles = savedSuggestions.map((pair) {
      return ListTile(
          title: Text(pair.asPascalCase, style: TextStyle(fontSize: 24.0)));
    });
    final divided =
    ListTile.divideTiles(tiles: _tiles, context: context).toList();
    return Scaffold(
      appBar: AppBar(title: Text('收藏')),
      body: ListView(children: divided),
    );
  }
}