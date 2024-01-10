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

  int difficulty = 3; //1-3

  int bam = 0;
  int lastBam = 0;

  Timer? timer;

  List colors = [Colors.red, Colors.grey, Colors.grey, Colors.grey];
  List tapColors = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];

  Color winColor = Colors.white;

  List notesList = [
    Image.asset('assets/notes/nota0.jpg'),
    Image.asset('assets/notes/nota1.jpg'),
    Image.asset('assets/notes/nota2.jpg'),
    Image.asset('assets/notes/nota3.jpg'),
    Image.asset('assets/notes/nota4.jpg'),
  ];

  int random = Random().nextInt(5);

  List levelsList = [1, 1, 4, 1];
  void _playTic() {
    if (playing == true) {
      lastBam = bam;

      if (incTic > 0) {
        print(
            'aaaaaaaaaaaaaaaaaaaaaaaaaa ${lastBam} -- ${levelsList[incTic - 1]}');
        if (lastBam == levelsList[incTic - 1]) {
          setState(() {
            winColor = Colors.green;
          });
        } else {
          setState(() {
            winColor = Colors.white;
          });
        }
      }

      if (incTic < 4) {
        incTic++;
        bam = 0;
        tapColors = [
          Colors.transparent,
          Colors.transparent,
          Colors.transparent,
          Colors.transparent
        ];

        if (level > 1) {
          switch (incTic) {
            case 1:
              Random().nextInt(3 - difficulty + 2) == 1
                  ? levelsList[2] = Random().nextInt(5)
                  : levelsList[2] = levelsList[2];
              break;
            case 2:
              Random().nextInt(3 - difficulty + 2) == 1
                  ? levelsList[3] = Random().nextInt(5)
                  : levelsList[3] = levelsList[3];
              break;
            case 3:
              Random().nextInt(3 - difficulty + 2) == 1
                  ? levelsList[0] = Random().nextInt(5)
                  : levelsList[0] = levelsList[0];
              break;
            case 4:
              Random().nextInt(3 - difficulty + 2) == 1
                  ? levelsList[1] = Random().nextInt(5)
                  : levelsList[1] = levelsList[1];
              break;
            default:
          }
          setState(() {});
        }
      } else {
        incTic = 1;
        level++;
        bam = 0;
        tapColors = [
          Colors.transparent,
          Colors.transparent,
          Colors.transparent,
          Colors.transparent
        ];
      }

      if (incTic == 1) {
        player.play(AssetSource('sounds/tic1n.MP3'));
      } else {
        player.play(AssetSource('sounds/tic1n.MP3'));
      }

      colors.fillRange(0, 4, Colors.grey);
      colors[incTic - 1] = Colors.red;

      setState(() {});
    }
  }

  void plaingNow() {
    if (!playing) {
      rate = (60000 / bpm).round();
      timer = Timer.periodic(
          Duration(milliseconds: rate + 20), (Timer t) => _playTic());
      playing = true;
    } else {
      levelsList = [1, 1, 4, 1];
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
              child: Text('BPM: ${bpm.round()}'),
            ),
            SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.onlyForContinuous,
              ),
              child: Slider(
                min: 50,
                max: 130,
                value: bpm,
                label: bpm.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    bpm = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    width: 70,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[0], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[levelsList[0]],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    width: 70,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[1], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[levelsList[1]],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    width: 70,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[2], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[levelsList[2]],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    width: 70,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[3], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[levelsList[3]],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 50,
                          width: 30,
                          decoration: BoxDecoration(
                              color: winColor,
                              border: Border.all(color: Colors.grey)),
                        ),
                        Container(
                            width: 30,
                            height: 100,
                            child: ListView.builder(
                                reverse: true,
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: tapColors[index],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                })),
                      ],
                    ),
                    InkWell(
                      enableFeedback: true,
                      onTapDown: (tap) {
                        setState(() {
                          bam++;
                          if (bam > 0 && bam < 5) {
                            setState(() {
                              tapColors[bam - 1] = Colors.green;
                            });
                          }
                        });
                        //print('aaa - ${bam}');
                      },
                      child: Image.asset(
                        'assets/images/pad.jpg',
                        height: 200,
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 200,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('incTic ' + incTic.toString()),
            Text('level ' + level.toString()),
            Text('lastBam ' + lastBam.toString()),
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
