import 'package:drum_test/games/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HardScreen extends StatefulWidget {
  const HardScreen({super.key});

  @override
  State<HardScreen> createState() => _HardScreenState();
}

class _HardScreenState extends State<HardScreen> {
  List hardLevels = [
    {
      'passed': false,
      'stars': 0,
      'bpm': 80,
      'levelListNotes': [
        [0, 0, 0, 0],
        [0, 0, 1, 0],
        [1, 0, 1, 0],
        [0, 0, 1, 1],
        [0, 1, 1, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 80,
      'levelListNotes': [
        [0, 0, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 1, 1],
        [0, 1, 1, 1],
        [1, 1, 1, 1],
        [0, 1, 1, 0],
        [0, 0, 0, 0],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 80,
      'levelListNotes': [
        [0, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 2, 0],
        [1, 0, 2, 0],
        [1, 1, 2, 0],
        [1, 1, 2, 1],
        [0, 0, 0, 0],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 80,
      'levelListNotes': [
        [0, 0, 0, 0],
        [0, 1, 0, 2],
        [0, 1, 0, 2],
        [1, 0, 2, 0],
        [2, 0, 1, 0],
        [2, 1, 1, 1],
        [0, 0, 0, 0],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 90,
      'levelListNotes': [
        [0, 0, 0, 0],
        [0, 0, 1, 0],
        [2, 0, 1, 0],
        [2, 0, 1, 1],
        [2, 0, 1, 1],
        [2, 2, 1, 1],
        [0, 0, 0, 0],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 100,
      'levelListNotes': [
        [0, 0, 0, 0],
        [0, 1, 1, 1],
        [0, 1, 1, 1],
        [0, 1, 2, 1],
        [0, 1, 2, 2],
        [2, 2, 2, 2],
        [0, 0, 0, 0],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 80,
      'levelListNotes': [
        [0, 0, 0, 0],
        [0, 0, 2, 0],
        [1, 0, 2, 0],
        [1, 0, 3, 0],
        [1, 0, 3, 1],
        [0, 1, 1, 1],
        [0, 0, 0, 0],
      ]
    },
  ];

  var prefs;
  sharedInit() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('hard') == null) {
      prefs.setStringList('hard', List.filled(hardLevels.length, '0'));
    } else if (prefs.getStringList('hard').length != hardLevels.length) {
      await prefs.remove('hard');
      prefs.setStringList('hard', List.filled(hardLevels.length, '0'));
      for (var i = 0; i < hardLevels.length; i++) {
        hardLevels[i]['stars'] = int.parse(prefs.getStringList('hard')[i]);
        if (hardLevels[i]['stars'] > 0) hardLevels[i]['passed'] = true;
      }
    } else {
      for (var i = 0; i < hardLevels.length; i++) {
        hardLevels[i]['stars'] = int.parse(prefs.getStringList('hard')[i]);
        if (hardLevels[i]['stars'] > 0) hardLevels[i]['passed'] = true;
      }
    }

    print(hardLevels);

    //hardLevels[0]['stars'] = prefs.getStringList('hard')[0] ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    sharedInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int passed = 0;
    hardLevels.forEach((element) {
      if (element['passed']) passed++;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text('Продвинутый уровень'),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        TextButton(
            onPressed: () async {
              await prefs.remove('hard');
              sharedInit();
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HardScreen()));
            },
            child: Text("Сбросить счет"))
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: hardLevels.length,
            itemBuilder: (BuildContext ctx, index) {
              int level = index + 1;
              return index > passed
                  ? AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 1500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Container(
                            height: 100,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.lock_outline_sharp,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 700),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GameScreen(
                                            level: level,
                                            bpm: hardLevels[index]['bpm']
                                                .toDouble(),
                                            levelListNotes: hardLevels[index]
                                                ['levelListNotes'],
                                            prefs: prefs,
                                            diff: 'hard',
                                          )));
                            },
                            child: Container(
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    level.toString(),
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 25, 7, 190),
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      hardLevels[index]['stars'] > 0
                                          ? Icon(
                                              Icons.star,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.white,
                                            ),
                                      hardLevels[index]['stars'] > 1
                                          ? Icon(
                                              Icons.star,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.white,
                                            ),
                                      hardLevels[index]['stars'] > 2
                                          ? Icon(
                                              Icons.star,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.white,
                                            ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
