import 'package:drum_test/games/easy_level.dart';
import 'package:drum_test/games/hard_level.dart';
import 'package:drum_test/games/player_game_widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen(
      {super.key,
      required this.level,
      required this.bpm,
      required this.levelListNotes,
      required this.prefs,
      required this.diff});
  final level;
  final double bpm;
  final levelListNotes;
  final prefs;
  final diff;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/rhythm-back2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Уровень ${level}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) {
              return;
            }
            print('exit');
            Navigator.pop(context);
            Navigator.pop(context);

            if (diff == 'easy') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EasyScreen()));
            } else if (diff == 'hard') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HardScreen()));
            }
          },
          child: PlayerGameWidget(
              gameBpm: bpm,
              levelListNotes: levelListNotes,
              prefs: prefs,
              level: level,
              diff: diff),
        ),
      ),
    );
  }
}
