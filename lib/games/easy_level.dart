import 'dart:ui';

import 'package:drum_test/games/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EasyScreen extends StatefulWidget {
  const EasyScreen({super.key});

  @override
  State<EasyScreen> createState() => _EasyScreenState();
}

class _EasyScreenState extends State<EasyScreen> {
  List easyLevels = [
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

    if (prefs.getStringList('easy') == null) {
      prefs.setStringList('easy', List.filled(easyLevels.length, '0'));
    } else if (prefs.getStringList('easy').length != easyLevels.length) {
      await prefs.remove('easy');
      prefs.setStringList('easy', List.filled(easyLevels.length, '0'));
      for (var i = 0; i < easyLevels.length; i++) {
        easyLevels[i]['stars'] = int.parse(prefs.getStringList('easy')[i]);
        if (easyLevels[i]['stars'] > 0) easyLevels[i]['passed'] = true;
      }
    } else {
      for (var i = 0; i < easyLevels.length; i++) {
        easyLevels[i]['stars'] = int.parse(prefs.getStringList('easy')[i]);
        if (easyLevels[i]['stars'] > 0) easyLevels[i]['passed'] = true;
      }
    }

    print(easyLevels);

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
    easyLevels.forEach((element) {
      if (element['passed']) passed++;
    });

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/rhythm-back3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(51, 5, 5, 5),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Начальный уровень',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          width: 100,
          child: ElevatedButton(
              onPressed: () async {
                await prefs.remove('easy');
                sharedInit();
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EasyScreen()));
              },
              child: Text("Сбросить счет")),
        ),
        body: AnimationLimiter(
          child: ListView.builder(
            itemCount: easyLevels.length,
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
                              color: Color.fromARGB(255, 71, 71, 71),
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
                                            bpm: easyLevels[index]['bpm']
                                                .toDouble(),
                                            levelListNotes: easyLevels[index]
                                                ['levelListNotes'],
                                            prefs: prefs,
                                            diff: 'easy',
                                          )));
                            },
                            child: Container(
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color(0xFFCA584C),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'bpm: ${easyLevels[index]['bpm']}',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 254, 255, 185)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        level.toString(),
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          easyLevels[index]['stars'] > 0
                                              ? Icon(
                                                  Icons.star,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                )
                                              : Icon(
                                                  Icons.star_border_outlined,
                                                  color: Colors.white,
                                                ),
                                          easyLevels[index]['stars'] > 1
                                              ? Icon(
                                                  Icons.star,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                )
                                              : Icon(
                                                  Icons.star_border_outlined,
                                                  color: Colors.white,
                                                ),
                                          easyLevels[index]['stars'] > 2
                                              ? Icon(
                                                  Icons.star,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                )
                                              : Icon(
                                                  Icons.star_border_outlined,
                                                  color: Colors.white,
                                                ),
                                        ],
                                      )
                                    ],
                                  ),
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
