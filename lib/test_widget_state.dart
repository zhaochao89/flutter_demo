import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final int count;
  CounterDisplay({this.count});
  
  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  final VoidCallback onPressed;
  CounterIncrementor({this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: onPressed, child: Text('Increment'));
  }
}

class Counter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CounterState();
  }
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Widget-State分离')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CounterDisplay(count: _counter),
            CounterIncrementor(onPressed: _increment)
          ],
        ),
      )
    );
  }
}