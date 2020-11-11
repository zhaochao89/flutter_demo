import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestSharedPreferences extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestSharedPreferences();
  }
}

class _TestSharedPreferences extends State<TestSharedPreferences> {
  String _result = '';
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getLocalData();
  }

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('userName');
    var password = prefs.getString('password');
    if (userName != null) {
      setState(() {
        _result += ('userName：' + userName);
      });
    }
    if (password != null) {
      setState(() {
        _result += (' password：' + password);
      });
    }
  }

  _saveLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_userController.text.length > 0) {
      prefs.setString('userName', _userController.text);
    }
    if (_passwordController.text.length > 0) {
      prefs.setString('password', _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shared_preferences')),
      body: Center(
        child: Column(
          children: [
            Text('$_result'),
            Row(
              children: [
                SizedBox(
                  child:Text('用户名'),
                  width: 80.0,
                ),
                Flexible(
                  child: TextField(decoration: InputDecoration(hintText: '请输入用户名'), controller: _userController),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  child:Text('密码'),
                  width: 80.0,
                ),
                Flexible(
                  child: TextField(decoration: InputDecoration(hintText: '密码'), controller: _passwordController,),
                )
              ],
            ),
            RaisedButton(onPressed: _saveLocalData,
              child: Text('保存'),
            )
          ],
        ),
      ),
    );
  }
}