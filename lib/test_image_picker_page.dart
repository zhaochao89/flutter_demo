import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter/cupertino.dart'

class TestImagePickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestImagePickerPageState();
  }
}

class _TestImagePickerPageState extends State<TestImagePickerPage> {
  final _picker = ImagePicker();
  File _image;

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _chooseType() {
      showCupertinoDialog(context: context, builder: (context) {
        return CupertinoAlertDialog(
          title: Text('提示'),
          content: Text('确定要删除吗？'),
          actions: [
            CupertinoDialogAction(child: Text('取消'), onPressed: () {
              print('点击取消了');
              Navigator.of(context).pop();
            }),
            CupertinoDialogAction(child: Text('确定'), onPressed: () {
              print('点击确定了');
              Navigator.pop(context);
            })
          ],
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('image picker')),
      body: Center(
        child: _image == null ? Text('No image selected') : Image.file(_image)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _chooseType,
        tooltip: 'Pick Image',
      child: Icon(Icons.add_a_photo),
    ),
      );
  }
}