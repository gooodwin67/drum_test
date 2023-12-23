import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

//https://github.com/sintakt/sintakt.github.io/blob/master/lib/src/click_player/click_player.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhythm Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Rhythm Challenge'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  PlayerMode mode = PlayerMode.mediaPlayer;

  bool playing = false;

  double bpm = 80;

  int rate = (60000 / 80).round();
  int incTic = 0;
  int level = 0;

  Timer? timer;

  List colors = [Colors.red, Colors.grey, Colors.grey, Colors.grey];

  List notesList = [
    Image.asset('assets/notes/nota1.jpg'),
    Image.asset('assets/notes/nota2.jpg'),
    Image.asset('assets/notes/nota3.jpg'),
    Image.asset('assets/notes/nota4.jpg'),
    Image.asset('assets/notes/nota0.jpg'),
  ];

  int random = Random().nextInt(5);

  List levelsList = [
    [1, 1, 1, 1],
    [1, 1, 1, 1],
    // [1, 1, 1, 1],
    // [1, 1, 1, 1],
    // [1, 1, 2, 1],
    // [1, 1, 2, 1],
    // [1, 1, 2, 1],
    // [1, 1, 3, 1],
    // [1, 1, 3, 1],
    // [1, 1, 3, 1],
    // [1, 1, 1, 1],
  ];
  void _playTic() {
    if (playing == true) {
      if (incTic < 4) {
        incTic++;
      } else {
        incTic = 1;
        if (level < levelsList.length - 1) {
          level++;
        } else {
          //Random().nextInt(3) + 1
          levelsList.add(levelsList.last);
          levelsList.last[Random().nextInt(3) + 1] = Random().nextInt(5) + 1;
          level++;
        }
      }

      if (incTic == 1) {
        player.play(AssetSource('sounds/tic0.WAV'));
      } else {
        player.play(AssetSource('sounds/tic9.WAV'));
      }

      colors.fillRange(0, 4, Colors.grey);
      colors[incTic - 1] = Colors.red;

      setState(() {});
    }
  }

  void plaingNow() {
    if (!playing) {
      rate = (60000 / bpm).round();
      timer =
          Timer.periodic(Duration(milliseconds: rate), (Timer t) => _playTic());
      playing = true;
    } else {
      timer?.cancel();
      playing = false;
      incTic = 0;
      colors.fillRange(0, 4, Colors.grey);
      colors[0] = Colors.red;
      level = 0;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Text('BPM:'),
            ),
            SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.onlyForContinuous,
              ),
              child: Slider(
                min: 50,
                max: 160,
                value: bpm,
                label: bpm.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    bpm = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: rate),
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors[0], width: 2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: notesList[levelsList[level][0] - 1],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: rate),
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors[1], width: 2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: notesList[levelsList[level][1] - 1],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: rate),
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors[2], width: 2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: notesList[levelsList[level][2] - 1],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: rate),
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors[3], width: 2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: notesList[levelsList[level][3] - 1],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('level ' + level.toString()),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                enableFeedback: true,
                onTapDown: (tap) {
                  //
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(148, 76, 175, 79),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        enableFeedback: false,
        onPressed: () {
          plaingNow();
        },
        child: playing ? Icon(Icons.stop) : Icon(Icons.play_arrow),
      ), //
    );
  }
}
