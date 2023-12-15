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
      title: 'Drum Rhythm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Drum Rhythm'),
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
  ];

  int random = Random().nextInt(3);

  List levelsList = [
    [1, 1, 1, 1],
    [1, 1, 1, 1],
    [1, 1, 1, 1],
    [1, 1, 1, 1],
    [1, 1, 2, 1],
    [1, 1, 2, 1],
    [1, 1, 2, 1],
    [1, 1, 3, 1],
    [1, 1, 3, 1],
    [1, 1, 3, 1],
    [1, 1, 1, 1],
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
          levelsList.last[Random().nextInt(3) + 1] = Random().nextInt(3) + 1;
          level++;
        }
      }
      if (incTic == 1) {
        player.play(AssetSource('sounds/tic0.WAV'));
      } else {
        player.play(AssetSource('sounds/tic11.WAV'));
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

/*
  void _playTic() {
    //player.setPlayerMode(PlayerMode.lowLatency);
    rate = (60000 / bpm).round();
    if (playing == true) {
      Future.delayed(Duration(milliseconds: rate), () {
        if (playing == true) {
          player.play(AssetSource('sounds/tic9.WAV'));
          incTic++;
          inc++;
          print(inc);

          if (level < levelsList.length - 1) {
            if (incTic % 4 == 0) {
              level++;
              inc = 0;
            }
          } else {
            int note2 = Random().nextInt(3) + 1;
            int note3 = Random().nextInt(3) + 1;
            int note4 = Random().nextInt(3) + 1;

            levelsList[levelsList.length - 2][0] = 1;
            levelsList[levelsList.length - 2][1] = note2;
            levelsList[levelsList.length - 2][2] = note3;
            levelsList[levelsList.length - 2][3] = note4;

            levelsList[levelsList.length - 1][0] = 1;
            levelsList[levelsList.length - 1][1] = note2;
            levelsList[levelsList.length - 1][2] = note3;
            levelsList[levelsList.length - 1][3] = note4;
            level--;
          }

          colors = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];

          setState(() {
            colors[inc] = Colors.red;
          });
          _playTic();
        }
      });
    } else {
      setState(() {
        inc = 0;
        incTic = 4;
        colors = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];
        level = 0;
      });
    }
  }
*/
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
              child: Text('BPM'),
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
                  ),
                  child: notesList[levelsList[level][0] - 1],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: rate),
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors[1], width: 2),
                  ),
                  child: notesList[levelsList[level][1] - 1],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: rate),
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors[2], width: 2),
                  ),
                  child: notesList[levelsList[level][2] - 1],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: rate),
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors[3], width: 2),
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
                  color: const Color.fromARGB(148, 76, 175, 79),
                  width: double.infinity,
                  height: 200,
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
