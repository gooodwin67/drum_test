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
  int inc = 0;
  int incTic = 4;
  int level = 0;

  List colors = [Colors.white, Colors.white, Colors.white, Colors.white];

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
    rate = (60000 / bpm).round();
    if (playing == true) {
      Future.delayed(Duration(milliseconds: rate), () {
        if (playing == true) {
          _playTic();

          if (incTic % 4 == 0) {
            inc = 0;
            player.play(AssetSource('sounds/tic9.WAV'));
            incTic++;

            if (level < levelsList.length - 1) {
              level++;
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
          } else {
            player.play(AssetSource('sounds/tic9.WAV'));
            incTic++;
          }

          colors = [Colors.white, Colors.white, Colors.white, Colors.white];
          setState(() {
            colors[inc] = Colors.red;
          });

          inc++;
        }
      });
    } else {
      setState(() {
        inc = 0;
        incTic = 4;
        colors = [Colors.white, Colors.white, Colors.white, Colors.white];
        level = 0;
      });
    }
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
                Container(
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: colors[0],
                  ),
                  child: notesList[levelsList[level][0] - 1],
                ),
                Container(
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: colors[1],
                  ),
                  child: notesList[levelsList[level][1] - 1],
                ),
                Container(
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: colors[2],
                  ),
                  child: notesList[levelsList[level][2] - 1],
                ),
                Container(
                  width: 70,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: colors[3],
                  ),
                  child: notesList[levelsList[level][3] - 1],
                ),
              ],
            ),
            Text(level.toString()),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                enableFeedback: false,
                onTap: () {
                  //await player.play(AssetSource('sounds/tic.mp3'));
                  //player.play(AssetSource('sounds/tic10.WAV'));
                },
                child: Container(
                  color: Colors.green,
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
          playing ? playing = false : playing = true;
          _playTic();
        },
        child: const Icon(Icons.play_arrow),
      ), //
    );
  }
}
