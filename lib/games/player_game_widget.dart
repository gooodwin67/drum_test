import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:soundpool/soundpool.dart';
import 'package:wakelock/wakelock.dart';

class PlayerGameWidget extends StatefulWidget {
  const PlayerGameWidget(
      {super.key, required this.gameBpm, required this.levelListNotes});

  final double gameBpm;
  final List levelListNotes;

  @override
  State<PlayerGameWidget> createState() => _PlayerGameWidgetState();
}

class _PlayerGameWidgetState extends State<PlayerGameWidget> {
  bool dead = false;
  int lives = 3;
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);
  Soundpool pool2 = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);
  int soundId = 0;
  int soundId2 = 0;
  loadSound() async {
    soundId = await rootBundle
        .load("assets/sounds/tic0n.WAV")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    soundId2 = await rootBundle
        .load("assets/sounds/tic9n.WAV")
        .then((ByteData soundData) {
      return pool2.load(soundData);
    });
  }

  bool playing = false;

  int rate = (60000 / 80).round();
  int incTic = 0;
  int level = 0;

  int difficulty = 1; //1-3 Частота смены нот

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

  List noteCanList = [0, 1, 2, 3, 4];
  List noteActive = [true, true, true, true, true];

  int random = Random().nextInt(5);

  //List levelsList = [0, 0, 0, 0];
  void _playTic(levelListNotes) {
    if (playing == true) {
      lastBam = bam;

      if (incTic > 0) {
        if (lastBam == levelListNotes[level][incTic - 1]) {
          setState(() {
            winColor = Colors.green;
          });
        } else {
          setState(() {
            winColor = Colors.red;
            lives--;
            if (lives == 0) {
              plaingNow(widget.gameBpm);
              playing = false;
              dead = true;
              showAlertDialog(context, lives);
              lives = 3;
              incTic = -1;
            }
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
        if (level < widget.levelListNotes.length - 1) {
          incTic = 1;
          level++;
          bam = 0;
          tapColors = [
            Colors.transparent,
            Colors.transparent,
            Colors.transparent,
            Colors.transparent
          ];
        } else {
          plaingNow(widget.gameBpm);
          playing = false;
          dead = true;
          showAlertDialog(context, lives);
          lives = 3;
        }
      }

      if (playing) {
        if (incTic == 1) {
          pool.play(soundId);
        } else {
          pool2.play(soundId2);
        }

        colors.fillRange(0, 4, Colors.grey);
        colors[incTic - 1] = Colors.red;
      }

      setState(() {});
    }
  }

  void plaingNow(gameBpm) {
    if (!playing) {
      lives = 3;
      Wakelock.enable();
      noteCanList = [];
      for (int i = 0; i < noteActive.length; i++) {
        if (noteActive[i]) {
          noteCanList.add(i);
        }
      }

      rate = (60000 / gameBpm).round();
      timer = Timer.periodic(Duration(milliseconds: rate),
          (Timer t) => _playTic(widget.levelListNotes));
      playing = true;
      setState(() {});
    } else {
      Wakelock.disable();
      //levelListNotes[0]/////////////////////////////
      timer?.cancel();
      playing = false;
      incTic = 0;
      colors.fillRange(0, 4, Colors.grey);
      colors[0] = Colors.red;
      level = 0;
      dead = false;

      setState(() {});
    }
  }

  @override
  void initState() {
    loadSound();
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
      backgroundColor: Color(0xFFffffff),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 5,
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
                    child: notesList[widget.levelListNotes[level][0]],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    width: 70,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[1], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[widget.levelListNotes[level][1]],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    width: 70,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[2], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[widget.levelListNotes[level][2]],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    width: 70,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[3], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[widget.levelListNotes[level][3]],
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
                              splashColor:
                                  const Color.fromARGB(10, 255, 255, 255),
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
            Text('level ' + level.toString()),
            Text('lives ' + lives.toString()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        enableFeedback: false,
        onPressed: () {
          plaingNow(widget.gameBpm);
        },
        child: playing ? Icon(Icons.stop) : Icon(Icons.play_arrow),
      ), //
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

showAlertDialog(BuildContext context, lives) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      lives = 3;
      Navigator.pop(context);
    },
  );
  Widget compliteButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      lives = 3;
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
  Widget cancelButton = TextButton(
    child: Text("Назад"),
    onPressed: () {
      lives = 3;
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = lives > 0
      ? AlertDialog(
          title: Text("Поздравляю!"),
          content: Text("Ты прошел уровень"),
          actions: [
            compliteButton,
          ],
        )
      : AlertDialog(
          title: Text("Ты проиграл!"),
          content: Text("Попробуешь еще раз?"),
          actions: [
            okButton,
            cancelButton,
          ],
        );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
