import 'package:flutter/material.dart';
import 'package:hello_world/home_page.dart';
import 'package:hello_world/native_page.dart';
import 'package:hello_world/second_page.dart';
import 'package:hello_world/third_page.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyBottomNavigationBar();
  }
}

class _MyBottomNavigationBar extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  Widget _currentBody = HomePage();
  List<Widget> _bodyList = [
    HomePage(),
    SecondPage(),
    RandomWords(),
    MyNativePage()
  ];
  _onTap(int index) {
    _currentBody = _bodyList[index];
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return createScaffold();
  }

//  保存页面状态的方法
//  方法一：IndexedStack
  Scaffold createScaffoldOne() {
    return Scaffold(
      body: IndexedStack(children: _bodyList, index: _currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        //type为shifting时，item会滑动，超过3个后，icon非选中状态下不显示
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '历史'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
          BottomNavigationBarItem(icon: Icon(Icons.eighteen_mp), label: '原生通信')
        ],
        onTap: _onTap,
      ),
    );
  }

//方法二：Stack Offstage
  Scaffold createScaffoldTwo() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        //type为shifting时，item会滑动，超过3个后，icon非选中状态下不显示
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '历史'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
          BottomNavigationBarItem(icon: Icon(Icons.eighteen_mp), label: '原生通信')
        ],
        onTap: _onTap,
      ),
      body: Stack(
        children: [
          Offstage(
            offstage: _currentIndex != 0,
            child: _bodyList[0],
          ),
          Offstage(
            offstage: _currentIndex != 1,
            child: _bodyList[1],
          ),
          Offstage(
            offstage: _currentIndex != 2,
            child: _bodyList[2],
          ),
          Offstage(
            offstage: _currentIndex != 3,
            child: _bodyList[3],
          )
        ],
      )
    );
  }
  //上面两种方法会增加一些开销，因为程序第一次加载的时候就会实例化所有子页面状态
//  方法三， 使用PageView，子页面配合使用AutomaticKeepAliveClientMixin保存状态
  final _pageControl = PageController();

  void _onBottomTapped(int index) {
    _pageControl.jumpToPage(index);
  }
  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  Scaffold createScaffold() {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          //type为shifting时，item会滑动，超过3个后，icon非选中状态下不显示
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.black,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: '历史'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
            BottomNavigationBarItem(icon: Icon(Icons.eighteen_mp), label: '原生通信')
          ],
          onTap: _onBottomTapped,
        ),
        body: PageView(
          controller: _pageControl,
          onPageChanged: _onPageChanged,
          children: _bodyList,
          physics: NeverScrollableScrollPhysics(),//禁止滑动
        )
    );
  }
}
