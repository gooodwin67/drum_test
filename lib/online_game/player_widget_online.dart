// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class PlayerWidgetOnline extends StatefulWidget {
  const PlayerWidgetOnline(
    this.saveNewRec, {
    required this.listUsers,
    required this.name,
    required this.id,
  });

  final List listUsers;
  final String name;
  final String id;
  final Function saveNewRec;

  @override
  State<PlayerWidgetOnline> createState() => _PlayerWidgetOnlineState();
}

class _PlayerWidgetOnlineState extends State<PlayerWidgetOnline> {
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);
  Soundpool pool2 = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);
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
  }

  bool playing = false;

  int myRec = 0;

  double bpm = 80;

  int rate = (60000 / 80).round();
  int incTic = 0;
  int level = 0;

  int difficulty = 2; //1-3 Частота смены нот

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
  void _playTic() {
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
            saveScore();
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

  void loadRec() async {
    var prefs = await SharedPreferences.getInstance();

    if (bpm.toInt() == 80) {
      int rec80 = prefs.getInt('80') ?? 0;
      myRec = rec80;
    } else if (bpm.toInt() == 100) {
      int rec100 = prefs.getInt('100') ?? 0;
      myRec = rec100;
    } else if (bpm.toInt() == 120) {
      int rec120 = prefs.getInt('120') ?? 0;
      myRec = rec120;
    }
    setState(() {});
  }

  void saveScore() async {
    int score = level;
    int saveBpm = bpm.toInt();
    bool newRec = false;
    plaingNow();
    /////////////////////////////
    var prefs = await SharedPreferences.getInstance();
    int rec80 = prefs.getInt('80') ?? 0;
    int rec100 = prefs.getInt('100') ?? 0;
    int rec120 = prefs.getInt('120') ?? 0;

    if (saveBpm == 80 && score > rec80) {
      prefs.setInt('80', score);
      newRec = true;
      widget.saveNewRec(score, 80);
    } else if (saveBpm == 100 && score > rec100) {
      prefs.setInt('100', score);
      newRec = true;
      widget.saveNewRec(score, 100);
    } else if (saveBpm == 120 && score > rec120) {
      prefs.setInt('120', score);
      newRec = true;
      widget.saveNewRec(score, 120);
    }

    showAlertDialog(context, score, newRec);
    loadRec();
  }

  void plaingNow() {
    if (!playing) {
      Wakelock.enable();
      noteCanList = [];
      for (int i = 0; i < noteActive.length; i++) {
        if (noteActive[i]) {
          noteCanList.add(i);
        }
      }

      rate = (60000 / bpm).round();
      timer =
          Timer.periodic(Duration(milliseconds: rate), (Timer t) => _playTic());
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
      setState(() {});
    }
  }

  @override
  void initState() {
    loadSound();
    loadRec();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
          title: Text('РИТМ Челлендж Online'),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    overlayShape: SliderComponentShape.noThumb,
                                    showValueIndicator:
                                        ShowValueIndicator.always,
                                  ),
                                  child: Slider(
                                    min: 80,
                                    max: 120,
                                    divisions: 2,
                                    value: bpm,
                                    label: bpm.round().toString(),
                                    onChanged: (double value) {
                                      loadRec();
                                      setState(() {
                                        bpm = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ]))
                    : SizedBox(),
              ),
              SizedBox(height: 5),
              Container(
                height: 70,
                key: Key('hideMenu'),
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Color.fromARGB(57, 255, 255, 255),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Счет: ${level.toString()}',
                      style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 58, 58, 58)),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Мой рекорд: ${myRec}',
                      style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 58, 58, 58)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height / 5,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AnimatedContainer(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 5),
                      duration: Duration(milliseconds: 0),
                      width: MediaQuery.of(context).size.width / 4.7,
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
                      width: MediaQuery.of(context).size.width / 4.7,
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
                      width: MediaQuery.of(context).size.width / 4.7,
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
                      width: MediaQuery.of(context).size.width / 4.7,
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
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.all(10),
              //   margin: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: Color.fromARGB(255, 250, 255, 219),
              //   ),
              //   child: Text('Счет ' + level.toString()),
              // ),
              // Text('lastBam ' + lastBam.toString()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          enableFeedback: false,
          onPressed: () {
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
        ), ////
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

showAlertDialog(BuildContext context, score, newRec) {
  Widget okButton = TextButton(
    child: Text(
      "Еще раз",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget backButton = TextButton(
    child: Text(
      "Назад",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    ),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Твой счет",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          score.toString(),
          style: TextStyle(fontSize: 50),
        ),
        SizedBox(height: 20),
        !newRec
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Ты побил свой рекорд!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ],
    ),
    actions: [
      okButton,
      backButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
