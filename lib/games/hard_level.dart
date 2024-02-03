import 'package:drum_test/games/game_screen.dart';
import 'package:flutter/material.dart';

class HardScreen extends StatelessWidget {
  const HardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List hardLevels = [
      {
        'passed': true,
        'stars': 2,
        'bpm': 180,
        'levelListNotes': [
          [1, 0, 1, 0],
          [1, 1, 1, 1],
          [1, 0, 1, 0],
          [1, 0, 1, 0],
        ]
      },
      {
        'passed': false,
        'stars': 0,
        'bpm': 80,
        'levelListNotes': [
          [1, 0, 1, 0],
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
          [1, 0, 1, 0],
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
          [1, 0, 1, 0],
          [1, 0, 1, 0],
          [1, 0, 1, 0],
          [1, 0, 1, 0],
        ]
      },
    ];
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
