import 'package:flutter/material.dart';

class EasyScreen extends StatelessWidget {
  const EasyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text('Начальный уровень'),
      ),
      body: Container(),
    );
  }
}
