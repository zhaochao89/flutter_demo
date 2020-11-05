import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FormPageState();
  }
}

class _FormPageState extends State<FormPage> {
  var _result = '请提交内容';
  TextEditingController _userNameController;
  var _passwordController = TextEditingController();
  var _errorUserName = 'ddd';
  var _errorPassword = '';
  var _passwordValue = '';

  FocusNode _blankNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController()
      ..addListener(() {
        print('userName 输入');
      });
  }

  @override
  dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  Widget _userNameWidget() {
    return Row(
      children: [
        SizedBox(
            child: Text('用户名：',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
            width: 80.0),
        Expanded(
            child: TextField(
          controller: _userNameController,
          decoration: InputDecoration(
            icon: Icon(Icons.person),
            hintText: '请输入用户名',
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54)),
            helperText: '用户名长度为6-10个字母',
            // errorText: _errorUserName
          ),
          keyboardType: TextInputType.phone,
        )),
        SizedBox(width: 80.0)
      ],
    );
  }

  Widget _passwordWidget() {
    return Row(
      children: [
        SizedBox(
          child: Text('密码：',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
          width: 80.0,
        ),
        Expanded(
          child: TextField(
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _passwordValue = value;
              });
            },
            controller: _passwordController,
            decoration: InputDecoration(
                icon: Icon(Icons.alarm_rounded),
                hintText: '请输入密码',
                helperText: '密码位6-18位数字、字母组合',
                // errorText: _errorPassword
                counterText: '${_passwordValue.length}/18'),
          ),
        ),
        SizedBox(
          width: 80.0,
        )
      ],
    );
  }

  _dismissKeyboard(BuildContext context) {
    print('_dismissKeyboard ${_blankNode.hasFocus}');
    FocusScope.of(context).requestFocus(_blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('登录')),
        body: GestureDetector(
          onTap: () {
            print('========');
            _dismissKeyboard(context);
          },
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Text('$_result', style: TextStyle(fontSize: 18.0)),
              SizedBox(height: 32.0),
              _userNameWidget(),
              SizedBox(height: 10.0),
              _passwordWidget(),
              SizedBox(height: 32.0),
              RaisedButton(
                onPressed: () {
                  _dismissKeyboard(context);
                  var text = '';
                  if (_userNameController.text.length > 0) {
                    text = '用户名：' + _userNameController.text;
                  }
                  if (_passwordController.text.length > 0) {
                    text += ' 密码：' + _passwordController.text;
                  }
                  if (text.length > 0) {
                    setState(() {
                      _result = text;
                    });
                  }
                },
                child: Text('登录'),
              ),
              Expanded(child: Container()),
            ],
          ),
        ));
  }
}
