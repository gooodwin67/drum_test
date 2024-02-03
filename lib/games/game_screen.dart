import 'package:drum_test/games/player_game_widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen(
      {super.key,
      required this.level,
      required this.bpm,
      required this.levelListNotes});
  final level;
  final double bpm;
  final levelListNotes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text('Уровень ${level}'),
      ),
      body: PlayerGameWidget(gameBpm: bpm, levelListNotes: levelListNotes),
    );
  }
}
