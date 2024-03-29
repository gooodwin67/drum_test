import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:soundpool/soundpool.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);
  Soundpool pool2 = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);
  late AudioPlayer player = AudioPlayer();
  int soundId = 0;
  int soundId2 = 0;
  loadSound() async {
    soundId = await rootBundle
        .load("assets/sounds/tic.WAV")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    soundId2 = await rootBundle
        .load("assets/sounds/tic.WAV")
        .then((ByteData soundData) {
      return pool2.load(soundData);
    });
    //await player.setVolume(0.7);
    await player.setPlaybackRate(bpm / 0.8 / 100);
    await player.play(AssetSource('sounds/gener808.wav'));
    await player.stop();
  }

  bool playing = false;

  double bpm = 80;

  int rate = (60000 / 80).round();
  int incTic = 0;
  int level = 0;

  int difficulty = 1; //1-3 Частота смены нот

  int bam = 0;
  int lastBam = 0;

  bool playMusic = false;

  Timer? timer;

  List colors = [
    Color.fromARGB(255, 123, 125, 255),
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];
  List tapColors = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];

  Color winColor = Colors.white;

  List notesList = [
    Image.asset('assets/notes/nota0.png'),
    Image.asset('assets/notes/nota1.png'),
    Image.asset('assets/notes/nota2.png'),
    Image.asset('assets/notes/nota3.png'),
    Image.asset('assets/notes/nota4.png'),
  ];

  List noteCanList = [0, 1, 2, 3, 4];
  List noteActive = [true, true, true, true, false];

  int random = Random().nextInt(5);

  List levelsList = [0, 0, 0, 0];
  void _playTic() async {
    if (playing == true) {
      lastBam = bam;
      if ((player.state == PlayerState.completed ||
              player.state == PlayerState.stopped) &&
          playMusic) {
        player.setPlaybackRate(bpm / 0.8 / 100);
        player.play(AssetSource('sounds/gener808.wav'));
        player.seek(Duration(milliseconds: 80));
      }

      if (incTic > 0) {
        if (lastBam == levelsList[incTic - 1]) {
          setState(() {
            winColor = Colors.green;
          });
        } else {
          setState(() {
            winColor = Colors.red;
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

      if (level > 0) {
        switch (incTic) {
          case 1:
            Random().nextInt(3 - difficulty + 2) == 1
                ? levelsList[2] =
                    noteCanList[Random().nextInt(noteCanList.length)]
                : levelsList[2] = levelsList[2];
            break;
          case 2:
            Random().nextInt(3 - difficulty + 2) == 1
                ? levelsList[3] =
                    noteCanList[Random().nextInt(noteCanList.length)]
                : levelsList[3] = levelsList[3];
            break;
          case 3:
            Random().nextInt(3 - difficulty + 2) == 1
                ? levelsList[0] =
                    noteCanList[Random().nextInt(noteCanList.length)]
                : levelsList[0] = levelsList[0];
            break;
          case 4:
            Random().nextInt(3 - difficulty + 2) == 1
                ? levelsList[1] =
                    noteCanList[Random().nextInt(noteCanList.length)]
                : levelsList[1] = levelsList[1];
            break;
          default:
        }
        setState(() {});
      }

      if (incTic == 1) {
        pool.play(soundId);
      } else {
        pool2.play(soundId2);
      }

      colors.fillRange(0, 4, Colors.grey);
      colors[incTic - 1] = Color.fromARGB(255, 123, 125, 255);

      setState(() {});
    }
  }

  void plaingNow() async {
    if (!playing) {
      Wakelock.enable();
      noteCanList = [];
      for (int i = 0; i < noteActive.length; i++) {
        if (noteActive[i]) {
          noteCanList.add(i);
        }
      }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
      rate = (60000 / bpm).round();
      timer =
          Timer.periodic(Duration(milliseconds: rate), (Timer t) => _playTic());
      playing = true;
      setState(() {});
    } else {
      await player.stop();
      Wakelock.disable();
      noteCanList[0] == 0
          ? levelsList = [0, 0, 0, 0]
          : levelsList = [1, 1, 1, 1];
      timer?.cancel();
      playing = false;
      incTic = 0;
      colors.fillRange(0, 4, Colors.grey);
      colors[0] = Color.fromARGB(255, 123, 125, 255);
      level = 0;
      setState(() {});
    }
  }

  @override
  void initState() {
    loadSound();
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/rhythm-back-white.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('РИТМ Челлендж'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: child,
                  );
                },
                child: !playing
                    ? Container(
                        key: Key('showMenu'),
                        padding: const EdgeInsets.all(10.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('BPM: ${bpm.round()}'),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SliderTheme(
                                data: SliderThemeData(
                                  overlayShape: SliderComponentShape.noThumb,
                                  showValueIndicator: ShowValueIndicator.always,
                                ),
                                child: Slider(
                                  min: 50,
                                  max: 200,
                                  value: bpm,
                                  label: bpm.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      bpm = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                                'Сложность (частота смены нот): ${difficulty.round()}'),
                            Container(
                              width: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    overlayShape: SliderComponentShape.noThumb,
                                    showValueIndicator:
                                        ShowValueIndicator.always,
                                  ),
                                  child: Slider(
                                    min: 1,
                                    max: 3,
                                    value: difficulty.toDouble(),
                                    label: difficulty.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        difficulty = value.toInt();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 25,
                                    height: 10,
                                    child: Checkbox(
                                        value: playMusic,
                                        onChanged: (value) {
                                          setState(() {
                                            playMusic = value!;
                                          });
                                        }),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    child: Text('Играть музыку (beta)'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Используемые ноты'),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: noteActive[0]
                                              ? Color.fromARGB(
                                                  255, 218, 190, 159)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 175, 175, 175)),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              noteActive[0]
                                                  ? noteActive[0] = false
                                                  : noteActive[0] = true;
                                              if (noteActive[0] == false) {
                                                levelsList = [1, 1, 1, 1];
                                              } else {
                                                levelsList = [0, 0, 0, 0];
                                              }
                                            });
                                          },
                                          child: notesList[0],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: noteActive[1]
                                              ? Color.fromARGB(
                                                  255, 218, 190, 159)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 175, 175, 175)),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              noteActive[1]
                                                  ? noteActive[1] = false
                                                  : noteActive[1] = true;
                                            });
                                          },
                                          child: notesList[1],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: noteActive[2]
                                              ? Color.fromARGB(
                                                  255, 218, 190, 159)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 175, 175, 175)),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              noteActive[2]
                                                  ? noteActive[2] = false
                                                  : noteActive[2] = true;
                                            });
                                          },
                                          child: notesList[2],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: noteActive[3]
                                              ? Color.fromARGB(
                                                  255, 218, 190, 159)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 175, 175, 175)),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              noteActive[3]
                                                  ? noteActive[3] = false
                                                  : noteActive[3] = true;
                                            });
                                          },
                                          child: notesList[3],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: noteActive[4]
                                              ? Color.fromARGB(
                                                  255, 218, 190, 159)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 175, 175, 175)),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              noteActive[4]
                                                  ? noteActive[4] = false
                                                  : noteActive[4] = true;
                                            });
                                          },
                                          child: notesList[4],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        key: Key('hideMenu'),
                      ),
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AnimatedContainer(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                      duration: Duration(milliseconds: 0),
                      width: MediaQuery.of(context).size.width / 4.5,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors[0], width: 3),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: notesList[levelsList[0]],
                    ),
                    AnimatedContainer(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                      duration: Duration(milliseconds: 0),
                      width: MediaQuery.of(context).size.width / 4.5,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors[1], width: 3),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: notesList[levelsList[1]],
                    ),
                    AnimatedContainer(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                      duration: Duration(milliseconds: 0),
                      width: MediaQuery.of(context).size.width / 4.5,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors[2], width: 3),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: notesList[levelsList[2]],
                    ),
                    AnimatedContainer(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                      duration: Duration(milliseconds: 0),
                      width: MediaQuery.of(context).size.width / 4.5,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors[3], width: 3),
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
                      TapLine(winColor: winColor, tapColors: tapColors),
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/pad.png',
                            height: 200,
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(1000),
                                splashColor:
                                    const Color.fromARGB(10, 255, 255, 255),
                                enableFeedback: true,
                                onTapDown: (tap) {
                                  Vibration.vibrate(
                                      duration: 50, amplitude: 128);
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
                              ),
                            ),
                          ),
                        ],
                      ),
                      TapLine(winColor: winColor, tapColors: tapColors),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Text('incTic ' + incTic.toString()),
              // Text('level ' + level.toString()),
              // Text('lastBam ' + lastBam.toString()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          enableFeedback: false,
          onPressed: () async {
            if (noteActive[0] == false &&
                noteActive[1] == false &&
                noteActive[2] == false &&
                noteActive[3] == false &&
                noteActive[4] == false) {
              setState(() {
                noteActive[0] = true;
              });
            }
            plaingNow();
          },
          child: playing
              ? Icon(
                  Icons.stop,
                  color: Colors.white,
                  size: 40,
                )
              : Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
        ), //
      ),
    );
  }
}

class TapLine extends StatelessWidget {
  const TapLine({
    super.key,
    required this.winColor,
    required this.tapColors,
  });

  final Color winColor;
  final List tapColors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: winColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey)),
        ),
        Container(
            width: 30,
            height: 90,
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
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                })),
      ],
    );
  }
}
