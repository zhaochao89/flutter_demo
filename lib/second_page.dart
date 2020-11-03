import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondPage extends StatefulWidget {
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin {

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('SecondPage init');
  }

  Widget myFlutterView() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: "plugins.flutter.io/custom_platform_view",
        creationParams: {'message': '从flutter Second Page传过来的参数'},
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (viewId) {
          print('viewId: $viewId');
        },
      );
    } else {
      return Text('Second Page');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Second page'),
        ),
        body: Center(
          child: myFlutterView(),
        )
    );
  }
}
