import 'package:drum_test/games/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HardScreen extends StatefulWidget {
  const HardScreen({super.key});

  @override
  State<HardScreen> createState() => _HardScreenState();
}

class _HardScreenState extends State<HardScreen> {
  List hardLevels = [
    {
      'passed': true,
      'stars': 1,
      'bpm': 80,
      'levelListNotes': [
        [0, 0, 0, 0],
        [1, 1, 2, 1],
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [1, 1, 1, 1],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 80,
      'levelListNotes': [
        [2, 0, 1, 0],
        [1, 0, 1, 0],
        [1, 0, 1, 0],
        [1, 0, 1, 0],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 80,
      'levelListNotes': [
        [3, 0, 1, 0],
        [1, 0, 1, 0],
        [1, 0, 1, 0],
        [1, 0, 1, 0],
      ]
    },
    {
      'passed': false,
      'stars': 0,
      'bpm': 80,
      'levelListNotes': [
        [4, 0, 1, 0],
        [1, 0, 1, 0],
        [1, 0, 1, 0],
        [1, 0, 1, 0],
      ]
    },
  ];

  var prefs;
  sharedInit() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('hard') == null) {
      prefs.setStringList('hard', List.filled(hardLevels.length, '0'));
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
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          itemCount: hardLevels.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (BuildContext ctx, index) {
            int level = index + 1;
            return index > passed
                ? Container(
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
                  )
                : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameScreen(
                                    level: level,
                                    bpm: hardLevels[index]['bpm'].toDouble(),
                                    levelListNotes: hardLevels[index]
                                        ['levelListNotes'],
                                    prefs: prefs,
                                    diff: 'hard',
                                  )));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  );
          },
        ),
      ),
    );
  }
}
