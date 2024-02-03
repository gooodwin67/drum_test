import 'package:drum_test/player_widget.dart';
import 'package:flutter/material.dart';

class FreeScreen extends StatelessWidget {
  const FreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlayerWidget(),
    );
  }
}
