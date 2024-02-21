import 'dart:async';
import 'dart:math';

import 'package:drum_test/games/easy_level.dart';
import 'package:drum_test/games/hard_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:soundpool/soundpool.dart';
import 'package:wakelock/wakelock.dart';

class PlayerGameWidget extends StatefulWidget {
  const PlayerGameWidget(
      {super.key,
      required this.gameBpm,
      required this.levelListNotes,
      required this.prefs,
      required this.level,
      required this.diff});

  final double gameBpm;
  final List levelListNotes;
  final prefs;
  final level;
  final diff;

  @override
  State<PlayerGameWidget> createState() => _PlayerGameWidgetState();
}

class _PlayerGameWidgetState extends State<PlayerGameWidget> {
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);
  Soundpool pool2 = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);
  int soundId = 0;
  int soundId2 = 0;
  bool dead = false;
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

  double bpm = 80;

  int lives = 3;

  int rate = (60000 / 80).round();
  int incTic = 0;
  int level = 0;

  int difficulty = 1; //1-3 Частота смены нот

  int bam = 0;
  int lastBam = 0;

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
    Image.asset('assets/notes/white/nota0w.png'),
    Image.asset('assets/notes/white/nota1w.png'),
    Image.asset('assets/notes/white/nota2w.png'),
    Image.asset('assets/notes/white/nota3w.png'),
    Image.asset('assets/notes/white/nota4w.png'),
  ];

  List noteCanList = [0, 1, 2, 3, 4];
  List noteActive = [true, true, true, true, true];

  int random = Random().nextInt(5);

  List levelsList = [0, 0, 0, 0];
  void _playTic(levelListNotes, gameBpm, diff) async {
    if (playing == true) {
      lastBam = bam;

      if (incTic > 0) {
        if (lastBam == levelsList[incTic - 1]) {
          setState(() {
            winColor = Colors.green;
          });
        } else {
          setState(() {
            winColor = Colors.red;
            if (lives > 0) {
              lives--;
              if (lives == 0) {
                playing = false;
                dead = true;
                showAlertDialog(context, lives, widget.diff);
                incTic = -1;
                lives = 3;
                playAgain();
              }
            } else {
              //plaingNow(gameBpm);
              playing = false;
              dead = true;
              showAlertDialog(context, lives, widget.diff);
              incTic = -1;
              lives = 3;
              playAgain();
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
          plaingNow(gameBpm);
          playing = false;
          dead = true;
          print(
              'выиграл'); /////////////////////////////////////////////////////////////////////////////////////////////////////////////
          var sharedList = widget.prefs.getStringList(widget.diff);
          if (int.parse(sharedList[widget.level - 1]) < lives)
            sharedList[widget.level - 1] = lives.toString();
          await widget.prefs.setStringList(widget.diff, sharedList);
          setState(() {});
          showAlertDialog(context, lives, diff);

          lives = 3;
        }
      }

      switch (incTic) {
        case 1:
          if (level > 0 && level < levelListNotes.length - 1) {
            levelsList[2] = levelListNotes[level][2];
          }

          break;
        case 2:
          if (level > 0 && level < levelListNotes.length - 1) {
            levelsList[3] = levelListNotes[level][3];
          }
          break;
        case 3:
          if (level > 0 && level < levelListNotes.length - 1) {
            levelsList[0] = levelListNotes[level][0];
          }
          break;
        case 4:
          if (level > 0 && level < levelListNotes.length - 1) {
            levelsList[1] = levelListNotes[level][1];
          }
          break;
        default:
      }
      setState(() {});

      if (incTic == 1) {
        pool.play(soundId);
      } else {
        pool2.play(soundId2);
      }

      colors.fillRange(0, 4, Colors.grey);
      if (!dead) colors[incTic - 1] = Color.fromARGB(255, 123, 125, 255);

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
      timer = Timer.periodic(
          Duration(milliseconds: rate),
          (Timer t) =>
              _playTic(widget.levelListNotes, widget.gameBpm, widget.diff));
      playing = true;
      setState(() {});
    } else {
      Wakelock.disable();

      levelsList = [0, 0, 0, 0];

      timer?.cancel();
      playing = false;
      incTic = 0;
      colors.fillRange(0, 4, Colors.grey);
      colors[0] = Color.fromARGB(255, 123, 125, 255);
      level = 0;
      dead = false;
      setState(() {});
    }
  }

  playAgain() {
    levelsList = [0, 0, 0, 0];

    timer?.cancel();
    playing = false;
    incTic = 0;
    colors.fillRange(0, 4, Colors.grey);
    colors[0] = Color.fromARGB(255, 123, 125, 255);
    level = 0;
    dead = false;
    setState(() {});
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
      backgroundColor: Colors.transparent,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedContainer(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                    duration: Duration(milliseconds: 0),
                    width: MediaQuery.of(context).size.width / 4.5,
                    height: double.infinity / 2,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[0], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[levelsList[0]],
                  ),
                  AnimatedContainer(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                    duration: Duration(milliseconds: 0),
                    width: MediaQuery.of(context).size.width / 4.5,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[1], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[levelsList[1]],
                  ),
                  AnimatedContainer(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                    duration: Duration(milliseconds: 0),
                    width: MediaQuery.of(context).size.width / 4.5,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors[2], width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: notesList[levelsList[2]],
                  ),
                  AnimatedContainer(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                    duration: Duration(milliseconds: 0),
                    width: MediaQuery.of(context).size.width / 4.5,
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
            // Text('lives ' + lives.toString()),
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

showAlertDialog(BuildContext context, lives, diff) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("Еще раз"),
    onPressed: () {
      lives = 3;

      Navigator.pop(context);
    },
  );
  Widget compliteButton = TextButton(
    child: Text("Назад"),
    onPressed: () {
      lives = 3;
      Navigator.pop(context);
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
          title: Text(
            "Поздравляю!",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ты прошел уровень",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lives > 0
                      ? Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 40,
                        )
                      : Icon(
                          Icons.star_border_outlined,
                          color: const Color.fromARGB(255, 187, 187, 187),
                          size: 40,
                        ),
                  lives > 1
                      ? Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 40,
                        )
                      : Icon(
                          Icons.star_border_outlined,
                          color: const Color.fromARGB(255, 187, 187, 187),
                          size: 40,
                        ),
                  lives > 2
                      ? Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 40,
                        )
                      : Icon(
                          Icons.star_border_outlined,
                          color: const Color.fromARGB(255, 187, 187, 187),
                          size: 40,
                        ),
                ],
              ),
            ],
          ),
          actions: [
            compliteButton,
            okButton,
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
