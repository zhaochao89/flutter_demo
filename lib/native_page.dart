import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNativePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyNativePage();
  }
}

class _MyNativePage extends State<MyNativePage>
    with AutomaticKeepAliveClientMixin {
  MethodChannel platform;
  var _title = "从原生端获取数据";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('MyNativePage initState');
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget platformView() {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        //iOS平台
        return UiKitView(
          viewType: "plugins.flutter.io/custom_platform_view",
          creationParams: {'message': '从flutter nativePage传过来的参数'},
          creationParamsCodec: StandardMessageCodec(),
          onPlatformViewCreated: (viewId) {
            print('native page viewId：$viewId');
            //通过viewID创建MethodChannel，解决flutter嵌入多个相同原生组件的通信问题
            platform = MethodChannel('com.flutter.guide.MyFlutterView_$viewId');
          },
        );
      } else {
        return Text('second page');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Native page'),
      ),
      body: Column(
        children: [
          RaisedButton(
              child: Text('这是flutter RaisedButton组件，点击传递事件参数给原生'),
              onPressed: () {
                platform
                    .invokeMethod('setText', {'name': 'flutter', 'age': 32});
              }),
          RaisedButton(
              child: Text(_title),
              onPressed: () async {
                var result = await platform.invokeMethod('getData');
                setState(() {
                  //setState不生效的原因_title定义在了build中，每次更新状态时都会重新创建build，
                  // 所以导致_title每次都是初始化状态的值，将_title的定义提到build方法之外。
                  _title = result['name'];
                });
              }),
          Expanded(child: platformView())
        ],
      ),
    );
  }
}
